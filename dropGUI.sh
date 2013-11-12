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

function upload
{
	echo "placeholder"
}
function download
{
	echo "placeholder"
}
function delete
{
	echo "placeholder"
}
function move
{
	echo "placeholder"
}
function copy
{
	echo "placeholder"
}
function mkdir
{
	echo "placeholder"
}
function list
{
	echo "placeholder"
}
function share
{
	echo "placeholder"
}
function info
{
	echo "placeholder"
}
function unlink
{
	echo "placeholder"
}


##########
# Zenity #
##########
zenity --list --radiolist\
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
	FALSE "unlink" "Deslinkear script de la cuenta Dropbox"
