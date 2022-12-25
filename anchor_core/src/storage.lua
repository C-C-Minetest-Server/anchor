local WP = minetest.get_worldpath()
local NAME = WP .. DIR_DELIM .. "anchors.lua"
local S = minetest.get_translator("anchor_core")

anchor.log("action","Loading anchor storages...")
anchor.storage = {}

local file = io.open(NAME, "rb")
if file then
	local content = file:read("*all")
	anchor.storage = minetest.deserialize(content)
end

local function save()
	minetest.safe_file_write(NAME,minetest.serialize(anchor.storage))
end

local function save_rep()
	save()
	minetest.after(30,save_rep)
end

minetest.after(1,save_rep)

minetest.register_on_shutdown(save)

function anchor.update_anchor(pos,meta)
	if not meta then meta = minetest.get_meta(pos) end
	local data = {}
	data.uuid = meta:get_string("anchor_uuid")
	if data.uuid == "" then
		error("Invalid anchor passed into anchor.update_anchor.")
	end
	data.name = meta:get_string("anchor_name")
	if data.name == "" then
		data.name = S("Untitled Anchor")
		meta:set_string("anchor_name",data.name)
	end
	data.subtitle = meta:get_string("anchor_subtitle")
	data.description = meta:get_string("anchor_description")
	if data.description == "" then
		data.description = S("It is so mysterious so that nobody can give it a valid description.")
		meta:set_string("anchor_description",data.description)
	end
	local pos_string = minetest.pos_to_string(pos)
	anchor.storage[pos_string] = data
end

function anchor.generate_uuid(pos)
	local pos_string = minetest.pos_to_string(pos)
	local time = "" .. os.time()
	return pos_string .. time
end

function anchor.add_anchor(pos,def)
	-- def:
	-- - uuid: (Optional) UUID of the anchor. `true` to generate a new one, and `nil` to keep the current one (if any currently).
	-- - name: (Recommended) Title of the anchor
	-- - subtitle: short description
	-- - description: (Recommended) long description
	local meta = minetest.get_meta(pos)

	if not def.uuid then
		local uuid = meta:get_string("anchor_uuid")
		if uuid == "" then
			def.uuid = true
		else
			def.uuid = uuid
		end
	end
	if def.uuid == true then
		def.uuid = anchor.generate_uuid(pos)
	end

	for _,k in ipairs({"uuid","name","subtitle","description"}) do
		if def[k] then
			meta:set_string("anchor_" .. k,def[k])
		end
	end

	meta:set_string("infotext",S("Teleport Anchor - @1",def.name))

	anchor.update_anchor(pos,meta)
end

function anchor.get_anchor(pos)
	local meta = minetest.get_meta(pos)
	local returndict = {}

	for _,k in ipairs({"uuid","name","subtitle","description"}) do
		returndict[k] = meta:get_string("anchor_" .. k)
	end

	if returndict.uuid == "" then return false end

	return returndict
end
