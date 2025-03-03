batrider_firefly_enemies = class( {} )

LinkLuaModifier( "modifier_batrider_firefly_enemies", "heroes/batrider/batrider_firefly_enemies", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function batrider_firefly_enemies:GetIntrinsicModifierName()
	return "modifier_batrider_firefly_enemies"
end


modifier_batrider_firefly_enemies = class({})
function modifier_batrider_firefly_enemies:IsPurgable()	return false end
function modifier_batrider_firefly_enemies:IsPermanent()	return true end
function modifier_batrider_firefly_enemies:IsHidden()   return true end

function modifier_batrider_firefly_enemies:OnCreated(kv)
  
end

function modifier_batrider_firefly_enemies:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_batrider_firefly_enemies:OnAbilityFullyCast(params)
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
   
    local Range = 300
    local point = self:GetParent():GetAbsOrigin()
    local enemies = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),	-- int, your team number
        point,	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )
   
    --allies
    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and not enemy:IsInvulnerable()  then
            if not enemy:HasModifier("modifier_batrider_firefly") then
                enemy:AddNewModifier(self:GetParent(),self.ability,"modifier_batrider_firefly",{duration = duration}) 
            else
                local buff =  enemy:FindModifierByName("modifier_batrider_firefly")
                if buff then
                    buff:ForceRefresh()
                end
            end 
        end
    end
        
        
   
        
end

