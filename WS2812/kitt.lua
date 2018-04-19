-- ring1.lua

function black()
    strip_buffer:fill(0, 0, 0)
    ws2812.write(strip_buffer)
end

local gnd = 5 -- D5
local btn = 6 -- D6
local brightness = 255
lock = false
gpio.mode(gnd, gpio.OUTPUT)
gpio.write(gnd, gpio.LOW)

gpio.mode(btn, gpio.INT, gpio.PULLUP)

gpio.trig(btn, "both", function()
    if not lock then
        lock = true
        tmr.create():alarm(50, tmr.ALARM_SINGLE, function()
            lock = false
            if gpio.read(btn) == gpio.LOW then
                ws2812_effects.set_color(20,255,147)
            else
                ws2812_effects.set_color(0,0,0)
            end
          end)
    end
  end)


-- init the ws2812 module
ws2812.init(ws2812.MODE_SINGLE)
-- create a buffer, 24 LEDs with 3 color bytes
strip_buffer = ws2812.newBuffer(24, 3)
-- init the effects module, set color to red and start blinking
ws2812_effects.init(strip_buffer)
ws2812_effects.set_mode("larson_scanner")
ws2812_effects.set_color(0,0,0)
ws2812_effects.set_speed(250)
ws2812_effects.set_delay(10)
ws2812_effects.start()
