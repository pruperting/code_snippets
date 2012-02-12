#!/bin/bash
echo mkvmerge.sh started on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/trans.log
VIDEO=$1
ENC=${VIDEO##*/}
mkvmerge --chapters "${VIDEO%/*}/${ENC%%.*}.ts.chap" "$VIDEO" -o "/mnt/media/documents/ruperts/TV/${ENC%%.*}.mkv"
