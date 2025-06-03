local S = core.get_translator("anchor_core")

core.register_chatcommand("anchors",{
	description = S("List and teleport to teleport anchors"),
	privs = {interact=true},
	func = function(name,param)
		anchor.gui.list:show(core.get_player_by_name(name))
	end
})
