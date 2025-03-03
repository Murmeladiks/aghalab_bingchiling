aghsfort_phantom_assassin_coup_de_grace_multiple = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_coup_de_grace_multiple", "heroes/phantom_assassin/aghsfort_phantom_assassin_coup_de_grace_multiple", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------


function aghsfort_phantom_assassin_coup_de_grace_multiple:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_coup_de_grace_multiple"
end
modifier_aghsfort_phantom_assassin_coup_de_grace_multiple = class({})
function modifier_aghsfort_phantom_assassin_coup_de_grace_multiple:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_coup_de_grace_multiple:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_coup_de_grace_multiple:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_coup_de_grace_multiple:OnCreated(kv)
	self.chance = 30
end

function modifier_aghsfort_phantom_assassin_coup_de_grace_multiple:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_aghsfort_phantom_assassin_coup_de_grace_multiple:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_coup_de_grace")
	if self.ability and self.ability:GetLevel()> 0 then
		if params.target:HasModifier("modifier_phantom_assassin_mark_of_death") then
			local basedamage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())
			local crit_bonus = self.ability:GetSpecialValueFor("crit_bonus")
			local damage = basedamage * crit_bonus/100
			print(damage)
			
			local damageTable = {
				victim = params.target,
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self.ability,
			}
			
					Timers:CreateTimer(0.5, function()
						ApplyDamage(damageTable)
						local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
						local sound_cast = "Hero_PhantomAssassin.Spatter"

						-- Create Particle
						local nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, params.target )
						local direction = RandomVector(1)

						ParticleManager:SetParticleControlEnt( nFXIndex, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, params.target:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, direction )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( sound_cast, params.target )
					end)
					Timers:CreateTimer(1, function()
						ApplyDamage(damageTable)
						local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
						local sound_cast = "Hero_PhantomAssassin.Spatter"

						-- Create Particle
						local nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, params.target )
						local direction = RandomVector(1)

						ParticleManager:SetParticleControlEnt( nFXIndex, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, params.target:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, direction )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( sound_cast, params.target )
					end)
					Timers:CreateTimer(1.5, function()
						ApplyDamage(damageTable)
						local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
						local sound_cast = "Hero_PhantomAssassin.Spatter"

						-- Create Particle
						local nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, params.target )
						local direction = RandomVector(1)

						ParticleManager:SetParticleControlEnt( nFXIndex, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, params.target:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, direction )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, params.target, PATTACH_ABSORIGIN_FOLLOW, nil, params.target:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( sound_cast, params.target )
					end)
			
			

		end 
	end
   
        
        
   
        
end










