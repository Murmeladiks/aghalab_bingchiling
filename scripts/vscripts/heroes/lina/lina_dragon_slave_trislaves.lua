lina_dragon_slave_trislaves = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lina_dragon_slave_trislaves", "heroes/lina/lina_dragon_slave_trislaves", LUA_MODIFIER_MOTION_NONE )
function lina_dragon_slave_trislaves:GetIntrinsicModifierName()
	return "modifier_lina_dragon_slave_trislaves"
end

modifier_lina_dragon_slave_trislaves = class({})

function modifier_lina_dragon_slave_trislaves:IsHidden()
	return true
end

function modifier_lina_dragon_slave_trislaves:IsPurgeException()
	return false
end

function modifier_lina_dragon_slave_trislaves:IsPurgable()
	return false
end

function modifier_lina_dragon_slave_trislaves:IsPermanent()
	return true
end



function modifier_lina_dragon_slave_trislaves:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_lina_dragon_slave_trislaves:OnCreated(kv)
    if IsServer() then
    end
end

function modifier_lina_dragon_slave_trislaves:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    local unit = self:GetParent()

    self.dragonSlave = unit:FindAbilityByName("lina_dragon_slave")
    self.lina_light_strike_array = unit:FindAbilityByName("lina_light_strike_array")
    if params.ability:GetAbilityName() == "lina_dragon_slave"  then
       
        local cursorPos = params.ability:GetCursorPosition()
        local casterPos = self:GetParent():GetAbsOrigin()

        
        local newVector1 = RotatePosition(casterPos, QAngle(0, 20, 0), cursorPos)
        local direction1 = (newVector1 - casterPos):Normalized()

        local newPos1 = casterPos + direction1 * 350
        self:GetParent():SetCursorCastTarget(nil)
        self:GetParent():SetCursorPosition(newPos1)
        self.dragonSlave:OnSpellStart()

        
        local newVector2 = RotatePosition(casterPos, QAngle(0, -20, 0), cursorPos)
        local direction2 = (newVector2 - casterPos):Normalized()

        local newPos2 = casterPos + direction2 * 350
        self:GetParent():SetCursorCastTarget(nil)
        self:GetParent():SetCursorPosition(newPos2)
        self.dragonSlave:OnSpellStart()
        
        if params.unit:HasModifier("modifier_lina_dragon_slave_strike") and self.lina_light_strike_array:GetLevel()> 0 then
            
            local distance = params.ability:GetSpecialValueFor("dragon_slave_distance")
            local newpos11 = casterPos + distance*direction1
            local newpos12 = LerpVectors(casterPos,newpos11,0.25)
            local newpos13 = LerpVectors(casterPos,newpos11,0.5)
            local newpos14 = LerpVectors(casterPos,newpos11,0.75)
            Timers:CreateTimer(0.25, function()
                if(self and not self:IsNull()) then
                    self:GetCaster():SetCursorPosition(newpos12)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos12, 
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
                    self:GetCaster():SetCursorPosition(newpos13)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos13, 
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
                    self:GetCaster():SetCursorPosition(newpos14)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos14, 
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
                    self:GetCaster():SetCursorPosition(newpos11)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos11, 
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



            local newpos21 = casterPos + distance*direction2
            local newpos22 = LerpVectors(casterPos,newpos21,0.25)
            local newpos23 = LerpVectors(casterPos,newpos21,0.5)
            local newpos24 = LerpVectors(casterPos,newpos21,0.75)
            Timers:CreateTimer(0.25, function()
                if(self and not self:IsNull()) then
                    self:GetCaster():SetCursorPosition(newpos22)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos22, 
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
                    self:GetCaster():SetCursorPosition(newpos23)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos23, 
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
                    self:GetCaster():SetCursorPosition(newpos24)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos24, 
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
                    self:GetCaster():SetCursorPosition(newpos21)
                    self.lina_light_strike_array:OnSpellStart()
                    if self:GetCaster():HasAbility("lina_light_strike_array_attack") then
                        
                        local radius =self.lina_light_strike_array:GetSpecialValueFor("light_strike_array_aoe")
                        local enemies = FindUnitsInRadius(
                            unit:GetTeamNumber(),
                            newpos21, 
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

end