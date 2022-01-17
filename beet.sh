#!/bin/bash
sudo mount -a
cd /mnt/omv/ogg
cd /home/dietpi
python3 /usr/local/bin/beet lastimport
python3 /usr/local/bin/beet lastupdate
python3 /usr/local/bin/beet splupdate
cd /mnt/omv/music/playlists
shopt -s nullglob
for i in *.m3u; do
    cat "$i" | shuf -n 50 -o "/mnt/omv/music/playlists/$i"
    #sed -i 's|FLAC|/srv/dev-disk-by-label-data/Music/FLAC|g' "/mnt/omv/music/playlists/$i"
    if grep -q "/srv/dev-disk-by-label-data/Music/FLAC" "$i"
        then
            # code if found
            echo "Found"
        else
            # code if not found
            sed -i 's|FLAC|/srv/dev-disk-by-label-data/Music/FLAC|g' "/mnt/omv/music/playlists/$i"
    fi
done
shopt -s nullglob
for i in *.m3u; do
    cat "$i" | shuf -n 50 -o "/mnt/omv/playlist/$i"
    if grep -q "/storage/3133-3664/Music/vorbis" "$i"
        then
            # code if found
            echo "Found"
        else
            # code if not found
            sed -i 's|/srv/dev-disk-by-label-data/Music/FLAC|/storage/3133-3664/Music/vorbis|g' "/mnt/omv/playlist/$i"
            sed -i 's|.mp3|.ogg|g' "/mnt/omv/playlist/$i"
            sed -i 's|.flac|.ogg|g' "/mnt/omv/playlist/$i"
    fi
done
/home/dietpi/.local/bin/garpy download -u USER -p PASSWORD /mnt/sda/g/garpy
acxi
exit
