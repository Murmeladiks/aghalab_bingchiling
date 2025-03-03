lina_light_strike_array_three_times = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lina_light_strike_array_three_times", "heroes/lina/lina_light_strike_array_three_times", LUA_MODIFIER_MOTION_NONE )
function lina_light_strike_array_three_times:GetIntrinsicModifierName()
	return "modifier_lina_light_strike_array_three_times"
end


modifier_lina_light_strike_array_three_times = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lina_light_strike_array_three_times:IsHidden()
	return true
end

function modifier_lina_light_strike_array_three_times:IsPurgeException()
	return false
end

function modifier_lina_light_strike_array_three_times:IsPurgable()
	return false
end

function modifier_lina_light_strike_array_three_times:IsPermanent()
	return true
end



function modifier_lina_light_strike_array_three_times:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_lina_light_strike_array_three_times:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_lina_light_strike_array_three_times:OnAbilityFullyCast(params)
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
    if not self.lina_light_strike_array or self.lina_light_strike_array:GetLevel() == 0 then
        return
    end
    
    local cursorPos = params.ability:GetCursorPosition()
   
    for i = 1, 2, 1 do
       
        Timers:CreateTimer(i*2.0, function()
            if(self and not self:IsNull()) then
                self:GetCaster():SetCursorPosition(cursorPos)
                self.lina_light_strike_array:OnSpellStart()
                if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
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
            end
        end)
    end
    
    
end




