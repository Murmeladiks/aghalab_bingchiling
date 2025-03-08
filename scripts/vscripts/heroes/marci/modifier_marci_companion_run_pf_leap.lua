---@class modifier_marci_companion_run_pf_leap:CDOTA_Modifier_Lua
modifier_marci_companion_run_pf_leap = class({})

function modifier_marci_companion_run_pf_leap:IsHidden() return true end
function modifier_marci_companion_run_pf_leap:IsDebuff() return false end
function modifier_marci_companion_run_pf_leap:IsPurgable() return false end

function modifier_marci_companion_run_pf_leap:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_marci_companion_run_pf_leap:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_marci_companion_run_pf_leap:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

if IsClient() then return end

function modifier_marci_companion_run_pf_leap:OnCreated(kv)
	self.target = EntIndexToHScript(kv.target)
	if not self.target then self:Destroy() end

	self.last_valid_pos = self.target:GetAbsOrigin()

	local parent = self:GetParent()

	local distance = parent:GetRangeToUnit(self.target)
	self.speed = 1200

	local start_pos = parent:GetAbsOrigin()
	local end_pos = self.target:GetAbsOrigin()

	local height_start = GetGroundHeight(start_pos, parent)
	local height_end = GetGroundHeight(end_pos, parent)
	local height = height_start + distance / 2

	self.initial_distance = distance
	self:InitVerticalArc(height_start, height, height_end, 1)

	parent:SetForwardVector((end_pos-start_pos):Normalized())

	if (distance / self.speed) > 0.3 then
		parent:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	end


	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	if not self:ApplyVerticalMotionController() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_marci_companion_run_pf_leap:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveHorizontalMotionController(self)
	self:GetParent():RemoveVerticalMotionController(self)

	if self.interrupted then return end

	if self.dodged then
		self:GetAbility():OnTargetReachedSelfCast()
	else
		self:GetAbility():OnTargetReachedSelfCast(self.target)
	end
end

function modifier_marci_companion_run_pf_leap:UpdateHorizontalMotion(me, dt)
	local target_pos = self.last_valid_pos
	local parent_pos = me:GetAbsOrigin()

	if not self.dodged then
		if IsValidEntity(self.target) and self.target:IsAlive() then
			target_pos = self.target:GetAbsOrigin()
		else
			self.dodged = true
		end
	end

	-- if target moves too fast mark it dodged
	if (target_pos - self.last_valid_pos):Length2D() / dt > self.speed then 
		self.dodged = true
	end

	local diff = target_pos - parent_pos
	local distance = diff:Length2D()

	if distance <= 64 then
		--target reached
		self:Destroy()
	end

	local dir = diff:Normalized()
	local new_pos = parent_pos + dir * dt * self.speed

	me:SetAbsOrigin(new_pos)
end

function modifier_marci_companion_run_pf_leap:UpdateVerticalMotion(me, dt)
	local target_pos = self.last_valid_pos
	local pos = me:GetAbsOrigin()

	if not self.dodged then
		if IsValidEntity(self.target) and self.target:IsAlive() then
			target_pos = self.target:GetAbsOrigin()
		else
			self.dodged = true
		end
	end

	-- if target change height during fly adjust Marci height accordingly
	local diff_z = target_pos.z - self.last_valid_pos.z
	self.last_valid_pos = target_pos

	local diff = target_pos - pos
	local distance = diff:Length2D()

	-- lil hack since target can move and arrive time can vary, so height controller use distance, not time
	local time = Clamp(self.initial_distance - distance, 0, self.initial_distance) / self.initial_distance

	local z = pos.z + self:GetVerticalSpeed(time) * dt + diff_z
	pos.z = z
	me:SetAbsOrigin(pos)

	local ground = GetGroundHeight( pos, me ) 
	if pos.z <= ground then

		-- below ground, set height as ground then destroy
		pos.z = ground
		me:SetOrigin( pos )
		self:Destroy()
	end
end

function modifier_marci_companion_run_pf_leap:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_marci_companion_run_pf_leap:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_marci_companion_run_pf_leap:InitVerticalArc(height_start, height_max, height_end, duration)
	local height_end = height_end - height_start
	local height_max = height_max - height_start

	-- fail-safe1: height_max cannot be smaller than height delta
	if height_max < height_end then
		height_max = height_end + 0.01
	end

	-- fail-safe2: height-max must be positive
	if height_max <= 0 then
		height_max = 0.01
	end

	-- math magic
	local duration_end = ( 1 + math.sqrt( 1 - height_end / height_max ) ) / 2
	self.const1 = 4 * height_max * duration_end / duration
	self.const2 = 4 * height_max * duration_end * duration_end / (duration * duration)
end

function modifier_marci_companion_run_pf_leap:GetVerticalPos(time)
	return self.const1 * time - self.const2 * time * time
end

function modifier_marci_companion_run_pf_leap:GetVerticalSpeed(time)
	return self.const1 - 2 * self.const2 * time
end