# nodemcu_sonoff
Nodemcu based code for [Sonoff WiFi smart switch.](https://www.itead.cc/smart-home/sonoff-wifi-wireless-switch.html)

### Features:

* MQTT relay switch control
* MQTT and HTTP device monitoring: switch state, device IP, uptime.
* The button on the device can also be used to toggle the state of the switch (On/Off)
* WiFi connection state monitoring and auto reconnection to the same/backup network.
* Telnet remote console and OTA update.


### Description:

* **default_config.lua :** some example of the configuration file. Copy to config.lua, edit with your options and upload to the device;
* **init.lua :** runs the WiFi connection and launches other modules;
* **ota.lua :** simple HTTP-server;
* **telnet.lua :** simple telnet server for remote console and on the air (OTA) update;
* **broker.lua :** MQTT client module.

```
mosquitto_pub -h "myMQTTserver" -t "/myMQTTpath/power" -m "ON" -- turn switch on
mosquitto_pub -h "myMQTTserver" -t "/myMQTTpath/power" -m "OFF" -- turn switch off
```
* **install.sh :** script for easy nodemcu firmware programming and source files upload

### Requarements:
[4refr0nt/luatool](https://github.com/4refr0nt/luatool) - tool for loading Lua-based scripts from file to ESP8266 with nodemcu firmware.
[espressif/esptool](https://github.com/espressif/esptool) -  tool for communication with the ROM bootloader in Espressif ESP8266.

### First install:
If you have new out-of-the-box sonoff  WiFi smart switch, just connect it to the PC with 3.3v USB-to-TTL adapter, switch it on with the button pressed, then run:

```
./install.sh /dev/ttyUSB0
```

### OTA update:
```
luatool.py --ip <your IP-address>:23 --src <path to file> --bar
```

> Main project structure and original code was taken from [elric91/nodemcu_sonoff](https://github.com/elric91/nodemcu_sonoff)
> Safe modules load stolen from [DasBasti's fork](https://github.com/DasBasti/nodemcu_sonoff)
> Nodemcu firmware generated with [Marcel's NodeMCU custom build machine](http://nodemcu-build.com/) (just add MQTT to the standard module selection)