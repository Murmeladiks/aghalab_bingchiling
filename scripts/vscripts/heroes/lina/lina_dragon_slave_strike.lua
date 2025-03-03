lina_dragon_slave_strike = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lina_dragon_slave_strike", "heroes/lina/lina_dragon_slave_strike", LUA_MODIFIER_MOTION_NONE )
function lina_dragon_slave_strike:GetIntrinsicModifierName()
	return "modifier_lina_dragon_slave_strike"
end



modifier_lina_dragon_slave_strike = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lina_dragon_slave_strike:IsHidden()
	return true
end

function modifier_lina_dragon_slave_strike:IsPurgeException()
	return false
end

function modifier_lina_dragon_slave_strike:IsPurgable()
	return false
end

function modifier_lina_dragon_slave_strike:IsPermanent()
	return true
end




function modifier_lina_dragon_slave_strike:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_lina_dragon_slave_strike:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_lina_dragon_slave_strike:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "lina_dragon_slave" then
        return
    end

    local unit = self:GetParent()

    self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
    local radius =self.lina_light_strike_array:GetSpecialValueFor("radius")
    if not self.lina_light_strike_array or self.lina_light_strike_array:GetLevel() == 0 then
        return
    end
    
    local cursorPos = params.ability:GetCursorPosition()
    local pos = params.unit:GetAbsOrigin()
    local direction = self:GetParent():GetForwardVector()
    local distance = params.ability:GetSpecialValueFor("dragon_slave_distance")
    
    local newpos = pos + distance*direction
    local newpos1 = LerpVectors(pos,newpos,0.25)
    local newpos2 = LerpVectors(pos,newpos,0.5)
    local newpos3 = LerpVectors(pos,newpos,0.75)
        Timers:CreateTimer(0.25, function()
            if(self and not self:IsNull()) then
                self:GetCaster():SetCursorPosition(newpos1)
                self.lina_light_strike_array:OnSpellStart()
                if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                    self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
                    local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                    local enemies = FindUnitsInRadius(
                        unit:GetTeamNumber(),
                        newpos1, 
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
        Timers:CreateTimer(0.5, function()
            if(self and not self:IsNull()) then
                self:GetCaster():SetCursorPosition(newpos2)
                self.lina_light_strike_array:OnSpellStart()
                if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                    self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
                    local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                    local enemies = FindUnitsInRadius(
                        unit:GetTeamNumber(),
                        newpos2, 
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
        Timers:CreateTimer(0.75, function()
            if(self and not self:IsNull()) then
                self:GetCaster():SetCursorPosition(newpos3)
                self.lina_light_strike_array:OnSpellStart()
                if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                    self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
                    local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                    local enemies = FindUnitsInRadius(
                        unit:GetTeamNumber(),
                        newpos3, 
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
        Timers:CreateTimer(1, function()
            if(self and not self:IsNull()) then
                self:GetCaster():SetCursorPosition(newpos)
                self.lina_light_strike_array:OnSpellStart()
                if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                    self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
                    local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                    local enemies = FindUnitsInRadius(
                        unit:GetTeamNumber(),
                        newpos4, 
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