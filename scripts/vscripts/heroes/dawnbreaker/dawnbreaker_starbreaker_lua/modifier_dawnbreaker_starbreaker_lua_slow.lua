-- Created by Elfansoer
modifier_dawnbreaker_starbreaker_lua_slow = class({})

function modifier_dawnbreaker_starbreaker_lua_slow:IsHidden() 	return true end
function modifier_dawnbreaker_starbreaker_lua_slow:IsDebuff() 	return true end
function modifier_dawnbreaker_starbreaker_lua_slow:IsPurgable() return true end

function modifier_dawnbreaker_starbreaker_lua_slow:OnCreated( kv )
	-- references
	self.slow = self:GetAbility():GetSpecialValueFor( "swipe_slow" )

	if not IsServer() then return end
	-- send init data from server to client
	self:SetHasCustomTransmitterData( true )
end

function modifier_dawnbreaker_starbreaker_lua_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_dawnbreaker_starbreaker_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end
