modifier_werewolf_howl_aura = class({})

----------------------------------------

function modifier_werewolf_howl_aura:IsAura()
	return true
end

----------------------------------------

function modifier_werewolf_howl_aura:GetModifierAura()
	return  "modifier_werewolf_howl_aura_effect"
end

----------------------------------------

function modifier_werewolf_howl_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

----------------------------------------

function modifier_werewolf_howl_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

----------------------------------------

function modifier_werewolf_howl_aura:GetAuraRadius()
	return self.radius
end

----------------------------------------

function modifier_werewolf_howl_aura:OnCreated( kv )
	if self:GetAbility() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	else
		self.radius = 0
	end
end

----------------------------------------
