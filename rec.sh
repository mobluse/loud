#!/bin/bash

shift $((OPTIND-1))

if [ -z "$1" ]; then
    echo "Error: Please provide an audio file and a duration as arguments."
    echo "Usage: $0 <audio_file> <duration>"
    exit 1
fi

FILE="$1"
DURATION=${2:-3}

ffmpeg -f alsa -i hw:3,0 -ac 1 -t $DURATION -c:a mp3 "$FILE"
