templar_assassin_refraction_allies = class( {} )

LinkLuaModifier( "modifier_templar_assassin_refraction_allies", "heroes/templar_assassin/templar_assassin_refraction_allies", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function templar_assassin_refraction_allies:GetIntrinsicModifierName()
	return "modifier_templar_assassin_refraction_allies"
end

modifier_templar_assassin_refraction_allies = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_refraction_allies:IsHidden()
	return true
end

function modifier_templar_assassin_refraction_allies:IsPurgeException()
	return false
end

function modifier_templar_assassin_refraction_allies:IsPurgable()
	return false
end

function modifier_templar_assassin_refraction_allies:IsPermanent()
	return true
end


function modifier_templar_assassin_refraction_allies:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_refraction_allies:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end


function  modifier_templar_assassin_refraction_allies:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "templar_assassin_refraction" then
        print("ogres assemble!!!")
        self.templar_assassin_refraction = params.unit:FindAbilityByName("templar_assassin_refraction")
        local duration = self.templar_assassin_refraction:GetSpecialValueFor("duration")
        local Range = 800
        local heroes = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),	-- int, your team number
            self:GetParent():GetAbsOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,	-- int, order filter
            false
        )
        local stack = self.templar_assassin_refraction:GetSpecialValueFor("instances")
            
        for _, hero in pairs(heroes) do
            if hero and not hero:IsNull() and not hero:IsInvulnerable()  then
                print("ogres assemble!!!")
                local buff1 = hero:AddNewModifier(self:GetParent(),self.templar_assassin_refraction,"modifier_templar_assassin_refraction_damage",{duration = duration})
                if buff1 then
                    buff1:SetStackCount(stack)
                end
                local buff2 = hero:AddNewModifier(self:GetParent(),self.templar_assassin_refraction,"modifier_templar_assassin_refraction_absorb",{duration = duration})
                if buff2 then
                    buff2:SetStackCount(stack)
                end
            end
        end
    end
     
  
   
    
		
	

    

end