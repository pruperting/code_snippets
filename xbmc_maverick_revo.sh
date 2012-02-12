#!/bin/bash
#------------------------------------------------------------------------------------------------------------
# xbmcmaverickrevo.sh by prupert, for updates (only bug fixes) check out www.prupert.co.uk
# Based on setupXBMC Version 0.7a - 18/11/2009 an XBMC Installation script - by VirtualDanny.net
# with some additions from the XCI script (which has some stuff from VirtualDanny's script, so hey, full circle)
# This script will provide an automatic installation of xbmc for Revos 3610s in a minimal maverick environment
# It enables HMDI (not tested) & Optical output, installs the latest nvidia driver and adds some modifications
# Once installed, you still need to set the correct audio output in the settings menu of XBMC, I choose Optical/Coaxial and the output and passthrough devices set as iec958
# This is not designed to be a script for any other hardware, although I am pretty sure it will work fine on most things
# It is also not designed to give you loads of options, it just does what it says on the tin.
# REQUIREMENTS:
# * Ubuntu Maverick Minimal Installation (using the mini.iso from here: https://help.ubuntu.com/community/Installation/MinimalCD
# * XBMC Compatible Hardware
# * Internet access
# * Username must be set to 'xbmc' during Ubuntu installation
#
#
# Remember to run this script with sudo
#------------------------------------------------------------------------------------------------------------
# 01.01.11: v20110101: initial release - tested on a brand new minimal install of maverick
#------------------------------------------------------------------------------------------------------------
# BUGS
# Shutdown / Suspend / Hibernate / Reboot do not work, they only exit XBMC. I have tried to fix this with no luck, still working on it.
# The xorg.conf fixes also don't work, though they might not be needed with the new way X works
#------------------------------------------------------------------------------------------------------------
## --[ Miscellaneous variables ]

LOG=/var/log/xbmcmaverickrevo.log

cd /

##--[ ADDING REPOSITORIES TO SOURCE LIST ]
echo installing repos and deps
aptitude install python-software-properties pkg-config -f -y &>> $LOG

add-apt-repository ppa:team-xbmc/ppa

##--[ ADDING NVIDIA REPOISOTIRES TO SOURCE LIST ]

add-apt-repository ppa:ubuntu-x-swat/x-updates

##--[ RUNNING A SYSTEM UPDATE ]

aptitude update

##--[ INSTALL GENERIC NVIDIA GRAPHIC DRIVERS ]
echo
echo installing nvidia drivers
aptitude install nvidia-current -f -y &>> $LOG
aptitude install nvidia-current-dev -f -y &>> $LOG
aptitude install vdpauinfo -f -y &>> $LOG
aptitude install libvdpau-dev -f -y &>> $LOG

##--[ INSTALLS XBMC Media Center ]
echo
echo installing xbmc
aptitude install xbmc -f -y &>> $LOG

##--[ INSTALL Additional software ]
echo
echo installing windows manager
aptitude install openbox xterm xinit x11-xserver-utils nfs-common smbfs smbclient libsmbclient -f -y &>> $LOG

## --[ INSTALL AND CONFIGURE ALSA SOUND ]
echo
echo installing alsa
aptitude install linux-sound-base alsa-base alsa-utils -y
usermod -a -G audio xbmc

echo
echo AlsaMixer will now start so that you can configure your volume levels.
echo 
echo Press 'M' to activate/deactive, Arrows to adjust volume, and ESC to save/quit.
echo Press any Key to contiue, or wait 10 seconds to continue
read -n1 -t10 any_key

alsamixer
alsactl store 0

## --[ INSTALL Linux IR Remote Control Support]

echo
echo Now installing the remote control program lirc.
echo 
echo When given the option, please select the remote control you will be using

aptitude install lirc -y

## --[ FINAL SYSTEM UPGRADE ]

aptitude update
aptitude upgrade -f -y &>> $LOG

## --[ GENERATE XORG.CONF ]
#this doesn't seem to work with my script, so commented out for now
#echo
#echo fixing up xorg, autologin and sound
#nvidia-xconfig -s --no-logo --force-generate

## --[ ADDING HWcursor fix ]

#sed -i '37i\    Option         "HWCursor" "False"' /etc/X11/xorg.conf

## --[ ENABLE 1080p 24Hz]

#sed -i '38i\    Option         "ExactModeTimingsDVI" "TRUE"' /etc/X11/xorg.conf
#sed -i '52i\    Option         "FlatPanelProperties" "Scaling = Native"' /etc/X11/xorg.conf
#sed -i '53i\    Option         "DynamicTwinView" "False"' /etc/X11/xorg.conf

## --[ Disable Composite for better H264 acceleration ]

#sed -i '59i\ ' /etc/X11/xorg.conf
#sed -i '60i\Section "Extensions"' /etc/X11/xorg.conf
#sed -i '61i\    Option         "Composite" "Disable"' /etc/X11/xorg.conf
#sed -i '62i\EndSection' /etc/X11/xorg.conf


## --[ INSTALLING XBMC HELPERS ]

aptitude install python-apt -f -y &>> $LOG

## --[ Setup autologin for user "xbmc" ]
echo '# tty1 - getty' > /etc/init/tty1.conf
echo '#' >> /etc/init/tty1.conf
echo '# This service maintains a getty on tty1 from the point the system is' >> /etc/init/tty1.conf
echo '# started until it is shut down again.' >> /etc/init/tty1.conf
echo >> /etc/init/tty1.conf
echo 'start on stopped rc RUNLEVEL=[2345]' >> /etc/init/tty1.conf
echo 'stop on runlevel [!2345]' >> /etc/init/tty1.conf
echo >> /etc/init/tty1.conf
echo 'respawn' >> /etc/init/tty1.conf
echo 'exec /bin/login -f xbmc </dev/tty1 > /dev/tty1 2>&1' >> /etc/init/tty1.conf

echo 'case "`tty`" in' > /home/xbmc/.bash_profile
echo '/dev/tty1) clear && startx &>/dev/null;;' >> /home/xbmc/.bash_profile
echo 'esac' >> /home/xbmc/.bash_profile

echo exec openbox-session > /home/xbmc/.xinitrc

mkdir -p /home/xbmc/.config/openbox

echo '#!/bin/bash' > /usr/local/bin/xbmc-session
echo >> /usr/local/bin/xbmc-session
echo 'xbmc --standalone' >> /usr/local/bin/xbmc-session
echo 'irexec &' >> /usr/local/bin/xbmc-session
echo 'exit' >> /usr/local/bin/xbmc-session

chmod +x /usr/local/bin/xbmc-session

echo xbmc-session > /home/xbmc/.config/openbox/autostart.sh

## --[ GRANT XBMC POWER ACCESS ]
##this doesn't work, it needs modification
#aptitiude install policykit-1 upower hal -f -y &>> $LOG

#touch /var/lib/polkit-1/localauthority/50-local.d/xbmc.xbmc.powercontrol.pkla

#echo '[Actions for xbmc user]' > /var/lib/polkit-1/localauthority/50-local.d/xbmc.xbmc.powercontrol.pkla
#echo 'Identity=unix-user:xbmc' >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.xbmc.powercontrol.pkla
#echo 'Action=org.freedesktop.upower.*;org.freedesktop.consolekit.system.*' >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.xbmc.powercontrol.pkla
#echo 'ResultActive=yes' >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.xbmc.powercontrol.pkla
#echo 'ResultAny=auth_admin' >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.xbmc.powercontrol.pkla
#echo 'ResultInactive=yes' >> /var/lib/polkit-1/localauthority/50-local.d/xbmc.xbmc.powercontrol.pkla


## --[ ENABLE HDMI & OPTICAL AUDIO ]

rm -f /home/xbmc/.asoundrc &>> $LOG
rm -f /etc/asound.conf &>> $LOG
touch /etc/asoundrc.conf
echo 'pcm.!default {' > /etc/asound.conf
echo ' type plug' >> /etc/asound.conf
echo '  slave {' >> /etc/asound.conf
echo '   pcm "both"' >> /etc/asound.conf
echo '  }' >> /etc/asound.conf
echo '}' >> /etc/asound.conf
echo '' >> /etc/asound.conf
echo 'pcm.both {' >> /etc/asound.conf
echo ' type route' >> /etc/asound.conf
echo '  slave {' >> /etc/asound.conf
echo '   pcm multi' >> /etc/asound.conf
echo '   channels 6' >> /etc/asound.conf
echo '  }' >> /etc/asound.conf
echo ' ttable.0.0 1.0' >> /etc/asound.conf
echo ' ttable.1.1 1.0' >> /etc/asound.conf
echo ' ttable.0.2 1.0' >> /etc/asound.conf
echo ' ttable.1.3 1.0' >> /etc/asound.conf
echo ' ttable.0.4 1.0' >> /etc/asound.conf
echo ' ttable.1.5 1.0' >> /etc/asound.conf
echo '}' >> /etc/asound.conf
echo '' >> /etc/asound.conf
echo 'pcm.multi {' >> /etc/asound.conf
echo ' type multi' >> /etc/asound.conf
echo '  slaves.a {' >> /etc/asound.conf
echo '   pcm "tv"' >> /etc/asound.conf
echo '   channels 2' >> /etc/asound.conf
echo '  }' >> /etc/asound.conf
echo '  slaves.b {' >> /etc/asound.conf
echo '  pcm "receiver"' >> /etc/asound.conf
echo '  channels 2' >> /etc/asound.conf
echo '  }' >> /etc/asound.conf
echo ' bindings.0.slave a' >> /etc/asound.conf
echo ' bindings.0.channel 0' >> /etc/asound.conf
echo ' bindings.1.slave a' >> /etc/asound.conf
echo ' bindings.1.channel 1' >> /etc/asound.conf
echo ' bindings.2.slave b' >> /etc/asound.conf
echo ' bindings.2.channel 0' >> /etc/asound.conf
echo ' bindings.3.slave b' >> /etc/asound.conf
echo ' bindings.3.channel 1' >> /etc/asound.conf
echo '}' >> /etc/asound.conf
echo '' >> /etc/asound.conf
echo 'pcm.tv {' >> /etc/asound.conf
echo ' type hw' >> /etc/asound.conf
echo ' card 0' >> /etc/asound.conf
echo ' device 3' >> /etc/asound.conf
echo ' channels 2' >> /etc/asound.conf
echo '}' >> /etc/asound.conf
echo '' >> /etc/asound.conf
echo 'pcm.receiver {' >> /etc/asound.conf
echo ' type hw' >> /etc/asound.conf
echo ' card 0' >> /etc/asound.conf
echo ' device 1' >> /etc/asound.conf
echo ' channels 2' >> /etc/asound.conf
echo '}' >> /etc/asound.conf
sed -i "s/<ac3passthrough>.*</<ac3passthrough>true</" /home/xbmc/.xbmc/userdata/guisettings.xml
sed -i "s/<audiodevice>.*</<audiodevice>alsa:plug:both</" /home/xbmc/.xbmc/userdata/guisettings.xml
sed -i "s/<passthroughdevice>.*</<passthroughdevice>alsa:iec958</" /home/xbmc/.xbmc/userdata/guisettings.xml
sed -i "s/<mode>0</<mode>1</" /home/xbmc/.xbmc/userdata/guisettings.xml

# Sort out ownerships

chown -R xbmc:xbmc /home/xbmc

# Add SVN version of XBMC
echo
echo adding svn ppa
add-apt-repository ppa:team-xbmc-svn/ppa
aptitude update
aptitude upgrade -f -y &>> $LOG
aptitude install xbmc-live -f -y &>> $LOG

#SYSTEM Reboot
sync
/sbin/reboot

