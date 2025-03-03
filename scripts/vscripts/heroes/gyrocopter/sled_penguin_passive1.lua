sled_penguin_passive1 = class({})
LinkLuaModifier( "modifier_sled_penguin_passive1", "heroes/gyrocopter/modifier_sled_penguin_passive1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sled_penguin_movement1", "heroes/gyrocopter/modifier_sled_penguin_movement1", LUA_MODIFIER_MOTION_HORIZONTAL )

----------------------------------------------------------------------------------

function sled_penguin_passive1:GetIntrinsicModifierName()
	return "modifier_sled_penguin_passive1"
end
