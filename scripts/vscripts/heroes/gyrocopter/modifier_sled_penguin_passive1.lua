modifier_sled_penguin_passive1 = class({})
----------------------------------------------------------------------------------

function modifier_sled_penguin_passive1:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive1:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive1:OnCreated( kv )
	if IsServer() then
		self.hPlayerEnt = nil
		self.bRideComplete = false
		self.bRideStarted = false
	end
end



----------------------------------------------------------------------------------

function modifier_sled_penguin_passive1:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

-----------------------------------------------------------------------

function modifier_sled_penguin_passive1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_sled_penguin_passive1:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			return
		end

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() then
			return
		end

		

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and
			not hOrderedUnit:HasModifier("modifier_sled_penguin_movement1") 
		then
			self.hPlayerEnt = hOrderedUnit
			
			self:StartIntervalThink( 0.25 )
		else
			CustomGameEventManager:Send_ServerToPlayer(hOrderedUnit:GetPlayerOwner(), "custom_dota_hud_error_message", {reason = 80, message = "This Penguin Is Reserved!"})
		end
	end

	return 0
end


-----------------------------------------------------------------------

function modifier_sled_penguin_passive1:OnIntervalThink()
	if IsServer() then
		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 200.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Aghanim ~= nil and self.bRideStarted == false then
					self.hPlayerEnt:Interrupt()
					
					self:StartIntervalThink( -1 )
					self.bRideStarted = true
					EmitSoundOn( "Hero_Tusk.IceShards.Penguin", self:GetParent() )
					self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sled_penguin_movement1", {} )
					self.hPlayerEnt:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sled_penguin_movement1", {} )
					self.hPlayerEnt.penguinRideStarted = true
					self.hPlayerEnt.penguinResered = false

					
				end
			end
		end
	end
end

