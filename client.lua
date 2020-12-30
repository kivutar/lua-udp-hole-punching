local socket = require("socket")
local json = require("json")

local rdv = socket.udp()
rdv:setpeername(arg[1], arg[2])

rdv:send("hi")
local data = assert(rdv:receive())
local my = json.parse(data)
print("I am", my.ip, my.port)

local data = assert(rdv:receive())
local peer = json.parse(data)
print("I see", peer.ip, peer.port)

assert(rdv:close())

local p2p = assert(socket.udp())
assert(p2p:settimeout(0))
assert(p2p:setsockname('*', my.port))

print("sending hello")
assert(p2p:sendto("hello", peer.ip, peer.port))
while true do
	local data = assert(p2p:receive())
	print("received", data)
	if data == "hohai" then break end
	assert(p2p:sendto("hohai", peer.ip, peer.port))
end

