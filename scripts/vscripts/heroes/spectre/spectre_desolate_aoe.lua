spectre_desolate_aoe = class( {} )

LinkLuaModifier( "modifier_spectre_desolate_aoe", "heroes/spectre/spectre_desolate_aoe", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_desolate_aoe:GetIntrinsicModifierName()
	return "modifier_spectre_desolate_aoe"
end
modifier_spectre_desolate_aoe = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_desolate_aoe:IsHidden()
	return true
end


function modifier_spectre_desolate_aoe:IsPurgable()
	return false
end

function modifier_spectre_desolate_aoe:AllowIllusionDuplicate()
	return true
end

function modifier_spectre_desolate_aoe:OnCreated( kv )
	if not IsServer() then return end
	
end

function modifier_spectre_desolate_aoe:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_spectre_desolate_aoe:OnAttackLanded( params )
	if params.attacker~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	self.spectre_desolate = self:GetParent():FindAbilityByName("spectre_desolate")
	if self.spectre_desolate and self.spectre_desolate:GetLevel()>0 then
		local bonus = self.spectre_desolate:GetSpecialValueFor( "bonus_damage" )
		self.damageTable = {
			--victim = enemy,
			attacker = self:GetParent(),
			damage = bonus,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self.spectre_desolate, --Optional.
		}
		
		
		local enemies = FindUnitsInRadius(
			params.target:GetTeamNumber(),	-- int, your team number
			params.target:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		
		
		for _,enemy in pairs(enemies) do
			if enemy~=params.target then
				self.damageTable.victim = enemy
				ApplyDamage(self.damageTable)
				self:PlayEffects( enemy )
			end
        end
	end
   
        
        
       
    
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_spectre_desolate_aoe:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
	local sound_cast = "Hero_Spectre.Desolate"

	-- Get Data
	local forward = (self:GetParent():GetOrigin()-target:GetOrigin())--:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end




