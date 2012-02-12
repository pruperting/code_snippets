#!/bin/bash
echo "starting vlc"
VPID=( $(ps -e | grep vlc | awk '{print $1;}'))
if [ $? = 1 ];then
echo "error getting vlc PID, exiting"
exit
fi
while [ -n "$VPID" ];do
kill $VPID
VPID=( $(ps -e | grep vlc | awk '{print $1;}'))
done
cvlc http://192.168.1.5:8081 &amp;
PID1=$?
 
echo video status $PID1
if [ "$PID1" == "1" ];then
echo "error starting vlc video"
exit
fi
vlc rtp://234.5.5.5:1234 --equalizer-bands="0,0,15,15,15,-20,0,0,0,0" &amp;
PID2=$?
 
echo audio status $PID2
if [ "$PID2" == "1" ];then
echo "error starting vlc audio"
exit
fi
exit
