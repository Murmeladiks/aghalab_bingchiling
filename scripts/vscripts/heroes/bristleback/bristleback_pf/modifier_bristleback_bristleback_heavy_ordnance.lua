modifier_bristleback_bristleback_heavy_ordnance = class({})

--------------------------------------------------------------------------------

-- aura hack stuff that i just found out a while ago
function modifier_bristleback_bristleback_heavy_ordnance:IsAura() 				return (self:GetParent() == self.caster) and (self.aura_radius > 0) end
function modifier_bristleback_bristleback_heavy_ordnance:GetAuraSearchTeam() 	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_bristleback_bristleback_heavy_ordnance:GetAuraSearchType() 	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end
function modifier_bristleback_bristleback_heavy_ordnance:GetAuraSearchFlags() 	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_bristleback_bristleback_heavy_ordnance:GetModifierAura() 		return "modifier_bristleback_bristleback_heavy_ordnance" end
function modifier_bristleback_bristleback_heavy_ordnance:GetAuraRadius() 		return self.aura_radius end
function modifier_bristleback_bristleback_heavy_ordnance:IsPurgable() 			return false end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:GetAuraEntityReject(hEntity)
	return hEntity == self:GetCaster()
end
--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:OnCreated()
	self.caster = self:GetCaster()

	if not self.caster or self.caster:IsNull() then
		self:Destroy()
		return
	end

	self.ability = self.caster:FindAbilityByName("pathfinder_bristleback_bristleback_heavy_ordnance")
	if not self.ability or self.ability:IsNull() then
		self:Destroy()
		return
	end

	self.fixed_movement_speed = self.ability:GetSpecialValueFor("fixed_movement_speed")
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.aura_total_damage_reduction = self.ability:GetSpecialValueFor("aura_total_damage_reduction")

	if self.caster ~= self:GetParent() or not IsServer() then return end

	local aura_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_heavy_ordnance_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(aura_fx, 1, Vector(self.aura_radius, 0, 0))
	self:AddParticle(aura_fx, false, false, -1, false, false)

	self.caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:OnDestroy()
	if self.FXIndex then
		ParticleManager:DestroyParticle(self.FXIndex, false)
		ParticleManager:ReleaseParticleIndex(self.FXIndex)
	end

	if self.caster == self:GetParent() and IsServer() then
		self.caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	if self:GetCaster() == self:GetParent() then
		table.insert(funcs, MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX)
		table.insert(funcs, MODIFIER_PROPERTY_ATTACK_RANGE_BONUS)
		table.insert(funcs, MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS)
		table.insert(funcs, MODIFIER_PROPERTY_PROJECTILE_NAME)
	end

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:GetModifierMoveSpeed_AbsoluteMax()
	return self.fixed_movement_speed or 290
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:GetModifierAttackRangeBonus()
	return (self.aura_radius or 150) - 150
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:GetModifierIncomingDamage_Percentage()
	return (-1) * (self.aura_total_damage_reduction or 0)
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_heavy_ordnance:GetModifierProjectileName()
	return "particles/neutral_fx/mud_golem_hurl_boulder.vpcf"
end