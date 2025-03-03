ursa_fury_swipes_armor = class( {} )

LinkLuaModifier( "modifier_ursa_fury_swipes_armor", "heroes/ursa/ursa_fury_swipes_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ursa_fury_swipes_armor_buff", "heroes/ursa/ursa_fury_swipes_armor", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ursa_fury_swipes_armor:GetIntrinsicModifierName()
	return "modifier_ursa_fury_swipes_armor"
end

modifier_ursa_fury_swipes_armor = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_fury_swipes_armor:IsHidden()
	return true
end

function modifier_ursa_fury_swipes_armor:IsPurgeException()
	return false
end

function modifier_ursa_fury_swipes_armor:IsPurgable()
	return false
end

function modifier_ursa_fury_swipes_armor:IsPermanent()
	return true
end



function modifier_ursa_fury_swipes_armor:OnCreated(kv)
    if IsServer() then
        
        self.cancritical = false
   
    end
end
function modifier_ursa_fury_swipes_armor:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
       
    }
end


function modifier_ursa_fury_swipes_armor:OnAttackStart(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    self.ursa_fury_swipes = self:GetParent():FindAbilityByName("ursa_fury_swipes")
    local duration = self.ursa_fury_swipes:GetSpecialValueFor("bonus_reset_time")
    if params.target then
        if not params.target:HasModifier("modifier_ursa_fury_swipes_armor_buff") then
            params.target:AddNewModifier(self:GetParent(), self.ursa_fury_swipes, "modifier_ursa_fury_swipes_armor_buff", {duration = duration})
        else
            local buff = params.target:FindModifierByName("modifier_ursa_fury_swipes_armor_buff")
            if buff then
                buff:SetStackCount(buff:GetStackCount()+1)
                buff:ForceRefresh()
            end
        end
    end
    
       
end


modifier_ursa_fury_swipes_armor_buff = class({})

function modifier_ursa_fury_swipes_armor_buff:IsHidden()
	return true
end

function modifier_ursa_fury_swipes_armor_buff:IsPurgeException()
	return false
end

function modifier_ursa_fury_swipes_armor_buff:IsPurgable()
	return false
end

function modifier_ursa_fury_swipes_armor_buff:IsPermanent()
	return false
end

function modifier_ursa_fury_swipes_armor_buff:OnCreated(kv)
    

    if IsServer() then
        self.armor = -1
        self:SetHasCustomTransmitterData(true)
    end

  
end


function modifier_ursa_fury_swipes_armor_buff:AddCustomTransmitterData()
    return {
       
		
		armor=self.armor,
		
    }
end
function modifier_ursa_fury_swipes_armor_buff:HandleCustomTransmitterData( data )
    
	  self.armor = data.armor
	
end
function modifier_ursa_fury_swipes_armor_buff:DeclareFunctions()
	return {     
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

end
function modifier_ursa_fury_swipes_armor_buff:GetModifierPhysicalArmorBonus(params)
    return self.armor*(1+self:GetStackCount())
end
