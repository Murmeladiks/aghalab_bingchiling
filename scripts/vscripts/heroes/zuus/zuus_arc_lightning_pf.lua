LinkLuaModifier("modifier_zuus_arc_lightning_pf", "heroes/zuus/zuus_arc_lightning_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_pf_ally_buff", "heroes/zuus/zuus_arc_lightning_pf", LUA_MODIFIER_MOTION_NONE)
zuus_arc_lightning_pf	= zuus_arc_lightning_pf or class({})
modifier_zuus_arc_lightning_pf	= modifier_zuus_arc_lightning_pf or class({})

function zuus_arc_lightning_pf:Spawn()
	if IsClient() then return end
	self.projectiles = {}
	self.projectiles_targets_hit = {}
end

function zuus_arc_lightning_pf:GetCastRange(location, target)
	local projectile_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile")
	if projectile_shard and not projectile_shard:IsNull() then
		return projectile_shard:GetSpecialValueFor("projectile_max_distance")
	end
	return self:GetSpecialValueFor("cast_range")
end

function zuus_arc_lightning_pf:GetBehavior()
	local behavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET

	if self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile") then
		behavior = DOTA_ABILITY_BEHAVIOR_POINT
	end

	return behavior
end

function zuus_arc_lightning_pf:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	if self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile") then
		return UF_SUCCESS
	end

	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
	local magic_immunity_talent = caster:FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
	if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
		target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	local unit_team_selection = DOTA_UNIT_TARGET_TEAM_ENEMY

	return UnitFilter(target, unit_team_selection, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flags, caster:GetTeamNumber())
end

function zuus_arc_lightning_pf:OnSpellStart()
	self:OnSpellStartExternal()
end

function zuus_arc_lightning_pf:OnSpellStartExternal(cast_origin)
	local target = self:GetCursorTarget()
	local target_location = self:GetCursorPosition()
	local projectile_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile")

	if projectile_shard then
		self:CreateArcLightningProjectile(cast_origin and cast_origin:GetAbsOrigin(), target_location)
	else
		self:CreateArcLightning(target, cast_origin)
	end
end

function zuus_arc_lightning_pf:CreateArcLightning(target, source, bounce_capabilities)
    self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
    if target and not target:IsNull() and not target:TriggerSpellAbsorb(self) then
		local head_particle
		if source then
			head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, source)
			ParticleManager:SetParticleControlEnt(head_particle, 0, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_pf", {
				starting_unit_entindex	= target:entindex(),
				bounce_enabled = bounce_capabilities and 1 or 0,
			})
		else
			head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_pf", {
				starting_unit_entindex	= target:entindex(),
				bounce_enabled = 1
			})
		end
		ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		-- No reason for this CP besides that I like colours
		ParticleManager:SetParticleControl(head_particle, 62, Vector(2, 0, 2))
		ParticleManager:ReleaseParticleIndex(head_particle)
	end
end

function zuus_arc_lightning_pf:CreateArcLightningLocation(target, location)
    self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
	local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(head_particle, 0, location)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(head_particle, 62, Vector(2, 0, 2))
	ParticleManager:ReleaseParticleIndex(head_particle)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_pf", {
		starting_unit_entindex	= target:entindex(),
		bounce_enabled = 1
	})
end

function zuus_arc_lightning_pf:CreateArcLightningProjectile(origin_point, target_point)
	local caster = self:GetCaster()
	local projectile_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile")

	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
	local magic_immunity_talent = caster:FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
	if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
		target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	local unit_team_selection = DOTA_UNIT_TARGET_TEAM_ENEMY
	if caster:FindAbilityByName("pathfinder_zuus_arc_lightning_ally_bounce_buff") then
		unit_team_selection = unit_team_selection + DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end

	local direction = (target_point and origin_point) and (target_point - origin_point):Normalized() or caster:GetForwardVector()
	direction.z = 0

	local projectile = {
		Ability = self,
		EffectName = "particles/meteor_particle_1.vpcf",
		vSpawnOrigin = origin_point or caster:GetAbsOrigin(),
		fDistance = projectile_shard:GetSpecialValueFor("projectile_max_distance") + caster:GetCastRangeBonus(),
		fStartRadius = projectile_shard:GetSpecialValueFor("projectile_radius"),
		fEndRadius = projectile_shard:GetSpecialValueFor("projectile_radius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = unit_team_selection,
		iUnitTargetFlags = target_flags,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = direction * projectile_shard:GetSpecialValueFor("projectile_speed"),
		bProvidesVision = true,
		iVisionRadius = 650,
		iVisionTeamNumber = caster:GetTeamNumber()
	}

	ProjectileManager:CreateLinearProjectile(projectile)
	caster:EmitSound("Zuus.ShortCircuit")
end

function zuus_arc_lightning_pf:OnProjectileThinkHandle(projectileID)
	local projectile_location = ProjectileManager:GetLinearProjectileLocation(projectileID) + Vector(0, 0, 60)
	local projectile_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile")

	if not projectile_shard or projectile_shard:IsNull() then return end
	if not self.projectiles[projectileID] then
		self.projectiles[projectileID] = projectile_shard:GetSpecialValueFor("arc_lightning_interval")
		self.projectiles_targets_hit[projectileID] = {}
	end

	self.projectiles[projectileID] = self.projectiles[projectileID] + FrameTime()
	for enemy, timer in pairs(self.projectiles_targets_hit[projectileID]) do
		self.projectiles_targets_hit[projectileID][enemy] = timer - FrameTime()
	end
	if self.projectiles[projectileID] < projectile_shard:GetSpecialValueFor("arc_lightning_interval") then return end

	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
	local magic_immunity_talent = self:GetCaster():FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
	if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
		target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	local unit_team_selection = DOTA_UNIT_TARGET_TEAM_ENEMY
	if self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_ally_bounce_buff") then
		unit_team_selection = unit_team_selection + DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
	local targets = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(), 
		projectile_location, 
		nil, 
		projectile_shard:GetSpecialValueFor("trigger_radius"), 
		unit_team_selection, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		target_flags,
		FIND_CLOSEST,
		false
	)
	if #targets == 0 then return end
	self.projectiles[projectileID] = 0

	EmitSoundOnLocationForAllies(projectile_location, "Hero_Zuus.ArcLightning.Cast", self:GetCaster())
	for _, enemy in pairs(targets) do
		self:CreateArcLightningLocation(enemy, projectile_location)
	end
end

-- Depreciated

-- function zuus_arc_lightning_pf:OnProjectileHitHandle(hTarget, vLocation, projectileID)
-- 	if hTarget == nil then
-- 		self.projectiles[projectileID] = nil
-- 		self.projectiles_targets_hit[projectileID] = nil
-- 		return
-- 	end
-- 	if not self.projectiles_targets_hit[tonumber(projectileID)] then self.projectiles_targets_hit[tonumber(projectileID)] = {} end

-- 	local projectile_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile")
-- 	if not projectile_shard or projectile_shard:IsNull() then return end
-- 	local timer = self.projectiles_targets_hit[projectileID][hTarget:entindex()]
-- 	if timer == nil or timer <= 0 then
-- 		self.projectiles_targets_hit[projectileID][hTarget:entindex()] = projectile_shard:GetSpecialValueFor("impact_internal_cooldown")
-- 		self:CreateArcLightningLocation(hTarget, vLocation + Vector(0, 0, 60))
-- 		EmitSoundOnLocationForAllies(vLocation, "Zuus.ShortCircuitImpact", self:GetCaster())

-- 		local aoe_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_WORLDORIGIN, caster)
-- 		ParticleManager:SetParticleControl(aoe_particle, 0, vLocation + Vector(0, 0, 2000))
-- 		ParticleManager:SetParticleControl(aoe_particle, 1, vLocation)
-- 		ParticleManager:SetParticleControl(aoe_particle, 2, vLocation)
-- 		ParticleManager:SetParticleControl(aoe_particle, 7, Vector(projectile_shard:GetSpecialValueFor("projectile_radius"), 0, 0))
-- 		ParticleManager:ReleaseParticleIndex(aoe_particle)
-- 	end
-- end

function modifier_zuus_arc_lightning_pf:IsHidden()	    return true end
function modifier_zuus_arc_lightning_pf:IsPurgable()	return false end
function modifier_zuus_arc_lightning_pf:RemoveOnDeath()	return false end
function modifier_zuus_arc_lightning_pf:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_zuus_arc_lightning_pf:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	self.ability 			= self:GetAbility()
	self.arc_damage			= self.ability:GetSpecialValueFor("arc_damage")
	self.radius				= self.ability:GetSpecialValueFor("radius")
	self.jump_count			= self.ability:GetSpecialValueFor("jump_count")
	self.jump_delay			= self.ability:GetSpecialValueFor("jump_delay")

	self.multi_enemy_bounce_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_multi_enemy_bounce")
	self.ally_bounce_buff_shard	= keys.bounce_enabled == 1 and self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_ally_bounce_buff") or nil
	self.ministun_duration = self.ability:GetSpecialValueFor("mini_stun")
	

	self.starting_unit_entindex	= keys.starting_unit_entindex
	
	self.units_affected			= {}
	
	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
		self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1
		
		if self.current_unit and not self.current_unit:IsNull() then
			if self:GetCaster():HasModifier("modifier_zuus_static_field_pf") then
				self:GetCaster():FindModifierByName("modifier_zuus_static_field_pf"):Damage(self.current_unit, self)
			end

			if self.current_unit:GetTeam() == self:GetCaster():GetTeam() and self.ally_bounce_buff_shard then
				self.current_unit:AddNewModifier(self:GetCaster(), self.ability, "modifier_zuus_arc_lightning_pf_ally_buff", {duration = self.ally_bounce_buff_shard:GetSpecialValueFor("duration"), chance = self.ally_bounce_buff_shard:GetSpecialValueFor("arc_lightning_chance")})
			else
				if self.ministun_duration > 0 then
					self.current_unit:AddNewModifier(self:GetCaster(), self.ability, "modifier_stunned", {duration = self.ministun_duration * (1 - self.current_unit:GetStatusResistance())})
				end
				
				ApplyDamage({
					victim 			= self.current_unit,
					damage 			= self.arc_damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self.ability
				})
			end
		end
	else
		self:Destroy()
		return
	end
	
	self.unit_counter			= 0
	
	self:StartIntervalThink(self.jump_delay)
end

function modifier_zuus_arc_lightning_pf:OnIntervalThink()
	self.zapped = false
	local unit_team_selection = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
	if self.ally_bounce_buff_shard then
		unit_team_selection = unit_team_selection + DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
	local magic_immunity_talent = self:GetCaster():FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
	if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
		target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	
	if not self.current_unit or self.current_unit:IsNull() then
		self:StartIntervalThink(-1)
        self:Destroy()
		return
	end

	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius, unit_team_selection, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flags, FIND_CLOSEST, false)) do
		if not unit or unit:IsNull() then
			-- do nothing, it's an invalid entity
		elseif (not self.units_affected[unit] or (unit:GetTeam() ~= self:GetCaster():GetTeam() and self.multi_enemy_bounce_shard)) and unit ~= self.current_unit and (unit ~= self.previous_unit or self.multi_enemy_bounce_shard) then
			self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(2, 0, 2))
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
		
			self.unit_counter						= self.unit_counter + 1
			self.previous_unit						= self.current_unit
			self.current_unit						= unit
			
			self.units_affected[self.current_unit]	= 1
			
			self.zapped								= true

			if unit:GetTeam() == self:GetCaster():GetTeam() then -- If Arc Lightning bounces on a teammate
				unit:AddNewModifier(self:GetCaster(), self.ability, "modifier_zuus_arc_lightning_pf_ally_buff", {duration = self.ally_bounce_buff_shard:GetSpecialValueFor("duration"), chance = self.ally_bounce_buff_shard:GetSpecialValueFor("arc_lightning_chance")})
				break
			else -- If Arc Lightning bounces on an enemy
				if self:GetCaster():HasModifier("modifier_zuus_static_field_pf") then
					self:GetCaster():FindModifierByName("modifier_zuus_static_field_pf"):Damage(unit, self)
				end

				if self.ministun_talent and not self.ministun_talent:IsNull() and self.ministun_talent:GetLevel() > 0 then
					self.current_unit:AddNewModifier(self:GetCaster(), self.ability, "modifier_stunned", {duration = self.ministun_talent:GetSpecialValueFor("value") * (1 - self.current_unit:GetStatusResistance())})
				end
				
				ApplyDamage({
					victim 			= unit,
					damage 			= self.arc_damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self.ability
				})

				if self.multi_enemy_bounce_shard then
					local chance = self.multi_enemy_bounce_shard:GetSpecialValueFor("lightning_bolt_chance")
					local lightning_bolt = self:GetCaster():FindAbilityByName("zuus_lightning_bolt_pf")
					if lightning_bolt and lightning_bolt:GetLevel() > 0 and RollPercentage(chance) then
						lightning_bolt:CastLightningBolt(self:GetCaster(), lightning_bolt, unit, unit:GetAbsOrigin(), unit)
					end
				end
				
				break
			end
		end
	end
	
    if (self.unit_counter >= self.jump_count and self.jump_count > 0) or not self.zapped then
        self:StartIntervalThink(-1)
        self:Destroy()
    end
end

modifier_zuus_arc_lightning_pf_ally_buff = class({})
function modifier_zuus_arc_lightning_pf_ally_buff:IsHidden()	    return false end
function modifier_zuus_arc_lightning_pf_ally_buff:IsPurgable()	return false end
function modifier_zuus_arc_lightning_pf_ally_buff:RemoveOnDeath()	return true end

function modifier_zuus_arc_lightning_pf_ally_buff:OnCreated(kv)
	if IsServer() then 
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.Activate")
	end
end

function modifier_zuus_arc_lightning_pf_ally_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_mjollnir_shield.vpcf"
end

function modifier_zuus_arc_lightning_pf_ally_buff:GetEffectName()
	return "particles/items2_fx/mjollnir_shield.vpcf"
end

function modifier_zuus_arc_lightning_pf_ally_buff:DeclareFunctions()
	if IsClient() then return {} end
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_zuus_arc_lightning_pf_ally_buff:OnAbilityFullyCast(kv)
	local inflictor = kv.ability

	if not inflictor or inflictor:IsNull() then return end
	if bitand(inflictor:GetBehavior(), DOTA_ABILITY_BEHAVIOR_ATTACK) ~= 0 then return end
	if inflictor:IsItem() then return end

	local target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS
	local magic_immunity_talent = self:GetCaster():FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
	if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
		target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	local targets = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(), 
        self:GetParent():GetAbsOrigin(), 
        nil, 
        self:GetAbility():GetSpecialValueFor("cast_range") + self:GetCaster():GetCastRangeBonus(), 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        target_flags, 
        FIND_ANY_ORDER, false)

	if #targets > 0 then
		self:GetAbility():CreateArcLightning(targets[1], self:GetParent())
		self:Destroy()
	end
end
