#!/bin/bash
# single_camcap.sh: captures video from an online stream
# Authors: Vahid Bastani
#
# Dependencies: timeout, sed, ffmpeg
# Syntax: ./single_camcap.sh stream_url [duration] [stream_format]
#   strem_url: the address of the video stream.
#   duration: capturing time in second (default is 30).
#   stream_format: video format of the stream (e.g. mjpeg). If not provided,
#                  ffmpeg tries to infer the format. However it may fail.
#  The script makes a directory in current directory with same name as
# stream_url (non alphanumerical characters are substituted with '_'. The
# captured video as well as ffmpeg log will be saved in the generated directory.
# File names are the execution time of the script.

# check first argument
if [ -z "$1" ]; then
   echo -e "\e[31mNo url supplied. \e[0mfirst argument should be url for video stream."
   exit 1
fi

link=$1

# check second argument
duration="30"

if [ -z "$2" ]; then
   echo "duration is not specified. default duration of $duration is taken."
else
   duration=$2
fi

#check if format is specified
input_format=""
if [ ! -z "$3" ]; then
   input_format="-f $3"
fi

echo "Recording from $link for $duration seconds"

# extract directory name from url
directory="videos_$(echo $1 | sed -e 's,^[A-Za-z]*://,,g' -e 's,[A-Za-z0-9_]*:[A-Za-z0-9_]*@,,g' -e 's,/,_,g' -e 's,?,_,g' -e 's,:,_,g' -e 's,=,_,g')"

# file name is current time
name="`date +%Y-%m-%d_%H.%M`"

echo "file name: $name"
echo "directory name: $directory"

# make directory if it does not exist
if [ ! -d $directory ]; then
   echo "making directory '$directory'"
   mkdir $directory
else
   echo "directory '$directory' already exist, file will be written there"
fi

filepath=$directory/$name.mp4
logpath=$directory/$name.log

timeout --foreground $duration ffmpeg -hide_banner $input_format -i $link -vcodec copy -an $filepath 2> $logpath
