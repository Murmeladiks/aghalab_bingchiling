alchemist_we_ogres = class( {} )

LinkLuaModifier( "modifier_alchemist_we_ogres", "heroes/alchemist/alchemist_we_ogres", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function alchemist_we_ogres:GetIntrinsicModifierName()
	return "modifier_alchemist_we_ogres"
end
function alchemist_we_ogres:OnSpellStart()
	self.alchemist_unstable_concoction_throw = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction_throw")
    self.aghsfort_alchemist_chemical_rage = self:GetCaster():FindAbilityByName("aghsfort_alchemist_chemical_rage")
    local duration = self.aghsfort_alchemist_chemical_rage:GetSpecialValueFor("duration")
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = self.alchemist_unstable_concoction_throw:GetSpecialValueFor( "projectile_speed" )
	local projectile_vision = 200
    for i = 1, duration, 1 do
        Timers:CreateTimer(i*1.0, function()
            if(target and target:IsAlive()) then
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
                if enemies[1] and not enemies[1]:IsNull() and enemies[1]:IsAlive() and not enemies[1]:IsInvulnerable() then
                    local info = {
                        Target = enemies[1],
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
        end)
    end   
   
                    
   
end
modifier_alchemist_we_ogres = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_alchemist_we_ogres:IsHidden()
	return true
end

function modifier_alchemist_we_ogres:IsPurgeException()
	return false
end

function modifier_alchemist_we_ogres:IsPurgable()
	return false
end

function modifier_alchemist_we_ogres:IsPermanent()
	return true
end


function modifier_alchemist_we_ogres:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_alchemist_we_ogres:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end


function  modifier_alchemist_we_ogres:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "aghsfort_alchemist_chemical_rage" then
        print("ogres assemble!!!")
        self.alchemist_chemical_rage = params.unit:FindAbilityByName("aghsfort_alchemist_chemical_rage")
        local duration = self.alchemist_chemical_rage:GetSpecialValueFor("duration")
        local Range = 600
        local heroes = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),	-- int, your team number
            self:GetParent():GetAbsOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,	-- int, order filter
            false
        )
        
            
        for _, hero in pairs(heroes) do
            if hero and not hero:IsNull() and not hero:IsInvulnerable()  then
                print("ogres assemble!!!")
                hero:AddNewModifier(self:GetParent(),self.alchemist_chemical_rage,"modifier_alchemist_chemical_rage",{duration = duration})
                if  self:GetParent():HasAbility("alchemist_chemical_rage_potion") then
                    self.alchemist_unstable_concoction = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction")
                    if self.alchemist_unstable_concoction:GetLevel()>0 then
                        self:GetCaster():SetCursorCastTarget(hero)
                        self.ability = self:GetAbility()
                        self.ability:OnSpellStart()
                    end
                end
            end
        end
    end
     
  
   
    
		
	

    

end