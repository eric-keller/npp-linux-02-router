# Introduction

In this demo, we extend demo2 to use [ExaBGP](https://github.com/Exa-Networks/exabgp) to inject routes.  If you used bird to set some static routers, the ASPATH will just be whatever the router's AS is.  With ExaBGP, we can associate a path with that route that then gets advertised.  Note - ExaBGP is more powerful than just this, but this is what this demo is showing.  At the end, we discuss how you can get real routing tables, as captured by [RIPE](https://ripe.net/).

```
    static { 
        route 7.0.0.0/8 next-hop 10.10.0.2 as-path [ 49432 48362 9002 3356 749 ];
```


# ExaBGP setup

You need to have docker container image of ExaBGP locally.  To build, following these steps:

```
git clone https://github.com/Exa-Networks/exabgp.git
cd exabgp
docker build -t exabgp .
```

# Topology setup

We are going with the same topology as found in demo2, with one change - lan1 will run an instance of ExaBGP and peer with rtrA.  See the demo2 README.md for how to deploy the topology, assign IP addresses, and then start bird in rtrA-rtrD.

lan1 is now using the exabgp container image you just built.  It will also use the bind the local directory mod2-bird-confs to /etc/bird-alt/ in the container (just like it does for rtrA-rtrD).  The configuration that it uses is exa.conf  

rtrA also had it's bird configuration (rtrA-bird.conf) change - adding the peering to the ExaBGP router that will run on lan1.

# Running ExaBGP

Once the topology is set up, you can run ExaBGP by running the exabgp command inside of the lan1 container and specifying to use the exa.conf provided.

```
lan1 exabgp -v /etc/bird-alt/exa.conf
```

You can then run similar commands as discussed in demo2 to see the peerings and routes.

```
rtrA birdc show protocols
rtrA birdc show route all
```



# Running with RIPE data

Thanks to Bashayer Alharbi for this.


## Downloaded from RIPE https://ris.ripe.net/docs/10_routecollectors.html

```
mkdir dump
cd dump
wget https://data.ris.ripe.net/rrc03/2023.08/bview.20230803.0800.gz
```

Note: file is >3GB, so all steps in this doc will take a while

```
gunzip bview.20230803.0800.gz
```

## Run it through bgpdump (using docker image on docker hub)

```
cd ..
docker run -v $(pwd)/dump:/dump fusl/ripencc-bgpdump  -m -O /dump/bview-out /dump/bview.20230803.0800
```


## Output is now in dump/bview-out

The output is in dump/bview-out.  These are in [MRT](https://www.rfc-editor.org/rfc/rfc6396.html) format, for which there are tools available to parse them.  After parsing, you can format into a form suitable to be used in a config file for ExaBGP (like our exa.conf)





