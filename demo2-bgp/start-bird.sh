#!/bin/bash

# note: no -it

lan1="docker exec  clab-mod2-bgp-lan1"
lan2="docker exec  clab-mod2-bgp-lan2"
rtrA="docker exec  clab-mod2-bgp-rtrA"
rtrB="docker exec  clab-mod2-bgp-rtrB"
rtrC="docker exec  clab-mod2-bgp-rtrC"
rtrD="docker exec  clab-mod2-bgp-rtrD"


$rtrA bird -c /etc/bird-alt/rtrA-bird.conf
$rtrB bird -c /etc/bird-alt/rtrB-bird.conf
$rtrC bird -c /etc/bird-alt/rtrC-bird.conf
$rtrD bird -c /etc/bird-alt/rtrD-bird.conf

