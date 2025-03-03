gyrocopter_rocket_barrage_turret = class( {} )

LinkLuaModifier( "modifier_gyrocopter_rocket_barrage_turret", "heroes/gyrocopter/gyrocopter_rocket_barrage_turret", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_barrage_dummy_stat", "heroes/gyrocopter/gyrocopter_rocket_barrage_turret", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gyrocopter_rocket_barrage_turret:GetIntrinsicModifierName()
	return "modifier_gyrocopter_rocket_barrage_turret"
end


modifier_gyrocopter_rocket_barrage_turret = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gyrocopter_rocket_barrage_turret:IsHidden()
	return true
end

function modifier_gyrocopter_rocket_barrage_turret:IsPurgeException()
	return false
end

function modifier_gyrocopter_rocket_barrage_turret:IsPurgable()
	return false
end

function modifier_gyrocopter_rocket_barrage_turret:IsPermanent()
	return true
end



function modifier_gyrocopter_rocket_barrage_turret:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_gyrocopter_rocket_barrage_turret:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
    }
end


function modifier_gyrocopter_rocket_barrage_turret:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "gyrocopter_rocket_barrage" then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("gyrocopter_rocket_barrage")
   
    local duration = self.ability:GetSpecialValueFor("barrage_duration")
    local Range = 600
    local point = self:GetParent():GetAbsOrigin()
    local heroes = FindUnitsInRadius(
        self:GetParent():GetTeamNumber(),	-- int, your team number
        point,	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )
    if heroes then
        for _, hero in pairs(heroes) do
            if hero and not hero:IsNull() and not hero:IsInvulnerable() and hero ~= self:GetParent()  then
                if not hero:HasModifier("modifier_gyrocopter_rocket_barrage") then
                    hero:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage", {duration = duration})
                else
                    local buff =  hero:FindModifierByName("modifier_gyrocopter_rocket_barrage")
                    if buff then
                        buff:ForceRefresh()
                    end
                end 
            end
            if  hero == self:GetParent()  then
                local vPos = self:GetParent():GetAbsOrigin()
                local dummy = CreateUnitByName("npc_aghsfort_gyrocopter_rocket_barrage_turret", vPos, true, nil, nil, DOTA_TEAM_GOODGUYS)
                dummy:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage", {})
                dummy:AddNewModifier(self:GetParent(), self.ability, "modifier_barrage_dummy_stat", {})
                Timers:CreateTimer(duration, function()
                    UTIL_Remove(dummy)
                end)
            end
        end
	end	
       
 
        
end


modifier_barrage_dummy_stat = class({})

------------------------------------------------------------------------------

function modifier_barrage_dummy_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_barrage_dummy_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_barrage_dummy_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		
		[MODIFIER_STATE_INVULNERABLE] = true,
		
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end
