class McpVlan < Inspec.resource(1)
  name 'mcp_vlan'
  desc 'Verifies MCP VLAN Resources'
  example "
    describe mcp_vlan(name: 'tools_prod') do
      it { should exist }
    end
  "
  supports platform: 'mcp'
  def initialize(opts = {})
    super()
    @name = opts[:name]
  end

  def exists?
    !vlan.empty?
  end

  def description
    vlan['description']
  end

  def ipv4address
    vlan['privateIpv4Range']['address']
  end

  def ipv4prefix
    vlan['privateIpv4Range']['prefixSize']
  end

  def ipv4gatewayadd
    vlan['ipv4GatewayAddress']
  end

  def gatewayaddressing
    vlan['gatewayAddressing'].downcase ||
      vlan['gatewayAddressing'].upcase ||
      vlan['gatewayAddressing'].camelcase
  end

  def state
    vlan['state'].downcase ||
      vlan['state'].upcase ||
      vlan['state'].camelcase
  end

  def datacenter
    vlan['datacenterId']
  end

  def to_s
    "MCP VLAN:  #{@name}"
  end

  def vlan
    return @vlans if defined?(@vlans)
    return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'
    vlans = JSON.parse(inspec.backend.mcp_client.network.listvlans(name: @name))
    @vlans = vlans['vlan'][0]
  end
end
