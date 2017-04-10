-- do only once:
-- adc.force_init_mode(adc.INIT_VDD33)
-- wifi.setmode(wifi.STATION)
-- wifi.sta.config("ssid","passwd")
-- stop startup:
-- tmr.stop(0)

dataPin = 2 -- GPIO4, ESP-201: IO4
vccPin = 1 -- GPIO5, ESP-201: IO5
breakPin = 3 -- GPIO0, NodeMCU: D3

-- sleep = 30*60 -- seconds
sleep = 10 -- seconds
key = "dRKTG5HB1xwWhIZSSJ-NVr"
trigger = "testi_button"

function start()
  status, temp, humi, temp_dec, humi_dec = dht.read(dataPin)

  voltage = adc.readvdd33(0)
  print("System voltage (mV):", voltage)

  location = "http://maker.ifttt.com/trigger/" .. trigger .. "/with/key/" .. key
  url = location .. "?value1=" .. temp .. "&value2=" .. humi .. "&value3=" .. voltage
  http.get(url, nil, function() node.dsleep(sleep * 1000000) end)
end

function wait_ip()
  print(gpio.read(breakPin))
  if gpio.read(breakPin) == 0 then
  do 
    tmr.stop(0)
    print("Break")
    return 
  end
  end
  print("Normal boot")
  if wifi.sta.getip() then
    tmr.stop(0)
    print(wifi.sta.getip())
    start()
  end
end

gpio.mode(vccPin, gpio.OUTPUT) gpio.write(vccPin, gpio.HIGH) -- DHT22 Vcc
gpio.mode(breakPin, gpio.INPUT)
tmr.alarm(0, 2000, tmr.ALARM_AUTO, wait_ip)
