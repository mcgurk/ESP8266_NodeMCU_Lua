Needed for waking up from deepsleep:  
NodeMCU: RST -> GPIO16 / D0  
ESP-201: RST -> XPD (pin8, GPIO16) (take red led away to get more power savings)

No need to test if dht.read is nil because failed read gets -999 and -999.  
There is no problem with adc.readvdd33(0) also because it gets 65535 if failed.  

todo:  
- 2s for DHT22 and then 0,1s for netloop  
- maximum time (10s) and then deepsleep  
- test if dhtpower pin is down in deepsleep
- check how much time one wakeperiod takes

If no wifi-connection
HTTP client: DNS failed for maker.ifttt.com
comes in 5s.

#### IFTTT

- ifttt.com
- My Applets -> New Applet
- this: Maker Webhooks -> Receive a web request
- give name for applet
- that: Google Drive -> Add row to spreadsheet
- Spreadsheet name:
- Formatted row:
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

#### Google Docs Spreadsheet date-/time-settings

- File -> Spreadsheet settings -> Language -> United States
- File -> Spreadsheet settings -> Always use English function names
- Date-/time-column: Format -> number -> date and time


#### Chart
- https://developers.google.com/chart/interactive/docs/quick_start
- https://developers.google.com/chart/interactive/docs/spreadsheets#sheet-name
