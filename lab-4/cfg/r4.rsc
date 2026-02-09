/ip address
add address=1.1.3.2/30 interface=ether2
add address=1.1.4.1/30 interface=ether3
add address=1.2.1.2/30 interface=ether4

add address=1.10.4.2/30 interface=ether5

/routing ospf
instance add name=ospf-instance-1 out-filter-chain=ospf router-id=0.0.0.4
area add instance=ospf-instance-1 name=ospf-area-1
interface-template add area=ospf-area-1

/routing filter rule
add chain=ospf disabled=no rule="if (dst == 1.10.0.0/16 && dst-len in 16-32 && \
    not protocol connected,ospf) { accept; }"
