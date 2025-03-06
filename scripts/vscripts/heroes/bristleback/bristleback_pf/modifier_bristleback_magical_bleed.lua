modifier_bristleback_magical_bleed = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_magical_bleed:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_bristleback_magical_bleed:OnCreated(keys)
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local quills_ability = caster:FindAbilityByName("bristleback_quill_spray_pf")

	self.damage_pct = self:GetAbility():GetSpecialValueFor("pathfinder_bristleback_bristleback_magical_bleed", "quill_max_damage_pct")
	self.damage = quills_ability:GetSpecialValueFor("max_damage") * self.damage_pct / 100
	if not IsServer() then return end

	self.damageTable = {
		attacker = caster,
		victim = parent,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability
	}
	self:SetStackCount(1)
	self:StartIntervalThink(self:GetDuration() / 4)
end

--------------------------------------------------------------------------------

function modifier_bristleback_magical_bleed:OnRefresh()
	if IsClient() then return end
	self:IncrementStackCount()
end

--------------------------------------------------------------------------------

function modifier_bristleback_magical_bleed:OnIntervalThink()
	self.damageTable.damage = self.damage * self:GetStackCount()
	ApplyDamage(self.damageTable)
end

--------------------------------------------------------------------------------

function modifier_bristleback_magical_bleed:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bristleback_magical_bleed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end