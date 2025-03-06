MINOR_ABILITY_UPGRADES["npc_dota_hero_tidehunter"] = {
	{
		description = "tidehunter_gush_pf_pct_cooldown",
		ability_name = "tidehunter_gush_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "tidehunter_gush_pf_gush_damage",
		ability_name = "tidehunter_gush_pf",
		special_value_name = "gush_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "tidehunter_gush_pf_movement_speed_reduction",
		ability_name = "tidehunter_gush_pf",
		special_value_name = "movement_speed_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 8,
	},
	{
		description = "tidehunter_gush_pf_negative_armor",
		ability_name = "tidehunter_gush_pf",
		special_value_name = "negative_armor",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "tidehunter_gush_pf_radius",
		ability_name = "tidehunter_gush_pf",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},
	{
		description = "tidehunter_gush_pf_cast_range",
		ability_name = "tidehunter_gush_pf",
		special_value_name = "cast_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 150,
	},
	{
		description = "tidehunter_gush_pf_debuff_duration",
		ability_name = "tidehunter_gush_pf",
		special_value_name = "debuff_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.25,
	},
	
	--------------------------------------------------------------
	{
		description = "tidehunter_kraken_shell_pf_damage_reduction",
		ability_name = "tidehunter_kraken_shell_pf",
		special_value_name = "damage_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "tidehunter_kraken_shell_pf_damage_cleanse",
		ability_name = "tidehunter_pf_blubber",
		special_value_name = "damage_cleanse",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -30,
	},
	
	--------------------------------------------------------------
	{
		description = "tidehunter_anchor_smash_pf_pct_cooldown",
		ability_name = "tidehunter_anchor_smash_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	-- {
	-- 	 description = "tidehunter_anchor_smash_pf_attack_damage",
	-- 	 ability_name = "tidehunter_anchor_smash_pf",
	-- 	 special_value_name = "attack_damage",
	-- 	 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	-- 	 value = 40,
	-- },
	{
		description = "tidehunter_anchor_smash_pf_damage_reduction",
		ability_name = "tidehunter_anchor_smash_pf",
		special_value_name = "damage_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 4,
	},
	{
		description = "tidehunter_anchor_smash_pf_radius",
		ability_name = "tidehunter_anchor_smash_pf",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	--------------------------------------------------------------
	{
		description = "tidehunter_ravage_pf_pct_cooldown",
		ability_name = "tidehunter_ravage_pf",
		special_value_name = "cooldown",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = 12,
	},
	{
		description = "tidehunter_ravage_pf_duration",
		ability_name = "tidehunter_ravage_pf",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	{
		description = "tidehunter_ravage_pf_damage",
		ability_name = "tidehunter_ravage_pf",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},
	{
		description = "tidehunter_ravage_pf_radius",
		ability_name = "tidehunter_ravage_pf",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 225,
	},
}

STAT_UPGRADE_EXCLUDES["npc_dota_hero_tidehunter"] = {"aghsfort_minor_stat_upgrade_bonus_evasion"}

ULTIMATE_ABILITY_NAMES["npc_dota_hero_tidehunter"] = "tidehunter_ravage"


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_tidehunter"] =
{
	
	"tidehunter_gush_pf_ravage",   
	"tidehunter_gush_pf_bounce",
	"tidehunter_kraken_shell_pf_gush",
	"tidehunter_kraken_shell_pf_ravage_cdr",
	"tidehunter_anchor_smash_pf_allies",
	"tidehunter_ravage_pf_puddle",
	"tidehunter_anchor_smash_pf_karate",
	"tidehunter_pf_crunch",
	"tidehunter_anchor_smash_pf_whack",
	"tidehunter_kraken_shell_pf_heal",
	"tidehunter_gush_pf_miss",
	
	--"aghsfort_special_templar_assassin_refraction_allies",
	--"aghsfort_special_templar_assassin_refraction_counter_attack",
	--"aghsfort_special_templar_assassin_psi_blades_autoattack",
}

item_tidehunter_gush_pf_pct_cooldown = item_small_scepter_fragment
item_tidehunter_gush_pf_gush_damage = item_small_scepter_fragment
item_tidehunter_gush_pf_movement_speed_reduction = item_small_scepter_fragment
item_tidehunter_gush_pf_negative_armor = item_small_scepter_fragment
item_tidehunter_gush_pf_radius = item_small_scepter_fragment
item_tidehunter_gush_pf_debuff_duration = item_small_scepter_fragment

item_tidehunter_kraken_shell_pf_damage_reduction = item_small_scepter_fragment
item_tidehunter_kraken_shell_pf_damage_cleanse = item_small_scepter_fragment

item_tidehunter_anchor_smash_pf_pct_cooldown = item_small_scepter_fragment
-- item_tidehunter_anchor_smash_pf_attack_damage = item_small_scepter_fragment
item_tidehunter_anchor_smash_pf_damage_reduction = item_small_scepter_fragment
item_tidehunter_anchor_smash_pf_radius = item_small_scepter_fragment

item_tidehunter_ravage_pf_pct_cooldown = item_small_scepter_fragment
item_tidehunter_ravage_pf_duration = item_small_scepter_fragment
item_tidehunter_ravage_pf_damage = item_small_scepter_fragment
item_tidehunter_ravage_pf_radius = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_tidehunter" ] =
{
	"item_tidehunter_gush_pf_pct_cooldown",
	"item_tidehunter_gush_pf_gush_damage",
	"item_tidehunter_gush_pf_movement_speed_reduction",
	"item_tidehunter_gush_pf_negative_armor",
	"item_tidehunter_gush_pf_radius",
	"item_tidehunter_gush_pf_debuff_duration",
	
	"item_tidehunter_kraken_shell_pf_damage_reduction",
	"item_tidehunter_kraken_shell_pf_damage_cleanse",
	
	"item_tidehunter_anchor_smash_pf_pct_cooldown",
	-- "item_tidehunter_anchor_smash_pf_attack_damage",
	"item_tidehunter_anchor_smash_pf_damage_reduction",
	"item_tidehunter_anchor_smash_pf_radius",
	
	"item_tidehunter_ravage_pf_pct_cooldown",
	"item_tidehunter_ravage_pf_duration",
	"item_tidehunter_ravage_pf_damage",
	"item_tidehunter_ravage_pf_radius",
}