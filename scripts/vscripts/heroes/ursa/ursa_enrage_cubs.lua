ursa_enrage_cubs = class( {} )

LinkLuaModifier( "modifier_ursa_enrage_cubs", "heroes/ursa/ursa_enrage_cubs", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ursa_enrage_cubs:GetIntrinsicModifierName()
	return "modifier_ursa_enrage_cubs"
end

modifier_ursa_enrage_cubs = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_enrage_cubs:IsHidden()
	return true
end

function modifier_ursa_enrage_cubs:IsPurgeException()
	return false
end

function modifier_ursa_enrage_cubs:IsPurgable()
	return false
end

function modifier_ursa_enrage_cubs:IsPermanent()
	return true
end


function modifier_ursa_enrage_cubs:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_ursa_enrage_cubs:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end


function  modifier_ursa_enrage_cubs:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "ursa_enrage" then
       
        self.ursa_enrage = params.unit:FindAbilityByName("ursa_enrage")
        local duration = self.ursa_enrage:GetSpecialValueFor("duration")
        local Range = 700
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
               
                hero:AddNewModifier(self:GetParent(),self.ursa_enrage,"modifier_ursa_enrage",{duration = duration})
                
            end
        end
    end
     
  
   
    
		
	

    

end