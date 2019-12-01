class McpServer < Inspec.resource(1)
  name 'mcp_server'
  desc 'Verifies MCP Server'
  example "
    describe mcp_server(name: 'server001') do
      it { should exist }
    end
  "
  supports platform: 'mcp'

  def initialize(opts = {})
    super()
    @name = opts[:name]
  end

  def name
    server[:name] unless server.nil?
  end

  def running?
    server['started']
  end

  def exists?
    !server.empty?
  end

  def memory
    server['memoryGb']
  end

  def cpus
    server['cpu']['count']
  end

  def vmtools
    server['guest']['vmTools']['versionStatus'].downcase
  end

  def os
    server['guest']['operatingSystem']['id']
  end

  def vlan_name
    server['networkInfo']['primaryNic']['vlanName']
  end

  def datacenter
    server['datacenterId']
  end

  def to_s
    "MCP Server: #{@name}"
  end

  def server
    return @servers if defined?(@servers)
    # for inspec check inspec.backend.mcp_client will be nil
    return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'
    servers = JSON.parse(inspec.backend.mcp_client.server.list(name: @name))
    if servers.count > 0
      @servers = servers['server'][0]
    else
      @servers = nil
    end
    @servers
  end
end
