witch_doctor_paralyzing_cask_applies_maledict = class( {} )

LinkLuaModifier( "modifier_witch_doctor_paralyzing_cask_applies_maledict", "heroes/witch_doctor/witch_doctor_paralyzing_cask_applies_maledict", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function witch_doctor_paralyzing_cask_applies_maledict:GetIntrinsicModifierName()
	return "modifier_witch_doctor_paralyzing_cask_applies_maledict"
end


modifier_witch_doctor_paralyzing_cask_applies_maledict = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_paralyzing_cask_applies_maledict:IsHidden()
	return true
end

function modifier_witch_doctor_paralyzing_cask_applies_maledict:IsPurgeException()
	return false
end

function modifier_witch_doctor_paralyzing_cask_applies_maledict:IsPurgable()
	return false
end

function modifier_witch_doctor_paralyzing_cask_applies_maledict:IsPermanent()
	return true
end


function modifier_witch_doctor_paralyzing_cask_applies_maledict:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_witch_doctor_paralyzing_cask_applies_maledict:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
	}

	return funcs
end



function  modifier_witch_doctor_paralyzing_cask_applies_maledict:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "witch_doctor_paralyzing_cask" then
        self.witch_doctor_maledict = self:GetParent():FindAbilityByName("witch_doctor_maledict")
        local duration = 12
        if self.witch_doctor_maledict and self.witch_doctor_maledict:GetLevel()>0 then
            if params.unit then
               if not params.unit:HasModifier("modifier_maledict") then
                params.unit:AddNewModifier(self:GetParent(), self.witch_doctor_maledict, "modifier_maledict", {duration = duration})
               end
            end
        end
    end

end