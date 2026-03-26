#!/bin/bash

set -e 

APP_NAME="My little AI"
DirectoryAPP="$HOME/.local/share/MyLittleAI"
DesktopAPP="$HOME/Desktop/MyLittleAI.desktop"

echo "Installing My Little AI please wait ..."


##zenity##
if ! command -v zenity >& /dev/null
then
	echo "Installing extra bits..."
	sudo apt-get update
	sudo apt-get install -y zenity
else
    echo "20% ..."
fi

#node
if ! command -v node >& /dev/null
then
	echo "40% ..."
	sudo apt-get install -y nodejs npm
else 
	echo "50% ..."
fi

mkdir  -p "$DirectoryAPP"
cp myLittleAI.js "$DirectoryAPP"

##puter##
cd "$DirectoryAPP"
npm init -y > /dev/null 2>&1 || true
npm install @heyputer/puter.js

cat > "$DesktopAPP" <<EOL
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=Run My AI App
Exec=sh -c "cd $DirectoryAPP && node myai.js"
Icon= myaiicon.png
Terminal=false
Type=Application
Categories=Utility;
EOL

chmod +x "$DesktopAPP"

echo "Completed, added to desktop"

