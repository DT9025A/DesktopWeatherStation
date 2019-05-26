--[[
	httpRequest.lua
	
	Description:
	Implement of basic HTTP GET/POST methods
	
	Creator:
	DT9025A
	
	Modifier:
	
	Functions:
	[LOCAL] Host, Dir subHost(pURL)
		split host and dir from url

	StatusCode httpRequest(pURL, pMeta, pHeaders, pPort, pCallBackFunc)
		HTTP request body
		pURL:target url
		pMeta:{method:"GET/POST"[, data="..."(if post)]} (CAN NOT BE NULL)
		pHeaders:{inherit:true/false[, ...]} ("Connection: Close\r\nUser-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; zh-CN; rv:1.9.2.4) Gecko/20100513 Firefox/3.6.4\r\nAccept: */*\r\n" for default & inherit
			'-' in header name should be replaced with '_')
		pPort:server port (80 for default)
		pCallBackFunc:callback function with connection object, received text as argument

	Variable naming rules:
	local variable in function [lName]
	local variable in this file [lgName]
	parameter variable in function [pName]
	variable in function [Name]
	variable in this file [gName]
]]--

local lgHeader = nil

local function subHost(pURL)
	local lHost = pURL, lDir, lTemp

	if pURL:find("://", 1) ~= nil then
		lHost = pURL:sub(pURL:find("://", 1) + 3, pURL:len())
	end

	lTemp = lHost:find("[/?]", 1)
	if lTemp ~= nil then
		lHost = lHost:sub(1, lTemp - 1)
	end

	lDir = pURL:sub(pURL:find(lHost, 1) + lHost:len(), pURL:len())

	if lDir:sub(1, 1) ~= "/" then
		lDir = "/" .. lDir
	end

	return lHost, lDir
end


function httpRequest(pURL, pMeta, pHeaders, pPort, pCallBackFunc)
	local lHost, lDir = subHost(pURL)
	local lPostBody = ""

	if pMeta.method == nil then
		return -1
	end

	--设置Headers
	lgHeader = "Connection: Close\r\nUser-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; zh-CN; rv:1.9.2.4) Gecko/20100513 Firefox/3.6.4\r\nAccept: */*\r\n"
	if pHeaders ~= nil then
		if pHeaders.inherit ~= nil and pHeaders.inherit == false then
			lgHeader = ""
		end
		for lHeader, lContent in pairs(pHeaders) do
			lgHeader = lgHeader .. lHeader:gsub("_", "-") .. ": " .. lContent .. "\r\n"
		end
	end

	connection = net.createConnection(net.TCP, 0)

	--注册接收事件
	if pCallBackFunc ~= nil then
		connection:on("receive", pCallBackFunc)
	else
		connection:on("receive", function(connection, plainText)
			print(plainText)
		end)
	end

	--设置Content-Length段
	if pMeta.method:upper() == "POST" then
		if lgHeader.find("Content-Length", 1) == nil then
			if pMeta.data ~= nil then
				lPostBody = pMeta.data
				lgHeader = lgHeader .. "Content-Length: " .. lPostBody:len() .. "\r\n"
			end
		else
			lgHeader = lgHeader .. "Content-Length: 0\r\n"
		end
	end

	--注册连接事件
	connection:on("connection", function(connection, plainText)
		connection:send(pMeta.method:upper() .. " " .. lDir .. " HTTP/1.1\r\nHost: " .. lHost .. "\r\n" .. lgHeader .. "\r\n" .. lPostBody)
		--释放内存
		lgHeader = nil
		pURL = nil
		pMeta = nil
		pHeaders = nil
		lDir = nil
		lHost = nil
	end)

	if pPort == nil then
		pPort = 80
	end

	connection:connect(pPort, lHost)

	return 0
end
