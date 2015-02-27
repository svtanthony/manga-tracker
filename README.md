# manga-tracker
manga update tracking through bash scripts

## Required
`ssmtp`
`mailutils`
`Linux`
##ssmtp
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
