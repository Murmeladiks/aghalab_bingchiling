
modifier_generic_collect_stats = class({})

------------------------------------------------------------------------------

function modifier_generic_collect_stats:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_generic_collect_stats:OnCreated( kv )
    if IsServer() then
        self.excludedUnits = {
			npc_dota_crate = true,
			npc_dota_vase = true,
            npc_dota_hero_target_dummy = true,
            npc_dota_dummy_caster = true,
		}

        print("player stats created!")
    end
end


function modifier_generic_collect_stats:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_generic_collect_stats:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
        --MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_generic_collect_stats:OnTakeDamage( params )
    if IsServer() then
        if params.attacker == self:GetParent() or params.unit == self:GetParent() then
            return
        end

        if params.unit:IsTower() or params.unit:IsBuilding() or params.unit:IsOther() then
            return
        end

        if self.excludedUnits[params.unit:GetUnitName()] then
            return
        end

        local hAttackerUnit = params.attacker
        local hVictimUnit = params.unit

        local damage = math.ceil(params.damage)
        --print("damage statistics")
        --print(damage)
        --not sure if this is necessary (-suicide makes physical dmg but 0 original damage)
        local originalDamage = math.ceil(math.max(params.original_damage, params.damage))

        --Damage Dealt
        if (hAttackerUnit and hAttackerUnit:IsRealHero()) or (hAttackerUnit:GetPlayerOwner() and hAttackerUnit:GetPlayerOwner():GetAssignedHero())  then
            local hero = hAttackerUnit

            if hAttackerUnit:GetPlayerOwner() and hAttackerUnit:GetPlayerOwner():GetAssignedHero() then
                hero = hAttackerUnit:GetPlayerOwner():GetAssignedHero()
            end
           local  nPlayerID = hero:GetPlayerOwnerID()
            -- local playerID = hero:GetPlayerID() or -1

            -- local playerStats = GameRules.Aghanim._vPlayerStats[ playerID ]
            -- if not playerStats then
            --     print("no player stats")
            --     return
            -- end
            local scores = CustomNetTables:GetTableValue( "aghanim_scores", tostring(nPlayerID) )
            if scores ~= nil then
                scores.kills = scores.kills + damage
                CustomNetTables:SetTableValue( "aghanim_scores", tostring(nPlayerID), scores )
            end
            -- if params.damage_type == 1 then
            --     --physical
            --     if playerStats.dealtDamage and playerStats.dealtDamage.physical and playerStats.dealtDamage.total then
            --         playerStats.dealtDamage.physical = playerStats.dealtDamage.physical + damage
            --         playerStats.dealtDamage.total = playerStats.dealtDamage.total + damage
            --     end
            -- elseif params.damage_type == 2 then
            --     --magical
            --     if playerStats.dealtDamage and playerStats.dealtDamage.magical and playerStats.dealtDamage.total then
            --         playerStats.dealtDamage.magical = playerStats.dealtDamage.magical + damage
            --         playerStats.dealtDamage.total = playerStats.dealtDamage.total + damage
            --     end
            -- elseif params.damage_type == 4 then
            --     --pure
            --     if playerStats.dealtDamage and playerStats.dealtDamage.pure and playerStats.dealtDamage.total then
            --         playerStats.dealtDamage.pure = playerStats.dealtDamage.pure + damage
            --         playerStats.dealtDamage.total = playerStats.dealtDamage.total + damage
            --     end
            -- else
            --     --other to physical
            --     if playerStats.dealtDamage and playerStats.dealtDamage.physical and playerStats.dealtDamage.total then
            --         playerStats.dealtDamage.physical = playerStats.dealtDamage.physical + damage
            --         playerStats.dealtDamage.total = playerStats.dealtDamage.total + damage
            --     end
            -- end
        end

    end
end

-- function modifier_generic_collect_stats:OnDeath( params )
--     if IsServer() then
--         if params.attacker == self:GetParent() or params.unit == self:GetParent() then
--             return
--         end

--         if params.unit:IsTower() or params.unit:IsBuilding() or params.unit:IsOther() then
--             return
--         end

--         if self.excludedUnits[params.unit:GetUnitName()] then
--             return
--         end
        
--         local hAttackerUnit = params.attacker

--         if hAttackerUnit:IsRealHero() then
--             local playerID = hAttackerUnit:GetPlayerID()

--             local playerStats = GameRules.Aghanim._vPlayerStats[ playerID ]
--             if playerStats then
--                 playerStats.creepsKilled = playerStats.creepsKilled + 1
--             end
--         end
--     end
-- end