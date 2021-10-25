# NAME
backup-website-database.sh - create a tar archive with database and website from config file

# DESCRIPTION
This script dump the database and create a tar archive from source into destination with database e files.
Require root privileges.	

# INSTALLATION
-`sudo chown -R root: /path/to/example.com`
-`sudo chmod 600 /path/to/example.com/.backup-config`
- edit config parameters
-`sudo chmod 754 /path/to/backup-website-database.sh`


# USAGE
- `sudo ./backup-website-database.sh /path/to/example.com/.backup-config`
       
# AUTHOR: 
backup-website-database.sh is written by Alfio Salanitri www.alfiosalanitri.it and are licensed under the MIT License.
