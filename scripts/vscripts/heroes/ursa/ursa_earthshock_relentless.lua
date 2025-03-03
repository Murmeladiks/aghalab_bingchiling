ursa_earthshock_relentless = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_ursa_earthshock_relentless", "heroes/ursa/ursa_earthshock_relentless", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ursa_earthshock_relentless_stack", "heroes/ursa/ursa_earthshock_relentless", LUA_MODIFIER_MOTION_NONE )
function ursa_earthshock_relentless:GetIntrinsicModifierName()
	return "modifier_ursa_earthshock_relentless"
end
function ursa_earthshock_relentless:Precache( context )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end


modifier_ursa_earthshock_relentless = class({})

--------------------------------------------------------------------------------
-- Classifications

function modifier_ursa_earthshock_relentless:IsHidden()
	return true
end

function modifier_ursa_earthshock_relentless:IsPurgeException()
	return false
end

function modifier_ursa_earthshock_relentless:IsPurgable()
	return false
end

function modifier_ursa_earthshock_relentless:IsPermanent()
	return true
end




function modifier_ursa_earthshock_relentless:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_ursa_earthshock_relentless:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_ursa_earthshock_relentless:OnDeath(params)
    if not IsServer() then
        return
    end
    -- if params.attacker ~= self:GetParent() then
    --     return
    -- end
     self.ursa_overpower = self:GetParent():FindAbilityByName("ursa_overpower")
    
    if  params.unit:HasModifier("modifier_ursa_earthshock")  then
        if self.ursa_overpower and self.ursa_overpower:GetLevel()>0 then
            if not self:GetParent():HasModifier("modifier_ursa_overpower") then
                local buffModifier =  self:GetParent():AddNewModifier(params.attacker,self.ursa_overpower,"modifier_ursa_overpower",{duration = 20})
                buffModifier:SetStackCount(3)
            else
                local buff = self:GetParent():FindModifierByName("modifier_ursa_overpower")
                buff:SetStackCount(buff:GetStackCount()+3)
            end
        end
    end
  

    
end

