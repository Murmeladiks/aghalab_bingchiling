modifier_bristleback_viscous_nasal_goo_pf = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_viscous_nasal_goo_pf:GetEffectName()
	if self:GetCaster():HasAbility("pathfinder_bristleback_viscous_nasal_goo_bloody_rage") then
		return "particles/heroes/bristleback/bristleback_bloody_goo_debuff.vpcf"
	end

	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bristleback_viscous_nasal_goo_pf:GetStatusEffectName()
	if self:GetCaster():HasAbility("pathfinder_bristleback_viscous_nasal_goo_bloody_rage") then
		return "particles/heroes/bristleback/bristleback_bloody_goo_status_effect.vpcf"
	end

	return "particles/status_fx/status_effect_goo.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bristleback_viscous_nasal_goo_pf:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- AbilitySpecials
	self.goo_duration = self.ability:GetSpecialValueFor("goo_duration")
	self.base_armor = self.ability:GetSpecialValueFor("base_armor")
	self.armor_per_stack = self.ability:GetSpecialValueFor("armor_per_stack")
	self.base_move_slow = self.ability:GetSpecialValueFor("base_move_slow")
	self.move_slow_per_stack = self.ability:GetSpecialValueFor("move_slow_per_stack")
	self.stack_limit =
		self.ability:GetSpecialValueFor("stack_limit") 

	if not IsServer() then
		return
	end

	self:SetStackCount(1)

	local particle_name = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf"
	
	if self:GetCaster():HasAbility("pathfinder_bristleback_viscous_nasal_goo_bloody_rage") then
		particle_name = "particles/heroes/bristleback/bristleback_bloody_stack.vpcf"
	end

	self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
end

--------------------------------------------------------------------------------

function modifier_bristleback_viscous_nasal_goo_pf:OnRefresh()
	if not IsServer() then
		return
	end

	if self:GetStackCount() < self.stack_limit then
		self:IncrementStackCount()
	elseif self.caster:HasAbility("pathfinder_bristleback_viscous_nasal_goo_dirty_brawler") then
		local dirty_brawler = self.caster:FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_dirty_brawler")
		local quill_spray = self.caster:FindAbilityByName("bristleback_quill_spray_pf")
		if quill_spray and not quill_spray:IsNull() and quill_spray:GetLevel() > 0 then
			self:SetStackCount(self:GetStackCount() - dirty_brawler:GetSpecialValueFor("stack_decrease"))
			quill_spray:SpawnQuills(self.parent:GetAbsOrigin())
		end
	end
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))

	-- Custom Status Resist nonsense (need to learn how to make an all-encompassing function for this...)
	self:SetDuration(self.goo_duration * (1 - self.parent:GetStatusResistance()), true)
end

--------------------------------------------------------------------------------

function modifier_bristleback_viscous_nasal_goo_pf:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

--------------------------------------------------------------------------------

function modifier_bristleback_viscous_nasal_goo_pf:GetModifierMoveSpeedBonus_Percentage()
	return ((self.base_move_slow + (self.move_slow_per_stack * self:GetStackCount())) * (-1))
end

--------------------------------------------------------------------------------

function modifier_bristleback_viscous_nasal_goo_pf:GetModifierPhysicalArmorBonus()
	return ((self.base_armor + (self.armor_per_stack * self:GetStackCount())) * (-1))
end