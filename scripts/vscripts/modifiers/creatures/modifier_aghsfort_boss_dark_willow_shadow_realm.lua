
--------------------------------------------------------------------------------
modifier_aghsfort_boss_dark_willow_shadow_realm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_boss_dark_willow_shadow_realm:IsHidden()
	return false
end

function modifier_aghsfort_boss_dark_willow_shadow_realm:IsDebuff()
	return false
end

function modifier_aghsfort_boss_dark_willow_shadow_realm:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_aghsfort_boss_dark_willow_shadow_realm:OnCreated( kv )
	-- references
	




	if not IsServer() then return end
	-- set creation time
	self.create_time = GameRules:GetGameTime()

	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )

	-- stop if currently attacking


	self:PlayEffects()
end

function modifier_aghsfort_boss_dark_willow_shadow_realm:OnRefresh( kv )
	-- references


	if not IsServer() then return end
	-- dodge projectiles
	ProjectileManager:ProjectileDodge( self:GetParent() )
end

function modifier_aghsfort_boss_dark_willow_shadow_realm:OnRemoved()
end

function modifier_aghsfort_boss_dark_willow_shadow_realm:OnDestroy()
	-- stop sound
	local sound_cast = "Hero_DarkWillow.Shadow_Realm"
	StopSoundOn( sound_cast, self:GetParent() )
end


--------------------------------------------------------------------------------
-- Status Effects
function modifier_aghsfort_boss_dark_willow_shadow_realm:CheckState()
	local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_aghsfort_boss_dark_willow_shadow_realm:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_aghsfort_boss_dark_willow_shadow_realm:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf"
	local sound_cast = "Hero_DarkWillow.Shadow_Realm"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end