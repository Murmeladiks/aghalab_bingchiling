LinkLuaModifier("modifier_magnataur_pf_skewer", 				"heroes/magnus/magnataur_pf_skewer", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_magnataur_pf_skewer_impact", 			"heroes/magnus/magnataur_pf_skewer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magnataur_pf_skewer_bonus_strength", 	"heroes/magnus/magnataur_pf_skewer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magnataur_pf_skewer_toss", 			"heroes/magnus/magnataur_pf_skewer", LUA_MODIFIER_MOTION_BOTH)

--------------------------------------------------------------------------------

magnataur_pf_skewer = class({})

--------------------------------------------------------------------------------

function magnataur_pf_skewer:Precache( context )
    PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_horn_toss.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_horn_toss_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_magnataur/magnataur_horn_toss_land.vpcf", context)	
end

--------------------------------------------------------------------------------

function magnataur_pf_skewer:GetCastRange(vLocation, hTarget)
	return IsClient() and self:GetSpecialValueFor("range") or 10000
end

--------------------------------------------------------------------------------

function magnataur_pf_skewer:OnSpellStart()
	local hCaster = self:GetCaster()
	local vOrigin = hCaster:GetAbsOrigin()
	local vPosition = hCaster:GetCursorPosition()
	local nRange = self:GetSpecialValueFor("range")

	if (vPosition - vOrigin):Length2D() > nRange + self:GetCaster():GetCastRangeBonus() then
		local nDistance = (nRange + self:GetCaster():GetCastRangeBonus())
	
		vPosition = vOrigin + (vPosition - vOrigin):Normalized() * nDistance
	end

	hCaster:EmitSound("Hero_Magnataur.Skewer.Cast")

	hCaster:AddNewModifier(hCaster, self, "modifier_magnataur_pf_skewer", {duration = -1, vPositionX = vPosition.x, vPositionY = vPosition.y, vPositionZ = vPosition.z})
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_skewer = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:IsPurgable()			return false end
function modifier_magnataur_pf_skewer:IsHidden()			return true end
function modifier_magnataur_pf_skewer:GetAttributes()		return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:OnCreated(kv)
	if IsClient() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	self.nSpeed = hAbility:GetSpecialValueFor("skewer_speed")
	self.nSearchRadius = hAbility:GetSpecialValueFor("skewer_radius")
	self.hSkeweredUnits = {}

	self.vOriginalPosition = hParent:GetAbsOrigin()
	self.vPosition = Vector(kv.vPositionX, kv.vPositionY, kv.vPositionZ)
	self.nDistanceToWalk = self.vPosition - self.vOriginalPosition
	self.vDirection = self.nDistanceToWalk:Normalized()
	self.nDistanceToWalk = self.nDistanceToWalk:Length2D()


	local nSkewerFx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControlEnt(nSkewerFx, 0, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(nSkewerFx, 1, hParent, PATTACH_POINT_FOLLOW, "attach_horn", hParent:GetAbsOrigin(), true)
	self:AddParticle(nSkewerFx, false, false, -1, false, false)

	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	else
		hParent:RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
		hParent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 0.5)
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()

		hParent:RemoveHorizontalMotionController( self )

		hParent:FadeGesture(ACT_DOTA_CAST_ABILITY_3)

		if hParent:FindAbilityByName("aghsfort_magnataur_horn_toss") ~= nil then
			hParent:StartGesture(ACT_DOTA_CAST_ABILITY_5)
		else
			hParent:StartGesture(ACT_DOTA_MAGNUS_SKEWER_END)
		end
		
		self.nDistanceTravelled = (self.vOriginalPosition - hParent:GetAbsOrigin()):Length2D()

		self:ClearEnemyModifiers()

		GridNav:DestroyTreesAroundPoint(hParent:GetAbsOrigin(), 400, false)

		if self:GetCaster():FindAbilityByName("aghsfort_magnataur_horn_toss") ~= nil then
			self:HornToss()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:HornToss()
	local hCaster = self:GetCaster()
	local hAbility = self:GetCaster():FindAbilityByName("aghsfort_magnataur_horn_toss")
	local hParent = self:GetParent()
	
	local vFacingDir = hParent:GetForwardVector()
	local vOrigin = hParent:GetOrigin()
	local vSearchPos = hParent:GetOrigin() + vFacingDir * hAbility:GetSpecialValueFor("pull_offset")
	local nRadius = hAbility:GetSpecialValueFor("radius")
	local nAngle = hAbility:GetSpecialValueFor("pull_angle")
	local vDestination = vOrigin - vFacingDir * hAbility:GetSpecialValueFor("destination_offset")
	
	local hEnemies = FindUnitsInRadius(hParent:GetTeam(), vSearchPos, nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	Timers:CreateTimer(0.2, function()
		hParent:EmitSound("Hero_Magnataur.HornToss.Cast")
		for _, hEnemy in pairs(hEnemies) do
			local vDir = (hEnemy:GetOrigin() - vOrigin):Normalized()
			local nEnemyAngle = math.deg(math.acos(DotProduct(vFacingDir, vDir)))
			nEnemyAngle = tostring(nEnemyAngle) == "nan" and 0 or nEnemyAngle

			local nAngleDiff = math.abs(AngleDiff(360, nEnemyAngle))

			if nAngleDiff <= nAngle / 2 then
				hEnemy:AddNewModifier(hCaster, hAbility, "modifier_magnataur_pf_skewer_toss", {duration = 0.6, x = vDestination.x, y = vDestination.y, z = vDestination.z})
				hEnemy:EmitSound("Hero_Magnataur.HornToss.Target")
			end
		end
	end)

	local nHornFX = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_horn_toss.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(nHornFX, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_horn", Vector(0, 0, 0), true)
	ParticleManager:ReleaseParticleIndex(nHornFX)
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:UpdateHorizontalMotion(hParent, dt)
	hParent:SetAbsOrigin(hParent:GetAbsOrigin() + self.nSpeed * self.vDirection * dt)
	GridNav:DestroyTreesAroundPoint(hParent:GetAbsOrigin(), 200, false)

	self:SkewerEnemies()

	if not GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds(hParent:GetOrigin()) or (hParent:GetAbsOrigin() - self.vOriginalPosition):Length2D() >= self.nDistanceToWalk then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:SkewerEnemies()
	local hParent = self:GetParent()

	local hEnemies = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.nSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
	for _, hEnemy in pairs(hEnemies) do
		if self.hSkeweredUnits[hEnemy:entindex()] ~= true then
			self.hSkeweredUnits[hEnemy:entindex()] = true
			self:SkewerEnemy(hEnemy)
			

			if hParent:FindAbilityByName("aghsfort_special_magnataur_skewer_bonus_strength") ~= nil then
				hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_magnataur_pf_skewer_bonus_strength", {duration = 20})
			end

			if hParent:FindAbilityByName("aghsfort_special_magnataur_skewer_shockwave") ~= nil then
				hParent:PerformAttack(hEnemy, false, true, true, true, false, false, true)
			end
		end
	end

	self:PositionEnemies()
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:SkewerEnemy(hTarget)
	if not hTarget or not hTarget:IsAlive() then
		return 0
	end

	hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_magnataur_pf_skewer_impact", {duration = -1})
	EmitSoundOn("Hero_Magnataur.Skewer.Target", hTarget)
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:PositionEnemies()
	local hParent = self:GetParent()
	local vFront = hParent:GetAbsOrigin() + hParent:GetForwardVector() * 140
	for _, bSkewered in pairs(self.hSkeweredUnits) do
		local hEnemy = EntIndexToHScript(_)
		
		if hEnemy and not hEnemy:IsNull() and hEnemy:IsAlive() and not hEnemy:IsBoss() and not hEnemy.bAbsoluteNoCC and not hEnemy.bMotionControlExcluded then
			if not hEnemy.vSkewerOffset then
				hEnemy.vSkewerOffset = RandomVector(15)
			end

			hEnemy:SetOrigin(vFront + hEnemy.vSkewerOffset)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer:ClearEnemyModifiers()
	for _, bSkewered in pairs(self.hSkeweredUnits) do
		local hEnemy = EntIndexToHScript(_)
		hEnemy.vSkewerOffset = nil
		if hEnemy and hEnemy:HasModifier("modifier_magnataur_pf_skewer_impact") then
			local hModifier = hEnemy:FindModifierByName("modifier_magnataur_pf_skewer_impact")
			hModifier.nDistanceTravelled = self.nDistanceTravelled
			hModifier:Destroy()
		end
	end
end


--------------------------------------------------------------------------------

modifier_magnataur_pf_skewer_impact = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_impact:IsPurgable()		return false end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_impact:OnCreated(kv)
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	hParent:FaceTowards(hCaster:GetAbsOrigin())
	hParent:SetForwardVector((hCaster:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized())

	self.nDistanceToDamagePct = hAbility:GetSpecialValueFor("damage_distance_pct") / 100
	self.nDistanceTravelled = 0

	self.tDamageTable = 
	{
		victim = hParent,
		attacker = hCaster,
		ability = hAbility,
		damage = hAbility:GetSpecialValueFor("skewer_damage"),
		damage_type = hAbility:GetAbilityDamageType()
	}

	if hParent:IsBoss() or hParent.bAbsoluteNoCC or hParent.bMotionControlExcluded then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_impact:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()

		self.tDamageTable.damage = self.tDamageTable.damage + self.nDistanceTravelled * self.nDistanceToDamagePct
		ApplyDamage(self.tDamageTable)

		hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_magnataur_skewer_slow", {duration = self:GetAbility():GetSpecialValueFor("slow_duration") * (1 - self:GetParent():GetStatusResistance())})
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_impact:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_impact:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_impact:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end

--------------------------------------------------------------------------------

modifier_magnataur_pf_skewer_bonus_strength = class({})

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_bonus_strength:IsPurgable()	return false end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_bonus_strength:OnCreated(kv)
	self.nStrengthPerStack = 7

	if IsClient() then return end
	self:SetStackCount(1)
	Timers:CreateTimer(self:GetDuration(), function()
		if self and not self:IsNull() then
			self:DecrementStackCount()
		end
	end)
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_bonus_strength:OnRefresh(kv)
	if IsClient() then return end
	self:IncrementStackCount()

	Timers:CreateTimer(self:GetDuration(), function()
		if self and not self:IsNull() then
			self:DecrementStackCount()
		end
	end)
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_bonus_strength:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_bonus_strength:GetModifierBonusStats_Strength()
	return self:GetStackCount() * self.nStrengthPerStack
end

---------------------------------------------------------------------

if modifier_magnataur_pf_skewer_toss == nil then
	modifier_magnataur_pf_skewer_toss = class({})
end

---------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:IsHidden() 	return true end
function modifier_magnataur_pf_skewer_toss:IsPurgable()	return false end

---------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:OnCreated(kv)
	if not IsServer() then return end
	local hAbility = self:GetCaster():FindAbilityByName("aghsfort_magnataur_horn_toss")
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local vOrigin = hParent:GetOrigin()

	self.vPos = Vector(kv.x, kv.y, kv.z)

	self.nDistance = (self.vPos - vOrigin):Length2D()
	self.nHeight = hAbility:GetSpecialValueFor("air_height")
	self.nHopDuration = hAbility:GetSpecialValueFor("air_duration")

	self.nInitialHeight = GetGroundHeight(vOrigin, nil)
	self.nSpeed = self.nDistance / self.nHopDuration
	self.vDirection = (self.vPos - vOrigin):Normalized()

	self.nDamagePct = hAbility:GetSpecialValueFor("damage_pct") / 100

	if not hParent:IsBoss() and not hParent.bAbsoluteNoCC and not hParent.bMotionControlExcluded and hParent:GetUnitName() ~= "npc_dota_creature_bonus_chicken" then
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then		
			self:Destroy()
			return
		end
	else
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:OnDestroy()
	if not IsServer() then return end
	local hParent = self:GetParent()

	if not hParent:IsBoss() and not hParent.bAbsoluteNoCC and not hParent.bMotionControlExcluded and hParent:GetUnitName() ~= "npc_dota_creature_bonus_chicken" then
		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveVerticalMotionController(self)
	end

	ApplyDamage({
		attacker = self:GetCaster(),
		victim = hParent,
		damage = self:GetCaster():FindAbilityByName("magnataur_pf_skewer"):GetSpecialValueFor("skewer_damage") * self.nDamagePct,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility()
	})

	hParent:EmitSound("Hero_Magnataur.HornToss.Damage")
	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_horn_toss_land.vpcf", PATTACH_ABSORIGIN, hParent)
	)
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

---------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:UpdateHorizontalMotion(hParent, dt)
	if not IsServer() then return end
	local vPos = hParent:GetAbsOrigin() + self.nSpeed * self.vDirection * dt
	hParent:SetAbsOrigin(vPos)
end

---------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:UpdateVerticalMotion(hParent, nDT)
	if not IsServer() then return end
	local vPos = hParent:GetAbsOrigin()
	local nGroundHeight =  GetGroundHeight(vPos, hParent)
	local nVerticalDistance = -self:GetElapsedTime() * (self:GetElapsedTime() - self.nHopDuration) * self.nHeight / math.pow(self.nHopDuration * 0.5, 2) + self.nInitialHeight

	hParent:SetAbsOrigin(vPos * Vector(1, 1, 0) + Vector(0, 0, nVerticalDistance))

	if vPos.z < nGroundHeight and self:GetElapsedTime() > 0.1 then
		self:Destroy()
	end
end

---------------------------------------------------------------------

function modifier_magnataur_pf_skewer_toss:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_horn_toss_debuff.vpcf"
end