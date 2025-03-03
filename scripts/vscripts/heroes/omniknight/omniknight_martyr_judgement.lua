omniknight_martyr_judgement = class( {} )

LinkLuaModifier( "modifier_omniknight_martyr_judgement", "heroes/omniknight/omniknight_martyr_judgement", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/queenofpain/queenofpain_scream_of_pain_knockback", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function omniknight_martyr_judgement:GetIntrinsicModifierName()
	return "modifier_omniknight_martyr_judgement"
end

modifier_omniknight_martyr_judgement = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_martyr_judgement:IsHidden()
	return true
end

function modifier_omniknight_martyr_judgement:IsPurgeException()
	return false
end

function modifier_omniknight_martyr_judgement:IsPurgable()
	return false
end

function modifier_omniknight_martyr_judgement:IsPermanent()
	return true
end


function modifier_omniknight_martyr_judgement:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_martyr_judgement:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_omniknight_martyr_judgement:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "omniknight_martyr" then
        self.omniknight_martyr = self:GetParent():FindAbilityByName("omniknight_martyr")
        local damage = self:GetParent():GetStrength()*1.5
        self.damagetable = {
            --victim = target,
            attacker = self:GetParent(),
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self.omniknight_martyr, --Optional.
        }
        
        local Range = 400
                    
                        local enemies = FindUnitsInRadius(
                            self:GetParent():GetTeamNumber(),	-- int, your team number
                            params.target:GetAbsOrigin(),	-- point, center point
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
                            local distance = 400
                            local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
                            enemy:AddNewModifier(self:GetParent(),self.omniknight_martyr,"modifier_generic_knockback_lua",
                                    {
                                        duration = duration,
                                        distance = distance,
                                        height = 30,
                                        direction_x = enemy_direction.x,
                                        direction_y = enemy_direction.y,
                                    } 
                                )
                            self.damagetable.victim = enemy
                            ApplyDamage(self.damagetable)
                        end
                        
    end

end
