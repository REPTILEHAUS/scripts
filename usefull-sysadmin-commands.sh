# Show all the folders in a tarball backup
tar -tvf backup.tar.gz 

# If you wish to extract a single folder/file from the tarball, find its full path in the previous
# command and use it in place of /var/www/website/directory-wanted and move it to the /tmp directory
tar  -zxvf backup.tar.gz -C /tmp   /var/www/website/directory-wanted

# Rsync using non standard SSH port to move /home/localuser/backup.tar.gz from local server to /home/localuser/backups/backup.tar.gz
# directory on a remote server while showing the transfer progress on the terminal
rsync -rvz -e 'ssh -p 3433' --progress ~/backup.tar.gz sysadmin@DestinationServerIP:~/backups/

# Add users to a htpasswd file
htpasswd -c /etc/apache2/passwords username


# Reconfigure Timezone
dpkg-reconfigure tzdata

# if working on OSX with MAMP and you want to dump ALL databases to separate files - be sure to replace the root username and password with your own.
/Applications/MAMP/Library/bin/mysql -u root -proot  -e 'show databases' | while read dbname; do /Applications/MAMP/Library/bin/mysqldump -u root -proot --complete-insert "$dbname" > "$dbname".sql; done


# Domain Research
nslookup -type=txt
nslookup -type=mx


