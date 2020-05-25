#!/bin/bash
beet lastimport
beet splupdate
cd /mnt/omv/music/playlists
shopt -s nullglob
for i in *.m3u; do
    cat "$i" | shuf -n 25 -o "/mnt/omv/playlist/$i"
    sed -i 's|FLAC|/storage/547F-11F2/Music/vorbis|g' "/mnt/omv/playlist/$i"
    sed -i 's|.mp3|.ogg|g' "/mnt/omv/playlist/$i"
    sed -i 's|.flac|.ogg|g' "/mnt/omv/playlist/$i"
done
