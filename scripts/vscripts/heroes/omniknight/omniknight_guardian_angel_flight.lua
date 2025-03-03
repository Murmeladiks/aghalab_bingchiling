omniknight_guardian_angel_flight = class( {} )

LinkLuaModifier( "modifier_omniknight_guardian_angel_flight", "heroes/omniknight/omniknight_guardian_angel_flight", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_omniknight_guardian_angel_flight_buff", "heroes/omniknight/omniknight_guardian_angel_flight", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function omniknight_guardian_angel_flight:GetIntrinsicModifierName()
	return "modifier_omniknight_guardian_angel_flight"
end

modifier_omniknight_guardian_angel_flight = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_guardian_angel_flight:IsHidden()
	return true
end

function modifier_omniknight_guardian_angel_flight:IsPurgeException()
	return false
end

function modifier_omniknight_guardian_angel_flight:IsPurgable()
	return false
end

function modifier_omniknight_guardian_angel_flight:IsPermanent()
	return true
end


function modifier_omniknight_guardian_angel_flight:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_guardian_angel_flight:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_omniknight_guardian_angel_flight:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "omniknight_guardian_angel" then
        self.omniknight_guardian_angel = self:GetParent():FindAbilityByName("omniknight_guardian_angel")
        local duration = self.omniknight_guardian_angel:GetSpecialValueFor("duration")
        local Range = self.omniknight_guardian_angel:GetSpecialValueFor("radius")
        local heroes = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),	-- int, your team number
            self:GetParent():GetCursorPosition(),	-- point, center point
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
                if not hero:HasModifier("modifier_omniknight_guardian_angel_flight_buff") then
                    hero:AddNewModifier(self:GetParent(), self.omniknight_guardian_angel, "modifier_omniknight_guardian_angel_flight_buff", {duration =duration})
                else
                    local buff = hero:FindModifierByName("modifier_omniknight_guardian_angel_flight_buff")
                    if buff then
                        buff:ForceRefresh()
                    end
                end
            end
        end
       
    end

end
modifier_omniknight_guardian_angel_flight_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_guardian_angel_flight_buff:IsHidden()
	return true
end

function modifier_omniknight_guardian_angel_flight_buff:IsPurgeException()
	return false
end

function modifier_omniknight_guardian_angel_flight_buff:IsPurgable()
	return false
end

function modifier_omniknight_guardian_angel_flight_buff:IsPermanent()
	return false
end


function modifier_omniknight_guardian_angel_flight_buff:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_guardian_angel_flight_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

    }
    return funcs
end
function modifier_omniknight_guardian_angel_flight_buff:CheckState()
	local state =
	{
		[MODIFIER_STATE_FLYING] = true,
		
	}
	return state
end
function modifier_omniknight_guardian_angel_flight_buff:GetModifierMagicalResistanceBonus( params )
    return 30
end