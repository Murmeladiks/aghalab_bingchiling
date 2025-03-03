LinkLuaModifier( "modifier_kobold_soul_chain", "modifiers/creatures/modifier_kobold_soul_chain", LUA_MODIFIER_MOTION_NONE )

kobold_soul_chain = class({})

--------------------------------------------------------------------------------

function kobold_soul_chain:Precache(context)
    if IsServer() then
        PrecacheResource( "particle", "particles/units/heroes/hero_grimstroke/grimstroke_cast_soulchain.vpcf", context )
       
    end
end

function kobold_soul_chain:IsHiddenAbilityCastable()
    return true
end

function kobold_soul_chain:GetAOERadius()
	return self:GetSpecialValueFor( "chain_latch_radius" )
end


--------------------------------------------------------------------------------

function kobold_soul_chain:OnSpellStart()
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end
	if target:IsIllusion() then return end
	
	-- load data
	local duration = self:GetSpecialValueFor( "chain_duration" )

	-- add modifier
	
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_kobold_soul_chain", -- modifier name
		{ 
			duration = duration,
			primary = true,
		 } -- kv
	)
	
print(target:GetName())
	-- play effects
	self:PlayEffects( target )
end

--------------------------------------------------------------------------------
function kobold_soul_chain:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_grimstroke/grimstroke_cast_soulchain.vpcf"
	local sound_cast = "Hero_Grimstroke.SoulChain.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end