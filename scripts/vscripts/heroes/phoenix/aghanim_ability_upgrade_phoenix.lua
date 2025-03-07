PURCHASABLE_SHARDS[ "npc_dota_hero_phoenix" ] =
{
   "item_phoenix_icarus_dive_pf_cooldown",
   "item_phoenix_icarus_dive_pf_dash_length",
   "item_phoenix_icarus_dive_pf_burn_duration",
   "item_phoenix_icarus_dive_pf_damage_per_second",
   "item_phoenix_icarus_dive_pf_slow_movement_speed_pct",

   "item_phoenix_fire_spirits_pf_cooldown",
   "item_phoenix_fire_spirits_pf_duration",
   "item_phoenix_fire_spirits_pf_damage_per_second",
   "item_phoenix_fire_spirits_pf_attackspeed_slow",

   "item_phoenix_sun_ray_pf_cooldown",
   "item_phoenix_sun_ray_pf_hp_cost_perc_per_second",
   "item_phoenix_sun_ray_pf_base_damage",
   "item_phoenix_sun_ray_pf_hp_perc_heal",
   "item_phoenix_sun_ray_pf_beam_range",

   "item_phoenix_supernova_pf_cooldown",
   "item_phoenix_supernova_pf_damage_per_sec",
   "item_phoenix_supernova_pf_max_health_for_egg",
   "item_phoenix_supernova_pf_stun_duration",
   
}

_G.PURCHASABLE_SHARDS = {}

item_phoenix_icarus_dive_pf_cooldown = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_dash_length = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_burn_duration = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_damage_per_second = item_small_scepter_fragment
item_phoenix_icarus_dive_pf_slow_movement_speed_pct = item_small_scepter_fragment

item_phoenix_fire_spirits_pf_cooldown = item_small_scepter_fragment
item_phoenix_fire_spirits_pf_duration = item_small_scepter_fragment
item_phoenix_fire_spirits_pf_damage_per_second = item_small_scepter_fragment
item_phoenix_fire_spirits_pf_attackspeed_slow = item_small_scepter_fragment

item_phoenix_sun_ray_pf_cooldown = item_small_scepter_fragment
item_phoenix_sun_ray_pf_hp_cost_perc_per_second = item_small_scepter_fragment
item_phoenix_sun_ray_pf_base_damage = item_small_scepter_fragment
item_phoenix_sun_ray_pf_hp_perc_heal = item_small_scepter_fragment
item_phoenix_sun_ray_pf_beam_range = item_small_scepter_fragment

item_phoenix_supernova_pf_cooldown = item_small_scepter_fragment
item_phoenix_supernova_pf_damage_per_sec = item_small_scepter_fragment
item_phoenix_supernova_pf_max_health_for_egg = item_small_scepter_fragment
item_phoenix_supernova_pf_stun_duration = item_small_scepter_fragment

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_phoenix"] =
{         
   "pathfinder_icarus_dive_loop",
   "pathfinder_icarus_dive_flyby",
   "pathfinder_icarus_dive_bkb",

   "pathfinder_fire_spirit_sun_strike",
   "pathfinder_fire_spirit_shell",
   "pathfinder_fire_spirit_baby",

   "pathfinder_sun_ray_star",
   "pathfinder_sun_ray_infinite",

   "pathfinder_supernova_allies",
   "pathfinder_supernova_blackhole",   
   "pathfinder_supernova_heal_bkb",
}

local Phoenix =
{
	{
		description = "phoenix_icarus_dive_pf_cooldown",
		ability_name = "phoenix_icarus_dive_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	{
		description = "phoenix_icarus_dive_pf_dash_length",
		ability_name = "phoenix_icarus_dive_pf",
		special_value_name = "dash_length",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 300,
	},

	{
		description = "phoenix_icarus_dive_pf_burn_duration",
		ability_name = "phoenix_icarus_dive_pf",
		special_value_name = "burn_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "phoenix_icarus_dive_pf_damage_per_second",
		ability_name = "phoenix_icarus_dive_pf",
		special_value_name = "damage_per_second",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},

	{
		description = "phoenix_icarus_dive_pf_slow_movement_speed_pct",
		ability_name = "phoenix_icarus_dive_pf",
		special_value_name = "slow_movement_speed_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},


	------------------------------------
	------------------------------------

	{
		description = "phoenix_fire_spirits_pf_cooldown",
		ability_name = "phoenix_fire_spirits_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "phoenix_fire_spirits_pf_duration",
		ability_name = "phoenix_fire_spirits_pf",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "phoenix_fire_spirits_pf_damage_per_second",
		ability_name = "phoenix_fire_spirits_pf",
		special_value_name = "damage_per_second",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},
	{
		description = "phoenix_fire_spirits_pf_attackspeed_slow",
		ability_name = "phoenix_fire_spirits_pf",
		special_value_name = "attackspeed_slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},

	------------------------------------
	------------------------------------

	{
		description = "phoenix_sun_ray_pf_cooldown",
		ability_name = "phoenix_sun_ray_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},

	{
		description = "phoenix_sun_ray_pf_hp_cost_perc_per_second",
		ability_name = "phoenix_sun_ray_pf",
		special_value_name = "hp_cost_perc_per_second",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -1,
	},
	{
		description = "phoenix_sun_ray_pf_base_damage",
		ability_name = "phoenix_sun_ray_pf",
		special_value_name = "base_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},
	{
		description = "phoenix_sun_ray_pf_hp_perc_heal",
		ability_name = "phoenix_sun_ray_pf",
		special_value_name = "hp_perc_heal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	{
		description = "phoenix_sun_ray_pf_beam_range",
		ability_name = "phoenix_sun_ray_pf",
		special_value_name = "beam_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 210,
	},

	------------------------------------
	------------------------------------

	{
		description = "phoenix_supernova_pf_cooldown",
		ability_name = "phoenix_supernova_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "phoenix_supernova_pf_damage_per_sec",
		ability_name = "phoenix_supernova_pf",
		special_value_name = "damage_per_sec",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},
	{
		description = "phoenix_supernova_pf_max_health_for_egg",
		ability_name = "phoenix_supernova_pf",
		special_value_name = "max_health_for_egg",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},
	{
		description = "phoenix_supernova_pf_stun_duration",
		ability_name = "phoenix_supernova_pf",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
}

return Phoenix