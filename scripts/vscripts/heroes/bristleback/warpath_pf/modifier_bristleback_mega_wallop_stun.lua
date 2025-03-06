modifier_bristleback_mega_wallop_stun = class({})

function modifier_bristleback_mega_wallop_stun:RemoveOnDeath() return false end
function modifier_bristleback_mega_wallop_stun:IsPurgable() return false end
function modifier_bristleback_mega_wallop_stun:IsHidden() return false end

function modifier_bristleback_mega_wallop_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_bristleback_mega_wallop_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

-- have you done parabola math before? you've done this in high school
function modifier_bristleback_mega_wallop_stun:GetVisualZDelta()
	return (self:GetElapsedTime() * self:GetRemainingTime()) * 1000
end

function modifier_bristleback_mega_wallop_stun:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end
