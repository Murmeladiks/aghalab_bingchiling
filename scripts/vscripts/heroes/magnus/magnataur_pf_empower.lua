
LinkLuaModifier("modifier_magnataur_pf_empower", "heroes/magnus/magnataur_pf_empower", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

magnataur_pf_empower = class({})

--------------------------------------------------------------------------------

function magnataur_pf_empower:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_secondary_hit.vpcf", context)
end

--------------------------------------------------------------------------------

function magnataur_pf_empower:GetAOERadius()
	if self:GetCaster():FindAbilityByName("aghsfort_special_magnataur_empower_charges") ~= nil then
		return self:GetCaster():FindAbilityByName("magnataur_pf_reverse_polarity"):GetSpecialValueFor("pull_radius") * 0.5
	end

	return 0
end

--------------------------------------------------------------------------------

function magnataur_pf_empower:GetBehavior()
	if self:GetCaster():FindAbilityByName("aghsfort_special_magnataur_empower_charges") ~= nil then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return self.BaseClass.GetBehavior(self)
end

--------------------------------------------------------------------------------

function magnataur_pf_empower:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	hTarget:AddNewModifier(hCaster, self, "modifier_magnataur_pf_empower", {duration = self:GetSpecialValueFor("empower_duration")})

	hCaster:EmitSound("Hero_Magnataur.Empower.Cast")
	hTarget:EmitSound("Hero_Magnataur.Empower.Target")

	if self:GetCaster():FindAbilityByName("aghsfort_special_magnataur_empower_charges") == nil then return end

	local hRP = hCaster:FindAbilityByName("magnataur_pf_reverse_polarity")

	if not hRP or not hRP:IsTrained() then return end

	local nStrength = 50 / 100

	local nPolarityFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(nPolarityFX, 1, Vector(hRP:GetSpecialValueFor("pull_radius") * nStrength, 0, 0))
	ParticleManager:SetParticleControl(nPolarityFX, 2, Vector(0.2, 0, 0))
	ParticleManager:SetParticleControlEnt(nPolarityFX, 3, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:ReleaseParticleIndex(nPolarityFX)

	Timers:CreateTimer(0.2, function()
		hRP:ReversePolarity(hTarget, nStrength)
	end)
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_empower = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:IsPurgable()	return false end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:OnCreated()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	self.nDamagePct = hAbility:GetSpecialValueFor("bonus_damage_pct")
	self.nCleavePct = hAbility:GetSpecialValueFor("cleave_damage_pct")
	self.nStartWidth = hAbility:GetSpecialValueFor("cleave_starting_width")
	self.nEndWidth = hAbility:GetSpecialValueFor("cleave_ending_width")
	self.nDistance = hAbility:GetSpecialValueFor("cleave_distance")

	self.nLifesteal = 10
	self.nShockwaveChance = 20
	self.nShockwaveCooldown = 3

	self.bCanShockwave = true

	if hCaster ~= self:GetParent() then return end

	local nSelfMult = hAbility:GetSpecialValueFor("self_multiplier") / 100 + 1

	self.nDamagePct = self.nDamagePct * nSelfMult
	self.nCleavePct = self.nCleavePct * nSelfMult
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:OnRefresh()
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()

	self.nDamagePct = hAbility:GetSpecialValueFor("bonus_damage_pct")
	self.nCleavePct = hAbility:GetSpecialValueFor("cleave_damage_pct")

	if hCaster ~= self:GetParent() then return end

	local nSelfMult = hAbility:GetSpecialValueFor("self_multiplier") / 100 + 1

	self.nDamagePct = self.nDamagePct * nSelfMult
	self.nCleavePct = self.nCleavePct * nSelfMult
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:OnIntervalThink()
	self:StartIntervalThink(-1)
	self.bCanShockwave = true
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:GetModifierBaseDamageOutgoing_Percentage()
	return self.nDamagePct
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:OnAttacked(event)
	if IsClient() then return end
	local hAttacker = event.attacker

	if hAttacker == self:GetParent() and event.target ~= nil and self.nLifesteal > 0 then
		local nHeal = ( event.damage * self.nLifesteal / 100 )
		hAttacker:HealWithParams(nHeal, self:GetAbility(), true, true, self:GetCaster(), false)

		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
		)
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:OnAttackLanded(event)
	if IsClient() then return end
	local hAttacker = event.attacker
	if hAttacker == self:GetParent() and (not hAttacker:IsIllusion()) then
		local hTarget = event.target

		if hTarget and hTarget:GetTeamNumber() ~= hAttacker:GetTeamNumber() and not hAttacker:IsRangedAttacker() and not hTarget:IsBuilding() and not hTarget:IsOther() then
			DoCleaveAttack(hAttacker, hTarget, self:GetAbility(), event.damage * self.nCleavePct / 100, self.nStartWidth, self.nEndWidth, self.nDistance, "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf")
			
			if self:GetCaster():FindAbilityByName("aghsfort_special_magnataur_empower_shockwave_on_attack") ~= nil then
				self:AttemptShockwave(hTarget)
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:GetModifierBaseDamageOutgoing_Percentage()
	return self.nDamagePct
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:AttemptShockwave(hTarget)
	if not self.bCanShockwave or not RollPseudoRandomPercentage(self.nShockwaveChance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_3, self:GetParent()) then return end

	local hShockwave = self:GetCaster():FindAbilityByName("magnataur_pf_shockwave")

	if not hShockwave or not hShockwave:IsTrained() then return end

	local hParent = self:GetParent()
	local vOrigin = hParent:GetOrigin()

	hShockwave:SendShockwave(hTarget:GetOrigin(), 100, vOrigin, false)

	self.bCanShockwave = false
	self:StartIntervalThink(self.nShockwaveCooldown)
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:OnTooltip()
	return self.nCleavePct
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_empower:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_empower.vpcf"
end