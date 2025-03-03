local Bane =
{

	{
		description = "aghsfort_ogre_magi_fireblast_mana_cost_cooldown",
		ability_name = "ogre_magi_fireblast",
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
		description = "aghsfort_ogre_magi_fireblast_stun_duration",
		ability_name = "ogre_magi_fireblast",
		special_value_name = "stun_duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.3,
	},
	{
		description = "aghsfort_ogre_magi_fireblast_fireblast_damage",
		ability_name = "ogre_magi_fireblast",
		special_value_name = "fireblast_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 60,
	},

	
	

	{
		description = "aghsfort_ogre_magi_ignite_mana_cost_cooldown",
		ability_name = "ogre_magi_ignite",
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
		description = "aghsfort_ogre_magi_ignite_duration",
		ability_name = "ogre_magi_ignite",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},

	{
		description = "aghsfort_ogre_magi_ignite_burn_damage",
		ability_name = "ogre_magi_ignite",
		special_value_name = "burn_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 15,
	},

	{
		description = "aghsfort_ogre_magi_bloodlust_mana_cost_cooldown",
		ability_name = "ogre_magi_bloodlust",
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
		description = "aghsfort_ogre_magi_bloodlust_duration",
		ability_name = "ogre_magi_bloodlust",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.5,
	},
	{
		description = "aghsfort_ogre_magi_bloodlust_bonus_movement_speed",
		ability_name = "ogre_magi_bloodlust",
		special_value_name = "bonus_movement_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	{
		description = "aghsfort_ogre_magi_bloodlust_bonus_attack_speed",
		ability_name = "ogre_magi_bloodlust",
		special_value_name = "bonus_attack_speed",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 20,
	},



	

	{
		description = "aghsfort_ogre_magi_multicast_multicast_2_times",
		ability_name = "ogre_magi_multicast",
		special_value_name = "multicast_2_times",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_ogre_magi_multicast_multicast_3_times",
		ability_name = "ogre_magi_multicast",
		special_value_name = "multicast_3_times",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 4,
	},
	{
		description = "aghsfort_ogre_magi_multicast_multicast_4_times",
		ability_name = "ogre_magi_multicast",
		special_value_name = "multicast_4_times",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
}

return Bane
