#!/bin/bash

serverConfig=/data/Tribes/config/serverConfig.cs

# param 1: GDRIVE_ID
# param 2: Output
download_gdrive() {
  wget --no-check-certificate "https://docs.google.com/uc?export=download&id=$1" -O $2
}


#kill $(ps aux | grep 'Xvfb' | awk '{print $2}')
[ -e /tmp/.X0-lock ] && rm -- /tmp/.X0-lock

Xvfb :0 -screen 0 1024x768x16 &

if [ ! -d "/data/Tribes" ];  then
  unzip $RETRO_TRIBES_INSTALLER_FILE -d /data
fi

if [ "$InstallRenegades" -eq 1 ] && [ ! -d "/data/Tribes/renegades" ]; then
  download_gdrive $RENEGADES_GDRIVE_ID /tmp/renegades.zip
  unzip -o /tmp/renegades.zip -d /data/Tribes
fi

if [ "$InstallSpoonbot" -eq 1 ] && [ ! -d "/data/Tribes/spoonbot_13" ]; then
  download_gdrive $SPOONBOT_GDRIVE_ID /tmp/spoonbot.zip
  unzip -o /tmp/spoonbot.zip -d /data/Tribes
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

if [ "$InstallRenegades" -eq 1 ] && [ "$InstallSpoonbot" -eq 1 ]; then
  DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod Renegades5 -mod spoonbot_13 +exec spoonbot.cs +exec renegades.cs +exec serverConfig.cs -dedicated
elif [ "$InstallRenegades" -eq 1 ] && [ ! "$InstallSpoonbot" -eq 1 ]; then
  DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod Renegades5 +exec renegades.cs +exec serverConfig.cs -dedicated
elif [ ! "$InstallRenegades" -eq 1 ] && [ "$InstallSpoonbot" -eq 1 ]; then
  DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod spoonbot_13 +exec spoonbot.cs +exec serverConfig.cs -dedicated
else
  DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod spoonbot_13 +exec serverConfig.cs +exec spoonbot.cs -dedicated
fi
tail -f /dev/null
