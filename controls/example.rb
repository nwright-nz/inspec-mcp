# copyright: 2018, The Authors

title "MCP Example Checks"

describe mcp_server(name: 'habitat-test') do
  it { should exist }
  it { should be_running }
  its('memory') { should eq 8 }
  its('cpus') { should eq 4 }
  its('vmtools') { should cmp 'current' }
  its('os') { should cmp 'WIN2019DC64' }
  its('vlan_name') {should eq 'Tools_Prod' }
  its('datacenter') { should eq 'AU11' }
end

describe mcp_vlan(name: 'Tools_Prod') do
  it { should exist }
  its('description') { should eq 'testing' }
  its('gatewayaddressing') { should cmp 'LOW' }
  its('state') { should eq 'normal' }
  its('datacenter') { should eq 'AU11' }
  its('ipv4address') { should eq '10.10.10.0'}
  its('ipv4prefix') { should cmp '24' }
end

describe mcp_domain(name: 'Tools') do 
  it { should exist }
  its('type') { should cmp 'Advanced' }
  its('datacenter') { should eq 'AU11' }
end

# describe mcp_servers(operatingSystemFamily: "WINDOWS") do
#   its('count') { should eq 4 }
# end

# describe mcp_servers(datacenterId: "AU11") do
#   its('count') { should eq 4 }
# end

# describe mcp_servers(started: false) do
#   its('count') { should eq 4 }
# end

# describe mcp_servers(networkDomainId: '7625caa0-165b-4ea2-81bd-4337646de9b0') do
#   its('count') { should eq 4 }
# end

control 'mcp-migrated-vms' do
  impact 'high'
  title 'Check that no extra VMs are created in the migrated network domain' 
  desc 'Check that no extra VMs are created in the migrated network domain'
  describe mcp_servers(networkDomainId: 'b414ce10-0f43-4808-90a4-2abc822ff443') do
    its('count') { should eq 14 }
  end
end

describe mcp_firewallrule(networkDomainId: '809a4317-973b-4f5e-9179-b49b6ff5ec4c') do
  it { should exist }
end

control 'mcp-check-common-ports' do
  impact 'high'
  title 'Check that only permitted ports are in the Common_Ports port list'
  describe mcp_portlist(networkDomainId: '809a4317-973b-4f5e-9179-b49b6ff5ec4c', name: 'Common_Ports') do
    it { should exist }
    its('ports') { should be_in [80, 443, 22, 8080]}
  end
end
