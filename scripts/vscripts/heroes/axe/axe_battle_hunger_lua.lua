axe_battle_hunger_lua = class({})
LinkLuaModifier( "modifier_axe_battle_hunger_lua", "heroes/axe/modifier_axe_battle_hunger_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_lua_debuff", "heroes/axe/modifier_axe_battle_hunger_lua_debuff", LUA_MODIFIER_MOTION_NONE )
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

function axe_battle_hunger_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor("duration")

	local enemies = FindRadiusPoint(caster, target_loc, self:GetSpecialValueFor("radius"), true)
	

	for _,target in pairs(enemies) do
		target:AddNewModifier(
			caster, self, "modifier_axe_battle_hunger_lua_debuff", { duration = duration }
		)
		
		caster:AddNewModifier(
			caster, self, "modifier_axe_battle_hunger_lua", { duration = duration }
		)
	end

	local sound_cast = "Hero_Axe.Battle_Hunger"
	caster:EmitSound( sound_cast)
end

function axe_battle_hunger_lua:OnSpellStartSingle(unit)
	local caster = self:GetCaster()
	local target = unit

	local duration = self:GetSpecialValueFor("duration")
		
	target:AddNewModifier(
		caster, self, "modifier_axe_battle_hunger_lua_debuff", { duration = duration }
	)	
	
	caster:AddNewModifier(
		caster, self, "modifier_axe_battle_hunger_lua", { duration = duration }
	)	
end

function axe_battle_hunger_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

