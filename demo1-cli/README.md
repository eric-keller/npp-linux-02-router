# Introduction

In this demo, we'll be going through some command line configuration in Linux for manipulating the routing table.  

Provided is a containerlab topology configuration file (3lan-mod2.clab.yml) with topology name mod2-play.  It has 3 hosts (named lan1, lan2, and lan3) connected to 1 router (named rtr) (the router is just a Linux host that we will be configuring).  To launch the containers, run the following.

```
sudo containerlab deploy
```

Note: when you are done and want to teardown the lab setup, run `sudo containerlab destroy`

There are 3 example scripts provided, that each illustrate one thing.  Each script provides a `create` function and a `delete` function, which allows you to run a script to create a setup, then delete that setup, then do that again with another script.

```
./setup-ip-ex1.sh create
./setup-ip-ex1.sh delete
```

Note, each script makes use of a bash variable for the docker command.

```
lan1="docker exec -it  clab-mod2-play-lan1"
```

Which then allows you to use `$lan <command>` to execute something in the clab-mod2-play-lan1 container.

```
$lan1 ip addr add 10.0.1.2 dev eth1
````

# Example 1: setup-ip-ex1.sh 

Illustrates what happens when not using via 

This script will add IP addresses to each host and set a route entry for 10.0.0.0/16, but does not use via.

Ping from lan1 to lan3 shouldn't work - despite all routing tables being setup because the lan* routing table entries are assuming they are directly connected (so it will ARP for the destination address)

```
lan1 ping 10.0.3.2
```

# Example 2: setup-ip-ex2.sh 

Illustrates what happens when using via.

Ping from lan1 to lan3 will work because the lan* routing table entries are now saying to go via the router

```
lan1 ping 10.0.3.2
```

# Example 3: setup-ip-ex3.sh

This is showing interfaces with multiple IP addresses assigned to it.


This will default to using the whatever IP address was first defined (10.0.1.2) as source

```
lan1 ping 10.0.3.3
```

This will use a specific source IP address

```
lan1 ping -I 10.0.1.3 10.0.3.3
```


# Example 4: setup-ip-ex4.sh 


Illustrates setting up a GRE tunnel.  

It creates a GRE tunnel with local/remote points 10.0.1.2/10.0.3.2 (this is the outer header)

Then give the device an address in a different prefix 192.168.0.1/192.168.0.2 (this is the inner header)


Once set up, you can ping the 192.168 prefix:

```
lan1 ping 192.168.0.2
```

You can run tshark

```
# won't have encapsulation
lan1 tshark -O gre -i gre1

# will  have encapsulation
lan1 tshark -O gre -i eth1 

# See encapsulation as it traverses the router
rtr tshark -O gre -i eth1  
```

# Neighbor

Ex1 and Ex2 are specifically related to what ARP requests are sent.  So, it makes sense to also not that you can see the ARP table with `ip neigh`

before ping - the table on lan1 should be empty

````
lan1 ip neigh
````

do ping  (see first packets are ARP - use tshark for that)

```
lan1 ip neigh
```

It should output:   10.0.1.1 dev eth1 lladdr aa:c1:ab:4e:9b:e5 REACHABLE

after a while

```
lan1 ip neigh
```

It should output (showing the entry is stale):    10.0.1.1 dev eth1 lladdr aa:c1:ab:4e:9b:e5 STALE

You can explicitly flush: (which you'll see ARP again)

```
lan1 ip neigh flush all
```

