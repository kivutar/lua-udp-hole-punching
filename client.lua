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
print("Punching")
assert(udp2:sendto("punch", peer.ip, peer.port))
local data = assert(udp2:receive())
print("received", data)

