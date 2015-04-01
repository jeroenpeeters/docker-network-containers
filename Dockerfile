# This is a minimal dockerfile based on centos6 used to facilitate running the generated iptables script.
# Nothing magical happening here....

MAINTAINER jeroen@peetersweb.nl

FROM gliderlabs/alpine

# install essentials
RUN apk --update add bash
RUN apk --update add dhclient
RUN apk --update add iptables

# install pipework
ADD https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework /opt/bin/
RUN chmod +x /opt/bin/pipework
