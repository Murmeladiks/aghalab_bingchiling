LinkLuaModifier("modifier_juggernaut_blade_dance_stack_think", "heroes/juggernaut/modifier_juggernaut_blade_dance_stack_think", LUA_MODIFIER_MOTION_NONE)
modifier_aghsfort_juggernaut_blade_dance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_juggernaut_blade_dance:IsHidden()
	return true
end

function modifier_aghsfort_juggernaut_blade_dance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_dance:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetLevelSpecialValueFor( "blade_dance_crit_chance", self:GetAbility():GetLevel() - 1 )
	self.crit_mult = self:GetAbility():GetLevelSpecialValueFor( "blade_dance_crit_mult", self:GetAbility():GetLevel() - 1 )

	local caster = self:GetCaster()
	

	
end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_dance:OnRefresh( kv )
	self.crit_chance = self:GetAbility():GetLevelSpecialValueFor( "blade_dance_crit_chance", self:GetAbility():GetLevel() - 1 )
	self.crit_mult = self:GetAbility():GetLevelSpecialValueFor( "blade_dance_crit_mult", self:GetAbility():GetLevel() - 1 )
end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_dance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_dance:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then
			return
		end

		-- Throw dice
		if RandomInt(0, 100) < self.crit_chance then
			self.record = params.record
			
			return self.crit_mult
		end
	end
end

--------------------------------------------------------------------------------

function modifier_aghsfort_juggernaut_blade_dance:GetModifierProcAttack_Feedback( params )
	if not IsServer() or not self.record or self.record ~= params.record then return end

	self.record = nil

	local caster = self:GetCaster()
	local ability = self:GetAbility()



	if self:GetCaster():HasAbility("aghsfort_special_juggernaut_blade_dance_cooldown") then
		local omnislash = caster:FindAbilityByName("aghsfort_juggernaut_omni_slash")
		
		if omnislash:GetCooldownTimeRemaining() > 0.75 then
			local cd = omnislash:GetCooldownTimeRemaining()
			omnislash:EndCooldown()
			omnislash:StartCooldown(cd - 0.75)
		end
	end
	if self:GetCaster():HasAbility("aghsfort_special_juggernaut_blade_dance_buff") then
		local buffModifier =  self:GetCaster():AddNewModifier(self:GetCaster(), nil,"modifier_juggernaut_blade_dance_stack_think", {duration=7})
		if(buffModifier) then
			buffModifier:AddStack()	
		end
	end

	EmitSoundOn("Hero_Juggernaut.BladeDance", params.target)
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
