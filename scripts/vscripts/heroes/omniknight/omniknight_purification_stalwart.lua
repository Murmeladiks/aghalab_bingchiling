omniknight_purification_stalwart = class({})
LinkLuaModifier( "modifier_omniknight_purification_stalwart", "heroes/omniknight/omniknight_purification_stalwart", LUA_MODIFIER_MOTION_NONE )


function omniknight_purification_stalwart:GetIntrinsicModifierName()
	return "modifier_omniknight_purification_stalwart"
end


modifier_omniknight_purification_stalwart = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_purification_stalwart:IsHidden()
    return true
end

function modifier_omniknight_purification_stalwart:IsPurgeException()
    return false
end

function modifier_omniknight_purification_stalwart:IsPurgable()
    return false
end

function modifier_omniknight_purification_stalwart:IsPermanent()
    return true
end



function modifier_omniknight_purification_stalwart:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_TOOLTIP,
        
       
    }
end

function modifier_omniknight_purification_stalwart:OnCreated(kv)
    if IsServer() then
        self.caster = self:GetCaster()
        self.cooldown_reduction = 0.2
        self:SetHasCustomTransmitterData( true )
    end
end

function modifier_omniknight_purification_stalwart:AddCustomTransmitterData()
	-- on server
	local data = {
		
        cooldown_reduction = self.cooldown_reduction,
	}

	return data
end
function modifier_omniknight_purification_stalwart:HandleCustomTransmitterData( data )
	-- on client
	self.cooldown_reduction = data.cooldown_reduction
end


function modifier_omniknight_purification_stalwart:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker == self:GetParent() then
        return
    end



   
   if params.unit == self:GetParent() then
    self.omniknight_purification = self:GetParent():FindAbilityByName("omniknight_purification")
    local currentCoolDown = self.omniknight_purification:GetCooldownTime()
    self.omniknight_purification:EndCooldown()
    self.omniknight_purification:StartCooldown(currentCoolDown - self.cooldown_reduction)
    end
    
   
  
end

function modifier_omniknight_purification_stalwart:OnTooltip()
    return self.cooldown_reduction
end