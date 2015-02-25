#! /bin/bash
#========================================================================
# Script name:	download.sh
# Date:		2/25/15
# Purpose:	Get HTML links to parse for http links and images to   
#			download images until the latest chapter.
#			Script will continue until no more links are available.
#========================================================================
# script requires initial link to be passed in
###########################################################################################
link=$1
###########################################################################################
# set up file saving environment
name=$(echo $link | sed -e 's/.*m\///' -e 's/\/.*//')
cd ~/manga-tracker/
if ( ! (ls ~/manga-tracker | grep -q $name) )
then
	mkdir $name
fi
cd $name

wget -q $link -O $name
link=$(grep -o .*jpg $name | grep -oE href=\"/[0-9]*-*[0-9]*-*[0-9]*/*$name/[chapter-]*[0-9]*[.html]*/*[0-9]* | sed 's/href="//')

while (test -n "$link")
do
	#chapter variable for directory
	chp=$(echo $link | sed -e 's/\/[a-z-]*\///' -e 's/\/.*//' )
	if (! (ls | grep -q $chp))
	then
		mkdir $chp
	fi

	# extract & download pic + run in background
	wget -qP ./$chp/ $(grep -o .*jpg $name | sed 's/.*src=\"//')

	#extract next page
	link=$(grep -o .*jpg $name | grep -oE href=\"/[0-9]*-*[0-9]*-*[0-9]*/*$name/[chapter-]*[0-9]*[.html]*/*[0-9]* | sed 's/href="//')
	wget -q www.mangapanda.com$link -O $name

	#kill loop conditional, so as to not download rubbish
	if test -z $(grep -o .*jpg $name | grep -oE href=\"/[0-9]*-*[0-9]*-*[0-9]*/*$name/[chapter-]*[0-9]*[.html]*/*[0-9]* | sed 's/href="//')
	then
		break
	fi

done
rm "$name"
