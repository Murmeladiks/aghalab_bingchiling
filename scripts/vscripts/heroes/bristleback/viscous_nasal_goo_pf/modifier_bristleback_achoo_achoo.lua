modifier_bristleback_achoo_achoo = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_achoo_achoo:IsHidden()
	return not self:GetParent():FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_achoo_achoo")
end

--------------------------------------------------------------------------------

function modifier_bristleback_achoo_achoo:IsPurgable() 		return false end
function modifier_bristleback_achoo_achoo:IsPermanent() 	return true end
function modifier_bristleback_achoo_achoo:RemoveOnDeath() 	return false end

--------------------------------------------------------------------------------

function modifier_bristleback_achoo_achoo:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(1)
end

--------------------------------------------------------------------------------

function modifier_bristleback_achoo_achoo:OnIntervalThink()
	local nasal_goo_spell = self:GetParent():FindAbilityByName("bristleback_viscous_nasal_goo_pf")
	if not nasal_goo_spell or not nasal_goo_spell:IsTrained() then return end

	local stack_limit = self:GetAbility():GetSpecialValueFor("stack_limit")
	if self:GetStackCount() < stack_limit then self:IncrementStackCount() end

	local achoo_achoo = self:GetParent():FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_achoo_achoo")
	self:StartIntervalThink((achoo_achoo and achoo_achoo:IsTrained()) and achoo_achoo:GetSpecialValueFor("achoo_achoo_stack_interval") or 1)
end

--------------------------------------------------------------------------------

modifier_bristleback_achoo_achoo_effect = class({})

--------------------------------------------------------------------------------

--function modifier_bristleback_achoo_achoo_effect:IsHidden() 		return true end
function modifier_bristleback_achoo_achoo_effect:IsPurgable() 		return false end
function modifier_bristleback_achoo_achoo_effect:RemoveOnDeath() 	return true end

--------------------------------------------------------------------------------

function modifier_bristleback_achoo_achoo_effect:OnCreated()
	if IsClient() then return end
	local achoo_achoo_shard = self:GetParent():FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_achoo_achoo")
	if not achoo_achoo_shard or not achoo_achoo_shard:IsTrained() then return end

	self:StartIntervalThink(achoo_achoo_shard:GetSpecialValueFor("delay"))
end

--------------------------------------------------------------------------------

function modifier_bristleback_achoo_achoo_effect:OnIntervalThink()
	local parent = self:GetParent()
	local casted = false

	local units = FindUnitsInRadius(
		parent:GetTeamNumber(),
		parent:GetAbsOrigin(),
		nil,
		self:GetAbility():GetEffectiveCastRange(parent:GetAbsOrigin(), parent),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	if #units > 0 then
		self:GetAbility():ViscousNasalGoo(units[1])
		casted = true
	end

	self:DecrementStackCount()
	if not casted or self:GetStackCount() <= 0 then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end