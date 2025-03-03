local Alchemist =
{

	{
		description = "aghsfort_alchemist_acid_spray_mana_cost_cooldown",
		ability_name = "aghsfort_alchemist_acid_spray",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

	{
		description = "aghsfort_alchemist_acid_spray_radius",
		ability_name = "aghsfort_alchemist_acid_spray",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_alchemist_acid_spray_duration",
		ability_name = "aghsfort_alchemist_acid_spray",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
	{
		description = "aghsfort_alchemist_acid_spray_damage",
		ability_name = "aghsfort_alchemist_acid_spray",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_alchemist_acid_armor_reduction",
		ability_name = "aghsfort_alchemist_acid_spray",
		special_value_name = "armor_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_alchemist_acid_armor_allies",
		ability_name = "aghsfort_alchemist_acid_spray",
		special_value_name = "armor_allies",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_alchemist_acid_tick_rate",
		ability_name = "aghsfort_alchemist_acid_spray",
		special_value_name = "tick_rate",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -0.1,
	},



	

	{
		description = "aghsfort_alchemist_goblins_greed_duration",
		ability_name = "alchemist_goblins_greed",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3.0,
	},
	{
		description = "aghsfort_alchemist_goblins_greed_bonus_gold",
		ability_name = "alchemist_goblins_greed",
		special_value_name = "bonus_gold",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_alchemist_goblins_greed_bonus_bonus_gold",
		ability_name = "alchemist_goblins_greed",
		special_value_name = "bonus_bonus_gold",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_alchemist_goblins_greed_damage",
		ability_name = "alchemist_goblins_greed",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_alchemist_goblins_greed_bonus_gold_cap",
		ability_name = "alchemist_goblins_greed",
		special_value_name = "bonus_gold_cap",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	{
		description = "aghsfort_alchemist_unstable_concoction_mana_cost_cooldown",
		ability_name = "alchemist_unstable_concoction",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},
	{
		description = "aghsfort_alchemist_unstable_concoction_max_damage",
		ability_name = "alchemist_unstable_concoction_throw",
		special_value_name = "max_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "aghsfort_alchemist_unstable_concoction_midair_explosion_radius",
		ability_name = "alchemist_unstable_concoction_throw",
		special_value_name = "midair_explosion_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "aghsfort_alchemist_chemical_rage_mana_cost_cooldown",
		ability_name = "aghsfort_alchemist_chemical_rage",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "cooldown",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
		},
	},

	{
		description = "aghsfort_alchemist_chemical_rage_duration",
		ability_name = "aghsfort_alchemist_chemical_rage",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	{
		description = "aghsfort_alchemist_chemical_rage_base_attack_time",
		ability_name = "aghsfort_alchemist_chemical_rage",
		special_value_name = "base_attack_time",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -0.1,
	},
	{
		description = "aghsfort_alchemist_chemical_rage_bonus_health_regen",
		ability_name = "aghsfort_alchemist_chemical_rage",
		special_value_name = "bonus_health_regen",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_alchemist_chemical_rage_bonus_movespeed",
		ability_name = "aghsfort_alchemist_chemical_rage",
		special_value_name = "bonus_movespeed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},


	
	{
		description = "aghsfort_alchemist_corrosive_weaponry_max_stacks",
		ability_name = "aghsfort_alchemist_corrosive_weaponry",
		special_value_name = "max_stacks",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
	{
		description = "aghsfort_alchemist_corrosive_weaponry_debuff_duration",
		ability_name = "aghsfort_alchemist_corrosive_weaponry",
		special_value_name = "debuff_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},
	{
		description = "aghsfort_alchemist_corrosive_weaponry_slow_per_stack",
		ability_name = "aghsfort_alchemist_corrosive_weaponry",
		special_value_name = "slow_per_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_alchemist_corrosive_weaponry_attack_damage_per_stack",
		ability_name = "aghsfort_alchemist_corrosive_weaponry",
		special_value_name = "attack_damage_per_stack",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	

	
}

return Alchemist
