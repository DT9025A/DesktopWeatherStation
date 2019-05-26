--[[
	timeStamp.lua
	
	Description:
	Shift Unix timestamp and date
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	[LOCAL] int leapYear(pYear)
		return the number of days in February of this year
	
	year, month, date, hour, minute, second unixToDate(pTimestamp, pTargetZone)
		shift unix timestamp to date
		
	unixTimeStamp dateToUnix(pYear, pMonth, pDate, hour, pMinute, pSecond, pSourceZone)
		shift date to unix timestamp

	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--

require("extend") --使用int()

local lgDayTab = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31} --日期表

local function leapYear(pYear)
	if pYear % 400 == 0 then
		return 29
	elseif pYear % 100 == 0 then
		return 28
	elseif pYear % 4 == 0 then
		return 29
	end
	return 28
end

function unixToDate(pTimestamp, pTargetZone)
	local lMonth, lYear, lDate
	pTimestamp = pTimestamp + pTargetZone * 3600
	lMonth = 0
	lDate = int(pTimestamp / 86400) --时间戳表示的天数
	lYear = 1970 --起始年份
	
	--计算整年
	while true do
		lMonth = 337 + leapYear(lYear)
		if lDate > lMonth then
			lDate = lDate - lMonth
			lYear = lYear + 1
		else
			break
		end
	end

	lgDayTab[2] = leapYear(lYear)
	lMonth = 1
	
	--计算整月
	while true do
		if lDate > lgDayTab[lMonth] then
			lDate = lDate - lgDayTab[lMonth]
			lMonth = lMonth + 1
		else
			break
		end
	end
	
	--日期
	lDate = 1 + lDate
	
	--更正不合法格式
	if lDate > lgDayTab[lMonth] then
		lDate = lDate - lgDayTab[lMonth]
		lMonth = 1 + lMonth
	end
 
	if lMonth > 12 then
		lMonth = lMonth - 12
		lYear = 1 + lYear
	end

	if lDate < 1 then
		lMonth = lMonth - 1
		lDate = lgDayTab[lMonth]
	end

	return lYear, lMonth, lDate, int(pTimestamp / 3600) % 24, int((pTimestamp % 3600) / 60), pTimestamp % 60
end

local function dateToUnix(pYear, pMonth, pDate, pHour, pMinute, pSecond, pSourceZone)
	local lDays, lTemp
	lDays = 0
	
	--源时间不合法
	if pYear < 1970 then
		return -1
	end

	--整年
	for lTemp = 1970, pYear - 1, 1 do
		lDays = lDays + leapYear(lTemp) + 337
	end

	lgDayTab[2] = leapYear(pYear)

	--整月
	for lTemp = 1, pMonth - 1, 1 do
		lDays = lDays + lgDayTab[lTemp]
	end

	--日
	lDays = lDays + pDate - 1

	return ((lDays * 24 + pHour - pSourceZone) * 60 + pMinute) * 60 + pSecond
end
