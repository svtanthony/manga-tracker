# Manga-Tracker
This is a script to automate searching for manga updates, then sending an email notification when an update is found. This script also includes download functionality.  

##How to use
* To check for *updates* of the tracked manga within `Links`, from the manga-tracker directory within a terminal type:  
`./update.sh`  

* To *download* the images of a specific chapter to most recent chapter type:  
 `./update.sh <MANGA_LINK/Chapter>`  
 
* To *download* all the recent releases of the tracked manga, change the the download enable option in the script. That way when there's an *update*, you will get a notification and download the images as well.  
 `downEn="true"`
 
* To *automate*, look below in the scheduling section.  

The `Links` file we will need at least 3 fields separated by spaces. First we need the name of the manga series to follow. Second we need a chapter value less than or equal to the current chapter. Finally, we need links to the manga hosting websites. It should look something like this.  
```
the-breaker-new-waves 193 http://www.mangahere.co/manga/the_breaker_new_waves http://www.mangapanda.com/the-breaker-new-waves
``` 

##Installation
Install the programs below if not installed. `Ssmtp` for those of us without a mail server. `Mailutils` for the mail functionallity.  

`Ssmtp` is a protocal to send mail from your system, so lets configure it. In the example below we will be using gmail as it is popular and easy to setup. Modify the file with sudo permission `/etc/ssmtp/ssmtp.conf` by adding the following lines: (**The email address and password need to be stored in plain text, as such , it is not recommended to use your email, but rather an email specifically for this purpose.**)

```
mailhub=mailhub=smtp.gmail.com:587  
  
# Use SSL/TLS before negotiation  
UseTLS=YES  
UseSTARTTLS=YES  

# Username/Password  
AuthUser=<GMAIL_USERNAME>  
AuthPass=<GMAIL_PASSWORD>  
```
## Scheduling
To schedule we will use `crontab`, by setting it to run from 7:00 AM to 12:00 AM, every 15 minutes.  
We need to edit our crontab entry (`crontab -e`) by appendeding the following:  

```
# minutes(0-59) hour(0-23) dom(1-31) month(1-12) dow(0-6) command_to_execute
*/15 7-23 * * * /home/user/manga-tracker/update.sh
```

## Supported Sites
Only the following Manga Hosting sites can be used:  
* http://www.mangahere.co  
* http://www.mangatown.com  
* http://www.mangapanda.com  
* http://www.mangareader.net  
* http://mangacow.co/  
* More coming soon
