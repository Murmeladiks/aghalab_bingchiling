queenofpain_blink_scream = class( {} )

LinkLuaModifier( "modifier_queenofpain_blink_scream", "heroes/queenofpain/queenofpain_blink_scream", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function queenofpain_blink_scream:GetIntrinsicModifierName()
	return "modifier_queenofpain_blink_scream"
end
function queenofpain_blink_scream:OnSpellStart()
	if IsServer() then
        local maintarget = self:GetCursorTarget()
        local point = maintarget:GetAbsOrigin()
        self.ability = self:GetCaster():FindAbilityByName("queenofpain_scream_of_pain")
        local radius = self.ability:GetSpecialValueFor("area_of_effect")
        self.screamDamage = self.ability:GetSpecialValueFor("damage")
        print(self.screamDamage)
        local projectile_name = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf"
        local projectile_speed = self.ability:GetSpecialValueFor("projectile_speed")

        -- Find Units in Radius
        local enemies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),	-- int, your team number
            point,	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            0,	-- int, flag filter
            0,	-- int, order filter
            false	-- bool, can grow cache
        )

        -- Prebuilt Projectile info
        local info = {
            -- Target = target,
            Source = maintarget,
            Ability = self.ability,	
            EffectName = projectile_name,
            iMoveSpeed = projectile_speed,
            vSourceLoc= point,                -- Optional (HOW)
            bDodgeable = false,                                -- Optional
            bVisibleToEnemies = true,                         -- Optional
            bReplaceExisting = false,                         -- Optional
            bProvidesVision = false,                           -- Optional
        }

        -- create projectile to all enemies hit
        for _,enemy in pairs(enemies) do
            info.Target = enemy
            ProjectileManager:CreateTrackingProjectile(info)
        end

        -- Play effects
        self:PlayEffects( maintarget )
    end
end
function queenofpain_blink_scream:OnProjectileHit( target, location )
	if IsServer() then
        -- Apply Damage	 
        local damageTable = {
            victim = target,
            attacker = self:GetCaster(),
            damage = self.screamDamage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability, --Optional.
        }
        ApplyDamage(damageTable)
    end
end
function queenofpain_blink_scream:PlayEffects(maintarget  )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf"
	local sound_cast = "Hero_QueenOfPain.ScreamOfPain"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, maintarget )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn(sound_cast, maintarget )
end
modifier_queenofpain_blink_scream = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_blink_scream:IsHidden()
	return true
end

function modifier_queenofpain_blink_scream:IsPurgeException()
	return false
end

function modifier_queenofpain_blink_scream:IsPurgable()
	return false
end

function modifier_queenofpain_blink_scream:IsPermanent()
	return true
end



function modifier_queenofpain_blink_scream:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_queenofpain_blink_scream:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end
function modifier_queenofpain_blink_scream:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "queenofpain_blink" then
        return
    end
    
    if params.unit:FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then
        print("blink")
        self.blink = true
        local vPos = self:GetParent():GetAbsOrigin()
        self.dummy = CreateUnitByName("npc_dota_dummy_caster_queen", vPos, true, nil, nil, DOTA_TEAM_GOODGUYS)
   end
end
 
   
    

function modifier_queenofpain_blink_scream:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "queenofpain_blink" then
        return
    end
    
       if params.unit:FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then
            self.queenofpain_scream_of_pain = params.unit:FindAbilityByName("queenofpain_scream_of_pain")
            self.queenofpain_scream_of_pain:OnSpellStart()
            if self.blink then
                print("dummy")
                params.unit:SetCursorCastTarget(self.dummy)
                self:GetAbility():OnSpellStart()
                Timers:CreateTimer(0.5, function()
                    UTIL_Remove(self.dummy)
                end)
                
            end 
       end
    

        
end

