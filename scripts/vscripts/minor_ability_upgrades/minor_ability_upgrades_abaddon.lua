local Abaddon =
{

	{
		description = "aghsfort_abaddon_death_coil_mana_cost_cooldown",
		ability_name = "abaddon_death_coil",
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
		description = "aghsfort_abaddon_death_coil_target_damage",
		ability_name = "abaddon_death_coil",
		special_values =
		{
			{
				special_value_name = "target_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 80,
			},
			{
				special_value_name = "heal_amount",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 80,
			},
		},
		
	},

	{
		description = "aghsfort_abaddon_aphotic_shield_mana_cost_cooldown",
		ability_name = "abaddon_aphotic_shield",
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
		description = "aghsfort_abaddon_aphotic_shield_duration",
		ability_name = "abaddon_aphotic_shield",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
	{
		description = "aghsfort_abaddon_aphotic_damage_absorb",
		ability_name = "abaddon_aphotic_shield",
		special_value_name = "damage_absorb",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_abaddon_aphotic_regen",
		ability_name = "abaddon_aphotic_shield",
		special_value_name = "regen",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	{
		description = "aghsfort_abaddon_frostmourne_mana_cost_cooldown",
		ability_name = "abaddon_frostmourne",
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
		description = "aghsfort_abaddon_frostmourne_curse_slow",
		ability_name = "abaddon_frostmourne",
		special_value_name = "curse_slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_abaddon_frostmourne_curse_attack_speed",
		ability_name = "abaddon_frostmourne",
		special_value_name = "curse_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},
	{
		description = "aghsfort_abaddon_frostmourne_curse_curse_dps",
		ability_name = "abaddon_frostmourne",
		special_value_name = "curse_dps",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	{
		description = "aghsfort_abaddon_borrowed_time_mana_cost_cooldown",
		ability_name = "abaddon_borrowed_time",
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
		description = "aghsfort_abaddon_borrowed_time_duration",
		ability_name = "abaddon_borrowed_time",
		special_values =
		{
			{
				special_value_name = "duration",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 1.5,
			},
			{
				special_value_name = "duration_scepter",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 1.5,
			},
		},
		
	},



	{
		description = "aghsfort_abaddon_borrowed_time_immolate_damage",
		ability_name = "abaddon_borrowed_time",
		special_value_name = "immolate_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},
}

return Abaddon
