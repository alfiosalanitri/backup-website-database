# NAME
backup-website-database.sh - create a tar archive with database dump and website files

# DESCRIPTION
This script dump the database and create a tar archive from source into destination with database e files.
To exclude files or directory: create an .excluded file with files and directories list (one for line) into backup directory destination.

# INSTALLATION
- `sudo chown -R root: /path/to/backups/example.com` (optional to secure database and user password)
- `sudo chmod 600 /path/to/backups/example.com/.backup-config` (optional to secure database and user password)
- edit config parameters
- `sudo chmod 754 /path/to/backup-website-database.sh`


# USAGE
- `sudo ./backup-website-database.sh /path/to/example.com/.backup-config` (type sudo only if the backup config file is protected, see installation line)
       
# AUTHOR: 
backup-website-database.sh is written by Alfio Salanitri www.alfiosalanitri.it and are licensed under the MIT License.
