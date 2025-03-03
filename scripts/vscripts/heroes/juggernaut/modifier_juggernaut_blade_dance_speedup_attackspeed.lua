
modifier_juggernaut_blade_dance_speedup_attackspeed = class({})


function modifier_juggernaut_blade_dance_speedup_attackspeed:IsPurgable()
	return false
end

function modifier_juggernaut_blade_dance_speedup_attackspeed:IsPurgeException()
	return false
end

function modifier_juggernaut_blade_dance_speedup_attackspeed:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_juggernaut_blade_dance_speedup_attackspeed:OnCreated( kv )
	self.attackspeed  = 100
	self.attackrange = 200
	
end
function modifier_juggernaut_blade_dance_speedup_attackspeed:OnRefresh( kv )
	self.attackspeed  = 100
	self.attackrange = 200
end
--------------------------------------------------------------------------------

function modifier_juggernaut_blade_dance_speedup_attackspeed:OnRefresh( kv )
	
end



function modifier_juggernaut_blade_dance_speedup_attackspeed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end



function modifier_juggernaut_blade_dance_speedup_attackspeed:GetModifierAttackSpeedPercentage(params)
	return self.attackspeed
end

function modifier_juggernaut_blade_dance_speedup_attackspeed:GetModifierAttackSpeed_Limit(params)
	return 1
end

function modifier_juggernaut_blade_dance_speedup_attackspeed:GetModifierAttackRangeBonus(params)
	return self.attackrange 
end


--------------------------------------------------------------------------------

