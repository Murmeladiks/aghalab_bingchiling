--[[ willow AI ]]

require( "ai/ai_core_willow" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICorewillow:CreatewillowBehaviorSystem( thisEntity, { BehaviorNone, BehaviorFireSpear, BehaviorGodsRebuke, BehaviorArena, BehaviorShivas, BehaviorBlademail } )
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
	local hTarget = AICorewillow:ClosestEnemyHeroInRange( thisEntity, 2000, false, true )
	if hTarget ~= nil then
		thisEntity.lastTargetPosition = hTarget:GetAbsOrigin()
		hTarget:MakeVisibleDueToAttack( thisEntity:GetTeamNumber(), 100 )
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex()
		}
		if  self.hBulwarkAbility then

			-- Check target position
			local facing_direction = thisEntity:GetAnglesAsVector().y
			local attacker_vector = (hTarget:GetOrigin() - thisEntity:GetOrigin())
			local attacker_direction = VectorToAngles( attacker_vector ).y
			local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )
			if angle_diff < 70 then
				if self.hBulwarkAbility:GetToggleState() ~= true and self.hBulwarkAbility:IsFullyCastable() then
					self.hBulwarkAbility:ToggleAbility()
				end
			else
				if self.hBulwarkAbility:GetToggleState() and self.hBulwarkAbility:IsFullyCastable() then
					self.hBulwarkAbility:ToggleAbility()
				end
			end
		end
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

BehaviorFireSpear = {}

function BehaviorFireSpear:Evaluate()
	
	local desire = 0

	self.hFireSpearAbility = thisEntity:FindAbilityByName( "boss_dark_willow_bloom_toss" )
	if self.hFireSpearAbility and self.hFireSpearAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorFireSpear:Begin()
	
	if self.hFireSpearAbility and self.hFireSpearAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 25 )
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = targetPoint,
				AbilityIndex = self.hFireSpearAbility:entindex(),
				Queue = false,
			}
		return order
	end

	return nil
end

BehaviorFireSpear.Continue = BehaviorFireSpear.Begin

--------------------------------------------------------------------------------------------------------

BehaviorGodsRebuke = {}

function BehaviorGodsRebuke:Evaluate()
	
	local desire = 0

	self.hGodsRebukeAbility = thisEntity:FindAbilityByName( "willow_gods_rebuke" )
	if self.hGodsRebukeAbility and self.hGodsRebukeAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorGodsRebuke:Begin()
	
	if self.hGodsRebukeAbility and self.hGodsRebukeAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 25 )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = targetPoint,
			AbilityIndex = self.hGodsRebukeAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorGodsRebuke.Continue = BehaviorGodsRebuke.Begin

--------------------------------------------------------------------------------------------------------

BehaviorArena = {}

function BehaviorArena:Evaluate()
	
	local desire = 0

	self.hArenaAbility = thisEntity:FindAbilityByName( "willow_arena_of_blood" )
	if self.hArenaAbility and self.hArenaAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 50 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end

	return desire
end

function BehaviorArena:Begin()
	
	if self.hArenaAbility and self.hArenaAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		local target = enemies[#enemies]
		local targetPoint = target:GetOrigin() + RandomVector( 25 )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = targetPoint,
			AbilityIndex = self.hArenaAbility:entindex(),
			Queue = false,
		}
		return order
	end

	return nil
end

BehaviorArena.Continue = BehaviorArena.Begin

--------------------------------------------------------------------------------------------------------

BehaviorShivas = {}

function BehaviorShivas:Evaluate()
	
	local desire = 0
	if not IsValid(self.hShivasAbility) then
		for i = 0, DOTA_ITEM_MAX - 1 do
			local item = thisEntity:GetItemInSlot( i )
			if item and (item:GetAbilityName() == "item_shivas_guard" )  then
				self.hShivasAbility = item
			end
		end
	end
	if self.hShivasAbility and self.hShivasAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 75 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end
	

	return desire
end

function BehaviorShivas:Begin()
	
	if self.hShivasAbility and self.hShivasAbility:IsFullyCastable() then
		
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hShivasAbility:entindex(),
		}
	
		return order
	end

	return nil
end

BehaviorShivas.Continue = BehaviorShivas.Begin

--------------------------------------------------------------------------------------------------------

BehaviorBlademail = {}

function BehaviorBlademail:Evaluate()
	
	local desire = 0
	if not IsValid(self.hBladeMailAbility) then
		for i = 0, DOTA_ITEM_MAX - 1 do
			local item = thisEntity:GetItemInSlot( i )
			if item and (item:GetAbilityName() == "item_blade_mail") then
				self.hBladeMailAbility = item
			end
		end
	end
	if self.hBladeMailAbility and self.hBladeMailAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( thisEntity:GetHealthPercent() < 90 ) then
			if ( #enemies >= 0 )  then
				desire = #enemies + 1
			end
		end
	end
	

	return desire
end

function BehaviorBlademail:Begin()
	
	if self.hBladeMailAbility and self.hBladeMailAbility:IsFullyCastable() then
		
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hBladeMailAbility:entindex(),
		}
		return order
	end

	return nil
end

BehaviorBlademail.Continue = BehaviorBlademail.Begin

--------------------------------------------------------------------------------------------------------

AICorewillow.possibleBehaviors = { BehaviorNone, BehaviorFireSpear, BehaviorGodsRebuke, BehaviorArena, BehaviorShivas, BehaviorBlademail }
