local Razor =
{

	{
		description = "aghsfort_razor_plasma_field_mana_cost_cooldown",
		ability_name = "razor_plasma_field",
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
		description = "aghsfort_razor_plasma_field_damage_min",
		ability_name = "razor_plasma_field",
		special_value_name = "damage_min",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 12,
	},

	{
		description = "aghsfort_razor_plasma_field_damage_max",
		ability_name = "razor_plasma_field",
		special_value_name = "damage_max",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},
	{
		description = "aghsfort_razor_plasma_field_radius",
		ability_name = "razor_plasma_field",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},

	{
		description = "aghsfort_razor_static_link_mana_cost_cooldown",
		ability_name = "razor_static_link",
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
		description = "aghsfort_razor_static_link_drain_duration",
		ability_name = "razor_static_link",
		special_value_name = "drain_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 4,
	},
	{
		description = "aghsfort_razor_static_link_drain_rate",
		ability_name = "razor_static_link",
		special_value_name = "drain_rate",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_razor_storm_surge_strike_pct_chance",
		ability_name = "razor_storm_surge",
		special_value_name = "strike_pct_chance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
	{
		description = "aghsfort_razor_storm_surge_strike_target_count",
		ability_name = "razor_storm_surge",
		special_value_name = "strike_target_count",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_razor_storm_surge_strike_damage",
		ability_name = "razor_storm_surge",
		special_value_name = "strike_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},
	{
		description = "aghsfort_razor_eye_of_the_storm_mana_cost_cooldown",
		ability_name = "razor_eye_of_the_storm",
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
		description = "aghsfort_razor_eye_of_the_storm_duration",
		ability_name = "razor_eye_of_the_storm",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3.0,
	},
	{
		description = "aghsfort_razor_eye_of_the_storm_radius",
		ability_name = "razor_eye_of_the_storm",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_razor_eye_of_the_storm_strike_interval",
		ability_name = "razor_eye_of_the_storm",
		special_value_name = "strike_interval",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -0.1,
	},
	{
		description = "aghsfort_razor_eye_of_the_storm_armor_reduction",
		ability_name = "razor_eye_of_the_storm",
		special_value_name = "armor_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_razor_eye_of_the_storm_damage",
		ability_name = "razor_eye_of_the_storm",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	
}

return Razor
