modifier_marci_companion_run_pf = class({})

function modifier_marci_companion_run_pf:IsHidden() return true end
function modifier_marci_companion_run_pf:IsDebuff() return false end
function modifier_marci_companion_run_pf:IsPurgable() return false end

function modifier_marci_companion_run_pf:OnCreated(kv)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if not IsServer() then return end
	self.projectile = tonumber(kv.proj)
	self.target = EntIndexToHScript( kv.target )

	-- precaution against non-dodging TPs
	self.targetpos = self.target:GetOrigin()
	self.distancethreshold = 1000

	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	local speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self:PlayEffects1( self.parent, speed )
end

function modifier_marci_companion_run_pf:OnDestroy()
	if not IsServer() then return end	
	self.parent:RemoveHorizontalMotionController( self )

	if self.interrupted then return end

	self.ability:OnTargetReached(self.target)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_marci_companion_run_pf:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_marci_companion_run_pf:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2_ALLY
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_marci_companion_run_pf:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_marci_companion_run_pf:UpdateHorizontalMotion(me, dt)
	-- precaution against non-dodging tps
	local targetpos = self.target:GetOrigin()
	if (targetpos - self.targetpos):Length2D() > self.distancethreshold then
		self.dodged = true
		self.interrupted = true
		return
	end
	self.targetpos = targetpos
	local loc = ProjectileManager:GetTrackingProjectileLocation(self.projectile)
	me:SetAbsOrigin(GetGroundPosition(loc, me))

	-- Call Dispose OnAbilityPhaseStart to vacuum units to throw them after that (if we have corresponging shards)
	local grapple = self.parent:FindAbilityByName("marci_grapple_pf")
	local global_shard = self.parent:FindAbilityByName("pathfinder_marci_companion_run_global")
	if grapple and grapple:IsTrained() and global_shard and not self.grapple_global_shard_done then
		local is_close_enough = (loc - targetpos):Length2D() <= self.ability:GetSpecialValueFor("move_speed") * grapple:GetCastPoint()
		if is_close_enough  then
			self.grapple_global_shard_done = true
			self.parent:SetCursorCastTarget(self.target)
			grapple:OnAbilityPhaseStart()
		end
	end
end

function modifier_marci_companion_run_pf:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_marci_companion_run_pf:PlayEffects1(caster, speed)
	local sound_cast = "Hero_Marci.Rebound.Cast"

	EmitSoundOn(sound_cast, caster)
end