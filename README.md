# PostgreSQL, client-side encrypted, Amazon S3 backupper

Docker image that is used to backup a PostgreSQL database, encrypt the dump file locally and upload to a S3 bucket.
Your own settings define how secure you want it to be :)

Import difference with other PostgreSQL to S3 backup tools is **client-side encryption**.
This means that it is not necessary to send any unencrypted data towards Amazon 

The following (required) environment variables need to be set in order to run everything smoothly:

```properties
# Used in the backup file name 
# and to place the file inside a subfolder of the S3 bucket
BACKUP_TYPE=<type of backup, should also be a folder/key in the S3 bucket>

# PostgreSQL settings
PGHOST=<database hostname>
PGPORT=<port of the database server, default 5432>
PGDATABASE=<database name>
PGUSER=<database user>
PGPASSWORD=<database password>

# OpenSSL settings
ENCRYPTION_PASS_PHRASE=<strong password>
OPENSSL_CIPHER_TYPE=<strong cipher like aes-256-cbc>

# Amazon settings
AWS_ACCESS_KEY_ID=<access key id got from Amazon>
AWS_SECRET_ACCESS_KEY=<secret access key got from Amazon>
AWS_DEFAULT_REGION=<Amazon region name e.g. eu-central-1>
S3_BUCKET_NAME=<name of the bucket in S3>

# Email settings
ENABLE_ERROR_MAIL=<should an email be send when something goes wrong? other then true will disable this>
ERROR_MAIL_SUBJECT=<subject of the mail, e.g. Failed to run database backup>
SMTP_HOST=<SMTP host e.g. smtp.office365.com>
SMTP_PORT=<SMTP port number, mostly 587 or 25>
SMTP_STARTTLS=<should TLS be used? other then true will disable this>
SMTP_AUTH=<type of auth, login>
SMTP_AUTH_USER=<username to login to the SMTP server>
SMTP_AUTH_PASSWORD=<password for the SMTP user>
SMTP_FROM=<name and email of the sender in the format: Name <full email adres> >
SMTP_TO=<email address to send to, multiple addresses can be used with a comma seperated list>
```
