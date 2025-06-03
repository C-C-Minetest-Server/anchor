local gui = flow.widgets
local S = core.get_translator("anchor_core")

return flow.make_gui(function(player, ctx)
	local name = player:get_player_name()
	local allow_tp = core.check_player_privs(name,{interact=true})
	if not ctx.anchors then
		ctx.anchors = anchor.playerstorage.get_list(player)
		ctx.anchors_by_name = {}
		for i,v in ipairs(ctx.anchors) do
			ctx.anchors_by_name[i] = v.name
		end
	end
	if #ctx.anchors == 0 or not allow_tp then
		return gui.ButtonExit {label=S("No anchors avaliable.")}
	end
	if not ctx.form.anchor_list then
		ctx.form.anchor_list = 1
	end
	ctx.curr_anchor_data = ctx.anchors[ctx.form.anchor_list]

	return gui.VBox { w = 12,
		gui.HBox {
			gui.Label { label = S("List of teleport anchors"), expand=true,align_h="left",h=0.4},
			gui.ButtonExit {
				label = "x",
				h = 0.4, w = 0.4
			},
		},
		gui.Box{w = 1, h = 0.05, color = "grey"},
		gui.HBox {
			gui.VBox {
				gui.Textlist {
					w = 3,h = 7,
					name = "anchor_list",
					listelems = ctx.anchors_by_name,
					on_event = function() return true end,
				},
				gui.ButtonExit {
					label = S("Teleport"),
					w=3,h=1,
					expand=true,align_h="right",
					on_event = function(player,ctx)
						local pos = ctx.curr_anchor_data.pos
						player:set_pos(vector.add(pos,{x=0,y=1,z=0}))
					end,
				},
			},
			gui.VBox {
				gui.Label { label = ctx.curr_anchor_data.name .. (ctx.curr_anchor_data.subtitle and (core.get_color_escape_sequence("#777778") .. " - " .. ctx.curr_anchor_data.subtitle) or "")},
				gui.Box{w=1, h = 0.03, color = "grey"},
				gui.Textarea { default = ctx.curr_anchor_data.description },
			}
		}
	}
end)
