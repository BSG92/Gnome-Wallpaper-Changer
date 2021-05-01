#!/usr/bin/bash

AUTHOR: Buddika Gunawardena (BSG92)

#shopt -s nullglob

export wallpaper_path
export wallpaper_types
export index

conf_file=$(pwd)/settings.conf

while IFS= read -r line
	do
		if [[ $line =~ ^wallpaper_path ]]; 
			then wallpaper_path=$( echo "$line" | cut -d\= -f2 )
		fi

		if [[ $line =~ ^current_index ]];
			then index=$( echo $line | cut -d\= -f2 )	
		fi
	done < "$conf_file"

wallpaper_types=(
	$wallpaper_path/*.jpg
	$wallpaper_path/*.jpeg
)

#get array size
wallpapers_size=${#wallpaper_types[*]}

# changing wallpapers
while [ $index -lt $wallpapers_size ]
	do
		#index is maxing out, so reset it
		if [ $(($index+1)) -eq $wallpapers_size ]; then
			$(sed -i 's/current_index\=.*/current_index=0/' "$conf_file")
			break
		else
			# handling white spaces using double quotes ""
			gsettings set org.gnome.desktop.background picture-uri "${wallpaper_types[$index]}"
			index=$(($index+1))
			$(sed -i 's/current_index\=.*/current_index='$index'/' "$conf_file")
			break
		fi
	done


########### DEBUGGING ############
#echo $wallpapers_size
#echo "printing line from file"
#echo $wallpaper_path
echo "index is $index"
######### END OF DEBUGGING ##########

