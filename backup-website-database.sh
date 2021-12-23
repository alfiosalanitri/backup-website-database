#!/bin/bash
#
# NAME
# backup-website-database.sh - create a tar archive with database dump and website files
#
# SYNOPSIS
#	- /path/to/backup-website-database.sh /path/to/backups/example.com/.backup-config
#
# DESCRIPTION
# This script dump the database and create a tar archive from source into destination with database e files.
# To exclude files or directory: create an .excluded file with files and directories list (one for line) into backup
# destination directory.
# 
# INSTALLATION
# -`sudo chown -R root: /path/to/backups/example.com` (optional to secure database and user password)
# -`sudo chmod 600 /path/to/backups/example.com/.backup-config` (optional to secure database and user password)
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
EXCLUDED=''
#if .excluded file exists into backup destination directory
if [ -f "${DEST_PATH}.excluded" ]; then
  EXCLUDED="-X ${DEST_PATH}.excluded"
fi
DATABASE_NAME=$(awk -F'=' '/^DATABASE_NAME=/ { print $2}' $CONFIG_FILE)
DATABASE_USER=$(awk -F'=' '/^DATABASE_USER=/ { print $2}' $CONFIG_FILE)
DATABASE_PSW=$(awk -F'=' '/^DATABASE_PSW=/ { print $2}' $CONFIG_FILE)
echo "--- Step 1/4 ---"
printf "[ ] Dumping mysql...\n"
mysqldump --no-tablespaces -u$DATABASE_USER -p$DATABASE_PSW $DATABASE_NAME > /tmp/$DATABASE_NAME-dump.sql
printf "[x] Database saved!\n"
echo "----------------"
echo ""
echo "--- Step 2/4 ---"
if ls ${DEST_PATH}backup-*.tar.xz &>/dev/null 
then
  printf "[ ] Deleting previews backup...\n"
  rm ${DEST_PATH}backup-*
  printf "[x] Previews backup deleted.\n"
else
  printf "[x] No previews backup founds.\n"
fi
echo "----------------"
echo ""
echo "--- Step 3/4 ---"
printf "[ ] Saving new backup... (this operation will take some minutes)\n"
tar cJfP ${DEST_PATH}backup-$(date +%d%m%Y-%H%M).tar.xz $EXCLUDED $SOURCE_PATH /tmp/$DATABASE_NAME-dump.sql
printf "[x] Backup file saved.\n"
echo "----------------"
echo ""
echo "--- Step 4/4 ---"
printf "[ ] Cleaning temp files...\n"
rm /tmp/$DATABASE_NAME-dump.sql
printf "[x] Temp files deleted.\n"
echo "----------------"
echo ""
printf "[x] Backup completed with success!\n"
exit 1
