gyrocopter_homing_missile_sledmissiles = class( {} )

LinkLuaModifier( "modifier_gyrocopter_homing_missile_sledmissiles", "heroes/gyrocopter/gyrocopter_homing_missile_sledmissiles", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function gyrocopter_homing_missile_sledmissiles:GetIntrinsicModifierName()
	return "modifier_gyrocopter_homing_missile_sledmissiles"
end


modifier_gyrocopter_homing_missile_sledmissiles = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gyrocopter_homing_missile_sledmissiles:IsHidden()
	return true
end

function modifier_gyrocopter_homing_missile_sledmissiles:IsPurgeException()
	return false
end

function modifier_gyrocopter_homing_missile_sledmissiles:IsPurgable()
	return false
end

function modifier_gyrocopter_homing_missile_sledmissiles:IsPermanent()
	return true
end



function modifier_gyrocopter_homing_missile_sledmissiles:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_gyrocopter_homing_missile_sledmissiles:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
    }
end


function modifier_gyrocopter_homing_missile_sledmissiles:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "gyrocopter_homing_missile" then
        return
    end
    local vPos = self:GetParent():GetAbsOrigin()
    local sledmissile = CreateUnitByName("npc_dota_sled_penguin1", vPos, true, nil, nil, DOTA_TEAM_GOODGUYS)
    local Vector = self:GetParent():GetForwardVector()
    sledmissile:SetForwardVector(Vector)
    if self:GetParent():HasAbility("gyrocopter_rocket_barrage_shard") then
        self.ability = self:GetParent():FindAbilityByName("gyrocopter_rocket_barrage")
        if self.ability and self.ability:GetLevel()>0 then
            sledmissile:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage", {})
        end
    end
    
end




