alchemist_unstable_concoction_bounce = class( {} )

LinkLuaModifier( "modifier_alchemist_unstable_concoction_bounce", "heroes/alchemist/alchemist_unstable_concoction_bounce", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function alchemist_unstable_concoction_bounce:GetIntrinsicModifierName()
	return "modifier_alchemist_unstable_concoction_bounce"
end
function alchemist_unstable_concoction_bounce:OnSpellStart()
    self.alchemist_unstable_concoction_throw = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction_throw")
  
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = self.alchemist_unstable_concoction_throw:GetSpecialValueFor( "projectile_speed" )
	local projectile_vision = 200
    local Range = 700
                local enemies = FindUnitsInRadius(
                    caster:GetTeamNumber(),	-- int, your team number
                    target:GetAbsOrigin(),	-- point, center point
                    nil,	-- handle, cacheUnit. (not known)
                    Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                    DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                    FIND_CLOSEST,	-- int, order filter
                    false
                )
                if enemies[#enemies] and not enemies[#enemies]:IsNull() and enemies[#enemies]:IsAlive() and not enemies[#enemies]:IsInvulnerable() then
                    local info = {
                        Target = enemies[#enemies],
                        Source = target,
                        Ability = self.alchemist_unstable_concoction_throw,	
                        
                        EffectName = projectile_name,
                        iMoveSpeed = projectile_speed,
                        bDodgeable = false,                           -- Optional
                    
                        bVisibleToEnemies = true,                         -- Optional
                        bProvidesVision = true,                           -- Optional
                        iVisionRadius = projectile_vision,                              -- Optional
                        iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
                        ExtraData = {
                            brew_time = 0,
                        }
                    }
                    ProjectileManager:CreateTrackingProjectile(info)
                
                    -- Play effects
                    local sound_cast = "Hero_Alchemist.UnstableConcoction.Throw"
                    EmitSoundOn( sound_cast, target )
                end
    
 

end



modifier_alchemist_unstable_concoction_bounce = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_alchemist_unstable_concoction_bounce:IsHidden()
	return true
end

function modifier_alchemist_unstable_concoction_bounce:IsPurgeException()
	return false
end

function modifier_alchemist_unstable_concoction_bounce:IsPurgable()
	return false
end

function modifier_alchemist_unstable_concoction_bounce:IsPermanent()
	return true
end


function modifier_alchemist_unstable_concoction_bounce:OnCreated( kv )
	if IsServer() then
        
    end
end

function modifier_alchemist_unstable_concoction_bounce:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function  modifier_alchemist_unstable_concoction_bounce:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    
        
    if  params.ability:GetAbilityName() == "alchemist_unstable_concoction_throw" then
       self.target = params.ability:GetCursorTarget()
    end

end

function  modifier_alchemist_unstable_concoction_bounce:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "alchemist_unstable_concoction_throw" then
        if params.unit == self.target then
            --防止所有受到伤害的都发射弹道
            self:GetCaster():SetCursorCastTarget(params.unit)
            self.ability = self:GetAbility()
            self.ability:OnSpellStart()
        end  
    end

end