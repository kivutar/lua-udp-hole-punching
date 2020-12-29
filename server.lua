local socket = require("socket")
local json = require("json")

local udp = socket.udp()
udp:setsockname('*', 1234)

local first = nil
local second = nil

while true do
	data, ip, port = udp:receivefrom()
	print(data, ip, port)
	if data == "hi" then
		if first == nil then
			first = {ip=ip, port=port}
			udp:sendto(json.stringify(first), first.ip, first.port)
		else
			second = {ip=ip, port=port}
			udp:sendto(json.stringify(second), second.ip, second.port)
			udp:sendto(json.stringify(second), first.ip, first.port)
			udp:sendto(json.stringify(first), second.ip, second.port)
		end
    end
end

