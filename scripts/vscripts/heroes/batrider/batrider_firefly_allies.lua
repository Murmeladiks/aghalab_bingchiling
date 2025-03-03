batrider_firefly_allies = class( {} )

LinkLuaModifier( "modifier_batrider_firefly_allies", "heroes/batrider/batrider_firefly_allies", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function batrider_firefly_allies:GetIntrinsicModifierName()
	return "modifier_batrider_firefly_allies"
end


modifier_batrider_firefly_allies = class({})
function modifier_batrider_firefly_allies:IsPurgable()	return false end
function modifier_batrider_firefly_allies:IsPermanent()	return true end
function modifier_batrider_firefly_allies:IsHidden()   return true end

function modifier_batrider_firefly_allies:OnCreated(kv)
  
end

function modifier_batrider_firefly_allies:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_batrider_firefly_allies:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "batrider_firefly" then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("batrider_firefly")
    local duration = self.ability:GetSpecialValueFor("duration")
   
    local Range = 600
    local point = self:GetParent():GetAbsOrigin()
    local heroes = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),	-- int, your team number
        point,	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )
   
    --allies
    for _, hero in pairs(heroes) do
        if hero and not hero:IsNull() and not hero:IsInvulnerable() and hero ~= self:GetParent()  then
            if not hero:HasModifier("modifier_batrider_firefly") then
                hero:AddNewModifier(self:GetParent(),self.ability,"modifier_batrider_firefly",{duration = duration}) 
            else
                local buff =  hero:FindModifierByName("modifier_batrider_firefly")
                if buff then
                    buff:ForceRefresh()
                end
            end 
        end
    end
        
        
   
        
end

