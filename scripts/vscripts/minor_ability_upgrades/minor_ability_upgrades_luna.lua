local Luna =
{
	{
		description = "aghsfort_luna_lucent_beam_flat_damage",
		ability_name = "luna_lucent_beam",
		special_value_name = "beam_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},

	{
	 	description = "aghsfort_luna_lucent_beam_percent_mana_cost_cooldown",
	 	ability_name = "luna_lucent_beam",
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
		description = "aghsfort_luna_lucent_beam_flat_stun",
		ability_name = "luna_lucent_beam",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.25,
	},

	{
		description = "aghsfort_luna_moon_glaive_range",
		ability_name = "luna_moon_glaive",
		special_value_name = "range",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 100,
	},

	{
		description = "aghsfort_luna_moon_glaive_bounces",
		ability_name = "luna_moon_glaive",
		special_value_name = "bounces",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	 },

	{
		description = "aghsfort_luna_moon_glaive_damage_reduction_percent",
		ability_name = "luna_moon_glaive",
		special_value_name = "damage_reduction_percent",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = -5,
	},

	--[[{
	 	description = "aghsfort_luna_moon_glaive_percent_mana_cost",
	 	ability_name = "aghsfort_luna_moon_glaive",
	 	special_value_name = "mana_cost",
	 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	 	value = 12,
	 },

	 {
	 	description = "aghsfort_luna_moon_glaive_percent_cooldown",
	 	ability_name = "aghsfort_luna_moon_glaive",
	 	special_value_name = "cooldown",
	 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	 	value = 12,
	 },--]]

	{
		description = "aghsfort_luna_lunar_blessing_flat_damage",
		ability_name = "luna_lunar_blessing",
		special_value_name = "self_bonus_damage_per_level",		
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
		
	},

	

	

	

	{
		description = "aghsfort_luna_eclipse_beams",
		ability_name = "luna_eclipse",
		special_value_name = "beams",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},

	--[[{
		description = "aghsfort_luna_eclipse_hit_count",
		ability_name = "aghsfort_luna_eclipse",
		special_value_name = "hit_count",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 2,
	},--]]

	{
		description = "aghsfort_luna_eclipse_percent_cooldown_mana_cost",
		ability_name = "luna_eclipse",
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

	--[[{
		description = "aghsfort_luna_eclipse_radius",
		ability_name = "aghsfort_luna_eclipse",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 125,
	},--]]

}

return Luna
