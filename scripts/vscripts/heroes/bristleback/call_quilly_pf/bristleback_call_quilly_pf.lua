LinkLuaModifier("modifier_quilly", "heroes/bristleback/call_quilly_pf/modifier_quilly", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

bristleback_call_quilly_pf = class({})

--------------------------------------------------------------------------------

function bristleback_call_quilly_pf:Spawn()
	if IsClient() then return end
	self:SetLevel(1)
end

--------------------------------------------------------------------------------

function bristleback_call_quilly_pf:Precache( context )
	PrecacheResource("particle", "particles/econ/items/pets/pet_frondillo/pet_spawn_frondillo.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_quilly_spawn.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_betray_quilly.vpcf", context)
end

--------------------------------------------------------------------------------

function bristleback_call_quilly_pf:IsRefreshable()
	return false
end

--------------------------------------------------------------------------------

function bristleback_call_quilly_pf:OnSpellStart()
	local caster = self:GetCaster()
	local health = caster:GetMaxHealth()

	local quilly = CreateUnitByName("npc_dota_creature_quilly", 
		caster:GetAbsOrigin() + caster:GetForwardVector() * 150, 
		true, 
		caster, 
		caster, 
		caster:GetTeamNumber())
	
	quilly:SetControllableByPlayer(caster:GetPlayerID(), true)

	-- segregate quilly creation and quilly stat set here
	quilly:SetBaseMoveSpeed(self:GetSpecialValueFor("quilly_movespeed"))
	quilly:SetBaseMaxHealth(health)
	quilly:SetMaxHealth(health)
	quilly:SetHealth(health)
	--quilly:ModifyHealth(health, nil, false, 0)
	quilly:SetBaseHealthRegen(caster:GetHealthRegen())
	quilly:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue(false))
	quilly:AddNewModifier(caster, self, "modifier_quilly", {})

	caster.quilly = quilly
	caster:SwapAbilities("bristleback_call_quilly_pf", "bristleback_betray_quilly_pf", false, true)

	-- maybe a little bit of flair here as well
	quilly:EmitSound("Bristleback.CastQuilly")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quilly_spawn.vpcf", PATTACH_ABSORIGIN, quilly)
	ParticleManager:SetParticleControl(pfx, 0, quilly:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
end