LinkLuaModifier( "modifier_aghsfort_juggernaut_blade_fury", "heroes/juggernaut/modifier_aghsfort_juggernaut_blade_fury", LUA_MODIFIER_MOTION_NONE )
aghsfort_juggernaut_healing_ward = class({})

function aghsfort_juggernaut_healing_ward:Precache( context )	
	PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_latch_edge.vpcf", context )	
end


function aghsfort_juggernaut_healing_ward:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()

	-- Play cast sound
	caster:EmitSound("Hero_Juggernaut.HealingWard.Cast")

	local ward_name = "npc_dota_juggernaut_healing_ward"
	local mana_ward_name = "juggernaut_zen_ward"
	

	local healing_ward 
	if IsServer() then
		healing_ward = CreateUnitByName(ward_name, targetPoint, true, caster, caster, caster:GetTeamNumber())
		healing_ward:SetOwner(caster)	
		healing_ward:AddAbility("juggernaut_healing_ward_passive"):SetLevel(1)
		if caster:HasAbility("aghsfort_special_juggernaut_zen_ward") then 
			mana_ward = CreateUnitByName(mana_ward_name, targetPoint, true, caster, caster, caster:GetTeamNumber())
			local vRandomOffset = Vector(RandomInt(-300, 300), RandomInt(-300, 300), 0)
	 		local vSpawnPoint = targetPoint + vRandomOffset
		 	FindClearSpaceForUnit(mana_ward, vSpawnPoint, true)
			mana_ward:SetOwner(caster)	
			mana_ward:AddAbility("juggernaut_mana_ward_passive"):SetLevel(1)
			local mana_ward_duration = self:GetLevelSpecialValueFor("healing_ward_heal_duration", caster:FindAbilityByName("aghsfort_juggernaut_healing_ward"):GetLevel() - 1)
			mana_ward:AddNewModifier(caster, self, "modifier_kill", {duration = mana_ward_duration})	
			mana_ward:SetControllableByPlayer(caster:GetPlayerID(), true)	
		end
	end

	local ward_duration = self:GetLevelSpecialValueFor("healing_ward_heal_duration", caster:FindAbilityByName("aghsfort_juggernaut_healing_ward"):GetLevel() - 1)

	local max_health = self:GetLevelSpecialValueFor("ward_health", (self:GetLevel() - 1))
	
	healing_ward:SetBaseMaxHealth(math.floor(max_health))
	healing_ward:SetHealth(math.floor(max_health))
	healing_ward:AddNewModifier(caster, self, "modifier_kill", {duration = ward_duration})	
	healing_ward:SetControllableByPlayer(caster:GetPlayerID(), true)	
	if caster:HasAbility("aghsfort_special_juggernaut_healing_ward_blade_fury") then 
		local hability = caster:FindAbilityByName("aghsfort_juggernaut_blade_fury")
		
			local bDuration = hability:GetLevelSpecialValueFor("duration",caster:FindAbilityByName("aghsfort_juggernaut_blade_fury"):GetLevel() - 1)
			healing_ward:AddNewModifier(
				caster, -- player source
				hability, -- ability source
				"modifier_aghsfort_juggernaut_blade_fury", -- modifier name
				{ duration = bDuration } -- kv
			)
			if caster:HasAbility("aghsfort_special_juggernaut_zen_ward") then 
				local hability = caster:FindAbilityByName("aghsfort_juggernaut_blade_fury")
		
				local bDuration = hability:GetLevelSpecialValueFor("duration",caster:FindAbilityByName("aghsfort_juggernaut_blade_fury"):GetLevel() - 1)
				mana_ward:AddNewModifier(
					caster, -- player source
					hability, -- ability source
					"modifier_aghsfort_juggernaut_blade_fury", -- modifier name
					{ duration = bDuration } -- kv
				)
			end
	end
	
	
end





------------------------------------------------------------------------------











