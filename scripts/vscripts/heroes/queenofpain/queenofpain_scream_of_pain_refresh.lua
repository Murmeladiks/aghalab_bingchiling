queenofpain_scream_of_pain_refresh = class( {} )

LinkLuaModifier( "modifier_queenofpain_scream_of_pain_refresh", "heroes/queenofpain/queenofpain_scream_of_pain_refresh", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function queenofpain_scream_of_pain_refresh:GetIntrinsicModifierName()
	return "modifier_queenofpain_scream_of_pain_refresh"
end

modifier_queenofpain_scream_of_pain_refresh = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_scream_of_pain_refresh:IsHidden()
	return true
end

function modifier_queenofpain_scream_of_pain_refresh:IsPurgeException()
	return false
end

function modifier_queenofpain_scream_of_pain_refresh:IsPurgable()
	return false
end

function modifier_queenofpain_scream_of_pain_refresh:IsPermanent()
	return true
end



function modifier_queenofpain_scream_of_pain_refresh:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_queenofpain_scream_of_pain_refresh:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_queenofpain_scream_of_pain_refresh:OnDeath(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self:GetParent() then
        return
    end
     
    if params.inflictor and params.inflictor:GetAbilityName() == "queenofpain_scream_of_pain" then
       
        self.queenofpain_blink = params.attacker:FindAbilityByName("queenofpain_blink")
       
        self.queenofpain_blink:EndCooldown()
    
        
     end
    
end
 
   
    



