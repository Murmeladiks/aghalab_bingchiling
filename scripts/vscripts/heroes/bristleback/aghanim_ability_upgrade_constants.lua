MINOR_ABILITY_UPGRADES["npc_dota_hero_bristleback"] = {
	{
		description = "bristleback_viscous_nasal_goo_pf_armor_per_stack",
		ability_name = "bristleback_viscous_nasal_goo_pf",
		special_value_name = "armor_per_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	{
		description = "bristleback_viscous_nasal_goo_pf_stack_limit",
		ability_name = "bristleback_viscous_nasal_goo_pf",
		special_value_name = "stack_limit",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "bristleback_viscous_nasal_goo_pf_move_slow_per_stack",
		ability_name = "bristleback_viscous_nasal_goo_pf",
		special_value_name = "move_slow_per_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.75,
	},
	{
		description = "bristleback_quill_spray_pf_max_damage",
		ability_name = "bristleback_quill_spray_pf",
		special_value_name = "max_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},
	{
		description = "bristleback_quill_spray_pf_quill_stack_damage",
		ability_name = "bristleback_quill_spray_pf",
		special_value_name = "quill_stack_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 7,
	},
	{
		description = "bristleback_quill_spray_pf_cooldown",
		ability_name = "bristleback_quill_spray_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "bristleback_bristleback_pf_damage_reduction",
		ability_name = "bristleback_bristleback_pf",
		special_values =
		{
			{
				special_value_name = "side_damage_reduction",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 2,
			},
			{
				special_value_name = "back_damage_reduction",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 4,
			},
		},
	},
	{
		description = "bristleback_bristleback_pf_quill_release_threshold",
		ability_name = "bristleback_bristleback_pf",
		special_value_name = "quill_release_threshold",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -10,
	},
	{
		description = "bristleback_warpath_pf_max_stacks",
		ability_name = "bristleback_warpath_pf",
		special_value_name = "max_stacks",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "bristleback_warpath_pf_move_speed_per_stack",
		ability_name = "bristleback_warpath_pf",
		special_value_name = "move_speed_per_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.75,
	},
	{
		description = "bristleback_warpath_pf_damage_per_stack",
		ability_name = "bristleback_warpath_pf",
		special_value_name = "damage_per_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 4,
	},
	{
		description = "bristleback_warpath_pf_stack_duration",
		ability_name = "bristleback_warpath_pf",
		special_value_name = "stack_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_bristleback"] = {
	"aghsfort_minor_stat_upgrade_bonus_spell_amp",
	"aghsfort_minor_stat_upgrade_bonus_attack_damage",
	"aghsfort_minor_stat_upgrade_bonus_evasion", --we want to get hit
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_bristleback"] = "bristleback_warpath"

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_bristleback"] = {
	"pathfinder_bristleback_viscous_nasal_goo_achoo_achoo",
	"pathfinder_bristleback_viscous_nasal_goo_dirty_brawler",
	"pathfinder_bristleback_viscous_nasal_goo_bloody_rage",
	
	"pathfinder_bristleback_quill_spray_pokes_from_the_devil",
	"pathfinder_bristleback_quill_spray_defensive_offense",
	"pathfinder_bristleback_quill_spray_directional_quills",
	
	"pathfinder_bristleback_bristleback_heavy_ordnance",
	"pathfinder_bristleback_bristleback_call_quilly_pf",
	"pathfinder_bristleback_bristleback_magical_bleed",
	
	"pathfinder_bristleback_warpath_shock_and_awe",
	"pathfinder_bristleback_warpath_mega_wallop",
	"pathfinder_bristleback_warpath_legal_repossession"
}

item_bristleback_viscous_nasal_goo_pf_armor_per_stack = item_small_scepter_fragment
item_bristleback_viscous_nasal_goo_pf_stack_limit = item_small_scepter_fragment
item_bristleback_quill_spray_pf_max_damage = item_small_scepter_fragment
item_bristleback_quill_spray_pf_quill_stack_damage = item_small_scepter_fragment
item_bristleback_bristleback_pf_damage_reduction = item_small_scepter_fragment
item_bristleback_bristleback_pf_quill_release_threshold = item_small_scepter_fragment
item_bristleback_warpath_pf_stack_duration = item_small_scepter_fragment
item_bristleback_warpath_pf_damage_per_stack = item_small_scepter_fragment

PURCHASABLE_SHARDS["npc_dota_hero_bristleback"] = {
	"item_bristleback_viscous_nasal_goo_pf_armor_per_stack",
	"item_bristleback_viscous_nasal_goo_pf_stack_limit",
	"item_bristleback_quill_spray_pf_max_damage",
	"item_bristleback_quill_spray_pf_quill_stack_damage",
	"item_bristleback_bristleback_pf_damage_reduction",
	"item_bristleback_bristleback_pf_quill_release_threshold",
	"item_bristleback_warpath_pf_stack_duration",
	"item_bristleback_warpath_pf_damage_per_stack",
}
