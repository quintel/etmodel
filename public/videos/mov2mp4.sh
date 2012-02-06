#!/bin/sh


# ffmpeg options
# -y               -> overwrite output file
# -i XXX          -> input file
# -s WWWxHHH      -> width and height
# -b 384k         -> output bitrate
# -vcodec libx264 -> video codec
# -flags          -> ???
# +loop+mv4       -> ???
# -cmp 256        -> ???
# see http://rodrigopolo.com/ffmpeg/cheats.html
# ffmpeg -i video_source_file.ext -vcodec libx264 -vpre hq -vpre ipod640 -b 250k -bt 50k -acodec libfaac -ab 56k -ac 2 -s 480x320 video_out_file.mp4
# http://stackoverflow.com/questions/3119797/ffmpeg-settings-for-converting-to-mp4-and-ogg-for-html5-video

# to batch run this script with zsh:
#
# for f in *.mov; do ./mov2mp4.sh $f; done
#
# to batch rename:
#
# autoload -U zmv
# zmv '(*).mov.ogv' '$1.ogv'


ffmpeg -y -i "$1" \
-s 516x296 -r 30000/1001 -b 200k -bt 240k -vcodec libx264 -vpre ipod320 -acodec libfaac -ac 2 -ar 48000 -ab 192k \
"$1.mp4"
# -s 320x240 -r 30000/1001 -b 200k -bt 240k -vcodec libx264 -vpre ipod320 -acodec libfaac -ac 2 -ar 48000 -ab 192k
ffmpeg2theora "$1.mp4" "$1.ogv"

