# Introduction

In this lab, you will configure a BGP router to peer with another router, and then use Linux commands to bring down links to see how traffic changes paths.

# Setup

The starting point for this lab will be demo2-bgp.

As a reminder, in that directory, you will find the following files:
- diamond-mod2.clab.yml - the containerlab topology configuration file from demo2-bgp.
- mod2-bird-confs/rtr[A-D]-bird.conf - the router configuration files for each of the 4 routers (rtrA-rtrD).
- setup-ip-diamond.sh - sets the IP addresses for each of the interfaces in the topology
- start-bird.sh - starts bird in each of the 4 routers (rtrA-rtrD) with the custom path to their configuration file.

Verify it works by running:

```
lan1 ping -I 1.1.1.1 4.4.4.4
lan1 traceroute -s 1.1.1.1 4.4.4.4
```

# Lab Task - Part 1

Extend the topology to include a link and peering between rtrB and rtrC.  Use the interface eth3 for each.  And set the IP addresses as follows:
- rtrB eth3 = 10.10.6.2
- rtrC eth3 = 10.10.6.1

To do this, you will need to edit the files as follows:
- diamond-mod2.clab.yml - create a new link
- rtrB-bird.conf - add the peering to rtrC.  Use the existing CtoA peering as a template, just update the neighbor.
- rtrC-bird.conf - add the peering to rtrB.  Use the existing BtoA peering as a template, just update the neighbor.
- setup-ip-diamond.sh - set the IP address and route table entry of rtrB eth3 and rtrC eth3

To test, look at the routing table and peerings of of rtrB and rtrC.  You should see B as a neighbor of C (and C a neihbor of B).  You should see an extra route (in addition to seeing C to D, you should see C to B to D, which won't get chosen).

If you used the same naming convention, you should see a line like the following after running `rtrB birdc show protocols`
```
BtoC       BGP        ---        up     08:40:11.679  Established
```

And after running `rtrC birdc show protocols`
```
CtoB       BGP        ---        up     08:40:11.679  Established
```

For the extra route, you should see something like this on rtrC (running `rtrC birdc show route all`).  Note the extra route for the prefix 4.4.4.0/24 via 10.10.6.2 (which is rtrB), and the AS Path for that is 65001 (rtrB) 65003 (rtrD).

```
4.4.4.0/24           unicast [CtoD 08:50:33.110] * (100) [AS65003i]
        via 10.10.4.2 on eth2
    [DELETED SOME OUTPUT]

        via 10.10.6.2 on eth3
        Type: BGP univ
        BGP.origin: IGP
        BGP.as_path: 65001 65003
        BGP.next_hop: 10.10.6.2
        BGP.local_pref: 100
                     unicast [CtoA 08:50:16.978] (100) [AS65003i]

        via 10.10.2.1 on eth1
    [DELETED SOME OUTPUT]
```


# Lab Task - Part 2

Fail the links between A and B and between C and D.  You can do this by bringing down eth1 on rtrB and eth2 on rtrC.  You can use the Linux `ip link` command to do that.

If you inspect the routing table for rtrC again, you should only see one entry for the 4.4.4.0/24 prefix, as the one directly to rtrD is no longer available.

```
4.4.4.0/24           unicast [CtoB 08:40:11.695] * (100) [AS65003i]
        via 10.10.6.2 on eth3
        Type: BGP univ
        BGP.origin: IGP
        BGP.as_path: 65001 65003
        BGP.next_hop: 10.10.6.2
        BGP.local_pref: 100
```


Now, traffic should be going A-C-B-D.  Verify using traceroute from lan1 to lan2 (recall, we're using an alias, so lan1 below is actually `docker exec -it  clab-mod2-bgp-lan1`).

```
lan1 traceroute -s 1.1.1.1 4.4.4.4
```


# Submission

The submission will consist running  set of commands following the completion of Part 1 (so, when you created a link and peering between B and C, but before you failed the links).  Then caputing the output for another command after performing part 2 (after you failed links AB and CD).  The output will go to submission.out - which is what you will submit.

A script is provided (capture_submission.sh) that you run in two parts.

Do Part 1.  Then run

```
./capture_submission part1
```

Then do Part 2.  Then run
```
./capture_submission part2
```
 


The output file (submission.out) should look like:

```
[output of traceroute (from lan1 to lan2) - part1]
---
[output of birdc show route all (from rtrB) - part1]
---
[output of birdc show route all (from rtrC) - part1]
---
[output of traceroute (from lan1 to lan2) - part2]
```

# Troubleshooting

If you are not seeing the rtrB - rtrC peering as Established (in both rtrB and rtrC), check these.
- Did you set the IP addresses correctly (of rtrB eth3 and rtrC eth3)
- Did you set the neigbor IP addresses correctly?  (the BtoC peering on rtrB should have the address as rtrC eth3's IP).
- Did you set the AS number of the neighbor correctly.  rtrB is AS 65001, rtrC is AS 65002.



