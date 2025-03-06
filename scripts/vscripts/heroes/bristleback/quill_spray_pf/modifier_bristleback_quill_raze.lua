modifier_bristleback_quill_raze = class({})
function modifier_bristleback_quill_raze:IsHidden()
	return true
end
function modifier_bristleback_quill_raze:RemoveOnDeath()
	return false
end
function modifier_bristleback_quill_raze:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bristleback_quill_raze:OnCreated(kv)
	if IsClient() then
		return
	end

	self.location = Vector(kv.x, kv.y, kv.z)
end

function modifier_bristleback_quill_raze:OnDestroy()
	if IsClient() then
		return
	end
	local parent = self:GetParent()
	if not parent or parent:IsNull() then
		return
	end
	local quill_shard = parent:FindAbilityByName("pathfinder_bristleback_quill_spray_pokes_from_the_devil")
	if not quill_shard or quill_shard:IsNull() then
		return
	end
	local quill_spray = parent:FindAbilityByName("bristleback_quill_spray_pf")
	if not quill_spray or quill_spray:IsNull() then
		return
	end
	local effect_radius = quill_shard:GetSpecialValueFor("effect_radius")

	local pfx =
		ParticleManager:CreateParticle(
		"particles/units/heroes/hero_bristleback/bristleback_quill_raze.vpcf",
		PATTACH_WORLDORIGIN,
		parent
	)
	ParticleManager:SetParticleControl(pfx, 0, self.location)
	ParticleManager:SetParticleControl(pfx, 1, Vector(effect_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx)
	EmitSoundOnLocationWithCaster(self.location, "Bristleback.PokesFromTheDevil", parent)

	local units =
		FindUnitsInRadius(
		parent:GetTeamNumber(),
		self.location,
		nil,
		effect_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, unit in pairs(units) do
		unit:AddNewModifier(
			parent,
			quill_spray,
			"modifier_bristleback_quill_spray_pf",
			{duration = quill_spray:GetSpecialValueFor("quill_stack_duration") * (1 - unit:GetStatusResistance())}
		)
		unit:AddNewModifier(
			parent,
			quill_spray,
			"modifier_stunned",
			{duration = quill_shard:GetSpecialValueFor("stun_duration") * (1 - unit:GetStatusResistance())}
		)
	end
end
