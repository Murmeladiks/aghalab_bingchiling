modifier_marci_companion_run_pf_buff = class({})

function modifier_marci_companion_run_pf_buff:IsHidden()
	return false
end

function modifier_marci_companion_run_pf_buff:IsDebuff()
	return false
end

function modifier_marci_companion_run_pf_buff:IsPurgable()
	return true
end

function modifier_marci_companion_run_pf_buff:OnCreated(kv)
	self.ms_bonus = self:GetAbility():GetSpecialValueFor("ally_movespeed_pct")

	if not IsServer() then return end

	EmitSoundOn("Hero_Marci.Rebound.Ally", self:GetParent())
end

function modifier_marci_companion_run_pf_buff:OnRefresh(kv)
	self:OnCreated(kv)
end


function modifier_marci_companion_run_pf_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_marci_companion_run_pf_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_marci_companion_run_pf_buff:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end

function modifier_marci_companion_run_pf_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end