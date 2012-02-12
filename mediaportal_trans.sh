#!/bin/bash
# Written by FakeOutdoorsman and updated by mysoogal further updated by prupert
# Attribution-Noncommercial 3.0 Unported
# http://creativecommons.org/licenses/by-nc/3.0/deed.en
# trackback http://ubuntuforums.org/showthread.php?t=960627
echo trans.sh started on `date "+%m/%d/%y %l:%M:%S %p"` > /mnt/media/documents/ruperts/TV/trans.log
find /mnt/media/documents/ruperts/TV -name "*.ts" >> /mnt/media/documents/ruperts/TV/trans.log
chmod -R 777 /mnt/media/documents/ruperts/TV
find /mnt/media/documents/ruperts/TV -name "*.ts" -exec /home/server/Desktop/handbrake/HandBrakeCLI -i {} -t 1 -c 1 -o {}.mkv -f mkv -e xvid -b 1200 -2  -a 1 -E faac -B 160 -R 0 -6 dpl2 -D 1 -C 2  -v '{}' \; >> /mnt/media/documents/ruperts/TV/trans.log
echo trans.sh finished on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/trans.log
echo attempting to add advert chapter markers on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/trans.log
find /mnt/media/documents/ruperts/TV -name "*.mkv" -exec /home/server/scripts/mkvmerge.sh "{}" \; >> /mnt/media/documents/ruperts/TV/trans.log
echo advert chapter markers added on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/trans.log
echo starting clear up on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/trans.log
cd "/mnt/media/documents/ruperts/TV/" || { echo >&2 "Source folder not found"; exit 1; } >> /mnt/media/documents/ruperts/TV/trans.log
find . -type f -name "*.ts" -exec sh -c '[ -f "${1%.ts}.ts.mkv" ]' _ {} \; -delete >> /mnt/media/documents/ruperts/TV/trans.log
find . -type f -name "*.ts" -exec sh -c '[ -f "${1%.ts}.mkv" ]' _ {} \; -delete >> /mnt/media/documents/ruperts/TV/trans.log
find . -type f -name "*.ts.mkv" -exec sh -c '[ -f "${1%.ts.mkv}.mkv" ]' _ {} \; -delete >> /mnt/media/documents/ruperts/TV/trans.log
find . -type f -name "*.ts.chap" -exec sh -c '[ -f "${1%.ts.chap}.mkv" ]' _ {} \; -delete >> /mnt/media/documents/ruperts/TV/trans.log
find /mnt/media/documents/ruperts/TV -name "*.mkv" -exec mv {} /media/video/Video \; >> /mnt/media/documents/ruperts/TV/trans.log
find /mnt/media/documents/ruperts/TV -name "*.edl" -exec rm {} \; >> /mnt/media/documents/ruperts/TV/trans.log
find /mnt/media/documents/ruperts/TV -name "*.txt" -exec rm {} \; >> /mnt/media/documents/ruperts/TV/trans.log
echo ts files deleted and moved script stopped on `date "+%m/%d/%y %l:%M:%S %p"` >> /mnt/media/documents/ruperts/TV/trans.log
