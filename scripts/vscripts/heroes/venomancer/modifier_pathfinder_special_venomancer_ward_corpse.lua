
modifier_pathfinder_special_venomancer_ward_corpse = class({})
LinkLuaModifier( "modifier_pathfinder_special_venomancer_ward_corpse_debuff", "heroes/venomancer/modifier_pathfinder_special_venomancer_ward_corpse_debuff", LUA_MODIFIER_MOTION_NONE )

require("heroes/venomancer/plague_ward")

function modifier_pathfinder_special_venomancer_ward_corpse:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_pathfinder_special_venomancer_ward_corpse:IsHidden()
	return true
end

function modifier_pathfinder_special_venomancer_ward_corpse:OnAttack(keys)
	local caster = self:GetParent()
	
	if IsValidEntity(caster) and keys.attacker == caster and not keys.no_attack_cooldown and HasShard(caster, "pathfinder_special_venomancer_ward_corpse") then
		-- Look for a target in the attack range of the ward
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			caster:Script_GetAttackRange(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
			FIND_ANY_ORDER,
			false)
			
		local targets_aimed = 0
		
		-- Send a attack projectile to the chosen enemies
		for i = 1, #enemies do
			if enemies[i] ~= keys.target then
				-- "Unlike most other instant attacks, the ones from the Serpent Wards do not proc any on-hit effects."
				caster:PerformAttack(enemies[i], false, false, true, true, true, false, false)
				
				targets_aimed	= targets_aimed + 1
				
				if targets_aimed >= caster:FindAbilityByName("pathfinder_special_venomancer_ward_corpse"):GetSpecialValueFor("additional_shots") then
					break
				end
			end
		end
	end
end

function modifier_pathfinder_special_venomancer_ward_corpse:OnDeath(params)
	local caster = self:GetParent()
	local target = params.unit
	
	if caster ~= params.attacker then
		return nil
	end	

	local corpse_ability = caster:FindAbilityByName("pathfinder_special_venomancer_ward_corpse")
	if not corpse_ability then
		return nil
	end
		
	local radius = corpse_ability:GetSpecialValueFor("radius")
	local spawn_chance = corpse_ability:GetSpecialValueFor("spawn_chance")
	local plague_ward_ability = caster:FindAbilityByName("venomancer_plague_ward_datadriven")

	if caster:GetRangeToUnit(target) <= radius then
		if RandomInt(0, 100) < spawn_chance then
			local kv = {
				caster = caster,
				target = target,
				ability = plague_ward_ability,
				target_points = {target:GetAbsOrigin()},
				Duration = plague_ward_ability:GetSpecialValueFor("duration")}
			venomancer_plague_ward_datadriven_on_spell_start(kv)
		end		
	end
end