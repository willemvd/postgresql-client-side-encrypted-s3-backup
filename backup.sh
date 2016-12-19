#!/bin/sh

#exit if one of the commands fail
set -e

DATE=$(date +%Y-%m-%d-%H-%M-%S)

# backup type is used to seperate types like hourly or daily (folders in s3 bucket should be named like that)
#BACKUP_TYPE=

BACKUP_FILE_NAME=$PGDATABASE-backup-$BACKUP_TYPE-$DATE.sql

cd /tmp

echo "Start dumping of database '$PGDATABASE' from '$PGHOST:$PGPORT/$PGDATABASE' with user '$PGUSER' to file '$BACKUP_FILE_NAME'"
START_DUMP=$(date +%s)

# all PostgreSQL settings are set with environment variables
#PGDATABASE=
#PGUSER=
#PGPASSWORD=
#PGHOST=
#PGPORT=
pg_dump --format=custom > $BACKUP_FILE_NAME

DONE_DUMP_IN=$(($(date +%s)-$START_DUMP))
echo "Done dumping ($DONE_DUMP_IN sec) database"

echo ""

# OpenSSL settings
#OPENSSL_CIPHER_TYPE=
#ENCRYPTION_PASS_PHRASE=

ENCRYPTION_FILE_NAME_SUFFIX=.enc

echo "Start encrypting database dump file '$BACKUP_FILE_NAME' with cipher type '$OPENSSL_CIPHER_TYPE' and password as defined in environment variable ENCRYPTION_PASS_PHRASE"
START_ENC=$(date +%s)
openssl enc -in $BACKUP_FILE_NAME -out $BACKUP_FILE_NAME$ENCRYPTION_FILE_NAME_SUFFIX -e -$OPENSSL_CIPHER_TYPE -pass pass:$ENCRYPTION_PASS_PHRASE

DONE_ENC_IN=$(($(date +%s)-$START_ENC))
echo "Done encrypting ($DONE_ENC_IN sec) database dump file, now remove unencrypted file"

rm -f $BACKUP_FILE_NAME

echo ""

echo "Start uploading encrypted '$BACKUP_FILE_NAME' to 's3://$S3_BUCKET_NAME/$BACKUP_TYPE/$BACKUP_FILE_NAME'"
START_UPLOAD=$(date +%s)

# AWS connection settings
#AWS_ACCESS_KEY_ID=
#AWS_SECRET_ACCESS_KEY=
#AWS_DEFAULT_REGION=

# bucket name to upload to
#S3_BUCKET_NAME=
aws s3 cp ./$BACKUP_FILE_NAME$ENCRYPTION_FILE_NAME_SUFFIX s3://$S3_BUCKET_NAME/$BACKUP_TYPE/$BACKUP_FILE_NAME

DONE_UPLOAD_IN=$(($(date +%s)-$START_UPLOAD))
echo "Done uploading ($DONE_UPLOAD_IN sec) 's3://$S3_BUCKET_NAME/$BACKUP_TYPE/$BACKUP_FILE_NAME'"