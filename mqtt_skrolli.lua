--local led = 4

--gpio.mode(led, gpio.OUTPUT)

if not m then -- varmistetaan, ettei oteta yhteyttä useaan kertaan päällekkäin
  m = mqtt.Client(mqtt_clientid, 120, mqtt_user, mqtt_pwd)
else
  m:close()
end
m:connect(mqtt_broker , mqtt_port, 0, 1, function(conn)
    print("Yhteys mqtt-brokeriin muodostettu!")
    m:publish("status", mqtt_clientid .. " yhdistetty!", 0, 0)
    m:subscribe(mqtt_topic, 0, function(conn)
        print("Tilattu " .. mqtt_topic .. "-topic")
      end)
    m:on('message', function(conn, topic, viesti)
        print("mqtt-viesti - topic:" .. topic .. ", viesti:" .. viesti)
        if string.upper(viesti) == "PING" then
          m:publish("status", mqtt_clientid .. " vastaa pingiin!", 0, 0)
        elseif string.upper(viesti) == "ON" then
          --gpio.write(led, gpio.LOW)
        elseif string.upper(viesti) == "OFF" then
          --gpio.write(led, gpio.HIGH)
        else
          kasittele_viesti(topic, viesti)
        end
      end)
  end)

local lukko = false
gpio.mode(nappi, gpio.INT)
gpio.trig(nappi, "down", function()
    if not lukko then
      m:publish("status", mqtt_clientid .. " - Nappi!", 0, 0)
      print("Nappi!")
      lukko = true
      tmr.alarm(0, 1000, tmr.ALARM_SINGLE, function()
          lukko = false
        end)
    end
  end)

PIXELCOUNT = 50

function kasittele_viesti(topic, viesti)
  print("viestinkäsittelijä")
  --buffer:fill(128, 0, 0)
  --buffer:fill(math.random(100), math.random(100), math.random(100))
  if viesti:sub(1, 1) == "#" then
    local r = tonumber(string.sub(viesti, 2, 3), 16)
    local g = tonumber(string.sub(viesti, 4, 5), 16)
    local b = tonumber(string.sub(viesti, 6, 7), 16)
    buffer:fill(r, g, b)
    ws2812.write(buffer)
  end
end


if not buffer then
  print("ws2812 init")
  ws2812.init()
  buffer = ws2812.newBuffer(PIXELCOUNT, 3)
end
