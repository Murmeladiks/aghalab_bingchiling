modifier_bristleback_bristleback_pf = class({})

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_pf:IsHidden() return true end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_pf:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self.side_angle = self.ability:GetSpecialValueFor("side_angle")
	self.back_angle = self.ability:GetSpecialValueFor("back_angle")
	self.quill_release_interval = self.ability:GetSpecialValueFor("quill_release_interval")
	
	self.bSnotRock = self.caster:GetHeroFacetID() == 2

	self.cumulative_damage = 0
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_pf:OnRefresh()
	self.side_angle = self.ability:GetSpecialValueFor("side_angle")
	self.back_angle = self.ability:GetSpecialValueFor("back_angle")
	self.quill_release_interval = self.ability:GetSpecialValueFor("quill_release_interval")
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_pf:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end

--------------------------------------------------------------------------------

function modifier_bristleback_bristleback_pf:GetModifierIncomingDamage_Percentage(keys)
	if self.parent:PassivesDisabled() or
		bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or
		bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS
	then return 0 end

	local warpath_mod = self.parent:FindModifierByName("modifier_bristleback_warpath_pf")
	local damage_direction = (keys.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
	local angle = math.deg(math.acos(DotProduct(self.parent:GetForwardVector(), damage_direction)))
	angle = tostring(angle) == "nan" and 0 or angle

	local angle_diff = math.abs(AngleDiff(angle, 180))

	local back_damage_reduction = self.ability:GetSpecialValueFor("back_damage_reduction")
	local side_damage_reduction = self.ability:GetSpecialValueFor("side_damage_reduction")
	local quill_release_threshold = self.ability:GetSpecialValueFor("quill_release_threshold")

	if angle_diff <= self.back_angle then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle,1 ,self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:ReleaseParticleIndex(particle)

		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf",PATTACH_ABSORIGIN_FOLLOW,self.parent)
		ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:ReleaseParticleIndex(particle2)

		self.cumulative_damage = self.cumulative_damage + keys.damage * (1 - back_damage_reduction / 100)
		self.parent:EmitSound("Hero_Bristleback.Bristleback")

		if self.cumulative_damage >= quill_release_threshold then
			if self.bSnotRock then
				local nasal_goo = self.parent:FindAbilityByName("bristleback_viscous_nasal_goo_pf")
				local procs_to_trigger = math.floor(self.cumulative_damage / quill_release_threshold)

				if nasal_goo and nasal_goo:IsTrained() then
					local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.ability:GetSpecialValueFor("goo_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)

					for i = 1, procs_to_trigger do
						Timers:CreateTimer(i * self.quill_release_interval, function()
							print("gonna release!")
							for _, enemy in pairs(enemies) do
								nasal_goo:ViscousNasalGoo(enemy, false, true, self.parent)
							end
						end)
					end
				end
			else
				local quill_spray = self.parent:FindAbilityByName("bristleback_quill_spray_pf")
				local procs_to_trigger = math.floor(self.cumulative_damage / quill_release_threshold)

				if quill_spray and not quill_spray:IsNull() then
					for i = 1, procs_to_trigger do
						Timers:CreateTimer(i * self.quill_release_interval, function()
							quill_spray:SpawnQuills(self.parent:GetAbsOrigin(), self.parent:GetForwardVector(), true)
						end)
					end
				end
			end

			self.cumulative_damage = self.cumulative_damage % quill_release_threshold
			

			if warpath_mod then
				warpath_mod:ProcWarpath()
			end
		end

		local goo_intrinsic = self.parent:FindModifierByName("modifier_bristleback_viscous_nasal_goo_pf_intrinsic")
		if goo_intrinsic and not goo_intrinsic:IsNull() then goo_intrinsic:DirtyBrawlerInteraction() end

		return -back_damage_reduction
	elseif angle_diff <= self.side_angle then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_side_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:ReleaseParticleIndex(particle)

		return -side_damage_reduction
	else
		return 0
	end
end