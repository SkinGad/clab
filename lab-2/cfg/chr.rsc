/ip address
add address=5.5.5.1/30 interface=ether2


/interface ipip
add local-address=5.5.5.1 name=ipip-tunnel1 remote-address=2.2.2.1
/ip address
add address=192.168.130.1/30 interface=ipip-tunnel1 network=192.168.130.0
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether2

/ip route
add dst-address=0.0.0.0/0 gateway=5.5.5.2

/routing table
add disabled=no fib name=ban
/routing rip instance
add disabled=no name=rip-instance-1 out-filter-chain=rip-filter redistribute=\
    connected,static routing-table=ban
/ip route
add dst-address=4.4.4.1/32 gateway=5.5.5.2 \
    routing-table=ban
/routing filter rule
add chain=rip-filter rule="if (dst == 0.0.0.0/0) {reject;}"
add chain=rip-filter disabled=no rule="accept;"
/routing rip interface-template
add disabled=no instance=rip-instance-1 interfaces=ipip-tunnel1
