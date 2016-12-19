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
```
