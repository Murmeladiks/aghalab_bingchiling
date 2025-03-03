undying_soul_rip_tear= class( {} )

LinkLuaModifier( "modifier_undying_soul_rip_tear", "heroes/undying/undying_soul_rip_tear", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rip_zombie_stat", "heroes/undying/undying_soul_rip_tear", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function undying_soul_rip_tear:GetIntrinsicModifierName()
	return "modifier_undying_soul_rip_tear"
end



modifier_undying_soul_rip_tear= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_soul_rip_tear:IsHidden()
	return true
end

function modifier_undying_soul_rip_tear:IsPurgeException()
	return false
end

function modifier_undying_soul_rip_tear:IsPurgable()
	return false
end

function modifier_undying_soul_rip_tear:IsPermanent()
	return true
end


function modifier_undying_soul_rip_tear:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_undying_soul_rip_tear:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_undying_soul_rip_tear:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
    self.chance = 50
    if params.inflictor and params.inflictor:GetAbilityName() == "undying_soul_rip" then
        if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
            local undying_tombstone = self:GetParent():FindAbilityByName("undying_tombstone")
            local duration = undying_tombstone:GetSpecialValueFor("duration")
            local zombie = CreateUnitByName("npc_dota_unit_undying_zombie",params.unit:GetAbsOrigin(),true,self:GetParent(), self:GetParent(),self:GetParent():GetTeamNumber())   
            zombie:AddNewModifier(zombie,nil,"modifier_rip_zombie_stat",{}) 
            zombie:AddNewModifier(caster, nil, "modifier_kill", {duration = duration}) 
        end
    end
    

end
modifier_rip_zombie_stat = class({})

------------------------------------------------------------------------------

function modifier_rip_zombie_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_rip_zombie_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_rip_zombie_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end