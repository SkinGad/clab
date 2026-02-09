/ip firewall connection tracking
set enabled=yes
/interface bridge
add name=bridge1 vlan-filtering=yes
/interface bridge port
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
/interface vlan
add interface=bridge1 name=vlan4 vlan-id=4
add interface=bridge1 name=vlan5 vlan-id=5
add interface=bridge1 name=vlan10 vlan-id=10
add interface=bridge1 name=vlan20 vlan-id=20
add interface=bridge1 name=vlan30 vlan-id=30
/interface vrrp
add interface=ether2 name=vrrp1 preemption-mode=no remote-address=\
    127.1.1.1 sync-connection-tracking=yes
add comment=vlan4 interface=vlan4 name=vrrp2 preemption-mode=no \
    remote-address=10.4.0.2 sync-connection-tracking=yes version=2
/interface list
add name=WAN
add name=LAN
/interface list member
add interface=ether2 list=WAN
add interface=ether3 list=LAN
add interface=ether4 list=LAN
add interface=vrrp1 list=WAN
/ip address
add address=10.4.0.3/24 interface=vlan4
add address=10.4.0.1/24 interface=vrrp2 network=10.4.0.0
add address=1.1.1.1/30 interface=vrrp1 network=1.1.1.0
add address=127.1.1.2/30 interface=ether2

/interface bridge vlan
add bridge=bridge1 tagged=\
    bridge1,ether3,ether4 vlan-ids=4
add bridge=bridge1 tagged=\
    bridge1,ether3,ether4 vlan-ids=5
add bridge=bridge1 tagged=\
    bridge1,ether3,ether4 vlan-ids=10
add bridge=bridge1 tagged=\
    bridge1,ether3,ether4 vlan-ids=20
add bridge=bridge1 tagged=\
    bridge1,ether3,ether4 vlan-ids=30


/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=1.1.1.2 routing-table=main \
    suppress-hw-offload=no

/routing ospf
instance add name=ospf-instance-1 out-filter-chain=ospf router-id=0.0.0.2
area add instance=ospf-instance-1 name=ospf-area-1
interface-template add area=ospf-area-1 interfaces=vlan4

/routing filter rule
add chain=ospf disabled=no rule="if (dst in 10.0.0.0/8) { accept; }"
