ursa_earthshock_cannonball = class( {} )

LinkLuaModifier( "modifier_ursa_earthshock_cannonball", "heroes/ursa/ursa_earthshock_cannonball", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/queenofpain/queenofpain_scream_of_pain_knockback", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function ursa_earthshock_cannonball:GetIntrinsicModifierName()
	return "modifier_ursa_earthshock_cannonball"
end

modifier_ursa_earthshock_cannonball = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_earthshock_cannonball:IsHidden()
	return true
end

function modifier_ursa_earthshock_cannonball:IsPurgeException()
	return false
end

function modifier_ursa_earthshock_cannonball:IsPurgable()
	return false
end

function modifier_ursa_earthshock_cannonball:IsPermanent()
	return true
end


function modifier_ursa_earthshock_cannonball:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_ursa_earthshock_cannonball:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_ursa_earthshock_cannonball:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "ursa_earthshock" then
        self.ursa_earthshock = params.unit:FindAbilityByName("ursa_earthshock")
        
        local Range = 250
        local enemies = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),	-- int, your team number
                            self:GetParent():GetAbsOrigin(),	-- point, center point
                            nil,	-- handle, cacheUnit. (not known)
                            Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                            DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                            FIND_CLOSEST,	-- int, order filter
                            false
                        )
                        for _,enemy in pairs( enemies ) do
                            local origin =self:GetParent():GetOrigin()
                            local duration = 0.3
                            local distance = 125
                            local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
                            enemy:AddNewModifier(self:GetParent(),self.ursa_earthshock,"modifier_generic_knockback_lua",
                                    {
                                        duration = duration,
                                        distance = distance,
                                        height = 30,
                                        direction_x = enemy_direction.x,
                                        direction_y = enemy_direction.y,
                                    } 
                                )
                            enemy:AddNewModifier(self:GetParent(),self.ursa_earthshock,"modifier_stunned",{duration = 1.5})
                        end
    end
     
  
   
    
		
	

    

end