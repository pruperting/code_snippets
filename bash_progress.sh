#!/bin/bash
time=( $(tac /var/log/rsback/work-daily | grep -m 1 "total runtime" | awk '{ print $6 }') )
echo "last running time was" $time
/bin/rsback -v work-daily >> /var/log/rsback/work-daily &
pid=$!
trap "
#[ -e /proc/$pid ] && kill $pid
#" EXIT

while [ -e /proc/$pid ]; do
sleep 10
runtime=( $(ps ax | grep -m 1 zenity | awk '{print $4}') )
echo "#" $runtime
done | zenity --width 500 --progress --pulsate --title="work-daily running time: $time" --text="running time:" --auto-close
retval=$?

# If the progress bar was canceled, give a warning.
if [ $retval -ne 0 ]; then
zenity --title="work-daily rsback" --error --text="the work-daily rsback was cancelled" || exit 1
kill $pid
fi
time=( $(tac /var/log/rsback/work-daily | grep -m 1 "total runtime" | awk '{ print $6 }') )
zenity --info --title "Work rsback" --text "work rsback done in $time"
exit
