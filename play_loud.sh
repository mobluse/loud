#!/bin/bash

# Check if a file argument is provided
if [ -z "$1" ]; then
    echo "Error: Please provide an audio file as an argument."
    echo "Usage: $0 <audio_file>"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist."
    exit 1
fi

# Check if loud_timestamps.txt exists
if [ ! -f "loud_timestamps.txt" ]; then
    echo "Error: loud_timestamps.txt does not exist."
    exit 1
fi

FILE="$1"
DURATION=10  # Duration to play/extract for each segment (in seconds)

# Ensure locale uses dot for decimal point
export LC_NUMERIC=C

# Read timestamps using cat and for loop
for STARTTIME in $(cat loud_timestamps.txt); do

    echo "Processing segment from $STARTTIME seconds for $DURATION seconds"

    # Play the segment with ffplay
    ffplay -i "$FILE" -ss "$STARTTIME" -t "$DURATION" -autoexit &>/dev/null

    # Extract the segment to MP3 with timestamp in filename
    ffmpeg -i "$FILE" -ss "$STARTTIME" -t "$DURATION" -c:a mp3 -y "loud_segment_${STARTTIME}.mp3" &>/dev/null

done
