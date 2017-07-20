#!/bin/bash

FW=./nodemcu-master-21-modules-2017-03-20-19-10-23-float.bin
PORT=/dev/ttyUSB0 

if [ -z $FW ]; then
    echo "FW file is empty"
    exit
fi

sudo esptool.py --port $PORT write_flash -fm qio 0x00000 $FW
