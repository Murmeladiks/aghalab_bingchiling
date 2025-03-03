medusa_mystic_snake_split = class( {} )

LinkLuaModifier( "modifier_medusa_mystic_snake_split", "heroes/medusa/medusa_mystic_snake_split", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function medusa_mystic_snake_split:Precache( context )	
	
end
function medusa_mystic_snake_split:GetIntrinsicModifierName()
	return "modifier_medusa_mystic_snake_split"
end


modifier_medusa_mystic_snake_split = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_mystic_snake_split:IsHidden()
	return true
end

function modifier_medusa_mystic_snake_split:IsPurgeException()
	return false
end

function modifier_medusa_mystic_snake_split:IsPurgable()
	return false
end

function modifier_medusa_mystic_snake_split:IsPermanent()
	return true
end


function modifier_medusa_mystic_snake_split:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_medusa_mystic_snake_split:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_medusa_mystic_snake_split:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "medusa_mystic_snake" then
        
        self.medusa_mystic_snake = self:GetParent():FindAbilityByName("medusa_mystic_snake")
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
		if enemies[2] and not enemies[2]:IsNull() and enemies[2]:IsAlive() and not enemies[2]:IsInvulnerable() then
			print("enemy!")
			self:GetParent():SetCursorCastTarget(enemies[2])
			self.medusa_mystic_snake:OnSpellStart()
		end

       
       
    
    end
   

end


