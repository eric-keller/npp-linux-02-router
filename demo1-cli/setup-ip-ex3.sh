#!/bin/bash

lan1="docker exec -it  clab-mod2-play-lan1"
lan2="docker exec -it  clab-mod2-play-lan2"
lan3="docker exec -it  clab-mod2-play-lan3"
rtr="docker exec -it  clab-mod2-play-rtr"

# This is showing interfaces with multiple IP addresses assigned to it.

# This will default to using the whatever IP address was first defined (10.0.1.2) as source
#lan1 ping 10.0.3.3

# This will use a specific source IP address
#lan1 ping -I 10.0.1.3 10.0.3.3

# To see ip neigh

# rtr tshark -i eth1
# before ping:
#lan1 ip neigh
  # empty
# do ping  (see first packets are ARP)
#   10.0.1.1 dev eth1 lladdr aa:c1:ab:4e:9b:e5 REACHABLE
# after a while
#   10.0.1.1 dev eth1 lladdr aa:c1:ab:4e:9b:e5 STALE

# Can explicitly flush: (which you'll see ARP again)
# lan1 ip neigh flush all

create_setup () {

echo 'creating setup'

$lan1 ip addr add 10.0.1.2 dev eth1
$lan1 ip addr add 10.0.1.3 dev eth1
$lan1 ip route add 10.0.1.1/32 dev eth1
$lan1 ip route add 10.0.0.0/16 dev eth1 via 10.0.1.1

$lan2 ip addr add 10.0.2.2 dev eth1
$lan2 ip addr add 10.0.2.3 dev eth1
$lan2 ip route add 10.0.2.1/32 dev eth1
$lan2 ip route add 10.0.0.0/16 dev eth1 via 10.0.2.1 
 
$lan3 ip addr add 10.0.3.2 dev eth1
$lan3 ip addr add 10.0.3.3 dev eth1
$lan3 ip route add 10.0.3.1/32 dev eth1
$lan3 ip route add 10.0.0.0/16 dev eth1 via 10.0.3.1


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

$lan2 ip addr del 10.0.2.2/32 dev eth1
$lan2 ip addr del 10.0.2.3/32 dev eth1
#$lan2 ip route del 10.0.0.0/16 dev eth1

$lan3 ip addr del 10.0.3.2/32 dev eth1
$lan3 ip addr del 10.0.3.3/32 dev eth1
#$lan3 ip route del 10.0.0.0/16 dev eth1


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
