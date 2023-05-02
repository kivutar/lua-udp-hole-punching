local socket = require("socket")

local udp = socket.udp()
udp:setsockname('*', arg[1] or 1234)
print("Listening on", '*', arg[1] or 1234)

local p1 = nil
local p2 = nil

while true do
	data, ip, port = udp:receivefrom()
	print("Received", data, ip, port)
	if data == "hi" then
		if p1 == nil then
			p1 = {ip=ip, port=port, idx=1}
			udp:sendto(p1.idx .. ":" .. p1.ip .. ":" .. p1.port, p1.ip, p1.port)
		else
			p2 = {ip=ip, port=port, idx=2}
			udp:sendto(p2.idx .. ":" .. p2.ip .. ":" .. p2.port, p2.ip, p2.port)
			udp:sendto(p2.idx .. ":" .. p2.ip .. ":" .. p2.port, p1.ip, p1.port)
			udp:sendto(p1.idx .. ":" .. p1.ip .. ":" .. p1.port, p2.ip, p2.port)
			p1 = nil
			p2 = nil
		end
    end
end

