modifier_bristleback_shock_and_awe_slow = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe_slow:GetTexture()
	return "bristleback_warpath"
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe_slow:OnCreated()
	local shock_and_awe = self:GetCaster():FindAbilityByName("pathfinder_bristleback_warpath_shock_and_awe")
	if not shock_and_awe or shock_and_awe:IsNull() or shock_and_awe:GetLevel() == 0 then return end

	self.movespeed_debuff = shock_and_awe:GetSpecialValueFor("slow_effect")
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_bristleback_shock_and_awe_slow:GetModifierMoveSpeedBonus_Percentage()
	return (self.movespeed_debuff or 0) * (-1)
end