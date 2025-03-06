LinkLuaModifier("modifier_bristleback_achoo_achoo",						"heroes/bristleback/viscous_nasal_goo_pf/modifier_bristleback_achoo_achoo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_achoo_achoo_effect", 				"heroes/bristleback/viscous_nasal_goo_pf/modifier_bristleback_achoo_achoo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bloody_rage_debuff", 				"heroes/bristleback/viscous_nasal_goo_pf/modifier_bristleback_bloody_rage_debuff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_pf", 			"heroes/bristleback/viscous_nasal_goo_pf/modifier_bristleback_viscous_nasal_goo_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_pf_intrinsic", 	"heroes/bristleback/viscous_nasal_goo_pf/modifier_bristleback_viscous_nasal_goo_pf_intrinsic", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

bristleback_viscous_nasal_goo_pf = class({})

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:Precache( context )
	
	PrecacheResource("particle", "particles/status_fx/status_effect_goo.vpcf", context)
	PrecacheResource("particle", "particles/heroes/bristleback/bristle_spikey_quill_spray_sparks.vpcf", context)
	PrecacheResource("particle", "particles/heroes/bristleback/bristleback_bloody_goo_status_effect.vpcf", context)
	PrecacheResource("particle", "particles/heroes/bristleback/bristleback_bloody_goo_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", context)
	PrecacheResource("particle", "particles/heroes/bristleback/bristleback_bloody_stack.vpcf", context)	
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_bloody_nasal_goo.vpcf", context)
end

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:GetIntrinsicModifierName()
	return "modifier_bristleback_viscous_nasal_goo_pf_intrinsic"
end

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:Spawn()
	if IsClient() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_achoo_achoo", {})
end

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:GetBehavior()
	local behaviour = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	if self:GetCaster():HasAbility("pathfinder_bristleback_viscous_nasal_goo_bloody_rage") then
		behaviour = behaviour + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return behaviour
end

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:GetAOERadius()
	local radius = 0
	local bloody_goo = self:GetCaster():FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_bloody_rage")
	if bloody_goo and not bloody_goo:IsNull() then
		radius = radius + bloody_goo:GetSpecialValueFor("splash_radius")
	end
	return radius
end

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:OnSpellStart()
	self.caster = self:GetCaster()

	-- AbilitySpecials
	self.goo_speed = self:GetSpecialValueFor("goo_speed")
	self.goo_duration = self:GetSpecialValueFor("goo_duration")
	self.base_armor = self:GetSpecialValueFor("base_armor")
	self.armor_per_stack = self:GetSpecialValueFor("armor_per_stack")
	self.base_move_slow = self:GetSpecialValueFor("base_move_slow")
	self.move_slow_per_stack = self:GetSpecialValueFor("move_slow_per_stack")
	self.radius_scepter = self:GetSpecialValueFor("radius_scepter")

	if not IsServer() then return end

	self:ViscousNasalGoo(self:GetCursorTarget(), true)
	if self.caster:GetName() == "npc_dota_hero_bristleback" and RollPercentage(40) then
		self.caster:EmitSound("bristleback_bristle_nasal_goo_0" .. math.random(1, 7))
	end
end

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:ViscousNasalGoo(hTarget, primary_cast, secondary_cast, hSource)
	if not self.caster then
		self:OnSpellStart()
		return
	end

	self.caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")
	local projectile = {
		Target = hTarget,
		Source = self.caster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
		iMoveSpeed = self.goo_speed,
		vSourceLoc = self.caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 50,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = self.caster:GetTeamNumber(),
		ExtraData = {
			primary_cast = primary_cast and 1 or 0,
			secondary_cast = secondary_cast and 1 or 0
		}
	}
	if self.caster:HasAbility("pathfinder_bristleback_viscous_nasal_goo_bloody_rage") then
		projectile.EffectName = "particles/units/heroes/hero_bristleback/bristleback_bloody_nasal_goo.vpcf"
	end
	if hSource then
		projectile.Source = hSource
		projectile.vSourceLoc = hSource:GetAbsOrigin()
	end

	ProjectileManager:CreateTrackingProjectile(projectile)

	if primary_cast and self.caster:HasAbility("pathfinder_bristleback_viscous_nasal_goo_achoo_achoo") then
		local achoo_modifier = self.caster:FindModifierByName("modifier_bristleback_achoo_achoo")
		local achoo_achoo_stack = achoo_modifier:GetStackCount()
		
		if achoo_achoo_stack > 0 then
			self.caster:AddNewModifier(self.caster, self, "modifier_bristleback_achoo_achoo_effect", {}):SetStackCount(achoo_achoo_stack)
			achoo_modifier:SetStackCount(0)
		end
	end
end

--------------------------------------------------------------------------------

function bristleback_viscous_nasal_goo_pf:OnProjectileHit_ExtraData(hTarget, vLocation, table)
	if hTarget == nil or not hTarget:IsAlive() or hTarget:IsMagicImmune() then return end
		
	-- Stop if target has linkens
	if hTarget:TriggerSpellAbsorb(self) then
		return
	end

	local goo_modifier =
		hTarget:AddNewModifier(
		self.caster,
		self,
		"modifier_bristleback_viscous_nasal_goo_pf",
		{duration = self.goo_duration * (1 - hTarget:GetStatusResistance())}
	)

	hTarget:EmitSound("Hero_Bristleback.ViscousGoo.Target")

	if self.caster:HasAbility("pathfinder_bristleback_viscous_nasal_goo_achoo_achoo") then
		if table["primary_cast"] == 1 then
			self.caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
			self.caster:PerformAttack(hTarget, true, true, true, true, false, false, false)
			self.caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		end

		local achoo_achoo_shard = self.caster:FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_achoo_achoo")
		hTarget:AddNewModifier(self.caster, self, "modifier_stunned", {duration = (1 - hTarget:GetStatusResistance()) * achoo_achoo_shard:GetSpecialValueFor("stun_duration_base") + achoo_achoo_shard:GetSpecialValueFor("stun_duration_per_stack") * (goo_modifier:GetStackCount() - 1)})
	end

	local bloody_goo = self.caster:FindAbilityByName("pathfinder_bristleback_viscous_nasal_goo_bloody_rage")
	if bloody_goo and bloody_goo:IsTrained() then
		if not hTarget:IsBoss() and hTarget:GetUnitName() ~= "npc_dota_creature_bonus_chicken" then
			hTarget:AddNewModifier(self.caster, self, "modifier_bristleback_bloody_rage_debuff", {duration = bloody_goo:GetSpecialValueFor("taunt_duration")})
		end
		
		if table["secondary_cast"] == 0 then
			--[[local enemies = FindUnitsInRadius(
				self.caster:GetTeamNumber(),
				hTarget:GetAbsOrigin(),
				nil,
				bloody_goo:GetSpecialValueFor("splash_radius"),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			for _, unit in pairs(enemies) do
				if unit ~= hTarget then
					unit:AddNewModifier(
						self.caster,
						self,
						"modifier_bristleback_viscous_nasal_goo_pf",
						{duration = self.goo_duration * (1 - unit:GetStatusResistance())}
					)
					unit:AddNewModifier(self.caster, self, "modifier_bristleback_bloody_rage_debuff", {duration = bloody_goo:GetSpecialValueFor("taunt_duration")})
				end
			end

			local bloody_goo_splash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_infest_emerge_bloody.vpcf", PATTACH_WORLDORIGIN, self.caster)
			ParticleManager:SetParticleControl(bloody_goo_splash_pfx, 0, hTarget:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(bloody_goo_splash_pfx)]]

			local enemies_outer = FindUnitsInRadius(
				self.caster:GetTeamNumber(),
				hTarget:GetAbsOrigin(),
				nil,
				bloody_goo:GetSpecialValueFor("secondary_projectile_radius"),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
			local secondary_projectile_fired = 0
			for _, unit in pairs(enemies_outer) do
				--if unit:GetRangeToUnit(hTarget) > bloody_goo:GetSpecialValueFor("splash_radius") then
					self:ViscousNasalGoo(unit, false, true, hTarget)
					secondary_projectile_fired = secondary_projectile_fired + 1

					if secondary_projectile_fired >= bloody_goo:GetSpecialValueFor("secondary_projectile_count") then
						break
					end
				--end
			end
		end
	end
end