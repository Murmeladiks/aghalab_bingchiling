LinkLuaModifier("modifier_bristleback_quill_raze", 				"heroes/bristleback/quill_spray_pf/modifier_bristleback_quill_raze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_quill_spray_pf", 			"heroes/bristleback/quill_spray_pf/modifier_bristleback_quill_spray_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_defensive_offense", 		"heroes/bristleback/quill_spray_pf/modifier_bristleback_defensive_offense", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_quillspray_thinker_pf", 	"heroes/bristleback/quill_spray_pf/modifier_bristleback_quillspray_thinker_pf", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

bristleback_quill_spray_pf = class({})

--------------------------------------------------------------------------------

function bristleback_quill_spray_pf:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_quill_raze.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_directional.vpcf", context)
end

--------------------------------------------------------------------------------

function bristleback_quill_spray_pf:GetCastRange(vLocation, hTarget)
	local directional_quills = self:GetCaster():FindAbilityByName("pathfinder_bristleback_quill_spray_directional_quills")

	if directional_quills and directional_quills:GetLevel() > 0 then
		return self:GetSpecialValueFor("radius") * (1 + directional_quills:GetSpecialValueFor("range_increase_pct") / 100)
	end
	
	return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------

function bristleback_quill_spray_pf:OnSpellStart()
	self.caster = self:GetCaster()

	-- AbilitySpecials
	self.radius = self:GetSpecialValueFor("radius") -- Note that the particle doesn't seem to support proper radius change so be warned...
	self.projectile_speed = self:GetSpecialValueFor("projectile_speed")


	self:SpawnQuills(self.caster:GetAbsOrigin(), self.caster:GetForwardVector())

	if self.caster:HasAbility("pathfinder_bristleback_quill_spray_pokes_from_the_devil") then
		self:SpawnQuillRaze(self.caster:GetAbsOrigin())
		if self.caster.quilly and not self.caster.quilly:IsNull() and self.caster.quilly:IsAlive() then
			self:SpawnQuillRaze(self.caster.quilly:GetAbsOrigin())
		end
	end

	local defensive_offense = self.caster:FindAbilityByName("pathfinder_bristleback_quill_spray_defensive_offense")
	if defensive_offense and defensive_offense:IsTrained() then
		self.caster:AddNewModifier(self.caster, defensive_offense, "modifier_bristleback_defensive_offense", {duration = defensive_offense:GetSpecialValueFor("duration")})
	end
end

--------------------------------------------------------------------------------

function bristleback_quill_spray_pf:SpawnQuills(vLocation, vDirection, bPassive, hQuilly)
	if self:GetLevel() == 0 then
		return
	end
	if not self.caster then
		self:OnSpellStart()
		return
	end

	if not vDirection then
		vDirection = -self.caster:GetForwardVector()
	end

	-- Calculate amount of time quills should "exist" based on speed and radius
	self.duration = self.radius / self.projectile_speed

	EmitSoundOnLocationWithCaster(vLocation, "Hero_Bristleback.QuillSpray.Cast", self.caster)
	local thinker = CreateModifierThinker(
		self.caster,
		self,
		"modifier_bristleback_quillspray_thinker_pf",
		{
			duration = self.duration,
			dx = vDirection.x,
			dy = vDirection.y,
			bPassive = bPassive,
			quilly = hQuilly and hQuilly:entindex() or nil
		},
		vLocation,
		self.caster:GetTeamNumber(),
		false
	)

	local spell_immunity_duration =
		self.caster:GetSpecialValueFor("pathfinder_bristleback_bristleback_heavy_ordnance", "quill_spray_spell_immunity_duration")

	if self.caster:HasModifier("modifier_bristleback_bristleback_heavy_ordnance") and spell_immunity_duration > 0 and not bPassive then
		if not self.caster:HasModifier("modifier_black_king_bar_immune") then
			self.caster:EmitSound("Hero_Bristleback.SpellImmunity")
		end
		self.caster:AddNewModifier(self.caster, self, "modifier_black_king_bar_immune", {duration = spell_immunity_duration})
	end
end

--------------------------------------------------------------------------------

function bristleback_quill_spray_pf:SpawnQuillRaze(vLocation)
	local quill_raze_shard = self.caster:FindAbilityByName("pathfinder_bristleback_quill_spray_pokes_from_the_devil")
	if not quill_raze_shard or quill_raze_shard:IsNull() then
		return
	end
	local modifier_table = {
		x = vLocation.x,
		y = vLocation.y,
		z = vLocation.z,
		duration = quill_raze_shard:GetSpecialValueFor("delay")
	}

	self.caster:AddNewModifier(self.caster, quill_raze_shard, "modifier_bristleback_quill_raze", modifier_table)
end

--------------------------------------------------------------------------------

function bristleback_quill_spray_pf:DirectionalQuillProjectile(target)
	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		Source = self.caster,
		Ability = self,
		EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
		iMoveSpeed = 900,
		vSourceLoc = self.caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 50,
		bProvidesVision = false,
		iVisionRadius = 0,
		iVisionTeamNumber = self.caster:GetTeamNumber(),
	})
end

--------------------------------------------------------------------------------

function bristleback_quill_spray_pf:OnProjectileHit(hTarget, vLocation)
	if not (hTarget and not hTarget:IsNull()) then return end

	local directional_quills = self.caster:FindAbilityByName("pathfinder_bristleback_quill_spray_directional_quills")
	if directional_quills and directional_quills:IsTrained() then
		hTarget:AddNewModifier(caster, nil, "modifier_knockback", {
			center_x = self.caster:GetAbsOrigin().x,
			center_y = self.caster:GetAbsOrigin().y,
			center_z = self.caster:GetAbsOrigin().z,
			duration = directional_quills:GetSpecialValueFor("knockback_time") * (1 - hTarget:GetStatusResistance()),
			knockback_duration = directional_quills:GetSpecialValueFor("knockback_time") * (1 - hTarget:GetStatusResistance()),
			knockback_distance = directional_quills:GetSpecialValueFor("knockback_distance"),
			knockback_height = 75
		})
		self.caster:PerformAttack(hTarget, true, true, true, true, false, false, true)
	end
end
