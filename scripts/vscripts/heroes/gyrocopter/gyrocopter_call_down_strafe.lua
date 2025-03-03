gyrocopter_call_down_strafe = class( {} )

LinkLuaModifier( "modifier_gyrocopter_call_down_strafe", "heroes/gyrocopter/gyrocopter_call_down_strafe", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wingman_stat", "heroes/gyrocopter/gyrocopter_call_down_strafe", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function gyrocopter_call_down_strafe:GetIntrinsicModifierName()
	return "modifier_gyrocopter_call_down_strafe"
end


modifier_gyrocopter_call_down_strafe = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_gyrocopter_call_down_strafe:IsHidden()
	return true
end

function modifier_gyrocopter_call_down_strafe:IsPurgeException()
	return false
end

function modifier_gyrocopter_call_down_strafe:IsPurgable()
	return false
end

function modifier_gyrocopter_call_down_strafe:IsPermanent()
	return true
end



function modifier_gyrocopter_call_down_strafe:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_gyrocopter_call_down_strafe:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
    }
end


function modifier_gyrocopter_call_down_strafe:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "gyrocopter_call_down" then
        return
    end
        local vPos = self:GetParent():GetAbsOrigin()
        local pos = self:GetParent():GetCursorPosition()
    
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

            sledmissile:MoveToPosition(pos1)                   

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

            sledmissile1:MoveToPosition(pos2)                   

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

            sledmissile2:MoveToPosition(pos3)                   

        end, FrameTime())
        sledmissile2:AddNewModifier(self:GetParent(),nil,"modifier_kill",{duration = 3})
    
end

modifier_wingman_stat = class({})

------------------------------------------------------------------------------

function modifier_wingman_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_wingman_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_wingman_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end


