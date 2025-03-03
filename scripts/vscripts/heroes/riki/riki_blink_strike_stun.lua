riki_blink_strike_stun= class( {} )

LinkLuaModifier( "modifier_riki_blink_strike_stun", "heroes/riki/riki_blink_strike_stun", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function riki_blink_strike_stun:GetIntrinsicModifierName()
	return "modifier_riki_blink_strike_stun"
end

modifier_riki_blink_strike_stun= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_blink_strike_stun:IsHidden()
	return true
end

function modifier_riki_blink_strike_stun:IsPurgeException()
	return false
end

function modifier_riki_blink_strike_stun:IsPurgable()
	return false
end

function modifier_riki_blink_strike_stun:IsPermanent()
	return true
end



function modifier_riki_blink_strike_stun:OnCreated(kv)
    if IsServer() then
		
    end
end

function modifier_riki_blink_strike_stun:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_riki_blink_strike_stun:OnTakeDamage(params)

	if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end  
    if params.inflictor and params.inflictor:GetAbilityName() == "riki_blink_strike" then
		local duration = params.inflictor:GetSpecialValueFor("slow")*2
	
		
		if params.unit and not params.unit:IsNull() and params.unit:IsAlive() and not params.unit:IsInvulnerable() then
			
			params.unit:AddNewModifier(params.attacker, params.inflictor, "modifier_stunned", {duration = duration})
		end
		
    end
end

