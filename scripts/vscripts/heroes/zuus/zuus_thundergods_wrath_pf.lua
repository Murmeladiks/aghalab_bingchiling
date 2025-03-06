LinkLuaModifier("modifier_zuus_thundergods_wrath_pf", 				"heroes/zuus/zuus_thundergods_wrath_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_pf_ground_target", "heroes/zuus/zuus_thundergods_wrath_pf", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

zuus_thundergods_wrath_pf = class({})

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:GetIntrinsicModifierName()
	return "modifier_zuus_thundergods_wrath_pf"
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:GetCastRange()
	local ground_target_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_thundergods_wrath_ground_target")

	if ground_target_shard then
		return ground_target_shard:GetSpecialValueFor("wrath_cast_range")
	end

    return 0
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:GetBehavior()
	local behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET

	if self:GetCaster():FindAbilityByName("pathfinder_zuus_thundergods_wrath_ground_target") then
		behavior = DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
	if self:GetCaster():FindAbilityByName("pathfinder_zuus_thundergods_wrath_autosmite") then
		behavior = behavior + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end

	return behavior
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath.PreCast")

	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))

	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.thundergod_spell_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.thundergod_spell_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.thundergod_spell_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)

	return true
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:OnSpellStart()
	local hCaster = self:GetCaster()
    local radius 	            = self:GetSpecialValueFor("radius")
    local position 				= hCaster:GetAbsOrigin()
	local spell_immunity_duration = self:GetSpecialValueFor("bkb_duration")	

    if self.thundergod_spell_cast then
        ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
    end

	if hCaster:FindAbilityByName("pathfinder_zuus_thundergods_wrath_ground_target") then
		position = self:GetCursorPosition()
	end

	if spell_immunity_duration > 0 then
		hCaster:EmitSound("DOTA_Item.BlackKingBar.Activate")
		hCaster:AddNewModifier(hCaster, self, "modifier_black_king_bar_immune", {duration = spell_immunity_duration})
	end

    self:CastWrath(position, radius)    
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:CastWrath(position, radius, multi_strike_payload)
	self.nDamageGrow = 1
    local caster = self:GetCaster()

	local ground_target_shard = caster:FindAbilityByName("pathfinder_zuus_thundergods_wrath_ground_target")
	local multi_strike_shard = caster:FindAbilityByName("pathfinder_zuus_thundergods_wrath_multistrike")
	local strike_damage_modifier = 100

    caster:EmitSound("Hero_Zuus.GodsWrath")
    self.damage_table 			= {}
    self.damage_table.attacker 		= caster
    self.damage_table.ability 		= self
    self.damage_table.damage_type 	= self:GetAbilityDamageType()

    local targets = FindUnitsInRadius(
        caster:GetTeamNumber(), 
        position, 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_ANY_ORDER, false
	)

	if self:GetSpecialValueFor("grow_kill_amp") > 0 then
		table.sort(targets, function(a,b) return a:GetHealth() < b:GetHealth() end)
	end
    
	local have_striked = false
	local strike_round = (multi_strike_payload and multi_strike_payload.strike_round) or 0
	local strike_count = (multi_strike_payload and multi_strike_payload.strike_count) or 0

	if multi_strike_shard and not multi_strike_shard:IsNull() then
		strike_damage_modifier = strike_damage_modifier * (math.pow(multi_strike_shard:GetSpecialValueFor("subsequent_strike_damage_multiplier") / 100, strike_round))
	end

    for _, target in pairs(targets) do 
		have_striked = true
		Timers:CreateTimer(self:GetSpecialValueFor("growing_delay") * strike_count, function()
			self:Smite(target, strike_damage_modifier)
		end)
		strike_count = strike_count + 1
    end

	if ground_target_shard then
		local aoe_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(aoe_particle, 0, position + Vector(0, 0, 2000))
		ParticleManager:SetParticleControl(aoe_particle, 1, position)
		ParticleManager:SetParticleControl(aoe_particle, 2, position)
		ParticleManager:SetParticleControl(aoe_particle, 7, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(aoe_particle)

		if #targets >= ground_target_shard:GetSpecialValueFor("minimum_unit_recast") then
			caster:AddNewModifier(caster, self, "modifier_zuus_thundergods_wrath_pf_ground_target", {duration = ground_target_shard:GetSpecialValueFor("recast_delay"), radius = radius / 2, x = position.x, y = position.y, z = position.z})
		end
	end

	if not have_striked then return end
	if not multi_strike_shard or multi_strike_shard:IsNull() then return end
	if strike_count >= multi_strike_shard:GetSpecialValueFor("strikes_minimum") then return end

	caster:AddNewModifier(caster, self, "modifier_zuus_thundergods_wrath_pf_ground_target", {duration = multi_strike_shard:GetSpecialValueFor("recast_delay"), radius = radius, x = position.x, y = position.y, z = position.z, strike_count = strike_count, strike_round = strike_round})
end

--------------------------------------------------------------------------------

function zuus_thundergods_wrath_pf:Smite(target, damage_percent_modifier)
    local caster = self:GetCaster()
    local target_point = target:GetAbsOrigin()
    local sight_duration = self:GetSpecialValueFor("sight_duration")
    local true_sight_radius = self:GetSpecialValueFor("true_sight_radius")

	if not target or target:IsNull() then return end

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, target)
    ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
    ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, target_point.z + 2000))
    ParticleManager:ReleaseParticleIndex(particle)

    if (not target:IsMagicImmune()) and (not target:IsInvisible() or caster:CanEntityBeSeenByMyTeam(target)) then
        if caster:HasModifier("modifier_zuus_static_field_pf") then
            caster:FindModifierByName("modifier_zuus_static_field_pf"):Damage(target, self)
        end
        
        self.damage_table.damage  = self:GetSpecialValueFor("damage") * self.nDamageGrow
        self.damage_table.victim  = target

		if damage_percent_modifier then
			self.damage_table.damage = self.damage_table.damage * (damage_percent_modifier / 100)
		end

        ApplyDamage(self.damage_table)

		if not target:IsAlive() and self:GetSpecialValueFor("grow_kill_amp") then
			self.nDamageGrow = self.nDamageGrow + self:GetSpecialValueFor("grow_kill_amp") / 100
		end
    end

    target:EmitSound("Hero_Zuus.GodsWrath.Target")
    AddFOWViewer(caster:GetTeam(), target_point, true_sight_radius, sight_duration, false)
    
    local dummy_unit = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, 0), false, nil, nil, caster:GetTeam())
	local true_sight = dummy_unit:AddNewModifier(caster, self, "modifier_zuus_lightning_true_sight_pf", {duration = sight_duration})
	true_sight:SetStackCount(true_sight_radius)
	dummy_unit:SetDayTimeVisionRange(true_sight_radius)
	dummy_unit:SetNightTimeVisionRange(true_sight_radius)
	dummy_unit:AddNewModifier(caster, nil, "modifier_zuus_lightning_dummy_pf", {})
	dummy_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = sight_duration + 1})
end

--------------------------------------------------------------------------------

modifier_zuus_thundergods_wrath_pf = class({})

--------------------------------------------------------------------------------

function modifier_zuus_thundergods_wrath_pf:RemoveOnDeath() return false end
function modifier_zuus_thundergods_wrath_pf:IsPurgable() 	return false end
function modifier_zuus_thundergods_wrath_pf:IsHidden() 		return true end

--------------------------------------------------------------------------------

function modifier_zuus_thundergods_wrath_pf:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(1)
	self:GetAbility():ToggleAutoCast()
end

--------------------------------------------------------------------------------

function modifier_zuus_thundergods_wrath_pf:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	if not ability or ability:IsNull() or ability:GetLevel() < 1 then return end
	if not caster or caster:IsNull() or not caster:IsAlive() then return end

	if not ability.damage_table then
		ability.damage_table 			= {}
		ability.damage_table.attacker 		= caster
		ability.damage_table.ability 		= ability
		ability.damage_table.damage_type 	= ability:GetAbilityDamageType()
	end

	local autosmite_shard = caster:FindAbilityByName("pathfinder_zuus_thundergods_wrath_autosmite")
	if not autosmite_shard or autosmite_shard:IsNull() or autosmite_shard:GetLevel() < 1 then return end
	self:StartIntervalThink(autosmite_shard:GetSpecialValueFor("delay"))

	if caster:GetManaPercent() < autosmite_shard:GetSpecialValueFor("max_mana_smite_cost_pct") then return end
	if ability:GetAutoCastState() and RollPercentage(autosmite_shard:GetSpecialValueFor("proc_chance")) then
		local targets = FindUnitsInRadius(
			caster:GetTeamNumber(), 
			caster:GetAbsOrigin(), 
			nil, 
			FIND_UNITS_EVERYWHERE, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 
			FIND_ANY_ORDER, false)
		
		if #targets > 0 then
			ability:Smite(targets[1], autosmite_shard:GetSpecialValueFor("smite_damage_modifier"))
			--print(caster:GetMaxMana() * (autosmite_shard:GetSpecialValueFor("max_mana_smite_cost_pct") / 100))
			caster:SpendMana(caster:GetMaxMana() * (autosmite_shard:GetSpecialValueFor("max_mana_smite_cost_pct") / 100), ability)
		end
	end
end

--------------------------------------------------------------------------------

modifier_zuus_thundergods_wrath_pf_ground_target = class({})

--------------------------------------------------------------------------------

function modifier_zuus_thundergods_wrath_pf_ground_target:RemoveOnDeath() 	return false end
function modifier_zuus_thundergods_wrath_pf_ground_target:IsPurgable()	 	return false end
function modifier_zuus_thundergods_wrath_pf_ground_target:IsHidden() 		return true end
function modifier_zuus_thundergods_wrath_pf_ground_target:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function modifier_zuus_thundergods_wrath_pf_ground_target:OnCreated(kv)
	if IsClient() then return end
	self.position = Vector(kv.x, kv.y, kv.z)
	self.radius = kv.radius
	self.strike_count = kv.strike_count or 0
	self.strike_round = (kv.strike_round and (kv.strike_round + 1)) or 0
end

--------------------------------------------------------------------------------

function modifier_zuus_thundergods_wrath_pf_ground_target:OnDestroy()
	if IsClient() then return end
	if not self:GetAbility() or self:GetAbility():IsNull() then return end

	local new_multi_strike_payload = {
		strike_count = self.strike_count,
		strike_round = self.strike_round,
	}

	self:GetAbility():CastWrath(self.position, self.radius, new_multi_strike_payload)
end