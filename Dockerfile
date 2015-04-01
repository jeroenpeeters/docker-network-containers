# This is a minimal dockerfile based on alpine used to facilitate running the generated iptables script.
# Nothing magical happening here....

FROM gliderlabs/alpine
MAINTAINER jeroen@peetersweb.nl

# install essentials
RUN apk --update add bash
RUN apk --update add dhclient
RUN apk --update add iptables

# dhcpclient script
ADD scripts/dhclient-script /sbin/dhclient-script

# install pipework
ADD https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework /opt/bin/
RUN chmod +x /opt/bin/pipework
