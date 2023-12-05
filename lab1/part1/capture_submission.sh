#!/bin/bash

lan1="docker exec -it  clab-mod2-bgp-lan1"
lan2="docker exec -it  clab-mod2-bgp-lan2"
rtrA="docker exec -it  clab-mod2-bgp-rtrA"
rtrB="docker exec -it  clab-mod2-bgp-rtrB"
rtrC="docker exec -it  clab-mod2-bgp-rtrC"
rtrD="docker exec -it  clab-mod2-bgp-rtrD"

filename="submission.out"

part1 () {
$lan1 traceroute -s 1.1.1.1 4.4.4.4 > $filename
echo "---" >> $filename
$rtrB birdc show route all >> $filename
echo "---" >> $filename
$rtrC birdc show route all >> $filename
echo "---" >> $filename
}

part2() {
$lan1 traceroute -s 1.1.1.1 4.4.4.4 >> $filename
}

if [ $# != 1 ]
then
   echo "specify part1 or part2"
elif [ $1 == "part1" ]
then
   part1
elif [ $1 == "part2" ]
then
   part2
else
   echo "specify part1 or part2"
fi

