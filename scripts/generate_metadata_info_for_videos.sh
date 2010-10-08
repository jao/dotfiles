#!/bin/bash

BASE_REF_DIR="/usr/local/multimedia/BRAZIL/"
ITEMTYPE_REF_CVS="/usr/local/multimedia/BRAZIL/itemtype.csv"

process_videos(){	
	find . -name "*.*" | grep -ive "sh$" | grep -iv ico_w | grep -iv "info.txt" | grep -ive "dm$" | grep -iv ds_Store | grep -ive "gif$" | grep -iv "properties" | while read video
	do
		echo "  File: $video"
		md5=`md5sum "$video" | awk '{print $1}'`
		echo "   md5 $md5"
		#save this stuff in a file
		rm -f $video".properties"
		echo "md5=$md5" >> $video".properties"
	done
}

#
# Enter each video content folder do stuff...
#
process_videos_folders() {
	cd $BASE_REF_DIR;
	cd videos;
	
	videos_folder=`pwd`
	
	for dir in `ls -1`
	do
		if [ -d $dir ]
			then
			cd $dir
			current_dir=`pwd`
			echo "Videos (content) folder: $current_dir"
			process_videos $current_dir;
			cd $videos_folder;
		fi
	done
}

process_videos_folders
