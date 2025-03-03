snapfire_firesnap_cookie_bakers_dozen = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_bakers_dozen", "heroes/snapfire/snapfire_firesnap_cookie_bakers_dozen", LUA_MODIFIER_MOTION_NONE )
function snapfire_firesnap_cookie_bakers_dozen:GetIntrinsicModifierName()
	return "modifier_snapfire_firesnap_cookie_bakers_dozen"
end

modifier_snapfire_firesnap_cookie_bakers_dozen = class({})

function modifier_snapfire_firesnap_cookie_bakers_dozen:IsHidden()
	return true
end

function modifier_snapfire_firesnap_cookie_bakers_dozen:IsPurgeException()
	return false
end

function modifier_snapfire_firesnap_cookie_bakers_dozen:IsPurgable()
	return false
end

function modifier_snapfire_firesnap_cookie_bakers_dozen:IsPermanent()
	return true
end



function modifier_snapfire_firesnap_cookie_bakers_dozen:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_snapfire_firesnap_cookie_bakers_dozen:OnCreated(kv)
    if IsServer() then
    end
end

function modifier_snapfire_firesnap_cookie_bakers_dozen:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    local unit = self:GetParent()

    self.snapfire_firesnap_cookie = unit:FindAbilityByName("snapfire_firesnap_cookie")
    
    if params.ability:GetAbilityName() == "snapfire_firesnap_cookie"  then
       local position = params.target:GetAbsOrigin()
        local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),   -- int, your team number
            position,   -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            300,   -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )

        -- damage enemies
        for _,enemy in pairs(enemies) do
            if enemy ~= params.target then
                if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
                    self:GetCaster():SetCursorCastTarget(enemy)
                    self.snapfire_firesnap_cookie:OnSpellStart()
                end
            end
        end
        local allies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),   -- int, your team number
            position,   -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            300,   -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
        for _,ally in pairs(allies) do
            if ally ~= params.target then
                if ally and not ally:IsNull() and ally:IsAlive() and not ally:IsInvulnerable() then
                    self:GetCaster():SetCursorCastTarget(ally)
                    self.snapfire_firesnap_cookie:OnSpellStart()
                end
            end
        end
       
    end

end