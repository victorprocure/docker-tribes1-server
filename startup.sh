#!/bin/bash

export WINEARCH=win32
export WINEPREFIX=/root/.win32

#kill $(ps aux | grep 'Xvfb' | awk '{print $2}')
[ -e /tmp/.X0-lock ] && rm -- /tmp/.X0-lock

Xvfb :0 -screen 0 1024x768x16 &

if [ ! -d "/data/tribes" ];  then
	DISPLAY=:0.0 wine "/root/tribes_installer.exe" "/S" "/D=d:\\tribes"
cp /root/serverConfig.cs /data/tribes/config/serverConfig.cs
fi

sed -i "s/127.0.0.1/$SERVER_IP/" /data/tribes/config/serverConfig.cs

DISPLAY=:0.0 wine start /d "d:\\tribes" "d:\\tribes\\Tribes.exe" "+exec serverConfig.cs" "-dedicated"

tail -f /dev/null
