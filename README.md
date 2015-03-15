# Manga-Tracker
Receive a message when one of your favorite manga series have updated.

##Installation
Install the packages below if not installed. 
`ssmtp`  
`mailutils`  
`Linux`  

####Mail Server
Since this script will send an email make sure you have an email server!
or install the `ssmtp` package.

modify the file `/etc/ssmtp/ssmtp.conf`

`mailhub=mailhub=smtp.gmail.com:587`

add these lines
`# Use SSL/TLS before negotiation`
`UseTLS=YES`
`UseSTARTTLS=YES`

add these lines
`# Username/Password`
`AuthUser=<USERNAME>`
`AuthPass=<PASSWORD>`
