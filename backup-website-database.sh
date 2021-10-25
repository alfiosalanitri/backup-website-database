#!/bin/bash
#
# NAME
# backup-website-database.sh - create a tar archive with databases and website
#
# SYNOPSIS
#	sudo ./backup-website-database.sh /path/to/example.com/.backup-config
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
printf "Dumping mysql...\n"
mysqldump --no-tablespaces -u$DATABASE_USER -p$DATABASE_PSW $DATABASE_NAME >/tmp/$DATABASE_NAME-dump.sql
if [ -f "${DEST_PATH}backup-*" ]; then
  printf "Deleting preview backup...\n"
  rm ${DEST_PATH}backup-*
fi
printf "Saving new backup...\n"
tar cJfP ${DEST_PATH}backup-$(date +%d%m%Y-%H%M).tar.xz $SOURCE_PATH /tmp/$DATABASE_NAME-dump.sql
printf "Cleaning temp files...\n"
rm /tmp/$DATABASE_NAME-dump.sql
printf "Backup Saved with success!\n"
exit 1
