--blink_new.lua

led = 4
gpio.mode(led, gpio.OUTPUT) 
Q = 0 
T = tmr.create() 
T:register(1000, tmr.ALARM_AUTO, function() 
    gpio.write(led, Q) 
    if Q == 0 then 
      Q = 1 
    else 
      Q = 0 
    end 
  end) 
T:start()

-- T:stop()
