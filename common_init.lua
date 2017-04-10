-- init.lua

mainfile = "main.lua"

local function startup()
  s = nil
  print("Normal startup")
  dofile(mainfile)
end

function s() -- do shortcut for abort
  print("Abort startup!")
  tmr.stop(0)
end

wifi.setmode(wifi.STATION)
w = wifi.sta.config -- do shortcut for wifi-settings
print() print()
print("*** s() to abort startup (give command in 2 seconds)")
print("*** w(\"ssid\",\"password\") to change Wifi-settings")
print() print()

tmr.alarm(0, 2000, 0, startup)
