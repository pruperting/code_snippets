#!/bin/bash
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/DnB --pid=m0003l3c --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio "/mnt/omv/music/Mixes/Hit Reset" --pid=m0002zgz --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio "/mnt/omv/music/Mixes/Power Down" --pid=p04m6srg --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio "/mnt/omv/music/Mixes/Chill Mix" --pid=p06kbdcc --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/FocusBeats --pid=p06lkldv --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/TMAM --pid=p071z8z5 --pid-recursive
get-iplayer --type=radio --metadata --thumbnail --tracklist --tag-tracklist --file-prefix="<name> - <episode> - <firstbcastdate>" --outputradio /mnt/omv/music/Mixes/EssentialMix/2020 --pid=b006wkfp --pid-recursive


#rsync -tvrzu --inplace --password-file /home/dietpi/secret /mnt/674cab58-5a9b-4d7a-826b-a5d30218f232/dietpi_userdata/Music/EM/ prsyncp@192.168.1.8::emix/
#rsync -vr --inplace
