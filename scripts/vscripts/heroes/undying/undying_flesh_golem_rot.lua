LinkLuaModifier("modifier_undying_flesh_golem_rot", "heroes/undying/undying_flesh_golem_rot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_undying_flesh_golem_rot_buff", "heroes/undying/undying_flesh_golem_rot", LUA_MODIFIER_MOTION_NONE )
undying_flesh_golem_rot = class( {} )
function undying_flesh_golem_rot:GetIntrinsicModifierName()
	return "modifier_undying_flesh_golem_rot"
end

modifier_undying_flesh_golem_rot = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_flesh_golem_rot:IsHidden()
	return true
end

function modifier_undying_flesh_golem_rot:IsPurgeException()
	return false
end

function modifier_undying_flesh_golem_rot:IsPurgable()
	return false
end

function modifier_undying_flesh_golem_rot:IsPermanent()
	return true
end




function modifier_undying_flesh_golem_rot:OnCreated(kv)
    if not IsServer() then
        return
    end
end
function modifier_undying_flesh_golem_rot:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_undying_flesh_golem_rot:OnAbilityFullyCast(params)
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
        if not self:GetParent():HasModifier("modifier_undying_flesh_golem_rot_buff") then
            self:GetParent():AddNewModifier(self:GetParent(),self.undying_tombstone,"modifier_undying_flesh_golem_rot_buff",{})
        else
            local buff = self:GetParent():FindModifierByName("modifier_undying_flesh_golem_rot_buff")
            if buff then
                buff:ForceRefresh()
            end
        end
    end

  
end
modifier_undying_flesh_golem_rot_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_flesh_golem_rot_buff:IsHidden()
	return true
end

function modifier_undying_flesh_golem_rot_buff:IsPurgeException()
	return false
end

function modifier_undying_flesh_golem_rot_buff:IsPurgable()
	return false
end

function modifier_undying_flesh_golem_rot_buff:IsPermanent()
	return true
end
function modifier_undying_flesh_golem_rot_buff:DeclareFunctions()
	local funcs = {
		
		MODIFIER_EVENT_ON_DEATH,
		
	}

	return funcs
end
function modifier_undying_flesh_golem_rot_buff:OnDeath(params)
	if not IsServer() then return end

    if self:GetParent():IsNull() or not self:GetParent():IsAlive() then
        return
    end

	if params.attacker == nil or params.unit == nil then
		return
	end

	if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return
	end
	local vToCaster = self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()
	local flDistance = vToCaster:Length2D()
	if 500 >= flDistance then
        local maxhealth = self:GetCaster():GetMaxHealth()
        local heal = maxhealth*0.04
		if self.canheal then
           -- print("heal")
            self:GetParent():Heal( heal, nil )
        end
	end
end



function modifier_undying_flesh_golem_rot_buff:OnCreated(kv)
    if not IsServer() then
        return
    end
    self.canheal = false
    self:StartIntervalThink(0.2)
end
function modifier_undying_flesh_golem_rot_buff:OnRefresh(kv)
    if not IsServer() then
        return
    end
    self.canheal = false
    self:StartIntervalThink(0.2)
end
function modifier_undying_flesh_golem_rot_buff:OnIntervalThink()
    if self:GetParent():HasModifier("modifier_undying_flesh_golem") then
        self.canheal = true
    else
        self.canheal = false
        self:StartIntervalThink(-1)
    end
end