---@class marci_grapple_pf:CDOTA_Ability_Lua
marci_grapple_pf = class({})

--[[
Grapple:
Unleach stacks
]]

local landing_target_fx_name = "particles/ui_mouseactions/range_finder_generic_aoe_nocenter.vpcf"
local target_fx_name = "particles/ui_mouseactions/range_finder_generic_aoe_moving_dash.vpcf"

LinkLuaModifier("modifier_generic_arc_lua", 				"libraries/modifiers/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_marci_grapple_pf_debuff", 		"heroes/marci/modifier_marci_grapple_pf_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_grapple_pf_mass_vacuum", 	"heroes/marci/modifier_marci_grapple_pf_mass_vacuum", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_marci_grapple_pf_mass_cleave", 	"heroes/marci/modifier_marci_grapple_pf_mass_cleave", LUA_MODIFIER_MOTION_NONE)

function marci_grapple_pf:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_marci.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_dispose_aoe_damage.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_dispose_land_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_grapple.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end

function marci_grapple_pf:GetBehavior()
	local caster = self:GetCaster()

	local behavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET

	if caster:FindAbilityByName("pathfinder_marci_grapple_throw") then
		behavior = behavior + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING
	end

	if caster:FindAbilityByName("pathfinder_marci_grapple_mass") then
		behavior = behavior + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return behavior
end

function marci_grapple_pf:GetAOERadius()
	local caster = self:GetCaster()
	local mass_shard = caster:FindAbilityByName("pathfinder_marci_grapple_mass")
	if mass_shard then
		return mass_shard:GetSpecialValueFor("radius")
	end
end

function marci_grapple_pf:OnVectorTargetingStart(location, cursor_targets)
	if not self.target_cast then return end

	if self.landing_target_fx then
		ParticleManager:DestroyParticle(self.landing_target_fx, true)
		self.landing_target_fx = nil
	end

	if self.target_fx then
		ParticleManager:DestroyParticle(self.target_fx, true)
		self.target_fx = nil
	end

	self.landing_radius = self:GetSpecialValueFor("landing_radius")

	self:DrawTargetFX(self.target_cast)
	self:DrawLandingFX(self.target_cast, location, cursor_targets)
end

function marci_grapple_pf:OnVectorTargetingThink(location, cursor_targets)
	if not location then return end

	self:DrawTargetFX(self.target_cast)
	self:DrawLandingFX(self.target_cast, location, cursor_targets)
end


function marci_grapple_pf:OnVectorTargetingEnd(location, cursor_targets)
	ParticleManager:DestroyParticle(self.landing_target_fx or -1, true)
	ParticleManager:DestroyParticle(self.target_fx, true)
end

function marci_grapple_pf:ClampLandingLocation(location, target, cursor_targets)
	local caster = self:GetCaster()
	local throw_shard = caster:FindAbilityByName("pathfinder_marci_grapple_throw")
	local min_distance = 0
	local max_distance = self.override_max_distance or throw_shard:GetSpecialValueFor("max_throw_distance")

	local target_entindex = target:entindex()
	local target_pos = target:GetAbsOrigin()

	if cursor_targets and table.contains(cursor_targets, target_entindex) then
		--return
	end

	local diff = location - target_pos
	diff.z = 0
	local distance = Clamp(diff:Length2D(), min_distance, max_distance)
	local direction = diff:Normalized()

	return target_pos + direction * distance
end

function marci_grapple_pf:DrawLandingFX(target, location, cursor_targets)
	local target_origin = target:GetAbsOrigin()
	location = self:ClampLandingLocation(location, target, cursor_targets)

	if not location then
		ParticleManager:DestroyParticle(self.landing_target_fx or -1, true)
		self.landing_target_fx = nil 
		return
	end

	if not self.landing_target_fx then
		self.landing_target_fx = ParticleManager:CreateParticle(landing_target_fx_name, PATTACH_WORLDORIGIN, target)
		ParticleManager:SetParticleControl(self.landing_target_fx, 3, Vector(self.landing_radius, 0, 0)) -- circle radius
	end

	local path_start = target_origin
	local path_end = location

	if (location - target_origin):Length2D() <= self.landing_radius + 50 then
		-- Hide path when it too short
		path_start = path_start + Vector(0,0,-1000)
		path_end = path_start + Vector(50,50,-1000)
	else
		path_end = path_end + ((target_origin - path_end):Normalized() * self.landing_radius * 0.97)
		path_end.z = target_origin.z
	end

	ParticleManager:SetParticleControl(self.landing_target_fx, 0, path_start)
	ParticleManager:SetParticleControl(self.landing_target_fx, 1, path_start)
	ParticleManager:SetParticleControl(self.landing_target_fx, 2, location) -- circle center
	ParticleManager:SetParticleControl(self.landing_target_fx, 12, path_end) 
end

function marci_grapple_pf:DrawTargetFX(target)
	local target_origin = target:GetAbsOrigin()
	local caster_origin = self:GetAbsOrigin()
	
	local diff = caster_origin - target_origin
	local distance = diff:Length2D()
	local green_start = caster_origin
	local red_start = caster_origin

	local cast_range_overflow = distance - self:GetEffectiveCastRange(target_origin, self.target_cast)
	if cast_range_overflow > 0 then
		green_start = green_start - diff:Normalized() * cast_range_overflow
	end

	if not self.target_fx then
		self.target_fx = ParticleManager:CreateParticle(target_fx_name, PATTACH_WORLDORIGIN, self)
	end

	ParticleManager:SetParticleControl(self.target_fx, 0, red_start)
	ParticleManager:SetParticleControl(self.target_fx, 1, green_start)
	ParticleManager:SetParticleControl(self.target_fx, 2, target_origin)
end

function marci_grapple_pf:CastFilterResultTarget( hTarget )
	local caster = self:GetCaster()

	if caster == hTarget then
		self.custom_error = "#dota_hud_error_cant_cast_on_self"
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		caster:GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	if IsClient() then
		self.target_cast = hTarget
	end

	if IsServer() and self.cast_location and bit.band(self:GetBehavior(), DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) == DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING then
		if not GridNav:IsTraversable(self.cast_location) or GridNav:IsBlocked(self.cast_location) then
			self.custom_error ="#dota_hud_error_invalid_location"
			return UF_FAIL_CUSTOM
		end
	end

	return UF_SUCCESS
end

function marci_grapple_pf:CastFilterResultLocation(location)
	self.cast_location = location

	return UF_SUCCESS
end

function marci_grapple_pf:GetCustomCastErrorTarget(hTarget)
	return self.custom_error
end

function marci_grapple_pf:OnAbilityPhaseStart()	
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	local mass_shard = caster:FindAbilityByName("pathfinder_marci_grapple_mass")
	if not mass_shard then return true end

	local target_pos = target:GetAbsOrigin()
	local radius = mass_shard:GetSpecialValueFor("radius")
	local type = self:GetAbilityTargetType()
	local team = target:GetTeam()
	local flags = self:GetAbilityTargetFlags()

	local targets = FindUnitsInRadius(team, target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, type, flags, FIND_ANY_ORDER, true)
	table.remove_item(targets, caster)
	self.targets = targets

	for _, unit in pairs(targets) do
		local unit_pos = unit:GetAbsOrigin()
		local distance = (target_pos - unit_pos):Length2D()
		local direction = (target_pos - unit_pos):Normalized()
		
		local pos = unit_pos
		if distance > 128 then
			pos = target_pos - direction * Script_RandomFloat(32, 128)
		end

		unit:AddNewModifier(caster, mass_shard, "modifier_marci_grapple_pf_mass_vacuum", { 
			duration = self:GetCastPoint(), 
			target_x = pos.x,
			target_y = pos.y,
			target_z = pos.z,
		})
	end

	local pFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_vacuum.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:ReleaseParticleIndex(pFX)

	EmitSoundOnLocationWithCaster(target_pos, "Hero_Dark_Seer.Vacuum", caster)

	return true
end

function marci_grapple_pf:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	local targets = self.targets or { target }
	local distance = self:GetSpecialValueFor("throw_distance_behind")
	local height = self:GetSpecialValueFor("air_height")
	local pos = caster:GetOrigin() - caster:GetForwardVector() * distance
	
	local throw_shard = caster:FindAbilityByName("pathfinder_marci_grapple_throw")
	if throw_shard and self.cast_location then
		
		if throw_shard then
			height = throw_shard:GetSpecialValueFor("air_height")
		end

		pos = self:ClampLandingLocation(self.cast_location, target)
	end

	if self.override_cast_location then
		pos = self.override_cast_location
		self.override_cast_location = nil
	end

	if self.override_height then
		height = self.override_height
		self.override_height = nil
	end

	for _, unit in pairs(targets) do
		if IsValidEntity(unit) and unit:IsAlive() then
			unit:RemoveModifierByName("modifier_marci_grapple_pf_mass_vacuum")
			local throw_pos = pos + unit:GetAbsOrigin() - target:GetAbsOrigin()
			self:ThrowUnit(unit, throw_pos, height, unit == target, self.companion_run_inflictor)
		end
	end

	self.companion_run_inflictor = nil

	self:PlayEffects4(caster)

	local mass_shard = caster:FindAbilityByName("pathfinder_marci_grapple_mass")
	if mass_shard and target:GetTeam() ~= caster:GetTeam() then
		caster:AddNewModifier(caster, mass_shard, "modifier_marci_grapple_pf_mass_cleave", nil)
	end

	self.targets = nil
	self.cast_location = nil
	self.override_max_distance = nil
end

function marci_grapple_pf:ThrowUnit(target, position, height, is_main, is_companion_run)
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("air_duration")
	local radius = self:GetSpecialValueFor("landing_radius")
	local slow_duration = self:GetSpecialValueFor("debuff_duration")
	local damage = self:GetSpecialValueFor("impact_damage")

	local targetpos = position
	local totaldist = (target:GetOrigin() - targetpos):Length2D()

	local arc = target:AddNewModifier(caster, self, "modifier_generic_arc_lua", 
		{
			target_x = targetpos.x,
			target_y = targetpos.y,
			duration = duration,
			distance = totaldist,
			height = height,
			fix_end = false,
			fix_duration = false,
			isStun = true,
			isForward = true,
			activity = ACT_DOTA_FLAIL,
		} 
	)

	arc:SetEndCallback(function()
		if not IsValidEntity(target) or not IsValidEntity(caster) then return end

		local allied = target:GetTeamNumber() == caster:GetTeamNumber()

		--Apply damage and debuff only when main target landing
		if is_main then

			local enemies = FindUnitsInRadius(
				caster:GetTeamNumber(),
				target:GetOrigin(),
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				0,
				0,
				false
			)

			local damageTable = {
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self, 
			}

			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, self, "modifier_marci_grapple_pf_debuff", { duration = slow_duration })
		
				damageTable.victim = enemy
				ApplyDamage(damageTable)

				self:PlayEffects2(enemy:GetOrigin())
			end

			GridNav:DestroyTreesAroundPoint(target:GetOrigin(), radius, false)

			local stun_shard = caster:FindAbilityByName("pathfinder_marci_grapple_stun")
			if stun_shard and not allied then
				local units = FindUnitsInRadius(
					caster:GetTeam(),
					target:GetOrigin(),
					nil,
					radius,
					DOTA_UNIT_TARGET_TEAM_BOTH,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					0,
					0,
					false
				)

				local bonus_stun = stun_shard:GetSpecialValueFor("bonus_stun") * #units

				if bonus_stun > 0 then
					target:AddNewModifier(caster, self, "modifier_marci_grapple_pf_debuff", { duration = slow_duration + bonus_stun })
				end
			end

			local heal_pct = self:GetSpecialValueFor("max_hp_heal") / 100
			if heal_pct > 0 and allied then
				local heal = target:GetMaxHealth() * heal_pct
				target:HealWithParams(heal, self, false, true, caster, false)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, caster)

				local heal_caster = caster:GetMaxHealth() * heal_pct
				caster:HealWithParams(heal_caster, self, false, true, caster, false)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal_caster, caster)
			end
			
			self:PlayEffects1(target:GetOrigin(), radius, allied)
		end

		-- Apply Rebound buff on landing for allies
		if allied and caster:FindAbilityByName("pathfinder_marci_grapple_throw") then
			local rebound = caster:FindAbilityByName("marci_companion_run_pf")

			if rebound and rebound:IsTrained() then
				local duration = rebound:GetSpecialValueFor("ally_buff_duration")
				target:AddNewModifier(caster, rebound, "modifier_marci_companion_run_pf_buff", { duration = duration })
			end
		end

		
		if allied and is_companion_run then
			local global_shard = caster:FindAbilityByName("pathfinder_marci_companion_run_global")
			if global_shard then
				local heal = target:GetMaxHealth() * global_shard:GetSpecialValueFor("heal_percent") * 0.01
				target:Heal(heal, global_shard)
			end
		end
	end)

	-- play effects
	self:PlayEffects3(caster, target, duration)
	
end

function marci_grapple_pf:PlayEffects1(point, radius, allied)
	-- Get Resources
	local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_marci/marci_dispose_land_aoe.vpcf", caster)
	local sound_cast = "Hero_Marci.Grapple.Impact"
	if allied then
		sound_cast = "Hero_Marci.Grapple.Impact.Ally"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, point)
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(effect_cast)

	-- Create Sound
	EmitSoundOnLocationWithCaster(point, sound_cast, self:GetCaster())
end

function marci_grapple_pf:PlayEffects2(point)
	-- Get Resources
	local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_marci/marci_dispose_aoe_damage.vpcf", caster)
	local sound_cast = "Hero_Marci.Grapple.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 1, point)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	-- Create Sound
	EmitSoundOnLocationWithCaster(point, sound_cast, self:GetCaster())
end

function marci_grapple_pf:PlayEffects3(caster, target, duration)
	-- Get Resources
	local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", caster)
	local sound_cast = "Hero_Marci.Grapple.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl(effect_cast, 5, Vector( duration, 0, 0 ))
	ParticleManager:ReleaseParticleIndex(effect_cast)

	-- Create Sound
	EmitSoundOn(sound_cast, target)
end

function marci_grapple_pf:PlayEffects4(caster)
	-- Get Resources
	local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_marci/marci_grapple.vpcf", caster)
	local sound_cast = "Hero_Marci.Grapple.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	-- Create Sound
	EmitSoundOn(sound_cast, caster)
end