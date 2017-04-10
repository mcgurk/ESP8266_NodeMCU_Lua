datapin = 2 -- GPIO4, ESP-201: IO4
sleep = 30*60 -- seconds
key = "xxxxxxxxxxxxxxxxxxxxxx"
trigger = "lampotila"

function start()
  status, temp, humi, temp_dec, humi_dec = dht.read(datapin)
  voltage = adc.readvdd33(0)
  location = "http://maker.ifttt.com/trigger/" .. trigger .. "/with/key/" .. key
  url = location .. "?value1=" .. temp .. "&value2=" .. humi .. "&value3=" .. voltage
  http.get(url, nil, function() node.dsleep(sleep * 1000000) end)
end
