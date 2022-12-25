anchor.playerstorage = {}
local _aps = anchor.playerstorage

function _aps.get_list(player)
	local meta = player:get_meta()
	local storageval = meta:get_string("anchor_list")

	if storageval == "" then
		return {}
	end

	local storagelist = minetest.deserialize(storageval)
	if not storagelist then
		storageval = meta:get_string("anchor_list_alt")
		storagelist = minetest.deserialize(storageval)
		if not storagelist then
			anchor.log("warning",string.format("The anchor list of player %s is corrupted. Returned a empty list.",player:get_player_name()))
			return {}
		end
	end

	local returnlist = {}
	local subject_del = {}
	for i,v in ipairs(storagelist) do
		-- v is a x,y,z,uuid dict
		local pos_string = minetest.pos_to_string({x=v.x,y=v.y,z=v.z})
		if anchor.storage[pos_string] and anchor.storage[pos_string].uuid == v.uuid then
			local data = table.copy(anchor.storage[pos_string])
			data.pos = {x=v.x,y=v.y,z=v.z}
			returnlist[i] = data
		else
			table.insert(subject_del,i)
		end
	end
	if #subject_del > 0 then
		for _,v in ipairs(subject_del) do
			table.remove(storagelist,v)
		end
		local n_storageval = minetest.serialize(storagelist)
		meta:set_string("anchor_list",n_storageval)
		meta:set_string("anchor_list_alt",n_storageval)
	end

	return returnlist
end

function _aps.clear_list(player)
	local meta = player:get_meta()
	meta:set_string("anchor_list","")
	meta:set_string("anchor_list_alt","")
end

function _aps.add_item(player,item)
	local meta = player:get_meta()
	local storageval = meta:get_string("anchor_list")

	local storagelist = nil
	if storageval ~= "" then
		storagelist = minetest.deserialize(storageval)
		if not storagelist then
			storageval = meta:get_string("anchor_list_alt")
			storagelist = minetest.deserialize(storageval)
			if not storagelist then
				anchor.log("warning",string.format("The anchor list of player %s is corrupted. Using a empty list.",player:get_player_name()))
			end
		end
	end
	if not storagelist then storagelist = {} end

	for i,v in ipairs(storagelist) do -- check duplication
		if v.x == item.x and v.y == item.y and v.z == item.z then
			if not(item.uuid) or v.uuid == item.uuid then
				return false
			end
		end
	end

	if not item.uuid then
		local pos = {x=item.x,y=item.y,z=item.z}
		local nodemeta = minetest.get_meta(pos)
		local uuid = nodemeta and nodemeta:get_string("anchor_uuid")
		if not uuid or uuid == "" then
			error("Failed to get the UUID of node " .. minetest.string_to_pos(pos) .. ". Please pass uuid into add_item.")
		end
		item.uuid = uuid
	end

	table.insert(storagelist,item)

	local n_storageval = minetest.serialize(storagelist)
	meta:set_string("anchor_list",n_storageval)
	meta:set_string("anchor_list_alt",n_storageval)
	return true
end

function _aps.remove_item(player,item)
	local meta = player:get_meta()
	local storageval = meta:get_string("anchor_list")

	local storagelist = nil
	if storageval ~= "" then
		local storagelist = minetest.deserialize(storageval)
		if not storagelist then
			storageval = meta:get_string("anchor_list_alt")
			storagelist = minetest.deserialize(storageval)
			if not storagelist then
				anchor.log("warning",string.format("The anchor list of player %s is corrupted. Using a empty list.",player:get_player_name()))
			end
		end
	end
	if not storagelist then storagelist = {} end

	for i,v in ipairs(storagelist) do
		if v.x == item.x and v.y == item.y and v.z == item.z then
			if not(item.uuid) or v.uuid == item.uuid then
				table.remove(table,i)
				local n_storageval = minetest.serialize(storagelist)
				meta:set_string("anchor_list",n_storageval)
				meta:set_string("anchor_list_alt",n_storageval)
				return
			end
		end
	end
end
