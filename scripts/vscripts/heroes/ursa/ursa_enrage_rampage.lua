ursa_enrage_rampage = class( {} )

LinkLuaModifier( "modifier_ursa_enrage_rampage", "heroes/ursa/ursa_enrage_rampage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/queenofpain/queenofpain_scream_of_pain_knockback", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function ursa_enrage_rampage:GetIntrinsicModifierName()
	return "modifier_ursa_enrage_rampage"
end



modifier_ursa_enrage_rampage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_enrage_rampage:IsHidden()
	return true
end

function modifier_ursa_enrage_rampage:IsPurgeException()
	return false
end

function modifier_ursa_enrage_rampage:IsPurgable()
	return false
end

function modifier_ursa_enrage_rampage:IsPermanent()
	return true
end


function modifier_ursa_enrage_rampage:OnCreated( kv )
	if IsServer() then
        self.canrampage = false
    end
end

function modifier_ursa_enrage_rampage:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_ursa_enrage_rampage:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "ursa_enrage" then
        
        self.ursa_earthshock = self:GetParent():FindAbilityByName("ursa_earthshock")
        self.ursa_enrage = self:GetParent():FindAbilityByName("ursa_enrage")
        local duration = self.ursa_enrage:GetSpecialValueFor("duration")
        if self.ursa_earthshock and self.ursa_earthshock:GetLevel()>0 then
            if not self.canrampage then
                self:StartIntervalThink(1)
            end
            -- for i = 1, duration, 1 do
                
            --     Timers:CreateTimer(i*1.0, function()
            --         if(self and not self:IsNull()) then
            --             self.ursa_earthshock:OnSpellStart()
                       
            --                 local Range = 250
            --                 local enemies = FindUnitsInRadius(
            --                                     self:GetParent():GetTeamNumber(),	-- int, your team number
            --                                     self:GetParent():GetAbsOrigin(),	-- point, center point
            --                                     nil,	-- handle, cacheUnit. (not known)
            --                                     Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            --                                     DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
            --                                     DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            --                                     DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            --                                     FIND_CLOSEST,	-- int, order filter
            --                                     false
            --                                 )
            --                                 for _,enemy in pairs( enemies ) do
            --                                     if self:GetParent():HasAbility("ursa_earthshock_cannonball") then
            --                                         local origin =self:GetParent():GetOrigin()
            --                                         local duration = 0.3
            --                                         local distance = 125
            --                                         local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
            --                                         enemy:AddNewModifier(self:GetParent(),self.ursa_earthshock,"modifier_generic_knockback_lua",
            --                                                 {
            --                                                     duration = duration,
            --                                                     distance = distance,
            --                                                     height = 30,
            --                                                     direction_x = enemy_direction.x,
            --                                                     direction_y = enemy_direction.y,
            --                                                 } 
            --                                             )
            --                                         enemy:AddNewModifier(self:GetParent(),self.ursa_earthshock,"modifier_stunned",{duration = 1.5})
            --                                     end
            --                                     if self:GetParent():HasAbility("special_bonus_unique_ursa_earthshock_digging") then
            --                                         if enemy:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
            --                                             local buff = enemy:FindModifierByName("modifier_ursa_fury_swipes_damage_increase")
            --                                             local count = buff:GetStackCount()
            --                                             local damage = self.ursa_earthshock:GetAbilityDamage()*count*0.5
            --                                             print(damage)
            --                                             local damagetable = {
            --                                                 victim = enemy,
            --                                                 attacker = self:GetParent(),
            --                                                 damage = damage,
            --                                                 damage_type = DAMAGE_TYPE_MAGICAL,
            --                                                 ability = self.ursa_earthshock,
            --                                             }
            --                                             ApplyDamage(damagetable)
                                                    
            --                                         end
            --                                     end
            --                                 end
                       
                       
                            
                        
            --         end
            --     end)
            -- end   
        end
    end
     
  
   
    
		
	

    

end
function  modifier_ursa_enrage_rampage:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_ursa_enrage") then
        self.canrampage = true
        self.ursa_earthshock:OnSpellStart()
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
                                                if self:GetParent():HasAbility("ursa_earthshock_cannonball") then
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
                                                if self:GetParent():HasAbility("special_bonus_unique_ursa_earthshock_digging") then
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
                       
                       
                            
                        
                    
    else
        self:StartIntervalThink(-1)
        self.canrampage =false
    end
end