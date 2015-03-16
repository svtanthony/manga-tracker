#/bin/bash
#=============================================================================
# Script Name:	update.sh
# By:			Roberto A. Pasillas (svtanthony@gmail.com)
# Date:			2/27/15
# Purpose:		This script will send an email if any of the tracked manga have 
#				updated and download the chapter if downloading is enabled. If a 
#				link is passed in, it will download starting from the link to
#				the most recent chapter.
#=============================================================================
# ********************   Config   ********************************************

#email address to send updates to
email="svtanthony@gmail.com"

#set to "true" to download new releases
downEn="false"

# UserAgent is required for some websites to allow connectivity
userAgent='Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4'

#=============================================================================
cd ~/manga-tracker/

if [ -n "$1" ] # check for updates or downlaod manga
then
	echo "download script here"
else
	awk -F ' ' '{print $1}' Links | while read mangaName
	do
		grep $mangaName Links | cut -d " " -f 3- | sed 's/ /\n/g' | while read link
		do 
			latestChp=$(grep $link Links | awk -F ' ' '{print $2}')
			parseName=$(echo $link | sed 's/.*\///g')
	
			# if to determine chp 
			if (echo $link | grep -qiE '(mangahere|mangatown)')
			then
				chp=$(wget -O- -q -U $userAgent $link | grep $parseName | head -5 | tail -1 | grep -oE c[0-9]\{1,4\} | sed 's/^c0\?//g')
			elif (echo $link | grep -qiE '(mangareader|mangapanda|mangastream)')
			then
				chp=$(wget -O- -q -U $userAgent $link | grep $parseName | head -2 | tail -1 | grep -oE [0-9]\{1,4\} | head -1)
			elif (echo $link | grep -qiE '(mangacow)')
			then
				chp=$(wget -O- -q -U $userAgent $link | grep $parseName | head -5 | tail -1 | grep -oE [0-9]\{,4\} | head -1)
			else
				chp=$latestChp
			fi
			
			# actions - Email and Download
			if [ "$chp" -gt "$latestChp" ]
			then
				sed -i "s/$mangaName $latestChp/$mangaName $chp/" Links
				echo "The latest Chapter($chp) of $mangaName has been released.  $link" | mail -s "Manga Update" $email &
				if [ $downEn == "true" ]
				then
					echo extract appropriate link then pass it on.
					#./update $link 
				fi
			fi
		done
	done
fi
