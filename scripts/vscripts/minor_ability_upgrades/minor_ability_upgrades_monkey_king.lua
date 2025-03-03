local Bane =
{

	{
		description = "aghsfort_monkey_king_boundless_strike_mana_cost_cooldown",
		ability_name = "monkey_king_boundless_strike",
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
		description = "aghsfort_monkey_king_boundless_strike_stun_duration",
		ability_name = "monkey_king_boundless_strike",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.2,
	},
	{
		description = "aghsfort_monkey_king_boundless_strike_strike_crit_mult",
		ability_name = "monkey_king_boundless_strike",
		special_value_name = "strike_crit_mult",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 45,
	},
	{
		description = "aghsfort_monkey_king_boundless_strike_strike_flat_damage",
		ability_name = "monkey_king_boundless_strike",
		special_value_name = "strike_flat_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},
	{
		description = "aghsfort_monkey_king_boundless_strike_strike_cast_range",
		ability_name = "monkey_king_boundless_strike",
		special_value_name = "strike_cast_range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},

	{
		description = "aghsfort_monkey_king_primal_spring_mana_cost_cooldown",
		ability_name = "monkey_king_primal_spring",
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
		description = "aghsfort_monkey_king_primal_spring_impact_damage",
		ability_name = "monkey_king_primal_spring",
		special_value_name = "impact_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_monkey_king_primal_spring_impact_radius",
		ability_name = "monkey_king_primal_spring",
		special_value_name = "impact_radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},


	{
		description = "aghsfort_monkey_king_wukongs_command_mana_cost_cooldown",
		ability_name = "monkey_king_wukongs_command",
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
		description = "aghsfort_monkey_king_wukongs_command_duration",
		ability_name = "monkey_king_wukongs_command",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "aghsfort_monkey_king_wukongs_command_attack_speed",
		ability_name = "monkey_king_wukongs_command",
		special_value_name = "attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = -0.1,
	},


	
	


	{
		description = "aghsfort_monkey_king_jingu_mastery_bonus_damage",
		ability_name = "monkey_king_jingu_mastery",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},
	{
		description = "aghsfort_monkey_king_jingu_mastery_lifesteal",
		ability_name = "monkey_king_jingu_mastery",
		special_value_name = "lifesteal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.0,
	},
	
}

return Bane
