--[[
	xpt2046.lua
	
	Description:
	xpt2046
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	
	
	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--

local lgStep = 0
local lxLT, lyLT, lxRB, lyRB

function initXPT2046(pCS, pIRQ, pWidth, pHeight, trigCallBack)
	spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 16, spi.FULLDUPLEX)
	xpt2046.init(pCS, pIRQ, pWidth, pHeight)
	gpio.mode(pIRQ, gpio.INT, gpio.PULLUP)
	gpio.trig(pIRQ, "down", trigCallBack)
end

function calibrateXPT2046()
	gpio.trig(2, "down", XPT2046CalibrateIRQ)
	lgStep = 0
end

function readXPT2046()
	local lX, lY
	print(lX .. ":" .. lY)
end

function XPT2046NormalIRQ()
	gpio.write(0, HIGH)
	tmr.sleep(5)
	gpio.write(0, LOW)
end

function XPT2046CalibrateIRQ()
	if lgStep == 0 then
		lxLT, lyLT = xpt2046.getRaw()
		print("RB")
		lgStep = 1
	else
		lxRB, lyRB = xpt2046.getRaw()
		xpt2046.setCalibration(lxLT, lyLT, lxRB, lyRB)
		print("OK")
		gpio.trig(2, "down", XPT2046NormalIRQ)
	end
end
