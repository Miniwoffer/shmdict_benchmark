local rnd = math.random
local shmd = ngx.shared.shmd
local format = string.format
local worker_id = ngx.worker.id()

local socket = require("socket")
local function time() return socket.gettime() * 1000 end

collectgarbage("collect")
ngx.update_time()

local start = time();
local index = 0

for _ = 1, rounds do
	for i = 1, keys do
		if random_access then
			index = rnd(1, keys)
		else
			index = i
		end
		-- shm set
		local foo = shmd:get(index, 0)
		if foo == nil then
			ngx.log(ngx.ERR, format("didnt get %d", index))
		end
	end
end
collectgarbage("collect")
ngx.update_time()
local end_noflags = time()
for _ = 1, rounds do
	for i = 1, keys do
		if random_access then
			index = rnd(1, keys)
		else
			index = i
		end
		-- shm set
		local foo = shmd:get(index, index)
		if foo then
			ngx.log(ngx.ERR, format("didnt get %d", index))
		end
	end
end
collectgarbage("collect")
local end_flags = time()

local faster = ((end_noflags-start)/(end_flags-end_noflags) - 1) * 100
ngx.update_time()
ngx.log(ngx.ERR,format("worker: %d %.02f", worker_id, faster))

