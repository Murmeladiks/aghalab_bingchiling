local Shadow_Demon =
{
	{
		description = "shadow_demon_disruption_cooldown_manacost",
		ability_name = "shadow_demon_disruption",
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
		 description = "shadow_demon_disruption_disruption_duration",
		 ability_name = "shadow_demon_disruption",
		 special_value_name = "disruption_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 0.6,
	},
	{
		 description = "shadow_demon_disruption_illusion_flat_damage",
		 ability_name = "shadow_demon_disruption",
		 special_value_name = "illusion_flat_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 15,
	},
	{
		 description = "shadow_demon_disruption_illusion_duration",
		 ability_name = "shadow_demon_disruption",
		 special_value_name = "illusion_duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 3,
	},

	
  
	{
		description = "shadow_demon_disseminate_cooldown_manacost",
		ability_name = "shadow_demon_disseminate",
		special_values =
		{
			{
				special_value_name = "mana_cost",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			{
				special_value_name = "mana_per_second",
				operator = MINOR_ABILITY_UPGRADE_OP_MUL,
				value = -MINOR_ABILITY_COOLDOWN_MANACOST_PCT,
			},
			
		},
	},

	{
		 description = "shadow_demon_disseminate_duration",
		 ability_name = "shadow_demon_disseminate",
		 special_value_name = "duration",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 1.5,
	},
	{
		 description = "shadow_demon_disseminate_health_lost",
		 ability_name = "shadow_demon_disseminate",
		 special_value_name = "health_lost",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 4,
	},
	{
		description = "shadow_demon_disseminate_damage_reflection_pct",
		ability_name = "shadow_demon_disseminate",
		special_value_name = "damage_reflection_pct",
		operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		value = 9,
   },
   {
	description = "shadow_demon_disseminate_radius",
	ability_name = "shadow_demon_disseminate",
	special_value_name = "radius",
	operator = MINOR_ABILITY_UPGRADE_OP_ADD,
	value = 165,
	},
	{
		 description = "shadow_demon_demonic_purge_purge_damage",
		 ability_name = "shadow_demon_demonic_purge",
		 special_value_name = "purge_damage",
		 operator = MINOR_ABILITY_UPGRADE_OP_ADD,
		 value = 150,
	},	

}

return Shadow_Demon