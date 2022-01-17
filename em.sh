#!/bin/bash
sudo mount -a
cd /mnt/omv/ogg
cd /home/dietpi
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/DnB --pid=m0003l3c --pid-recursive
#get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio "/mnt/omv/music/Mixes/Hit Reset" --pid=m0002zgz --pid-recursive
#get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio "/mnt/omv/music/Mixes/Power Down" --pid=p04m6srg --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio "/mnt/omv/music/Mixes/Chill Mix" --pid=p06kbdcc --pid-recursive
#get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/FocusBeats --pid=p06lkldv --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/TMAM --pid=p071z8z5 --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/EssentialMix/2022 --pid=b006wkfp --pid-recursive
acxi
#get podcasts
/home/dietpi/flexget/bin/flexget execute
#get soundcloud mixes - needs work currently will download everything
/home/dietpi/.local/bin/scdl -l https://soundcloud.com/factmag/tracks -t -c -n 10 --addtimestamp --addtofile --download-archive FACT.txt --extract-artist --min-size 20m --no-playlist-folder --original-art --path /mnt/omv/music/Mixes/FACT/
#this produces way too many results, so stopping for now
#/home/dietpi/.local/bin/scdl -l https://soundcloud.com/RINSEFM/tracks -t -c -n 10 --addtimestamp --addtofile --download-archive RINSEFM.txt --extract-artist --min-size 20m --no-playlist-folder --original-art --path /mnt/omv/music/Mixes/RinseFM/
/home/dietpi/.local/bin/scdl -l https://soundcloud.com/fabric/tracks -t -c -n 10 --addtimestamp --addtofile --download-archive FABRIC.txt --extract-artist --min-size 20m --no-playlist-folder --original-art --path /mnt/omv/music/Mixes/Fabric/

# another soundcloud user to try: https://soundcloud.com/bestdjmixes

#get mixcloud mix, currently only individual mixes:
#youtube-dl --no-mtime --add-metadata -x --audio-format vorbis --audio-quality 3 https://www.mixcloud.com/stampthewax/monday-morning-mixtape-377/

#script that uses youtube-dl limited to first page - can't use as doesnt remember already downloaded
#yarn --cwd /home/dietpi/mixcloud-dl -p 1 start FACTMixArchive /mnt/omv/music/Mixes/FACTArchive
#yarn --cwd /home/dietpi/mixcloud-dl -p 1 start fabric /mnt/omv/music/Mixes/FabricMiniMix
#yarn --cwd /home/dietpi/mixcloud-dl -p 1 start fabric_London /mnt/omv/music/Mixes/Fabric

#alternative mixcloud solution
#use this to create list of downloads python3 pymixcloud.py fabric
#youtube-dl -o "/mnt/omv/music/Mixes/FabricMiniMix/%(title)s.%(ext)s" --no-mtime --add-metadata -x --audio-format vorbis --audio-quality 3 --download-archive youtube-dl-archive -a /home/dietpi/mc_list_fabric

#convert files to ogg
/home/dietpi/parpegall.sh /mnt/omv/music/Mixes

#create rss feed of mixes
cd /var/www
python3 /var/www/genRSS.py -r -M -C -v -d podcast/media -H 192.168.1.10 -e ogg -t "Ruperts Mixes Podcast" -p "A Podcast Of All My Mixes" -o feed.rss


#rsync -tvrzu --inplace --password-file /home/dietpi/secret /mnt/674cab58-5a9b-4d7a-826b-a5d30218f232/dietpi_userdata/Music/EM/ prsyncp@192.168.1.8::emix/
#rsync -vr --inplace
