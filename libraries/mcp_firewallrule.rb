class McpFirewallRule < Inspec.resource(1)
    name 'mcp_firewallrule'
    desc 'Verifies MCP firewall rules'
    example "
      describe mcp_firewallrule(domainId: '1234-44-4566') do
        it { should exist }
      end
    "
    # supports platform: 'mcp/0.12'
  
    def initialize(opts = {})
      super()
      @networkDomainId = opts[:networkDomainId]
    end
    
    def exists?
      !firewall.empty?
    end

    def firewall 
      return @rules if defined?(@rules)
      # for inspec check inspec.backend.mcp_client will be nil
      return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'
      rules = JSON.parse(inspec.backend.mcp_client.network.list_fw_rules(networkDomainId: @networkDomainId))
      # puts rules
      if rules.count > 0
        @rules = rules['firewallRule'][0]
      else
        @rules = nil
      end
      @rules
    end
      # def allow_in?(criteria = {})
      #   allow(inbound_rules, criteria.dup)
      # end

      # def allow(rules, criteria)
      #   criteria = allow__check_criteria(criteria)
      #   rules = allow__focus_on_position(rules, criteria)
    
      #   rules.any? do |rule|
      #     matched = true
      #     matched &&= allow__match_port(rule, criteria)
      #     matched &&= allow__match_protocol(rule, criteria)
      #     matched &&= allow__match_ipv4_range(rule, criteria)
      #     matched &&= allow__match_ipv6_range(rule, criteria)
      #     matched &&= allow__match_security_group(rule, criteria)
      #     matched
      #   end
      # end

      # def allow__check_criteria(raw_criteria)
      #   allowed_criteria = [
      #     :from_port,
      #     :ipv4_range,
      #     :ipv6_range,
      #     :security_group,
      #     :port,
      #     :position,
      #     :protocol,
      #     :to_port,
      #     :exact, # Internal
      #   ]
      #   recognized_criteria = {}
      #   allowed_criteria.each do |expected_criterion|
      #     if raw_criteria.key?(expected_criterion)
      #       recognized_criteria[expected_criterion] = raw_criteria.delete(expected_criterion)
      #     end
      #   end
    
      #   # Any leftovers are unwelcome
      #   unless raw_criteria.empty?
      #     raise ArgumentError, "Unrecognized security group rule 'allow' criteria '#{raw_criteria.keys.join(',')}'. Expected criteria: #{allowed_criteria.join(', ')}"
      #   end
    
      #   recognized_criteria


end
    