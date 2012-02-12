#! /bin/sh
### BEGIN INIT INFO
# Provides: mythtvremodel
# Required-Start:    $local_fs $syslog $remote_fs dbus
# Required-Stop:     $local_fs $syslog $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: rename, move delete recordings
### END INIT INFO
# script to rename files recorded from mythtv and then to move them and delete them
#made by prupert.co.uk
#creative commons licence, whichever is the most FREE (as in beer)

#lets put in some variables so others can use this
#location of log file, you can choose anything and any name
log=/path/to/mythtvremodel.log
#this is the full path to mythrename.pl
mrename=/location/to/mythrename.pl
#this is the full path to your recordings folder
record=/var/www/mythweb/data/recordings/
#this is the extension your recordings are stored as, usually mpg or nuv
ext=mpg
#this is the full path to where you want your files moved to
dest=/path/to/folder/to/move/recordings/to/
#this is the full path to myth.find_orphans.pl
morphan=/path/to/myth.find_orphans.pl
#mythtv database password for myth.find_orphans.pl
pass=yourmythtvdatabasepassword

# first, run mythtvrename to get nice names for the recordings
echo starting mythtvremodel on `date "+%m/%d/%y %l:%M:%S %p"` > $log
perl $mrename --underscores --format %T-%S-%d%m%y >> $log
# use find to search for all recorded files in the recording folder and move them to the TV folder
find "$record" -name "*.$ext" >> $log
find "$record" -name "*.$ext" -exec mv {} "$dest" \; >> $log
# use mythorphan to remove the now missing recorded files from the database
perl $morphan --pass=$pass --dodbdelete >> $log
#that should be it
echo stopping mythtvremodel on `date "+%m/%d/%y %l:%M:%S %p"` >> $log
exit 0
