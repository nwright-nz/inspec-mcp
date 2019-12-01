class McpServers < Inspec.resource(1)
  name 'mcp_servers'
  desc 'Verifies MCP Servers'
  example "
    describe mcp_servers(vlanId: '111222-222-33344') do
      its('count') { should eq 11 }
    end
  "
  supports platform: 'mcp'

  def initialize(opts = {})
    @filter = opts
    puts opts
    super()
  end

  def count
    serverlist['totalCount']
  end

  def serverlist
    return @serverlist if defined?(@serverlist)
    # for inspec check inspec.backend.mcp_client will be nil
    return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'
    serverlist = JSON.parse(inspec.backend.mcp_client.server.list(@filter))
    if serverlist.count > 0
      @serverlist = serverlist
    else
      @serverlist = nil
    end
    @serverlist
  end
end