snapfire_lil_shredder_allies = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_snapfire_lil_shredder_allies", "heroes/snapfire/snapfire_lil_shredder_allies", LUA_MODIFIER_MOTION_NONE )
function snapfire_lil_shredder_allies:GetIntrinsicModifierName()
	return "modifier_snapfire_lil_shredder_allies"
end

modifier_snapfire_lil_shredder_allies = class({})

function modifier_snapfire_lil_shredder_allies:IsHidden()
	return true
end

function modifier_snapfire_lil_shredder_allies:IsPurgeException()
	return false
end

function modifier_snapfire_lil_shredder_allies:IsPurgable()
	return false
end

function modifier_snapfire_lil_shredder_allies:IsPermanent()
	return true
end



function modifier_snapfire_lil_shredder_allies:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_START,
     
    }
end

function modifier_snapfire_lil_shredder_allies:OnCreated(kv)
    if IsServer() then
       
    end
end

function modifier_snapfire_lil_shredder_allies:OnAbilityStart(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    local unit = self:GetParent()

    self.snapfire_lil_shredder = unit:FindAbilityByName("snapfire_lil_shredder")
    local duration = self.snapfire_lil_shredder:GetSpecialValueFor("buff_duration_tooltip")
    print(duration)
    if params.ability:GetAbilityName() == "snapfire_lil_shredder"  then
        print("ally!")
        local position = unit:GetAbsOrigin()
        local allies = FindUnitsInRadius(
            self:GetCaster():GetTeamNumber(),   -- int, your team number
            position,   -- point, center point
            nil,    -- handle, cacheUnit. (not known)
            600,   -- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,    -- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
            0,  -- int, flag filter
            0,  -- int, order filter
            false   -- bool, can grow cache
        )
        for _,ally in pairs(allies) do
            if ally ~= params.target then
                if ally and not ally:IsNull() and ally:IsAlive() and not ally:IsInvulnerable() then
                    print("found allies")
                    ally:AddNewModifier(self:GetParent(),self.snapfire_lil_shredder,"modifier_snapfire_lil_shredder_buff",{duration = duration})
                    ally:AddNewModifier(self:GetParent(),self.snapfire_lil_shredder,"modifier_snapfire_lil_shredder_attack",{duration = duration})
                end
            end
        end

    end

end