print("init.lua - Skrolli")

local tiedosto = "ohjelma.lua" -- Sen tiedoston nimi, joka suoritetaan initin jälkeen
local nappi = 3 -- NodeMCU:n Flash-nappi
local led = 4 -- NodeMCU:n sininen led

wifi.setmode(wifi.STATION) -- varmistetaan, että ESP ei ole turhaan tukiasema

-- vilkutetaan lediä merkiksi siitä, että ohjelma on käynnissä
gpio.mode(led, gpio.OUTPUT) 
local Q=0 
tmr.alarm(0, 100, tmr.ALARM_AUTO, function() 
    gpio.write(led, Q)
    Q=1-Q
  end)

-- asetetaan napille keskeytys, jolla voi keskeyttää init.lua:n suoritus
gpio.mode(nappi, gpio.INT)
gpio.trig(nappi, "down", function()
    gpio.mode(nappi, gpio.INPUT) -- poistetaan keskeytys käytöstä
    tmr.stop(0) -- pysäytetään ledin vilkutusajastin
    tmr.stop(1) -- pysäytetään verkkoyhteyden odotusajastin
    tmr.stop(2) -- pysäytetään WiFi-asetustukiasemajastin
    gpio.write(led, gpio.HIGH) -- sammutetaan led
    print("init.lua keskeytetty!")
  end)

-- tarkistetaan 2s välein, onko verkkoyhteys saatu
tmr.alarm(1, 2000, tmr.ALARM_AUTO, function() 
    if wifi.sta.getip() then
      tmr.stop(0) -- pysäytetään ledin vilkutusajastin
      tmr.stop(1) -- pysäytetään verkkoyhteyden odotusajastin
      tmr.stop(2) -- pysäytetään WiFi-asetustukiasemajastin
      gpio.write(led, gpio.HIGH) -- sammutetaan led
      print("IP: " .. wifi.sta.getip())
      print("Suoritetaan tiedosto \"" .. tiedosto .. "\"")
      dofile(tiedosto) -- jos verkkoyhteys on saatu, suoritetaan tiedosto
    end
  end)

-- jos verkkoyhteyttä ei ole saatu 10s aikana, käynnistetään WiFi-asetustukiasema
tmr.alarm(2, 10000, tmr.ALARM_SINGLE, function()
    print("Käynnistetään enduser setup")
    tmr.interval(0, 500) -- hidastetaan merkiksi ledin välkkymistä
    enduser_setup.start(function() 
        tmr.alarm(3, 2000, tmr.ALARM_SINGLE, function() 
            node.restart() -- 2s päästä asetusten talletuksesta bootataan
          end)
      end)
  end)
