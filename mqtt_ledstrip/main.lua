-- main.lua

mqttclient = require("mqttclient")

strip = require("strip")
strip.start()

PINK = { 100, 20, 10 }

print("Save pixelcount: send mqtt message \"save,50\"")
print("or savecfg(\"pixelcount.cfg\", \"PIXELCOUNT\", 50)")

function savecfg(filename, variable, value)
  local line = variable .. " = " .. value
  file.remove(filename)
  file.open(filename, "w+");
  file.writeline(line)
  file.close()
  send_status("*" .. variable .. " = " .. value .. "* saved to " .. filename)
end

function showcfg(filename)
  file.open(filename, "r")
  print("*" .. file.readline() .. "*")
  file.close();
end

mqttclient.start( function(conn, topic, input)
    print("mqtt callback")
    print("mqtt input: " .. input)
    print("mqtt input type: " .. type(input))
    local a = tonumber(input)
    if a then 
      print("number")
      strip.location(a)
      return
    end
    print("not number")
    local t={}
    for x in string.gmatch(input, "([^,]+)") do table.insert(t, x) end
    for key,value in pairs(t) do print(key,value) end
    cmd = string.upper(t[1])
    --table.remove(t,1)
    local n={}
    for key,value in pairs(t) do n[key] = tonumber(value) end
    print("command: " .. cmd)
    if cmd == "ON" then 
      strip.rainbow()
    elseif cmd == "OFF" then 
      strip.off()
    elseif cmd == "KITT" then
      strip.kitt()
    elseif cmd == "TRAVELLER" then
      strip.kitt(0.8, 20, n[2], n[3], n[4])
    elseif cmd == "RAINBOW" then
      strip.rainbow(n[2])
    elseif cmd == "POINT" then
      strip.point(nil, nil, n[2], n[3], n[4])
    elseif cmd == "COLOR" then
      strip.color(n[2], n[3], n[4])
    elseif cmd == "SAVE" then
      if n[2] then
        savecfg("pixelcount.cfg", "PIXELCOUNT", n[2])
        strip.off()
        strip.start()
        strip.color(100, 100, 100)
      else
        send_status("pixelcount.cfg not saved!")
      end
    else
      print("Unknown command")
    end 
  end)

