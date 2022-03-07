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

#BEGIN Server Configuration Variables
ENV ServerAddress="LOOPBACK:28001" \
    ServerPort="28001" \
    ServerAdminPassword="ChangeMe" \
    ServerHostName="Docker Tribes Host" \
    ServerInfo="Docker TRIBES server setup\\\nGithub\\\n\\\/victorprocure\\\n\\\/docker-tribes1-server" \
    ServerMaxPlayers="32" \
    ServerTimeLimit="20" \
    ServerTeamScoreLimit="0" \
    ServerPublicGame="true" \
    PacketSize="400" \
    PacketRate="15"
#END Server Configuration Variables

ENV InstallRenegades 0
ENV InstallSpoonbot 0

ARG RETRO_TRIBES_GDRIVE_ID="15j9PWPFFBJ6Rk0yaSTMIyHro9WEDTFJe" \
    RETRO_TRIBES_INSTALLER_SHA256=98425295B40A755BF926F80D72E73360D0269BBC34FA8B8A3520DA4F5D6F2258
ENV RETRO_TRIBES_INSTALLER_FILE /root/tribes_installer.zip
ENV SPOONBOT_GDRIVE_ID="1Uw0JoAbBlMewdAJ2nrXwU4Go6inb-HqL" \
    RENEGADES_GDRIVE_ID="1CiaF7LSQiymSkGw_wAqI1XZgWRdqidjz"

RUN wget -O $RETRO_TRIBES_INSTALLER_FILE --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$RETRO_TRIBES_GDRIVE_ID" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$RETRO_TRIBES_GDRIVE_ID" \
      && rm -rf /tmp/cookies.txt \
      && echo "$RETRO_TRIBES_INSTALLER_SHA256 *$RETRO_TRIBES_INSTALLER_FILE" | sha256sum -c -

RUN wget -O /root/logredirect.zip https://github.com/victorprocure/LogRedirect/releases/download/v1.0.0/logdirect-x86.zip \
      && unzip /root/logredirect.zip -d /root/

EXPOSE 28001/udp 28001/tcp

COPY serverConfig.cs /root/serverConfig.cs
COPY startup.sh /root/startup.sh
RUN chmod gou+x /root/startup.sh

ENTRYPOINT [ "sh" ]
CMD ["/root/startup.sh"]
