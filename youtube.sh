#!/bin/bash
#Youtube video mp3 extractor using youtube-dl

#Reads the videos url
read -p "VIDEO's URL: " url

if [ ! -d "Music" ]; then
    echo "Creating Music folder..."
    mkdir "Music"
fi

#Change directory to Music folder
echo "Going to Music folder..."
cd && cd Music/

# converts and saves youtube's video mp3 in the music directory 
youtube-dl --restrict-filenames --extract-audio --audio-format mp3 --output "%(title)s.%(ext)s" $url

echo "Done"