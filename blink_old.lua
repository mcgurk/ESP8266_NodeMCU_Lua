-- blink_old.lua

ledPin = 4
gpio.mode(ledPin, gpio.OUTPUT)
lighton=0
tmr.alarm(0,1000,1,function()
if lighton==0 then
    lighton=1
    gpio.write(ledPin, gpio.HIGH)
else
    lighton=0
    gpio.write(ledPin, gpio.LOW)
end
end)
print("Blinking")

-- tmr.stop(0)
