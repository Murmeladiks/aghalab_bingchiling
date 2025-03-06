modifier_bristleback_bloody_rage_debuff = class({})
function modifier_bristleback_bloody_rage_debuff:IsHidden() 	return false end
function modifier_bristleback_bloody_rage_debuff:IsDebuff() 	return true end
function modifier_bristleback_bloody_rage_debuff:IsStunDebuff() return false end
function modifier_bristleback_bloody_rage_debuff:IsPurgable() 	return false end


function modifier_bristleback_bloody_rage_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()

	if not IsServer() then return end
	-- added just in case
	self.caster:MakeVisibleDueToAttack(DOTA_TEAM_BADGUYS, 100)

	if self.parent:GetCurrentActiveAbility() then
		self:StartIntervalThink(FrameTime())
		self.active = false
	else
		self.parent:SetForceAttackTarget(self.caster) -- for creeps
		self.parent:MoveToTargetToAttack(self.caster) -- for heroes -- wut
		self.active = true
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_bloody_rage_debuff:OnRemoved()
	if not IsServer() then return end
	if self.parent and not self.parent:IsNull() then
		self.parent:SetForceAttackTarget(nil)
		self.active = false
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_bloody_rage_debuff:OnIntervalThink()
	if not self.parent:GetCurrentActiveAbility() then
		self:StartIntervalThink(-1)
		self.parent:SetForceAttackTarget(self.caster)
		self.parent:MoveToTargetToAttack(self.caster)
		self.active = true
	end
end

--------------------------------------------------------------------------------

function modifier_bristleback_bloody_rage_debuff:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.active,
		[MODIFIER_STATE_TAUNTED] = self.active
	}
end

--------------------------------------------------------------------------------

function modifier_bristleback_bloody_rage_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

