modifier_axe_counter_helix_lua = class({})
LinkLuaModifier("modifier_axe_counter_helix_special_fury_checker", "heroes/axe/modifier_axe_counter_helix_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_counter_helix_aura", "heroes/axe/axe_counter_helix_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_counter_helix_special_reduce_damage", "heroes/axe/modifier_axe_counter_helix_lua", LUA_MODIFIER_MOTION_NONE)

function modifier_axe_counter_helix_lua:IsHidden() 		return true end
function modifier_axe_counter_helix_lua:IsPurgable() 	return false end

function modifier_axe_counter_helix_lua:OnCreated( kv )
	self:OnRefresh()
	if not IsServer() then return end
	self:StartIntervalThink(1.5)
end

function modifier_axe_counter_helix_lua:OnRefresh()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self.radius = self.ability:GetSpecialValueFor("radius")
	self.chance = self.ability:GetSpecialValueFor("trigger_chance")

	self.damage_table = {
		victim = nil,
		attacker = self.parent,
		damage = self.ability:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_PURE,
		ability = self.ability,
	}
end

function modifier_axe_counter_helix_lua:OnIntervalThink()
	if self.caster:HasAbility("pathfinder_axe_special_counter_helix_fury") 
	and not self.caster:HasModifier("modifier_axe_counter_helix_special_fury") then
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_axe_counter_helix_special_fury_checker", {})
	end

	if self.caster:HasAbility("pathfinder_axe_special_berseker_call_blink") 
	and not self.caster:HasModifier("modifier_axe_berserkers_call_lua_blink_checker") then
		self.caster:AddNewModifier(self.caster, self, "modifier_axe_berserkers_call_lua_blink_checker", {})
	end

	if self.caster:HasAbility("pathfinder_axe_special_counter_helix_allies") 
	and not self.caster:HasModifier("modifier_axe_counter_helix_aura") then
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_axe_counter_helix_aura", {})
	end
end


function modifier_axe_counter_helix_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_axe_counter_helix_lua:OnAttackLanded( params )	
	if not IsServer() or not self.ability:IsCooldownReady() then return end

	if self.caster:PassivesDisabled() then return end

	local has_talent = self.parent:HasTalent("special_bonus_unique_counter_helix_attack")
	local roll_for_unit = params.target
	local PSEUDO_RANDOM_ID = DOTA_PSEUDO_RANDOM_AXE_HELIX

	if has_talent then
		if params.target ~= self.parent and params.attacker ~= self.parent then return end
	else
		if params.target ~= self.parent then return end
	end

	if has_talent and params.attacker == self.parent then
		roll_for_unit = params.attacker
		PSEUDO_RANDOM_ID = DOTA_PSEUDO_RANDOM_AXE_HELIX_ATTACK
	end
	
	if params.attacker:GetTeamNumber() == params.target:GetTeamNumber() then return end
	
	if params.attacker:IsOther() or params.attacker:IsBuilding() then return end

	if not RollPseudoRandomPercentage(self.chance, PSEUDO_RANDOM_ID, roll_for_unit) then return end

	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),
		self.parent:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		0,
		false
	)

	local reduce_damage_special = self.caster:FindAbilityByName("pathfinder_axe_special_counter_helix_reduce_damage")
	local duration = reduce_damage_special and reduce_damage_special:GetLevelSpecialValueFor("duration", 1) or 0

	for _, enemy in pairs(enemies) do
		self.damage_table.victim = enemy
		ApplyDamage(self.damage_table)			
		
		if reduce_damage_special and enemy and not enemy:IsNull() then
			enemy:AddNewModifier(self.caster, self.ability, "modifier_axe_counter_helix_special_reduce_damage", {
				duration = duration
			})
		end
	end

	if self.parent:GetUnitName()  == "npc_dota_hero_axe" then
		self.ability:UseResources( false, false, false, true )
	end

	self:PlayEffects()
end


function modifier_axe_counter_helix_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"		
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex( effect_cast )
		
	if self.parent:GetUnitName() == "npc_dota_hero_axe" then
		self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	end

	EmitSoundOn("Hero_Axe.CounterHelix", self.parent)
end


function modifier_axe_counter_helix_lua:GetEffectName()
	if self.parent:GetUnitName() ~= "npc_dota_hero_axe" then
		return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
	end
end

function modifier_axe_counter_helix_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_axe_counter_helix_special_fury_checker = class({})
function modifier_axe_counter_helix_special_fury_checker:IsDebuff()			return false end
function modifier_axe_counter_helix_special_fury_checker:IsHidden()			return true end
function modifier_axe_counter_helix_special_fury_checker:RemoveOnDeath()	return false end
function modifier_axe_counter_helix_special_fury_checker:IsPurgable()		return false end


modifier_axe_counter_helix_special_fury = class({})

function modifier_axe_counter_helix_special_fury:IsDebuff()			return false end
function modifier_axe_counter_helix_special_fury:IsHidden()			return true end
function modifier_axe_counter_helix_special_fury:IsPurgable()		return false end
function modifier_axe_counter_helix_special_fury:RemoveOnDeath()	return true end


function modifier_axe_counter_helix_special_fury:OnCreated()
	if not IsServer() then return end	
	
	self:OnRefresh()

	self:StartIntervalThink(self.tick)	
end

function modifier_axe_counter_helix_special_fury:OnRefresh()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	if not IsServer() then return end

	local special = self.caster:FindAbilityByName("pathfinder_axe_special_counter_helix_fury")
	self.tick = special:GetLevelSpecialValueFor("tick", 1)
	self.hp_cost_per_tick = special:GetLevelSpecialValueFor("hp_per_tick", 1)

	self.radius = self.ability:GetSpecialValueFor("radius")	
	self.damage = self.ability:GetSpecialValueFor("damage") / (1 / self.tick)		
	
	self.damage_table = {
		-- victim = target,
		attacker = self.caster,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self.ability
	}

	self.hp_cost_damage_table = {
		victim = self.caster,
		attacker = self.caster,
		damage = 0,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self.ability,
	}
end

function modifier_axe_counter_helix_special_fury:OnIntervalThink()	
	self:PlayEffects()
	self.hp_cost = self.caster:GetMaxHealth() * self.hp_cost_per_tick	

	if self.caster:GetHealth() > self.hp_cost then
		self.hp_cost_damage_table.damage = self.hp_cost
		ApplyDamage(self.hp_cost_damage_table)
	else
		self.ability:ToggleAbility()
	end

	if not self.caster:IsAlive() and self.ability:GetToggleState() then		
		self.ability:ToggleAbility()
	end
end


function modifier_axe_counter_helix_special_fury:GetOverrideAnimation()	
	return ACT_DOTA_CAST3_STATUE
end

function modifier_axe_counter_helix_special_fury:PlayEffects()
	if not IsServer() then return end	

	self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_3)
	local particle_cast = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf"
	local particle_cast2 = "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf"

	local sound_cast = "Hero_Axe.CounterHelix"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	self.parent:EmitSoundParams( sound_cast, 0,0.5,0 )

	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),
		self.caster:GetOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,	
		0,
		false
	)

	local special = self.caster:FindAbilityByName("pathfinder_axe_special_counter_helix_reduce_damage")
	local duration = special and special:GetLevelSpecialValueFor("duration", 1) or 0

	for _, enemy in pairs(enemies) do
		if enemy:GetUnitName() ~= "npc_dota_creature_bonus_greevil" then
			self.damage_table.victim = enemy
			ApplyDamage( self.damage_table )

			if special then
				enemy:AddNewModifier(self.caster, self.ability, "modifier_axe_counter_helix_special_reduce_damage", {
					duration = duration
				})
			end
		end
	end	
end

function modifier_axe_counter_helix_special_fury:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_axe_counter_helix_special_fury:GetModifierMoveSpeedBonus_Percentage()	
	return -1 * self.caster:FindAbilityByName("pathfinder_axe_special_counter_helix_fury"):GetLevelSpecialValueFor("self_slow",1)
end


modifier_axe_counter_helix_special_reduce_damage = class({})
function modifier_axe_counter_helix_special_reduce_damage:IsDebuff()		return true end
function modifier_axe_counter_helix_special_reduce_damage:IsHidden()		return false end
function modifier_axe_counter_helix_special_reduce_damage:RemoveOnDeath()	return true end

function modifier_axe_counter_helix_special_reduce_damage:GetEffectName()
	return "particles/econ/courier/courier_trail_ember/courier_trail_ember.vpcf"
end

function modifier_axe_counter_helix_special_reduce_damage:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self.damage_reduction = -1 * self.caster:FindAbilityByName("pathfinder_axe_special_counter_helix_reduce_damage"):GetLevelSpecialValueFor("percent", 1)
end

function modifier_axe_counter_helix_special_reduce_damage:OnRefresh()
	self:OnCreated()
end

if not IsServer() then return end

function modifier_axe_counter_helix_special_reduce_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_axe_counter_helix_special_reduce_damage:GetModifierDamageOutgoing_Percentage()
	if self.parent:IsAlive() then
		return self.damage_reduction
	end
end

