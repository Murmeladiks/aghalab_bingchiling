LinkLuaModifier("modifier_kobold_heal", "modifiers/modifier_kobold_heal", LUA_MODIFIER_MOTION_NONE)


kobold_heal = class({})

function kobold_heal:GetIntrinsicModifierName()
	return "modifier_kobold_heal"
end
