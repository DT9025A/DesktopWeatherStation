--[[
	wlan.lua
	
	Description:
	WLAN event registration
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	registerWlanEvents()
		register wlan event {STA_DISCONNECTED, STA_CONNECTED, STA_GOT_IP}
		
	scanWlan()
		scan wlans and print it
		
	connectToWlan(pSSID, pPassword)
		
	
	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--

require("extend")
require("wlanRecord")

local lgIsDealing = false
local lgAuthMode = {"OPEN", nil, "WPA PSK", "WPA2 PSK", "WPA/WPA2 PSK"}

function registerWlanEvents()
	wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
		if lgIsDealing == false then
			lgIsDealing = true
			wifi.sta.getap(1, function (T)
				local lPassword, lWLANs, lIndex, lConfig
				lConfig = wifi.sta.getconfig()
				lIndex = 1
				lWLANs = {}
				for lBSSID, lValue in pairs(T) do
					local lSSID = string.match(lValue, "([^,]+),([^,]+),([^,]+),([^,]*)")
					lWLANs[lIndex] = lSSID
					lIndex = lIndex + 1
				end
				for lIndex = 1, tableLen(lWLANs), 1 do
					lPassword = enumerationWLAN(lWLANs[lIndex])
					if lPassword ~= nil then
						wifi.sta.config({ssid = lWLANs[lIndex], pwd = lPassword})
						print("Config:", lWLANs[lIndex], lPassword)
					end
				end
				lgIsDealing = false
				if lPassword == nil then
					print("No connected WLAN, please add new one.")
					lgIsDealing = true
				end
			end)
		end
	end)
	wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
		print("\n\tSTA - CONNECTED" .. "\n\tSSID: " .. T.SSID .. "\n\tBSSID: " .. T.BSSID .. "\n\tChannel: " .. T.channel)
	end)
	wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
		print("\n\tSTA - GOT IP" .. "\n\tStation IP: " .. T.IP .. "\n\tSubnet mask: " .. T.netmask .. "\n\tGateway IP: " .. T.gateway)
	end)
end

function scanWlan()
	wifi.sta.getap(1, function (T)
		local lWLANs = {}
		for lBSSID, lValue in pairs(T) do
			local lSSID, lRSSI, lAUTH = string.match(lValue, "([^,]+),([^,]+),([^,]+),([^,]*)")
			lWLANs[lSSID] = lAUTH
		end
		for k, v in pairs(lWLANs) do
			print(k, lgAuthMode[v + 1])
		end
	end)
end

function connectToWlan(pSSID, pPassword)
	addWLAN(pSSID, pPassword)
	wifi.sta.config({ssid = "_-_-_", pwd = "-_-_-"})
	lgIsDealing = false
end

