-- TL;DR: Shuffle the list before passing it to ipairs(t)
local function ran_ipairs(t)
	local cp_t = table.copy(t)

	return function()
		local index = math.random(1,#cp_t)
		local val = cp_t[index]
		table.remove(cp_t,index)
		return val
	end
end


function anchor.find_save_pos_around_pos(pos,rad)
	if not rad then rad = 5 end
	local irad = rad * -1
	local pos1 = vector.add(pos,{x=rad,y=rad,z=rad})
	local pos2 = vector.add(pos,{x=irad,y=irad,z=irad})
	local airs = core.find_nodes_in_area(pos1, pos2, {"air"}, false)

	for _,y in ran_ipairs(airs) do
		-- Do not land the player on the same Y-axis as the anchor.
		if y.y ~= pos.y then
			-- Check is the node under the air a walkable node.
			-- If yes, this air would not be checked.
			local under = vector.add(y,{x=0,y=-1,z=0})
			local under_node = core.get_node(under)
			local under_node_def = core.registered_nodes[under_node.name]
			if under_node.name ~= "air" and under_node.name ~= "ignore" and under_node_def and not(under_node_def.walkable) then
				-- Check is the node above the air a walkable node.
				local above = vector.add(y,{x=0,y=1,z=0})
				local above_node = core.get_node(above)
				local above_node_def = core.registered_nodes[above_node.name]
				if under_node.name == "air" or (under_node_def and (under_node_def.walkable) then
					-- Do not spawn players in unknown nodes
					local node = core.get_node(y)
					local node_def = core.registered_nodes[y]
					if node_def then
						-- Do not spawn players in dangerous nodes.
						if not(node_def.damage_per_second) or node_def.damage_per_second == 0 then
							-- That's it. Return it.
							return y
						end
					end
				end
			end
		end
	end
	-- We've tried out best.
	return false
end
