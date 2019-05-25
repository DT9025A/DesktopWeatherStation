--[[
	ntp.lua
	
	Description:
	Sync time from ntp server
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	syncTime()
		Sync time from ntp server
	
	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--
require("timeStamp")

function syncTime()
	sntp.sync({"edu.ntp.org.cn", "cn.ntp.org.cn"}, function(lSec, lUsec, lServer, lInfo)
		print('sync from', lServer, ",", lSec, "secs from year 1970")
		local lYear,lMonth,lDate,lHour,lMinute,lSec = unixToDate(lSec, 8)
		print(lYear, "/", lMonth, "/", lDate, "\n", lHour, ":", lMinute, ":", lSec, "\nGMT ", 8)
	end, function()
		print("Filed to sync time")
	end)
end