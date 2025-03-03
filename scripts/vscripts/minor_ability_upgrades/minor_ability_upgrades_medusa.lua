local Medusa =
{

	{
		description = "aghsfort_medusa_split_shot_damage",
		ability_name = "medusa_split_shot",
		special_values =
		{
			{
				special_value_name = "damage_modifier",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 5,
			},
			{
				special_value_name = "damage_modifier_tooltip",
				operator = MINOR_ABILITY_UPGRADE_OP_ADD,
				value = 5,
			},
		},
	},
	
	
	
	{
		description = "aghsfort_medusa_mystic_snake_mana_cost_cooldown",
		ability_name = "medusa_mystic_snake",
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
		description = "aghsfort_medusa_mystic_snake_snake_jumps",
		ability_name = "medusa_mystic_snake",
		special_value_name = "snake_jumps",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_medusa_mystic_snake_snake_damage",
		ability_name = "medusa_mystic_snake",
		special_value_name = "snake_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 60,
	},
	{
		description = "aghsfort_medusa_mystic_snake_snake_scale",
		ability_name = "medusa_mystic_snake",
		special_value_name = "snake_scale",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},
	{
		description = "aghsfort_medusa_mystic_snake_snake_mana_steal",
		ability_name = "medusa_mystic_snake",
		special_value_name = "snake_mana_steal",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 3,
	},
	{
		description = "aghsfort_medusa_mana_shield_damage_per_mana",
		ability_name = "medusa_mana_shield",
		special_value_name = "damage_per_mana",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.2,
	},
	{
		description = "aghsfort_medusa_mana_shield_damage_per_mana_per_level",
		ability_name = "medusa_mana_shield",
		special_value_name = "damage_per_mana_per_level",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.1,
	},

	{
		description = "aghsfort_medusa_stone_gaze_mana_cost_cooldown",
		ability_name = "medusa_stone_gaze",
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
		description = "aghsfort_medusa_stone_gaze_duration",
		ability_name = "medusa_stone_gaze",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_medusa_stone_gaze_radius",
		ability_name = "medusa_stone_gaze",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_medusa_stone_gaze_bonus_physical_damage",
		ability_name = "medusa_stone_gaze",
		special_value_name = "bonus_physical_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 5,
	},

	

	{
		description = "aghsfort_medusa_gorgon_grasp_mana_cost_cooldown",
		ability_name = "medusa_gorgon_grasp",
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
		description = "aghsfort_medusa_gorgon_grasp_radius",
		ability_name = "medusa_gorgon_grasp",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_medusa_gorgon_grasp_radius_grow",
		ability_name = "medusa_gorgon_grasp",
		special_value_name = "radius_grow",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	
	
	{
		description = "aghsfort_medusa_gorgon_grasp_damage",
		ability_name = "medusa_gorgon_grasp",
		special_value_name = "damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_medusa_gorgon_grasp_damage_pers",
		ability_name = "medusa_gorgon_grasp",
		special_value_name = "damage_pers",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	{
		description = "aghsfort_medusa_gorgon_grasp_duration",
		ability_name = "medusa_gorgon_grasp",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1,
	},
	



	
}

return Medusa
