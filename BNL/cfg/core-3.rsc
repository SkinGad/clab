/interface bridge
add name=bridge1 vlan-filtering=yes
/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=ether5
add bridge=bridge1 interface=ether6
add bridge=bridge1 interface=ether7
add bridge=bridge1 interface=ether8
/interface vlan
add interface=bridge1 name=vlan4 vlan-id=4
add interface=bridge1 name=vlan5 vlan-id=5
add interface=bridge1 name=vlan10 vlan-id=10
add interface=bridge1 name=vlan20 vlan-id=20
add interface=bridge1 name=vlan30 vlan-id=30
/ip address
add address=10.4.0.6/24 interface=vlan4
/ip route
add disabled=no dst-address=0.0.0.0/0 gateway=10.4.0.1 routing-table=main

/interface bridge vlan
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3,ether4,ether5,ether6,ether7,ether8 vlan-ids=4
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3,ether4,ether5,ether6,ether7,ether8 vlan-ids=5
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3,ether4,ether5,ether6,ether7,ether8 vlan-ids=10
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3,ether4,ether5,ether6,ether7,ether8 vlan-ids=20
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3,ether4,ether5,ether6,ether7,ether8 vlan-ids=30

/routing ospf
instance add name=ospf-instance-1 out-filter-chain=ospf router-id=0.0.1.3
area add instance=ospf-instance-1 name=ospf-area-1
interface-template add area=ospf-area-1 interfaces=vlan4

/routing filter rule
add chain=ospf disabled=no rule="if (dst in 10.0.0.0/8) { accept; }"
add chain=ospf disabled=no rule="if (dst == 0.0.0.0/0) { accept; }"
