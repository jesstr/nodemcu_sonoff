local dispatcher = {}
local connected = false

-- client activation
if m == nil then
    m = mqtt.Client(MQTT_CLIENTID, 60, MQTT_USERNAME, MQTT_PASSWORD) 
else
    m:close()
end

-- debounce
function debounce(func)
    local last = 0

    return function (...)
        local now = tmr.now()
        if now - last < BUTTON_DEBOUNCE then return end

        last = now
        return func(...)
    end
end

-- actions
local function switch_power(m, pl)
	if pl == "ON" or pl == "1" then
		gpio.write(GPIO_SWITCH, gpio.HIGH)
		print("MQTT : plug ON for ", MQTT_CLIENTID)
	elseif pl == "OFF" or pl == "0" then
		gpio.write(GPIO_SWITCH, gpio.LOW)
		print("MQTT : plug OFF for ", MQTT_CLIENTID)
	end
end

local function toggle_power()
    local msg
	if gpio.read(GPIO_SWITCH) == gpio.HIGH then
		gpio.write(GPIO_SWITCH, gpio.LOW)
        msg = "OFF"
	else
		gpio.write(GPIO_SWITCH, gpio.HIGH)
        msg = "ON"
    end
    if connected then
        m:publish(MQTT_MAINTOPIC .. '/state/power', msg, 0, 1)
        print("MQTT (online): " .. msg)
        LedBlink(100)
    else
        print("MQTT (offline): " .. msg)
        LedFlicker(100, 100, 2)
    end
end

-- events
m:lwt('/lwt', MQTT_CLIENTID .. " died !", 0, 0)

m:on('connect', function(m)
	print('MQTT : ' .. MQTT_CLIENTID .. " connected to : " .. MQTT_HOST .. " on port : " .. MQTT_PORT)
	m:subscribe(MQTT_MAINTOPIC .. '/cmd/#', 0, function (m)
		print('MQTT : subscribed to ', MQTT_MAINTOPIC) 
	end)

    connected = true
    LedFlickerStop()

    --Last switch state report
    local msg
    if gpio.read(GPIO_SWITCH) == gpio.HIGH then
        msg = "ON"
    else
        msg = "OFF"
    end
    m:publish(MQTT_MAINTOPIC .. '/state/power', msg, 0, 1)

    --Service messages publish
    tmr.alarm(PUBLISH_ALARM_ID, 60000, 1, function ()
        if connected == true then
            LedBlink(50)
            time = tmr.time()
            dd = time / (3600 * 24)
            hh = (time / 3600) % 24
            mm = (time / 60) % 60
            local str = string.format("%dd %dh %dm", dd, hh, mm)
            --print("Uptime: "..str)
            m:publish("/"..MQTT_CLIENTID.."/state/uptime", str, 0, 1, nil)
            m:publish("/"..MQTT_CLIENTID.."/state/ip", wifi.sta.getip(), 0, 1, nil)
        end
    end)
end)

m:on('offline', function(m)
    connected = false
    print('MQTT : disconnected from ', MQTT_HOST)
end)

m:on('message', function(m, topic, pl)
	print('MQTT : Topic ', topic, ' with payload ', pl)
	if pl~=nil and dispatcher[topic] then
        LedBlink(50)
		dispatcher[topic](m, pl)
	end
end)


-- Start
gpio.mode(GPIO_SWITCH, gpio.OUTPUT)
gpio.mode(GPIO_BUTTON, gpio.INT)
gpio.trig(GPIO_BUTTON, 'down', debounce(toggle_power))
dispatcher[MQTT_MAINTOPIC .. '/cmd/power'] = switch_power
m:connect(MQTT_HOST, MQTT_PORT, 0, 1)
