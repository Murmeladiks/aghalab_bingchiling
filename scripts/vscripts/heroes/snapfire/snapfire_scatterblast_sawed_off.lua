snapfire_scatterblast_sawed_off = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_snapfire_scatterblast_sawed_off", "heroes/snapfire/snapfire_scatterblast_sawed_off", LUA_MODIFIER_MOTION_NONE )
function snapfire_scatterblast_sawed_off:GetIntrinsicModifierName()
	return "modifier_snapfire_scatterblast_sawed_off"
end

modifier_snapfire_scatterblast_sawed_off = class({})

function modifier_snapfire_scatterblast_sawed_off:IsHidden()
	return true
end

function modifier_snapfire_scatterblast_sawed_off:IsPurgeException()
	return false
end

function modifier_snapfire_scatterblast_sawed_off:IsPurgable()
	return false
end

function modifier_snapfire_scatterblast_sawed_off:IsPermanent()
	return true
end



function modifier_snapfire_scatterblast_sawed_off:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_snapfire_scatterblast_sawed_off:OnCreated(kv)
    if IsServer() then
    end
end

function modifier_snapfire_scatterblast_sawed_off:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    local unit = self:GetParent()

    self.snapfire_scatterblast = unit:FindAbilityByName("aghsfort_snapfire_scatterblast")
    
    if params.ability:GetAbilityName() == "aghsfort_snapfire_scatterblast"  then
       
        local cursorPos = params.ability:GetCursorPosition()
        local casterPos = self:GetParent():GetAbsOrigin()

        
        local newVector1 = RotatePosition(casterPos, QAngle(0, 30, 0), cursorPos)
        local direction1 = (newVector1 - casterPos):Normalized()

        local newPos1 = casterPos + direction1 * 350
        self:GetParent():SetCursorCastTarget(nil)
        self:GetParent():SetCursorPosition(newPos1)
        self.snapfire_scatterblast:OnSpellStart()

        
        local newVector2 = RotatePosition(casterPos, QAngle(0, -30, 0), cursorPos)
        local direction2 = (newVector2 - casterPos):Normalized()

        local newPos2 = casterPos + direction2 * 350
        self:GetParent():SetCursorCastTarget(nil)
        self:GetParent():SetCursorPosition(newPos2)
        self.snapfire_scatterblast:OnSpellStart()
        
       
    end

end