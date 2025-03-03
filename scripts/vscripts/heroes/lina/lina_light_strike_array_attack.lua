lina_light_strike_array_attack = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lina_light_strike_array_attack", "heroes/lina/lina_light_strike_array_attack", LUA_MODIFIER_MOTION_NONE )
function lina_light_strike_array_attack:GetIntrinsicModifierName()
	return "modifier_lina_light_strike_array_attack"
end


modifier_lina_light_strike_array_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lina_light_strike_array_attack:IsHidden()
	return true
end

function modifier_lina_light_strike_array_attack:IsPurgeException()
	return false
end

function modifier_lina_light_strike_array_attack:IsPurgable()
	return false
end

function modifier_lina_light_strike_array_attack:IsPermanent()
	return true
end



function modifier_lina_light_strike_array_attack:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_lina_light_strike_array_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_lina_light_strike_array_attack:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "lina_light_strike_array" then
        return
    end

    local unit = self:GetParent()

    self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
    local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
    print(radius)
    
    local cursorPos = params.ability:GetCursorPosition()
   
    local enemies = FindUnitsInRadius(
        unit:GetTeamNumber(),
        cursorPos, 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        0, 
        false 
    )


    for _,enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
            print("attack!")
            unit:PerformAttack(enemy, true, true, true, false, true, false, false)
        end
    end
    
    
end




