LinkLuaModifier("modifier_marci_pf_guardian_buff", 		"heroes/marci/marci_pf_guardian", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marci_pf_guardian_debuff", 	"heroes/marci/marci_pf_guardian", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

marci_pf_guardian = class({})

--------------------------------------------------------------------------------

function marci_pf_guardian:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_sidekick_debuff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_guardian_pulse.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_marci/marci_sidekick_heal.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_marci_sidekick.vpcf", context)	
end

--------------------------------------------------------------------------------

function marci_pf_guardian:Spawn()
	if IsClient() then return end
	Timers:CreateTimer(0.1, function()
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity(self:GetCaster():GetPlayerOwnerID())

		local vecAbilitiesToRemove = {
			"marci_guardian",
			"marci_bodyguard",
		}

		for _, sAbilityName in pairs(vecAbilitiesToRemove) do
			if hPlayerHero:HasAbility(sAbilityName) then hPlayerHero:RemoveAbility(sAbilityName) end
		end


		if hPlayerHero:GetHeroFacetID() == 2 and not hPlayerHero.bSwappedToBodyguard then
			hPlayerHero.bSwappedToBodyguard = true

			local hBodyguard = hPlayerHero:AddAbility("marci_pf_bodyguard")
			hPlayerHero:SwapAbilities("marci_pf_guardian", "marci_pf_bodyguard", false, true)
			hPlayerHero:RemoveAbility("marci_pf_guardian")
		end
	end)
end

--------------------------------------------------------------------------------

function marci_pf_guardian:CastFilterResultTarget(hTarget)
	local hCaster = self:GetCaster()

	if hTarget == hCaster then return UF_FAIL_CUSTOM end

	if hCaster:HasShard("pathfinder_marci_guardian_enemy") then
		return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, hCaster:GetTeamNumber())
	end

	return self.BaseClass.CastFilterResultTarget(self, hTarget)
end

--------------------------------------------------------------------------------

function marci_pf_guardian:GetCustomCastErrorTarget(hTarget)
	if hTarget == self:GetCaster() then return "#dota_hud_error_cant_cast_on_self" end
end

--------------------------------------------------------------------------------

function marci_pf_guardian:GetIntrinsicModifierName()
	return "modifier_marci_pf_guardian_buff"
end
--------------------------------------------------------------------------------

function marci_pf_guardian:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:GetTeam() ~= hCaster:GetTeam() then
		self:EnemyCast(hTarget)
		return
	end

	if self.hCurrentAlly and self.hCurrentAlly:HasModifier("modifier_marci_pf_guardian_buff") then
		self.hCurrentAlly:RemoveModifierByName("modifier_marci_pf_guardian_buff")
	end
	
	hTarget:AddNewModifier(hCaster, self, "modifier_marci_pf_guardian_buff", {})

	self.hCurrentAlly = hTarget


	if hCaster:HasShard("pathfinder_marci_unleash_bash") then
		local hUnleash = hCaster:FindAbilityByName("marci_unleash_lua")

		if hTarget and hUnleash:IsTrained() then
			hTarget:AddNewModifier(hCaster, hUnleash, "modifier_marci_unleash_lua_passive", nil)
			hTarget:AddNewModifier(hCaster, hUnleash, "modifier_marci_unleash_lua_fury", { type = MARCI_UNLEASH_STACK_SIDEKICK})
		end
	end

	if hCaster:HasShard("pathfinder_marci_guardian_kick") then
		local nHealthPctPerKick = hCaster:FindTalentValue("pathfinder_marci_guardian_kick", "health_percent_per_kick")
		local nKicks = math.floor((100 - hTarget:GetHealthPercent()) / nHealthPctPerKick) + 1

		for i = 1, nKicks do
			Timers:CreateTimer((i-1) * 0.1, function() self:DoKick(hTarget) end)
		end
	end
end

--------------------------------------------------------------------------------

function marci_pf_guardian:EnemyCast(hTarget)
	local hCaster = self:GetCaster()

	if self.hCurrentEnemy and self.hCurrentEnemy:HasModifier("modifier_marci_pf_guardian_debuff") then
		self.hCurrentEnemy:RemoveModifierByName("modifier_marci_pf_guardian_debuff")
	end

	hTarget:AddNewModifier(hCaster, self, "modifier_marci_pf_guardian_debuff", {})

	self.hCurrentEnemy = hTarget
end

--------------------------------------------------------------------------------

function marci_pf_guardian:DoKick(hTarget)
	local hCaster = self:GetCaster()
	local nRadius = hCaster:FindTalentValue("pathfinder_marci_guardian_kick", "radius")
	local nKickDuration = 0.5

	local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), hTarget:GetOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_DAMAGE_FLAG_NONE, 0, false)

	local nStartAngle = VectorToAngles(hTarget:GetForwardVector()).y
	local vOrigin = hTarget:GetAbsOrigin()

	local tEnemyAngles = {}

	for _, hEnemy in pairs(hEnemies) do
		local vDir = (hEnemy:GetAbsOrigin() - vOrigin):Normalized()
		local nDirAngle = (360 - (VectorToAngles(vDir).y - nStartAngle)) % 360

		tEnemyAngles[hEnemy] = nDirAngle
	end

	table.sort(hEnemies, function(a,b) return tEnemyAngles[a] <= tEnemyAngles[b] end)

	for _, hEnemy in ipairs(hEnemies) do
		local nDelay = tEnemyAngles[hEnemy] / 360 * nKickDuration

		Timers:CreateTimer(nDelay, function() 
			if IsValidEntity(hEnemy) and IsValidEntity(hTarget) and hEnemy:IsAlive() and hTarget:IsAlive() then
				hTarget:PerformAttack(hEnemy, false, true, true, false, hTarget:IsRangedAttacker(), false, false)
			end
		end)
	end
end

--------------------------------------------------------------------------------

modifier_marci_pf_guardian_buff = class({})

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:OnCreated()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	self.nPenalty = hAbility:GetSpecialValueFor("max_partner_penalty") / 100
	self.bDisabled = false
	self.bIsMarci = hParent == self:GetCaster()

	if IsClient() then 
		self.nBuffFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nBuffFX, 0, hParent, PATTACH_OVERHEAD_FOLLOW, nil, Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(self.nBuffFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
		ParticleManager:SetParticleControl(self.nBuffFX, 2, Vector(1, 0, 0))
		self:AddParticle(self.nBuffFX, false, false, -1, false, true)
		return
	end

	self.nMaxDistance = hAbility:GetSpecialValueFor("max_partner_distance")	+ 50

	hParent:EmitSound("Hero_Marci.Guardian.Applied")
	self:SetHasCustomTransmitterData(true)

	self:StartIntervalThink(0.1)
end

-----------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:AddCustomTransmitterData()
	return {bDisabled = self.bDisabled}
end

-----------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:HandleCustomTransmitterData(data)
	self.bDisabled = data.bDisabled == 1
	local nVecNumber = self.bDisabled and 0 or 1

	if IsServer() or not self.nBuffFX then return end
	--print("updating to " .. nVecNumber)	
	ParticleManager:SetParticleControl(self.nBuffFX, 2, Vector(nVecNumber, 0, 0))
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:OnIntervalThink()
	local hAbility = self:GetAbility()
	if self.bIsMarci then
		local hCurrentAlly = hAbility.hCurrentAlly
		if (not hCurrentAlly or (hCurrentAlly:GetOrigin() - self:GetParent():GetOrigin()):Length2D() > self.nMaxDistance) and not self.bDisabled then
			self.bDisabled = true
			self:SendBuffRefreshToClients()
		elseif hCurrentAlly and (hCurrentAlly:GetOrigin() - self:GetParent():GetOrigin()):Length2D() <= self.nMaxDistance and self.bDisabled then
			self.bDisabled = false
			self:SendBuffRefreshToClients()
		end
	else
		if not self:GetCaster() or not self:GetCaster():IsAlive() then
			self:Destroy()
			if hAbility then
				hAbility.hCurrentAlly = nil
			end
			return
		end

		if (self:GetCaster():GetOrigin() - self:GetParent():GetOrigin()):Length2D() > self.nMaxDistance and not self.bDisabled then
			self.bDisabled = true
			self:SendBuffRefreshToClients()
		elseif (self:GetCaster():GetOrigin() - self:GetParent():GetOrigin()):Length2D() <= self.nMaxDistance and self.bDisabled then
			self.bDisabled = false
			self:SendBuffRefreshToClients()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED
	}
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:GetModifierBaseDamageOutgoing_Percentage()
	if not self.bDisabled then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	elseif self.bIsMarci then
		return self:GetAbility():GetSpecialValueFor("bonus_damage") * self.nPenalty
	end
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:OnAttacked(event)
	if IsClient() then return end
	local hAttacker = event.attacker
	local hTarget = event.target
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	if hAttacker ~= self:GetParent() or not hTarget or hTarget:GetTeam() == hAttacker:GetTeam() or hTarget:IsBuilding() or hTarget:IsOther() then return end

	local hCurrentAlly = hAbility.hCurrentAlly

	local nLifesteal = event.damage * hAbility:GetSpecialValueFor("lifesteal_pct") / 100

	if hAttacker == hCaster then
		local nAppliedLifesteal = nLifesteal

		if self.bDisabled then
			nAppliedLifesteal = nAppliedLifesteal * self.nPenalty
		end

		hAttacker:HealWithParams(nAppliedLifesteal, hAbility, true, true, hCaster, false)

		if hCurrentAlly then
			hCurrentAlly:HealWithParams(nAppliedLifesteal, hAbility, true, true, hCaster, false)
		end

		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
		)
	elseif not self.bDisabled then
		hAttacker:HealWithParams(nLifesteal, hAbility, true, true, hCaster, false)
		hCaster:HealWithParams(nLifesteal, hAbility, true, true, hCaster, false)

		ParticleManager:ReleaseParticleIndex(
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
		)
	end
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_buff:ShouldUseOverheadOffset()
	return true
end

--------------------------------------------------------------------------------

modifier_marci_pf_guardian_debuff = class({})

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:OnCreated()
	if IsClient() then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()

	self.nHealPct = (self:GetAbility():GetSpecialValueFor("lifesteal_pct") / 100) * (hCaster:FindTalentValue("pathfinder_marci_guardian_enemy", "lifesteal_to_heal_pct") / 100)
	self.nRadius = hCaster:FindTalentValue("pathfinder_marci_guardian_enemy", "pulse_radius")

	self.nDamageDealt = 0

	local nDebuffFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_sidekick_debuff.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(nDebuffFX, 0, hParent, PATTACH_OVERHEAD_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:SetParticleControlEnt(nDebuffFX, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:SetParticleControl(nDebuffFX, 2, Vector(1, 0, 0))
	self:AddParticle(nDebuffFX, false, false, -1, false, true)
	hParent:EmitSound("Hero_Marci.Guardian.Applied")

	self:StartIntervalThink(hCaster:FindTalentValue("pathfinder_marci_guardian_enemy", "interval"))
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:OnIntervalThink()
	if self.nDamageDealt <= 0 then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	local nValue = self.nDamageDealt * self.nHealPct
	self.nDamageDealt = 0

	local tDamageTable = {
		attacker = hCaster,
		victim = nil,
		damage = nValue,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = hAbility
	}


	local hUnits = FindUnitsInRadius(hCaster:GetTeam(), hParent:GetOrigin(), nil, self.nRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)

	for _, hUnit in pairs(hUnits) do
		if hUnit:GetTeam() == hCaster:GetTeam() then
			hUnit:HealWithParams(nValue, hAbility, false, true, hCaster, false)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hUnit, nValue, hCaster)
			local nHealFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_sidekick_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
			ParticleManager:SetParticleControlEnt(nHealFX, 1, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
			ParticleManager:ReleaseParticleIndex(nHealFX)
		else
			tDamageTable.victim = hUnit
			ApplyDamage(tDamageTable)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, hUnit, nValue, hCaster)
		end
	end

	local nPulseFX = ParticleManager:CreateParticle("particles/units/heroes/hero_marci/marci_guardian_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControl(nPulseFX, 1, Vector(self.nRadius, 0, 0))
	ParticleManager:SetParticleControlEnt(nPulseFX, 2, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
	ParticleManager:ReleaseParticleIndex(nPulseFX)
	hParent:EmitSound("Hero_Marci.Guardian.Pulse")
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:OnTakeDamage(event)
	if IsClient() or event.attacker ~= self:GetParent() then return end
	self.nDamageDealt = self.nDamageDealt + event.damage
end


--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------

function modifier_marci_pf_guardian_debuff:ShouldUseOverheadOffset()
	return true
end