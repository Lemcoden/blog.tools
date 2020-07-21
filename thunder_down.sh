#!/bin/bash

function thunder_download(){
	export thunder_urls=""
	export down_url=""
	export dest_dir=""	
	while [ -n "$1" ]
	do
		case $1 in
			-h) thunder_help;return;;
			-f) 
				thunder_urls=`cat $2`
				shift 2
			;;
			-d)
			       	dest_dir=$2
				shift 2
			;; 
			--) shift;break;; # end of options
			*)  break;;
		esac
	done

	for thunder_url in $@ $thunder_urls
	do
	down_url=`echo $thunder_url | awk -Fthunder:// '{print $2}' | base64 -d | awk -FAA '{print $2}' | awk -FZZ '{print $1}' `
	down_urls="$down_urls $down_url"
	done
	
	if [ -n "$dest_dir" ] 
	then	
      	wget $down_urls -P $dest_dir 
	else 
	wget $down_urls 
	fi

}

function thunder_help(){
	echo "
		usage:thunder_down [option] files and download urls
		-f, the download urls' file	
		-d, the destation down directory
		-h, the help 
	"
}
thunder_download $*  
