modifier_item_arcanist_potion = class({})

--------------------------------------------------------------------------------

function modifier_item_arcanist_potion:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_item_arcanist_potion:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_arcanist_potion:OnCreated( kv )
	
	self.cooldown_reduction_pct = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_pct" )
	self.mana_cost_reduction_pct = self:GetAbility():GetSpecialValueFor( "mana_cost_reduction_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_arcanist_potion:DeclareFunctions()
	local funcs =
	{
		
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_UNIT_STATS_NEEDS_REFRESH,
		
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_arcanist_potion:GetModifierPercentageCooldown( params )
	return self.cooldown_reduction_pct
end

--------------------------------------------------------------------------------

function modifier_item_arcanist_potion:GetModifierPercentageManacost( params )
	return self.mana_cost_reduction_pct
end

--------------------------------------------------------------------------------

function modifier_item_arcanist_potion:GetModifierUnitStatsNeedsRefresh( params )
	return 1
end

--------------------------------------------------------------------------------



