modifier_juggernaut_blade_fury_pull = class({})

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_pull:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_pull:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_pull:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_pull:OnCreated( kv )
	if IsServer() then
		self.drag_speed = 220
		print("drag_speed")
		print(self.drag_speed)
		self.fLastThinkTime = GameRules:GetGameTime()
		self.hOwner = self:GetAuraOwner()
		self:StartIntervalThink( 0 )
		local hOwner = self:GetAuraOwner()
		if hOwner ~= nil and hOwner:IsNull() == false and hOwner:IsAlive() == true then
			

			local vOrigin = hOwner:GetAbsOrigin()

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_enigma/enigma_black_hole_scepter_pull_debuff.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, vOrigin )
			self:AddParticle( nFXIndex, false, false, -1, false, false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_pull:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_fury_pull:OnIntervalThink()
	if IsServer() then
		if self:GetParent() and not self:GetParent():IsNull() and self:GetParent():IsAlive() then
			local nDragSpeed = self.drag_speed

			local dt = GameRules:GetGameTime() - self.fLastThinkTime
			self.fLastThinkTime = GameRules:GetGameTime()

			local hOwner = self:GetAuraOwner()
			if hOwner ~= nil and hOwner:IsNull() == false and hOwner:IsAlive() == true then
				local vOrigin = hOwner:GetAbsOrigin()
				vOrigin.z = 0
				local vPos = self:GetParent():GetAbsOrigin()
				vPos.z = 0
				local vPullDir = vOrigin - vPos

				local fDistToDestination = vPullDir:Length2D()
				local fMaxTravelDistance = nDragSpeed * dt
				local fTravelDistance = math.min( fDistToDestination, fMaxTravelDistance )

				local vPullVec
				if fDistToDestination == 0 then
					vPullVec = Vector( 0, 0, 0 )
				else
					vPullVec = fTravelDistance * vPullDir:Normalized()
				end

				self:GetParent():SetAbsOrigin( self:GetParent():GetAbsOrigin() + vPullVec )
			end
		end
	end
end
