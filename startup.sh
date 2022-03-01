#!/bin/bash

export WINEARCH=win32
export WINEPREFIX=/root/.win32

#kill $(ps aux | grep 'Xvfb' | awk '{print $2}')
[ -e /tmp/.X0-lock ] && rm -- /tmp/.X0-lock

Xvfb :0 -screen 0 1024x768x16 &

if [ ! -d "/data/Tribes" ];  then
unzip /root/tribes_installer.zip -d /data
cp /root/serverConfig.cs /data/Tribes/config/serverConfig.cs
fi

sed -i "s/127.0.0.1/$SERVER_IP/" /data/Tribes/config/serverConfig.cs

DISPLAY=:0.0 wine start /d "d:\\Tribes" "d:\\Tribes\\Tribes.exe" -mod spoonbot_13 +exec serverConfig.cs +exec spoonbot.cs -dedicated

tail -f /dev/null
