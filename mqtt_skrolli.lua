local mqtt_broker = "xxxxx.xxxxx.xxx"
local mqtt_port = 1883
local mqtt_user = "xxxxx"
local mqtt_pwd  = "xxxxx"
local mqtt_clientid = "NodeMCU-" .. string.format('%x', node.chipid())
local mqtt_topic = "NodeMCU"
local nappi = 3
local led = 4

gpio.mode(led, gpio.OUTPUT)

if not m then 
  m = mqtt.Client(mqtt_clientid, 120, mqtt_user, mqtt_pwd)
else
  m:close()
end
m:connect(mqtt_broker , mqtt_port, 0, 1, function(conn)
    m:publish("status", mqtt_clientid .. " yhdistetty!", 0, 0)
    m:subscribe(topic, 0, function(conn)
        print("Tilattu " .. topic .. "-topic")
      end)
    m:on('message', function(conn, topic, viesti)
        print("mqtt-viesti - topic:" .. topic .. ", viesti:" .. viesti)
        if string.upper(viesti) == "PING" then
          m:publish("status", mqtt_clientid .. " vastaa pingiin!", 0, 0)
        elseif string.upper(viesti) == "ON" then
          gpio.write(led, gpio.LOW)
        elseif string.upper(viesti) == "OFF" then
          gpio.write(led, gpio.HIGH)
        end
      end)
  end)

local lukko = false
gpio.mode(nappi, gpio.INT)
gpio.trig(nappi, "down", function()
    if not lukko then
      m:publish(topic, "Nappi!", 0, 0)
      print("Nappi!")
      lukko = true
      tmr.alarm(0, 1000, tmr.ALARM_SINGLE, function()
          lukko = false
        end)
    end
  end)
