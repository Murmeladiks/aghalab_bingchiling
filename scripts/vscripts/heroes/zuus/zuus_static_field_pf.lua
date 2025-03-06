LinkLuaModifier("modifier_zuus_static_field_pf", 								"heroes/zuus/zuus_static_field_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_static_field_pf_attacking_debuff", 				"heroes/zuus/zuus_static_field_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_static_field_pf_active", 						"heroes/zuus/zuus_static_field_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns", 	"heroes/zuus/modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

zuus_static_field_pf = class({})

--------------------------------------------------------------------------------

function zuus_static_field_pf:Spawn()
	if IsClient() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_special_bonus_pathfinder_zuus_autoattack_cooldowns", {})
end

--------------------------------------------------------------------------------

function zuus_static_field_pf:GetIntrinsicModifierName()
	return "modifier_zuus_static_field_pf"
end

--------------------------------------------------------------------------------

function zuus_static_field_pf:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Zuus.StaticFieldActive")

	local zuus_static_field = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(zuus_static_field, 1, caster:GetAbsOrigin() * 100)
	ParticleManager:ReleaseParticleIndex(zuus_static_field)
	caster:AddNewModifier(caster, self, "modifier_zuus_static_field_pf_active", {duration = self:GetSpecialValueFor("active_duration")})
end

--------------------------------------------------------------------------------

modifier_zuus_static_field_pf = class({})

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf:RemoveOnDeath()	return false end
function modifier_zuus_static_field_pf:IsPurgable() 	return false end
function modifier_zuus_static_field_pf:IsHidden() 		return true end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf:OnCreated()
	if IsClient() then return end
	local hAbility = self:GetAbility()

	self.nMinDamage = hAbility:GetSpecialValueFor("damage_health_pct_min_close")
	self.nMaxDamage = hAbility:GetSpecialValueFor("damage_health_pct_max_close")
	self.nMinDistance = hAbility:GetSpecialValueFor("distance_threshold_min")
	self.nMaxDistance = hAbility:GetSpecialValueFor("distance_threshold_max")
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf:OnRefresh()
	if IsClient() then return end
	self:OnCreated()
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf:Damage(target, inflictor, damage_percent_modifier)
	if not IsServer() then return end	
	if self:GetCaster():PassivesDisabled() or not target:IsAlive() or target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
	
	local ability			= self:GetAbility()
	local caster			= self:GetCaster()

	if ability:GetLevel() < 1 then return end
	
	local damage_pct_of_int = ability:GetSpecialValueFor("damage_pct_of_int")
	if damage_percent_modifier then
		damage_pct_of_int = damage_pct_of_int * (damage_percent_modifier / 100)
	end

	local zuus_static_field = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(zuus_static_field, 1, target:GetAbsOrigin() * 100)
	ParticleManager:ReleaseParticleIndex(zuus_static_field)

	local damage = caster:GetIntellect(false) * (damage_pct_of_int / 100)
	local nBonus = 0
	
	if self.nMinDamage > 0 then
		local nDistance = (caster:GetOrigin() - target:GetOrigin()):Length2D()

		if nDistance < self.nMinDistance then
			nBonus = self.nMaxDamage
		elseif nDistance < self.nMaxDistance then
			nBonus = self.nMaxDamage - (self.nMaxDamage - self.nMinDamage) * ((nDistance - self.nMinDistance) / (self.nMaxDistance - self.nMinDistance))
		end
	end

	ApplyDamage({
		attacker = caster,
		victim = target,
		damage = damage * (1 + nBonus / 100),
		damage_type = ability:GetAbilityDamageType(),
		ability = inflictor or ability
	})
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf:DeclareFunctions()
	if IsClient() then return {} end
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf:OnAttackLanded(kv)
	if kv.attacker ~= self:GetParent() then return end
	local ability = self:GetParent():FindAbilityByName("pathfinder_zuus_static_field_attack_arc_lightning")
	local target = kv.target
	if not ability or target:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

	self:Damage(target, nil, ability:GetSpecialValueFor("static_field_damage"))

	if target:IsBuilding() then -- I don't think we should actually cast arc lightning on buildings :/
		if not self:GetParent():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile") then return end
	end
	local attack_modifier = target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_zuus_static_field_pf_attacking_debuff", {})

	if attack_modifier and attack_modifier:GetStackCount() >= ability:GetSpecialValueFor("attack_stack_limit") then
		attack_modifier:Destroy()

		local arc_lightning = self:GetParent():FindAbilityByName("zuus_arc_lightning_pf")
		if arc_lightning and arc_lightning:GetLevel() > 0 then
			self:GetParent():SetCursorCastTarget(target)
			arc_lightning:OnSpellStart()
		end
	end
end

--------------------------------------------------------------------------------

modifier_zuus_static_field_pf_attacking_debuff = class({})

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_attacking_debuff:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_attacking_debuff:OnCreated()
	if IsClient() then return end
	self:SetStackCount(1)
	
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack_number.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0, 1, 0))

	self:AddParticle(self.particle, false, false, -1, false, true)
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_attacking_debuff:OnRefresh()
	if IsClient() then return end
	self:IncrementStackCount()
	ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
end

--------------------------------------------------------------------------------

modifier_zuus_static_field_pf_active = class({})

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:OnCreated()
	if IsClient() then return end
	self:SetStackCount(0)	-- Dont let repeated activations scale Zeus' intelligence to galaxy brain levels!
	self:SetStackCount(self:GetParent():GetIntellect(false) * (self:GetAbility():GetSpecialValueFor("active_int_boost_pct") / 100))
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:OnRefresh()
	self:OnCreated()
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:StatusEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:HeroEffectPriority()
	return 10
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_pf_active:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end