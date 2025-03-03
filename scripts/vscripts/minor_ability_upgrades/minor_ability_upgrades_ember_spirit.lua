local Emberspirit  =
{

	{
		description = "aghsfort_ember_spirit_searing_chains_mana_cost_cooldown",
		ability_name = "ember_spirit_searing_chains",
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
		description = "aghsfort_ember_spirit_searing_chains_duration",
		ability_name = "ember_spirit_searing_chains",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},

	{
		description = "aghsfort_ember_spirit_searing_chains_radius",
		ability_name = "ember_spirit_searing_chains",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_ember_spirit_searing_chains_damage_per_second",
		ability_name = "ember_spirit_searing_chains",
		special_value_name = "damage_per_second" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},
	{
		description = "aghsfort_ember_spirit_searing_chains_unit_count",
		ability_name = "ember_spirit_searing_chains",
		special_value_name = "unit_count" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	


	{
		description = "aghsfort_ember_spirit_sleight_of_fist_radius",
		ability_name = "ember_spirit_sleight_of_fist",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	{
		description = "aghsfort_ember_spirit_sleight_of_fist_bonus_hero_damage",
		ability_name = "ember_spirit_sleight_of_fist",
		special_value_name = "bonus_hero_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},

	{
		description = "aghsfort_ember_spirit_flame_guard_mana_cost_cooldown",
		ability_name = "ember_spirit_flame_guard",
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
		description = "aghsfort_ember_spirit_flame_guard_duration",
		ability_name = "ember_spirit_flame_guard",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},
	{
		description = "aghsfort_ember_spirit_flame_guard_damage_per_second",
		ability_name = "ember_spirit_flame_guard",
		special_value_name = "damage_per_second",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_ember_spirit_flame_guard_radius",
		ability_name = "ember_spirit_flame_guard",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_ember_spirit_immolation_radius",
		ability_name = "ember_spirit_immolation",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_ember_spirit_immolation_damage",
		ability_name = "ember_spirit_immolation",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_ember_spirit_fire_remnant_mana_cost_cooldown",
		ability_name = "ember_spirit_fire_remnant",
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
		description = "aghsfort_ember_spirit_fire_remnant_damage",
		ability_name = "ember_spirit_fire_remnant",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "aghsfort_ember_spirit_fire_remnant_duration",
		ability_name = "ember_spirit_fire_remnant",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	
}

return Emberspirit
