LinkLuaModifier("modifier_zuus_lightning_bolt_pf", "heroes/zuus/zuus_lightning_bolt_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_true_sight_pf", "heroes/zuus/zuus_lightning_bolt_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_dummy_pf", "heroes/zuus/zuus_lightning_bolt_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_kill_recast_interval", "heroes/zuus/zuus_lightning_bolt_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_linear_cast", "heroes/zuus/zuus_lightning_bolt_pf", LUA_MODIFIER_MOTION_NONE)
zuus_lightning_bolt_pf = class({})

function zuus_lightning_bolt_pf:GetIntrinsicModifierName()
    return "modifier_zuus_lightning_bolt_pf"
end

function zuus_lightning_bolt_pf:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Cast")

	return true
end

function zuus_lightning_bolt_pf:GetCastRange()
	local line_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_lightning_bolt_linear_cast")
	if line_shard then
		return self:GetSpecialValueFor("cast_range") * line_shard:GetSpecialValueFor("max_distance_cast_range_multiplier") + self:GetCaster():GetCastRangeBonus() * (line_shard:GetSpecialValueFor("max_distance_cast_range_multiplier") - 1)
	end

	return self:GetSpecialValueFor("cast_range")
end

function zuus_lightning_bolt_pf:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	if target == caster and caster:FindAbilityByName("pathfinder_zuus_lightning_bolt_self_cast") then
		return UF_SUCCESS
	end

	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
	local magic_immunity_talent = caster:FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
	if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
		target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, target_flags, caster:GetTeamNumber())
end

function zuus_lightning_bolt_pf:OnSpellStart()
	if IsServer() then
		self:OnSpellStartExternal(self:GetCaster())
	end
end

function zuus_lightning_bolt_pf:OnSpellStartExternal(origin_caster, position_target)
	local caster 		= self:GetCaster()
	local target 		= self:GetCursorTarget()
	local target_point 	= position_target or self:GetCursorPosition()

	local line_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_lightning_bolt_linear_cast")
	if line_shard then
		zuus_lightning_bolt_pf:CastLightningBoltLinear(origin_caster, target_point, caster, self)
	else
		zuus_lightning_bolt_pf:CastLightningBolt(caster, self, target, target_point)
	end
end

function zuus_lightning_bolt_pf:CastLightningBolt(caster, ability, target, target_point, nimbus)
	if IsServer() then
		local spread_aoe 			= ability:GetSpecialValueFor("spread_aoe")
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_radius_day  	= ability:GetSpecialValueFor("sight_radius_day")
		local sight_radius_night  	= ability:GetSpecialValueFor("sight_radius_night")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local stun_duration 		= ability:GetSpecialValueFor("stun_duration")
		local target_flags 			= DOTA_UNIT_TARGET_FLAG_NONE
		local z_pos 				= 2000
		local magic_immunity_talent = caster:FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
		if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
			target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		end

		local self_cast_shard = caster:FindAbilityByName("pathfinder_zuus_lightning_bolt_self_cast")

		EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.LightningBolt", caster)

		-- Add fog vision 
		AddFOWViewer(caster:GetTeam(), target_point, true_sight_radius, sight_duration, false)

		if target == caster and not self_cast_shard then target = nil end
		if target ~= nil then
			target_point = target:GetAbsOrigin()
		end

		-- Spell was used on the ground search for invisible hero to target
		if target == nil then

			-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				ability:GetAbilityTargetType(), 
				target_flags, 
				FIND_CLOSEST, 
				false
			)
			
			local closest = radius
			for i,unit in ipairs(nearby_enemy_units) do
				if not unit:IsMagicImmune() or pierce_spellimmunity then 
					-- First unit is the closest
					target = unit
					break
				end
			end
		end

		if not nimbus and target then
			-- If the target possesses a ready Linken's Sphere, do nothing
			if target:GetTeam() ~= caster:GetTeam() then
				if target:TriggerSpellAbsorb(ability) then
					return nil
				end
			end
		end

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
		
        -- Renders the particle on the ground target
        ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
        ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, z_pos))
        ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
        ParticleManager:ReleaseParticleIndex(particle)

		-- Add dummy to provide us with truesight aura
		local dummy_unit = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, 0), false, nil, nil, caster:GetTeam())
		local true_sight = dummy_unit:AddNewModifier(caster, ability, "modifier_zuus_lightning_true_sight_pf", {duration = sight_duration})
		true_sight:SetStackCount(true_sight_radius)
		dummy_unit:SetDayTimeVisionRange(true_sight_radius)
		dummy_unit:SetNightTimeVisionRange(true_sight_radius)

		dummy_unit:AddNewModifier(caster, ability, "modifier_zuus_lightning_dummy_pf", {})
		dummy_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = sight_duration + 1})

		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage			= ability:GetSpecialValueFor("damage")

		if target == caster then 
			local heal_amount = caster:GetMaxHealth() * (self_cast_shard:GetSpecialValueFor("percent_heal") / 100)
			local stun_duration = self_cast_shard:GetSpecialValueFor("stun_duration")
			local effect_radius = self_cast_shard:GetSpecialValueFor("effect_radius")
			local knockback_distance = self_cast_shard:GetSpecialValueFor("knockback_distance")

			caster:Heal(heal_amount, self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal_amount, nil)

			local heal_particle = ParticleManager:CreateParticle("particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:ReleaseParticleIndex(heal_particle)
			caster:EmitSound("Zuus.LightningBoltSelfcast")

			-- Enemy damage and knockback
			local knockbackProperties =
			{
				center_x = target_point.x,
				center_y = target_point.y,
				center_z = target_point.z,
				duration = stun_duration * (1 - target:GetStatusResistance()),
				knockback_duration = stun_duration * (1 - target:GetStatusResistance()),
				knockback_distance = knockback_distance,
				knockback_height = 75
			}

			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), 
				caster:GetAbsOrigin(), 
				nil, 
				effect_radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				target_flags, 
				FIND_ANY_ORDER, false)

			for _, enemy in pairs(enemies) do
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_unstable_current.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy) 
				ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle)

				enemy:AddNewModifier(caster, nil, "modifier_knockback", knockbackProperties)

				if caster:HasModifier("modifier_zuus_static_field_pf") then
					caster:FindModifierByName("modifier_zuus_static_field_pf"):Damage(target, self)
				end

				damage_table.victim 		= enemy
				ApplyDamage(damage_table)
			end
            
		elseif target ~= nil and target:GetTeam() ~= caster:GetTeam() then            
			target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration * (1 - target:GetStatusResistance())})

			if caster:HasModifier("modifier_zuus_static_field_pf") then
				caster:FindModifierByName("modifier_zuus_static_field_pf"):Damage(target, self)
			end

			damage_table.victim 		= target
			ApplyDamage(damage_table)
		end
	end
end

function zuus_lightning_bolt_pf:CastLightningBoltLinear(origin_caster, target_point, spell_owner, ability)
	local line_shard = spell_owner:FindAbilityByName("pathfinder_zuus_lightning_bolt_linear_cast")
	zuus_lightning_bolt_pf:CastLightningBolt(spell_owner, ability, spell_owner, origin_caster:GetAbsOrigin())

	local origin_point = origin_caster and origin_caster:GetAbsOrigin()
	local direction = (origin_point and target_point) and (target_point - origin_point):Normalized() or origin_caster:GetForwardVector()
	local max_distance = line_shard:GetSpecialValueFor("max_distance_cast_range_multiplier") * (ability:GetSpecialValueFor("cast_range") + spell_owner:GetCastRangeBonus())
	local cast_distance_interval = line_shard:GetSpecialValueFor("distance_interval")
	local bolt_interval = line_shard:GetSpecialValueFor("bolt_interval")
	spell_owner:AddNewModifier(spell_owner, ability, "modifier_zuus_lightning_bolt_linear_cast", {max_distance = max_distance, cast_distance_interval = cast_distance_interval, bolt_interval = bolt_interval,
		ox = origin_point.x, oy = origin_point.y, oz = origin_point.z,
		fvx = direction.x, fvy = direction.y, fvz = direction.z
	})
end

modifier_zuus_lightning_bolt_pf = class({})
function modifier_zuus_lightning_bolt_pf:RemoveOnDeath() return false end
function modifier_zuus_lightning_bolt_pf:IsHidden() return true end
function modifier_zuus_lightning_bolt_pf:IsPurgable() return false end
function modifier_zuus_lightning_bolt_pf:IsDebuff() return false end

function modifier_zuus_lightning_bolt_pf:DeclareFunctions()
    if IsClient() then return {} end
    return {
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_zuus_lightning_bolt_pf:OnDeath(kv)
    if kv.attacker == self:GetParent() then
        local death_location = kv.unit:GetAbsOrigin()
        local kill_recast_shard = self:GetParent():FindAbilityByName("pathfinder_zuus_lightning_bolt_kill_recast")

        -- Kill Recast legendary shard
        if kill_recast_shard and kv.inflictor and kv.inflictor:GetAbilityName() == "zuus_lightning_bolt_pf" then
            self:GetParent():AddNewModifier(self:GetParent(), kill_recast_shard, "modifier_zuus_lightning_bolt_kill_recast_interval", {duration = kill_recast_shard:GetSpecialValueFor("interval"), x = death_location.x, y = death_location.y, z = death_location.z})
        end
    end
end

modifier_zuus_lightning_bolt_kill_recast_interval = class({})
function modifier_zuus_lightning_bolt_kill_recast_interval:RemoveOnDeath() return false end
function modifier_zuus_lightning_bolt_kill_recast_interval:IsHidden() return true end
function modifier_zuus_lightning_bolt_kill_recast_interval:IsPurgable() return false end
function modifier_zuus_lightning_bolt_kill_recast_interval:IsDebuff() return false end
function modifier_zuus_lightning_bolt_kill_recast_interval:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_zuus_lightning_bolt_kill_recast_interval:OnCreated(kv)
    if IsClient() then return end
    self.death_location = Vector(kv.x, kv.y, kv.z)
end

function modifier_zuus_lightning_bolt_kill_recast_interval:OnDestroy()
    if IsClient() then return end
    local ability = self:GetAbility()
    local lightning_bolt_ability = self:GetParent():FindAbilityByName("zuus_lightning_bolt_pf")

	local target_flags 			= DOTA_UNIT_TARGET_FLAG_NONE
	local magic_immunity_talent = self:GetParent():FindAbilityByName("special_unique_pathfinder_zuus_non_ult_spell_immunity_pierce")
	if magic_immunity_talent and magic_immunity_talent:GetLevel() > 0 then
		target_flags = target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

    local targets = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(), 
        self.death_location, 
        nil, 
        ability:GetSpecialValueFor("radius"), 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        target_flags, 
        FIND_CLOSEST, 
        false)

    if #targets == 0 then return end

    -- Find the target with the lowest hp
    local current_target = nil
    local current_target_hp = nil
    
    for _, target in pairs(targets) do
        if current_target_hp == nil or target:GetHealth() < current_target_hp then
            current_target = target
            current_target_hp = target:GetHealth()
        end
    end

    lightning_bolt_ability:CastLightningBolt(self:GetParent(), lightning_bolt_ability, current_target, current_target:GetAbsOrigin())
end

modifier_zuus_lightning_true_sight_pf = class({})
function modifier_zuus_lightning_true_sight_pf:IsAura() return true end
function modifier_zuus_lightning_true_sight_pf:IsHidden() return true end
function modifier_zuus_lightning_true_sight_pf:IsPurgable() return false end
function modifier_zuus_lightning_true_sight_pf:GetAuraRadius() return math.max(self:GetStackCount(), 1) end
function modifier_zuus_lightning_true_sight_pf:GetModifierAura() return "modifier_truesight" end
function modifier_zuus_lightning_true_sight_pf:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_zuus_lightning_true_sight_pf:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
function modifier_zuus_lightning_true_sight_pf:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER end
function modifier_zuus_lightning_true_sight_pf:GetAuraDuration() return 0.5 end

modifier_zuus_lightning_dummy_pf = class({})
function modifier_zuus_lightning_dummy_pf:IsHidden() return true end
function modifier_zuus_lightning_dummy_pf:IsPurgable() return false end
function modifier_zuus_lightning_dummy_pf:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_FLYING] = true,
	}

	return state
end

modifier_zuus_lightning_bolt_linear_cast = class({})
function modifier_zuus_lightning_bolt_linear_cast:RemoveOnDeath() return false end
function modifier_zuus_lightning_bolt_linear_cast:IsHidden() return true end
function modifier_zuus_lightning_bolt_linear_cast:IsPurgable() return false end
function modifier_zuus_lightning_bolt_linear_cast:IsDebuff() return false end
function modifier_zuus_lightning_bolt_linear_cast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_zuus_lightning_bolt_linear_cast:OnCreated(kv)
    if IsClient() then return end
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

    self.max_distance = kv.max_distance
	self.cast_distance_interval = kv.cast_distance_interval 
	self.bolt_interval = kv.bolt_interval

	self.origin = Vector(kv.ox, kv.oy, kv.oz)
	self.direction = Vector(kv.fvx, kv.fvy, kv.fvz)

	self.current_distance = self.cast_distance_interval
	self:StartIntervalThink(self.bolt_interval)
end

function modifier_zuus_lightning_bolt_linear_cast:OnIntervalThink()
	self.ability:CastLightningBolt(self.caster, self.ability, nil, self.origin + self.direction * self.current_distance)
	self.current_distance = self.current_distance + self.cast_distance_interval

	if self.current_distance > self.max_distance then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end
