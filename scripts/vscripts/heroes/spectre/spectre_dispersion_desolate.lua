spectre_dispersion_desolate= class( {} )

LinkLuaModifier( "modifier_spectre_dispersion_desolate", "heroes/spectre/spectre_dispersion_desolate", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_dispersion_desolate:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_desolate"
end



modifier_spectre_dispersion_desolate= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_dispersion_desolate:IsHidden()
	return true
end

function modifier_spectre_dispersion_desolate:IsPurgeException()
	return false
end

function modifier_spectre_dispersion_desolate:IsPurgable()
	return false
end

function modifier_spectre_dispersion_desolate:IsPermanent()
	return true
end


function modifier_spectre_dispersion_desolate:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_spectre_dispersion_desolate:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_spectre_dispersion_desolate:OnTakeDamage(params)
    if not IsServer() then
        return
    end

     if params.attacker == self:GetParent() then
         return
     end
     if params.unit == self:GetParent() then
        self.spectre_desolate = self:GetParent():FindAbilityByName("spectre_desolate")
        self.spectre_dispersion = self:GetParent():FindAbilityByName("spectre_dispersion")
        if self.spectre_desolate and self.spectre_desolate:GetLevel()>0 and self.spectre_dispersion and self.spectre_dispersion:GetLevel()>0 then
            local damage = self.spectre_desolate:GetSpecialValueFor("bonus_damage")
            local radius = self.spectre_dispersion:GetSpecialValueFor("max_radius")
            print("dispersion_desolate")
            print(damage)
            self.damageTable = {
                --victim = params.attacker,
                attacker = self:GetParent(),
                damage =  damage,
                damage_type = DAMAGE_TYPE_PURE,
                ability = self.spectre_desolate, 
                
            }
            local enemies = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),	-- int, your team number
                self:GetParent():GetOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                0,	-- int, flag filter
                0,	-- int, order filter
                false	-- bool, can grow cache
            )
            for _,enemy in pairs(enemies) do
                if enemy then
                    self.damageTable.victim = enemy
                    ApplyDamage(self.damageTable)
                    self:PlayEffects( enemy )
                end
            end
        
        end
    end
        
 
    

end
function modifier_spectre_dispersion_desolate:PlayEffects( target )
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