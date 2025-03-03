modifier_creature_bonus_balloon = class({})

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:OnCreated( kv )
	self.total_gold = self:GetAbility():GetSpecialValueFor( "total_gold" )
	self.time_limit = self:GetAbility():GetSpecialValueFor( "time_limit" )
	self.gold_bag_duration = self:GetAbility():GetSpecialValueFor( "gold_bag_duration" )
	if IsServer() then
		--[[
		local vDestination = self:GetParent():GetOrigin() + RandomVector( RandomFloat( 0, 500 ) )
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vDestination
			})
		]]
		self.flExpireTime = GameRules:GetGameTime() + self.time_limit
		self:OnIntervalThink()
		self:StartIntervalThink( 3.0 )
		--[[
		local hWaypoint = Entities:FindByClassnameNearest( "path_track", self:GetParent():GetOrigin(), 2000.0 )
		if hWaypoint ~= nil then
			print( "Patrolling to " .. hWaypoint:GetName() )
			self:GetParent():SetInitialGoalEntity( hWaypoint )
		end
		]]
	end
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TELEPORTED,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,

	}

	return funcs
end

function modifier_creature_bonus_balloon:OnIntervalThink()
	if not IsServer() then
		return
	end

	if self.bTeleporting == true then
		return
	end

	if GameRules:GetGameTime() > self.flExpireTime then
		self:GetParent():ForceKill(false)
		return
	end
	--[[
	local vOrigin = self:GetParent():GetOrigin()
	ExecuteOrderFromTable({
		UnitIndex = self:GetParent():entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = FindPathablePositionNearby( vOrigin, 500, 2500 )
		})	
	]]
end

--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		if hAttacker == hUnit then
			return 0
		end

		if hUnit == self:GetParent() then		
			local nGoldAmount = 60
			local nAdjustedAmount = math.ceil( nGoldAmount * GameRules.Aghanim:GetGoldModifier() / 100 )
			local iBonusBags = 0
			if self:GetParent():FindModifierByName("modifier_bonus_balloon_gold") then
				iBonusBags = iBonusBags + 4
			end
			hUnit:AddEffects( EF_NODRAW )
			local iGoldBagsDrop = 1 + iBonusBags

			for i = 1, iGoldBagsDrop do
				local newItem = CreateItem( "item_bag_of_gold", nil, nil )				
				newItem:SetPurchaseTime( 0 )
				newItem:SetCurrentCharges( nAdjustedAmount )
				local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
				newItem:LaunchLoot( true, 300, 0.75, hAttacker:GetAbsOrigin(),nil )
			end

			EmitSoundOn( "Balloon.Pop", hUnit )

			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/balloon/balloon_death_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
	return 0
end



--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:CheckState()
	local state = {}
	if IsServer()  then
		if GameRules:GetGameTime() > self.flExpireTime or self.total_gold <= 0 then
			state[MODIFIER_STATE_MAGIC_IMMUNE] = true
			state[MODIFIER_STATE_INVULNERABLE] = true
			state[MODIFIER_STATE_OUT_OF_GAME] = true
		end
	end
	
	return state
end


--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
--------------------------------------------------------------------------------

function modifier_creature_bonus_balloon:GetVisualZDelta( params )
	return -50
end

