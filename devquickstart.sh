 #!/bin/bash


DB_USER="MYSQLUSERNAME"
DB_PASSWD="MySQLPASSWORD"
EXECUTION_USER="operations"
DEV_DIR="/var/www/development"
TLD="yourdomain.com"
GIT_REPO_DIR="git-repositories"


# add a help -h flag
if [ "$1" == "-h" ]; then
  echo "Usage: SiteName DBUsername DBPassword"
  exit 0
fi

# if no arguments are added give this instruction
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "To use this script you need to add a"
    echo "SITENAME, DBusername and a DBPassword"
    exit 1
fi

echo "--------------Parameters---------"
echo "Global Site Name: " $1
echo "Database User name" $2
echo "Database User password" $3

echo "Making Site Directory"
sudo mkdir $DEV_DIR$1
echo "chown and chmod Permissions for Dir"
sudo chmod 755 -R $DEV_DIR$1
sudo chown $EXECUTION_USER:www-data $DEV_DIR$1


echo "copy Virtual Host to $1.$TLD"
sudo cp /etc/apache2/sites-available/dev.$TLD /etc/apache2/sites-available/$1.$TLD

echo "Replacing defaults with $1 in vhost"
sudo sed -i 's/reptilehausdev/'$1'/g' /etc/apache2/sites-available/$1.$TLD

sudo a2ensite $1.$TLD
sudo service apache2 reload

echo "--------------Git Repo---------"
echo "Creating enter and create dir, then bare repo "
cd /home/$EXECUTION_USER/$GIT_REPO_DIR && mkdir /home/$EXECUTION_USER/$GIT_REPO_DIR/$1.git && cd /home/$EXECUTION_USER/$GIT_REPO_DIR/$1.git && git init --bare

cd hooks
#cat > post-receive
echo "Adding Hook"
if [ -e post-receive ]; then
  echo "File $1 already exists!"
else
	echo "#!/bin/sh" > post-receive
	echo "git --work-tree="$DEV_DIR$1" --git-dir=/home/$EXECUTION_USER/$GIT_REPO_DIR/"$1".git checkout -f" >> post-receive
fi


chmod +x post-receive


echo "--------------Creating Database $1---------"

#DB_PASSWD=""
HN=`hostname | awk -F. '{print $1}'`


Q1="CREATE DATABASE IF NOT EXISTS $1;"
Q2="GRANT USAGE ON *.* TO '$2'@'localhost' IDENTIFIED BY '$3';"
Q3="GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost';"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"


# using MYSQL_PWD  instead of the -p flag supresses password warning on commandline
MYSQL_PWD=$DB_PASSWD mysql --user=$DB_USER -e "$SQL"

echo "done"

echo "-------FINISHED EXECUTING SCRIPT--------"
