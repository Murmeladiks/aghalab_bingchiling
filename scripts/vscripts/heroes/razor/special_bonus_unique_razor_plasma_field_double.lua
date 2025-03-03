special_bonus_unique_razor_plasma_field_double = class( {} )

LinkLuaModifier( "modifier_special_bonus_unique_razor_plasma_field_double", "heroes/razor/special_bonus_unique_razor_plasma_field_double", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function special_bonus_unique_razor_plasma_field_double:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_razor_plasma_field_double"
end

modifier_special_bonus_unique_razor_plasma_field_double = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_special_bonus_unique_razor_plasma_field_double:IsHidden()
	return true
end

function modifier_special_bonus_unique_razor_plasma_field_double:IsPurgeException()
	return false
end

function modifier_special_bonus_unique_razor_plasma_field_double:IsPurgable()
	return false
end

function modifier_special_bonus_unique_razor_plasma_field_double:IsPermanent()
	return true
end


function modifier_special_bonus_unique_razor_plasma_field_double:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_special_bonus_unique_razor_plasma_field_double:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_special_bonus_unique_razor_plasma_field_double:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "razor_plasma_field" then
        return
    end
     
    
	Timers:CreateTimer(0.4, function()
        if(self and not self:IsNull()) then
           
            params.ability:OnSpellStart()
           
        end
    end)
    
   
    
		
	

    

end