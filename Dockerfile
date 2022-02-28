FROM debian:stable-slim
RUN apt update \
    && apt install -y wget gnupg2 xvfb zstd cabextract;

RUN dpkg --add-architecture i386 \
    && wget -qO- https://dl.winehq.org/wine-builds/winehq.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/winehq.gpg --import \
    && chmod 644 /etc/apt/trusted.gpg.d/winehq.gpg \
    && echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" > /etc/apt/sources.list.d/winehq.list \
    && apt update \
    && apt install -y --install-recommends winehq-stable

ENV WINEARCH=win32 \
    WINEPREFIX=/root/.win32 \
    W_OPT_UNATTENDED=true

ENV RETRO_TRIBES_INSTALLER_URL http://www.iateyourbaby.com/twdemos/Groove/full_installs/retro_141_installerv2.exe
ENV RETRO_TRIBES_INSTALLER_SHA256 5FF657631D22FE497FCE096F2E39ADF327E23A37F386D8062DCC4BE150151581
ENV RETRO_TRIBES_INSTALLER_FILE /root/tribes_installer.exe

RUN wget -O "$RETRO_TRIBES_INSTALLER_FILE" $RETRO_TRIBES_INSTALLER_URL \
      && echo "$RETRO_TRIBES_INSTALLER_SHA256 *$RETRO_TRIBES_INSTALLER_FILE" | sha256sum -c -

RUN winecfg

VOLUME ["/data"]
RUN ln -s /data /root/.win32/dosdevices/d:

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks \
    && sh winetricks corefonts dxvk

ENV SERVER_IP 127.0.0.1

EXPOSE 28001/udp 28001/tcp

COPY serverConfig.cs /root/serverConfig.cs
COPY startup.sh /root/startup.sh
RUN chmod gou+x /root/startup.sh

ENTRYPOINT [ "sh" ]
CMD ["/root/startup.sh"]
