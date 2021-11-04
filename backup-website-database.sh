#!/bin/bash
#
# NAME
# backup-website-database.sh - create a tar archive with databases and website
#
# SYNOPSIS
#	- sudo ./backup-website-database.sh /path/to/example.com/.backup-config
# - or
# - sudo ./backup-website-database.sh /path/to/example.com/.backup-config /path/to/example.com/.excluded
#
# DESCRIPTION
# This script dump the database and create a tar archive from source into destination with database e files.
# Require root privileges.
# 
# INSTALLATION
# -`sudo chown -R root: /path/to/example.com`
# -`sudo chmod 600 /path/to/example.com/.backup-config`
# - edit config parameters
# -`sudo chmod 754 /path/to/backup-website-database.sh`
# 
# AUTHOR: 
# backup-website-database.sh is written by Alfio Salanitri www.alfiosalanitri.it and are licensed under the MIT License.
if [ ! -f "$1" ]; then
  printf "Type the full/path/to/.backup-config file\n"
  exit 1
fi
CONFIG_FILE=$1
SOURCE_PATH=$(awk -F'=' '/^SOURCE_PATH=/ { print $2}' $CONFIG_FILE)
DEST_PATH=$(awk -F'=' '/^DEST_PATH=/ { print $2}' $CONFIG_FILE)
DATABASE_NAME=$(awk -F'=' '/^DATABASE_NAME=/ { print $2}' $CONFIG_FILE)
DATABASE_USER=$(awk -F'=' '/^DATABASE_USER=/ { print $2}' $CONFIG_FILE)
DATABASE_PSW=$(awk -F'=' '/^DATABASE_PSW=/ { print $2}' $CONFIG_FILE)
printf "[ ] Dumping mysql...\n"
mysqldump --no-tablespaces -u$DATABASE_USER -p$DATABASE_PSW $DATABASE_NAME >/tmp/$DATABASE_NAME-dump.sql
printf "[x] Database saved!\n\n"
if ls ${DEST_PATH}backup-*.tar.xz &>/dev/null 
then
  printf "[ ] Deleting previews backup...\n"
  rm ${DEST_PATH}backup-*
  printf "[x] Previews backup deleted.\n\n"
fi
printf "[ ] Saving new backup...\n"
# check files or folder to exclude
if [ -z "$2" ]; then
  tar cJfP ${DEST_PATH}backup-$(date +%d%m%Y-%H%M).tar.xz $SOURCE_PATH /tmp/$DATABASE_NAME-dump.sql
else
  # check if excluded file exists
  if [ ! -f "$2" ]; then
    printf "Sorry, but %s file doesn't exists.\n" $2
    exit 1
  fi
  tar cJfP ${DEST_PATH}backup-$(date +%d%m%Y-%H%M).tar.xz -X $2 $SOURCE_PATH /tmp/$DATABASE_NAME-dump.sql
fi
printf "[x] Backup file saved.\n\n"
printf "[ ] Cleaning temp files...\n"
rm /tmp/$DATABASE_NAME-dump.sql
printf "[x] Temp files deleted.\n\n\n"
printf "Backup completed with success!\n"
exit 1
