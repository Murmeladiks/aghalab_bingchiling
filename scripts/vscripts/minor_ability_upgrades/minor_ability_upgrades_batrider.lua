local Batrider =
{
	{
		description = "aghsfort_batrider_sticky_napalm_mana_cost_cooldown",
		ability_name = "batrider_sticky_napalm",
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
		description = "aghsfort_batrider_sticky_napalm_damage",
		ability_name = "batrider_sticky_napalm",
		special_value_name = "damage" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_batrider_sticky_napalm_application_damage",
		ability_name = "batrider_sticky_napalm",
		special_value_name = "application_damage" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_batrider_sticky_napalm_duration",
		ability_name = "batrider_sticky_napalm",
		special_value_name = "duration" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	{
		description = "aghsfort_batrider_flamebreak_mana_cost_cooldown",
		ability_name = "batrider_flamebreak",
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
		description = "aghsfort_batrider_flamebreak_damage_duration",
		ability_name = "batrider_flamebreak",
		special_value_name = "damage_duration" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	{
		description = "aghsfort_batrider_flamebreak_damage_impact",
		ability_name = "batrider_flamebreak",
		special_value_name = "damage_impact" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},
	{
		description = "aghsfort_batrider_flamebreak_damage_per_second",
		ability_name = "batrider_flamebreak",
		special_value_name = "damage_per_second" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_batrider_flamebreak_explosion_radius",
		ability_name = "batrider_flamebreak",
		special_value_name = "explosion_radius" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_batrider_firefly_mana_cost_cooldown",
		ability_name = "batrider_firefly",
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
		description = "aghsfort_batrider_firefly_damage_per_second",
		ability_name = "batrider_firefly",
		special_value_name = "damage_per_second" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},
	{
		description = "aghsfort_batrider_firefly_radius",
		ability_name = "batrider_firefly",
		special_value_name = "radius" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_batrider_firefly_duration",
		ability_name = "batrider_firefly",
		special_value_name = "duration" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
	{
		description = "aghsfort_batrider_flaming_lasso_mana_cost_cooldown",
		ability_name = "batrider_flaming_lasso",
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
		description = "aghsfort_batrider_flaming_lasso_duration",
		ability_name = "batrider_flaming_lasso",
		special_value_name = "duration" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
	{
		description = "aghsfort_batrider_flaming_lasso_damage",
		ability_name = "batrider_flaming_lasso",
		special_value_name = "damage" ,
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
}

return Batrider
