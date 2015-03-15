# Manga-Tracker
I like to read manga and I dislike to constantly search updates to the manga series. I'm sure there are many people in my situation. The solution was to read less manga or automate the searching process. With this script the user will receive an email (texts can be encoded as email messages) when one of your favorite manga series update.  

##Installation
Install the `*NIX` packages below if not installed.  
`ssmtp` for those of us without a mail server.  
`mailutils` for the mail functionallity.  

What `ssmtp` simple way of getting mail off a system to your mail hub, so lets configure it. In the example below I will be using gmail as it is popular and easy to setup. Modify the file with sudo permission `/etc/ssmtp/ssmtp.conf` by adding the following lines:

```
mailhub=mailhub=smtp.gmail.com:587  
  
# Use SSL/TLS before negotiation  
UseTLS=YES  
UseSTARTTLS=YES  

# Username/Password  
AuthUser=<GMAIL_USERNAME>  
AuthPass=<GMAIL_PASSWORD>  
```
