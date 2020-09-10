#!/bin/bash

# Script to clone a directory from a server machine.


# Archive: create an archive of vol03.
archive(){
	if [[ -d vol03 ]]
	then
		echo "Archiving previous vol03..."
		tar -czf "vol03-backup-$( date +%Y%m%d ).tar.gz" vol03

		if [[ ${?} -eq 0 ]]
		then
			echo "Successfully archived and created backup: vol03-backup-$( date +%Y%m%d ).tar.gz"
		else
			echo "ARCHIVING ERROR: Could not create backup." >&2 
		fi
	else
		echo "ARCHIVING ERROR: No previous vol03 folder found" >&2
	fi
	echo "Returning to main menu..."
}

# Delete: delete's vol03. Will prompt user to double check
delete(){
	echo "This action will delete vol03, please confirm this action."
	read -p "Continue (y/n)?" choice
	case "$choice" in 
  		[yY] | [Yy][Ee][Ss]) 
			echo "Deletion confirmed..."
			echo Removing vol03...
			rm -r vol03
			if [[ ${?} -eq 0 ]]
			then
				echo "Successfully removed previous vol03"
			else
				echo "DELETION ERROR: Could not remove previous vol03." >&2
			fi
			;;
  		*)
			;;
	esac	
	echo "Returning to main menu..."
}

# Clone: 
clone(){
	
	read -p "Please indicate (in days) the maximum age of files to be backed up: " choice
	echo ""
	echo "Your choice is ${choice} days"

	

	#ssh server1 find vol03 -type f -mtime ${choice} > filestomove.txt
	#cat filestomove.txt | rev | cut -d "/" -f 2- | rev | uniq > newdirs.txt
	#
	#for LINE in $( cat newdirs.txt)
	#do
	#	mkdir -p ${LINE}
	#done
	#
	#for LINE in $( cat filestomove.txt)
	#do
	#	scp server1:${LINE} ${LINE}
	#done
}


mainMenu(){
	echo 
	echo "########################################"
	echo "Please select what you would like to do"
	echo ""

	select task in Archive Delete Clone Exit
	
	do
	case $task in
		"Archive")
			echo "${task} option selected"
			archive
			echo
			mainMenu
			;;
		"Delete")
			echo "${task} option selected"
			delete
			echo
			mainMenu
			;;
		"Clone")
			echo "${task} option selected"
			clone
			echo
			mainMenu
			;;
		"Exit")
			echo "Exiting...Goodbye"
			echo
			exit 0
			;;
		*) # Matching with invalid data
			echo "Invalid entry."
			echo
			mainMenu
			;;
	esac
	done
}

echo "########################################"
echo "##                                    ##"
echo "##     Welcome to Cloning Utility     ##"
echo "##                                    ##"
echo "########################################"
echo
	
mainMenu



