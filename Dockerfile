FROM centos:6.4

# install essentials
RUN yum install -y wget dhclient

# install pipework
RUN wget -N -P /opt/bin/ https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework
RUN chmod +x /opt/bin/pipework
