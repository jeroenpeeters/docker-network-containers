Docker Network Containers
===========================

Scripts for setting up Docker router containers that expose the private ports of a container on a public IP address.

Preface
--------
Docker exposes the TCP/IP ports from the containers by providing a NAT service which maps the container's private ports to unique public ports. This allows for multiple containers using the same private port (e.g. port 80 for a webserver).
However, this is not always convenient because some protocols require static, stable ports (HTTP for instance).

This can be solved in multiple different ways, of which this is an attempt.

Network Container
-----------------
A network container, in this case, is a container which sole purpose is to provide public network capabilities to another container. It maps the private ports of the container onto a public IP address. This way services can be exposed on their default ports. Furthermore it is possible to use standard network protocols like DHCP and DNS.

How does it work?
-----------------
Setting up a network container is a three step process. The whole process is automated by a single script that performs the following tasks:

  1. Retrieve the private ports of the container, for this the ports MUST be exported to Docker.
  2. Generate an iptables script that performs routing to the private ports. This script will be executed inside the network container.
  3. Run the network container and pass it the generated iptables script.
  4. Create a network bridge from the network interface of the host to the interface inside the network container.
  5. Wait for the container to come up on a public IP address.

Next to setting up iptables routing inside the container, the generated script also tries to acquire an IP address using DHCP. For this to succeed it is very important that a DHCP server is available on the network that is bridged into the container.

Usage
-----

### Create network container
`create-network-container.sh **CONTAINERNAME IFDEV**`

The script takes two paramaters. The name of a running container, and the network interface of the host that must be bridged into the network container. To find out the name of the network interface on your host use ifconfig.

### Remove network container
`remove-network-container.sh **CONTAINERNAME**`

Unlinks the network container and then stops and removes it.

### Example
Lets assume that you have a running container named 'webserver' exposing port 80.

    # /opt/bin/create-network-container.sh webserver ens32
      creating iptables route for port 80
      containerid=63f967c4cc1e0cd166fffc6b469cc03190e9fd3b2ea86d290304b227459f5202
      waiting for public ip to be bound
      waiting for public ip to be bound
      ip=10.19.88.31

    # docker ps
      CONTAINER ID  IMAGE                                   COMMAND               CREATED             STATUS             PORTS                  NAMES
      63f967c4cc1e  jeroenpeeters/public-networking:latest  "bash /scripts/17903  About a minute ago  Up About a minute                         publicnetwork-webserver
      ab6dba7f96e4  dockerfile/nodejs:latest                "node /scripts/examp  About a minute ago  Up About a minute  0.0.0.0:49154->80/tcp  publicnetwork-webserver/private_server,webserver

    # /opt/bin/remove-network-container.sh webserver

Installation
------------

### Requirements

  - To bridge the network interface I rely on https://github.com/jpetazzo/pipework, install this first. It is assumed that pipework is available as */opt/bin/pipework*.
  - The network interface on the Docker host should allow for promiscuous mode: `ip link set dev ETH_DEV_NAME promisc on`
  - When running on a virtualized environment (VMWare, VirtualBox, etc) the virtual tap devices should be set to allow promiscuous mode as well.

Install the Docker Network Container scripts on each Docker host:

    git clone https://github.com/jeroenpeeters/docker-network-containers.git /tmp/networking-container
    cp /tmp/networking-container/create-network-container.sh /opt/bin/
    cp /tmp/networking-container/remove-network-container.sh /opt/bin/
    chmod +x /opt/bin/create-network-container.sh /opt/bin/remove-network-container.sh
    
