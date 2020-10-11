#!/bin/bash

# Script to clone a directory from a server machine.

loading(){
	echo -ne "##########"
	sleep 0.3
	echo -ne "##########"
	sleep 0.3
	echo -ne "##########"
	sleep 0.3
	echo  -ne "#########"
	sleep 0.3
	echo ""
}


# Archive: create an archive of vol03.
archive(){
	loading

	if [[ -d vol03 ]]
	then
		echo "Archiving previous vol03..."
		loading
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
	loading

	echo "This action will delete vol03, please confirm this action."
	read -p "Continue (y/n)?" choice
	case "$choice" in 
  		[yY] | [Yy][Ee][Ss]) 
			echo "Deletion confirmed..."
			echo "Removing vol03..."
			loading
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
	loading
	
	read -p "Please indicate (in days) the maximum age of files to be backed up: " choice
	echo ""
	echo "Your choice is ${choice} days"

	

	ssh server1 find vol03 -type f -mtime -${choice} > filestomove.txt
	if [[ ${?} -eq 0 ]]
	then
		echo "Found files from last ${choice} days"
		cat filestomove.txt | rev | cut -d "/" -f 2- | rev | uniq > newdirs.txt
			
		echo "Creating directory file"
		loading
		for LINE in $( cat newdirs.txt)
		do
			mkdir -p ${LINE}
		done
			
		for LINE in $( cat filestomove.txt)
		do
			scp server1:${LINE} ${LINE}
		done

		find passwd.txt
		if [[ ${?} -eq 0 ]]
		then
			read -p "passwd file found, would you like to encrypt it before transfer? (y/n) " choice2
			case "$choice2" in 
  			[yY] | [Yy][Ee][Ss]) 
				#Encrpytion
				#to encrypt: openssl enc [cipher of choice] -in [file to encrypt] -out [encrypted filename]
				#to decrpyt: openssl enc [cipher of choice] -d -in [encrypted file] -out [decrypted filename]
				ssh server1 openssl enc -AES-256-CBC -in passwd.txt -out encpasswd
				scp server1:encpasswd encpasswd
				loading
				echo "Transferred encrypted passwd.txt"
				;;
  			*)
				scp server1:passwd.txt passwd.txt
				loading
				echo "Transferred passwd.txt"
				;;
			esac
		fi
	fi
}


mainMenu(){
	echo "########################################"
	echo "##                                    ##"
	echo "##     Welcome to Cloning Utility     ##"
	echo "##                                    ##"
	echo "########################################"
	echo
	echo 
	echo "########################################"
	echo "Please select what you would like to do"
	echo ""

	select task in Archive Delete Clone Exit
	
	do
	case $task in
		"Archive")
			echo
			echo "${task} option selected"
			archive
			echo
			mainMenu
			;;
		"Delete")
			echo
			echo "${task} option selected"
			delete
			echo
			mainMenu
			;;
		"Clone")
			echo
			echo "${task} option selected"
			clone
			echo
			mainMenu
			;;
		"Exit")
			echo
			echo "Exiting...Goodbye"
			echo
			exit 0
			;;
		*) # Matching with invalid data
			echo
			echo "Invalid entry."
			echo
			mainMenu
			;;
	esac
	done
}
	
mainMenu



