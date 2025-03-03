
modifier_ascension_chilling_touch_debuff = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_chilling_touch_debuff:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ascension_chilling_touch_debuff:IsPurgable()
	return true
end

function modifier_ascension_chilling_touch_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

----------------------------------------

function modifier_ascension_chilling_touch_debuff:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_chilling_touch_debuff:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
end

--------------------------------------------------------------------------------

function modifier_ascension_chilling_touch_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_chilling_touch_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.slow
end