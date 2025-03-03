aghsfort_phantom_assassin_blur_strike = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_blur_strike", "heroes/phantom_assassin/aghsfort_phantom_assassin_blur_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_phantom_assassin_blur_regeneration_heal", "heroes/phantom_assassin/aghsfort_phantom_assassin_blur_regeneration", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_blur_strike:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_blur_strike"
end


modifier_aghsfort_phantom_assassin_blur_strike = class({})
function modifier_aghsfort_phantom_assassin_blur_strike:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_blur_strike:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_blur_strike:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_blur_strike:OnCreated(kv)
  
end

function modifier_aghsfort_phantom_assassin_blur_strike:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_aghsfort_phantom_assassin_blur_strike:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "phantom_assassin_blur" then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_blur")
    local duration = self.ability:GetSpecialValueFor("duration")
    local Range = 600
    local heroes = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),	-- int, your team number
        self:GetParent():GetAbsOrigin(),	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )
    
        
            for _, hero in pairs(heroes) do
                if hero and not hero:IsNull() and not hero:IsInvulnerable()  then
                   hero:AddNewModifier(self:GetParent(),self.ability,"modifier_phantom_assassin_blur_active",{duration = duration})
                   if self:GetParent():FindAbilityByName("aghsfort_phantom_assassin_blur_regeneration") ~= nil then
                    hero:AddNewModifier(self:GetParent(),self.ability,"modifier_aghsfort_phantom_assassin_blur_regeneration_heal",{duration = 10})
                   end
                end
            end
        
        
   
        
end




