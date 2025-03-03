local Kez =
{
	{
		description = "aghsfort_kez_echo_slash_katana_strikes",
		ability_name = "kez_echo_slash",
		special_value_name = "katana_strikes",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_kez_echo_slash_katana_radius",
		ability_name = "kez_echo_slash",
		special_value_name = "katana_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	{
		description = "aghsfort_kez_echo_slash_katana_distance",
		ability_name = "kez_echo_slash",
		special_value_name = "katana_distance",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	
	{
		description = "aghsfort_kez_echo_slash_echo_damage",
		ability_name = "kez_echo_slash",
		special_values =
		{
			{
				special_value_name = "katana_echo_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 25,
			},
			{
				special_value_name = "echo_hero_damage",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 20,
			},
		},
	},
	{
		description = "kez_echo_slash_mana_cost_cooldown",
		ability_name = "kez_echo_slash",
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
		description = "kez_grappling_claw_AbilityCastRange",
		ability_name = "kez_grappling_claw",
		special_value_name = "AbilityCastRange",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "kez_grappling_claw_bonus_flat_lifesteal",
		ability_name = "kez_grappling_claw",
		special_value_name = "bonus_flat_lifesteal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},



	{
		description = "kez_kazurai_katana_mana_cost_cooldown",
		ability_name = "kez_kazurai_katana",
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
		description = "kez_kazurai_katana_katana_bonus_damage",
		ability_name = "kez_kazurai_katana",
		special_value_name = "katana_bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "kez_kazurai_katana_attack_damage_pct",
		ability_name = "kez_kazurai_katana",
		special_value_name = "katana_bleed_attack_damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2.5,
	},
	{
		description = "kez_kazurai_katana_katana_bleed_duration",
		ability_name = "kez_kazurai_katana",
		special_value_name = "katana_bleed_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2.0,
	},
	

	{
		description = "kez_raptor_dance_mana_cost_cooldown",
		ability_name = "kez_raptor_dance",
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
		description = "kez_raptor_dance_strikes",
		ability_name = "kez_raptor_dance",
		special_value_name = "strikes",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "kez_raptor_dance_radius",
		ability_name = "kez_raptor_dance",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "kez_raptor_dance_base_damage",
		ability_name = "kez_raptor_dance",
		special_value_name = "base_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	{
		description = "kez_raptor_dance_max_health_damage_pct",
		ability_name = "kez_raptor_dance",
		special_value_name = "max_health_damage_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.1,
	},
	



	{
		description = "kez_falcon_rush_mana_cost_cooldown",
		ability_name = "kez_falcon_rush",
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
		description = "kez_falcon_rush_duration",
		ability_name = "kez_falcon_rush",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},
	
	{
		description = "kez_falcon_rush_rush_range",
		ability_name = "kez_falcon_rush",
		special_value_name = "rush_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},
	{
		description = "kez_falcon_rush_attack_speed_factor",
		ability_name = "kez_falcon_rush",
		special_value_name = "attack_speed_factor",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},

	{
		description = "kez_talon_toss_mana_cost_cooldown",
		ability_name = "kez_talon_toss",
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
		description = "kez_talon_toss_radius",
		ability_name = "kez_talon_toss",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 55,
	},
	{
		description = "kez_talon_toss_damage",
		ability_name = "kez_talon_toss",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 55,
	},
	{
		description = "kez_talon_toss_silence_duration",
		ability_name = "kez_talon_toss",
		special_value_name = "silence_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "kez_shodo_sai_base_crit_pct",
		ability_name = "kez_shodo_sai",
		special_value_name = "base_crit_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "kez_ravens_veil_blast_radius",
		ability_name = "kez_ravens_veil",
		special_value_name = "blast_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 200,
	},
	{
		description = "kez_ravens_veil_buff_duration",
		ability_name = "kez_ravens_veil",
		special_value_name = "buff_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},
	{
		description = "kez_ravens_veil_bonus_ms",
		ability_name = "kez_ravens_veil",
		special_value_name = "bonus_ms",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 8,
	},

}

return Kez
