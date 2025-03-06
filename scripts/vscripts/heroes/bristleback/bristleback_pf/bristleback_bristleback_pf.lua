LinkLuaModifier("modifier_bristleback_bristleback_pf", 				"heroes/bristleback/bristleback_pf/modifier_bristleback_bristleback_pf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_magical_bleed", 				"heroes/bristleback/bristleback_pf/modifier_bristleback_magical_bleed", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_heavy_ordnance", 	"heroes/bristleback/bristleback_pf/modifier_bristleback_bristleback_heavy_ordnance", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

bristleback_bristleback_pf = class({})

--------------------------------------------------------------------------------

function bristleback_bristleback_pf:Precache( context )
	PrecacheResource("particle", "particles/neutral_fx/mud_golem_hurl_boulder.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_heavy_ordnance_aura.vpcf", context)
end

--------------------------------------------------------------------------------

function bristleback_bristleback_pf:GetIntrinsicModifierName()
	return "modifier_bristleback_bristleback_pf"
end

--------------------------------------------------------------------------------

function bristleback_bristleback_pf:GetCooldown(iLevel)
	if IsServer() then return end
	if self:GetCaster():HasAbility("pathfinder_bristleback_bristleback_heavy_ordnance") then
		return self:GetCaster():FindAbilityByName("pathfinder_bristleback_bristleback_heavy_ordnance"):GetSpecialValueFor("end_cooldown")
	end

	return 0
end

--------------------------------------------------------------------------------

function bristleback_bristleback_pf:GetBehavior()
	if self:GetCaster():HasAbility("pathfinder_bristleback_bristleback_heavy_ordnance") then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

--------------------------------------------------------------------------------

function bristleback_bristleback_pf:GetCastRange(vLocation, hTarget)
	if self:GetCaster():HasAbility("pathfinder_bristleback_bristleback_heavy_ordnance") then
		return self:GetCaster():FindAbilityByName("pathfinder_bristleback_bristleback_heavy_ordnance"):GetSpecialValueFor("aura_radius")
	end
	return 0
end

--------------------------------------------------------------------------------

function bristleback_bristleback_pf:OnToggle()
	local caster = self:GetCaster()
	
	if self:GetToggleState() == true then
		caster:AddNewModifier(caster, self, "modifier_bristleback_bristleback_heavy_ordnance", {})
		caster:EmitSound("Bristleback.HeavyOrdnance")
		caster:EmitSound("Hero_Bristleback.Bristleback.Active")
	else
		local mod = caster:FindModifierByName("modifier_bristleback_bristleback_heavy_ordnance")

		if mod and not mod:IsNull() then
			mod:Destroy()
		end

		self:StartCooldown(self:GetCaster():FindAbilityByName("pathfinder_bristleback_bristleback_heavy_ordnance"):GetSpecialValueFor("end_cooldown"))
	end
end