#!/usr/bin/env bash

#Default Dropbox Uploader configuration file
CONFIG_FILE=~/.dropbox_uploader

#Check the shell
if [ -z "$BASH_VERSION" ]; then
    echo -e "Error: this script requires the BASH shell!"
    exit 1
fi


# #Check dropbox_uploader.sh script
#Looking for dropbox uploader
if [ -f "./dropbox_uploader.sh" ]; then
    DU="./dropbox_uploader.sh"
else
    DU=$(which dropbox_uploader.sh)
    if [ $? -ne 0 ]; then
        echo "Dropbox Uploader not found!"
        exit 1
    fi
fi

#Check Zenity
if [ -z "$(zenity --version)" ]; then
    echo -e "Error: this script requires Zenity"
    echo -e "To install it in Debian/Ubuntu, try:"
    echo -e "	sudo apt-get install zenity\n"
    exit 1
fi


#############
# Funciones #
#############

function normalizePath
{
    readlink -m "$1"
}

function getFileSelect
{
	zenity --file-selection --title="Select a file/directory"
}

function getFileRemote
{
	zenity --entry --title="Enter a file/directory" --text="Remote file/directory:"
}

function optFileSelect
{
	if [ $1 = 1 ]; then
		Texto_opcional="Do you wish to enter the remote file/directory?"
	else
		Texto_opcional="Do you wish to enter the local file/directory?"
	fi
	if zenity --question --title="Optional parameter" --text="$Texto_opcional"; then
		if [ $1 = 1 ]; then
			zenity --entry --title="Remote" --text="Enter the file/directory:"
		else
			zenity --file-selection --title="Local"
		fi
	fi
}

function upload
{
	local SRC=`getFileSelect`
	local DST=`optFileSelect 1`
	$DU -g upload $SRC $DST
	dropGUI
}

function download
{
	local SRC=`getFileRemote`
	local DST=`optFileSelect 2`
	$DU -g download $SRC $DST
	dropGUI
}

function delete
{
	local DST=`getFileRemote`
	$DU -g delete $DST
	dropGUI
}

function move
{
	local SRC=`getFileRemote`
	local DST=`getFileRemote`
	$DU -g move $SRC $DST
	dropGUI
}

function copy
{
	local SRC=`getFileRemote`
	local DST=`getFileRemote`
	$DU -g copy $SRC $DST
	dropGUI
}

function mkdir
{
	local DST=`getFileRemote`
	$DU -g mkdir $DST
	dropGUI
}

function list
{
	local DST=`optFileSelect 1`
	$DU -g list $DST
	dropGUI
}

function share
{
	local DST=`getFileRemote`
	$DU -g share $DST
	dropGUI
}

function info
{
	$DU -g info
	dropGUI
}

function unlink
{
	$DU -g unlink
}

##########
# Setup ##
##########

if [[ -f $CONFIG_FILE ]]; then
	echo "Config file found ..."
else
	$DU -g version
fi

##########
# Zenity #
##########

function dropGUI
{
	COMMANDO=$(zenity --list --radiolist\
		--title="Choose an action." --height=600 \
		--column="" --column="" --column="Action" --hide-column=2 \
		TRUE "upload" "Upload a file/directory" \
		FALSE "download" "Download a file/directory" \
		FALSE "delete" "Delete a file/directory" \
		FALSE "move" "Move or rename a file/directory" \
		FALSE "copy" "Copy  a file/directory" \
		FALSE "mkdir" "Create a new directory" \
		FALSE "list" "List the content of a Dropbox directory" \
		FALSE "share" "Get a public link to share a file" \
		FALSE "info" "Get your Dropbox account info" \
		FALSE "unlink" "Unlink this script from your account")


	if [[ $COMMANDO = "upload" ]]; then
		upload
	elif [[ $COMMANDO = "download" ]]; then
		download
	elif [[ $COMMANDO = "delete" ]]; then
		delete
	elif [[ $COMMANDO = "move" ]]; then
		move
	elif [[ $COMMANDO = "copy" ]]; then
		copy
	elif [[ $COMMANDO = "mkdir" ]]; then
		mkdir
	elif [[ $COMMANDO = "list" ]]; then
		list
	elif [[ $COMMANDO = "share" ]]; then
		share
	elif [[ $COMMANDO = "info" ]]; then
		info
	elif [[ $COMMANDO = "unlink" ]]; then
		unlink
	elif [[ $COMMANDO = "" ]]; then
		echo "Closing ..."
	else
		echo "Error: Unknown action!"
		exit 1
	fi
}

dropGUI
