local gui = flow.widgets
local S = core.get_translator("anchor_core")

return flow.make_gui(function(player, ctx)
	local name = player:get_player_name()
	local allow_modify = core.check_player_privs(name,{server=true})
	if not allow_modify then
		return gui.ButtonExit {label=S("You are not allowed to set up teleport anchors.")}
	end
	if not ctx.pos then return gui.ButtonExit { label = "ERR" } end
	if not ctx.anchor_data then
		ctx.anchor_data = anchor.get_anchor(ctx.pos)
		if not ctx.anchor_data then return gui.ButtonExit { label = "ERR" } end
	end

	return gui.VBox { w = 12,
		gui.Label { label = S("Modifying anchor @1",ctx.anchor_data.name), expand=true,align_h="left",h=0.4},
		gui.Box{w = 1, h = 0.05, color = "grey"},
		gui.HBox {
			gui.VBox {expand=true,
				gui.Label { label = S("Name:") },
				gui.Field { name = "anchor_name",default=ctx.anchor_data.name }
			},
			gui.VBox {expand=true,
				gui.Label { label = S("Subtitle:") },
				gui.Field { name = "anchor_subtitle",default=ctx.anchor_data.subtitle }
			},
		},
		gui.Label { label = S("Description:") },
		gui.Textarea { name = "anchor_description", h = 6,default=ctx.anchor_data.description },
		gui.HBox {
			gui.Checkbox {
				name = "checkbox_anchor_uuid",
				label = S("Keep original UUID"),
				selected = true,
				expand=true,align_h="left"
			},
			gui.ButtonExit {
				label = S("Discard"),
			},
			gui.ButtonExit {
				label = S("Confirm"),
				on_event = function(player, ctx)
					local data = {}
					data.name = ctx.form.anchor_name
					data.subtitle = ctx.form.anchor_subtitle
					data.description = ctx.form.anchor_description
					if not ctx.form.checkbox_anchor_uuid then
						data.uuid = true
					end
					anchor.add_anchor(ctx.pos,data)
					core.chat_send_player(player:get_player_name(),S("Anchor updated."))
				end
			},
		}
	}
end)
