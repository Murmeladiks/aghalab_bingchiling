---@class modifier_marci_unleash_lua_fury:CDOTA_Modifier_Lua
modifier_marci_unleash_lua_fury = class({})

function modifier_marci_unleash_lua_fury:IsHidden() return false end
function modifier_marci_unleash_lua_fury:IsDebuff() return false end
function modifier_marci_unleash_lua_fury:IsPurgable() return false end

function modifier_marci_unleash_lua_fury:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

function modifier_marci_unleash_lua_fury:GetModifierAttackSpeed_Limit()
	return 1
end

function modifier_marci_unleash_lua_fury:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_marci_unleash_lua_fury:OnIntervalThink()
	if IsClient() then
		self:UpdateStackParticle()
	else
		-- Combo timer expires
		self:Destroy()

		if self.counters[MARCI_UNLEASH_STACK_DEFAULT] == 0 then return end

		local main = self.parent:FindModifierByName("modifier_marci_unleash_lua")
		if not main then return end

		self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_lua_recovery", 
		{ 
			duration = self.recovery,
			success = true,
		})
	end
end

function modifier_marci_unleash_lua_fury:ForceDestroy()
	self.forced = true
	self:Destroy()
end

function modifier_marci_unleash_lua_fury:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	self.bonus_as = self.ability:GetSpecialValueFor("flurry_bonus_attack_speed")
	self.recovery = self.ability:GetSpecialValueFor("time_between_flurries")
	self.charges = self.ability:GetSpecialValueFor("charges_per_flurry")
	self.timer = self.ability:GetSpecialValueFor("max_time_window_per_hit")

	if IsClient() then
		-- To update stack particle
		self:StartIntervalThink(0)

		self.effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_unleash_lua_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		self:AddParticle(self.effect_cast, false, false, -1, false, true)
		return 
	end

	self.counters = {}
	self.counters[MARCI_UNLEASH_STACK_DISPOSE_STUNNED] = 0
	self.counters[MARCI_UNLEASH_STACK_DEFAULT] = 0
	self.counters[MARCI_UNLEASH_STACK_PASSIVE] = 0
	self.counters[MARCI_UNLEASH_STACK_SIDEKICK] = 0
	self.counters[MARCI_UNLEASH_STACK_COMPANION_RUN] = 0

	local type = kv.type or MARCI_UNLEASH_STACK_DEFAULT
	local charges = type == MARCI_UNLEASH_STACK_DISPOSE_STUNNED and 1 or self.charges
	
	self.counters[type] = charges
	
	local stacks = self:RecalcStackCount()

	self.success = 0

	self:PlayEffects1()
	self.parent:AddActivityModifier("unleash")
end

function modifier_marci_unleash_lua_fury:RecalcStackCount()
	local stacks = 0
	for _, i in ipairs(self.counters) do
		stacks = stacks + i
	end

	self:SetStackCount(stacks)
	return stacks
end

function modifier_marci_unleash_lua_fury:DecrementStacks()
	local stacks = 0
	for k, i in ipairs(self.counters) do
		if i > 0 then

			if k == MARCI_UNLEASH_STACK_DISPOSE_STUNNED then
				break
			end

			self.counters[k] = i - 1

			-- Start recovery when we have 0 stacks from Unleash active
			if k == MARCI_UNLEASH_STACK_DEFAULT and i == 1 then
				local passive_shard = self.caster:FindAbilityByName("pathfinder_marci_unleash_passive")

				-- Check Unleash main modifier
				local main = self.parent:FindModifierByName("modifier_marci_unleash_lua")
				if not main then return end

				self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_unleash_lua_recovery", 
				{ 
					duration = self.recovery,
					success = true,
				})
			end

			break
		end
	end

	return self:RecalcStackCount()
end

function modifier_marci_unleash_lua_fury:RemoveStacks(type)
	self.counters[type] = 0

	local counter = self:RecalcStackCount()

	if counter <= 0 then
		self.success = 1
		self:Destroy()
	end
end

function modifier_marci_unleash_lua_fury:HasStacks(type)
	return self.counters[type] > 0 
end

function modifier_marci_unleash_lua_fury:OnRefresh(kv)
	if IsClient() then return end

	self.charges = self:GetAbility():GetSpecialValueFor("charges_per_flurry")
	local old_stacks = self:GetStackCount()

	self:StartIntervalThink(-1)

	local type = kv.type or MARCI_UNLEASH_STACK_DEFAULT
	local charges = type == MARCI_UNLEASH_STACK_DISPOSE_STUNNED and 1 or self.charges
	
	self.counters[type] = charges

	local stacks = self:RecalcStackCount()

	if old_stacks ~= stacks then
		self:PlayEffects1(true)
	end
end

function modifier_marci_unleash_lua_fury:OnDestroy()
	if IsClient() then return end

	self.parent:ClearActivityModifiers()

	if self.caster ~= self.parent then 
		self.parent:RemoveModifierByName("modifier_marci_unleash_lua_passive")
		return 
	end
end

function modifier_marci_unleash_lua_fury:OnAttack(params)
	if self.parent ~= params.attacker then return end

	if params.no_attack_cooldown and not self.parent:HasModifier("modifier_pathfinder_juggernaut_omni_slash") then return end

	self:StartIntervalThink(self.timer)

	local counter = self:DecrementStacks()
	self:SetStackCount(counter)
	
	local pulse_shard = self.caster:FindAbilityByName("pathfinder_marci_unleash_pulse")
	local is_pulse = pulse_shard and counter % 2 == 0 or counter == 0

	-- Pulse logic in `modifier_marci_unleash_lua_passive` since ranged projectiles can arrive after fury modifier removed
	self.ability.attack_records[params.record] = is_pulse

	self:PlayEffects3(self.parent, params.target)

	if counter <= 0 then
		self.success = 1
		self:Destroy()
	end
end

function modifier_marci_unleash_lua_fury:GetActivityTranslationModifiers()
	if self:GetStackCount() == 1 then
		return "flurry_pulse_attack"
	end

	if self:GetStackCount() % 2 == 0 then
		return "flurry_attack_b"
	end

	return "flurry_attack_a"
end

function modifier_marci_unleash_lua_fury:PlayEffects1(refresh)
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Charged"
	local sound_cast2 = "Hero_Marci.Unleash.Charged.2D"

	if not refresh then
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"eye_l",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			2,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"eye_r",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			3,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_attack1",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			4,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_attack2",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			5,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_attack1",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			6,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_attack2",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
	end

	EmitSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_cast2, self:GetParent() )
end

function modifier_marci_unleash_lua_fury:PlayEffects3(caster, target)
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf"

	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex(effect_cast)
end

function modifier_marci_unleash_lua_fury:UpdateStackParticle()
	local parent = self:GetParent()
	local count = self:GetStackCount()

	local digit = count % 10
	local digit2 = math.floor(count / 10)

	local offset = digit2 > 0 and 8 or 0
	digit2 = digit2 == 0 and -1 or digit2

	ParticleManager:SetParticleControl(self.effect_cast, 1, Vector(0, digit, 0))
	ParticleManager:SetParticleControl(self.effect_cast, 7, Vector(0, digit2, 0))
	ParticleManager:SetParticleControl(self.effect_cast, 9, Vector(offset, 0, 0))
end

function modifier_marci_unleash_lua_fury:ShouldUseOverheadOffset()
	return true
end