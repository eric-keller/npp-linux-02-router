# Introduction

This set of demos and lab goes along with the coursera course: `Network Principles in Practice: Linux`.  You are welcome to run this code and I try to make it as self explanatory as possible, but some of the explanation will be in the videos for the course.

NOTE: Mac M1/M2 users should refer to the guidance [here](https://github.com/eric-keller/npp-linux-01-intro/blob/main/mac-arm/README.md)

# Vagrantfile

A Vagrantfile is provided that will create a Ubuntu 22.04 VM, and install the needed software on the VM.

This was tested using vagrant VirtualBox running on Windows 11.

```
vagrant up
```


Configure your ssh client with the following.  I use [MobaXterm](https://mobaxterm.mobatek.net/).
Hostname/IP address: 127.0.0.1
Port number: 2222
Username: vagrant
Private Key: <path/to/private_key>
Note: you’ll want x11 forwarding on

To get the location of the private key:

```
vagrant ssh-config
```


When you want to stop the VM, you can either run `vagrant suspend` to save the state so you can resume it later with `vagrant up`, or `vagrant halt` to shut the VM down.


# Module 2 demos (demo1-cli, demo2-bgp, demo3-exabgp)

Module 2 provides an overview of using Linux as a router.  The material provided will overview some commands (e.g., using `iproute2`), as well as running routing softer (bird).  

# Lab (lab1)

This is the material provided for the coursera course. A description of the lab and a script to run your solution and package up a submission are provided.

# License

For all files in this repo, we follow the MIT license.  See LICENSE file.
