LinkLuaModifier( "modifier_phoenix_sun_ray_pf", "heroes/phoenix/phoenix_sun_ray_pf.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if phoenix_sun_ray_pf == nil then
	phoenix_sun_ray_pf = class({})
end
function phoenix_sun_ray_pf:GetIntrinsicModifierName()
	return "modifier_phoenix_sun_ray_pf"
end
---------------------------------------------------------------------
--Modifiers
if modifier_phoenix_sun_ray_pf == nil then
	modifier_phoenix_sun_ray_pf = class({})
end
function modifier_phoenix_sun_ray_pf:OnCreated(params)
	if IsServer() then
	end
end
function modifier_phoenix_sun_ray_pf:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_phoenix_sun_ray_pf:OnDestroy()
	if IsServer() then
	end
end
function modifier_phoenix_sun_ray_pf:DeclareFunctions()
	return {
	}
end