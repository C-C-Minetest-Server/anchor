local S = minetest.get_translator("anchor_basicanchor")

anchor.register_anchor("anchor_basicanchor:basicanchor",{
	description = S("Basic Teleport Anchor"),
	tiles = {"anchor_basicanchor_node.png"},
	groups = {cracky = 3},
	sounds = default and default.node_sound_stone_defaults()
})
