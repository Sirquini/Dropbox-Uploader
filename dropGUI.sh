#!/usr/bin/env bash

#Check the shell
if [ -z "$BASH_VERSION" ]; then
    echo -e "Error: Este script requiere el shell de BASH!"
    exit 1
fi

#Check dropbox_uploader.sh script
if [ -z "$(./dropbox_uploader.sh version)" ]; then
    echo -e "Error: Este script requiere de dropbox_uploader.sh"
    exit 1
fi

#Check Zenity
if [ -z "$(zenity --version)" ]; then
    echo -e "Error: Este script requiere Zenity"
    exit 1
fi


#############
# Funciones #
#############

function upload
{
	echo "Uploaded"
}

function download
{
	echo "Downloaded"
}

function delete
{
	echo "Deleted"
}

function move
{
	echo "Moved"
}

function copy
{
	echo "Copied"
}

function mkdir
{
	echo "Dir made"
}

function list
{
	echo "Listed"
}

function share
{
	echo "Shared"
}

function info
{
	echo "Showing Info"
}

function unlink
{
	echo "Unlinked Account"
}


##########
# Zenity #
##########

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


if [ $COMMANDO = "upload" ]; then
	upload
elif [ $COMMANDO = "download" ]; then
	download
elif [ $COMMANDO = "delete" ]; then
	delete
elif [ $COMMANDO = "move" ]; then
	move
elif [ $COMMANDO = "copy" ]; then
	copy
elif [ $COMMANDO = "mkdir" ]; then
	mkdir
elif [ $COMMANDO = "list" ]; then
	list
elif [ $COMMANDO = "share" ]; then
	share
elif [ $COMMANDO = "info" ]; then
	info
elif [ $COMMANDO = "unlink" ]; then
	unlink
else
	echo "Error: Accion no reconocida!"
	exit 1
fi

