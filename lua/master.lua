local shmd = ngx.shared.shmd

local rnd = math.random
local char = string.char
local concat = table.concat
local size = 1
local tbl = {}

return function()
	for i = 1, keys do
		if value_type == "number" then
			local ok, err = shmd:set(i, rnd(0,100000000000), 0, i)
			if not ok then
				ngx.log(ngx.ERR, err)
				return
			end
		else
			for j = 1, value_len do
				tbl[j] = char(rnd(0,255))
			end
			value = concat(tbl)
			-- shm set
			local ok, err = shmd:set(i, value, 0, i)
			if not ok then
				ngx.log(ngx.ERR, err)
				return
			end
		end
	end
end
