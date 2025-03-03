medusa_mystic_snake_life_saving = class( {} )

LinkLuaModifier( "modifier_medusa_mystic_snake_life_saving", "heroes/medusa/medusa_mystic_snake_life_saving", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function medusa_mystic_snake_life_saving:Precache( context )	
	
end
function medusa_mystic_snake_life_saving:GetIntrinsicModifierName()
	return "modifier_medusa_mystic_snake_life_saving"
end


modifier_medusa_mystic_snake_life_saving = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_mystic_snake_life_saving:IsHidden()
	return false
end

function modifier_medusa_mystic_snake_life_saving:IsPurgeException()
	return false
end

function modifier_medusa_mystic_snake_life_saving:IsPurgable()
	return false
end

function modifier_medusa_mystic_snake_life_saving:IsPermanent()
	return true
end
function modifier_medusa_mystic_snake_life_saving:GetTexture()
    return "medusa_mystic_snake"
end

function modifier_medusa_mystic_snake_life_saving:OnCreated( kv )
	if IsServer() then
		self.canCastSnake = true

        self.coolDown =  10
        self.maxSnakes =  2

        self.manaThreshold = 30

        
        self:SetHasCustomTransmitterData(true)

        self:StartIntervalThink(0.25)
    end
end
function modifier_medusa_mystic_snake_life_saving:AddCustomTransmitterData()
    return {
        coolDown = self.coolDown,
        maxSnakes = self.maxSnakes,
    }
end

function modifier_medusa_mystic_snake_life_saving:HandleCustomTransmitterData( data )
    self.coolDown = data.coolDown
    self.maxSnakes = data.maxSnakes
end
function modifier_medusa_mystic_snake_life_saving:OnIntervalThink()
    if not IsServer() then
        return
    end

    if not self.canCastSnake then
        if GameRules:GetGameTime() - self.snakeTime >= self.coolDown then
            self.canCastSnake = true
            self:SetDuration(-1, true)
        end

        if not self.canCastSnake then
            return
        end
    end

    if self:GetParent():GetMana() <= self:GetParent():GetMaxMana() * self.manaThreshold / 100 then

        local abilitySnake = self:GetParent():FindAbilityByName("medusa_mystic_snake")
        if not abilitySnake or abilitySnake:GetLevel() == 0 then
            return
        end

        local castRange = abilitySnake:GetSpecialValueFor("AbilityCastRange") or 750
        castRange = castRange * 2

        local enemies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),   -- int, your team number
            self:GetParent():GetAbsOrigin(),    -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            castRange,  -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, -- int, flag filter
            FIND_ANY_ORDER, -- int, order filter
            false   -- bool, can grow cache
        )

        if not enemies or #enemies == 0 then
            return
        end

        self.canCastSnake = false
        self:SetDuration(self.coolDown + 0.1, true)

        local snakes = {}
        for _, enemy in pairs(enemies) do 
            if enemy and not enemy:IsNull() and enemy:IsAlive()  then
                table.insert(snakes, enemy)

                if #snakes >= self.maxSnakes then
                    break
                end
            end
        end

        --repeat the unit if there is only one
        if #snakes == 1 then
            table.insert(snakes, snakes[1])
        end

        for i = 1, #snakes do
            Timers:CreateTimer(0.2 * i, function()
                self:GetParent():SetCursorCastTarget(snakes[i])
                abilitySnake:OnSpellStart()
            end)
        end

        self.snakeTime = GameRules:GetGameTime()
    end
end



