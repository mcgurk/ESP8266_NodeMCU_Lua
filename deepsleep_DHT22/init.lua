-- do only once:
-- adc.force_init_mode(adc.INIT_VDD33)
-- wifi.setmode(wifi.STATION)
-- wifi.sta.config("ssid","passwd")
-- stop startup:
-- tmr.stop(0)

datapin = 2 -- GPIO4, ESP-201: IO4
powerpin = 1 -- GPIO5, ESP-201: IO5

sleep = 30*60 -- seconds
-- sleep = 10 -- seconds

key = "xxxxxxxxxxxxxxxxxxxxxx"
trigger = "lampotila"

function start()
  status, temp, humi, temp_dec, humi_dec = dht.read(datapin)
  if status == dht.OK then
    print("DHT Temperature:"..temp..";".."Humidity:"..humi)
  elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
  end

  voltage = adc.readvdd33(0)
  print("System voltage (mV):", voltage)

  location = "http://maker.ifttt.com/trigger/" .. trigger .. "/with/key/" .. key
  url = location .. "?value1=" .. temp .. "&value2=" .. humi .. "&value3=" .. voltage
  http.get(url, nil, function() node.dsleep(sleep * 1000000) end)
end

function wait_ip()
  if wifi.sta.getip() then
    tmr.stop(0)
    print(wifi.sta.getip())
    start()
  end
end

gpio.mode(powerpin, gpio.OUTPUT)
gpio.write(powerpin, gpio.HIGH)
tmr.alarm(0, 2000, tmr.ALARM_AUTO, wait_ip)
