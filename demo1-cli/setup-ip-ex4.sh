#!/bin/bash

lan1="docker exec -it  clab-mod2-play-lan1"
lan2="docker exec -it  clab-mod2-play-lan2"
lan3="docker exec -it  clab-mod2-play-lan3"
rtr="docker exec -it  clab-mod2-play-rtr"

# Illustrates setting up a GRE tunnel

#lan1 ping 192.168.0.2

# lan1 tshark -O gre -i gre1   (won't have encapsulation)
# lan1 tshark -O gre -i eth1   (will have encapsulation)

# rtr tshark -O gre -i eth1  (see encapsulation as it traverses router)



create_setup () {

echo 'creating setup'

$lan1 ip addr add 10.0.1.2 dev eth1
$lan1 ip addr add 10.0.1.3 dev eth1
$lan1 ip route add 10.0.1.1/32 dev eth1
$lan1 ip route add 10.0.0.0/16 dev eth1 via 10.0.1.1

# create GRE tunnel - with local/remote points 10.0.1.2/10.0.3.2 (this is the outer header)
$lan1 ip tunnel add gre1 mode gre local 10.0.1.2 remote 10.0.3.2 ttl 255
# Then give the device an address in a different prefix (this is the inner header)
# also specify /30 so a routing table entry will be created directing
#   192.16.0.0/30 into dev gre1 (which will encap in 10.0.1.2/10.0.3.2)
#   which to send, 10.0.0.0/16 is in the routing table already
$lan1 ip addr add 192.168.0.1/30 dev gre1
$lan1 ip link set gre1 up


$lan2 ip addr add 10.0.2.2 dev eth1
$lan2 ip addr add 10.0.2.3 dev eth1
$lan2 ip route add 10.0.2.1/32 dev eth1
$lan2 ip route add 10.0.0.0/16 dev eth1 via 10.0.2.1 
 
$lan3 ip addr add 10.0.3.2 dev eth1
$lan3 ip addr add 10.0.3.3 dev eth1
$lan3 ip route add 10.0.3.1/32 dev eth1
$lan3 ip route add 10.0.0.0/16 dev eth1 via 10.0.3.1

$lan3 ip tunnel add gre1 mode gre local 10.0.3.2 remote 10.0.1.2 ttl 255
$lan3 ip addr add 192.168.0.2/30 dev gre1
$lan3 ip link set gre1 up


$rtr ip addr add 10.0.1.1 dev eth1
$rtr ip route add 10.0.1.0/24 dev eth1

$rtr ip addr add 10.0.2.1 dev eth2
$rtr ip route add 10.0.2.0/24 dev eth2

$rtr ip addr add 10.0.3.1 dev eth3
$rtr ip route add 10.0.3.0/24 dev eth3

}

delete_setup() {
echo 'delete setup'

$lan1 ip addr del 10.0.1.2/32 dev eth1
$lan1 ip addr del 10.0.1.3/32 dev eth1
#$lan1 ip route del 10.0.0.0/16 dev eth1
$lan1 ip tunnel del gre1 mode gre local 10.0.1.2 remote 10.0.3.2 ttl 255


$lan2 ip addr del 10.0.2.2/32 dev eth1
$lan2 ip addr del 10.0.2.3/32 dev eth1
#$lan2 ip route del 10.0.0.0/16 dev eth1

$lan3 ip addr del 10.0.3.2/32 dev eth1
$lan3 ip addr del 10.0.3.3/32 dev eth1
#$lan3 ip route del 10.0.0.0/16 dev eth1

$lan3 ip tunnel del gre1 mode gre local 10.0.3.2 remote 10.0.1.2 ttl 255
#$lan3 ip addr del 192.168.0.2/30 dev gre1
#$lan3 ip link set gre1 up


$rtr ip addr del 10.0.1.1/32 dev eth1
#$rtr ip route del 10.0.1.0/24 dev eth1

$rtr ip addr del 10.0.2.1/32 dev eth2
#$rtr ip route del 10.0.2.0/24 dev eth2

$rtr ip addr del 10.0.3.1/32 dev eth3
#$rtr ip route del 10.0.3.0/24 dev eth3



}




#echo "The number of arguments is: $#"
#echo "arg1 = $1"

if [ $# != 1 ]
then
   echo "specify delete or create"
elif [ $1 == "delete" ]
then 
   delete_setup
elif [ $1 == "create" ]
then
   create_setup
else
   echo "specify delete or create"
fi
