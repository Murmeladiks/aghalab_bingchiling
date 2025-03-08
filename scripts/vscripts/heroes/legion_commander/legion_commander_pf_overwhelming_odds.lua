LinkLuaModifier("modifier_legion_commander_pf_overwhelming_odds", 					"heroes/legion_commander/legion_commander_pf_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_overwhelming_odds_shield",			"heroes/legion_commander/legion_commander_pf_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_pf_overwhelming_odds_kill_detector", 	"heroes/legion_commander/legion_commander_pf_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

legion_commander_pf_overwhelming_odds = class({})

--------------------------------------------------------------------------------

function legion_commander_pf_overwhelming_odds:Precache(context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_legion_commander.vsndevts", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds_cast.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds_buff.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmga.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmgb.vpcf", context)
	PrecacheResource("particle", "particles/items4_fx/meteor_hammer_spell.vpcf", context)
	PrecacheResource("particle", "particles/items2_fx/refresher.vpcf", context)	
end

--------------------------------------------------------------------------------
-- Thank you, thank you. I'll be making plays like that all game
function legion_commander_pf_overwhelming_odds:GetBehavior()
	if self:GetCaster():HasModifier("modifier_legion_commander_pf_duel_taunted") then
		return self.BaseClass.GetBehavior(self)
	end

	return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

--------------------------------------------------------------------------------

function legion_commander_pf_overwhelming_odds:GetIntrinsicModifierName()	
	return "modifier_legion_commander_pf_overwhelming_odds_kill_detector"
end

--------------------------------------------------------------------------------

function legion_commander_pf_overwhelming_odds:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end

--------------------------------------------------------------------------------

function legion_commander_pf_overwhelming_odds:OnAbilityPhaseStart()	
	if IsServer() then
		local hCaster = self:GetCaster()
		
		local nPrecastFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds_cast.vpcf", PATTACH_POINT_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(nPrecastFX, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(nPrecastFX)

		hCaster:EmitSound("Hero_LegionCommander.Overwhelming.Cast")
	end

	return true
end

--------------------------------------------------------------------------------

function legion_commander_pf_overwhelming_odds:OnAbilityPhaseInterrupted()
	if not IsClient() then return end
	self:GetCaster():StopSound("Hero_LegionCommander.Overwhelming.Cast")
end

--------------------------------------------------------------------------------

function legion_commander_pf_overwhelming_odds:OnSpellStart()
	self:LaunchArrows(self:GetCaster())
end

--------------------------------------------------------------------------------

function legion_commander_pf_overwhelming_odds:LaunchArrows(hCenterUnit)
	local hCaster = self:GetCaster()
	local vPos = hCenterUnit:GetOrigin()
	local nRadius = self:GetSpecialValueFor("radius")
	local nShielDuration = self:GetSpecialValueFor("shield_duration")

	local hEnemyHeroes = FindUnitsInRadius(hCaster:GetTeam(), vPos, nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_ANY_ORDER, false)
	local hEnemyCreeps = FindUnitsInRadius(hCaster:GetTeam(), vPos, nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
	local hEnemies = table.concat(hEnemyHeroes, hEnemyCreeps)

	local tDamageTable = {
		attacker = hCaster,
		victim = nil,
		damage = self:GetSpecialValueFor("damage") + (self:GetSpecialValueFor("damage_per_unit") * #hEnemyCreeps) + (self:GetSpecialValueFor("damage_per_hero") * #hEnemyHeroes),
		damage_type = self:GetAbilityDamageType(),
		ability = self
	}

	for _, hEnemy in pairs(hEnemies) do
		tDamageTable.victim = hEnemy
		ApplyDamage(tDamageTable)
		
		hEnemy:EmitSound(hEnemy:IsConsideredHero() and "Hero_LegionCommander.Overwhelming.Hero" or "Hero_LegionCommander.Overwhelming.Creep")
		local sParticleName = hEnemy:IsConsideredHero() and "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmgb.vpcf" or "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmga.vpcf"
		local nHitFX = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(nHitFX, 0, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(nHitFX, 1, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(nHitFX, 3, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:ReleaseParticleIndex(nHitFX)
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_pf_overwhelming_odds", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_LegionCommander.Overwhelming.Buff")

	local nOddsFX = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControl(nOddsFX, 0, vPos)
	ParticleManager:SetParticleControl(nOddsFX, 1, vPos)
	ParticleManager:SetParticleControl(nOddsFX, 3, vPos)
	ParticleManager:SetParticleControl(nOddsFX, 4, Vector(nRadius, nRadius, nRadius))	
	ParticleManager:SetParticleControl(nOddsFX, 5, vPos)
	ParticleManager:SetParticleControl(nOddsFX, 6, vPos)
	ParticleManager:ReleaseParticleIndex(nOddsFX)
	hCenterUnit:EmitSound("Hero_LegionCommander.Overwhelming.Location")

	if nShielDuration > 0 then
		hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_pf_overwhelming_odds_shield", {duration = nShielDuration, damage = tDamageTable.damage})
	end

	if hCaster:HasShard("pathfinder_special_lc_arrows_meteor") then
		Timers:CreateTimer(0.25, function()
			local nMeteorFX = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_CUSTOMORIGIN, hCaster)	
			ParticleManager:SetParticleControl(nMeteorFX, 0, vPos + Vector(0, 0, 1000))
			ParticleManager:SetParticleControl(nMeteorFX, 1, vPos)
			ParticleManager:SetParticleControl(nMeteorFX, 2, Vector(0.5, 0, 0))
			ParticleManager:ReleaseParticleIndex(nMeteorFX)
			StartSoundEventFromPosition("DOTA_Item.MeteorHammer.Cast", vPos)
			

			Timers:CreateTimer(0.5, function()
				local nStunDuration = hCaster:FindTalentValue("pathfinder_special_lc_arrows_meteor", "stun_duration")
				local tDamageTable = {
					attacker = hCaster,
					victim = nil,
					damage = self:GetSpecialValueFor("damage"),
					damage_type = self:GetAbilityDamageType(),
					ability = self
				}

				local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), vPos, nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
				for _, hEnemy in pairs(hEnemies) do		
					tDamageTable.victim = hEnemy
					ApplyDamage(tDamageTable)

					hEnemy:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nStunDuration * (1 - hEnemy:GetStatusResistance())})
				end

				StartSoundEventFromPosition("DOTA_Item.MeteorHammer.Impact", vPos)
			end)
		end)
	end
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_overwhelming_odds =  class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds:OnCreated()
	self.nAttackSpeed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds:GetModifierAttackSpeedBonus_Constant()
	return self.nAttackSpeed
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds:GetEffectName()
	return "particles/units/heroes/hero_legion_commander/legion_commander_odds_buff.vpcf"
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_overwhelming_odds_shield = class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_shield:OnCreated(kv)
	if IsClient() then return end

	local hAbility = self:GetAbility()
	local hParent = self:GetParent()

	self.nShieldValue = kv.damage * hAbility:GetSpecialValueFor("shield_per_damage_pct") / 100
	self.nMaxShield = self.nShieldValue

	
	self:SetHasCustomTransmitterData(true)
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_shield:OnRefresh(kv)
	if IsClient() then return end
	local hAbility = self:GetAbility()

	self.nShieldValue = math.max(self.nShieldValue, kv.damage * hAbility:GetSpecialValueFor("shield_per_damage_pct") / 100)
	self.nMaxShield = math.max(self.nShieldValue, self.nMaxShield)

	self:SendBuffRefreshToClients()
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_shield:AddCustomTransmitterData()
	return {
		nShieldValue = self.nShieldValue,
		nMaxShield = self.nMaxShield
	}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_shield:HandleCustomTransmitterData(data)
	self.nShieldValue = data.nShieldValue
	self.nMaxShield = data.nMaxShield
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_shield:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT}
end

--------------------------------------------------------------------------------


function modifier_legion_commander_pf_overwhelming_odds_shield:GetModifierIncomingDamageConstant(event)
	if IsServer() then		
		local nDamage = event.damage
		local nReduction = -self.nShieldValue

		self.nShieldValue = math.max(0, self.nShieldValue - nDamage)

		if self.nShieldValue <= 0 then
			self:Destroy()
		end

		self:SendBuffRefreshToClients()

		return nReduction
	else
		return event.report_max and self.nMaxShield or self.nShieldValue
	end
end

--------------------------------------------------------------------------------

modifier_legion_commander_pf_overwhelming_odds_kill_detector =  class({})

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_kill_detector:IsHidden() 	return true end
function modifier_legion_commander_pf_overwhelming_odds_kill_detector:IsPurgable() return false end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_kill_detector:DeclareFunctions()
	return {MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT}
end

--------------------------------------------------------------------------------

function modifier_legion_commander_pf_overwhelming_odds_kill_detector:OnTakeDamageKillCredit( params )
	if IsClient() or not self:GetParent():HasShard("pathfinder_special_lc_arrows_reset") then return end

	if params.inflictor and params.inflictor == self:GetAbility() and params.damage >= params.target:GetHealth() then
		local hParent = self:GetParent()
		local nRefreshFX = ParticleManager:CreateParticle( "particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)	
		ParticleManager:SetParticleControlEnt(nRefreshFX, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:ReleaseParticleIndex(nRefreshFX)

		hParent:FindAbilityByName("legion_commander_pf_overwhelming_odds"):EndCooldown()
		hParent:FindAbilityByName("legion_commander_pf_press_the_attack"):EndCooldown()
		hParent:FindAbilityByName("legion_commander_pf_duel"):EndCooldown()
		
		local hSpecialAbility = hParent:FindAbilityByName("pathfinder_special_lc_global_arrows")
		if hSpecialAbility then
			hSpecialAbility:EndCooldown()
		end
	end
end