queenofpain_blink_attackspeed = class( {} )

LinkLuaModifier( "modifier_queenofpain_blink_attackspeed", "heroes/queenofpain/queenofpain_blink_attackspeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_queenofpain_blink_attackspeed_buff", "heroes/queenofpain/queenofpain_blink_attackspeed", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function queenofpain_blink_attackspeed:GetIntrinsicModifierName()
	return "modifier_queenofpain_blink_attackspeed"
end

modifier_queenofpain_blink_attackspeed = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_blink_attackspeed:IsHidden()
	return true
end

function modifier_queenofpain_blink_attackspeed:IsPurgeException()
	return false
end

function modifier_queenofpain_blink_attackspeed:IsPurgable()
	return false
end

function modifier_queenofpain_blink_attackspeed:IsPermanent()
	return true
end



function modifier_queenofpain_blink_attackspeed:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_queenofpain_blink_attackspeed:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
    }
end

   
    

function modifier_queenofpain_blink_attackspeed:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "queenofpain_blink" then
        return
    end
    
       
    params.unit:AddNewModifier(params.unit,self:GetAbility(),"modifier_queenofpain_blink_attackspeed_buff",{duration = 4})

        
end

modifier_queenofpain_blink_attackspeed_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_blink_attackspeed_buff:IsHidden()
	return true
end

function modifier_queenofpain_blink_attackspeed_buff:IsPurgeException()
	return false
end

function modifier_queenofpain_blink_attackspeed_buff:IsPurgable()
	return false
end

function modifier_queenofpain_blink_attackspeed_buff:IsPermanent()
	return false
end
function modifier_queenofpain_blink_attackspeed_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
       
    }
end
function modifier_queenofpain_blink_attackspeed_buff:GetModifierAttackSpeedBonus_Constant()
    return 60
end