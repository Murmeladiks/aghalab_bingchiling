witch_doctor_maledict_mumbo = class( {} )

LinkLuaModifier( "modifier_witch_doctor_maledict_mumbo", "heroes/witch_doctor/witch_doctor_maledict_mumbo", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function witch_doctor_maledict_mumbo:GetIntrinsicModifierName()
	return "modifier_witch_doctor_maledict_mumbo"
end


modifier_witch_doctor_maledict_mumbo = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_maledict_mumbo:IsHidden()
	return true
end

function modifier_witch_doctor_maledict_mumbo:IsPurgeException()
	return false
end

function modifier_witch_doctor_maledict_mumbo:IsPurgable()
	return false
end

function modifier_witch_doctor_maledict_mumbo:IsPermanent()
	return true
end


function modifier_witch_doctor_maledict_mumbo:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_witch_doctor_maledict_mumbo:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
	}

	return funcs
end



function  modifier_witch_doctor_maledict_mumbo:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "witch_doctor_maledict" then
       local heal = params.damage*65/100
       self:GetParent():Heal( heal, nil )
    end

end