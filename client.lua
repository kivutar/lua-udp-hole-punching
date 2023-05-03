local socket = require("socket")

-- split on :
local function split(s)
	local r = {}
	for w in s:gmatch("[^:]+") do
		table.insert(r, w)
	end
	return r
end

local rdv = socket.udp()
rdv:setpeername(arg[1], arg[2])

rdv:send("hi")
local data = assert(rdv:receive())
local my = split(data)
print("I am", my[1], my[2], my[3])

local data = assert(rdv:receive())
local peer = split(data)
print("I see player idx", peer[1], peer[2], peer[3])

assert(rdv:close())

local p2p = assert(socket.udp())
--assert(p2p:settimeout(0))
assert(p2p:setsockname('*', my[3]))

if my[2] == peer[2] then
	my[2] = "127.0.0.1"
	peer[2] = "127.0.0.1"
end

print("sending hello")
os.execute("sleep 1")
assert(p2p:sendto("hello", peer[2], peer[3]))

local data = p2p:receive()
if data ~= nil then print("received", data) end

print("sending hohai")
os.execute("sleep 1")
assert(p2p:sendto("hohai", peer[2], peer[3]))

local data = p2p:receive()
if data ~= nil then print("received", data) end
