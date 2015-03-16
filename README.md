# Manga-Tracker
I enjoy reading manga; however I dislike to constantly search for updates to the manga series. The solution was to either read less manga or automate the searching process. And you guessed correctly, the serching process is now automated. With this script the user will receive an email (text messages can be encoded as email messages) when one of your favorite manga series update.  

##How to use
In the ***Links*** file we will need at least 3 fields separated by spaces. First we need a name of the manga series to follow. Second we need a chapter value less than or equal to the current chapter. Finally, we need links to the manga hosting websites. It should look something like this.  
```
the-breaker-new-waves 193 http://www.mangahere.co/manga/the_breaker_new_waves http://www.mangapanda.com/the-breaker-new-waves
```
* To check for *updates* of the tracked manga within ***Links***, from the manga-tracker directory within a terminal type:  
`./update.sh`  

* To *download* the images of a specific chapter to most recent chapter type:  
 `./update.sh <MANGA_LINK/Chapter>`  
 
* To *download* all the recent releases of the tracked manga, change the the download enable option in the script. That way when there's an *update*, you will get a notification and download the images as well.  
 `downEn="true"`
 
* To *automate*, look below in the scheduling section.  
 
##Installation
Install the `*NIX` packages below if not installed.  
`ssmtp` for those of us without a mail server.  
`mailutils` for the mail functionallity.  

 `ssmtp` simple way of getting mail off a system to your mail hub, so lets configure it. In the example below we will be using gmail as it is popular and easy to setup. Modify the file with sudo permission `/etc/ssmtp/ssmtp.conf` by adding the following lines:

```
mailhub=mailhub=smtp.gmail.com:587  
  
# Use SSL/TLS before negotiation  
UseTLS=YES  
UseSTARTTLS=YES  

# Username/Password  
AuthUser=<GMAIL_USERNAME>  
AuthPass=<GMAIL_PASSWORD>  
```
####Scheduling
To schedule we will use `crontab`, by setting it to run from 7:00 AM to 12:00 AM, every 15 minutes.  
A crontab entry consists of the following:  
`minutes(0-59) hour(0-23) day_of_month(1-31) month(1-12) day_of_week(0-6) command_to_execute`

We need to edit our crontab entry (`crontab -e`) by appendeding the following:  
```
*/15 7-23 * * * /home/user/manga-tracker/update.sh
```

## Limitations
Only the following Manga Hosting sites can be used:  
* http://www.mangahere.co  
* http://www.mangatown.com  
* http://www.mangapanda.com  
* http://www.mangareader.net  
* http://mangacow.co/  
* More coming soon
