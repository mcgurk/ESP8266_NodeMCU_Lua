# ESP8266_NodeMCU_Lua

#### Blink
led=4 gpio.mode(led,1) Q=0 tmr.alarm(0,1000,1,function() gpio.write(led,Q) Q=1-Q end)

#### Docs
https://nodemcu.readthedocs.io/en/master/

#### Firmware
https://nodemcu-build.com/

#### Windows flasher (includes eraser)
https://github.com/marcelstoer/nodemcu-pyflasher/releases/download/v0.2.0/NodeMCU-PyFlasher-0.2.0.exe

#### Lua IDE
http://esp8266.ru/esplorer-latest/?f=ESPlorer.zip


#### PINS
http://nodemcu.readthedocs.io/en/dev/en/modules/gpio/

http://www.forward.com.au/pfod/ESP8266/GPIOpins/index.html
- NodeMCU/Lua -> ESP8266
- 0 -> GPIO16 (XPD, needed for automatic wake from deepsleep)
- 1 -> GPIO5
- 2 -> GPIO4
- 3 -> GPIO0 (flash mode selector - must be high at normal boot)
- 4 -> GPIO2 (must be high at boot) (blue LED in NodeMCU)
- 5 -> GPIO14
- 6 -> GPIO12
- 7 -> GPIO13 (CTS)
- 8 -> GPIO15 (boot from -selector - must be low at normal boot) (RTS)
- 9 -> GPIO3 (RX)
- 10 -> GPIO1 (TX) (blue LED in ESP-201)
- 11 -> GPIO9
- 12 -> GPIO10

#### NodeMCU
https://raw.githubusercontent.com/nodemcu/nodemcu-devkit/master/Documents/NODEMCU_DEVKIT_SCH.png

#### ESP-201
- USB TTL <--> ESP8266 ESP-201
- VCC -- VCC
- GND -- GND
- TX -- RX (GPIO_3)
- RX -- TX (GPIO_1, blue LED)
- GND -- GPIO15 (boot source: flash) (can be permanent)
- 3.3V -- CHIP_EN (can be permanent)
- DTR -- IO0 (GPIO0) (Arduino IDE automatic flash (reset mode: ck))
- RTS -- RST (Arduino IDE automatic flash (reset mode: ck))

I/O-pins
- IO0 = NodeMCU 3 (GPIO0 ?) (flash mode! be carefull!)
- IO2 = NodeMCU 4 (GPIO2 ?)
- IO4 = NodeMCU 2 (GPIO4 ?)
- IO5 = NodeMCU 1 (GPIO5 ?)
- IO12 = NodeMCU 6 (GPIO12 ?)
- IO13 = NodeMCU 7 (GPIO13 ?)
- IO14 = NodeMCU 5 (GPIO14 ?)
