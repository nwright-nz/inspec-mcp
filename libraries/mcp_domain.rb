class McpDomain < Inspec.resource(1)
  name 'mcp_domain'
  desc 'Verifies MCP Network Domain'
  example "
    describe mcp_domain(name: 'Test Domain') do
      it { should exist }
    end
  "
  supports platform: 'mcp'

  def initialize(opts = {})
    super()
    @name = opts[:name]
  end

  def exists?
    !domain.nil?
  end

  def type
    domain['type'].downcase ||
      domain['type'].upcase ||
      domain['type'].camelcase
  end

  def description
    domain['description']
  end

  def datacenter
    domain['datacenterId']
  end

  def to_s
    "MCP Network Domain:  #{@name}"
  end

  def domain
    return @domains if defined?(@domains)
    return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'
    domains = JSON.parse(inspec.backend.mcp_client.network.list_domains(name: @name))
    @domains = domains['networkDomain'][0]
  end
end
