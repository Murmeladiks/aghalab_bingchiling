riki_blink_strike_attackspeed = class( {} )

LinkLuaModifier( "modifier_riki_blink_strike_attackspeed", "heroes/riki/riki_blink_strike_attackspeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_blink_strike_attackspeed_buff", "heroes/riki/riki_blink_strike_attackspeed", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function riki_blink_strike_attackspeed:GetIntrinsicModifierName()
	return "modifier_riki_blink_strike_attackspeed"
end

modifier_riki_blink_strike_attackspeed = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_blink_strike_attackspeed:IsHidden()
	return true
end

function modifier_riki_blink_strike_attackspeed:IsPurgeException()
	return false
end

function modifier_riki_blink_strike_attackspeed:IsPurgable()
	return false
end

function modifier_riki_blink_strike_attackspeed:IsPermanent()
	return true
end



function modifier_riki_blink_strike_attackspeed:OnCreated(kv)
    if IsServer() then
		
    end
end

function modifier_riki_blink_strike_attackspeed:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_riki_blink_strike_attackspeed:OnAbilityFullyCast(params)

	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    if not params.target then return end
	if params.ability:GetAbilityName() == "riki_blink_strike" then
		local duration = params.ability:GetSpecialValueFor("slow")*4
		params.unit:AddNewModifier(params.unit,params.ability,"modifier_riki_blink_strike_attackspeed_buff",{duration = duration})
		
    end
end


modifier_riki_blink_strike_attackspeed_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_blink_strike_attackspeed_buff:IsHidden()
	return true
end

function modifier_riki_blink_strike_attackspeed_buff:IsPurgeException()
	return false
end

function modifier_riki_blink_strike_attackspeed_buff:IsPurgable()
	return false
end

function modifier_riki_blink_strike_attackspeed_buff:IsPermanent()
	return false
end



function modifier_riki_blink_strike_attackspeed_buff:OnCreated(kv)
    if IsServer() then
		
    end
end
function modifier_riki_blink_strike_attackspeed_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
    }
end

function modifier_riki_blink_strike_attackspeed_buff:GetModifierAttackSpeedPercentage(kv)
    return 200
end
function modifier_riki_blink_strike_attackspeed_buff:GetModifierAttackSpeed_Limit(params)
	return 1
end