local chainsaw = {}
work = {}
local min, ceil = math.min, math.ceil
local registered_nodes = minetest.registered_nodes
local nodes = {}

for node, def in pairs(registered_nodes) do
	if (def.drawtype == "normal" or def.drawtype:sub(1,5) == "glass") and (def.groups.cracky or def.groups.choppy) and
		not def.on_construct and
		not def.after_place_node and
		not def.on_rightclick and
		not def.on_blast and
		not def.allow_metadata_inventory_take and
		not (def.groups.tree == 1) and
		not (def.groups.not_cutable == 1) and
		not (def.groups.frost_grass == 1) and
		def.description and
		def.description ~= ""
	then
		nodes[#nodes+1] = node
	end
end

work.custom_nodes_register = {
	"farming:straw",
	"nether:rack",
	"nether:netherbrick",
	"nether:quarz_stone",
	"nether:quarz_brick",
	"nether:quarz_block",
	"nether:purpur_block",
	"nether:netherwart_brick",
	"nether:dark_netherwart_brick",
}

setmetatable(nodes, {
	__concat = function(t1, t2)
		for i=1, #t2 do
			t1[#t1+1] = t2[i]
		end
		return t1
	end
})

nodes = nodes..work.custom_nodes_register

chainsaw.defs = {
	-- Name       Yield   X  Y   Z  W   H  L
	{"stair",	1, nil			},
	{"curve",	1, nil			},
	{"corner",	1, nil			},
	{"flat",	8, nil			},
	{"cover",	4, nil			},
	{"slab",	2, nil			},
	{"slope",	2, nil			},
	{"ocorner",	1, nil			},
	{"icorner",	1, nil			},
	{"cube",	8, {0,0,0,8,8,8}	}
}

function chainsaw:get_output(inv, input, name)
	local output = {}
	for i=1, #self.defs do
		local nbox = self.defs[i]
		local count = min(nbox[2] * input:get_count(), input:get_stack_max())
		local item = name.."_"..nbox[1]
		item = nbox[3] and item or "stairs:"..nbox[1].."_"..name:match(":(.*)")
		output[#output+1] = item.." "..count
	end
	inv:set_list("forms", output)
end

work.pixelbox = function(size, boxes)
	local fixed = {}
	for _, box in pairs(boxes) do
		local x, y, z, w, h, l = unpack(box)
		fixed[#fixed+1] = {
			(x / size) - 0.5,
			(y / size) - 0.5,
			(z / size) - 0.5,
			((x + w) / size) - 0.5,
			((y + h) / size) - 0.5,
			((z + l) / size) - 0.5
		}
	end
	return {type="fixed", fixed=fixed}
end

local formspecs = {
	-- Main formspec
	[[ label[0.9,1.23;Bearbeiten]
	   box[0,1;3,0.9;#555555]
	   button[0,0;2,1;craft;>>]
	   image[4,1;1,1;gui_furnace_arrow_bg.png^[transformR270]
	   image[0,1;1,1;chainsaw_saw.png]
	   list[context;input;3,1;1,1;]
	   list[context;forms;5,0;3,3;]
	   listring[current_player;main]
	   listring[context;forms]
	   listring[current_player;main]
	   listring[context;input] ]],
	-- Crafting formspec
	[[ image[4,1;1,1;gui_furnace_arrow_bg.png^[transformR90]
	   image[0,1;1,1;anvil_hammer.png]
	   label[0.9,1.23;Craften]
	   box[0,1;3,0.9;#555555]
	   button[0,0;2,1;back;<<]
	   list[current_player;craft;5,0;3,3;]
	   list[current_player;craftpreview;3,1;1,1;]
	   listring[current_player;main]
	   listring[current_player;craft] ]],
}

xbg = default.gui_bg..default.gui_bg_img..default.gui_slots

function chainsaw:set_formspec(meta, id)
	meta:set_string("formspec",
			"size[8,7;]list[current_player;main;0,3.25;8,4;]"..
			formspecs[id]..xbg..default.get_hotbar_bg(0,3.25))
end

function chainsaw.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("input", 1)
	inv:set_size("forms", 4*3)

	meta:set_string("infotext", "Kreissaege")
	chainsaw:set_formspec(meta, 1)
end

function chainsaw.fields(pos, _, fields)
	if fields.quit then return end
	local meta = minetest.get_meta(pos)
	local id = fields.back and 1 or
		   fields.craft and 2
	if not id then return end
	chainsaw:set_formspec(meta, id)
end

function chainsaw.dig(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("input")
end

function chainsaw.put(_, listname, _, stack)
	local stackname = stack:get_name()
	if (listname == "input" and registered_nodes[stackname.."_cube"])then
		return stack:get_count()
	end
	return 0
end

function chainsaw.move(_, from_list, _, to_list, _, count)
	return (from_list ~= "forms") and count or 0
end

function chainsaw.on_put(pos, listname, _, stack)
	local inv = minetest.get_meta(pos):get_inventory()
	if listname == "input" then
		local input = inv:get_stack("input", 1)
		chainsaw:get_output(inv, input, stack:get_name())
	end
end

function chainsaw.on_take(pos, listname, index, stack, player)
	local inv = minetest.get_meta(pos):get_inventory()
	local input = inv:get_stack("input", 1)
	local inputname = input:get_name()
	local stackname = stack:get_name()

	if listname == "input" then
		if stackname == inputname then
			chainsaw:get_output(inv, input, stackname)
		else
			inv:set_list("forms", {})
		end
	elseif listname == "forms" then
		local fromstack = inv:get_stack(listname, index)
		if not fromstack:is_empty() and fromstack:get_name() ~= stackname then
			local player_inv = player:get_inventory()
			if player_inv:room_for_item("main", fromstack) then
				player_inv:add_item("main", fromstack)
			end
		end

		input:take_item(ceil(stack:get_count() / chainsaw.defs[index][2]))
		inv:set_stack("input", 1, input)
		chainsaw:get_output(inv, input, inputname)
	end
end

minetest.register_node("chainsaw:chainsaw", {
	description = minetest.get_color_escape_sequence("#0070dd") .. "Kreissaege",
	drawtype = "nodebox",
	tiles = {"chainsaw_circular_saw_top.png", "chainsaw_circular_saw_bottom.png", "chainsaw_circular_saw_side.png"},
	stack_max = 64,
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4, -0.5, -0.4, -0.25, 0.25, -0.25},
			{0.25, -0.5, 0.25, 0.4, 0.25, 0.4},
			{-0.4, -0.5, 0.25, -0.25, 0.25, 0.4},
			{0.25, -0.5, -0.4, 0.4, 0.25, -0.25},
			{-0.5, 0.25, -0.5, 0.5, 0.375, 0.5},
			{-0.01, 0.4375, -0.125, 0.01, 0.5, 0.125},
			{-0.01, 0.375, -0.1875, 0.01, 0.4375, 0.1875},
			{-0.25, -0.0625, -0.25, 0.25, 0.25, 0.25},
		},
	},
	groups = {choppy=2, oddly_breakable_by_hand=1},
	sounds = default.node_sound_wood_defaults(),
	can_dig = chainsaw.dig,
	on_construct = chainsaw.construct,
	on_receive_fields = chainsaw.fields,
	on_metadata_inventory_put = chainsaw.on_put,
	on_metadata_inventory_take = chainsaw.on_take,
	allow_metadata_inventory_put = chainsaw.put,
	allow_metadata_inventory_move = chainsaw.move
})

for _, d in pairs(chainsaw.defs) do
	for i=1, #nodes do
		local node = nodes[i]
		local def = registered_nodes[node]

		if d[3] then
			local groups = {}
			local tiles
			groups.not_in_creative_inventory = 1

			for k, v in pairs(def.groups) do
				if k ~= "wood" and k ~= "stone" and k ~= "cobble" and k ~= "brick" and k ~= "nether" and k ~= "level" then
					groups[k] = v
				end
			end

			if def.tiles then
				if #def.tiles > 1 and (def.drawtype:sub(1,5) ~= "glass") then
					tiles = def.tiles
				else
					tiles = {def.tiles[1]}
				end
			else
				tiles = {def.tile_images[1]}
			end

			if not registered_nodes["stairs:slab_"..node:match(":(.*)")] then
				stairs.register_stair_and_corner_and_curve_and_flat_and_cover_and_slab_and_slope_and_ocorner_and_icorner(node:match(":(.*)"), node,
					groups, tiles,
					def.description.."treppe",
					def.description.."ecke",
					def.description.."kante",
					def.description.."teppich",
					def.description.."abdeckung",
					def.description.."stufe",
					def.description.."rampe",
					def.description.."kantrampe",
					def.description.."eckrampe",
					def.sounds)
			end

			minetest.register_node(":"..node.."_"..d[1], {
				description = def.description.."",
				paramtype = "light",
				paramtype2 = "facedir",
				drawtype = "nodebox",
				sounds = def.sounds,
				tiles = tiles,
				groups = groups,
				node_box = work.pixelbox(16, {unpack(d, 3)}),
				sunlight_propagates = true,
				on_place = minetest.rotate_node
			})
		end
	end
end

minetest.register_craft({
	output = 'chainsaw:chainsaw',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:stick', 'group:wood', 'default:stick'},
		{'default:stick', '', 'default:stick'},
	}
})