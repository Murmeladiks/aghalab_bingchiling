modifier_bristleback_defensive_offense = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_defensive_offense:IsHidden()		return true end
function modifier_bristleback_defensive_offense:RemoveOnDeath() return false end
function modifier_bristleback_defensive_offense:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_bristleback_defensive_offense:OnCreated()
	self.damage_stored = 0
	if IsServer() then
		self:GetParent():EmitSound("Hero_Bristleback.PistonProngs.QuillSpray.Cast")
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_defensive_offense:GetEffectName()
	return "particles/creatures/creature_spiked_carapace.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bristleback_defensive_offense:DeclareFunctions()
	if IsClient() then return end
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

--------------------------------------------------------------------------------

function modifier_bristleback_defensive_offense:GetModifierIncomingDamage_Percentage(keys)
	if 	bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or
		bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS
	then
		return 0
	end

	self.damage_stored = self.damage_stored + keys.damage
	ApplyDamage({
		victim = keys.attacker,
		attacker = self:GetParent(),
		damage = keys.damage,
		damage_type = keys.damage_type,
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
		ability = self:GetAbility()
	})

	return -99999
end

--------------------------------------------------------------------------------

function modifier_bristleback_defensive_offense:OnDestroy()
	if IsClient() then return end
	if self.damage_stored > 0 then
		self:GetParent():EmitSound("Bristleback.DefensiveOffenseHeal")
		local allies =
			FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),
			self:GetParent():GetAbsOrigin(),
			nil,
			self:GetAbility():GetSpecialValueFor("radius"),
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
			FIND_ANY_ORDER,
			false
		)

		local healing = self.damage_stored * self:GetAbility():GetSpecialValueFor("ally_heal_modifier") / 100

		for _, unit in pairs(allies) do
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_luminosity.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, unit:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(pfx)

			unit:HealWithParams(healing, self:GetAbility(), false, true, self:GetParent(), false)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
		end
	end
end
