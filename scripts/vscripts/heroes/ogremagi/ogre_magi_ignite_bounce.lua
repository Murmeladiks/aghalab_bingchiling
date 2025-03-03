ogre_magi_ignite_bounce = class( {} )

LinkLuaModifier( "modifier_ogre_magi_ignite_bounce", "heroes/ogremagi/ogre_magi_ignite_bounce", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ogre_magi_ignite_bounce:GetIntrinsicModifierName()
	return "modifier_ogre_magi_ignite_bounce"
end
function ogre_magi_ignite_bounce:OnSpellStart()
    self.ogre_magi_ignite = self:GetCaster():FindAbilityByName("ogre_magi_ignite")
  
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local projectile_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf"
	local projectile_speed = self.ogre_magi_ignite:GetSpecialValueFor( "projectile_speed" )
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
                        Ability = self.ogre_magi_ignite,	
                        
                        EffectName = projectile_name,
                        iMoveSpeed = projectile_speed,
                        bDodgeable = false,                           -- Optional
                    
                        bVisibleToEnemies = true,                         -- Optional
                        bProvidesVision = true,                           -- Optional
                        iVisionRadius = projectile_vision,                              -- Optional
                        iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
                        ExtraData = {
                            
                        }
                    }
                    ProjectileManager:CreateTrackingProjectile(info)
                
                    -- Play effects
                    local sound_cast = "Hero_Alchemist.UnstableConcoction.Throw"
                    EmitSoundOn( sound_cast, target )
                end
    
 

end



modifier_ogre_magi_ignite_bounce = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_ignite_bounce:IsHidden()
	return true
end

function modifier_ogre_magi_ignite_bounce:IsPurgeException()
	return false
end

function modifier_ogre_magi_ignite_bounce:IsPurgable()
	return false
end

function modifier_ogre_magi_ignite_bounce:IsPermanent()
	return true
end


function modifier_ogre_magi_ignite_bounce:OnCreated( kv )
	if IsServer() then
        self.count = 0
    end
end

function modifier_ogre_magi_ignite_bounce:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function  modifier_ogre_magi_ignite_bounce:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    
        
    if  params.ability:GetAbilityName() == "ogre_magi_ignite" then
       self.target = params.ability:GetCursorTarget()
    end

end

function  modifier_ogre_magi_ignite_bounce:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "ogre_magi_ignite" then
        if params.unit == self.target then
            if self.count < 3 then
                if self.target then
                    self:GetCaster():SetCursorCastTarget(params.unit)
                    self.ability = self:GetAbility()
                    self.ability:OnSpellStart()
                    self.count = self.count + 1
                end
            else
                self.count=0
            end
        end  
    end

end