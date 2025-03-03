LinkLuaModifier("modifier_aghsfort_special_juggernaut_blade_dance_teleport", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_teleport", LUA_MODIFIER_MOTION_NONE)

aghsfort_special_juggernaut_blade_dance_teleport = class({})

function aghsfort_special_juggernaut_blade_dance_teleport:Spawn()
	  if IsClient() then return end
	
	  Timers:CreateTimer(0.07, function()
          local blade_dance = self:GetCaster():FindAbilityByName("aghsfort_juggernaut_blade_dance")
          blade_dance:RefreshCharges()
          blade_dance:EndCooldown()
      end)

   
end
function aghsfort_special_juggernaut_blade_dance_teleport:GetIntrinsicModifierName()
	
	return "modifier_aghsfort_special_juggernaut_blade_dance_teleport"
   
end

modifier_aghsfort_special_juggernaut_blade_dance_teleport = class({})

--------------------------------------------------------------------------------

function modifier_aghsfort_special_juggernaut_blade_dance_teleport:IsPurgable()	return false end
function modifier_aghsfort_special_juggernaut_blade_dance_teleport:IsPermanent()	return true end
function modifier_aghsfort_special_juggernaut_blade_dance_teleport:IsHidden()   return true end

function modifier_aghsfort_special_juggernaut_blade_dance_teleport:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
    }
end
function modifier_aghsfort_special_juggernaut_blade_dance_teleport:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_aghsfort_special_juggernaut_blade_dance_teleport:OnCreated(table)
    self.value = 2
   

   
end

function modifier_aghsfort_special_juggernaut_blade_dance_teleport:GetModifierOverrideAbilitySpecial( params )
    if self:GetParent() == nil or params.ability == nil then
        return 0
    end

    local szAbilityName = params.ability:GetAbilityName()



    if szAbilityName == "aghsfort_juggernaut_blade_dance" then
        return 1
    end

    return 0
end

function modifier_aghsfort_special_juggernaut_blade_dance_teleport:GetModifierOverrideAbilitySpecialValue( params )
    local szSpecialValueName = params.ability_special_value
    local level = params.ability_special_level

    if szSpecialValueName == "AbilityCharges" and self.value then
        return self.value
    end
    if szSpecialValueName == "AbilityCooldown" then
        return 0.1
    end

    return params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, level )
end

