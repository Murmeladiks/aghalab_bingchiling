local Omniknight =
{
	{
		description = "aghsfort_omniknight_purification_mana_cost_cooldown",
		ability_name = "omniknight_purification",
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
		 description = "aghsfort_omniknight_purification_flat_heal",
		 ability_name = "omniknight_purification",
		 special_value_name = "heal",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 40,
	},


	{
		 description = "aghsfort_omniknight_purification_flat_radius",
		 ability_name = "omniknight_purification",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 80,
	},

	{
		description = "aghsfort_omniknight_repel_mana_cost_cooldown",
		ability_name = "omniknight_martyr",
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
		 description = "aghsfort_omniknight_repel_flat_duration",
		 ability_name = "omniknight_martyr",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	

	{
		 description = "aghsfort_omniknight_repel_flat_bonus_str",
		 ability_name = "omniknight_martyr",
		 special_value_name = "base_strength",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 7,
	},

	{
		 description = "aghsfort_omniknight_repel_flat_hp_regen",
		 ability_name = "omniknight_repel",
		 special_value_name = "base_hpregen",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 6,
	},
	{
		description = "aghsfort_omniknight_degen_aura_flat_radius",
		ability_name = "omniknight_degen_aura",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
   },
	{
		 description = "aghsfort_omniknight_hammer_of_purity_base_damage",
		 ability_name = "omniknight_hammer_of_purity",
		 special_value_name = "base_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 25,
	},
	{
		description = "aghsfort_omniknight_hammer_of_purity_bonus_damage",
		ability_name = "omniknight_hammer_of_purity",
		special_value_name = "bonus_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 25,
   },

	{
		 description = "aghsfort_omniknight_degen_aura_flat_move_speed_bonus",
		 ability_name = "omniknight_degen_aura",
		 special_value_name = "speed_bonus",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 8,
	},


	{
		description = "aghsfort_omniknight_guardian_angel_mana_cost_cooldown",
		ability_name = "omniknight_guardian_angel",
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
		 description = "aghsfort_omniknight_guardian_angel_flat_duration",
		 ability_name = "omniknight_guardian_angel",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.5,
	},

	{
		 description = "aghsfort_omniknight_guardian_angel_flat_radius",
		 ability_name = "omniknight_guardian_angel",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 200,
	},



}

return Omniknight