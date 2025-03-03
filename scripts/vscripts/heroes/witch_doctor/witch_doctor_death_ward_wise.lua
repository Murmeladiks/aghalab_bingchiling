witch_doctor_death_ward_wise = class( {} )

LinkLuaModifier( "modifier_witch_doctor_death_ward_wise", "heroes/witch_doctor/witch_doctor_death_ward_wise", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_witch_doctor_death_ward_wise_buff", "heroes/witch_doctor/witch_doctor_death_ward_wise", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function witch_doctor_death_ward_wise:GetIntrinsicModifierName()
	return "modifier_witch_doctor_death_ward_wise"
end


modifier_witch_doctor_death_ward_wise = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_death_ward_wise:IsHidden()
	return true
end

function modifier_witch_doctor_death_ward_wise:IsPurgeException()
	return false
end

function modifier_witch_doctor_death_ward_wise:IsPurgable()
	return false
end

function modifier_witch_doctor_death_ward_wise:IsPermanent()
	return true
end



function modifier_witch_doctor_death_ward_wise:OnCreated(kv)
    if IsServer() then
       
    end
end



function modifier_witch_doctor_death_ward_wise:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
    }
end
function modifier_witch_doctor_death_ward_wise:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "witch_doctor_death_ward" then
        self.witch_doctor_death_ward = self:GetParent():FindAbilityByName("witch_doctor_death_ward")
        local duration = self.witch_doctor_death_ward:GetChannelTime()
        if not self:GetParent():HasModifier("modifier_witch_doctor_death_ward_wise_buff") then
            self:GetParent():AddNewModifier(self:GetParent(), self.witch_doctor_death_ward, "modifier_witch_doctor_death_ward_wise_buff", {duration=duration})
        else 
            local buff = self:GetParent():FindModifierByName("modifier_witch_doctor_death_ward_wise_buff") 
            if buff then
                buff:ForceRefresh()
            end
        end
    end
end


modifier_witch_doctor_death_ward_wise_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_death_ward_wise_buff:IsHidden()
	return false
end



function modifier_witch_doctor_death_ward_wise_buff:IsPurgable()
	return false
end

function modifier_witch_doctor_death_ward_wise_buff:OnCreated( kv )
    if IsServer() then  
        self.damage_reduction = 80
    end
end
function modifier_witch_doctor_death_ward_wise_buff:DeclareFunctions()
    local funcs = 
    {  
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end
function modifier_witch_doctor_death_ward_wise_buff:GetModifierIncomingDamage_Percentage( params )
    return -self.damage_reduction
end
