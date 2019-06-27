--[[
	extend.lua
	
	Description:
	Some extend functons
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	number int(pFloat)
		cast float to int

	bool typeVerify(pType, pParameter)
		verify parameter's type
		
	number getRunTime()
		get esp's running secs from start
		
	number tableLen(pTable)
		calculate length of a table
		
	table tableRemove(pTable, pIndex)
		remove object at pIndex in pTable
	
	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--

function int(pFloat)
	return pFloat - pFloat % 1
end

function typeVerify(pType, pParameter)
	if pType == type(pParameter) then
		return true
	end
	return false
end

function getRunTime()
	return int(tmr.now() / 1000000)
end

function tableLen(pTable)
	local lLength = 0
	if typeVerify("table", pTable) then
		for k,v in pairs(pTable) do
			lLength = lLength + 1
		end
	end
	return lLength
end

function tableRemove(pTable, pIndex)
	local lResult = {}
	local lResIndex = 1
	for lCount = 1, tableLen(pTable), 1 do
		if lCount ~= pIndex then
			lResult[lResIndex] = pTable[lCount]
			lResIndex = lResIndex + 1
		end
	end
	return lResult
end

