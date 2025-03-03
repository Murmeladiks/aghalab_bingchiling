local DrowRanger =
{

	{
		 description = "aghsfort2_drow_ranger_frost_arrows_damage",
		 ability_name = "drow_ranger_frost_arrows",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 10,
	},
	{
		 description = "aghsfort2_drow_ranger_frost_arrows_frost_arrows_movement_speed",
		 ability_name = "drow_ranger_frost_arrows",
		 special_value_name = "frost_arrows_movement_speed",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 10,
	},

	{
		description = "aghsfort2_drow_ranger_wave_of_silence_wave_width",
		ability_name = "drow_ranger_wave_of_silence",
		special_value_name = "wave_width",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
   	},
	{
		description = "aghsfort2_drow_ranger_wave_of_silence_silence_duration",
		ability_name = "drow_ranger_wave_of_silence",
		special_value_name = "silence_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
   	},
	{
		description = "aghsfort2_drow_ranger_wave_of_silence_blind_percent",
		ability_name = "drow_ranger_wave_of_silence",
		special_value_name = "miss_chance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 7,
	},
	{
		description = "aghsfort2_drow_ranger_wave_of_silence_mana_cost_cooldown",
		ability_name = "drow_ranger_wave_of_silence",
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
	   description = "aghsfort2_drow_ranger_multishot_arrow_count_per_wave",
	   ability_name = "drow_ranger_multishot",
	   special_value_name = "arrow_count_per_wave",
	   operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	   value = 1,
	},
   	{
	   description = "aghsfort2_drow_ranger_multishot_arrow_damage_pct",
	   ability_name = "drow_ranger_multishot",
	   special_value_name = "arrow_damage_pct",
	   operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	   value = 15,
	},
	{
		description = "aghsfort2_drow_ranger_multishot_mana_cost_cooldown",
		ability_name = "drow_ranger_multishot",
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
		description = "aghsfort2_drow_ranger_marksmanship_bonus_damage",
		ability_name = "drow_ranger_marksmanship",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 30,
	},
	{
		description = "aghsfort2_drow_ranger_marksmanship_bonus_range",
		ability_name = "drow_ranger_marksmanship",
		special_value_name = "disable_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},

	{
		description = "aghsfort2_drow_ranger_marksmanship_mana_cost_cooldown",
		ability_name = "drow_ranger_marksmanship",
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

return DrowRanger
