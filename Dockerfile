FROM debian:stable-slim
RUN apt update \
    && apt install -y wget gnupg2 xvfb zstd cabextract unzip;

RUN dpkg --add-architecture i386 \
    && wget -qO- https://dl.winehq.org/wine-builds/winehq.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/winehq.gpg --import \
    && chmod 644 /etc/apt/trusted.gpg.d/winehq.gpg \
    && echo "deb https://dl.winehq.org/wine-builds/debian/ bullseye main" > /etc/apt/sources.list.d/winehq.list \
    && apt update \
    && apt install -y --install-recommends winehq-stable

ENV WINEARCH=win32 \
    WINEPREFIX=/root/.win32 \
    W_OPT_UNATTENDED=true

VOLUME ["/data"]

RUN winecfg \
    && ln -s /data /root/.win32/dosdevices/d:

RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks \
    && sh winetricks corefonts dxvk

ARG RETRO_TRIBES_INSTALLER_URL=http://www.playspoon.com/downloads/Tribes/tribes_1.30_fullgame.zip
ARG RETRO_TRIBES_INSTALLER_SHA256=4CBB220483CFE898F9D1D645F870E739AE1A0323A9FDAF63CEE3408BC2B48BA2
ENV RETRO_TRIBES_INSTALLER_FILE /root/tribes_installer.zip

RUN wget -O "$RETRO_TRIBES_INSTALLER_FILE" $RETRO_TRIBES_INSTALLER_URL \
      && echo "$RETRO_TRIBES_INSTALLER_SHA256 *$RETRO_TRIBES_INSTALLER_FILE" | sha256sum -c -

EXPOSE 28001/udp 28001/tcp

COPY serverConfig.cs /root/serverConfig.cs
COPY startup.sh /root/startup.sh
RUN chmod gou+x /root/startup.sh

#BEGIN Server Configuration Variables
ENV ServerAddress="LOOPBACK:28001" \
    ServerPort="28001" \
    ServerAdminPassword="ChangeMe" \
    ServerHostName="Docker Tribes Host" \
    ServerInfo="Docker TRIBES server setup\\\nGithub\\/victorprocure\\/docker-tribes1-server" \
    ServerMaxPlayers="32" \
    ServerTimeLimit="20" \
    ServerTeamScoreLimit="0" \
    ServerPublicGame="true" \
    PacketSize="400" \
    PacketRate="15"
#END Server Configuration Variables

ENTRYPOINT [ "sh" ]
CMD ["/root/startup.sh"]
