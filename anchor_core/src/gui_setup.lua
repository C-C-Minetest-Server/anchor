local gui = flow.widgets
local S = core.get_translator("anchor_core")

return flow.make_gui(function(player, ctx)
	local name = player:get_player_name()
	local allow_modify = core.check_player_privs(name,{server=true})
	if not allow_modify then
		return gui.ButtonExit {label=S("You are not allowed to set up teleport anchors.")}
	end
	if not ctx.pos then return gui.ButtonExit { label = "ERR" } end

	return gui.VBox { w = 12,
		gui.Label { label = S("Setting up anchor at @1",core.pos_to_string(ctx.pos)), expand=true,align_h="left",h=0.4},
		gui.Box{w = 1, h = 0.05, color = "grey"},
		gui.HBox {
			gui.VBox {expand=true,
				gui.Label { label = S("Name:") },
				gui.Field { name = "anchor_name" }
			},
			gui.VBox {expand=true,
				gui.Label { label = S("Subtitle:") },
				gui.Field { name = "anchor_subtitle" }
			},
		},
		gui.Label { label = S("Description:") },
		gui.Textarea { name = "anchor_description", h = 6 },
		gui.HBox {
			gui.ButtonExit {
				label = S("Discard"),expand=true,align_h="right"
			},
			gui.ButtonExit {
				label = S("Confirm"),
				on_event = function(e_player, e_ctx)
					local data = {}
					data.name = e_ctx.form.anchor_name
					data.subtitle = e_ctx.form.anchor_subtitle
					data.description = e_ctx.form.anchor_description
					data.uuid = true
					anchor.add_anchor(e_ctx.pos,data)
					anchor.playerstorage.add_item(e_player, {
						x = ctx.pos.x,
						y = ctx.pos.y,
						z = ctx.pos.z,
						uuid = core.get_meta(e_ctx.pos):get_string("anchor_uuid")
					})
					core.chat_send_player(player:get_player_name(),S("Anchor created."))
				end
			},
		}
	}
end)
