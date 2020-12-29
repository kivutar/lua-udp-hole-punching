local socket = require("socket")
local json = require("json")

local udp = socket.udp()
udp:setsockname('*', 1234)

local map = {}

while true do
	data, ip, port = udp:receivefrom()
	print(data, ip, port)
	if data == "hi" then
		local id = ip..":"..port
		map[id] = {}
		map[id].ip = ip
		map[id].port = port
		local o = {ip=ip, port=port}
		udp:sendto(json.stringify(o), ip, port)
	elseif data == "list" then
		udp:sendto(json.stringify(map), ip, port)
    end
end

