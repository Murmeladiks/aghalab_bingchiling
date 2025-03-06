pathfinder_zuus_cloud = class({})

function pathfinder_zuus_cloud:Spawn()
	if IsClient() then return end
	local ability = self:GetCaster():FindAbilityByName("zuus_cloud_pf")
	ability:SetHidden(false)
	ability:SetLevel(1)
end

pathfinder_zuus_heavenly_jump = class({})

function pathfinder_zuus_heavenly_jump:Spawn()
	if IsClient() then return end
	local ability = self:GetCaster():FindAbilityByName("zuus_heavenly_jump_pf")
	ability:SetHidden(false)
	ability:SetLevel(1)
end
