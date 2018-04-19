-- ring1.lua

function black()
    strip_buffer:fill(0, 0, 0)
    ws2812.write(strip_buffer)
end

local gnd = 5 -- D5
local btn = 6 -- D6
-- local brightness = 50
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
                --ws2812_effects.set_delay(10)
                --ws2812_effects.set_brightness(brightness)
                ws2812_effects.set_mode("circus_combustus")
                ws2812_effects.set_brightness(255)
                ws2812_effects.start()
            else
                --ws2812_effects.set_brightness(0)
                --ws2812_effects.set_delay(100)
                ws2812_effects.stop()
                black()
            end
          end)
    end
  end)


ws2812.init(ws2812.MODE_SINGLE)
strip_buffer = ws2812.newBuffer(24, 3)
ws2812_effects.init(strip_buffer)
--
ws2812_effects.set_mode("circus_combustus")
ws2812_effects.set_delay(10)
ws2812_effects.set_speed(250)
ws2812_effects.set_brightness(0)
--
--ws2812_effects.start()
black()
