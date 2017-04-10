local nappi = 3 -- NodeMCU:n Flash-nappi
local event = "nappi" -- IFTTT:n tapahtuman nimi
local key = "xxxxxxxxxxxxxxxxxxxxxx" -- henkilökohtainen IFTTT-avain
local lukko = false -- "debounce"-muuttuja
gpio.mode(nappi, gpio.INT) -- I/O-pinnin keskeytys päälle
gpio.trig(nappi, "down", function() -- kun nappi painuu alas, suoritetaan HTTP-pyyntö IFTTT:lle
    if not lukko then
      http.get("http://maker.ifttt.com/trigger/" .. event .. "/with/key/" .. key)
      print("Nappi!")
      lukko = true
      tmr.alarm(0, 1000, tmr.ALARM_SINGLE, function()
          lukko = false -- vapautetaan lukko 1s päästä
        end)
    end
  end)
  
