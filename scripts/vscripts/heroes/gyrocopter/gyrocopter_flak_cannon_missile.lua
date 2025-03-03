gyrocopter_flak_cannon_missile = class( {} )

LinkLuaModifier( "modifier_gyrocopter_flak_cannon_missile", "heroes/gyrocopter/gyrocopter_flak_cannon_missile", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gyrocopter_rocket_barrage_dummy_stat", "heroes/gyrocopter/gyrocopter_flak_cannon_missile", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gyrocopter_flak_cannon_missile:GetIntrinsicModifierName()
	return "modifier_gyrocopter_flak_cannon_missile"
end


modifier_gyrocopter_flak_cannon_missile = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gyrocopter_flak_cannon_missile:IsHidden()
	return true
end

function modifier_gyrocopter_flak_cannon_missile:IsPurgeException()
	return false
end

function modifier_gyrocopter_flak_cannon_missile:IsPurgable()
	return false
end

function modifier_gyrocopter_flak_cannon_missile:IsPermanent()
	return true
end



function modifier_gyrocopter_flak_cannon_missile:OnCreated(kv)
    if IsServer() then
        
        self.count = 0
   
    end
end
function modifier_gyrocopter_flak_cannon_missile:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end


function modifier_gyrocopter_flak_cannon_missile:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    self.ability = self:GetParent():FindAbilityByName("gyrocopter_homing_missile")

    
	if self.ability and self.ability:GetLevel()> 0 then
		if self:GetParent():HasModifier("modifier_gyrocopter_flak_cannon") then  
               
                    if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
                        self:GetParent():SetCursorCastTarget(params.target)
                        self.ability:OnSpellStart()

                    end 
                    if self:GetParent():HasAbility("gyrocopter_homing_missile_minimissiles") then
                        local castRange = 600

                        local enemies = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),   -- int, your team number
                            params.target:GetAbsOrigin(),    -- point, center point
                            nil,    -- handle, cacheUnit. (not known)
                            castRange + 50, -- float, radius. or use FIND_UNITS_EVERYWHERE
                            DOTA_UNIT_TARGET_TEAM_ENEMY,    -- int, team filter
                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
                            0,
                            FIND_FARTHEST,  -- int, order filter
                            false
                        )

                        local limit = 4
                        local counter = 0

                        if #enemies == 1 then
                            for i = 1, limit, 1 do
                                self:GetParent():SetCursorCastTarget(target)
                                ability:OnSpellStart()
                            end
                        else
                            for _, enemy in pairs(enemies) do
                                if counter >= limit then
                                    break
                                end
            
                                if enemy and enemy:IsAlive() and not enemy:IsInvulnerable()  then
                                    counter = counter + 1
                                    self:GetParent():SetCursorCastTarget(enemy)
                                    ability:OnSpellStart()
                                end
                            end
            
                            if counter < limit and target and target:IsAlive() then
                                local missingMissiles = limit - counter
            
                                for i = 1, missingMissiles, 1 do
                                    self:GetParent():SetCursorCastTarget(target)
                                    ability:OnSpellStart()
                                end
                            end
                        end
                    end
                    
        end
	end
      
end


