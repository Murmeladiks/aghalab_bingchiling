modifier_axe_culling_blade_lua = class({})

function modifier_axe_culling_blade_lua:IsHidden() 		return false end
function modifier_axe_culling_blade_lua:IsDebuff() 		return false end
function modifier_axe_culling_blade_lua:IsPurgable() 	return true end

function modifier_axe_culling_blade_lua:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

function modifier_axe_culling_blade_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_axe_culling_blade_lua:OnCreated( kv )
	self.ability = self:GetAbility()

	self.as_bonus = self.ability:GetSpecialValueFor("atk_speed_bonus_tooltip")
	self.ms_bonus = self.ability:GetSpecialValueFor("speed_bonus")
end

function modifier_axe_culling_blade_lua:OnRefresh( kv )
	self:OnCreated()
end

function modifier_axe_culling_blade_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end

function modifier_axe_culling_blade_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_axe_culling_blade_lua:GetModifierAttackSpeedBonus_Constant()
	return self.as_bonus
end

function modifier_axe_culling_blade_lua:GetModifierIgnoreMovespeedLimit(params)
    return 1
end
