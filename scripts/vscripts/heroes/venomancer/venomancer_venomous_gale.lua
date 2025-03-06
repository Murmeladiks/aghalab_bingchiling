LinkLuaModifier( "modifier_venomancer_venomous_gale", "heroes/venomancer/venomancer_venomous_gale.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if venomancer_venomous_gale == nil then
	venomancer_venomous_gale = class({})
end
function venomancer_venomous_gale:GetIntrinsicModifierName()
	return "modifier_venomancer_venomous_gale"
end
---------------------------------------------------------------------
--Modifiers
if modifier_venomancer_venomous_gale == nil then
	modifier_venomancer_venomous_gale = class({})
end
function modifier_venomancer_venomous_gale:OnCreated(params)
	if IsServer() then
	end
end
function modifier_venomancer_venomous_gale:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_venomancer_venomous_gale:OnDestroy()
	if IsServer() then
	end
end
function modifier_venomancer_venomous_gale:DeclareFunctions()
	return {
	}
end