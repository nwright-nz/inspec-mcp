class McpPortList < Inspec.resource(1)
    name 'mcp_portlist'
    desc 'Verifies MCP port lists'
    example "
      describe mcp_portlist(domainId: '1234-44-4566') do
        it { should exist }
      end
    "
    # supports platform: 'mcp/0.12'
  
    def initialize(opts = {})
      super()
      @filters = opts
    end
    
    def exists?
      !portlist.empty?
    end

    def ports
        cleanports = []
        portlist['port'].each { | port | 
        cleanports.push(port['begin'])
        }
        cleanports
    end

    def to_s
        "MCP PortList: #{@filters[:name]}"
      end

    def portlist 
        return @portlists if defined?(@portlists)
        # for inspec check inspec.backend.mcp_client will be nil
        return nil if inspec.backend.class.to_s == 'Train::Transports::Mock::Connection'
        puts @filters
        portlists = JSON.parse(inspec.backend.mcp_client.network.list_port_lists(@filters))
        puts portlists
        if portlists.count > 0
          puts portlists.count
          @portlists = portlists['portList'][0]
        else
          @portlists = nil
        end
        @portlists
      end
    end