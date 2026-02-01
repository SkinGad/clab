/interface bridge
add name=bridge1

/ip pool
add name=dhcp_pool0 ranges=192.168.99.2-192.168.99.10
/ip dhcp-server
add address-pool=dhcp_pool0 interface=bridge1 name=dhcp1

/interface ipip
add local-address=2.2.2.1 name=ipip-tunnel1 remote-address=5.5.5.1
/interface list
add name=WAN
/interface bridge port
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
/interface list member
add interface=ether2 list=WAN
add interface=ipip-tunnel1 list=WAN
/ip address
add address=2.2.2.1/30 interface=ether2
add address=192.168.99.1/24 interface=ether3 network=192.168.99.0
add address=192.168.130.2/30 interface=ipip-tunnel1 network=192.168.130.0
/ip dhcp-server network
add address=192.168.99.0/24 dns-server=8.8.8.8 gateway=192.168.99.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN
/ip route
add dst-address=0.0.0.0/0 gateway=2.2.2.2


/routing rip instance
add name=rip-instance-1
add name=rip-instance-2 redistribute=rip
/routing rip interface-template
add instance=rip-instance-1 interfaces=ipip-tunnel1
add instance=rip-instance-2 interfaces=bridge1
