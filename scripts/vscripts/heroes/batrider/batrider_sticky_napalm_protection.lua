batrider_sticky_napalm_protection = class( {} )

LinkLuaModifier( "modifier_batrider_sticky_napalm_protection", "heroes/batrider/batrider_sticky_napalm_protection", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_batrider_sticky_napalm_protection_buff", "heroes/batrider/batrider_sticky_napalm_protection", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function batrider_sticky_napalm_protection:GetIntrinsicModifierName()
	return "modifier_batrider_sticky_napalm_protection"
end


modifier_batrider_sticky_napalm_protection = class({})
function modifier_batrider_sticky_napalm_protection:IsPurgable()	return false end
function modifier_batrider_sticky_napalm_protection:IsPermanent()	return true end
function modifier_batrider_sticky_napalm_protection:IsHidden()   return true end

function modifier_batrider_sticky_napalm_protection:OnCreated(kv)
  
end

function modifier_batrider_sticky_napalm_protection:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_batrider_sticky_napalm_protection:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "batrider_sticky_napalm" then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("batrider_sticky_napalm")
    local duration = self.ability:GetSpecialValueFor("duration")
     --self
    if not self:GetParent():HasModifier("modifier_batrider_sticky_napalm_protection_buff") then
        self:GetParent():AddNewModifier(self:GetParent(),self.ability,"modifier_batrider_sticky_napalm_protection_buff",{duration = duration}) 
    else
        local buff =  self:GetParent():FindModifierByName("modifier_batrider_sticky_napalm_protection_buff")
        if buff then
            buff:AddStack()
        end
    end
    local Range = self.ability:GetSpecialValueFor("radius")
    local point = self:GetParent():GetCursorPosition()
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
   
    --allies
    for _, hero in pairs(heroes) do
        if hero and not hero:IsNull() and not hero:IsInvulnerable() and hero ~= self:GetParent()  then
            if not hero:HasModifier("modifier_batrider_sticky_napalm_protection_buff") then
                hero:AddNewModifier(self:GetParent(),self.ability,"modifier_batrider_sticky_napalm_protection_buff",{duration = duration}) 
            else
                local buff =  hero:FindModifierByName("modifier_batrider_sticky_napalm_protection_buff")
                if buff then
                    buff:AddStack()
                end
            end 
        end
    end
        
        
   
        
end

modifier_batrider_sticky_napalm_protection_buff = class({})
function modifier_batrider_sticky_napalm_protection_buff:Precache( context )
end
function modifier_batrider_sticky_napalm_protection_buff:IsPurgable()	return false end
function modifier_batrider_sticky_napalm_protection_buff:IsPermanent()	return false end
function modifier_batrider_sticky_napalm_protection_buff:IsHidden()   return false end
function modifier_batrider_sticky_napalm_protection_buff:OnCreated(kv)
    if  IsServer() then        
    end      
end
function modifier_batrider_sticky_napalm_protection_buff:AddStack( kv )
	if not self:GetCaster():HasAbility("special_bonus_unique_batrider_sticky_napalm_infinity") then
        if self:GetStackCount() < 10 then
            self:IncrementStackCount()
            self:ForceRefresh()
        else
            self:SetStackCount(10)
            self:ForceRefresh()
        end
    else
        self:IncrementStackCount()
        self:ForceRefresh()
    end
end
function modifier_batrider_sticky_napalm_protection_buff:DeclareFunctions()
    local funcs = 
    {
        
        --MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT ,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

    }
    return funcs
end

-- function modifier_batrider_sticky_napalm_protection_buff:GetModifierIncomingDamage_Percentage( params )
--     return -5*(1+self:GetStackCount())
-- end
function modifier_batrider_sticky_napalm_protection_buff:GetModifierSpellAmplify_Percentage(params)
    return 5*(1+self:GetStackCount())
end

function modifier_batrider_sticky_napalm_protection_buff:GetModifierMoveSpeedBonus_Percentage(params)
	return 5*(1+self:GetStackCount())
end

function modifier_batrider_sticky_napalm_protection_buff:GetModifierIgnoreMovespeedLimit(params)
	return 1
end
function modifier_batrider_sticky_napalm_protection_buff:GetModifierTurnRate_Percentage( params )
    return 5*(1+self:GetStackCount())
end
