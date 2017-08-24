#!/bin/bash


# Script name: wwwpermissions.sh
#
# Author: P-C Markovski
# Date (Git repo init): 2017-08-24
# Purpose: Take a username as parameter and change all directory and file permissions in /var/www to the recommended permissions.
#	   Also Change the ownership of all files in /var/www to username:www.


function set_permissions()
{
	# Add user as a member in the www-data group.
	# The www-data group is used by Apache2, and any web server admins should be members of this group.

		usermod -a -G www-data $1

	# Change the ownership for all files in /var/www to <param>:www.

		chown -R $1:www-data /var/www/

	# Find all directories and files in /var/www and change permissions accordingly.
	# These are the recommended rights for directories and files served by an Apache server.

		find /var/www -type d -exec chmod 755 {} \;
		find /var/www -type f -exec chmod 644 {} \;
}


	# Give Apache a serious kickstart, reload all configurations and print status.

function gogo_apache()
{
	printf "Restarting Apache.. "
	service apache2 restart
	printf "Reloading Apache.."
	service apache2 reload
	service apache2 status
}

if [ "$1" == "p" ]; then
	printf "Setting permissions for Apache to include %s\n", $2
	set_permissions $2
fi

if [ "$1" == "g" ]; then
	printf "Fresh restart and reload of Apache..\n"
	gogo_apache
fi



