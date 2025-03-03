witch_doctor_maledict_blighted = class( {} )

LinkLuaModifier( "modifier_witch_doctor_maledict_blighted", "heroes/witch_doctor/witch_doctor_maledict_blighted", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function witch_doctor_maledict_blighted:GetIntrinsicModifierName()
	return "modifier_witch_doctor_maledict_blighted"
end


modifier_witch_doctor_maledict_blighted = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_maledict_blighted:IsHidden()
	return true
end

function modifier_witch_doctor_maledict_blighted:IsPurgeException()
	return false
end

function modifier_witch_doctor_maledict_blighted:IsPurgable()
	return false
end

function modifier_witch_doctor_maledict_blighted:IsPermanent()
	return true
end


function modifier_witch_doctor_maledict_blighted:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_witch_doctor_maledict_blighted:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
       
	}

	return funcs
end



function  modifier_witch_doctor_maledict_blighted:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "witch_doctor_maledict" then
        self.witch_doctor_maledict = self:GetParent():FindAbilityByName("witch_doctor_maledict")
        local damage = params.damage
        self.damageTable = {
        --      victim = target,
                    attacker = self:GetParent(),
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility(), --Optional.
                }
             
        local Range = 300
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
                    self.damageTable.victim = enemy
                    ApplyDamage(self.damageTable)
                    if self:GetParent():HasAbility("witch_doctor_maledict_mumbo") then
                        local heal = damage*65/100
                        self:GetParent():Heal( heal, nil )
                    end
                end
            end           
        end
    end

end