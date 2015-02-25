#/bin/bash
#=============================================================================
# Script Name:	update.sh
# Date:			2/25/15
# Purpose:		This script will receive a manga to check and check the links 
#				associated with the manga to check if there's an update.
#=============================================================================
# Usage: this script will require the name of the manga to be passed in.
#=============================================================================
userAgent='Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4'
# check tracked manga
sed 's/[a-z0-9\-\_\.]*@.*//' Contact | sort -u | while read mangaName
do
	latestChp=$(cat Links | grep $mangaName | awk -F ' ' '{print $2}')
	#obtain link in a loop#####################################################################################################################
	link=$(cat Links | grep $mangaName | awk -F ' ' '{print $3}')
	parseName=$(cat Links | grep $mangaName | awk -F ' ' '{print $3}' | sed 's/.*\///g')
	chp=$(wget -q -U $userAgent -O- $link | grep $parseName | head -5 | tail -1 | grep -oE c[0-9]\{1,4\} | sed 's/^c0\?//g')
	
	echo latest chapter is $latestChp
	echo link is $link
	echo parse name = $parseName
	echo chp is $chp
	#if [ $(echo "$chp > $latestChp" | bc) ]
	if [ "$chp" -gt "$latestChp" ]
	then
		echo "UPDATE FOUND"
		#echo "The latest Chapter($chp) of $mangaName has been released" | mail -s "Manga Update" svtanthony@gmail.com
	fi

	echo

done

