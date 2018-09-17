#!/bin/bash

FW=nodemcu-master-22-modules-2018-05-27-13-21-02-float.bin
DEFPORT=/dev/ttyUSB0 

PORT=${1:-$DEFPORT}

FILE=$(cd `dirname $0` && pwd)/$FW

if [ ! -f $FILE ]; then
    echo "Firmware file $FILE not found"
    exit
fi

sudo esptool.py --port $PORT write_flash -fm qio 0x00000 $FILE
