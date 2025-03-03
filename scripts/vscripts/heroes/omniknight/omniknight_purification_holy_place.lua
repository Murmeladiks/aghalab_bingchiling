omniknight_purification_holy_place = class( {} )

LinkLuaModifier( "modifier_omniknight_purification_holy_place", "heroes/omniknight/omniknight_purification_holy_place", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function omniknight_purification_holy_place:GetIntrinsicModifierName()
	return "modifier_omniknight_purification_holy_place"
end

modifier_omniknight_purification_holy_place = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_purification_holy_place:IsHidden()
	return true
end

function modifier_omniknight_purification_holy_place:IsPurgeException()
	return false
end

function modifier_omniknight_purification_holy_place:IsPurgable()
	return false
end

function modifier_omniknight_purification_holy_place:IsPermanent()
	return true
end


function modifier_omniknight_purification_holy_place:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_purification_holy_place:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_omniknight_purification_holy_place:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "omniknight_purification" then
        self.omniknight_purification = params.unit:FindAbilityByName("omniknight_purification")
        
        local Range = 250
        local heroes = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),	-- int, your team number
            params.target:GetAbsOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,	-- int, order filter
            false
        )
        
            
        for _, hero in pairs(heroes) do
            if hero and not hero:IsNull() and not hero:IsInvulnerable() and hero~=params.target then
                self:GetParent():SetCursorCastTarget(hero)
                self.omniknight_purification:OnSpellStart()
                
            end
        end

        if self:GetParent():HasAbility("omniknight_purification_cure") then
            if  RollPseudoRandomPercentage(50, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                for _, hero in pairs(heroes) do
                    if hero and not hero:IsNull() and not hero:IsInvulnerable()  then
                        Timers:CreateTimer(0.1, function()
                            self:GetParent():SetCursorCastTarget(hero)
                            self.omniknight_purification:OnSpellStart()
                        end)
                        
                    end
                end
            end
        end
    end
     
  
   
    
		
	

    

end