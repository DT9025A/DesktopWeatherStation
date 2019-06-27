require("wlan")
require("xpt2046")

-- wlan init
wifi.setmode(wifi.STATION)
registerWlanEvents()

--xpt2046 init
initXPT2046(15, 2, 240, 320, XPT2046NormalIRQ)
gpio.mode(0, gpio.OUTPUT)
gpio.write(0, LOW)
