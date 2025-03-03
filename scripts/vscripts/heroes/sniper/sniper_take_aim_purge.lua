sniper_take_aim_purge = class( {} )

LinkLuaModifier( "modifier_sniper_take_aim_purge", "heroes/sniper/sniper_take_aim_purge", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_take_aim_purge_movespeed", "heroes/sniper/sniper_take_aim_purge", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function sniper_take_aim_purge:GetIntrinsicModifierName()
	return "modifier_sniper_take_aim_purge"
end

modifier_sniper_take_aim_purge = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_take_aim_purge:IsHidden()
	return true
end

function modifier_sniper_take_aim_purge:IsPurgeException()
	return false
end

function modifier_sniper_take_aim_purge:IsPurgable()
	return false
end

function modifier_sniper_take_aim_purge:IsPermanent()
	return true
end



function modifier_sniper_take_aim_purge:OnCreated(kv)
    if IsServer() then
	
    end
end
function modifier_sniper_take_aim_purge:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_sniper_take_aim_purge:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "sniper_take_aim" then
        return
    end
    local unit = self:GetParent()
    self.sniper_take_aim = unit:FindAbilityByName("sniper_take_aim")
	local duration = self.sniper_take_aim:GetSpecialValueFor("duration")
	self.speed = self.sniper_take_aim:GetSpecialValueFor("slow")
	unit:Purge(false, true, false, false, false)
	unit:AddNewModifier(unit,self:GetAbility(),"modifier_sniper_take_aim_purge_movespeed",{duration = duration})

   
end

modifier_sniper_take_aim_purge_movespeed = class({})

function modifier_sniper_take_aim_purge_movespeed:IsHidden()
	return true
end

function modifier_sniper_take_aim_purge_movespeed:IsPurgeException()
	return false
end

function modifier_sniper_take_aim_purge_movespeed:IsPurgable()
	return false
end

function modifier_sniper_take_aim_purge_movespeed:IsPermanent()
	return true
end



function modifier_sniper_take_aim_purge_movespeed:OnCreated(kv)
    if IsServer() then
	
    end
end
function modifier_sniper_take_aim_purge_movespeed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end
function modifier_sniper_take_aim_purge_movespeed:GetModifierMoveSpeedBonus_Percentage(params)
	return 300
end