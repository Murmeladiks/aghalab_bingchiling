axe_battle_hunger_lua = class({})
LinkLuaModifier( "modifier_axe_battle_hunger_lua", "heroes/axe/modifier_axe_battle_hunger_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_battle_hunger_lua_debuff", "heroes/axe/modifier_axe_battle_hunger_lua_debuff", LUA_MODIFIER_MOTION_NONE )


function axe_battle_hunger_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor("duration")

	local enemies = FindRadiusPoint(caster, target_loc, self:GetSpecialValueFor("radius"), true)

	for _,target in pairs(enemies) do
		target:AddNewModifier(
			caster, self, "modifier_axe_battle_hunger_lua_debuff", { duration = duration }
		)
		
		caster:AddNewModifier(
			caster, self, "modifier_axe_battle_hunger_lua", { duration = duration }
		)
	end

	local sound_cast = "Hero_Axe.Battle_Hunger"
	caster:EmitSound( sound_cast)
end

function axe_battle_hunger_lua:OnSpellStartSingle(unit)
	local caster = self:GetCaster()
	local target = unit

	local duration = self:GetSpecialValueFor("duration")
		
	target:AddNewModifier(
		caster, self, "modifier_axe_battle_hunger_lua_debuff", { duration = duration }
	)	
	
	caster:AddNewModifier(
		caster, self, "modifier_axe_battle_hunger_lua", { duration = duration }
	)	
end

function axe_battle_hunger_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

