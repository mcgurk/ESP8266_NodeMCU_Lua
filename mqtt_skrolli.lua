local mqtt_broker = "xxxxx.xxxxx.xxx"
local mqtt_port = 1883
local mqtt_user = "xxxxx"
local mqtt_pwd  = "xxxxx"
local mqtt_clientid = "NodeMCU-" .. string.format('%x', node.chipid())
local mqtt_topic = "NodeMCU"
local nappi = 3

-- varmistetaan, ettei oteta yhteyttä useaan kertaan päällekkäin
if not m then
  m = mqtt.Client(mqtt_clientid, 120, mqtt_user, mqtt_pwd)
else
  m:close()
end

-- muodostetaan yhteys mqtt-broakeriin
m:connect(mqtt_broker , mqtt_port, 0, 1, function(conn)
    print("Yhteys mqtt-brokeriin muodostettu!")
    m:publish("status", mqtt_clientid .. " yhdistetty!", 0, 0)
    m:subscribe(mqtt_topic, 0, function(conn)
        print("Tilattu " .. mqtt_topic .. "-topic")
      end)
    m:on('message', function(conn, topic, viesti)
        print("mqtt-viesti - topic:" .. topic .. ", viesti:" .. viesti)
        if viesti:upper() == "PING" then
          m:publish("status", mqtt_clientid .. " vastaa pingiin!", 0, 0)
        else
          viestinkasittelija(topic, viesti)
        end
      end)
  end)

-- asetetaan napille keskeytys ja sen käsittelijä
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

local r = 100
local g = 100
local b = 100
-- täällä käsitellään käyttäjän mqtt-viestit
function viestinkasittelija(topic, viesti)
  if viesti:sub(1, 1) == "#" then
    r = tonumber(viesti:sub(2, 3), 16)
    g = tonumber(viesti:sub(4, 5), 16)
    b = tonumber(viesti:sub(6, 7), 16)
    buffer:fill(r, g, b)
  elseif viesti:upper() == "TRUE" then
    buffer:fill(r, g, b)
  elseif viesti:upper() == "FALSE" then
    buffer:fill(0, 0, 0)
  end
  ws2812.write(buffer)
end

-- tehdään alustukset lednauhaa varten
if not buffer then
  ws2812.init()
  buffer = ws2812.newBuffer(100, 3)
end
