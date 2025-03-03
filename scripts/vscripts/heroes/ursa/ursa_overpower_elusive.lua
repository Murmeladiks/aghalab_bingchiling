ursa_overpower_elusive = class( {} )

LinkLuaModifier( "modifier_ursa_overpower_elusive", "heroes/ursa/ursa_overpower_elusive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ursa_overpower_elusive_buff", "heroes/ursa/ursa_overpower_elusive", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ursa_overpower_elusive:GetIntrinsicModifierName()
	return "modifier_ursa_overpower_elusive"
end

modifier_ursa_overpower_elusive = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_overpower_elusive:IsHidden()
	return true
end

function modifier_ursa_overpower_elusive:IsPurgeException()
	return false
end

function modifier_ursa_overpower_elusive:IsPurgable()
	return false
end

function modifier_ursa_overpower_elusive:IsPermanent()
	return true
end


function modifier_ursa_overpower_elusive:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_ursa_overpower_elusive:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_ursa_overpower_elusive:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "ursa_overpower" then
        self:GetParent():AddNewModifier(self:GetParent(),params.ability,"modifier_ursa_overpower_elusive_buff",{duration = 3.5})
    end
     

end
modifier_ursa_overpower_elusive_buff = class({})

function modifier_ursa_overpower_elusive_buff:IsHidden()
	return true
end

function modifier_ursa_overpower_elusive_buff:IsPurgeException()
	return false
end

function modifier_ursa_overpower_elusive_buff:IsPurgable()
	return false
end

function modifier_ursa_overpower_elusive_buff:IsPermanent()
	return false
end

function modifier_ursa_overpower_elusive_buff:OnCreated(kv)
    

    if IsServer() then
        self.evasion =30
        self:SetHasCustomTransmitterData(true)
    end

  
end


function modifier_ursa_overpower_elusive_buff:AddCustomTransmitterData()
    return {
       
		
		evasion=self.evasion,
		
    }
end
function modifier_ursa_overpower_elusive_buff:HandleCustomTransmitterData( data )
    
	  self.evasion = data.evasion
	
end
function modifier_ursa_overpower_elusive_buff:DeclareFunctions()
	return {     
        MODIFIER_PROPERTY_EVASION_CONSTANT,
    }

end
function modifier_ursa_overpower_elusive_buff:GetModifierEvasion_Constant(params)
    return self.evasion
end
