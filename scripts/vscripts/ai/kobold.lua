--[[ kobold AI ]]

require( "ai/ai_core_kobold" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICorekobold:CreatekoboldBehaviorSystem( thisEntity, { BehaviorNone, BehaviorFireChain,  BehaviorLineWave, BehaviorWave, BehaviorSummon } )
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
	return behaviorSystem:Think( )
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
	
	local orders = nil
	local hTarget = AICorekobold:ClosestEnemyHeroInRange( thisEntity, 2000, false, true )
	if hTarget ~= nil then
		thisEntity.lastTargetPosition = hTarget:GetAbsOrigin()
		hTarget:MakeVisibleDueToAttack( thisEntity:GetTeamNumber(), 100 )
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex()
		}
		
	elseif thisEntity.lastTargetPosition ~= nil then
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = thisEntity.lastTargetPosition
		}
	else
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end

	return orders
end

BehaviorNone.Continue = BehaviorNone.Begin

--------------------------------------------------------------------------------------------------------

BehaviorFireChain = {}

function BehaviorFireChain:Evaluate()
	
	local desire = 0

	self.hFireChainAbility = thisEntity:FindAbilityByName( "kobold_soul_chain" )
	if self.hFireChainAbility and self.hFireChainAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorFireChain:Begin()
	
	if self.hFireChainAbility and self.hFireChainAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[1]
		
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = target:entindex(),
				AbilityIndex = self.hFireChainAbility:entindex(),
				Queue = false,
			}
		
		
		
		return order
	end

	return nil
end

BehaviorFireChain.Continue = BehaviorFireChain.Begin

--------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------

BehaviorLineWave = {}

function BehaviorLineWave:Evaluate()
	
	local desire = 0

	self.hLineWaveAbility = thisEntity:FindAbilityByName( "siltbreaker_line_wave" )
	if self.hLineWaveAbility and self.hLineWaveAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		
	end

	return desire
end

function BehaviorLineWave:Begin()
	
	if self.hLineWaveAbility and self.hLineWaveAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[#enemies]
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = target:entindex(),
			AbilityIndex = self.hLineWaveAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorLineWave.Continue = BehaviorLineWave.Begin

--------------------------------------------------------------------------------------------------------
BehaviorWave = {}

function BehaviorWave:Evaluate()
	
	local desire = 0

	self.hWaveAbility = thisEntity:FindAbilityByName("siltbreaker_waves")
	if self.hWaveAbility and self.hWaveAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		
	end

	return desire
end

function BehaviorWave:Begin()
	
	if self.hWaveAbility and self.hWaveAbility:IsFullyCastable() then
		
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hWaveAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorWave.Continue = BehaviorWave.Begin


--------------------------------------------------------------------------------------------------------
BehaviorSummon = {}

function BehaviorSummon:Evaluate()
	
	local desire = 0

	self.hSummonAbility = thisEntity:FindAbilityByName( "siltbreaker_summon_minions" )
	if self.hSummonAbility and self.hSummonAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		
	end

	return desire
end

function BehaviorSummon:Begin()
	
	if self.hSummonAbility and self.hSummonAbility:IsFullyCastable() then
		
		local order =
		{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hSummonAbility:entindex(),
		Queue = false,
		}
		return order
	end

	return nil
end

BehaviorSummon.Continue = BehaviorSummon.Begin


AICorekobold.possibleBehaviors = { BehaviorNone, BehaviorFireChain,  BehaviorLineWave, BehaviorWave, BehaviorSummon}
