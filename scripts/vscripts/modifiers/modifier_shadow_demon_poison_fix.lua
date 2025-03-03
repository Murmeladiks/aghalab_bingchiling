
modifier_shadow_demon_poison_fix = class({})

--------------------------------------------------------------------------------

function modifier_shadow_demon_poison_fix:IsPurgable()	return false end
function modifier_shadow_demon_poison_fix:IsPermanent()	return true end
function modifier_shadow_demon_poison_fix:IsHidden()   return true end

--------------------------------------------------------------------------------

function modifier_shadow_demon_poison_fix:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE

	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_shadow_demon_poison_fix:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_shadow_demon_poison_fix:OnCreated(kv)
	self.stack_damage = kv.stack_damage
    self:updateData(kv)
   	
    self:SetHasCustomTransmitterData(true)
       
end
function modifier_shadow_demon_poison_fix:OnRefresh( kv )
	self:updateData(kv)
end
function modifier_shadow_demon_poison_fix:updateData(kv)
	self.stack_damage = kv.stack_damage
 
    
end

function modifier_shadow_demon_poison_fix:AddCustomTransmitterData()
    return {
        stack_damage = self.stack_damage,
    }
end
function modifier_shadow_demon_poison_fix:HandleCustomTransmitterData( data )
    self.stack_damage = data.stack_damage
end
function modifier_shadow_demon_poison_fix:GetModifierOverrideAbilitySpecial( params )
    if self:GetParent() == nil or params.ability == nil then
        return 0
    end

    local szAbilityName = params.ability:GetAbilityName()



    if szAbilityName == "shadow_demon_shadow_poison" then
        return 1
    end

    return 0
end

function modifier_shadow_demon_poison_fix:GetModifierOverrideAbilitySpecialValue( params )
    local szSpecialValueName = params.ability_special_value
    local level = params.ability_special_level

    if szSpecialValueName == "stack_damage" and self.stack_damage then
        return self.stack_damage
    end



    return params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, level )
end

