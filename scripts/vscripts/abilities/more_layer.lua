more_layer = class( {} )

LinkLuaModifier( "modifier_more_layer", "abilities/more_layer", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function more_layer:GetIntrinsicModifierName()
	return "modifier_more_layer"
end


modifier_more_layer = class({})
function modifier_more_layer:IsPurgable()	return false end
function modifier_more_layer:IsPermanent()	return true end
function modifier_more_layer:IsHidden()   return true end


function modifier_more_layer:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
    }
end

function modifier_more_layer:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_more_layer:OnCreated(table)
    local caster = self:GetCaster()
	self.maxlayer = self:GetAbility():GetSpecialValueFor( "value" )
   
    print(self.maxlayer)
    self:updateData(kv)
   	
    self:SetHasCustomTransmitterData(true)
       
end
function modifier_more_layer:OnRefresh( kv )
	self:updateData(kv)
end
function modifier_more_layer:updateData(kv)
    local caster = self:GetCaster()
	self.maxlayer = self:GetAbility():GetSpecialValueFor( "value" )
   
    print(self.maxlayer)
    self:SetHasCustomTransmitterData(true)
end

function modifier_more_layer:AddCustomTransmitterData()
    return {
        layer = self.maxlayer,
    }
end
function modifier_more_layer:HandleCustomTransmitterData( data )
    self.maxlayer = data.layer
end
function modifier_more_layer:GetModifierOverrideAbilitySpecial( params )
    if self:GetParent() == nil or params.ability == nil then
        return 0
    end

    local szAbilityName = params.ability:GetAbilityName()



    if szAbilityName == "shadow_demon_shadow_poison" then
        return 1
    end

    return 0
end

function modifier_more_layer:GetModifierOverrideAbilitySpecialValue( params )
    local szSpecialValueName = params.ability_special_value
    local level = params.ability_special_level

    if szSpecialValueName == "max_multiply_stacks" and self.maxlayer then
        return self.maxlayer
    end
  


    return params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, level )
end

