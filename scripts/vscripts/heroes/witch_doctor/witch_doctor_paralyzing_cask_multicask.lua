witch_doctor_paralyzing_cask_multicask = class( {} )

LinkLuaModifier( "modifier_witch_doctor_paralyzing_cask_multicask", "heroes/witch_doctor/witch_doctor_paralyzing_cask_multicask", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function witch_doctor_paralyzing_cask_multicask:Precache( context )	
	
end
function witch_doctor_paralyzing_cask_multicask:GetIntrinsicModifierName()
	return "modifier_witch_doctor_paralyzing_cask_multicask"
end


modifier_witch_doctor_paralyzing_cask_multicask = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_paralyzing_cask_multicask:IsHidden()
	return true
end

function modifier_witch_doctor_paralyzing_cask_multicask:IsPurgeException()
	return false
end

function modifier_witch_doctor_paralyzing_cask_multicask:IsPurgable()
	return false
end

function modifier_witch_doctor_paralyzing_cask_multicask:IsPermanent()
	return true
end


function modifier_witch_doctor_paralyzing_cask_multicask:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_witch_doctor_paralyzing_cask_multicask:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_witch_doctor_paralyzing_cask_multicask:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "witch_doctor_paralyzing_cask" then
        
        self.witch_doctor_paralyzing_cask = self:GetParent():FindAbilityByName("witch_doctor_paralyzing_cask")
		local castRange = params.ability:GetCastRange(self:GetParent():GetAbsOrigin(), nil)

                    
		local enemies = FindUnitsInRadius(
			self:GetParent():GetTeamNumber(),	-- int, your team number
			self:GetParent():GetAbsOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			castRange,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_CLOSEST,	-- int, order filter
			false
		)
		if enemies[1] and not enemies[1]:IsNull() and enemies[1]:IsAlive() and not enemies[1]:IsInvulnerable() then
			print("enemy!")
			self:GetParent():SetCursorCastTarget(enemies[1])
			self.witch_doctor_paralyzing_cask:OnSpellStart()
		end

       
       
    
    end
   

end


