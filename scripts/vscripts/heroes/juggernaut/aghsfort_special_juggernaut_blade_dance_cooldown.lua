aghsfort_special_juggernaut_blade_dance_cooldown = class({})
LinkLuaModifier( "modifier_juggernaut_blade_dance_cooldance", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_cooldown", LUA_MODIFIER_MOTION_NONE )


function aghsfort_special_juggernaut_blade_dance_cooldown:GetIntrinsicModifierName()
	return "modifier_juggernaut_blade_dance_cooldance"
end


modifier_juggernaut_blade_dance_cooldance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_blade_dance_cooldance:IsHidden()
    return true
end

function modifier_juggernaut_blade_dance_cooldance:IsPurgeException()
    return false
end

function modifier_juggernaut_blade_dance_cooldance:IsPurgable()
    return false
end

function modifier_juggernaut_blade_dance_cooldance:IsPermanent()
    return true
end



function modifier_juggernaut_blade_dance_cooldance:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_PRE_ATTACK,
       
    }
end

function modifier_juggernaut_blade_dance_cooldance:OnCreated(kv)
    if IsServer() then
        self.caster = self:GetCaster()
        self.cooldown_reduction = 1.5

        
        self:SetHasCustomTransmitterData( true )
    end
end

function modifier_juggernaut_blade_dance_cooldance:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance,
        cooldown_reduction = self.cooldown_reduction,
	}

	return data
end
function modifier_juggernaut_blade_dance_cooldance:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	self.cooldown_reduction = data.cooldown_reduction
end


function modifier_juggernaut_blade_dance_cooldance:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end

    if attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    if params.target:IsNull() or not params.target:IsAlive() or params.target:IsBuilding() or params.target:IsOther() then
        return
    end

    if params.no_attack_cooldown then
		return
	end
    self.blade = self:GetCaster():FindAbilityByName("juggernaut_blade_dance")
    self.fury = self:GetCaster():FindAbilityByName("juggernaut_blade_fury")
    self.slash = self:GetCaster():FindAbilityByName("juggernaut_omni_slash")
    self.swift = self:GetCaster():FindAbilityByName("juggernaut_swift_slash")
    self.chance = self.blade:GetSpecialValueFor("blade_dance_crit_chance")
    self.times = {
        ["juggernaut_blade_dance"]= 0,
        ["juggernaut_blade_fury"] = 0,
        ["juggernaut_omni_slash"] = 0,
        ["juggernaut_swift_slash"] = 0

    }
   
    print(self.chance)
    if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
        
        if self.blade then
            self.bladetime =  self.blade:GetCooldownTimeRemaining()
            self.times["juggernaut_blade_dance"] = self.bladetime
         end
         
         if self.fury then 
             self.furytime =  self.fury:GetCooldownTimeRemaining()
             self.times["juggernaut_blade_fury"] = self.furytime
         end
        
         if self.slash then 
             self.slashtime = self.slash:GetCooldownTimeRemaining()
             self.times["juggernaut_omni_slash"] = self.slashtime
         end
         
         if self.swift then 
             self.swifttime = self.swift:GetCooldownTimeRemaining()  
             self.times["juggernaut_swift_slash"] = self.swifttime 
         end
         local max = nil
         for _, value in pairs(self.times) do
             if (max == nil) or (value >= max) then
                 max = value
             end
         end
     
         print(max)
         
         if max > 0 then
             for key, val in pairs(self.times) do
                 if val == max then
                     self.maxcooldownname =  key
                 end
             end
         end
         print(self.maxcooldownname)
         if self.maxcooldownname then 
             self.ability = self:GetCaster():FindAbilityByName(self.maxcooldownname)
             local currentCoolDown = self.ability:GetCooldownTime()
             self.ability:EndCooldown()
             self.ability:StartCooldown(currentCoolDown - self.cooldown_reduction)
         end





    end
end
function modifier_juggernaut_blade_dance_cooldance:GetModifierPreAttack(params)
    if not IsServer() then
        return
    end
    self.blade = self:GetCaster():FindAbilityByName("juggernaut_blade_dance")
    self.fury = self:GetCaster():FindAbilityByName("juggernaut_blade_fury")
    self.slash = self:GetCaster():FindAbilityByName("juggernaut_omni_slash")
    self.swift = self:GetCaster():FindAbilityByName("juggernaut_swift_slash")
    self.chance = self.blade:GetSpecialValueFor("blade_dance_crit_chance")
    self.times1 = {
        ["juggernaut_blade_dance"]= 0,
        ["juggernaut_blade_fury"] = 0,
        ["juggernaut_omni_slash"] = 0,
        ["juggernaut_swift_slash"] = 0

    }
    if self:GetParent():HasModifier("modifier_juggernaut_omnislash") then
        if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
            if self.blade then
                self.bladetime =  self.blade:GetCooldownTimeRemaining()
                self.times1["juggernaut_blade_dance"] = self.bladetime
             end
             
             if self.fury then 
                 self.furytime =  self.fury:GetCooldownTimeRemaining()
                 self.times1["juggernaut_blade_fury"] = self.furytime
             end
            
             if self.slash then 
                 self.slashtime = self.slash:GetCooldownTimeRemaining()
                 self.times1["juggernaut_omni_slash"] = self.slashtime
             end
             
             if self.swift then 
                 self.swifttime = self.swift:GetCooldownTimeRemaining()  
                 self.times1["juggernaut_swift_slash"] = self.swifttime 
             end
            
             local max = nil
             for _, value in pairs(self.times1) do
                 if (max == nil) or (value >= max) then
                     max = value
                 end
             end
         
             print(max)
             
             if max > 0 then
                 for key, val in pairs(self.times1) do
                     if val == max then
                         self.maxcooldownname =  key
                     end
                 end
             end
             print(self.maxcooldownname)
             if self.maxcooldownname then 
                 self.ability = self:GetCaster():FindAbilityByName(self.maxcooldownname)
                 local currentCoolDown = self.ability:GetCooldownTime()
                 self.ability:EndCooldown()
                 self.ability:StartCooldown(currentCoolDown - self.cooldown_reduction)
             end
        end

    end
end
function modifier_juggernaut_blade_dance_cooldance:OnTooltip()
    return self.cooldown_reduction
end