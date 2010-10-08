#!/bin/bash

BASE_REF_DIR="/usr/local/multimedia/BRAZIL/"
ITEMTYPE_REF_CVS="/usr/local/multimedia/BRAZIL/itemtype.csv"

process_sounds(){
	find . -name "*.*" | grep -ive "sh$" | grep -iv ico_w | grep -iv "info.txt" | grep -ive "dm$" | grep -iv ds_Store | grep -ive "gif$" | grep -iv "properties" | while read sound
	do
		echo "  File: $sound"
		info=`ffmpeg -i "$sound" 2>&1 | grep Audio`
		hz=`echo $info | awk '{print $5}'`
		echo "   hz $hz"
		bitrate=`ffmpeg -i "$sound" 2>&1 | grep bitrate | sed 's/bitrate:/ /g' | awk '{ print $5 }'`
		echo "   bitrate $bitrate"
		md5=`md5sum "$sound" | awk '{print $1}'`
		echo "   md5 $md5"
		#save this stuff in a file
		rm -f $sound".properties"
		echo "md5=$md5" >> $sound".properties"
		echo "bitrate=$bitrate" >> $sound".properties"
		echo "hz=$hz" >> $sound".properties"
	done
}

#
# Enter each sound content folder do stuff...
#
process_songs_folders() {
	cd $BASE_REF_DIR;
	cd songs;
	
	songs_folder=`pwd`
	
	for dir in `ls -1`
	do
		if [ -d $dir ]
			then
			cd $dir
			current_dir=`pwd`
			echo "Songs (content) folder: $current_dir"
			process_sounds $current_dir;
			cd $songs_folder;
		fi
	done
}

process_songs_folders
