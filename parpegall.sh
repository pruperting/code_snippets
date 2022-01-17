#!/bin/bash

SOURCE_DIR="$1"

export SOURCE_DIR

doone() {
    inFile="$1"
    outFile="${inFile%.*}.ogg"
    if [ ! -f "$outFile" ]; then # If the mp3 file doesn't exist already
        ffmpeg -i "$inFile"  -c:a libvorbis -q:a 4 "$outFile"
        RC=$?
        if [ "${RC}" -ne "0" ]; then
            # Do something to handle the error.
            echo "$inFile" >> /home/dietpi/parpegerror.log
            /bin/rm -f "$outFile"
        else
            #here we delete the file
            /bin/rm -f "$inFile"
        fi
    fi
}

export -f doone

doEG() {
    inFile="$1"
    outFile="${inFile%.*}.ogg"
    if [ ! -f "$outFile" ]; then # If the mp3 file doesn't exist already
        egfile="$inFile.txt"
        egtitle=$(awk -F"title@  " '/title@  /{print $2}' "$egfile")
        IFS=' ' read -r id egartist <<< "$egtitle"
        egpath="${outFile%/*}"
        egoutFile="$egpath/$egtitle.ogg"
        ffmpeg -i "$inFile"  -c:a libvorbis -q:a 4 -metadata artist="$egartist" -metadata title="$egtitle" -metadata album="Electronic Groove" "$egoutFile"
        RC=$?
        if [ "${RC}" -ne "0" ]; then
            # Do something to handle the error.
            echo "$inFile" >> /home/dietpi/parpegerror.log
            /bin/rm -f "$egoutFile"
        else
            #here we delete the file
            /bin/rm -f "$inFile"
        fi
    fi
}

export -f doEG

doCW() {
    inFile="$1"
    outFile="${inFile%.*}.ogg"
    if [ ! -f "$outFile" ]; then # If the mp3 file doesn't exist already
        egfile="$inFile.txt"
        egdesc=$(sed -n '/^description@$/{n;h;b};H;${x;p}' "$egfile")
        ffmpeg -i "$inFile"  -c:a libvorbis -q:a 4 -metadata comment="$egdesc" "$outFile"
        RC=$?
        if [ "${RC}" -ne "0" ]; then
            # Do something to handle the error.
            echo "$inFile" >> /home/dietpi/parpegerror.log
            /bin/rm -f "$outFile"
        else
            #here we delete the file
            /bin/rm -f "$inFile"
        fi
    fi
}

export -f doCW

doFACT() {
    inFile="$1"
    outFile="${inFile%.*}.ogg"
    if [ ! -f "$outFile" ]; then # If the mp3 file doesn't exist already
        ffmpeg -i "$inFile"  -c:a libvorbis -q:a 4 -metadata album="FACT Mix" "$outFile"
        RC=$?
        if [ "${RC}" -ne "0" ]; then
            # Do something to handle the error.
            echo "$inFile" >> /home/dietpi/parpegerror.log
            /bin/rm -f "$outFile"
        else
            #here we delete the file
            /bin/rm -f "$inFile"
        fi
    fi
}

export -f doFACT

doLNOE() {
    inFile="$1"
    outFile="${inFile%.*}.ogg"
    if [ ! -f "$outFile" ]; then # If the mp3 file doesn't exist already
        egfile="$inFile.txt"
        egdesc=$(sed -n '/^description@$/{n;h;b};H;${x;p}' "$egfile")
        slimoutFile=$(sed 's/-[^.]*././g' <<< "$outFile")
        ffmpeg -i "$inFile"  -c:a libvorbis -q:a 4 -metadata artist="Sasha" -metadata album="LNOE" -metadata comment="$egdesc" "$slimoutFile"
        RC=$?
        if [ "${RC}" -ne "0" ]; then
            # Do something to handle the error.
            echo "$inFile" >> /home/dietpi/parpegerror.log
            /bin/rm -f "$outFile"
        else
            #here we delete the file
            /bin/rm -f "$inFile"
        fi
    fi
}

export -f doLNOE

choosedo () {
    file="$1"
    path="${file%/*}"
    EG="/mnt/omv/music/Mixes/ElectronicGroove"
    CW="/mnt/omv/music/Mixes/Coldwired"
    FACT="/mnt/omv/music/Mixes/FACT"
    FACTA="/mnt/omv/music/Mixes/FACTArchive"
    LNOE="/mnt/omv/music/Mixes/LNOE"
 
    if [ "$path" == "$EG" ]; then
        echo "Electronic Groove"
        doEG "$file"
    elif [ "$path" == "$CW" ]; then
        echo "Coldwired"
        doCW "$file"
    elif [ "$path" == "$FACT" ]; then
        echo "FACT"
        doFACT "$file"
    elif [ "$path" == "$FACTA" ]; then
        echo "FACTA"
        doFACT "$file"
    elif [ "$path" == "$LNOE" ]; then
        echo "LNOE"
        doLNOE "$file"
    else
        doone "$file"
    fi
}

export -f choosedo

# Find all flac/wav files in the given SOURCE_DIR and iterate over them:
find "${SOURCE_DIR}" -type f \( -iname "*.mp3" -or -iname "*.m4a" \) -print0 |
  parallel -0 -j3 --bar --eta choosedo

exit
