-- GPIOS
GPIO_LED = GPIO13
GPIO_SWITCH = GPIO12
GPIO_BUTTON = GPIO0

-- WiFi networks list in format [SSID] = password
WIFI_AUTH = {
["YOUR_SSID_1"] = "YOUR PASSWORD 1",
["YOUR_SSID_2"] = "YOUR PASSWORD 2"
}

-- Alarms
WIFI_ALARM_ID = 0
WIFI_LED_BLINK_ALARM_ID = 1

-- MQTT
MQTT_CLIENTID = "switch-"..node.chipid()
MQTT_HOST = "YOUR_HOST"
MQTT_PORT = 1883
MQTT_MAINTOPIC = "/" .. MQTT_CLIENTID
MQTT_USERNAME = ""
MQTT_PASSWORD = ""

-- OTHERS
BUTTON_DEBOUNCE = 500000
TELNET_MODULE = 1 -- 1 to active


-- Confirmation message
print("\nGlobal variables loaded...\n")
