--[[
	wlanRecord.lua
	
	Description:
	Record connected WLANs
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	[LOCAL] configJSON, configFile, result readFile()
		read WLAN recording file 'wlan.json'
	
	[LOCAL] startIndex, configJSON, configFile, result updateFile()
		make some preparation to update file
	
	[LOCAL] writeAndCloseFile(file, data)
		write and close file
		
	password, ssid enumerationWLAN(ssid)
		enumrate connected wlan in 'wlan.json'
	
	(boolean)result addWLAN(ssid, password)
		add a record to 'wlan.json'
		
	(boolean)result removeWLAN(ssid)
		remove record 'ssid' in 'wlan.json'

	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--

require("extend")

local function readFile()
	local lConfJson, lConfFile
	
	if file.exists("wlan.json") then
		lConfFile = file.open("wlan.json", "r")
		
		if lConfFile:read("\n") ~= nil then
			lConfFile:seek("set")
			lConfJson = sjson.decode(lConfFile:read("\n"))
		end
		
		return lConfJson, lConfFile, nil
	end
	
	return nil, nil, "Error in function wlanRecord/readFile()"
end

local function updateFile()
	local lIndex
	local lConfJson, lConfFile, lResult = readFile()
	
	if lResult ~= nil then
		return nil, nil, nil, lResult
	end
	
	if lConfJson ~= nil then
		lIndex = tableLen(lConfJson.wifi) + 1
		lConfFile.close()
		file.remove("wlan.json");
	else
		lConfJson = {wifi = {{ssid, pwd}}}
		lIndex = 1
	end
	
	lConfFile = file.open("wlan.json", "w+")
	return lIndex, lConfJson, lConfFile, nil
end

local function writeAndCloseFile(pFile, pData)
	pFile.write(pData)
	pFile.flush()
	pFile.close()
end

function enumerationWLAN(pSSID)
	local lConfJson, lConfFile, lResult = readFile()
	
	if lResult ~= nil then
		return lResult
	end
	
	if lConfFile ~= nil then
		lConfFile.close()
	end
	
	if lConfJson ~= nil then
		for lCount = 1, tableLen(lConfJson.wifi), 1 do
			if lConfJson.wifi[lCount].ssid == pSSID then
				return lConfJson.wifi[lCount].pwd, pSSID
			end
			
		end
	end
	
	return nil
end

function addWLAN(pSSID, pPWD)
	local lIndex, lConfJson, lConfFile, lResult = updateFile()
	
	if lResult ~= nil then
		return false
	end
	
	lConfJson.wifi[lIndex] = {ssid = pSSID, pwd = pPWD}
	writeAndCloseFile(lConfFile, sjson.encode(lConfJson) .. "\n")
	return true
end

function removeWLAN(pSSID)
	local lIndex, lConfJson, lConfFile = updateFile()
	
	if lConfJson.wifi ~= nil then
		for lIndex = 1, tableLen(lConfJson.wifi), 1 do
			if lConfJson.wifi[lIndex].ssid == pSSID then
				lConfJson.wifi = tableRemove(lConfJson.wifi, lIndex)
				break
			end
		end
		writeAndCloseFile(lConfFile, sjson.encode(lConfJson) .. "\n")
		return true
	else
		return false, "No recording(s)."
	end
end

