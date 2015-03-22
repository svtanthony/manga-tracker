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
# ========================================= DOWNLOAD =====================================================================
	# intial parameter passed to function
	link=$1
	userAgent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4"

	# obtain name of series & image url
	if (echo $link | grep -qiE '(mangahere|mangatown)')
	then
		name=$(echo "$link" | sed -e 's/.*manga\///g' -e 's/\/.*//g')
		download=$(wget -qO- -U $userAgent $link | grep .*.jpg | head -2 | tail -1 | grep -o http.*.jpg)
	elif (echo $link | grep -qi 'mangapanda')
	then
		name=$(echo  $link | sed -e 's/.*m\///' -e 's/\/.*//')
		download=$(wget -qO- $link | grep -o .*jpg | sed 's/.*src=\"//' | tail -1)
	elif (echo $link | grep -qi 'mangareader')
	then
		name=$(echo  $link | sed -e 's/.*t\///' -e 's/\/.*//g')
		download=$(wget -qO- $link | grep -o .*jpg | sed 's/.*src=\"//' | tail -1)
	elif (echo $link | grep -qi 'mangacow')
	then
		name=$(echo  $link | sed -e 's/.*o\///' -e 's/\/.*//g')
		download=$(wget -qO- $link | sed 's/;/\n/g'| grep -o .*jpg | sed 's/.*src=\"//' | tail -2 | head -1 )
	fi

	# cd to manga-tracker & create download directory
	cd ~/manga-tracker/
	if ( ! (ls ~/manga-tracker | grep -q $name) )
	then
		mkdir $name
	fi
	cd $name


	while (test -n $link -a -n $download)
	do
	
		#chapter variable for directory
		if (echo $link | grep -qiE '(mangahere|mangatown)')
		then
			chp=$(echo "$link" | sed -e "s/.*$name\///g" -e 's/[a-zA-Z]*//g' -e 's/^0//g' -e 's/\/.*//g')
		elif (echo $link | grep -qi 'mangapanda')
		then
			chp=$(echo  $link | sed -e "s/.*$name\///g" -e 's/\/.*//')
		elif (echo $link | grep -qi 'mangareader')
		then
			chp=$(echo  $link | sed -e "s/.*$name\///g" -e 's/\/.*//')
		elif (echo $link | grep -qi 'mangacow')
		then
			chp=$(echo  $link | sed -e "s/.*$name\///g" -e 's/\/.*//')
		fi

		#create a folder for images
		if (! (ls | grep -q $chp))
		then
			mkdir $chp
		fi

		# download image
		wget -U $userAgent -qP ./$chp/ $download 

		# update urls
		if (echo $link | grep -qiE '(mangahere|mangatown)')
		then
			tempLink=$link
			link=$(wget -qO- -U $userAgent $link | grep next_page | tail -1 | grep -o http.*html)
			if ( test -z "$link" )
			then
				link=$(wget -qO- -U $userAgent $tempLink | grep "Next Chapter" | sed -e 's/Previous.*//g' -e 's/.*href="//g' -e 's/\/".*//')
			fi
			download=$(wget -qO- -U $userAgent $link | grep .*.jpg | head -2 | tail -1 | grep -o http.*.jpg)
		elif (echo $link | grep -qi 'mangapanda')
		then
			link=www.mangapanda.com$(wget -qO- $link | grep -oE href=\"/[0-9]*-*[0-9]*-*[0-9]*/*$name/[chapter-]*[0-9]*[.html]*/*[0-9]* | sed 's/href="//' | head -3 | tail -1)
			if [ "$link" == "www.mangapanda.com" ]
			then
				link=""
			fi
			download=$(wget -qO- $link | grep -o .*jpg | sed 's/.*src=\"//' | tail -1 | grep $name)
		elif (echo $link | grep -qi 'mangareader')
		then
			link=www.mangareader.net$(wget -qO- $link | grep -oE href=\"/[0-9]*-*[0-9]*-*[0-9]*/*$name/[chapter-]*[0-9]*[.html]*/*[0-9]* | sed 's/href="//' | head -3 | tail -1)
			if [ "$link" == "www.mangareader.net" ]
			then
				link=""
			fi
			download=$(wget -qO- $link | grep -o .*jpg | sed 's/.*src=\"//' | tail -1 | grep $name)
		elif (echo $link | grep -qi 'mangacow')
		then
			link=$(wget -qO- $link | sed 's/;/\n/g' | grep "wpm_nav_nxt =" | sed -e 's/.* = "//g' -e 's/\/"//g')
			download=$(wget -qO- $link | grep -o .*jpg | sed 's/.*src=\"//' | tail -1)
		fi

		if test -z $(echo "$download" | grep ^h)
		then
			break
		fi
	done
#===================================================== UPDATE ===================================================================
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
