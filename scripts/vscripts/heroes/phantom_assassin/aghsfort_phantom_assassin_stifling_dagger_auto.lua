aghsfort_phantom_assassin_stifling_dagger_auto = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_stifling_dagger_auto", "heroes/phantom_assassin/aghsfort_phantom_assassin_stifling_dagger_auto", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_stifling_dagger_auto:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_stifling_dagger_auto"
end


modifier_aghsfort_phantom_assassin_stifling_dagger_auto = class({})
function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:IsHidden()   return true end
function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:OnCreated(kv)
    if IsServer() then
        self.cooldown =  2.5


        self:SetHasCustomTransmitterData(true)

        self:StartIntervalThink(0.25)
    end
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:OnIntervalThink()
    if self:GetRemainingTime() > 0 then
        return
    else
        self:SetDuration(-1, true)
    end

    if not self:GetParent():IsAlive() or self:GetParent():PassivesDisabled() or self:GetParent():IsIllusion() then
        return
    end

    local dagger = self:GetParent():FindAbilityByName("aghsfort_phantom_assassin_stifling_dagger_lua")

    if not dagger or dagger:GetLevel() == 0 then
        return
    end

    local daggerRange = dagger:GetEffectiveCastRange(self:GetParent():GetAbsOrigin(), nil)
    
    local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),	-- int, your team number
        self:GetParent():GetAbsOrigin(),	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        daggerRange,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )

   
   
    
    local target = nil

    if enemies[#enemies] and not enemies[#enemies]:IsNull() and not enemies[#enemies]:IsInvulnerable() then
        target = enemies[#enemies]
    end
    if target then
        self:GetParent():SetCursorCastTarget(target)
        dagger:OnSpellStart()

        self:SetDuration(self.cooldown, true)
    end
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:AddCustomTransmitterData()
    return {
        cooldown = self.cooldown,
    }
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:HandleCustomTransmitterData( data )
    self.cooldown = data.cooldown
end

function modifier_aghsfort_phantom_assassin_stifling_dagger_auto:OnTooltip()
    return self.cooldown
end