local socket = require("socket")
local json = require("json")

local udp = socket.udp()
udp:setpeername("127.0.0.1", 1234)

udp:send("hi")
local data = udp:receive()
local my = json.parse(data)
print("I am", my.ip, my.port)

udp:send("list")
local data = udp:receive()
local map = json.parse(data)

local peer = nil
for k,p in pairs(map) do
	if p.ip ~= my.ip or p.port ~= my.port then
		peer = p
		break
	end
end
assert(udp:close())

if peer == nil then
	print("acting as server on", my.ip, my.port)
	local udp2 = assert(socket.udp())
	assert(udp2:setsockname('*', my.port))
	while true do
		local data, ip, port = assert(udp2:receivefrom())
		print("received", data, ip, port)
		peer = {ip=ip, port=port}
		assert(udp2:sendto("hohai", peer.ip, peer.port))
	end
end

if peer ~= nil then
	print("acting as client for", peer.ip, peer.port)
	print("sending hello")
	local udp2 = assert(socket.udp())
	assert(udp2:setpeername(peer.ip, peer.port))
	assert(udp2:send("hello"))
	while true do
		local data = assert(udp2:receive())
		print("received", data)
		assert(udp2:send("hohai"))
	end
end

