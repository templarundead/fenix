#!/usr/bin/env bash

f_optimize () {
	# Create folder 'image' to save optimized images
	mkdir image
	# List all .jpg file in current folder
	ls | grep jpg > list.txt
	# Read file list.txt and optimize each image
	while read -r line
	do
		mozjpeg -optimize -progressive -copy none "$line" > image/"$line"
	done < list.txt
	# Remove file list.txt after finish optimize
	rm -f list.txt
}
# Main function
f_main () {
	f_optimize
}
f_main
# Exit script
exit
