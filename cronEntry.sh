#/usr/bin/bash

conf_file=$(pwd)/settings.conf
export cron_file
export USER

while IFS= read -r line
	do
		if [[ $line =~ ^user ]]; then
			USER=$( echo "$line" | cut -d\= -f2 )
			cron_file=/var/spool/cron/$USER
		fi
	done < "$conf_file"
	
echo "Modifying crontab for $USER in $cron_file"
	
if [[ $1 == "add" ]]; then
	if [[ $(crontab -l) =~ wall_changer ]]; then
		echo "Cron entry already added"
	else
		echo "*/30 * * * * $PWD/wall_changer.sh" >> $cron_file
		if [[ $? -eq 0 ]]; then
			echo "Cron entry successfully added"
		fi
	fi
elif [[ $1 == "remove" ]]; then
	if [[ $(crontab -l) =~ wall_changer ]]; then
		#$(sed '/wall_changer/d' $cron_file)
		$(crontab -l | grep -v 'wall_changer' | crontab -)
		if [[ $? -eq 0 ]]; then
			echo "Cron entry removed"
		fi
	else
		echo "Cron entry not found. Nothing to remove"
	fi
else
	echo
	echo "Require 1 parameter"
	echo "\"add\"   or   \"remove\""
fi



