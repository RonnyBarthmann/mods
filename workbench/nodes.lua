dye.dyes = {
	{"_red",		"Rot",			"#ff0000"},
	{"_orange",		"Qrange",		"#ff8000"},
	{"_yellow",		"Gelb",			"#ffff00"},
	{"_lime", 		"Lindgruen",		"#80ff00"},
	{"_green",		"Gruen",		"#00ff00"},
	{"_jade",		"Jaden",		"#00ff80"},
	{"_cyan",		"Himmelblau",		"#00ffff"},
	{"_blue",		"Blau",			"#0080ff"},
	{"_night",		"Nachtblau",		"#0000ff"},
	{"_purble",		"Lilan",		"#8000ff"},
	{"_pink",		"Pink",			"#ff00ff"},
	{"_violet",		"Violet",		"#ff0080"},
	{"_dark_red",		"Dunkelrot",		"#800000"},
	{"_brown",		"Braun",		"#804000"},
	{"_gold",		"Golden",		"#808000"},
	{"_dark_lime",		"Dunkellintgruen",	"#408000"},
	{"_dark_green",		"Dunkelgruen",		"#008000"},
	{"_dark_jade",		"Dunkeljaden",		"#008040"},
	{"_dark_cyan",		"Dunkelhimmelblau",	"#004040"},
	{"_dark_blue",		"Dunkelblau",		"#004080"},
	{"_dark_night",		"Dunkelnachtblau",	"#000040"},
	{"_dark_purble",	"Dunkellilan",		"#400040"},
	{"_rose",		"Rosan",		"#ff80ff"},
	{"_magenta",		"Magentan",		"#800040"},
	{"_black", 		"Schwarz",		"#000000"},
	{"_grey",		"Grau",			"#404040"},
	{"_silver",		"Silbern",		"#808080"},
	{"_white",		"Weiss",		"#ffffff"}
}

for _, row in ipairs(dye.dyes) do
	local name = row[1]
	local desc = row[2]
	local col = row[3]

minetest.register_node("workbench:cobble" ..name, {
	discription = col.. "er Bruchstein",
	paramtype = "light",
	is_ground_connect = false,
	stack_max = 64,
	tiles = {"default_cobble.png^[colorize:" ..col.. "ff"},
	groups = {cracky = 3, cobble = 1},
	sounds = default.node_sound_stone_defaults(),
})

end