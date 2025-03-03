
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

