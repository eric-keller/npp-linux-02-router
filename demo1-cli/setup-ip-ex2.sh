#!/bin/bash

lan1="docker exec -it  clab-mod2-play-lan1"
lan2="docker exec -it  clab-mod2-play-lan2"
lan3="docker exec -it  clab-mod2-play-lan3"
rtr="docker exec -it  clab-mod2-play-rtr"


# Ping from lan1 to lan3 will work 
# because the lan* routing table entries are now saying to go via the router
#lan1 ping 10.0.3.2

create_setup () {

echo 'creating setup'

$lan1 ip addr add 10.0.1.2 dev eth1
# say router is directly connected
$lan1 ip route add 10.0.1.1/32 dev eth1
# then everything else has to go via that router
$lan1 ip route add 10.0.0.0/16 dev eth1 via 10.0.1.1

$lan2 ip addr add 10.0.2.2 dev eth1
$lan2 ip route add 10.0.2.1/32 dev eth1
$lan2 ip route add 10.0.0.0/16 dev eth1 via 10.0.2.1 
 
$lan3 ip addr add 10.0.3.2 dev eth1
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
#$lan1 ip route del 10.0.0.0/16 dev eth1

$lan2 ip addr del 10.0.2.2/32 dev eth1
#$lan2 ip route del 10.0.0.0/16 dev eth1

$lan3 ip addr del 10.0.3.2/32 dev eth1
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
