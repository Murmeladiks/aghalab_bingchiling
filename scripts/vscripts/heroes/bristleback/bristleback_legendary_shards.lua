pathfinder_bristleback_bristleback_call_quilly_pf = class({})

function pathfinder_bristleback_bristleback_call_quilly_pf:Spawn()
	if IsClient() then return end
	self:GetCaster():FindAbilityByName("bristleback_call_quilly_pf"):SetHidden(false)
end
