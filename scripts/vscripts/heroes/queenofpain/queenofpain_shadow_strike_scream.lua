queenofpain_shadow_strike_scream = class( {} )

-- LinkLuaModifier( "modifier_queenofpain_shadow_strike_scream", "heroes/queenofpain/queenofpain_shadow_strike_scream", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_queenofpain_shadow_strike_scream_thinker", "heroes/queenofpain/queenofpain_shadow_strike_scream", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function queenofpain_shadow_strike_scream:GetIntrinsicModifierName()
	return "modifier_item_ultimate_scepter"
end
-- function queenofpain_shadow_strike_scream:OnSpellStart()
-- 	if IsServer() then
--         -- unit identifier
--         local maintarget = self:GetCursorTarget()
--         local point = maintarget:GetAbsOrigin()
--         self.ability = self:GetCaster():FindAbilityByName("queenofpain_scream_of_pain")
--         local radius = self.ability:GetSpecialValueFor("area_of_effect")
--         self.screamDamage = self.ability:GetSpecialValueFor("damage")
--         print(self.screamDamage)
--         local projectile_name = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf"
--         local projectile_speed = self.ability:GetSpecialValueFor("projectile_speed")

--         -- Find Units in Radius
--         local enemies = FindUnitsInRadius(
--             self:GetCaster():GetTeamNumber(),	-- int, your team number
--             point,	-- point, center point
--             nil,	-- handle, cacheUnit. (not known)
--             radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
--             DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
--             DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
--             0,	-- int, flag filter
--             0,	-- int, order filter
--             false	-- bool, can grow cache
--         )

--         -- Prebuilt Projectile info
--         local info = {
--             -- Target = target,
--             Source = maintarget,
--             Ability = self.ability,	
--             EffectName = projectile_name,
--             iMoveSpeed = projectile_speed,
--             vSourceLoc= point,                -- Optional (HOW)
--             bDodgeable = false,                                -- Optional
--             bVisibleToEnemies = true,                         -- Optional
--             bReplaceExisting = false,                         -- Optional
--             bProvidesVision = false,                           -- Optional
--         }

--         -- create projectile to all enemies hit
--         for _,enemy in pairs(enemies) do
--             info.Target = enemy
--             ProjectileManager:CreateTrackingProjectile(info)
--         end

--         -- Play effects
--         self:PlayEffects( maintarget )
--     end
-- end
-- function queenofpain_shadow_strike_scream:OnProjectileHit( target, location )
-- 	if IsServer() then
--         -- Apply Damage	 
--         local damageTable = {
--             victim = target,
--             attacker = self:GetCaster(),
--             damage = self.screamDamage,
--             damage_type = DAMAGE_TYPE_MAGICAL,
--             ability = self.ability, --Optional.
--         }
--         ApplyDamage(damageTable)
--     end
-- end
-- function queenofpain_shadow_strike_scream:PlayEffects( maintarget )
-- 	-- Get Resources
-- 	local particle_cast = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf"
-- 	local sound_cast = "Hero_QueenOfPain.ScreamOfPain"

-- 	-- Create Particle
-- 	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, maintarget )
-- 	ParticleManager:ReleaseParticleIndex( effect_cast )

-- 	-- Create Sound
-- 	EmitSoundOn(sound_cast, maintarget )
-- end
-- modifier_queenofpain_shadow_strike_scream = class({})

-- --------------------------------------------------------------------------------
-- -- Classifications
-- function modifier_queenofpain_shadow_strike_scream:IsHidden()
-- 	return true
-- end

-- function modifier_queenofpain_shadow_strike_scream:IsPurgeException()
-- 	return false
-- end

-- function modifier_queenofpain_shadow_strike_scream:IsPurgable()
-- 	return false
-- end

-- function modifier_queenofpain_shadow_strike_scream:IsPermanent()
-- 	return true
-- end



-- function modifier_queenofpain_shadow_strike_scream:OnCreated(kv)
--     if IsServer() then
        
       
   
-- end
-- end
-- function modifier_queenofpain_shadow_strike_scream:DeclareFunctions()
--     return {
--         MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
--         MODIFIER_EVENT_ON_MODIFIER_ADDED,
       
--     }
-- end
-- function modifier_queenofpain_shadow_strike_scream:OnModifierAdded(params)
--     if not IsServer() then
--         return
--     end
--     if params.added_buff:GetName() ~= "modifier_queenofpain_shadow_strike" then
--         return
--     end
    
--     local unit = params.unit
--     self.queenofpain_shadow_strike = self:GetParent():FindAbilityByName("queenofpain_shadow_strike")
--     local duraiton = self.queenofpain_shadow_strike:GetSpecialValueFor("duration") + 1
  
    
    
--     if not unit:HasModifier("modifier_queenofpain_shadow_strike_scream_thinker") then
--         unit:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_queenofpain_shadow_strike_scream_thinker",{duration = duration})
--     else
--         unit:RemoveModifierByName("modifier_queenofpain_shadow_strike_scream_thinker")
--         unit:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_queenofpain_shadow_strike_scream_thinker",{duration = duration})
--     end
-- end
 
   
    

-- function modifier_queenofpain_shadow_strike_scream:OnAbilityFullyCast(params)
--     if not IsServer() then
--         return
--     end
--     if params.unit ~= self:GetParent() then
--         return
--     end

--     if params.ability:GetAbilityName() ~= "queenofpain_shadow_strike" then
--         return
--     end
--     if params.target:HasModifier("modifier_queenofpain_shadow_strike") then
--        if params.unit:FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then   
--             Timers:CreateTimer(0.5, function()
--                 params.unit:SetCursorCastTarget(params.target)
--                 self:GetAbility():OnSpellStart()
--             end)
--        end
--     end

        
-- end

-- modifier_queenofpain_shadow_strike_scream_thinker = class({})
-- function modifier_queenofpain_shadow_strike_scream_thinker:IsHidden()
-- 	return true
-- end

-- function modifier_queenofpain_shadow_strike_scream_thinker:IsPurgeException()
-- 	return false
-- end

-- function modifier_queenofpain_shadow_strike_scream_thinker:IsPurgable()
-- 	return false
-- end

-- function modifier_queenofpain_shadow_strike_scream_thinker:IsPermanent()
-- 	return false
-- end



-- function modifier_queenofpain_shadow_strike_scream_thinker:OnCreated(kv)
--     if IsServer() then
        
--         self:OnIntervalThink()
-- 		self:StartIntervalThink( 0.1 )   
   
--     end
-- end

-- function modifier_queenofpain_shadow_strike_scream_thinker:OnIntervalThink()
--     if IsServer() then
        
--         if not self:GetParent():HasModifier("modifier_queenofpain_shadow_strike") then
--             if self:GetCaster():FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then
--                 self:GetCaster():SetCursorCastTarget(self:GetParent())
--                 self:GetAbility():OnSpellStart()
--                 self:StartIntervalThink( -1 )
--            end
--         end
--     end
-- end