-- do only once:
-- adc.force_init_mode(adc.INIT_VDD33)
-- wifi.setmode(wifi.STATION)
-- wifi.sta.config("ssid","passwd")
-- stop startup:
-- tmr.stop(0) or IO12 from 3.3V to GND

datapin = 2 -- GPIO4, ESP-201: IO4
powerpin = 1 -- GPIO5, ESP-201: IO5
button = 6 -- GPIO12, ESP-201: IO12
sleep = 30*60 -- seconds
key = "xxxxxxxxxxxxxxxxxxxxxx"
trigger = "lampotila"

function read_and_send_and_sleep()
  status, temp, humi, temp_dec, humi_dec = dht.read(datapin)
  gpio.write(powerpin, gpio.LOW)
  voltage = adc.readvdd33(0)
  location = "http://maker.ifttt.com/trigger/" .. trigger .. "/with/key/" .. key
  url = location .. "?value1=" .. temp .. "&value2=" .. humi .. "&value3=" .. voltage
  http.get(url, nil, function() 
      node.dsleep(sleep * 1000000) 
    end)
end

tmr.alarm(2, 10000, tmr.ALARM_SINGLE, function()
    node.dsleep(sleep * 1000000) 
  end)
    
local _,r = node.bootreason()
if r == 5 then
  gpio.mode(powerpin, gpio.OUTPUT)
  gpio.write(powerpin, gpio.HIGH)
  tmr.alarm(0, 2000, tmr.ALARM_AUTO, function()
    if wifi.sta.getip() then
      tmr.stop(0)
      read_and_send_and_sleep()
    end
  end)
else  

print(node.bootreason())

tmr.alarm(1, 200, tmr.ALARM_AUTO, function() 
    print("blaah") -- led blink
  end)
  
gpio.mode(button, gpio.INT) -- enable interrupt
gpio.trig(button, "down", function()
    gpio.mode(button, gpio.INPUT) -- disable interrupt
    tmr.stop(0) -- stop timer
    tmr.stop(1) -- stop led blinking
    print(node.bootreason())
    print("init.lua interrupted!")
  end)

tmr.alarm(0, 5000, tmr.ALARM_AUTO, function()
    print(node.bootreason())
    if wifi.sta.getip() then
      tmr.stop(0) -- stop timer
      tmr.stop(1) -- stop led blinking
      read_and_send_and_sleep()
    end
  end)

end
