#!/bin/bash

serverConfig=/data/Tribes/config/serverConfig.cs

#kill $(ps aux | grep 'Xvfb' | awk '{print $2}')
[ -e /tmp/.X0-lock ] && rm -- /tmp/.X0-lock

Xvfb :0 -screen 0 1024x768x16 &

if [ ! -d "/data/Tribes" ];  then
  unzip /root/tribes_installer.zip -d /data
  cp -f /root/serverConfig.cs $serverConfig
fi

if [ ! -f $serverConfig ] || [ "/root/serverConfig.cs" -nt $serverConfig ]; then
  cp -f /root/serverConfig.cs $serverConfig
fi

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

DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod spoonbot_13 +exec serverConfig.cs +exec spoonbot.cs -dedicated

tail -f /dev/null
