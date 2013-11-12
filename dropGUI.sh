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
# Setup ##
##########

if [[ -f $CONFIG_FILE ]]; then
	echo "Config file found ..."
else
	zenity --info \
		--title="Primer uso" \
		--text="Esta es la primera vez que corre este script\n \
		1) Abre la siguiente URL en tu navegador, ingresa usando tu cuenta DropBox: https://www2.dropbox.com/developers/apps\n \
		2) Clic en \"Create App\", selecciona \"Dropbox API app\"\n \
		3) Selecciona \"Files and datastores\"\n \
		4) Ahora continua con la configuraccion, escgiendo los permisos de la aplicacion y el acceso a restricciones de tu carpeta DropBox\n \
		5) Ingresa el \"App Name\" que prefieras (e.g. MyUploader$RANDOM$RANDOM$RANDOM)\n\n \
		Ahora, haz clic en \"Create App\".\n\n \
		Cuando tu nueva aplicacion sea correctamente creada,\n \
		ingresa tu App Key, App Secret y el Permission type mostrado en la pagina de configuracion"

	zenity --info --title="Primer uso" \
		--text="Por Favor ejecuta en tu terminal el comando\n $DU \n y luego vuelve a ejecutar este script"

	exit 0

	# while (true); do

	# 	DB_APP_KEY=$(zenity --entry --title="App key" --text="Ingresa tu App Key")
	# 	DB_APP_SECRET=$(zenity --entry --title="App secret" --text="Ingresa tu App Secret")
	# 	DB_PERMISSION=$(zenity --entry --title="Permission Type" --text="Permission type, App folder or Full Dropbox [a/f]")


	# 	if [[ $DB_PERMISSION == "a" ]]; then
	# 		ACCESS_MSG="App Folder"
	# 	else
	# 		ACCESS_MSG="Full Dropbox"
	# 	fi

	# 	if zenity --question --text="App key es $DB_APP_KEY, App secret es $DB_APP_SECRET y el nivel de acceso es $ACCESS_MSG. ok?"; then
	# 		break;
	# 	fi
	# done

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
}

dropGUI
