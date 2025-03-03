modifier_juggernaut_mana_ward_passive = class({})
LinkLuaModifier( "modifier_juggernaut_mana_ward_effect", "heroes/juggernaut/modifier_juggernaut_mana_ward_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_mana_ward_passive:IsHidden()
	return true
end

function modifier_juggernaut_mana_ward_passive:IsDebuff()
	return false
end

function modifier_juggernaut_mana_ward_passive:IsPurgable()
	return false
end

local pfx

--------------------------------------------------------------------------------
-- Aura
function modifier_juggernaut_mana_ward_passive:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_juggernaut_mana_ward_passive:GetModifierAura()
	return "modifier_juggernaut_mana_ward_effect"
end

function modifier_juggernaut_mana_ward_passive:GetAuraRadius()
	if IsServer() then		
		return self:GetCaster():GetOwner():FindAbilityByName("juggernaut_healing_ward"):GetLevelSpecialValueFor("healing_ward_aura_radius", self:GetCaster():GetOwner():FindAbilityByName("juggernaut_healing_ward"):GetLevel() - 1)
	end
end

function modifier_juggernaut_mana_ward_passive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_juggernaut_mana_ward_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_juggernaut_mana_ward_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_juggernaut_mana_ward_passive:OnIntervalThink()
	
end

function modifier_juggernaut_mana_ward_passive:CheckState()
	return
	{
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end


function modifier_juggernaut_mana_ward_passive:PlayEffects()

	
	local particle_cast = "particles/econ/items/witch_doctor/wd_ti10_immortal_weapon/wd_ti10_immortal_voodoo.vpcf"
	sound_cast = "Hero_Juggernaut.HealingWard.Loop"


	local healing_ward_ambient_pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( healing_ward_ambient_pfx, 1, Vector( self:GetAbility():GetCaster():GetOwner():FindAbilityByName("juggernaut_healing_ward"):GetLevelSpecialValueFor("healing_ward_aura_radius", self:GetAbility():GetCaster():GetOwner():FindAbilityByName("juggernaut_healing_ward"):GetLevel() - 1), 0, 450) )



	pfx = healing_ward_ambient_pfx


	EmitSoundOn( sound_cast, self:GetParent() )

	local eruption_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(eruption_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(eruption_pfx)


		
end

function modifier_juggernaut_mana_ward_passive:OnDeath(params) 
	if params.unit ~= self:GetParent() then return end
	StopSoundOn("Hero_Juggernaut.HealingWard.Loop", self:GetParent())
	self:GetAbility():GetCaster():GetOwner().active_healing_ward = nil
	if pfx then
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end

end

function modifier_juggernaut_mana_ward_passive:OnCreated( kv )
	self:StartIntervalThink(0.75)
	-- PlayEffects
	if self:GetCaster() and IsServer() then
		self:PlayEffects()
	end
end
