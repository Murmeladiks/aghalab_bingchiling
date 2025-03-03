local Phantom_Assassin =
{

	{
		description = "phantom_assassin_stifling_dagger_mana_cost_cooldown",
		ability_name = "aghsfort_phantom_assassin_stifling_dagger_lua",
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
		description = "phantom_assassin_stifling_dagger_base_damage",
		ability_name = "aghsfort_phantom_assassin_stifling_dagger_lua",
		special_value_name = "base_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	
	{
		description = "phantom_assassin_stifling_dagger_attack_factor",
		ability_name = "aghsfort_phantom_assassin_stifling_dagger_lua",
		special_values =
		{
			{
				special_value_name = "attack_factor",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 20,
			},
			{
				special_value_name = "attack_factor_tooltip",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 20,
			},
		},
	},
	{
		description = "phantom_assassin_phantom_strike_bonus_attack_speed",
		ability_name = "phantom_assassin_phantom_strike",
		special_value_name = "bonus_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 40,
	},
	{
		description = "phantom_assassin_phantom_strike_bonus_duration",
		ability_name = "phantom_assassin_phantom_strike",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.8,
	},
	
	

	{
		description = "phantom_assassin_phantom_strike_mana_cost_cooldown",
		ability_name = "phantom_assassin_phantom_strike",
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
		description = "phantom_assassin_blur_mana_cost_cooldown",
		ability_name = "phantom_assassin_blur",
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
		description = "phantom_assassin_blur_duration",
		ability_name = "phantom_assassin_blur",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "phantom_assassin_blur_active_movespeed_bonus",
		ability_name = "phantom_assassin_blur",
		special_value_name = "active_movespeed_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},

	{
		description = "phantom_assassin_coup_de_grace_crit_chance",
		ability_name = "phantom_assassin_coup_de_grace",
		special_value_name = "crit_chance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 4,
	},
	{
		description = "phantom_assassin_coup_de_grace_dagger_crit_chance",
		ability_name = "phantom_assassin_coup_de_grace",
		special_value_name = "dagger_crit_chance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 8,
	},
	{
		description = "phantom_assassin_coup_de_grace_crit_bonus",
		ability_name = "phantom_assassin_coup_de_grace",
		special_value_name = "crit_bonus",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 80,
	},
	{
		description = "phantom_assassin_coup_de_grace_attacks_to_proc",
		ability_name = "phantom_assassin_coup_de_grace",
		special_value_name = "attacks_to_proc",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -1,
	},
	{
		description = "phantom_assassin_coup_de_grace_attacks_to_proc_creeps",
		ability_name = "phantom_assassin_coup_de_grace",
		special_value_name = "attacks_to_proc_creeps",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -1,
	},
	{
		description = "phantom_assassin_coup_de_grace_duration",
		ability_name = "phantom_assassin_coup_de_grace",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},




	
}

return Phantom_Assassin
