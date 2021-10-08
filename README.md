# NAME
backup-website-database.sh - create a tar archive with databases and website

# DESCRIPTION
this script dump the database and create a tar archive from source into destination with database e files.
NOTE: pass the database password to this script isn't safety. Create a database user with this privileges: SHOW DATABASES, SELECT, LOCK TABLES, RELOAD, SHOW VIEW and use it.
	

# INSTALLATION
`sudo chmod +x backup-website-database.sh`


# USAGE
`./backup-website-database.sh /path/to/example.com/.backup-config`
       
# AUTHOR: 
backup-website-database.sh is written by Alfio Salanitri www.alfiosalanitri.it and are licensed under the terms of the GNU General Public License, version 2 or higher. 
