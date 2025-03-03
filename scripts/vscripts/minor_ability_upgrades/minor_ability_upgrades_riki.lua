local Riki =
{

	{
		description = "aghsfort_riki_smoke_screen_mana_cost_cooldown",
		ability_name = "riki_smoke_screen",
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
		description = "aghsfort_riki_smoke_screen_AbilityDuration",
		ability_name = "riki_smoke_screen",
		special_value_name = "AbilityDuration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "aghsfort_riki_smoke_screen_radius",
		ability_name = "riki_smoke_screen",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_riki_smoke_screen_miss_rate",
		ability_name = "riki_smoke_screen",
		special_value_name = "miss_rate",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_riki_smoke_screen_armor_reduction",
		ability_name = "riki_smoke_screen",
		special_value_name = "armor_reduction",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},

	{
		description = "aghsfort_riki_blink_strike_AbilityChargeRestoreTime",
		ability_name = "riki_blink_strike",
		special_value_name = "AbilityChargeRestoreTime",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -1.5,
	},



	{
		description = "aghsfort_riki_blink_strike_bonus_damage",
		ability_name = "riki_blink_strike",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	{
		description = "aghsfort_riki_blink_strike_slow",
		ability_name = "riki_blink_strike",
		special_value_name = "slow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.1,
	},




	{
		description = "aghsfort_riki_permanent_invisibility_fade_delay",
		ability_name = "riki_permanent_invisibility",
		special_value_name = "fade_delay",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -0.1,
	},
	{
		description = "aghsfort_riki_permanent_invisibility_movement_speed",
		ability_name = "riki_permanent_invisibility",
		special_value_name = "movement_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},


	{
		description = "aghsfort_riki_tricks_of_the_trade_mana_cost_cooldown",
		ability_name = "riki_tricks_of_the_trade",
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
		description = "aghsfort_riki_tricks_of_the_trade_radius",
		ability_name = "riki_tricks_of_the_trade",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	{
		description = "aghsfort_riki_tricks_of_the_trade_damage_pct",
		ability_name = "riki_tricks_of_the_trade",
		special_value_name = "damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_riki_tricks_of_the_trade_agility_pct",
		ability_name = "riki_tricks_of_the_trade",
		special_value_name = "agility_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
	},
	
	{
		description = "aghsfort_riki_tricks_of_the_trade_attack_count",
		ability_name = "riki_tricks_of_the_trade",
		special_values =
		{
			{
				special_value_name = "attack_count",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 1,
			},
			{
				special_value_name = "scepter_attacks",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 1,
			},
		},
	},
	
}

return Riki
