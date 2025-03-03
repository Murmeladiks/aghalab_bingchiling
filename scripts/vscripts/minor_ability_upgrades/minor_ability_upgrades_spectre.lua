local Spectre =
{

	{
		description = "aghsfort_spectre_spectral_dagger_mana_cost_cooldown",
		ability_name = "spectre_spectral_dagger",
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
		description = "aghsfort_spectre_spectral_dagger_damage",
		ability_name = "spectre_spectral_dagger",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},

	{
		description = "aghsfort_spectre_spectral_dagger_bonus_movespeed",
		ability_name = "spectre_spectral_dagger",
		special_value_name = "bonus_movespeed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_spectre_desolate_dagger_bonus_damage",
		ability_name = "spectre_desolate",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	{
		description = "aghsfort_spectre_dispersion_damage_reflection_pct",
		ability_name = "spectre_dispersion",
		special_value_name = "damage_reflection_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},

	{
		description = "aghsfort_spectre_haunt_single_mana_cost_cooldown",
		ability_name = "spectre_haunt_single",
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
		description = "aghsfort_spectre_haunt_single_duration",
		ability_name = "spectre_haunt_single",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "aghsfort_spectre_haunt_duration",
		ability_name = "spectre_haunt",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
	{
		description = "aghsfort_spectre_haunt_mana_cost_cooldown",
		ability_name = "spectre_haunt",
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







	
}

return Spectre
