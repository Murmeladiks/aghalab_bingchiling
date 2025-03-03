queenofpain_shadow_strike_spread = class( {} )

LinkLuaModifier( "modifier_queenofpain_shadow_strike_spread", "heroes/queenofpain/queenofpain_shadow_strike_spread", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function queenofpain_shadow_strike_spread:GetIntrinsicModifierName()
	return "modifier_queenofpain_shadow_strike_spread"
end

modifier_queenofpain_shadow_strike_spread = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_shadow_strike_spread:IsHidden()
	return true
end

function modifier_queenofpain_shadow_strike_spread:IsPurgeException()
	return false
end

function modifier_queenofpain_shadow_strike_spread:IsPurgable()
	return false
end

function modifier_queenofpain_shadow_strike_spread:IsPermanent()
	return true
end



function modifier_queenofpain_shadow_strike_spread:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_queenofpain_shadow_strike_spread:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
    }
end


function modifier_queenofpain_shadow_strike_spread:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "queenofpain_shadow_strike" then
        return
    end
    local position = params.target:GetAbsOrigin()
    local radius = 600
    local enemies = FindUnitsInRadius(
        params.unit:GetTeamNumber(),
        position, 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        0, 
        false 
    )
    local maxtargets = 5
    local targetenemy = 0 
    for _,enemy in pairs(enemies) do
        if enemy and enemy ~= params.target then
            if  not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
                params.unit:SetCursorCastTarget(enemy)
                params.ability:OnSpellStart()
                -- if self:GetParent():HasAbility("queenofpain_shadow_strike_scream") and self:GetParent():FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then
                --     if enemy:HasModifier("modifier_queenofpain_shadow_strike") then
                --         self:GetParent():SetCursorCastTarget(enemy)
                --         self.queenofpain_shadow_strike_scream = self:GetParent():FindAbilityByName("queenofpain_shadow_strike_scream")
                --         self.queenofpain_shadow_strike_scream:OnSpellStart()
                --     end
                -- end
                targetenemy = targetenemy + 1
                if targetenemy == 5 then
                    break
                end
            end
        end
    end

        
end


