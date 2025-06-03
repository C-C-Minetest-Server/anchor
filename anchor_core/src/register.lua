local S = core.get_translator("anchor_core")
anchor.node = {}

function anchor.node.on_rightclick(pos, node, clicker, itemstack, pointed_thing)
	if not clicker:is_player() then return end
	local name = clicker:get_player_name()
	local meta = core.get_meta(pos)
	local uuid = meta:get_string("anchor_uuid")
	local allow_modify = core.check_player_privs(name,{server=true})
	local allow_tp = core.check_player_privs(name,{interact=true})
	if uuid == "" then
		if not allow_modify then
			core.chat_send_player(name,S("You are not allowed to set up teleport anchors."))
			return
		end
		anchor.gui.setup:show(clicker,{pos=pos})
		return
	end

	if not allow_tp then
		core.chat_send_player(name,S("You are not allowed to use teleport anchors."))
		return
	end

	local data = table.copy(pos)
	data.uuid = uuid
	local add_result = anchor.playerstorage.add_item(clicker,data)
	if add_result then
		core.chat_send_player(name,S("Teleport anchor unlocked."))
	end

	if allow_modify then
		anchor.gui.modify:show(clicker,{pos=pos})
		return
	end
end

function anchor.node.can_dig(pos, player)
	if not player or not player:is_player() then return end
	local name = player:get_player_name()
	local allow_modify = core.check_player_privs(name,{server=true})
	if not allow_modify then
		core.chat_send_player(name,S("You are not allowed to remove teleport anchors."))
		return false
	end
	return true
end

function anchor.node.on_construct(pos)
	local meta = core.get_meta(pos)
	meta:set_string("infotext",S("Unconfigured teleport anchor"))
end

function anchor.node.on_destruct(pos)
	local pos_string = core.pos_to_string(pos)
	anchor.storage[pos_string] = nil
end

function anchor.register_anchor(name,def)
	-- Group setup
	if not def.group then def.group = {} end
	def.group.anchors = 1

	-- functions
	for k,v in pairs(anchor.node) do
		def[k] = v
	end

	return core.register_node(name,def)
end

