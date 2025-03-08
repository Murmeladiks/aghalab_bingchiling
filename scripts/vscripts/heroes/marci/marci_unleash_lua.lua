---@class marci_unleash_lua:CDOTA_Ability_Lua
marci_unleash_lua = class({})
LinkLuaModifier( "modifier_marci_unleash_lua", "heroes/marci/modifier_marci_unleash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_passive", "heroes/marci/marci_unleash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_fury", "heroes/marci/modifier_marci_unleash_lua_fury", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_debuff", "heroes/marci/modifier_marci_unleash_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_lua_recovery", "heroes/marci/modifier_marci_unleash_lua_recovery", LUA_MODIFIER_MOTION_NONE )

-- Stacks with lower enum value used first
_G.MARCI_UNLEASH_STACK_DISPOSE_STUNNED = 1 -- Attacking Dispose stunned unit
_G.MARCI_UNLEASH_STACK_DEFAULT = 2 -- Unleash cast
_G.MARCI_UNLEASH_STACK_PASSIVE = 3 -- Unleash passive shard
_G.MARCI_UNLEASH_STACK_SIDEKICK = 4 -- Sidekick + bash shard
_G.MARCI_UNLEASH_STACK_COMPANION_RUN = 5 -- Rebound + Unleash shard

function marci_unleash_lua:Precache(context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_marci.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_lua_stack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
end

function marci_unleash_lua:Spawn()
	if IsClient() then return end
	self.attack_records = {}
end

function marci_unleash_lua:GetIntrinsicModifierName()
	return "modifier_marci_unleash_lua_passive"
end

function marci_unleash_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_marci_unleash_lua", { duration = duration } )
end

modifier_marci_unleash_lua_passive = class({})

function modifier_marci_unleash_lua_passive:IsHidden() return true end
function modifier_marci_unleash_lua_passive:IsPurgable() return false end
function modifier_marci_unleash_lua_passive:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_marci_unleash_lua_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY
	}

	return funcs
end

function modifier_marci_unleash_lua_passive:GetModifierProcAttack_Feedback(params)
	local ability = self:GetAbility()
	local parent = self:GetParent()

	if params.no_attack_cooldown then return end

	if ability.attack_records[params.record] then
		self:Pulse(params.target:GetOrigin())
	end

	if ability.attack_records[params.record] ~= nil and params.attacker == parent then
		self:BashPulse(params.target:GetOrigin())
	end
end

function modifier_marci_unleash_lua_passive:OnAttackRecordDestroy(params)
	local ability = self:GetAbility()
	ability.attack_records[params.record] = nil
end

function modifier_marci_unleash_lua_passive:BashPulse(center)
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local bash_shard = caster:GetHeroFacetID() == 1 and caster:FindAbilityByName("pathfinder_marci_unleash_bash") or caster:FindAbilityByName("pathfinder_marci_unleash_bash_bodyguard")

	if bash_shard then
		local chance = bash_shard:GetSpecialValueFor("chance")
		
		if RollPercentage(chance) then
			local radius = bash_shard:GetSpecialValueFor("bash_radius")
			local duration = bash_shard:GetSpecialValueFor("bash_duration")

			local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
				center,
				nil,
				radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				0,
				0,
				false
			)

			for _, unit in pairs(enemies) do
				unit:AddNewModifier(parent, ability, "modifier_bashed", { duration = duration })
			end

			self:PlayEffects3(center, radius)
		end
	end
end

function modifier_marci_unleash_lua_passive:Pulse(center)
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local caster = self:GetCaster()

	local radius = self:GetAbility():GetSpecialValueFor("pulse_radius")
	local damage = self:GetAbility():GetSpecialValueFor("pulse_damage")
	local duration = self:GetAbility():GetSpecialValueFor("pulse_debuff_duration")

	local enemies = FindUnitsInRadius(
		parent:GetTeamNumber(),
		center,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	local damageTable = {
		-- victim = target,
		attacker = parent,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
	}

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		enemy:AddNewModifier(parent, ability, "modifier_marci_unleash_lua_debuff", { duration = duration })
	end

	self:PlayEffects(center, radius)

	local pulse_shard = caster:FindAbilityByName("pathfinder_marci_unleash_pulse")
	if not pulse_shard then return end

	local friends = FindUnitsInRadius(
		parent:GetTeamNumber(),
		center,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	local heal = damage * pulse_shard:GetSpecialValueFor("health_percent_damage") * 0.01

	for _,unit in pairs(friends) do
		unit:Heal(heal, ability)

		local pFX = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_healing_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:ReleaseParticleIndex(pFX)
	end

	self:PlayEffects2(center, radius)
end

function modifier_marci_unleash_lua_passive:PlayEffects(point, radius)
	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf"
	local sound_cast = "Hero_Marci.Unleash.Pulse"

	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, point)
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius,radius,radius))
	ParticleManager:ReleaseParticleIndex(effect_cast)

	EmitSoundOnLocationWithCaster(point, sound_cast, self:GetParent())
end

function modifier_marci_unleash_lua_passive:PlayEffects2(point, radius)
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_damage.vpcf"

	radius = radius - 200

	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, point)
	ParticleManager:SetParticleControl(effect_cast, 1, point)
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(radius,radius,radius))
	ParticleManager:ReleaseParticleIndex(effect_cast)
end

function modifier_marci_unleash_lua_passive:PlayEffects3(point, radius)
	local nFXIndex = ParticleManager:CreateParticle("particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(nFXIndex, 0, point)
	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(radius,radius,radius))
	ParticleManager:ReleaseParticleIndex(nFXIndex)

	EmitSoundOnLocationWithCaster(point, "OgreTank.GroundSmash.Lesser", self:GetParent())
end