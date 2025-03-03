modifier_sled_penguin_movement1 = class({})

----------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:OnCreated( kv )
	if IsServer() then
		self.max_sled_speed = self:GetAbility():GetSpecialValueFor( "max_sled_speed" )
		self.speed_step = self:GetAbility():GetSpecialValueFor( "speed_step" )
		self.collision_radius = self:GetAbility():GetSpecialValueFor( "collision_radius" )
		self.nCurSpeed = 50
		self.nGold = 0
		self.flDesiredYaw = self:GetCaster():GetAnglesAsVector().y
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end

		if self:GetParent() == self:GetCaster() then
			self:GetParent():StartGesture( ACT_DOTA_SLIDE )
		end

		self.startTime = GameRules:GetGameTime()
		self.fThinkInterval = 0.5

		self:StartIntervalThink( self.fThinkInterval )
		local connectedPlayers = CAghanim:GetConnectedPlayers()
		for _, nPlayerID in pairs(connectedPlayers) do
			local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
			if hero:GetName() == "npc_dota_hero_gyrocopter" then
				self.ability = hero:FindAbilityByName("gyrocopter_homing_missile")
			end
        end
	end
end
function modifier_sled_penguin_movement1:OnIntervalThink()
	if IsServer() then
		if self:GetParent():HasModifier( "modifier_sled_penguin_movement1" )  then
			if self:GetParent():GetUnitName() == "npc_dota_sled_penguin1" then
				
				local damage = self.ability:GetSpecialValueFor("hit_damage")
				local damageTable = {
					--victim = target,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self.ability, --Optional.
				}
				
		
				local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.collision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				for _, hOgreSeal in pairs( hEnemies ) do
					if hOgreSeal ~= nil and hOgreSeal:IsNull() == false then
						-- Knock ogre seal back
						-- local vLocation = self:GetParent():GetAbsOrigin() + ( self:GetParent():GetForwardVector() * 50 )
						-- local kv =
						-- {
						-- 	center_x = vLocation.x,
						-- 	center_y = vLocation.y,
						-- 	center_z = vLocation.z,
						-- 	should_stun = false, 
						-- 	duration = 0.4,
						-- 	knockback_duration = 0.2,
						-- 	knockback_distance = 150,
						-- 	knockback_height = 50,
						-- }
						EmitSoundOn( "Hero_Gyrocopter.HomingMissile.Target", self:GetParent() )
						damageTable.victim = hOgreSeal
						ApplyDamage(damageTable)

						-- hOgreSeal:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv )
						
					
						
						return self.fThinkInterval
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		if self:GetParent() == self:GetCaster() then
			self:GetCaster():RemoveGesture( ACT_DOTA_SLIDE_LOOP )
			EmitSoundOn( "Hero_Tusk.IceShards.Penguin", self:GetParent() )
			self:GetParent():AddNewModifier(nil,nil,"modifier_kill",{duration = 0.1})
		else
			
			print("do nothing")
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = self:GetCaster() == self:GetParent(),
		[MODIFIER_STATE_INVULNERABLE] = self:GetCaster() == self:GetParent(),
		[MODIFIER_STATE_NO_HEALTH_BAR] = self:GetCaster() == self:GetParent(),
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self:GetCaster() == self:GetParent() then
			if self.bStartedLoop == nil and self:GetElapsedTime() > 0.3 then
				self.bStartedLoop = true
				self:GetCaster():StartGesture( ACT_DOTA_SLIDE_LOOP )
			end

			local flTurnAmount = 0.0
			local curAngles = self:GetCaster():GetAngles()
			
			local flAngleDiff = AngleDiff( self.flDesiredYaw, curAngles.y )
			
			local flTurnRate = 65
			--local flTurnRateMod = 25 * self.nCurSpeed / self.max_sled_speed 
			--flTurnRate = flTurnRate - flTurnRateMod
			flTurnAmount = flTurnRate * dt
			flTurnAmount = math.min( flTurnAmount, math.abs( flAngleDiff ) )
		
			if flAngleDiff < 0.0 then
				flTurnAmount = flTurnAmount * -1
			end

			if flAngleDiff ~= 0.0 then
				curAngles.y = curAngles.y + flTurnAmount
				me:SetAbsAngles( curAngles.x, curAngles.y, curAngles.z )
			end

			local vNewPos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * ( dt * self.nCurSpeed )
			if GridNav:CanFindPath( me:GetOrigin(), vNewPos ) == false then
				self:Destroy()

				return
			end
			me:SetOrigin( vNewPos )
			self.nGold = self.nGold + 1

			if GameRules:GetGameTime() - self.startTime >= 15 then
				print("double gold")
				self.nGold = self.nGold + 1
			end

			self.nCurSpeed = math.min( self.nCurSpeed + self.speed_step, self.max_sled_speed )
		else
			if self:GetCaster():IsAlive() == false or self:GetCaster():FindModifierByName( "modifier_sled_penguin_movement1" ) == nil then
				self:Destroy()
				return
			end
			--local attachment = self:GetCaster()ScriptLookupAttachment( )
			me:SetOrigin( self:GetCaster():GetOrigin() )
			local casterAngles = self:GetCaster():GetAngles() 
			me:SetAbsAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_movement1:GetOverrideAnimation( params )
	if self:GetParent() ~= self:GetCaster() then
		return ACT_DOTA_FLAIL
	end
	return ACT_DOTA_SLIDE_LOOP
end


-----------------------------------------------------------------------

function modifier_sled_penguin_movement1:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType == DOTA_UNIT_ORDER_MOVE_TO_POSITION or nOrderType == DOTA_UNIT_ORDER_ATTACK_MOVE then
			if hOrderedUnit == self:GetParent() and self:GetParent() ~= self:GetCaster() then
				local vDir = params.new_pos - self:GetCaster():GetOrigin()
				vDir.z = 0
				vDir = vDir:Normalized()
				local angles = VectorAngles( vDir )
				local hBuff = self:GetCaster():FindModifierByName( "modifier_sled_penguin_movement1" )
				if hBuff ~= nil then
					hBuff.flDesiredYaw = angles.y
				end	
			end
		end

	end
	return 0
end

-----------------------------------------------------------------------

function modifier_sled_penguin_movement1:GetModifierDisableTurning( params )
	return 1
end