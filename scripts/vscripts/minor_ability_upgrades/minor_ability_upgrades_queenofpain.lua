local QueenOfPain =
{
	{
		description = "aghsfort_queenofpain_shadow_strike_mana_cost_cooldown",
		ability_name = "queenofpain_shadow_strike",
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
		 description = "aghsfort_queenofpain_shadow_strike_dot_damage",
		 ability_name = "queenofpain_shadow_strike",
		 special_value_name = "duration_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 20,
	},

	{
		 description = "aghsfort_queenofpain_shadow_strike_strike_damage",
		 ability_name = "queenofpain_shadow_strike",
		 special_value_name = "strike_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 100,
	},	


	{
		description = "aghsfort_queenofpain_shadow_strike_duration_heal",
		ability_name = "queenofpain_shadow_strike",
		special_value_name = "duration_heal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 10,
	},

	{
		description = "aghsfort_queenofpain_scream_of_pain_mana_cost_cooldown",
		ability_name = "aghsfort_queenofpain_scream_of_pain",
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
		description = "aghsfort_queenofpain_blink_mana_cost_cooldown",
		ability_name = "queenofpain_blink",
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
		 description = "aghsfort_queenofpain_blink_range",
		 ability_name = "queenofpain_blink",
		 special_value_name = "min_blink_range",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 200,
	},
	
	{
		 description = "aghsfort_queenofpain_scream_of_pain_damage",
		 ability_name = "queenofpain_scream_of_pain",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},
	{
		 description = "aghsfort_queenofpain_scream_of_pain_radius",
		 ability_name = "queenofpain_scream_of_pain",
		 special_value_name = "area_of_effect",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 75,
	},
	{
		description = "aghsfort_queenofpain_sonic_wave_mana_cost_cooldown",
		ability_name = "queenofpain_sonic_wave",
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
		 description = "aghsfort_queenofpain_sonic_wave_damage",
		 ability_name = "queenofpain_sonic_wave",
		 special_value_name = "damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 110,
	},
	{
		 description = "aghsfort_queenofpain_sonic_wave_distance",
		 ability_name = "queenofpain_sonic_wave",
		 special_value_name = "distance",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},
	{
		 description = "aghsfort_queenofpain_sonic_wave_knockback_duration",
		 ability_name = "queenofpain_sonic_wave",
		 special_value_name = "knockback_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.5,
	},	
	{
		description = "aghsfort_queenofpain_masochist_spell_amplification",
		ability_name = "queenofpain_masochist",
		special_value_name = "spell_amplification",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
   },		
   {
	description = "aghsfort_queenofpain_bondage_spell_reflect_pct",
	ability_name = "queenofpain_bondage",
	special_value_name = "spell_reflect_pct",
	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	value = 3,
	},	
	{
	description = "aghsfort_queenofpain_succubus_spell_lifesteal",
	ability_name = "queenofpain_succubus",
	special_value_name = "spell_lifesteal",
	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	value = 3,
	},	
}

return QueenOfPain
