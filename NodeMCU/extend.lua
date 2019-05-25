--[[
	extend.lua
	
	Description:
	Some extend functons
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	int int(pFloat)
		cast float to int

	int table_len(pTable)
		calculate length of a table
	
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

function table_len(pTable)
	local lLength = 0
	for k,v in pairs(pTable) do
		lLength = lLength + 1
	end
	return lLength
end
