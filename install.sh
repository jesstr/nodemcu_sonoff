#!/bin/bash

LUATOOL=luatool.py
ESPTOOL=esptool.py
DEFPORT=/dev/ttyUSB0
PORT=${1:-$DEFPORT}
BAUD=115200
FW=./fw//nodemcu-master-21-modules-2017-03-20-19-10-23-float.bin

#File list to upload
files=(
broker.lua
config.lua
ota.lua
page.tmpl
telnet.lua
init.lua
)

echo "Board will be erased and all data will be lost!"	
read -p "Hold button on the board and reboot it. Then press ENTER to continue..."

#Flash chip
echo "Programming..."
sudo $ESPTOOL --port $PORT write_flash -fm qio 0x00000 $FW
if [[ $? != 0 ]]; then 
	exit 
fi

sleep 5

#Clear files on flash memory
echo "Clearing..."
sudo $LUATOOL -p $PORT -b $BAUD --wipe
echo

sleep 2

#Do upload
for fname in ${files[@]}; do
	echo "Uploading: $fname..."
	sudo $LUATOOL -p $PORT -b $BAUD -f ./$fname --bar
done

#Verify uploaded file list
list=$(sudo $LUATOOL -p $PORT -b $BAUD --list | awk -F '[:,]' '/^name/{print $2}')

if [[ $(echo ${files[@]} ${list[@]} | tr ' ' '\n' | sort | uniq -d | wc -l) == ${#files[@]} ]]; then
	echo "---------------"
	echo -e "Uploaded ${#files[@]} files.\nDone"
else
	echo "Upload error!"
	exit
fi

