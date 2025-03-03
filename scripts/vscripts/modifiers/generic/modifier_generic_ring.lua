-- Created by Elfansoer
--[[
	Usage parameters
		kv.start_radius (0)
		kv.end_radius (0)
		kv.width (100)
		kv.speed (0)

		kv.target_team
		kv.target_type
		kv.target_flags

		kv.IsCircle (1) -- 0: expanding radius, 1: expanding donut with width (hollow inside)

	Callback set after creating modifier:
		modifier:SetCallback( function( unit ) ... end ) -- MANDATORY
		modifier:SetEndCallback( function() ... end )


]]
--------------------------------------------------------------------------------
modifier_generic_ring = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_ring:IsHidden()
	return true
end

function modifier_generic_ring:IsDebuff()
	return false
end

function modifier_generic_ring:IsStunDebuff()
	return false
end

function modifier_generic_ring:IsPurgable()
	return false
end

function modifier_generic_ring:RemoveOnDeath()
	return false
end

function modifier_generic_ring:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_ring:OnCreated( kv )

	if not IsServer() then return end

	-- references
	self.start_radius = kv.start_radius or 0
	self.end_radius = kv.end_radius or 0
	self.width = kv.width or 100
	self.speed = kv.speed or 0
	self.outward = self.end_radius>=self.start_radius
	if not self.outward then
		self.speed = -self.speed
	end

	self.target_team = kv.target_team or 0
	self.target_type = kv.target_type or 0
	self.target_flags = kv.target_flags or 0

	self.IsCircle = kv.IsCircle or 1

	self.targets = {}
end

function modifier_generic_ring:OnRemoved()
end

function modifier_generic_ring:OnDestroy()
	if self.EndCallback then
		self.EndCallback()
	end
	if not IsServer() then return end

	-- kill if thinker
	if self:GetParent():GetClassname()=="npc_dota_thinker" then
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_generic_ring:SetCallback( callback )
	self.Callback = callback

	-- Start interval
	self:StartIntervalThink( 0.03 )
	self:OnIntervalThink()
end

function modifier_generic_ring:SetEndCallback( callback )
	self.EndCallback = callback
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_generic_ring:OnIntervalThink()
	local radius = self.start_radius + self.speed * self:GetElapsedTime()
	if not self.outward and radius<self.end_radius then
		self:Destroy()
		return
	elseif self.outward and radius>self.end_radius then
		self:Destroy()
		return
	end

	-- Find targets in ring
	local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.target_team,	-- int, team filter
		self.target_type,	-- int, type filter
		self.target_flags,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,target in pairs(targets) do

		-- only unaffected unit
		if not self.targets[target] then

			-- check if it is within circle/chakram
			if (not self.IsCircle) or (target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()>(radius-self.width) then

				self.targets[target] = true

				-- do something
				self.Callback( target )
			end
		end

	end
end