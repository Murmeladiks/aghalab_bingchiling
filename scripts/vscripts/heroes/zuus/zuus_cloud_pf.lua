LinkLuaModifier("modifier_zuus_cloud_pf", "heroes/zuus/zuus_cloud_pf", LUA_MODIFIER_MOTION_NONE)

zuus_cloud_pf = zuus_cloud_pf or class({})

function zuus_cloud_pf:Spawn()
	if IsClient() then return end
	self:SetLevel(1)
end

function zuus_cloud_pf:GetAOERadius()
	return self:GetSpecialValueFor("cloud_radius")
end

function zuus_cloud_pf:OnSpellStart()
	if IsServer() then
		self.target_point 			= self:GetCursorPosition()
		local caster 				= self:GetCaster()
		
		local cloud_arc_interval	= self:GetSpecialValueFor("cloud_arc_interval")
		local cloud_bolt_interval 	= self:GetSpecialValueFor("cloud_bolt_interval")
		local cloud_duration 		= self:GetSpecialValueFor("cloud_duration")
		local cloud_radius 			= self:GetSpecialValueFor("cloud_radius")

		EmitSoundOnLocationWithCaster(self.target_point, "Hero_Zuus.Cloud.Cast", caster)
		
		self.zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", Vector(self.target_point.x, self.target_point.y, 450), false, caster, nil, caster:GetTeam())
		self.zuus_nimbus_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
		self.zuus_nimbus_unit:SetModelScale(0.7)
		self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_phased", {})
		self.zuus_nimbus_unit:AddNewModifier(caster, self, "modifier_zuus_cloud_pf", {duration = cloud_duration, cloud_arc_interval = cloud_arc_interval, cloud_bolt_interval = cloud_bolt_interval, cloud_radius = cloud_radius})
		self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})
		self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_invulnerable", {duration = cloud_duration})
	end
end

modifier_zuus_cloud_pf = class({})
function modifier_zuus_cloud_pf:IsHidden() return true end
function modifier_zuus_cloud_pf:OnCreated(keys)
	if IsServer() then
		self.ability 				= self
		self.cloud_radius 			= keys.cloud_radius
		self.caster 				= self:GetCaster()
		self.arc_lightning			= self.caster:FindAbilityByName("zuus_arc_lightning_pf")
		self.lightning_bolt 		= self.caster:FindAbilityByName("zuus_lightning_bolt_pf")
		self.thundergods_wrath		= self.caster:FindAbilityByName("zuus_thundergods_wrath_pf")
		local target_point 			= GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent())
		
		self.original_z = target_point.z
		self:SetStackCount(self.original_z)

		-- Create nimbus cloud particle
		self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- Position of ground effect
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, Vector(target_point.x, target_point.y, 450))
		-- Radius of ground effect
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.cloud_radius, 0, 0))
		-- Position of cloud 
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, Vector(target_point.x, target_point.y, target_point.z + 450))	

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_zuus_cloud_pf:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_zuus_cloud_pf:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_zuus_cloud_pf:GetVisualZDelta()
	return 450
end

function modifier_zuus_cloud_pf:OnAbilityFullyCast(kv)
	if IsClient() then return end
	if kv.unit ~= self.caster then return end

	local target = kv.target
	local target_fallback = FindUnitsInRadius(
		self.caster:GetTeamNumber(), 
        self:GetParent():GetAbsOrigin(), 
        nil, 
        self.cloud_radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_NONE, 
        FIND_CLOSEST, false)[1]

	if kv.ability == self.arc_lightning then
		local projectile_shard = self:GetCaster():FindAbilityByName("pathfinder_zuus_arc_lightning_projectile")
		if projectile_shard then
			self.arc_lightning:OnSpellStartExternal(self:GetParent())
		else
			if target and target:GetRangeToUnit(self:GetParent()) <= self.cloud_radius then
				self.arc_lightning:OnSpellStartExternal(self:GetParent())
			elseif target_fallback then
				self.caster:SetCursorCastTarget(target_fallback)
				self.arc_lightning:OnSpellStartExternal(self:GetParent())
			end
		end
	elseif kv.ability == self.lightning_bolt then
		local line_shard = self.caster:FindAbilityByName("pathfinder_zuus_lightning_bolt_linear_cast")
		if line_shard then
			self.lightning_bolt:CastLightningBoltLinear(self:GetParent(), self.lightning_bolt:GetCursorPosition(), self.caster, self.lightning_bolt)
		else
			if target and target:GetRangeToUnit(self:GetParent()) <= self.cloud_radius then
				-- simply lightning bolt the same target
			elseif target_fallback then
				self.caster:SetCursorCastTarget(target_fallback)
			else
				self.caster:SetCursorPosition(self:GetParent():GetAbsOrigin() + RandomVector(self.cloud_radius * math.random()))
			end
			self.lightning_bolt:OnSpellStartExternal(self:GetParent())
		end
	elseif kv.ability == self.thundergods_wrath then
		self.thundergods_wrath:CastWrath(self:GetParent():GetAbsOrigin(), self.thundergods_wrath:GetSpecialValueFor("radius"))
	end
end

function modifier_zuus_cloud_pf:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.zuus_nimbus_particle, false)
	end
end
