#### NodeMCU
- RST -> GPIO16 / D0 (needed for waking up from deepsleep)
- USB-Serial-port-chip takes some current all the time (3-4mA)

#### ESP-201
- RST -> XPD (pin8, GPIO16) (needed for waking up from deepsleep)
- 22k: 3.3V - CHIP_EN (10k would be better?)
- 22k: GND - IO15 (10k would be better?)
- 220µF: GND - 3.3V (how to know which is right capacitance? how about type of capacitor?)
- take red led away to get more power savings
- https://www.letscontrolit.com/wiki/index.php/Power
An extra capacitor is needed with value between 1uF and 10uF. Preferable a tantalum type because of its excellent high frequency properties. This capacitor can best be placed as close to the module as possible
- Voltage:
https://www.reddit.com/r/esp8266/comments/329nxo/17v_current_consumption_power_usage/
According to specs, the module works between 1.7V - 3.6V. The chip itself is only stable from ~2.5V-~4.2V according to thread. I used 3xAA Eneloop: at start almost 4.5V!


#### Misc
No need to test if dht.read is nil because failed read gets -999 and -999.  
There is no problem with adc.readvdd33(0) also because it gets 65535 if failed.  

If no wifi-connection
HTTP client: DNS failed for maker.ifttt.com
comes in 5s.  

todo:  
- test if dhtpower pin is down in deepsleep (goes about 0,12V. I put it implicity LOW)
- check how much time one wakeperiod takes
- 22k in IO15 (RTS) is quite high. Does it work with e.g. MAX3232? Measured 0,19V when connected to CTS.

### Lua
https://nodemcu-build.com/
- ADC
- DHT
- HTTP
- (adc dht file gpio http net node tmr uart wifi)

https://github.com/marcelstoer/nodemcu-pyflasher
- ESP-201: GND -> GND, 3.3V -> 3.3V, RX -> TX, TX -> RX, RTS -> RST, DTR -> IO0

### Settings (must do one time only)
- adc.force_init_mode(adc.INIT_VDD33)
- wifi.setmode(wifi.STATION)
- wifi.sta.config("ssid","passwd")

Test:
- print(wifi.sta.getip())
- print(adc.readvdd33(0))

### IFTTT

- ifttt.com
- My Applets -> New Applet
- this: Maker Webhooks -> Receive a web request
- give name for applet
- that: Google Drive -> Add row to spreadsheet
- Spreadsheet name:
- Formatted row (3xAA 1.2V Eneloop 1900mAh):
```
=TIMEVALUE(SUBSTITUTE("{{OccurredAt}}";" at ";" "))+DATEVALUE(SUBSTITUTE("{{OccurredAt}}";" at ";" ")) ||| {{EventName}} ||| {{Value1}} ||| {{Value2}} ||| {{Value3}} ||| =ROUND({{Value3}}/3)
```
- Drive folder path: IFTTT

After 2000 lines new file is created (not tested).

Google Docs doesn't recognize date-/time-format without this:
```
=TIMEVALUE(SUBSTITUTE("{{OccurredAt}}";" at ";" "))+DATEVALUE(SUBSTITUTE("{{OccurredAt}}";" at ";" "))
```
(convert from default format, if you accidentally use default format:)
```
=TIMEVALUE(SUBSTITUTE(INDIRECT("A"&ROW())," at "," "))+DATEVALUE(SUBSTITUTE(INDIRECT("A"&ROW())," at "," "))
```

### Google Docs Spreadsheet date-/time-settings

- File -> Spreadsheet settings -> Language -> United States
- File -> Spreadsheet settings -> Always use English function names
- Date-/time-column: Format -> number -> date and time
- Number data: Format -> number -> number
- Try to avoid "automatic"-format cells


### Chart
- https://developers.google.com/chart/interactive/docs/quick_start
- https://developers.google.com/chart/interactive/docs/spreadsheets#sheet-name
