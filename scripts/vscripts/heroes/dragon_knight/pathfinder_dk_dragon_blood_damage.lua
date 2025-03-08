pathfinder_dk_dragon_blood_damage = class({})

function pathfinder_dk_dragon_blood_damage:Spawn()
	if IsClient() then return end
	Timers:CreateTimer(0.07, function()
		local hDragonBlood = self:GetCaster():FindAbilityByName("dragon_knight_pf_dragon_blood")
		
		self:GetCaster():AddNewModifier(self:GetCaster(), hDragonBlood, "modifier_dragon_knight_pf_dragon_blood_boiling_veins", hModifierTable)
	end)
end
