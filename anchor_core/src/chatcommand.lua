local S = minetest.get_translator("anchor_core")

minetest.register_chatcommand("anchors",{
	description = S("List and teleport to teleport anchors"),
	privs = {interact=true},
	func = function(name,param)
		anchor.gui.list:show(minetest.get_player_by_name(name))
	end
})
