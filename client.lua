local socket = require("socket")
local json = require("json")

local udp = socket.udp()
udp:setpeername("127.0.0.1", 1234)

udp:send("hi")
local data = assert(udp:receive())
local my = json.parse(data)
print("I am", my.ip, my.port)

local data = assert(udp:receive())
local peer = json.parse(data)
print("I see", peer.ip, peer.port)

assert(udp:close())

local udp2 = assert(socket.udp())
assert(udp2:setsockname('*', my.port))
print("sending hello")
assert(udp2:sendto("hello", peer.ip, peer.port))
os.execute("sleep 1")
print("sending hello")
assert(udp2:sendto("hello", peer.ip, peer.port))
while true do
	local data = assert(udp2:receive())
	print("received", data)
	assert(udp2:sendto("hohai", peer.ip, peer.port))
end

