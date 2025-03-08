modifier_marci_grapple_pf_debuff = class({})

function modifier_marci_grapple_pf_debuff:OnCreated( kv )
	self.ms_slow = -self:GetAbility():GetSpecialValueFor("movement_slow_pct")
end

function modifier_marci_grapple_pf_debuff:OnRefresh(kv)
	self:OnCreated(kv)
end

function modifier_marci_grapple_pf_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_marci_grapple_pf_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_marci_grapple_pf_debuff:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_marci_grapple_pf_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_marci_grapple_pf_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end