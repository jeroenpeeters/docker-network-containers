# This is a minimal dockerfile based on centos6 used to facilitate running the generated iptables script.
# Nothing magical happening here....

FROM docker-registry.isd.ictu:5000/alpine

# install essentials
RUN apk --update add dhclient
RUN apk --update add iptables

# install pipework
ADD https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework /opt/bin/ 
RUN chmod +x /opt/bin/pipework
