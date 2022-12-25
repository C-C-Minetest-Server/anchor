local WP = minetest.get_worldpath()
local BASE = WP .. DIR_DELIM .. "anchor_networks" .. DIR_DELIM
minetest.mkdir(BASE)

local data = {}
local fx = {}

function fx.load(name)
	local file = io.open(BASE .. name, "rb")
	if file then
		local content = file:read("*all")
		return minetest.deserialize(content)
	else
		return {}
	end
end

function fx.get(name)
	if not data[name] then
		data[name] = fx.load(name)
	end
	return table.copy(data[name])
end

function fx.get_anchor(name,pos)
	local idata = fx.get(name)
	if idata[pos] then
		local ianchor = table.copy[idata[pos]]
		ianchor.pos = pos
		return ianchor
	end
	return false
end

function fx.save(name,idata)
	data[name] = idata
	minetest.safe_file_write(BASE .. name,minetest.serialize(idata))
end

function fx.add_anchor(name,pos,def)
	local idata = fx.get(name)
	idata[pos] = def
	fx.save(name,idata)
end

function fx.remove_anchor(name,pos)
	fx.add_anchor(name,pos,nil)
end

anchor.storage = fx
