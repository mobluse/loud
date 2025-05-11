#!/bin/bash

VERBOSE=1  # Default: verbose output

while getopts "q" opt; do
    case $opt in
        q) VERBOSE=0 ;;  # Quiet mode
    esac
done
shift $((OPTIND-1))

if [ -z "$1" ]; then
    echo "Error: Please provide an audio file as an argument."
    echo "Usage: $0 [-q] <audio_file>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist."
    exit 1
fi

FILE="$1"

ffmpeg -i "$FILE" -af "silencedetect=noise=-20dB:d=0.5" -f null - 2> silencedetect.txt
sed 's/\r/\n/g;s/\n$//' silencedetect.txt | awk '/silence_end/ {print $5-5}' > loud_timestamps.txt

if [ $VERBOSE -ne 0 ]; then
    cat loud_timestamps.txt
fi
