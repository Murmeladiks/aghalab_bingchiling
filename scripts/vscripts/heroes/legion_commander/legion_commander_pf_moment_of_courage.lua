LinkLuaModifier("modifier_legion_commander_pf_moment_of_courage", 			"heroes/legion_commander/legion_commander_pf_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_moment_of_courage_lifesteal", "heroes/legion_commander/legion_commander_pf_moment_of_courage", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

legion_commander_pf_moment_of_courage = class({})

--------------------------------------------------------------------------------

function legion_commander_pf_moment_of_courage:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_courage_tgt.vpcf", context)
end

--------------------------------------------------------------------------------

function legion_commander_pf_moment_of_courage:GetIntrinsicModifierName()
	return "modifier_legion_commander_pf_moment_of_courage"
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_moment_of_courage = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage:IsHidden() 		return true end
function modifier_legion_commander_pf_moment_of_courage:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage:OnCreated()
	self.nBuffDuration = self:GetAbility():GetSpecialValueFor("buff_duration")
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage:OnAttackStart(event)
	if IsClient() or event.target ~= self:GetParent() then return end

	local hTarget = event.target
	local hAbility = self:GetAbility()

	if not hAbility:IsCooldownReady() or hTarget:PassivesDisabled() or not RollPseudoRandomPercentage(hAbility:GetSpecialValueFor("trigger_chance"), DOTA_PSEUDO_RANDOM_LEGION_MOMENT, hTarget) then return end

	hTarget:AddNewModifier(self:GetCaster(), hAbility, "modifier_legion_commander_pf_moment_of_courage_lifesteal", {duration = self.nBuffDuration})
	hAbility:UseResources(false, false, false, true)
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_moment_of_courage_lifesteal = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage_lifesteal:IsPurgable() 	return false end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage_lifesteal:OnCreated()
	self.nLifesteal = self:GetAbility():GetSpecialValueFor("hp_leech_percent") / 100
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage_lifesteal:MomentOfCourage(hTarget, nDamage)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	hParent:HealWithParams(self.nLifesteal * nDamage, hAbility, true, true, hParent, false)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hParent, self.nLifesteal * nDamage, hParent)

	if hParent:HasShard("pathfinder_special_lc_moment_aoe") then
		local nRadius = hParent:FindTalentValue("pathfinder_special_lc_moment_aoe", "radius")
		local nTargets = hParent:FindTalentValue("pathfinder_special_lc_moment_aoe", "extra_targets")

		local hEnemies = FindUnitsInRadius(hParent:GetTeam(), hParent:GetOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)

		for _, hEnemy in pairs(hEnemies) do
			if hEnemy ~= hTarget then
				hParent:PerformAttack(hEnemy, false, true, true, false, false, false, false)
				hParent:HealWithParams(self.nLifesteal * nDamage, hAbility, true, true, hParent, false)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hParent, self.nLifesteal * nDamage, hParent)

				nTargets = nTargets - 1

				if nTargets <= 0 then break end
			end
		end
	end

	local nAttackFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(nAttackFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:SetParticleControl(nAttackFX, 2, Vector(0, hParent:GetHullRadius(), 0))
	ParticleManager:ReleaseParticleIndex(nAttackFX)

	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_courage_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	)

	hParent:EmitSound("Hero_LegionCommander.Courage")
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage_lifesteal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage_lifesteal:GetModifierAttackSpeedBonus_Constant()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_moment_of_courage_lifesteal:OnDamageCalculated(event)
	if IsServer() then
		if event.attacker ~= self:GetParent() or event.no_attack_cooldown then
			return 0
		end

		self:MomentOfCourage(event.target, event.damage)

		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- yes its probably wrong; fuckoff now
function modifier_legion_commander_pf_moment_of_courage_lifesteal:GetActivityTranslationModifiers()
	return "ACT_DOTA_MOMENT_OF_COURAGE"
end