FROM docker.io/library/ubuntu:latest

ENV POWERPANEL_VERSION=480

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
RUN curl -s -L -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' 'https://www.cyberpower.com/global/en/File/GetFileSampleByType?fileId=SU-20040001-04&fileType=Download%20Center&fileSubType=FileOriginal' -o ppb-linux-x86_64.sh \
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

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="nathanvaughn/powerpanel-business" \
      org.label-schema.description="Docker image for PowerPanel Business" \
      org.label-schema.license="MIT" \
      org.label-schema.url="https://github.com/nathanvaughn/powerpanel-business-docker" \
      org.label-schema.vendor="nathanvaughn" \
      org.label-schema.version=$POWERPANEL_VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/nathanvaughn/powerpanel-business-docker.git" \
      org.label-schema.vcs-type="Git" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.title="nathanvaughn/powerpanel-business" \
      org.opencontainers.image.description="Docker image for PowerPanel Business" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/nathanvaughn/powerpanel-business-docker" \
      org.opencontainers.image.authors="Nathan Vaughn" \
      org.opencontainers.image.vendor="nathanvaughn" \
      org.opencontainers.image.version=$POWERPANEL_VERSION \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.source="https://github.com/nathanvaughn/powerpanel-business-docker.git"
