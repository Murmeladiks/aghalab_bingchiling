omniknight_martyr_barrier = class( {} )

LinkLuaModifier( "modifier_omniknight_martyr_barrier", "heroes/omniknight/omniknight_martyr_barrier", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_omniknight_martyr_barrier_buff", "heroes/omniknight/omniknight_martyr_barrier", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function omniknight_martyr_barrier:GetIntrinsicModifierName()
	return "modifier_omniknight_martyr_barrier"
end

modifier_omniknight_martyr_barrier = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_martyr_barrier:IsHidden()
	return true
end

function modifier_omniknight_martyr_barrier:IsPurgeException()
	return false
end

function modifier_omniknight_martyr_barrier:IsPurgable()
	return false
end

function modifier_omniknight_martyr_barrier:IsPermanent()
	return true
end


function modifier_omniknight_martyr_barrier:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_martyr_barrier:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_omniknight_martyr_barrier:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "omniknight_martyr" then
        self.omniknight_martyr = self:GetParent():FindAbilityByName("omniknight_martyr")
        local duration = self.omniknight_martyr:GetSpecialValueFor("duration")
        if not params.target:HasModifier("modifier_omniknight_martyr_barrier_buff") then
            local barrier_buff =  params.target:AddNewModifier(self:GetParent(), self.omniknight_martyr, "modifier_omniknight_martyr_barrier_buff", {duration =duration})
            barrier_buff:SetStackCount(5)

        else
            local buff = params.target:FindModifierByName("modifier_omniknight_martyr_barrier_buff")
            if buff then
                buff:SetStackCount(5)
                buff:ForceRefresh()
            end
        end
    end

end
modifier_omniknight_martyr_barrier_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_martyr_barrier_buff:IsHidden()
	return false
end

function modifier_omniknight_martyr_barrier_buff:IsPurgeException()
	return false
end

function modifier_omniknight_martyr_barrier_buff:IsPurgable()
	return false
end

function modifier_omniknight_martyr_barrier_buff:IsPermanent()
	return false
end


function modifier_omniknight_martyr_barrier_buff:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_martyr_barrier_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,

    }
    return funcs
end
function modifier_omniknight_martyr_barrier_buff:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker == self:GetParent() then
        return
    end



   
   if params.unit == self:GetParent() then
        if self:GetStackCount()>1 then
            self:SetStackCount(self:GetStackCount()-1)
        else
            self:GetParent():RemoveModifierByName("modifier_omniknight_martyr_barrier_buff")
        end
    end
    
   
  
end
function modifier_omniknight_martyr_barrier_buff:GetModifierIncomingDamage_Percentage( params )
    return -100
end