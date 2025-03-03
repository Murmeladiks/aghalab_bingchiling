local Disruptor =
{
	{
		description = "aghsfort_disruptor_thunder_strike_mana_cost_cooldown",
		ability_name = "disruptor_thunder_strike",
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
		 description = "aghsfort_disruptor_thunder_strike_flat_radius",
		 ability_name = "disruptor_thunder_strike",
		 special_value_name = "radius",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 60,
	},

	{
		 description = "aghsfort_disruptor_thunder_strike_flat_strikes",
		 ability_name = "disruptor_thunder_strike",
		 special_value_name = "strikes",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1,
	},

	{
		 description = "aghsfort_disruptor_thunder_strike_flat_strike_damage",
		 ability_name = "disruptor_thunder_strike",
		 special_value_name = "strike_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 35,
	},

	{
		description = "aghsfort_disruptor_glimpse_mana_cost_cooldown",
		ability_name = "disruptor_glimpse",
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
		description = "aghsfort_disruptor_glimpse_flat_max_damage",
		ability_name = "disruptor_glimpse",
		special_value_name = "max_damage",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
   },

	{
		 description = "aghsfort_disruptor_glimpse_flat_bonus_damage",
		 ability_name = "disruptor_glimpse",
		 special_value_name = "damage_to_distance_pct",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 5,
	},

	{
		description = "aghsfort_disruptor_kinetic_field_mana_cost_cooldown",
		ability_name = "disruptor_kinetic_field",
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
		description = "aghsfort_disruptor_kinetic_fence_mana_cost_cooldown",
		ability_name = "disruptor_kinetic_fence",
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
		description = "aghsfort_disruptor_kinetic_fence_flat_duration",
		ability_name = "disruptor_kinetic_fence",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},
	{
		description = "aghsfort_disruptor_kinetic_fence_wall_width",
		ability_name = "disruptor_kinetic_fence",
		special_value_name = "wall_width",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 50,
	},
	{
		description = "aghsfort_disruptor_kinetic_fence_formation_time",
		ability_name = "disruptor_kinetic_fence",
		special_value_name = "formation_time",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = -20,
	},
	-- {
	-- 	description = "aghsfort_disruptor_electromagnetic_repulsion_damage_threshold",
	-- 	ability_name = "disruptor_electromagnetic_repulsion",
	-- 	special_value_name = "damage_threshold",
	-- 	operator = MINOR_ABILITY_UPGRADE_OP_MUL,
	-- 	value = -10,
	-- },
	{
		description = "aghsfort_disruptor_kinetic_field_flat_duration",
		ability_name = "disruptor_kinetic_field",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 0.5,
	},

	{
		description = "aghsfort_disruptor_kinetic_field_formation_time",
		ability_name = "disruptor_kinetic_field",
		special_value_name = "formation_time",
		operator = MINOR_ABILITY_UPGRADE_OP_MUL,
		value = -20,
	},


	{
		description = "aghsfort_disruptor_static_storm_mana_cost_cooldown",
		ability_name = "disruptor_static_storm",
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
		description = "aghsfort_disruptor_static_storm_flat_duration",
		ability_name = "disruptor_static_storm",
		special_value_name = "duration",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 1.25,
	},

	{
		description = "aghsfort_disruptor_static_storm_flat_radius",
		ability_name = "disruptor_static_storm",
		special_value_name = "radius",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 125,
	},

	{
		description = "aghsfort_disruptor_static_storm_flat_damage_max",
		ability_name = "disruptor_static_storm",
		special_value_name = "damage_max",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 75,
	},
}

return Disruptor