LinkLuaModifier("modifier_bristleback_warpath_pf", 			"heroes/bristleback/warpath_pf/modifier_bristleback_warpath_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_mega_wallop_stun", 	"heroes/bristleback/warpath_pf/modifier_bristleback_mega_wallop_stun", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

bristleback_warpath_pf = class({})

--------------------------------------------------------------------------------

function bristleback_warpath_pf:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_warpath_empower.vpcf", context)
end

--------------------------------------------------------------------------------

function bristleback_warpath_pf:GetIntrinsicModifierName()
	return "modifier_bristleback_warpath_pf"
end