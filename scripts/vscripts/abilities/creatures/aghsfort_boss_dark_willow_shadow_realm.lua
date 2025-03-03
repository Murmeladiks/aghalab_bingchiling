aghsfort_boss_dark_willow_shadow_realm = class({})
LinkLuaModifier( "modifier_boss_dark_willow_shadow_realm", "modifiers/creatures/modifier_boss_dark_willow_shadow_realm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_dark_willow_shadow_realm_debuff", "modifiers/creatures/modifier_boss_dark_willow_shadow_realm_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start


function aghsfort_boss_dark_willow_shadow_realm:OnSpellStart()
	-- unit identifier
	
	local caster = self:GetCaster()
	
	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	
		local hHoundBoss = CreateUnitByName( "npc_dota_creature_lycan_boss", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		local vRandomOffset = Vector(RandomInt(-300, 300), RandomInt(-300, 300), 0)
		local vSpawnPoint = self:GetCaster():GetAbsOrigin() + vRandomOffset
		FindClearSpaceForUnit(hHoundBoss, vSpawnPoint, true)
		self.lycanboss = true
	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_boss_dark_willow_shadow_realm", -- modifier name
		{ duration = duration } -- kv
	)
	
end