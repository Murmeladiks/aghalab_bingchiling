modifier_axe_berserkers_call_lua = class({})


function modifier_axe_berserkers_call_lua:IsHidden() 	return false end
function modifier_axe_berserkers_call_lua:IsDebuff() 	return false end
function modifier_axe_berserkers_call_lua:IsPurgable() 	return true end


function modifier_axe_berserkers_call_lua:OnCreated( kv )
	self.ability = self:GetAbility()
	self.armor = -1 * self.ability:GetSpecialValueFor("bonus_armor")
end

function modifier_axe_berserkers_call_lua:OnRefresh( kv )
	self.armor = -1 * self.ability:GetSpecialValueFor("bonus_armor")
end

function modifier_axe_berserkers_call_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_axe_berserkers_call_lua:GetModifierIncomingDamage_Percentage()
	return self.armor
end

function modifier_axe_berserkers_call_lua:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
end

function modifier_axe_berserkers_call_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
