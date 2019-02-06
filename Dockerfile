FROM fedora:27
RUN dnf update -y
RUN dnf install -y python
RUN dnf install -y python-pip
RUN pip install vici

RUN mkdir -p /config

COPY cyberprobe.cfg /cyberprobe.cfg
COPY ipsec-addr-sync /usr/local/bin/

# Sleep gives the VPN time to start
CMD cp /cyberprobe.cfg /config/cyberprobe.cfg; \
    sleep 5; \
    /usr/local/bin/ipsec-addr-sync /config/cyberprobe.cfg /config/charon.vici

