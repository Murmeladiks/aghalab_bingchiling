queenofpain_shadow_strike_attack = class( {} )

LinkLuaModifier( "modifier_queenofpain_shadow_strike_attack", "heroes/queenofpain/queenofpain_shadow_strike_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function queenofpain_shadow_strike_attack:GetIntrinsicModifierName()
	return "modifier_queenofpain_shadow_strike_attack"
end

modifier_queenofpain_shadow_strike_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_queenofpain_shadow_strike_attack:IsHidden()
	return true
end

function modifier_queenofpain_shadow_strike_attack:IsPurgeException()
	return false
end

function modifier_queenofpain_shadow_strike_attack:IsPurgable()
	return false
end

function modifier_queenofpain_shadow_strike_attack:IsPermanent()
	return true
end



function modifier_queenofpain_shadow_strike_attack:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_queenofpain_shadow_strike_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end


function modifier_queenofpain_shadow_strike_attack:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    self.ability = self:GetParent():FindAbilityByName("queenofpain_shadow_strike")
    self.chance = 20
    
	if self.ability and self.ability:GetLevel()> 0 then
		
        if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
			
				if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
					
                    -- self:GetParent():SetCursorCastTarget(params.target)
                    -- self.ability:OnSpellStart()
                    
                    
                    if self:GetParent():HasAbility("special_bonus_unique_queenofpain_shadow_strike_spread") then
                        self.location = params.target:GetAbsOrigin()
                        self:GetParent():SetCursorPosition(self.location)
                        self.ability:OnSpellStart()
                    else
                        self:GetParent():SetCursorCastTarget(params.target)
                        self.ability:OnSpellStart()
                    end
                        -- if self:GetParent():HasAbility("queenofpain_shadow_strike_spread") then
                        --     local position = params.target:GetAbsOrigin()
                        --     local radius = 600
                        --     local enemies = FindUnitsInRadius(
                        --         params.attacker:GetTeamNumber(),
                        --         position, 
                        --         nil, 
                        --         radius, 
                        --         DOTA_UNIT_TARGET_TEAM_ENEMY, 
                        --         DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                        --         DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                        --         0, 
                        --         false 
                        --     )
                        --     local maxtargets = 5
                        --     local targetenemy = 0 
                        --     for _,enemy in pairs(enemies) do
                        --         if enemy and enemy ~= params.target then
                        --             if  not enemy:IsNull() and enemy:IsAlive() and not enemy:IsInvulnerable() then
                        --                 params.attacker:SetCursorCastTarget(enemy)
                        --                 self.ability:OnSpellStart()
                        --                 if self:GetParent():HasAbility("queenofpain_shadow_strike_scream") and self:GetParent():FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then
                        --                     if enemy:HasModifier("modifier_queenofpain_shadow_strike") then
                        --                         self:GetParent():SetCursorCastTarget(enemy)
                        --                         self.queenofpain_shadow_strike_scream = self:GetParent():FindAbilityByName("queenofpain_shadow_strike_scream")
                        --                         self.queenofpain_shadow_strike_scream:OnSpellStart()
                        --                     end
                        --                 end
                        --                 targetenemy = targetenemy + 1
                        --                 if targetenemy == 5 then
                        --                     break
                        --                 end
                        --             end
                        --         end
                        --     end
                        -- end
                        -- if self:GetParent():HasAbility("queenofpain_shadow_strike_scream") and self:GetParent():FindAbilityByName("queenofpain_scream_of_pain"):GetLevel()>0 then
                        --     if params.target:HasModifier("modifier_queenofpain_shadow_strike") then
                        --         self:GetParent():SetCursorCastTarget(params.target)
                        --         self.queenofpain_shadow_strike_scream = self:GetParent():FindAbilityByName("queenofpain_shadow_strike_scream")
                        --         self.queenofpain_shadow_strike_scream:OnSpellStart()
                        --     end
                        -- end
                    
				end
			
		end 
	end
   
        
        
   
        
end


