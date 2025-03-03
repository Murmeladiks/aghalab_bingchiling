gyrocopter_homing_missile_minimissiles = class( {} )

LinkLuaModifier( "modifier_gyrocopter_homing_missile_minimissiles", "heroes/gyrocopter/gyrocopter_homing_missile_minimissiles", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gyrocopter_homing_missile_minimissiles:GetIntrinsicModifierName()
	return "modifier_gyrocopter_homing_missile_minimissiles"
end


modifier_gyrocopter_homing_missile_minimissiles = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gyrocopter_homing_missile_minimissiles:IsHidden()
	return true
end

function modifier_gyrocopter_homing_missile_minimissiles:IsPurgeException()
	return false
end

function modifier_gyrocopter_homing_missile_minimissiles:IsPurgable()
	return false
end

function modifier_gyrocopter_homing_missile_minimissiles:IsPermanent()
	return true
end


function modifier_gyrocopter_homing_missile_minimissiles:OnCreated( kv )
	if IsServer() then
        self.count = 0
    end
end

function modifier_gyrocopter_homing_missile_minimissiles:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end



function  modifier_gyrocopter_homing_missile_minimissiles:OnAbilityExecuted(params)
    if IsServer() then
        if params.unit == self:GetParent() and params.ability:GetAbilityName() == "gyrocopter_homing_missile" then
            local target = params.target
            local ability = params.ability

            local castRange = 600

            local enemies = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),   -- int, your team number
                params.target:GetAbsOrigin(),    -- point, center point
                nil,    -- handle, cacheUnit. (not known)
                castRange + 50, -- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
                0,
                FIND_FARTHEST,  -- int, order filter
                false
            )

            local limit = 4
            local counter = 0
            if #enemies == 1 then
                for i = 1, limit, 1 do
                    self:GetParent():SetCursorCastTarget(target)
                    ability:OnSpellStart()
                end
            else
                for _, enemy in pairs(enemies) do
                    if counter >= limit then
                        break
                    end

                    if enemy and enemy:IsAlive() and not enemy:IsInvulnerable()  then
                        counter = counter + 1
                        self:GetParent():SetCursorCastTarget(enemy)
                        ability:OnSpellStart()
                    end
                end

                if counter < limit and target and target:IsAlive() then
                    local missingMissiles = limit - counter

                    for i = 1, missingMissiles, 1 do
                        self:GetParent():SetCursorCastTarget(target)
                        ability:OnSpellStart()
                    end
                end
            end
        end
    end

end