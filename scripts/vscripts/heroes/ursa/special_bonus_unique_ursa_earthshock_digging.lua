special_bonus_unique_ursa_earthshock_digging = class( {} )

LinkLuaModifier( "modifier_special_bonus_unique_ursa_earthshock_digging", "heroes/ursa/special_bonus_unique_ursa_earthshock_digging", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function special_bonus_unique_ursa_earthshock_digging:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_ursa_earthshock_digging"
end

modifier_special_bonus_unique_ursa_earthshock_digging = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_special_bonus_unique_ursa_earthshock_digging:IsHidden()
	return true
end

function modifier_special_bonus_unique_ursa_earthshock_digging:IsPurgeException()
	return false
end

function modifier_special_bonus_unique_ursa_earthshock_digging:IsPurgable()
	return false
end

function modifier_special_bonus_unique_ursa_earthshock_digging:IsPermanent()
	return true
end


function modifier_special_bonus_unique_ursa_earthshock_digging:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_special_bonus_unique_ursa_earthshock_digging:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_special_bonus_unique_ursa_earthshock_digging:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "ursa_earthshock" then
        self.ursa_earthshock = self:GetParent():FindAbilityByName("ursa_earthshock")
        self.ursa_fury_swipes =self:GetParent():FindAbilityByName("ursa_fury_swipes")

  
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
                            if enemy:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
                                local buff = enemy:FindModifierByName("modifier_ursa_fury_swipes_damage_increase")
                                local count = buff:GetStackCount()
                                local damage = self.ursa_earthshock:GetAbilityDamage()*count*0.5
                                print(damage)
                                local damagetable = {
                                    victim = enemy,
                                    attacker = self:GetParent(),
                                    damage = damage,
                                    damage_type = DAMAGE_TYPE_MAGICAL,
                                    ability = self.ursa_earthshock,
                                }
                                ApplyDamage(damagetable)
                            
                            end
                        end
    end
     
  
   
    
		
	

    

end