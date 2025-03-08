MINOR_ABILITY_UPGRADES["npc_dota_hero_legion_commander"] = {
	{
		description = "legion_commander_overwhelming_odds_radius",
		ability_name = "legion_commander_pf_overwhelming_odds",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},

	{
		description = "legion_commander_overwhelming_odds_base_damage",
		ability_name = "legion_commander_pf_overwhelming_odds",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 80,
	},
	
	{
		description = "legion_commander_overwhelming_odds_damage_per_unit",
		ability_name = "legion_commander_pf_overwhelming_odds",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		special_values =
		{
			{
				special_value_name = "damage_per_unit",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 10,
			},
			{
				special_value_name = "damage_per_hero",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 20,
			},
		},
	},

	{
		description = "legion_commander_overwhelming_odds_speed",
		ability_name = "legion_commander_pf_overwhelming_odds",
		special_value_name = "bonus_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},

	
	{
		description = "legion_commander_overwhelming_odds_speed_duration",
		ability_name = "legion_commander_pf_overwhelming_odds",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.75,
	},
	
	{
		description = "legion_commander_overwhelming_odds_cooldown",
		ability_name = "legion_commander_pf_overwhelming_odds",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	
	{
		description = "legion_commander_pf_press_the_attack_hp_regen_movespeed",
		ability_name = "legion_commander_pf_press_the_attack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		special_values =
		{
			{
				special_value_name = "hp_regen",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 8,
			},
			{
				special_value_name = "move_speed",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 2,
			},
		},
	},
	
	{
		description = "legion_commander_pf_press_the_attack_duration",
		ability_name = "legion_commander_pf_press_the_attack",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "legion_commander_pf_press_the_attack_cooldown",
		ability_name = "legion_commander_pf_press_the_attack",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	
	{
		description = "legion_commander_pf_moment_of_courage_chance",
		ability_name = "legion_commander_pf_moment_of_courage",
		special_value_name = "trigger_chance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	
	{
		description = "legion_commander_pf_moment_of_courage_lifesteal",
		ability_name = "legion_commander_pf_moment_of_courage",
		special_value_name = "hp_leech_percent",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	
	{
		description = "legion_commander_pf_duel_duration",
		ability_name = "legion_commander_pf_duel",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	
	{
		description = "legion_commander_pf_duel_damage",
		ability_name = "legion_commander_pf_duel",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		special_values =
		{
			{
				special_value_name = "reward_damage_creep",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 1,
			},
			{
				special_value_name = "reward_damage_hero",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 4,
			},
		},
	},
	{
		description = "legion_commander_pf_duel_cooldown",
		ability_name = "legion_commander_pf_duel",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_legion_commander"] = {
	"aghsfort_minor_stat_upgrade_bonus_spell_amp",
}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_legion_commander"] = "legion_commander_duel"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_legion_commander"] =
{
	"pathfinder_special_lc_global_arrows_dummy",
	"pathfinder_special_lc_arrows_meteor",
	"pathfinder_special_lc_arrows_reset",	
	
	"pathfinder_special_lc_press_blademail",
	"pathfinder_special_lc_press_bkb",

	"pathfinder_special_lc_moment_aoe",

	"pathfinder_special_lc_duel_legion",
	"pathfinder_special_lc_duel_purge",
	"pathfinder_special_lc_duel_arrows",

	--"pathfinder_special_lc_moment_aura",
}

item_legion_commander_overwhelming_odds_radius = item_small_scepter_fragment
item_legion_commander_overwhelming_odds_base_damage = item_small_scepter_fragment
item_legion_commander_overwhelming_odds_damage_per_unit = item_small_scepter_fragment
item_legion_commander_overwhelming_odds_speed = item_small_scepter_fragment
item_legion_commander_overwhelming_odds_speed_duration = item_small_scepter_fragment
item_legion_commander_overwhelming_odds_cooldown = item_small_scepter_fragment

item_legion_commander_pf_press_the_attack_hp_regen_movespeed = item_small_scepter_fragment
item_legion_commander_pf_press_the_attack_duration = item_small_scepter_fragment
item_legion_commander_pf_press_the_attack_cooldown = item_small_scepter_fragment

item_legion_commander_pf_moment_of_courage_chance = item_small_scepter_fragment
item_legion_commander_pf_moment_of_courage_lifesteal = item_small_scepter_fragment

item_legion_commander_pf_duel_duration = item_small_scepter_fragment
item_legion_commander_pf_duel_damage = item_small_scepter_fragment
item_legion_commander_pf_duel_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_legion_commander" ] =
{
	"item_legion_commander_overwhelming_odds_radius",
	"item_legion_commander_overwhelming_odds_base_damage",
	"item_legion_commander_overwhelming_odds_damage_per_unit",
	"item_legion_commander_overwhelming_odds_speed",
	"item_legion_commander_overwhelming_odds_speed_duration",
	"item_legion_commander_overwhelming_odds_cooldown",
	
	"item_legion_commander_pf_press_the_attack_hp_regen_movespeed",
	"item_legion_commander_pf_press_the_attack_duration",
	"item_legion_commander_pf_press_the_attack_cooldown",
	
	"item_legion_commander_pf_moment_of_courage_chance",   
	"item_legion_commander_pf_moment_of_courage_lifesteal",
	
	"item_legion_commander_pf_duel_duration",   
	"item_legion_commander_pf_duel_damage",
	"item_legion_commander_pf_duel_cooldown",
}