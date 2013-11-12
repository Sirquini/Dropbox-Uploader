#!/usr/bin/env bash

#Default Dropbox Uploader configuration file
CONFIG_FILE=~/.dropbox_uploader

#Check the shell
if [ -z "$BASH_VERSION" ]; then
    echo -e "Error: Este script requiere el shell de BASH!"
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
    echo -e "Error: Este script requiere Zenity"
    echo -e "Para instalar en Debian/Ubuntu, intente:"
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
	zenity --file-selection --title="Selecciona un archivo/directorio"
}

function getFileRemote
{
	zenity --entry --title="Ingresa un archivo/directorio" --text="Archivo/directorio remoto:"
}

function optFileSelect
{
	if [ $1 = 1 ]; then
		Texto_opcional="Desea ingresar el archivo/directorio remoto?"
	else
		Texto_opcional="Desea ingresar el archivo/directorio local?"
	fi
	if zenity --question --title="Argumento Opcional" --text="$Texto_opcional"; then
		if [ $1 = 1 ]; then
			zenity --entry --title="Remoto" --text="Ingresa el archivo/directorio:"
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
		--title="Elija la accion que desea tomar." \
		--column="" --column="" --column="Accion" --hide-column=2 \
		TRUE "upload" "Subir archivo/directorio" \
		FALSE "download" "Descargar archivo/directorio" \
		FALSE "delete" "Eliminar archivo/directorio" \
		FALSE "move" "Mover (renombrar) archivo/directorio" \
		FALSE "copy" "Copiar archivo/directorio" \
		FALSE "mkdir" "Crear un directorio" \
		FALSE "list" "Listar contenido de un directorio" \
		FALSE "share" "Link puclico para compartir archivo" \
		FALSE "info" "Informacion de la cuenta Dropbox" \
		FALSE "unlink" "Deslinkear script de la cuenta Dropbox")


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
		echo "Cerrando ..."
	else
		echo "Error: Accion no reconocida!"
		exit 1
	fi
}

dropGUI
