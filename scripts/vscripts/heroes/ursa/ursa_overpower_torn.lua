ursa_overpower_torn = class( {} )

LinkLuaModifier( "modifier_ursa_overpower_torn", "heroes/ursa/ursa_overpower_torn", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ursa_overpower_torn:GetIntrinsicModifierName()
	return "modifier_ursa_overpower_torn"
end

modifier_ursa_overpower_torn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_overpower_torn:IsHidden()
	return true
end

function modifier_ursa_overpower_torn:IsPurgeException()
	return false
end

function modifier_ursa_overpower_torn:IsPurgable()
	return false
end

function modifier_ursa_overpower_torn:IsPermanent()
	return true
end



function modifier_ursa_overpower_torn:OnCreated(kv)
    if IsServer() then
        
        self.cancritical = false
   
    end
end
function modifier_ursa_overpower_torn:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end


function modifier_ursa_overpower_torn:OnAttackStart(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    if self:GetParent():HasModifier("modifier_ursa_overpower") then
        self.cancritical = true
    end
    
       
end

function modifier_ursa_overpower_torn:GetModifierPreAttack_CriticalStrike( params )
    if self.cancritical then
        return 130
    end   
end

