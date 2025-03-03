require("libraries.timers")

AddStackModifier = function(npc, data)
    data.data = data.data or {}
    data.data.duration = (data.duration or -1)
    if npc:HasModifier(data.modifier) then
        local current_stack = npc:GetModifierStackCount(data.modifier, data.ability)
        if data.updateStack then
            npc:AddNewModifier(data.caster or npc, data.ability, data.modifier, data.data)
        end
        npc:SetModifierStackCount(data.modifier, data.ability, current_stack + (data.count or 1))
        if npc:GetModifierStackCount(data.modifier, data.ability) < 1 then
            npc:RemoveModifierByName(data.modifier)
        end
    else
        npc:AddNewModifier(data.caster or npc, data.ability, data.modifier, data.data)
        npc:SetModifierStackCount(data.modifier, data.ability, (data.count or 1))
    end
    return npc:GetModifierStackCount(data.modifier, data.ability)
end

RandomChoice = function(t) -- Selects a random item from a table
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys + 1] = key -- Store keys in another table
    end
    local index = keys[math.random(1, #keys)]
    return t[index]
end

FindTalentValue = function(unit, talentName)

    if IsServer() and unit:HasAbility(talentName) then
        return unit:FindAbilityByName(talentName):GetSpecialValueFor("value")
    end
    return 0
end

HasShard = function(unit, talentName)
	local legendary_shard = unit:FindAbilityByName(talentName)
    if legendary_shard and not legendary_shard:IsNull() and legendary_shard:GetLevel() > 0 then
        return true
    end
    return false
end

FindRadius = function(unit, radius, isEnemy)
    if not IsServer() then
        return
    end
    local search_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    if not isEnemy then
        search_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end
    local units = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, radius, search_team,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    return units
end

FindRadiusPoint = function(caster, point, radius, isEnemy)
    if not IsServer() then
        return
    end
    local search_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    if not isEnemy then
        search_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    end
    local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, search_team,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    return units
end

patron_particles =
    {"particles/econ/items/windrunner/windranger_arcana/windranger_arcana_focusfire_v2_ground_butterfly.vpcf",
     "particles/econ/courier/courier_nian/courier_nian_bag_coin.vpcf",
     "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf"}
courier_models = {"models/items/courier/snowl/snowl.vmdl", "models/items/courier/snowl/snowl_flying.vmdl"}

AddPatronEffect = function(unit)
    if not IsServer() then return end
	
	local player_id = unit:GetPlayerOwnerID()
	local data = { model = courier_models[RandomInt(1, #courier_models)] }
	
	if WearFunc[CHC_ITEM_TYPE_PETS] and WearFunc[CHC_ITEM_TYPE_PETS][player_id] and next(WearFunc[CHC_ITEM_TYPE_PETS][player_id]) then
		data = WearFunc[CHC_ITEM_TYPE_PETS][player_id]
	end
	
    return data
end

EmitManySounds = function(soundlist, delay)
    for i = 1, #soundlist do
        Timers:CreateTimer(i * delay, function()
            EmitGlobalSound(soundlist[i])
        end)
    end
end
