LinkLuaModifier("modifier_zuus_heavenly_jump_lua", "heroes/zuus/zuus_heavenly_jump_pf", LUA_MODIFIER_MOTION_BOTH )
zuus_heavenly_jump_pf = class({})

function zuus_heavenly_jump_pf:GetAOERadius()
	return self:GetSpecialValueFor("strike_radius")
end

function zuus_heavenly_jump_pf:GetCastRange()
	return self:GetSpecialValueFor("hop_distance")
end

function zuus_heavenly_jump_pf:OnSpellStart()
	local caster = self:GetCaster()
	local hop_destination = self:GetCursorPosition()

	local jump_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_heavenly_jump")
	if not jump_shard or jump_shard:IsNull() then return end
	caster:AddNewModifier(caster, caster:FindAbilityByName("pathfinder_zuus_heavenly_jump"), "modifier_zuus_heavenly_jump_lua", {duration = jump_shard:GetSpecialValueFor("hop_duration"), x = hop_destination.x, y = hop_destination.y, z = hop_destination.z})
	caster:EmitSound("Hero_Zuus.Taunt.Jump")
	ProjectileManager:ProjectileDodge(caster)

	-- Lightning bolt particles: for consistency
	local lightning_bolt = caster:FindAbilityByName("zuus_lightning_bolt_pf")
	if not lightning_bolt or lightning_bolt:GetLevel() < 1 then return end
	local thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(thundergod_spell_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(thundergod_spell_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(thundergod_spell_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(thundergod_spell_cast)
end

modifier_zuus_heavenly_jump_lua	= class({})
function modifier_zuus_heavenly_jump_lua:RemoveOnDeath() return true end
function modifier_zuus_heavenly_jump_lua:IsPurgable() return false end
function modifier_zuus_heavenly_jump_lua:IsHidden()	return true end
function modifier_zuus_heavenly_jump_lua:OnCreated( params )
	if not IsServer() then return end

	self.destination	= Vector(params.x, params.y, params.z)
	self.vector			= (self.destination - self:GetParent():GetAbsOrigin())
	self.direction		= self.vector:Normalized()
	self.speed			= self.vector:Length2D() / self:GetDuration()

	self.hop_height = self:GetAbility():GetSpecialValueFor("hop_height")
	self:GetParent():SetForwardVector(self.direction)

	if self:ApplyVerticalMotionController() == false then 
		self:Destroy()
	end
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
	end
	
	self.interval	= FrameTime()
	
	self:StartIntervalThink(self.interval)
end

-- 0 height is at 0 and self:GetDuration()
function modifier_zuus_heavenly_jump_lua:OnIntervalThink()
	local z_axis = (-1) * self:GetElapsedTime() * (self:GetElapsedTime() - self:GetDuration()) * self.hop_height / math.pow(self:GetDuration() / 2, 2)

	self:GetParent():SetOrigin( (self:GetParent():GetOrigin() * Vector(1, 1, 0)) + (((self.direction * self.speed * self.interval) * Vector(1, 1, 0)) + (Vector(0, 0, GetGroundHeight(self:GetParent():GetOrigin(), nil)) + Vector(0, 0, z_axis) )))
end

function modifier_zuus_heavenly_jump_lua:OnDestroy( kv )
	if not IsServer() then return end
	self:GetParent():InterruptMotionControllers( true )

	local caster = self:GetCaster()
	local jump_shard = caster:FindAbilityByName("pathfinder_zuus_heavenly_jump")
	if not caster or caster:IsNull() or not jump_shard or jump_shard:IsNull() then return end
	local lightning_bolt = caster:FindAbilityByName("zuus_lightning_bolt_pf")
	if not lightning_bolt or lightning_bolt:GetLevel() < 1 then return end

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		jump_shard:GetSpecialValueFor("strike_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_CLOSEST,
		false
	)

	caster:EmitSound("Zuus.HeavenlyJumpWrath")
	if #enemies < jump_shard:GetSpecialValueFor("max_enemy_strike_count") then
		caster:SetCursorCastTarget(caster)
		lightning_bolt:OnSpellStartExternal(caster, caster:GetAbsOrigin() + caster:GetForwardVector())
	end

	local strike_count = (#enemies < jump_shard:GetSpecialValueFor("max_enemy_strike_count")) and 1 or 0
	for _, enemy in pairs(enemies) do
		caster:SetCursorCastTarget(enemy)
		lightning_bolt:OnSpellStartExternal(enemy, enemy:GetAbsOrigin() - enemy:GetForwardVector())
		strike_count = strike_count + 1

		if strike_count >= jump_shard:GetSpecialValueFor("max_enemy_strike_count") then break end
	end
end

function modifier_zuus_heavenly_jump_lua:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end
