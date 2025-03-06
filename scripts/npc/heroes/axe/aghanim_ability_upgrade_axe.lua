MINOR_ABILITY_UPGRADES["npc_dota_hero_axe"] = {
	{
		description = "axe_battle_hunger_lua_duration",
		ability_name = "axe_battle_hunger_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "axe_battle_hunger_lua_slow",
		ability_name = "axe_battle_hunger_lua",
		special_value_name = "slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -8,
	},

	{
		description = "axe_battle_hunger_lua_speed_bonus",
		ability_name = "axe_battle_hunger_lua",
		special_value_name = "speed_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},

	{
		description = "axe_battle_hunger_lua_damage_per_second",
		ability_name = "axe_battle_hunger_lua",
		special_value_name = "damage_per_second",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 6,
	},

	{
		description = "axe_battle_hunger_lua_radius",
		ability_name = "axe_battle_hunger_lua",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "axe_battle_hunger_lua_pct_cooldown",
		ability_name = "axe_battle_hunger_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},


	--------

	{
		description = "axe_berserkers_call_lua_radius",
		ability_name = "axe_berserkers_call_lua",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},
	{
		description = "axe_berserkers_call_lua_bonus_armor",
		ability_name = "axe_berserkers_call_lua",
		special_value_name = "bonus_armor",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 7,
	},
	{
		description = "axe_berserkers_call_lua_duration",
		ability_name = "axe_berserkers_call_lua",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.75,
	},
	{
		description = "axe_berserkers_call_lua_pct_cooldown",
		ability_name = "axe_berserkers_call_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	----------
	{
		description = "axe_counter_helix_lua_trigger_chance",
		ability_name = "axe_counter_helix_lua",
		special_value_name = "trigger_chance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	{
		description = "axe_counter_helix_lua_damage",
		ability_name = "axe_counter_helix_lua",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 65,
	},
	{
		description = "axe_counter_helix_lua_radius",
		ability_name = "axe_counter_helix_lua",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 35,
	},

	----------

	{
		description = "axe_culling_blade_lua_kill_threshold",
		ability_name = "axe_culling_blade_lua",
		special_value_name = "kill_threshold",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 30,
	},
	{
		description = "axe_culling_blade_lua_speed_bonus",
		ability_name = "axe_culling_blade_lua",
		special_value_name = "speed_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "axe_culling_blade_lua_atk_speed_bonus_tooltip",
		ability_name = "axe_culling_blade_lua",
		special_value_name = "atk_speed_bonus_tooltip",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},
	{
		description = "axe_culling_blade_lua_pct_cooldown",
		ability_name = "axe_culling_blade_lua",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_axe"] = {
	"aghsfort_minor_stat_upgrade_bonus_attack_damage",
	"aghsfort_minor_stat_upgrade_bonus_evasion",
	"aghsfort_minor_stat_upgrade_bonus_attack_speed",
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_axe"] = "axe_culling_blade"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_axe"] =
{
	"pathfinder_axe_special_culling_blade_leap",   
	"pathfinder_axe_special_culling_blade_omnislash",
	"pathfinder_axe_special_culling_blade_heal",
	"pathfinder_axe_special_culling_blade_delay",

	"pathfinder_axe_special_counter_helix_reduce_damage",
	"pathfinder_axe_special_counter_helix_allies",
	"pathfinder_axe_special_counter_helix_fury",

	"pathfinder_axe_special_battle_hunger_lifesteal",
	"pathfinder_axe_special_battle_hunger_culling_cdr",
	"pathfinder_axe_special_battle_hunger_refresh",

	"pathfinder_axe_special_berseker_call_health",
	"pathfinder_axe_special_berseker_call_battle_hunger",
	"pathfinder_axe_special_berseker_call_allies",
	"pathfinder_axe_special_berseker_call_blink",
}


item_axe_battle_hunger_lua_duration = item_small_scepter_fragment
item_axe_battle_hunger_lua_slow = item_small_scepter_fragment
item_axe_battle_hunger_lua_speed_bonus = item_small_scepter_fragment
item_axe_battle_hunger_lua_damage_per_second = item_small_scepter_fragment
item_axe_battle_hunger_lua_radius = item_small_scepter_fragment
item_axe_battle_hunger_lua_pct_cooldown = item_small_scepter_fragment   
item_axe_berserkers_call_lua_radius = item_small_scepter_fragment   
item_axe_berserkers_call_lua_bonus_armor = item_small_scepter_fragment   
item_axe_berserkers_call_lua_duration = item_small_scepter_fragment   
item_axe_berserkers_call_lua_pct_cooldown = item_small_scepter_fragment   
item_axe_counter_helix_lua_trigger_chance = item_small_scepter_fragment   
item_axe_counter_helix_lua_damage = item_small_scepter_fragment  
item_axe_counter_helix_lua_radius = item_small_scepter_fragment   
item_axe_culling_blade_lua_kill_threshold = item_small_scepter_fragment 
item_axe_culling_blade_lua_speed_bonus = item_small_scepter_fragment   
item_axe_culling_blade_lua_atk_speed_bonus_tooltip = item_small_scepter_fragment
item_axe_culling_blade_lua_pct_cooldown = item_small_scepter_fragment   

PURCHASABLE_SHARDS[ "npc_dota_hero_axe" ] =
{
	"item_axe_battle_hunger_lua_duration",
	"item_axe_battle_hunger_lua_slow",
	"item_axe_battle_hunger_lua_speed_bonus",
	"item_axe_battle_hunger_lua_damage_per_second",
	"item_axe_battle_hunger_lua_radius",
	"item_axe_battle_hunger_lua_pct_cooldown",
 
	"item_axe_berserkers_call_lua_radius",   
	"item_axe_berserkers_call_lua_bonus_armor",
	"item_axe_berserkers_call_lua_duration",   
	"item_axe_berserkers_call_lua_pct_cooldown",
 
	"item_axe_counter_helix_lua_trigger_chance",
	"item_axe_counter_helix_lua_damage",
	"item_axe_counter_helix_lua_radius",
 
	"item_axe_culling_blade_lua_kill_threshold",
	"item_axe_culling_blade_lua_speed_bonus",
	"item_axe_culling_blade_lua_atk_speed_bonus_tooltip",
	"item_axe_culling_blade_lua_pct_cooldown",
}