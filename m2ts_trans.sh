#!/bin/bash
echo transm2ts.sh started on `date "+%m/%d/%y %l:%M:%S %p"` > /mnt/media/documents/ruperts/TV/transm2ts.log
find /mnt/media/documents/ruperts/TV -name "*.m2ts" >> /mnt/media/documents/ruperts/TV/transm2ts.log
chmod -R 777 /mnt/media/documents/ruperts/TV
find /mnt/media/documents/ruperts/TV -name "*.m2ts" -exec /home/server/Desktop/handbrake/HandBrakeCLI -i {} -t 1 -c 1 -o {}.mkv -f mkv -w 720 -e xvid -b 1200 -2 -a 1 -E faac -B 160 -R 0 -6 dpl2 -D 1 -C 2 -v '{}' \; >> /mnt/media/documents/ruperts/TV/transm2ts.log
echo transm2ts.sh finished on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/transm2ts.log
echo starting clear up on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/transm2ts.log
cd "/mnt/media/documents/ruperts/TV/" || { echo >&2 "Source folder not found"; exit 1; } >> /mnt/media/documents/ruperts/TV/transm2ts.log
find . -type f -name "*.m2ts" -exec sh -c '[ -f "${1%.m2ts}.m2ts.mkv" ]' _ {} \; -delete >> /mnt/media/documents/ruperts/TV/transm2ts.log
find . -type f -name "*.m2ts" -exec sh -c '[ -f "${1%.m2ts}.mkv" ]' _ {} \; -delete >> /mnt/media/documents/ruperts/TV/transm2ts.log
find /mnt/media/documents/ruperts/TV -name "*.mkv" -exec mv {} /media/video/Video/TV \; >> /mnt/media/documents/ruperts/TV/transm2ts.log
echo m2ts files deleted and moved script stopped on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/transm2ts.log
exit


