workbench = {}

screwdriver = screwdriver or {}

local formspecs = {
	-- Main formspec
	[[ label[0.75,0.25;Anmalen]
	   box[0,0;1.8,0.9;#555555]
	   image[0,0;1,1;tools_worktable_brush.png]
	   list[context;input;2,0;1,1;]
	   list[context;dyes;3,0;1,1;]
	   list[context;colors;5,0;1,1;]
	   button[6,0;2,1;bleach;Bleichen]
	   image[4,0;1,1;gui_furnace_arrow_bg.png^[transformR270]
	   listring[current_player;main]
	   listring[context;color]
	   listring[current_player;main]
	   listring[context;dyes]
	   listring[current_player;main]
	   listring[context;input] ]],
}

xbg = default.gui_bg..default.gui_bg_img..default.gui_slots

workbench.defs = {
	-- Name
	{"red", "#ff0000"},
	{"orange", "#ff8000"},
	{"yellow", "#ffff00"},
	{"lime", "#80ff00"},
	{"green", "#00ff00"},
	{"jade", "#00ff80"},
	{"cyan", "#00ffff"},
	{"blue", "#0080ff"},
	{"night", "#0000ff"},
	{"purble", "#8000ff"},
	{"pink", "#ff00ff"},
	{"violet", "#ff0080"},
	{"dark_red", "#800000"},
	{"brown", "#804000"},
	{"gold", "#808000"},
	{"dark_lime", "#408000"},
	{"dark_green", "#008000"},
	{"dark_jade", "#008040"},
	{"dark_cyan", "#004040"},
	{"dark_blue", "#004080"},
	{"dark_night", "#000040"},
	{"dark_purble", "#400040"},
	{"rose", "#ff80ff"},
	{"magenta", "#800040"},
	{"black", "#000000"},
	{"grey", "#404040"},
	{"silver", "#808080"},
	{"white", "#ffffff"}
}

function workbench:set_formspec(meta, id)
	meta:set_string("formspec",
			"size[8,5;]list[current_player;main;0,1.25;8,4;]"..
			formspecs[id]..xbg..default.get_hotbar_bg(0,1.25))
end

function workbench.construct(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("input", 1)
	inv:set_size("dyes", 1)
	inv:set_size("colors", 1)

	meta:set_string("infotext", "Werkbank")
	workbench:set_formspec(meta, 1)
end

function workbench.dig(pos)
	local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("input")
end

function workbench.fields(pos, _, fields, sender)
	local inv = minetest.get_meta(pos):get_inventory()
	local input = inv:get_stack("input", 1)
	local dye = inv:get_stack("dyes", 1)
end

function workbench.put(_, listname, _, stack)
	local stackname = stack:get_name()
	if stackname == "group:dye" then
		return stack:get_count()
	elseif listname == "paint" then
		return 1
	end
	return 0
end

minetest.register_node("workbench:workbench", {
	description = "Werkbank",
	tiles = {"workbench_workbench_top.png", "default_chest_buttom.png",
		 "workbench_workbench_sides.png", "workbench_workbench_sides.png",
		 "workbench_workbench_front.png", "workbench_workbench_front.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	stack_max = 64,
	sounds = default.node_sound_wood_defaults(),
	groups = {choppy = 3, flammable = 1, oddly_breakable_by_hand = 2, fence_connect = 1},
	on_rotate = screwdriver.rotate_simple,
	can_dig = workbench.dig,
	on_construct = workbench.construct,
	on_receive_fields = workbench.fields,
})

minetest.register_craft({
	output = "workbench:workbench",
	recipe = {
		{"group:wood", "group:wood"},
		{"group:wood", "group:wood"}
	}
})

local default_path = minetest.get_modpath("workbench")

dofile(default_path.."/nodes.lua")