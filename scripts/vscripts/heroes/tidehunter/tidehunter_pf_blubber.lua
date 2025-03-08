LinkLuaModifier("modifier_tidehunter_pf_blubber", "heroes/tidehunter/tidehunter_pf_blubber", LUA_MODIFIER_MOTION_NONE)

------------------------------------------------------------------------------------

tidehunter_pf_blubber = class({})

------------------------------------------------------------------------------------

function tidehunter_pf_blubber:Precache( context )
	PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_tidehunter/tidehunter_blubber_heal.vpcf", context)
end

------------------------------------------------------------------------------------

function tidehunter_pf_blubber:GetIntrinsicModifierName()	
	return "modifier_tidehunter_pf_blubber"
end

------------------------------------------------------------------------------------

modifier_tidehunter_pf_blubber = class({})

------------------------------------------------------------------------------------

function modifier_tidehunter_pf_blubber:IsPurgable() 	return false end
function modifier_tidehunter_pf_blubber:RemoveOnDeath() return false end
function modifier_tidehunter_pf_blubber:IsHidden()		return true end

------------------------------------------------------------------------------------


function modifier_tidehunter_pf_blubber:OnCreated()
	if not IsServer() then return end
	
	self.reset_timer	= GameRules:GetDOTATime(true, true)
	self.current_damage = 0
	
	self:StartIntervalThink(0.1)
	self.last_purge = GameRules:GetGameTime()
	self.last_gush_purge = GameRules:GetGameTime()
end

------------------------------------------------------------------------------------

function modifier_tidehunter_pf_blubber:OnIntervalThink()
	if not IsServer() then return end
	
	if GameRules:GetDOTATime(true, true) - self.reset_timer >= self:GetAbility():GetSpecialValueFor("damage_reset_interval") then
		self.current_damage = 0
		self.reset_timer = GameRules:GetDOTATime(true, true)
	end
end

------------------------------------------------------------------------------------

function modifier_tidehunter_pf_blubber:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

------------------------------------------------------------------------------------

function modifier_tidehunter_pf_blubber:OnTakeDamage(event)
	if IsClient() or event.unit ~= self:GetParent() then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local hUnit = event.unit
	local hGushAbility = hCaster:FindAbilityByName("tidehunter_gush_pf")
	local nCleanseThreshold = hAbility:GetSpecialValueFor("damage_cleanse")

	if hUnit:PassivesDisabled() or hUnit:IsIllusion() then return end

	self.current_damage = self.current_damage + event.damage
	self.reset_timer = GameRules:GetDOTATime(true, true)
	
	if self.current_damage < nCleanseThreshold then return end

	self.current_damage = 0
	hUnit:Purge(false, true, false, true, true)			

	local nPurgeFX = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
	ParticleManager:SetParticleControlEnt(nPurgeFX, 3, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
	ParticleManager:ReleaseParticleIndex(nPurgeFX)
	hUnit:EmitSound("Hero_Tidehunter.KrakenShell")


	if hCaster:HasAbility("tidehunter_kraken_shell_pf_gush") and hGushAbility:IsTrained() and GameRules:GetGameTime() - self.last_gush_purge > 1.5 then
		self.last_gush_purge = GameRules:GetGameTime()

		local hGushedTargets = {}
		local nRadius = hCaster:GetSpecialValueFor("tidehunter_kraken_shell_pf_gush", "radius")
		local nTargetCount = hCaster:GetSpecialValueFor("tidehunter_kraken_shell_pf_gush", "targets")
		local hEnemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		local i = nTargetCount

		for _, hEnemy in pairs(hEnemies) do
			if not hGushedTargets[hEnemy:entindex()] then
				hGushedTargets[hEnemy:entindex()] = true

				Timers:CreateTimer(math.abs(i - nTargetCount) * 0.15, function()
					hGushAbility:CreateGush(hCaster, hEnemy, 0)
				end)

				nTargetCount = nTargetCount - 1
				if nTargetCount < 1 then break end
			end
		end		
	end

	self.last_purge = GameRules:GetGameTime()
	
	if hCaster:HasAbility("tidehunter_kraken_shell_pf_ravage_cdr") then
		local hRavageAbility = hCaster:FindAbilityByName("tidehunter_ravage_pf")
		local nCooldownPct = hCaster:GetSpecialValueFor("tidehunter_kraken_shell_pf_ravage_cdr", "cdr_percent") / 100
		local special = hCaster:FindAbilityByName("tidehunter_kraken_shell_pf_ravage_cdr")	

		if hRavageAbility:IsTrained() and not hRavageAbility:IsCooldownReady() then
			local nCooldown = hRavageAbility:GetCooldownTimeRemaining()
			local nReduction = hRavageAbility:GetCooldown(hRavageAbility:GetLevel()) * nCooldownPct
			hRavageAbility:EndCooldown()
			hRavageAbility:StartCooldown(math.max(nCooldown - nReduction, 0))
		end			
	end

	if hCaster:HasAbility("tidehunter_kraken_shell_pf_heal") then
		local nRadius = 1000
		local nHealPct = 30 / 100 

		local nHealAmount = nCleanseThreshold * nHealPct

		local hAllies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for _, hAlly in pairs(hAllies) do
			hAlly:Purge(false, true, false, true, true)
			hAlly:HealWithParams(nHealAmount, hAbility, false, true, hCaster, false)

			nPurgeFX = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAlly)
			ParticleManager:SetParticleControlEnt(nPurgeFX, 3, hAlly, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0, 0, 0), true)
			ParticleManager:ReleaseParticleIndex(nPurgeFX)

			local nTrailFX = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_blubber_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
			ParticleManager:SetParticleControlEnt(nTrailFX, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
			ParticleManager:SetParticleControlEnt(nTrailFX, 1, hAlly, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
			ParticleManager:ReleaseParticleIndex(nTrailFX)
		end
	end
end