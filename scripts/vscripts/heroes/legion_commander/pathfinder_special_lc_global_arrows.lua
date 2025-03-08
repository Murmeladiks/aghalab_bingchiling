pathfinder_special_lc_global_arrows = class({})

--------------------------------------------------------------------------------

function pathfinder_special_lc_global_arrows:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_legion_commander/legion_duel.vpcf", context)
end

--------------------------------------------------------------------------------

function pathfinder_special_lc_global_arrows:GetChannelAnimation()
	self:GetCaster():AddActivityModifier("fallen_legion")
    return ACT_DOTA_IDLE_RARE
end

--------------------------------------------------------------------------------

function pathfinder_special_lc_global_arrows:GetChannelTime()	
    return self:GetSpecialValueFor("channel_time")
end

--------------------------------------------------------------------------------

function pathfinder_special_lc_global_arrows:OnAbilityPhaseStart()
	if IsServer() then
		if RandomInt(1,100) < 50 then
			self:GetCaster():EmitSound("legion_commander_legcom_duelhero_23")	
		else
			self:GetCaster():EmitSound("legion_commander_legcom_duelhero_22")
		end

		self.nInitDelay = 0.6
		self.nInternalTimer = self:GetSpecialValueFor("interval")
	end

	return true
end

--------------------------------------------------------------------------------

function pathfinder_special_lc_global_arrows:OnChannelThink(flInterval)
	if self.nInitDelay > 0 then
		self.nInitDelay = self.nInitDelay - flInterval
		return
	end

	self.nInternalTimer = self.nInternalTimer - flInterval

	if self.nInternalTimer > 0 then				
		return
	end
	
	local hCaster = self:GetCaster()
	local hOdds = hCaster:FindAbilityByName("legion_commander_pf_overwhelming_odds")

	self.nInternalTimer = self:GetSpecialValueFor("interval")	
	
	ParticleManager:ReleaseParticleIndex(
		ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	)

	if not hOdds or not hOdds:IsTrained() then return end

	local nRadius = hOdds:GetSpecialValueFor("radius")
	local hChosenAlly = hCaster
	local nChosenEnemies = 0

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
		if hPlayerHero then
			local hEnemies = FindUnitsInRadius(hCaster:GetTeam(), hPlayerHero:GetOrigin(), nil, nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

			if #hEnemies > nChosenEnemies then
				hChosenAlly = hPlayerHero
				nChosenEnemies = #hEnemies
			end
		end
	end

	hOdds:LaunchArrows(hChosenAlly)
end