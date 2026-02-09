/interface bridge
add name=bridge1 vlan-filtering=yes
/interface bridge port
add bridge=bridge1 interface=ether2
add bridge=bridge1 interface=ether3
add bridge=bridge1 interface=ether4 pvid=30
add bridge=bridge1 interface=ether5 pvid=30
/interface vlan
add interface=bridge1 name=vlan4 vlan-id=4
add interface=bridge1 name=vlan5 vlan-id=5
add interface=bridge1 name=vlan10 vlan-id=10
add interface=bridge1 name=vlan20 vlan-id=20
add interface=bridge1 name=vlan30 vlan-id=30
/ip address
add address=10.4.0.10/24 interface=vlan4
add address=10.10.30.2/30 interface=vlan30
add address=10.10.31.2/30 interface=vlan30

/interface bridge vlan
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3 vlan-ids=4
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3 vlan-ids=5
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3 vlan-ids=10
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3 vlan-ids=20
add bridge=bridge1 tagged=\
    bridge1,ether2,ether3 vlan-ids=30

/routing ospf
instance add name=ospf-instance-1 out-filter-chain=ospf router-id=0.0.2.3
area add instance=ospf-instance-1 name=ospf-area-1
interface-template add area=ospf-area-1 interfaces=vlan4

/routing filter rule
add chain=ospf disabled=no rule="if (dst in 10.0.0.0/8) { accept; }"
