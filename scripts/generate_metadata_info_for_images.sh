#!/bin/bash

BASE_REF_DIR="/usr/local/multimedia/BRAZIL/"
ITEMTYPE_REF_CVS="/usr/local/multimedia/BRAZIL/itemtype.csv"

#
# Generate a file: biggest_images.properties
# This file will contain only the biggest images per content folder
#  the images are checked based on filename of the ICO_WEB

get_biggest_images_for_content() {
	content_dir="$1"
	biggest_images_file="$content_dir/biggest_images.properties"
	
#	if [ ! -e $biggest_images_file ]
#		then
			ls -1 ICO_WEB* | while read ico_img
			do
				ref_name=`echo "$ico_img" | sed 's/\./ /g' | awk '{print $1}' | sed 's/ICO_WEB_/ /g' | awk '{print $1}'`
				biggest_img=`ls | grep "$ref_name" | grep -ivh ICO_W | grep -iv "*.dm"| grep -ivh INFO | grep -ivh THUMBS | grep -ivh PREVIEW | grep -e "^[0-9]\{3\}X[0-9]\{3\}*" | sort -r | head -n 1`
				echo "  Biggest image found: $biggest_img"
				md5=`md5sum "$content_dir/$biggest_img" | awk '{print $1}'`
				rm -f $biggest_images_file
				echo "$ref_name=$biggest_img;$md5" >> $biggest_images_file
			done
#		else
#			echo "$biggest_images_file already exist, skiping... "
#	fi
}

#
# Enter each image content folder do stuff...
#
process_image_folders() {
	cd $BASE_REF_DIR;
	cd images;
	
	images_folder=`pwd`
	
	for dir in `ls -1`
	do
		if [ -d $dir ]
			then
			cd $dir
			current_dir=`pwd`
			echo "Images (content) folder: $current_dir"
			get_biggest_images_for_content $current_dir;
			cd $images_folder;
		fi
	done
}

process_image_folders
