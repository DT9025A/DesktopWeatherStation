--[[
	dht11.lua
	
	Description:
	DHT11 operations
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	readDHT(pPin)
		Read DHT11 measurements from specified pin

	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--

function readDHT(pPin)
	lStatus,lTemperature,lHumidity,lTemperatureFloat,lHumidityFloat = dht.read11(pPin)
	
	if lStatus == dht.OK then
		print(lTemperature .. "." .. lTemperatureFloat .. "," .. lHumidity .. "." .. lHumidityFloat)
	else
		print("ERROR")
	end
	
end
