
item_health_potion = class({})

--------------------------------------------------------------------------------

function item_health_potion:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_health_potion:OnSpellStart()
	if IsServer() then
		if IsServer() then
			self:GiveContentToAllTeam()
		end
	end
end
function item_health_potion:GiveContentToAllTeam()
    if IsServer() then
		local hp_restore_pct = self:GetSpecialValueFor( "hp_restore_pct" )

        local Heroes = HeroList:GetAllHeroes()

        local friendlyUnits = self:FindFriendlyMates()
        if friendlyUnits and #friendlyUnits > 0 then
            TableMerge(Heroes, friendlyUnits)
        end

        for _,Hero in pairs( Heroes ) do
            if not Hero:HasModifier("modifier_event_slark_greed") then
                Hero:EmitSoundParams( "DOTA_Item.FaerieSpark.Activate", 0, 0.5, 0)
                local flHealAmount = Hero:GetMaxHealth() * hp_restore_pct / 100
                Hero:Heal( flHealAmount, self )

                local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
            end
        end

        local container = self:GetContainer()

        self:SetCurrentCharges(1)
        self:SpendCharge(0)
    
        if container and not container:IsNull() then
            UTIL_Remove(container)
        end
    
        UTIL_Remove(self)
    end
end
function item_health_potion:FindFriendlyMates()
    -- Friends that need escort/survive
    local friends = {
        npc_dota_lone_druid_bear1 = true,
        npc_dota_lone_druid_bear2 = true,
        npc_dota_lone_druid_bear3 = true,
        npc_dota_lone_druid_bear4 = true,
    }

    local teamMates = FindUnitsInRadius(
        DOTA_TEAM_GOODGUYS, -- int, your team number
        Vector(0,0,0),  -- point, center point
        nil,    -- handle, cacheUnit. (not known)
        FIND_UNITS_EVERYWHERE,  -- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_FRIENDLY, -- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
        DOTA_UNIT_TARGET_FLAG_NONE, -- int, flag filter
        FIND_UNITS_EVERYWHERE,  -- int, order filter
        false   -- bool, can grow cache
    )

    local foundFriends = {}

    if teamMates and #(teamMates) > 0 then
        for _, mate in pairs(teamMates) do
            if mate and friends[mate:GetUnitName()] then
                table.insert(foundFriends, mate)
            end
        end
    end

    return foundFriends
end

