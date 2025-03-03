witch_doctor_maledict_infectious = class( {} )

LinkLuaModifier( "modifier_witch_doctor_maledict_infectious", "heroes/witch_doctor/witch_doctor_maledict_infectious", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function witch_doctor_maledict_infectious:GetIntrinsicModifierName()
	return "modifier_witch_doctor_maledict_infectious"
end


modifier_witch_doctor_maledict_infectious = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_maledict_infectious:IsHidden()
	return true
end

function modifier_witch_doctor_maledict_infectious:IsPurgeException()
	return false
end

function modifier_witch_doctor_maledict_infectious:IsPurgable()
	return false
end

function modifier_witch_doctor_maledict_infectious:IsPermanent()
	return true
end


function modifier_witch_doctor_maledict_infectious:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_witch_doctor_maledict_infectious:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
	}

	return funcs
end



function  modifier_witch_doctor_maledict_infectious:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "witch_doctor_maledict" then
        self.witch_doctor_maledict = self:GetParent():FindAbilityByName("witch_doctor_maledict")
   
        local Range = 250
        local duration = 12
        if params.unit then
            local enemies = FindUnitsInRadius(
                self:GetParent():GetTeamNumber(),	-- int, your team number
                params.unit:GetAbsOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_CLOSEST,	-- int, order filter
                false
            )
            for _,enemy in pairs( enemies ) do
                if enemy ~= nil and enemy ~= params.unit then
                    if not enemy:HasModifier("modifier_maledict") then
                        enemy:AddNewModifier(self:GetParent(), self.witch_doctor_maledict, "modifier_maledict", {duration = duration})
                    end
                   
                end
            end           
        end
    end

end