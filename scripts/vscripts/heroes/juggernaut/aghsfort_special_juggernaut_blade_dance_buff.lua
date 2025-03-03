aghsfort_special_juggernaut_blade_dance_buff = class({})
LinkLuaModifier( "modifier_juggernaut_blade_dance_stack", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_juggernaut_blade_dance_stack_think", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_buff", LUA_MODIFIER_MOTION_NONE )

function aghsfort_special_juggernaut_blade_dance_buff:GetIntrinsicModifierName()
	return "modifier_juggernaut_blade_dance_stack"
end


modifier_juggernaut_blade_dance_stack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_blade_dance_stack:IsHidden()
    return true
end

function modifier_juggernaut_blade_dance_stack:IsPurgeException()
    return false
end

function modifier_juggernaut_blade_dance_stack:IsPurgable()
    return false
end

function modifier_juggernaut_blade_dance_stack:IsPermanent()
    return true
end



function modifier_juggernaut_blade_dance_stack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end

function modifier_juggernaut_blade_dance_stack:OnCreated(kv)
    if IsServer() then
        self.caster = self:GetCaster()
        
        self:SetHasCustomTransmitterData( true )
    end
end

function modifier_juggernaut_blade_dance_stack:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_juggernaut_blade_dance_stack:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end


function modifier_juggernaut_blade_dance_stack:OnAttackLanded(params)
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
    self.ability = self:GetCaster():FindAbilityByName("juggernaut_blade_dance")
    self.chance = self.ability:GetSpecialValueFor("blade_dance_crit_chance")
    
    print(self.chance)
    if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
        local buffModifier =  params.attacker:AddNewModifier(params.attacker, nil,"modifier_juggernaut_blade_dance_stack_think", {duration=7})
            if(buffModifier) then
                buffModifier:AddStack()
                print("stack")
                
            end
    end
end

modifier_juggernaut_blade_dance_stack_think = class({})


function modifier_juggernaut_blade_dance_stack_think:IsPurgable()
	return false
end

function modifier_juggernaut_blade_dance_stack_think:IsPurgeException()
	return false
end

function modifier_juggernaut_blade_dance_stack_think:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_dance_stack_think:OnCreated( kv )
	self.movespeed  = 15
	self.evasion = 15
end
function modifier_juggernaut_blade_dance_stack_think:OnRefresh( kv )
	self.movespeed  = 15
    self.evasion = 15
end
--------------------------------------------------------------------------------

function modifier_juggernaut_blade_dance_stack_think:OnRefresh( kv )
	
end
function modifier_juggernaut_blade_dance_stack_think:AddStack()
    if self:GetStackCount() < 5 then
		self:IncrementStackCount()
	end
	if self:GetStackCount() == 5 then
		self:SetStackCount(5)
	   end
    print(self:GetStackCount())
	
    Timers:CreateTimer(7, function()
        if(self and not self:IsNull()) then
            self:DecrementStackCount()
        end
    end)
   
   
end


function modifier_juggernaut_blade_dance_stack_think:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT ,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		
	}

	return funcs
end



function modifier_juggernaut_blade_dance_stack_think:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed*self:GetStackCount()
end

function modifier_juggernaut_blade_dance_stack_think:GetModifierIgnoreMovespeedLimit(params)
	return 1
end
function modifier_juggernaut_blade_dance_stack_think:GetModifierEvasion_Constant(params)
	return self.evasion*self:GetStackCount()
end


--------------------------------------------------------------------------------


