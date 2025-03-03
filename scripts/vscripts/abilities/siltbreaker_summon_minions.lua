
siltbreaker_summon_minions = class({})
LinkLuaModifier( "modifier_siltbreaker_summon_minions", "modifiers/modifier_siltbreaker_summon_minions", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_summon_minions:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function siltbreaker_summon_minions:OnAbilityPhaseStart()
	if IsServer() then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )
		local fImmuneDuration = self.channel_duration + self:GetCastPoint()
		--self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_immunity", { duration = fImmuneDuration } )
		
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions:OnAbilityPhaseInterrupted()
	if IsServer() then
		
	end 
end

--------------------------------------------------------------------------------

function siltbreaker_summon_minions:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_summon_minions", {} )
	end
end

-----------------------------------------------------------------------------

function siltbreaker_summon_minions:OnChannelFinish( bInterrupted )
	if IsServer() then
		
		
		self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_summon_minions" )
	end
end

-----------------------------------------------------------------------------

