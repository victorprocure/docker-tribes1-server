#!/bin/bash

serverConfig=/data/Tribes/config/serverConfig.cs

#kill $(ps aux | grep 'Xvfb' | awk '{print $2}')
[ -e /tmp/.X0-lock ] && rm -- /tmp/.X0-lock

Xvfb :0 -screen 0 1024x768x16 &

if [ ! -d "/data/Tribes" ];  then
  unzip /root/tribes_installer.zip -d /data
fi

if [ "$InstallRenegades" -eq 1 ] && [ ! -d "/data/Tribes/Renegades" ]; then
  wget --no-check-certificate -O /tmp/renegades.zip \
    "https://drive.google.com/uc?export=download&id=1LxarQoL2HFiR-3ulHJk8dhkXvCwYBxBF"
  unzip -o /tmp/renegades.zip -d /data
fi

  cp -f /root/serverConfig.cs $serverConfig

#BEGIN SET Server Config
sed -i "s/#ServerAddress#/$ServerAddress/" $serverConfig
sed -i "s/#ServerPort#/$ServerPort/" $serverConfig
sed -i "s|#ServerAdminPassword#|$ServerAdminPassword|" $serverConfig
sed -i "s|#ServerHostName#|$ServerHostName|" $serverConfig
sed -i "s|#ServerInfo#|$ServerInfo|" $serverConfig
sed -i "s/#ServerMaxPlayers#/$ServerMaxPlayers/" $serverConfig
sed -i "s/#ServerTimeLimit#/$ServerTimeLimit/" $serverConfig
sed -i "s/#ServerTeamScoreLimit#/$ServerTeamScoreLimit/" $serverConfig
sed -i "s/#ServerPublicGame#/$ServerPublicGame/" $serverConfig
sed -i "s/#PacketSize#/$PacketSize/" $serverConfig
sed -i "s/#PacketRate#/$PacketRate/" $serverConfig
#END SET Server Config

if [ "$InstallRenegades" -eq 1 ]; then
  DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod Renegades5 -mod spoonbot_13 +exec spoonbot.cs +exec renegades.cs +exec serverConfig.cs -dedicated
else
  DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod spoonbot_13 +exec serverConfig.cs +exec spoonbot.cs -dedicated
fi
tail -f /dev/null
