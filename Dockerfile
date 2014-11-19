# This is a minimal dockerfile based on centos6 used to facilitate running the generated iptables script.
# Nothing magical happening here....

FROM centos:centos6

# install essentials
RUN yum install -y wget dhclient

# install pipework
RUN wget -N -P /opt/bin/ https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework
RUN chmod +x /opt/bin/pipework
