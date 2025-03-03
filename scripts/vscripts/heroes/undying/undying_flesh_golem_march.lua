LinkLuaModifier("modifier_undying_flesh_golem_march", "heroes/undying/undying_flesh_golem_march", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_undying_flesh_golem_march_buff", "heroes/undying/undying_flesh_golem_march", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_march_zombie_stat", "heroes/undying/undying_flesh_golem_march", LUA_MODIFIER_MOTION_NONE )
undying_flesh_golem_march = class( {} )
function undying_flesh_golem_march:GetIntrinsicModifierName()
	return "modifier_undying_flesh_golem_march"
end

modifier_undying_flesh_golem_march = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_flesh_golem_march:IsHidden()
	return true
end

function modifier_undying_flesh_golem_march:IsPurgeException()
	return false
end

function modifier_undying_flesh_golem_march:IsPurgable()
	return false
end

function modifier_undying_flesh_golem_march:IsPermanent()
	return true
end




function modifier_undying_flesh_golem_march:OnCreated(kv)
    if not IsServer() then
        return
    end
end
function modifier_undying_flesh_golem_march:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_undying_flesh_golem_march:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "undying_flesh_golem" then
        return
    end
    self.undying_tombstone = self:GetParent():FindAbilityByName("undying_tombstone")
    if self.undying_tombstone and self.undying_tombstone:GetLevel()>0 then
        if not self:GetParent():HasModifier("modifier_undying_flesh_golem_march_buff") then
            self:GetParent():AddNewModifier(self:GetParent(),self.undying_tombstone,"modifier_undying_flesh_golem_march_buff",{})
        else
            local buff = self:GetParent():FindModifierByName("modifier_undying_flesh_golem_march_buff")
            if buff then
                buff:ForceRefresh()
            end
        end
    end

  
end
modifier_undying_flesh_golem_march_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_flesh_golem_march_buff:IsHidden()
	return true
end

function modifier_undying_flesh_golem_march_buff:IsPurgeException()
	return false
end

function modifier_undying_flesh_golem_march_buff:IsPurgable()
	return false
end

function modifier_undying_flesh_golem_march_buff:IsPermanent()
	return true
end




function modifier_undying_flesh_golem_march_buff:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end
function modifier_undying_flesh_golem_march_buff:OnRefresh(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end
function modifier_undying_flesh_golem_march_buff:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_undying_flesh_golem") then
        local undying_tombstone = self:GetParent():FindAbilityByName("undying_tombstone")
        local duration = undying_tombstone:GetSpecialValueFor("duration")
        local zombie = CreateUnitByName("npc_dota_unit_undying_zombie",self:GetParent():GetAbsOrigin(),true,self:GetParent(), self:GetParent(),self:GetParent():GetTeamNumber())
        zombie:AddNewModifier(zombie,nil,"modifier_march_zombie_stat",{}) 
        zombie:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
    else
        self:StartIntervalThink(-1)
    end
end

modifier_march_zombie_stat = class({})

------------------------------------------------------------------------------

function modifier_march_zombie_stat:IsPurgable()
	return false
end

------------------------------------------------------------------------------

function modifier_march_zombie_stat:OnCreated( kv )
    if IsServer() then
      
    end
end


function modifier_march_zombie_stat:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end