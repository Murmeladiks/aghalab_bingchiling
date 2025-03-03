aghsfort_juggernaut_blade_dance = class({})
LinkLuaModifier( "modifier_aghsfort_juggernaut_blade_dance", "heroes/juggernaut/modifier_aghsfort_juggernaut_blade_dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_juggernaut_blade_dance_speedup_attackspeed", "heroes/juggernaut/modifier_juggernaut_blade_dance_speedup_attackspeed", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Passive Modifier
function aghsfort_juggernaut_blade_dance:GetIntrinsicModifierName()
	return "modifier_aghsfort_juggernaut_blade_dance"
end
function aghsfort_juggernaut_blade_dance:GetBehavior()
	if self:GetCaster():FindAbilityByName("aghsfort_special_juggernaut_blade_dance_teleport") ~= nil then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
	end

	return self.BaseClass.GetBehavior(self)
end
function aghsfort_juggernaut_blade_dance:OnAbilityPhaseStart()
	local sound_cast = "DOTA_Item.BlinkDagger.Activate"
	EmitSoundOn( sound_cast, self:GetCaster() )

	return true
end



--------------------------------------------------------------------------------
function aghsfort_juggernaut_blade_dance:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetOrigin()
    local vPoint = self:GetCursorPosition()
	
    caster:SetAbsOrigin(vPoint)
    FindClearSpaceForUnit(caster, vPoint, false) 
    
    caster:AddNewModifier(caster, nil, "modifier_juggernaut_blade_dance_speedup_attackspeed", {duration =2 })

end