medusa_stone_gaze_crit = class( {} )

LinkLuaModifier( "modifier_medusa_stone_gaze_crit", "heroes/medusa/medusa_stone_gaze_crit", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function medusa_stone_gaze_crit:GetIntrinsicModifierName()
	return "modifier_medusa_stone_gaze_crit"
end

modifier_medusa_stone_gaze_crit = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_stone_gaze_crit:IsHidden()
	return true
end

function modifier_medusa_stone_gaze_crit:IsPurgeException()
	return false
end

function modifier_medusa_stone_gaze_crit:IsPurgable()
	return false
end

function modifier_medusa_stone_gaze_crit:IsPermanent()
	return true
end



function modifier_medusa_stone_gaze_crit:OnCreated(kv)
    if IsServer() then
        
        self.cancritical = false
   
    end
end
function modifier_medusa_stone_gaze_crit:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end


function modifier_medusa_stone_gaze_crit:OnAttackStart(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    if params.target:HasModifier("modifier_medusa_stone_gaze_stone") then
        self.cancritical = true
    end
    
       
end

function modifier_medusa_stone_gaze_crit:GetModifierPreAttack_CriticalStrike( params )
    if self.cancritical then
        return 300
    end   
end

