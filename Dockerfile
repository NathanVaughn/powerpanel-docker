FROM docker.io/library/ubuntu:20.04

ENV POWERPANEL_VERSION=481

RUN apt-get update && apt-get install -y \
      curl \
      ca-certificates \
      libgusb2 \
      libusb-1.0-0 \
      usb.ids \
      usbutils \
      expect \
      --no-install-recommends \
      && rm -rf /var/lib/apt/lists/*
RUN curl -s -L 'https://dl4jz3rbrsfum.cloudfront.net/software/PPB_Linux%2064bit_v4.8.1.sh' -o ppb-linux-x86_64.sh \
 && chmod +x ppb-linux-x86_64.sh

COPY --from=copier install.exp install.exp
RUN chmod +x install.exp && expect -d ./install.exp && rm ppb-linux-x86_64.sh && rm install.exp

# http, https, snmp
EXPOSE 3052
EXPOSE 53568
EXPOSE 162
VOLUME ["/usr/local/ppbe/db_local/"]

HEALTHCHECK CMD curl -vs --fail http://127.0.0.1:3052/ || exit 1
ENTRYPOINT ["/usr/local/ppbe/ppbed", "run"]
