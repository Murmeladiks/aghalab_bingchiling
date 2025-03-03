gyrocopter_homing_missile_calldown = class( {} )
LinkLuaModifier( "modifier_wingman_stat", "heroes/gyrocopter/gyrocopter_call_down_strafe", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gyrocopter_homing_missile_calldown", "heroes/gyrocopter/gyrocopter_homing_missile_calldown", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gyrocopter_homing_missile_calldown:GetIntrinsicModifierName()
	return "modifier_gyrocopter_homing_missile_calldown"
end


modifier_gyrocopter_homing_missile_calldown = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gyrocopter_homing_missile_calldown:IsHidden()
	return true
end

function modifier_gyrocopter_homing_missile_calldown:IsPurgeException()
	return false
end

function modifier_gyrocopter_homing_missile_calldown:IsPurgable()
	return false
end

function modifier_gyrocopter_homing_missile_calldown:IsPermanent()
	return true
end


function modifier_gyrocopter_homing_missile_calldown:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_gyrocopter_homing_missile_calldown:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
	}

	return funcs
end



function  modifier_gyrocopter_homing_missile_calldown:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "gyrocopter_homing_missile" then
        self.gyrocopter_call_down = self:GetParent():FindAbilityByName("gyrocopter_call_down")
        if self.gyrocopter_call_down and self.gyrocopter_call_down:GetLevel()>0 then
            if params.unit then
                self:GetParent():SetCursorCastTarget(params.unit)
                self.gyrocopter_call_down:OnSpellStart()
                if self:GetParent():HasAbility("gyrocopter_call_down_strafe") then
                    local vPos = self:GetParent():GetAbsOrigin()
                    local pos = params.unit:GetAbsOrigin()
                
                    local sledmissile = CreateUnitByName("npc_dota_creature_gyrocopter1", pos, true, nil, nil, DOTA_TEAM_GOODGUYS)
                    local Vector = self:GetParent():GetForwardVector()
                
                    sledmissile:SetForwardVector(Vector)
                    local pos1 =sledmissile:GetAbsOrigin() +Vector*5000
                    sledmissile:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wingman_stat", {})
                    self.ability = self:GetParent():FindAbilityByName("gyrocopter_rocket_barrage")
                    if self.ability and self.ability:GetLevel()>0 then
                        sledmissile:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage", {})
                    end
                    
                    sledmissile:SetContextThink(DoUniqueString(self:GetParent():GetName()), function()
            
                        sledmissile:OnCommandMoveToDirection(Vector)                   
            
                    end, FrameTime())
                    sledmissile:AddNewModifier(self:GetParent(),nil,"modifier_kill",{duration = 3})
            
            
                    local sledmissile1 = CreateUnitByName("npc_dota_creature_gyrocopter1", pos+RandomVector(100), true, nil, nil, DOTA_TEAM_GOODGUYS)
                    local Vector = self:GetParent():GetForwardVector()
                
                    sledmissile1:SetForwardVector(Vector)
                    local pos2 =sledmissile1:GetAbsOrigin() +Vector*5000
                    sledmissile1:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wingman_stat", {})
                    self.ability = self:GetParent():FindAbilityByName("gyrocopter_rocket_barrage")
                    if self.ability and self.ability:GetLevel()>0 then
                        sledmissile1:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage", {})
                    end
                    
                    sledmissile1:SetContextThink(DoUniqueString(self:GetParent():GetName()), function()
            
                        sledmissile1:OnCommandMoveToDirection(Vector)                     
            
                    end, FrameTime())
                    sledmissile1:AddNewModifier(self:GetParent(),nil,"modifier_kill",{duration = 3})
            
            
            
                    local sledmissile2 = CreateUnitByName("npc_dota_creature_gyrocopter1", pos+RandomVector(100), true, nil, nil, DOTA_TEAM_GOODGUYS)
                    local Vector = self:GetParent():GetForwardVector()
                
                    sledmissile2:SetForwardVector(Vector)
                    local pos3 =sledmissile2:GetAbsOrigin() +Vector*5000
                    sledmissile2:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wingman_stat", {})
                    self.ability = self:GetParent():FindAbilityByName("gyrocopter_rocket_barrage")
                    if self.ability and self.ability:GetLevel()>0 then
                        sledmissile2:AddNewModifier(self:GetParent(), self.ability, "modifier_gyrocopter_rocket_barrage", {})
                    end
                    
                    sledmissile2:SetContextThink(DoUniqueString(self:GetParent():GetName()), function()
            
                        sledmissile2:OnCommandMoveToDirection(Vector)                       
            
                    end, FrameTime())
                    sledmissile2:AddNewModifier(self:GetParent(),nil,"modifier_kill",{duration = 3})
                end
            end
        end
    end

end