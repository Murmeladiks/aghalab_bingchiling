MINOR_ABILITY_UPGRADES["npc_dota_hero_zuus"] = {
	{
		description = "zuus_arc_lightning_pf_damage",
		ability_name = "zuus_arc_lightning_pf",
		special_value_name = "arc_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},
	{
		description = "zuus_arc_lightning_pf_bounce",
		ability_name = "zuus_arc_lightning_pf",
		special_value_name = "jump_count",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
		},
	{
		description = "zuus_arc_lightning_pf_cooldown",
		ability_name = "zuus_arc_lightning_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "zuus_lightning_bolt_pf_damage",
		ability_name = "zuus_lightning_bolt_pf",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
		},
	{
		description = "zuus_lightning_bolt_pf_stun_duration",
		ability_name = "zuus_lightning_bolt_pf",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.50,
		},
	{
		description = "zuus_lightning_bolt_pf_cooldown",
		ability_name = "zuus_lightning_bolt_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
		},
	{
		description = "zuus_lightning_bolt_pf_cast_range",
		ability_name = "zuus_lightning_bolt_pf",
		special_value_name = "cast_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
		},
		{
		description = "zuus_static_field_pf_damage",
		ability_name = "zuus_static_field_pf",
		special_value_name = "damage_pct_of_int",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "zuus_static_field_pf_active_pct_increase",
		ability_name = "zuus_static_field_pf",
		special_value_name = "active_int_boost_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "zuus_static_field_pf_active_duration",
		ability_name = "zuus_static_field_pf",
		special_value_name = "active_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
	{
		description = "zuus_static_field_pf_cooldown",
		ability_name = "zuus_static_field_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "zuus_thundergods_wrath_pf_damage",
		ability_name = "zuus_thundergods_wrath_pf",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 70,
	},		
	{
		description = "zuus_thundergods_wrath_pf_radius",
		ability_name = "zuus_thundergods_wrath_pf",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "zuus_thundergods_wrath_pf_cooldown",
		ability_name = "zuus_thundergods_wrath_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
}
STAT_UPGRADE_EXCLUDES["npc_dota_hero_zuus"] = {
	"aghsfort_minor_stat_upgrade_bonus_evasion",
	"aghsfort_minor_stat_upgrade_bonus_attack_damage"
}
ULTIMATE_ABILITY_NAMES["npc_dota_hero_zuus"] = "zuus_thundergods_wrath"
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_zuus"] = {
	"pathfinder_zuus_arc_lightning_ally_bounce_buff",
    "pathfinder_zuus_arc_lightning_multi_enemy_bounce",
	"pathfinder_zuus_arc_lightning_projectile",
	"pathfinder_zuus_lightning_bolt_kill_recast",
	"pathfinder_zuus_lightning_bolt_self_cast",
	"pathfinder_zuus_lightning_bolt_linear_cast",
	"pathfinder_zuus_cloud",
	"pathfinder_zuus_heavenly_jump",
	"pathfinder_zuus_static_field_attack_arc_lightning",
	"pathfinder_zuus_thundergods_wrath_autosmite",
	"pathfinder_zuus_thundergods_wrath_multistrike",
	"pathfinder_zuus_thundergods_wrath_ground_target",
}

item_zuus_arc_lightning_pf_damage = item_small_scepter_fragment
item_zuus_arc_lightning_pf_bounce = item_small_scepter_fragment
item_zuus_arc_lightning_pf_cooldown = item_small_scepter_fragment
item_zuus_lightning_bolt_pf_damage = item_small_scepter_fragment
item_zuus_lightning_bolt_pf_stun_duration = item_small_scepter_fragment
item_zuus_lightning_bolt_pf_cooldown = item_small_scepter_fragment
item_zuus_lightning_bolt_pf_cast_range = item_small_scepter_fragment
item_zuus_static_field_pf_damage = item_small_scepter_fragment
item_zuus_static_field_pf_active_pct_increase = item_small_scepter_fragment
item_zuus_static_field_pf_active_duration = item_small_scepter_fragment
item_zuus_static_field_pf_cooldown = item_small_scepter_fragment
item_zuus_thundergods_wrath_pf_damage = item_small_scepter_fragment
item_zuus_thundergods_wrath_pf_radius = item_small_scepter_fragment
item_zuus_thundergods_wrath_pf_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS["npc_dota_hero_zuus"] = {
   "item_zuus_arc_lightning_pf_damage",
   "item_zuus_arc_lightning_pf_bounce",
   "item_zuus_arc_lightning_pf_cooldown",
   "item_zuus_lightning_bolt_pf_damage",
   "item_zuus_lightning_bolt_pf_stun_duration",
   "item_zuus_lightning_bolt_pf_cooldown",
   "item_zuus_lightning_bolt_pf_cast_range",
   "item_zuus_static_field_pf_damage",
   "item_zuus_static_field_pf_active_pct_increase",
   "item_zuus_static_field_pf_active_duration",
   "item_zuus_static_field_pf_cooldown",
   "item_zuus_thundergods_wrath_pf_damage",
   "item_zuus_thundergods_wrath_pf_radius",
   "item_zuus_thundergods_wrath_pf_cooldown",
}
