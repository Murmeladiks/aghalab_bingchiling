alchemist_chemical_rage_potion = class( {} )

LinkLuaModifier( "modifier_alchemist_chemical_rage_potion", "heroes/alchemist/alchemist_chemical_rage_potion", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function alchemist_chemical_rage_potion:GetIntrinsicModifierName()
	return "modifier_alchemist_chemical_rage_potion"
end
function alchemist_chemical_rage_potion:OnSpellStart()
	self.alchemist_unstable_concoction_throw = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction_throw")
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = self.alchemist_unstable_concoction_throw:GetSpecialValueFor( "projectile_speed" )
	local projectile_vision = 200
    local info = {
		Target = target,
		Source = caster,
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
	EmitSoundOn( sound_cast, caster )
end


modifier_alchemist_chemical_rage_potion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_alchemist_chemical_rage_potion:IsHidden()
	return true
end

function modifier_alchemist_chemical_rage_potion:IsPurgeException()
	return false
end

function modifier_alchemist_chemical_rage_potion:IsPurgable()
	return false
end

function modifier_alchemist_chemical_rage_potion:IsPermanent()
	return true
end


function modifier_alchemist_chemical_rage_potion:OnCreated( kv )
	if IsServer() then
        self.canrampage = false
    end
end

function modifier_alchemist_chemical_rage_potion:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end


function  modifier_alchemist_chemical_rage_potion:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "aghsfort_alchemist_chemical_rage" then
        
        self.alchemist_unstable_concoction = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction")
        self.aghsfort_alchemist_chemical_rage = self:GetParent():FindAbilityByName("aghsfort_alchemist_chemical_rage")
        local duration = self.aghsfort_alchemist_chemical_rage:GetSpecialValueFor("duration")
        if self.alchemist_unstable_concoction:GetLevel()>0 then
            if not self.canrampage then
                self:StartIntervalThink(1)
            end
            -- for i = 1, duration, 1 do
            --     print("rage!")
            --     Timers:CreateTimer(i*1.0, function()
            --         if(self and not self:IsNull()) then
            --             local Range = 700
                    
            --             local enemies = FindUnitsInRadius(
            --                 self:GetParent():GetTeamNumber(),	-- int, your team number
            --                 self:GetParent():GetAbsOrigin(),	-- point, center point
            --                 nil,	-- handle, cacheUnit. (not known)
            --                 Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            --                 DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            --                 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            --                 DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            --                 FIND_CLOSEST,	-- int, order filter
            --                 false
            --             )
            --             if enemies[1] and not enemies[1]:IsNull() and enemies[1]:IsAlive() and not enemies[1]:IsInvulnerable() then
            --                 print("enemy!")
            --                 self:GetCaster():SetCursorCastTarget(enemies[1])
            --                 self.ability = self:GetAbility()
            --                 self.ability:OnSpellStart()
            --             end
                
                        
                        
                        
            --         end
            --     end)
            -- end   
        end
    end
     
  
   
    
		
	

    

end

function  modifier_alchemist_chemical_rage_potion:OnIntervalThink()
     if self:GetParent():HasModifier("modifier_alchemist_chemical_rage") then
        local Range = 700
                    
                        local enemies = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),	-- int, your team number
                            self:GetParent():GetAbsOrigin(),	-- point, center point
                            nil,	-- handle, cacheUnit. (not known)
                            Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,	-- int, order filter
                            false
                        )
                        if enemies[1] and not enemies[1]:IsNull() and enemies[1]:IsAlive() and not enemies[1]:IsInvulnerable() then
                            print("enemy!")
                            self:GetCaster():SetCursorCastTarget(enemies[1])
                            self.ability = self:GetAbility()
                            self.ability:OnSpellStart()
                        end
     else
        self:StartIntervalThink(-1)
        self.canrampage =false
     end
end