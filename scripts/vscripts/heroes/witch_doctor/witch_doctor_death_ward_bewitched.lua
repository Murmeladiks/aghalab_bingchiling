witch_doctor_death_ward_bewitched = class( {} )

LinkLuaModifier( "modifier_witch_doctor_death_ward_bewitched", "heroes/witch_doctor/witch_doctor_death_ward_bewitched", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_ward_dummy_stat", "heroes/witch_doctor/witch_doctor_death_ward_bewitched", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function witch_doctor_death_ward_bewitched:GetIntrinsicModifierName()
	return "modifier_witch_doctor_death_ward_bewitched"
end


modifier_witch_doctor_death_ward_bewitched = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_death_ward_bewitched:IsHidden()
	return true
end

function modifier_witch_doctor_death_ward_bewitched:IsPurgeException()
	return false
end

function modifier_witch_doctor_death_ward_bewitched:IsPurgable()
	return false
end

function modifier_witch_doctor_death_ward_bewitched:IsPermanent()
	return true
end



function modifier_witch_doctor_death_ward_bewitched:OnCreated(kv)
    if IsServer() then
       
    end
end



function modifier_witch_doctor_death_ward_bewitched:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       -- MODIFIER_EVENT_ON_TAKEDAMAGE,
       
    }
end
function modifier_witch_doctor_death_ward_bewitched:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    
    --棒子伤害来源于其自身的攻击力
    if params.ability:GetAbilityName() == "witch_doctor_death_ward" then
        local vPos = self:GetParent():GetCursorPosition()
        local death_ward =  CreateUnitByName("npc_dota_witch_doctor_death_ward", vPos, true, nil, nil, DOTA_TEAM_GOODGUYS)
        self.witch_doctor_death_ward = self:GetParent():FindAbilityByName("witch_doctor_death_ward")
        local damage = self.witch_doctor_death_ward:GetSpecialValueFor("damage")
        local duration = self.witch_doctor_death_ward:GetChannelTime()
       -- death_ward:SetOwner(self:GetParent())
        death_ward:SetBaseDamageMin(damage)
        death_ward:SetBaseDamageMax(damage)
        death_ward:AddNewModifier(self:GetParent(),self.witch_doctor_death_ward,"modifier_witch_doctor_death_ward",{duration = duration})
        death_ward:AddNewModifier(nil,nil,"modifier_kill",{duration = duration})
        death_ward:AddNewModifier(self:GetParent(),self.witch_doctor_death_ward,"modifier_death_ward_dummy_stat",{})
    end
end

function  modifier_witch_doctor_death_ward_bewitched:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    --伤害来源是棒子而不是巫医
    -- if params.attacker ~= self:GetParent() then
    --     return
    -- end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "witch_doctor_death_ward" then
        if self:GetParent() then
            self:GetParent():PerformAttack(params.unit, true, true, true, true, false, false, true)
        end
    end

end
modifier_death_ward_dummy_stat = class({})

------------------------------------------------------------------------------

function modifier_death_ward_dummy_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_death_ward_dummy_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_death_ward_dummy_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		
		[MODIFIER_STATE_INVULNERABLE] = true,
		
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end
