#!/bin/bash
CONFIG_FILE=$1
SOURCE_PATH=$(awk -F'=' '/^SOURCE_PATH=/ { print $2}' $CONFIG_FILE)
DEST_PATH=$(awk -F'=' '/^DEST_PATH=/ { print $2}' $CONFIG_FILE)
DATABASE_NAME=$(awk -F'=' '/^DATABASE_NAME=/ { print $2}' $CONFIG_FILE)
DATABASE_USER=$(awk -F'=' '/^DATABASE_USER=/ { print $2}' $CONFIG_FILE)
DATABASE_PSW=$(awk -F'=' '/^DATABASE_PSW=/ { print $2}' $CONFIG_FILE)
printf "Esportazione database in corso...\n"
mysqldump --no-tablespaces -u$DATABASE_USER -p$DATABASE_PSW $DATABASE_NAME > /tmp/$DATABASE_NAME-dump.sql
printf "Rimozione precedenti backup in corso...\n"
rm ${DEST_PATH}backup-*
printf "Creazione backup in corso...\n"
tar cJfP ${DEST_PATH}backup-$(date +%d%m%Y-%H%M).tar.xz $SOURCE_PATH /tmp/$DATABASE_NAME-dump.sql
printf "Completamento operazione...\n"
rm /tmp/$DATABASE_NAME-dump.sql
printf "Backup eseguito con successo\n"
exit 1
