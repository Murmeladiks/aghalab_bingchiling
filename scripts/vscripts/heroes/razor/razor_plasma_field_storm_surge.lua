razor_plasma_field_storm_surge = class( {} )

LinkLuaModifier( "modifier_razor_plasma_field_storm_surge", "heroes/razor/razor_plasma_field_storm_surge", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function razor_plasma_field_storm_surge:GetIntrinsicModifierName()
	return "modifier_razor_plasma_field_storm_surge"
end

modifier_razor_plasma_field_storm_surge = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_plasma_field_storm_surge:IsHidden()
	return true
end

function modifier_razor_plasma_field_storm_surge:IsPurgeException()
	return false
end

function modifier_razor_plasma_field_storm_surge:IsPurgable()
	return false
end

function modifier_razor_plasma_field_storm_surge:IsPermanent()
	return true
end


function modifier_razor_plasma_field_storm_surge:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_razor_plasma_field_storm_surge:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_razor_plasma_field_storm_surge:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "razor_plasma_field" then
        return
    end
    local radius = params.ability:GetSpecialValueFor("radius")
    local duration = math.floor(params.ability:GetSpecialValueFor("total_ability_time"))
    
    self.razor_storm_surge =  self:GetCaster():FindAbilityByName("razor_storm_surge")
    local damage = self.razor_storm_surge:GetSpecialValueFor("strike_damage")*0.5
    if self.razor_storm_surge:GetLevel()>0 then
        for i = 1, duration*2, 1 do
            Timers:CreateTimer(i*0.5, function()
                if(self and not self:IsNull()) then
                
                    local enemies = FindUnitsInRadius(
                        self:GetParent():GetTeamNumber(),	-- int, your team number
                        self:GetParent():GetAbsOrigin(),	-- point, center point
                        nil,	-- handle, cacheUnit. (not known)
                        radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                        FIND_CLOSEST,	-- int, order filter
                        false
                    )
                    for _, enemy in pairs(enemies) do
                        if enemy and not enemy:IsNull() and not enemy:IsInvulnerable()  then
                            enemy:AddNewModifier(self:GetParent(),self.razor_storm_surge,"modifier_razor_unstablecurrent_slow",{duration = duration})
                            local damageTable = {
                                victim = enemy,
                                attacker = self:GetParent(),
                                damage = damage,
                                damage_type = DAMAGE_TYPE_MAGICAL,
                                ability = self.razor_storm_surge, --Optional.
                            }
                            ApplyDamage(damageTable)
                            local sound_cast = "Hero_Razor.UnstableCurrent.Target"
	                        EmitSoundOn( sound_cast, enemy )
                        end
                    end
            
                    
                    
                    
                end
            end)
        end   
    end
    
	
    
   
    
		
	

    

end