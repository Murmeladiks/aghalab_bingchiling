LinkLuaModifier( "modifier_spectre_haunt_dm_illusion_buff", "heroes/spectre/modifier_spectre_haunt_single_fix", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_spectre_dispersion_lua", "heroes/spectre/modifier_spectre_haunt_single_fix", LUA_MODIFIER_MOTION_BOTH )

modifier_spectre_haunt_single_fix = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_haunt_single_fix:IsHidden()
	return true
end


function modifier_spectre_haunt_single_fix:IsPurgable()
	return false
end

function modifier_spectre_haunt_single_fix:IsPurgeException()
	return false
end


function modifier_spectre_haunt_single_fix:IsPermanent()
	return true
end
function modifier_spectre_haunt_single_fix:OnCreated( kv )
	if not IsServer() then return end	
end

function modifier_spectre_haunt_single_fix:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_spectre_haunt_single_fix:OnAbilityFullyCast( params )
	if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    --if not params.target then return end
	if params.ability:GetAbilityName() == "item_manta"  then
		print("using mantan")
		if self:GetParent():HasAbility("spectre_haunt_heal") then
			local pos = self:GetParent():GetAbsOrigin()
			Timers:CreateTimer(0.5, function()
				local illusions = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				pos,
				nil,
				1000,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
				FIND_CLOSEST,
				false
			) 
				for _, illusion in pairs(illusions) do	
					if illusion and illusion:IsIllusion() then
						if illusion:GetName() == "npc_dota_hero_spectre" then
							print("found illusion")
							illusion:AddNewModifier(self:GetParent(), nil, "modifier_spectre_haunt_dm_illusion_buff", {duration =18})
						end
					end
				end
			end)
			
		
			
		end
	end 
        if params.ability:GetAbilityName() == "spectre_haunt_single"  then
			self.pos = params.target:GetAbsOrigin()
			self:CreateIllusion()
		end
		if params.ability:GetAbilityName() == "spectre_reality"  then
			print("facetid")
			print(self:GetParent():GetHeroFacetID())
			local pos = self:GetParent():GetCursorPosition()
			local pos1 = self:GetParent():GetAbsOrigin()
			local illusions = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				pos,
				nil,
				100,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
				FIND_CLOSEST,
				false
			) 
			--与所有的幻象换位置
			local heroillusion = {}
			for _, illusion in pairs(illusions) do	
				if illusion and illusion:IsIllusion() then
				 	if illusion:GetName() == "npc_dota_hero_spectre" then
				 		table.insert(heroillusion,illusion)
						
				 	end
			    end
			end
			if heroillusion[1] then
				FindClearSpaceForUnit( self:GetParent(), pos + RandomVector(50), false )
				FindClearSpaceForUnit( heroillusion[1], pos1 + RandomVector(50), false )
				if self:GetParent():GetHeroFacetID() == 2 then
					local enemies = FindUnitsInRadius(
					self:GetParent():GetTeamNumber(),
					pos,
					nil,
					600,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO,
					DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
					FIND_CLOSEST,
					false
					) 
					if enemies   then		
						self.spectre_spectral_dagger = self:GetParent():FindAbilityByName("spectre_spectral_dagger")
						if self.spectre_spectral_dagger and self.spectre_spectral_dagger:GetLevel()>0 then
							self:GetParent():SetCursorCastTarget(enemies[1])
							self.spectre_spectral_dagger:OnSpellStart()
						end
					end
					if self:GetParent():HasAbility("spectre_reality_cooldown") then
						self.spectre_reality = self:GetParent():FindAbilityByName("spectre_reality")
						self.spectre_reality:EndCooldown()
					end
				end
				
			end
			
			
		end
		if params.ability:GetAbilityName() == "spectre_haunt"  then
			self:CreateMoreIllusion()
		end
    
end

function modifier_spectre_haunt_single_fix :CreateIllusion()
	if not IsServer() then return nil end
	self.ability = self:GetParent():FindAbilityByName("spectre_haunt_single")
	local spawnPoint = self.pos
	local unit = self:GetParent():GetUnitName()
	local ability = self.ability
	local duration  = self.ability:GetSpecialValueFor("duration")
	local outgoingDamage = self.ability:GetSpecialValueFor("illusion_damage_outgoing")
	local incomingDamage = self.ability:GetSpecialValueFor("illusion_damage_incoming")
	local pszScriptName = "modifier_spectre_haunt_dm_illusion_buff"

	local illusion_kv = { duration = duration + 1, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage }

	-- ( hOwner, hHeroToCopy, hModiiferKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace )
	local illusions = CreateIllusions(self:GetParent(), self:GetParent(), illusion_kv, 1, 50, true, true )
	local illusion = illusions[1]
	illusion:SetPlayerID(self:GetParent():GetPlayerID())
	illusion:SetOwner(self:GetParent())

	local casterLevel = self:GetParent():GetLevel()
	for i=1,casterLevel-3 do
		illusion:HeroLevelUp(false)
	end
	illusion:SetAbilityPoints(0)
	for abilitySlot=0,15 do
		local ability = self:GetParent():GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end

	-- Recreate the items of the caster
	for itemSlot=0,5 do
		self:CopyItem(self:GetParent(), illusion, itemSlot)
	end

	-- 15, 16 分别为TP槽位和自然物品槽位
	for itemSlot=15,16 do
		self:CopyItem(self:GetParent(), illusion, itemSlot)
	end




	-- FindClearRandomPositionAroundUnit(illusion, illusion, 25)
	FindClearSpaceForUnit( illusion, spawnPoint + RandomVector(100), false )
	if self:GetParent():HasAbility("spectre_haunt_heal") then
		illusion:AddNewModifier(self:GetParent(), self.ability, "modifier_spectre_haunt_dm_illusion_buff", {duration = duration})
	end
	if self:GetParent():HasAbility("spectre_haunt_dispersion") then
		self.spectre_dispersion = self:GetParent():FindAbilityByName("spectre_dispersion")
		if self.spectre_dispersion and self.spectre_dispersion:GetLevel()>0 then
			illusion:AddNewModifier(self:GetParent(), self.ability, "modifier_spectre_dispersion_lua", {duration = duration})
		end
	end
	
end
function modifier_spectre_haunt_single_fix :CreateMoreIllusion()
	if not IsServer() then return nil end
	self.ability = self:GetParent():FindAbilityByName("spectre_haunt")
	local spawnPoint = self:GetParent():GetAbsOrigin()
	local unit = self:GetParent():GetUnitName()
	local ability = self.ability
	local duration  = self.ability:GetSpecialValueFor("duration")
	local outgoingDamage = self.ability:GetSpecialValueFor("illusion_damage_outgoing")
	local incomingDamage = self.ability:GetSpecialValueFor("illusion_damage_incoming")
	local pszScriptName = "modifier_spectre_haunt_dm_illusion_buff"

	local illusion_kv = { duration = duration + 1, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage }

	-- ( hOwner, hHeroToCopy, hModiiferKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace )
	local illusions = CreateIllusions(self:GetParent(), self:GetParent(), illusion_kv, 5, 50, true, true )
	for _, illusion in pairs(illusions) do
		illusion:SetPlayerID(self:GetParent():GetPlayerID())
		illusion:SetOwner(self:GetParent())

		local casterLevel = self:GetParent():GetLevel()
		for i=1,casterLevel-3 do
			illusion:HeroLevelUp(false)
		end
		illusion:SetAbilityPoints(0)
		for abilitySlot=0,15 do
			local ability = self:GetParent():GetAbilityByIndex(abilitySlot)
			if ability ~= nil then 
				local abilityLevel = ability:GetLevel()
				local abilityName = ability:GetAbilityName()
				local illusionAbility = illusion:FindAbilityByName(abilityName)
				if illusionAbility then
					illusionAbility:SetLevel(abilityLevel)
				end
			end
		end

		-- Recreate the items of the caster
		for itemSlot=0,5 do
			self:CopyItem(self:GetParent(), illusion, itemSlot)
		end

		-- 15, 16 分别为TP槽位和自然物品槽位
		for itemSlot=15,16 do
			self:CopyItem(self:GetParent(), illusion, itemSlot)
		end




		-- FindClearRandomPositionAroundUnit(illusion, illusion, 25)
		FindClearSpaceForUnit( illusion, spawnPoint + RandomVector(100), false )
		if self:GetParent():HasAbility("spectre_haunt_heal") then
			illusion:AddNewModifier(self:GetParent(), self.ability, "modifier_spectre_haunt_dm_illusion_buff", {duration = duration})
		end
		if self:GetParent():HasAbility("spectre_haunt_dispersion") then
			self.spectre_dispersion = self:GetParent():FindAbilityByName("spectre_dispersion")
			if self.spectre_dispersion and self.spectre_dispersion:GetLevel()>0 then
				illusion:AddNewModifier(self:GetParent(), self.ability, "modifier_spectre_dispersion_lua", {duration = duration})
			end
		end
	end
	
end
function modifier_spectre_haunt_single_fix:CopyItem(caster, illusion, itemSlot)
	local item = caster:GetItemInSlot(itemSlot)
	local item_illusion = illusion:GetItemInSlot(itemSlot)
	if item_illusion then
		item_illusion:RemoveSelf()
	end
	if item ~= nil then
		local itemName = item:GetName()
		
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
			newItem:SetStacksWithOtherOwners(true)
			newItem:SetPurchaser(nil)
			if newItem:RequiresCharges() then
				newItem:SetCurrentCharges(item:GetCurrentCharges())
			end
			if newItem:IsToggle() and item:GetToggleState() then
				newItem:ToggleAbility()
			end
		
	end
	illusion:SetHasInventory(false)
	illusion:SetCanSellItems(false)
end
modifier_spectre_haunt_dm_illusion_buff = class({})


function modifier_spectre_haunt_dm_illusion_buff:IsHidden() return true end
function modifier_spectre_haunt_dm_illusion_buff:IsPurgable() return false end


function modifier_spectre_haunt_dm_illusion_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_spectre_haunt_dm_illusion_buff:GetModifierMoveSpeed_Absolute( params )
    return 550
end

function modifier_spectre_haunt_dm_illusion_buff:OnTakeDamage( params )
	if not IsServer() then return nil end

	local caster = self:GetCaster()
	local parent = self:GetParent()
	local spell = self:GetAbility()
	local Attacker = params.attacker
	local Target = params.unit
	-- local Ability = params.inflictor
	local flDamage = params.damage
	local attacker = params.attacker
	local target = params.attacker
	local damage = params.damage

	if params.unit ~= self:GetParent() or Target == nil then
		-- print("OnTakeDamage: params.unit ~= self:GetParent()")
		return 0
	end
	if params.attacker == params.unit then return end

	local ability = spell
	local unit = parent
	local hero = self:GetCaster()--unit:GetOwnerEntity()
	local attack_damage = damage   --keys.DamageTaken

	
	local illusion_heal_damage =  math.floor(attack_damage * 0.5) 
	local hero_heal_damage = math.floor(attack_damage * 0.5)

	if hero and unit then
		local illusions = FindUnitsInRadius(
				self:GetParent():GetTeamNumber(),
				self:GetParent():GetAbsOrigin(),
				nil,
				9999,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
				FIND_CLOSEST,
				false
			) 
			for _, illusion in pairs(illusions) do	
				if illusion and illusion:IsIllusion() and illusion~=self:GetParent() then
					if illusion:GetName() == "npc_dota_hero_spectre" then
						print("found illusion")
						illusion:Heal(illusion_heal_damage, nil)
					end
				end
			end	
		
		hero:Heal(hero_heal_damage, nil)
		
	end

end

function modifier_spectre_haunt_dm_illusion_buff:OnDestroy()
	if not IsServer() then return nil end
	
	if unit then
		unit:RemoveSelf()
	end
end


modifier_spectre_dispersion_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_dispersion_lua:IsHidden()
	return true
end

function modifier_spectre_dispersion_lua:IsDebuff()
	return false
end

function modifier_spectre_dispersion_lua:IsStunDebuff()
	return false
end

function modifier_spectre_dispersion_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_spectre_dispersion_lua:OnCreated( kv )
	self.parent = self:GetParent()
	self.spectre_dispersion = self:GetCaster():FindAbilityByName("spectre_dispersion")
	-- references
	self.reflect = self.spectre_dispersion:GetSpecialValueFor( "damage_reflection_pct" )
	self.min_radius = self.spectre_dispersion:GetSpecialValueFor( "min_radius" )
	self.max_radius = self.spectre_dispersion:GetSpecialValueFor( "max_radius" )
	self.delta = self.max_radius-self.min_radius

	if not IsServer() then return end
	-- for shard
	self.attacker = {}

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		-- damage = 500,
		-- damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
	}
end

function modifier_spectre_dispersion_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_spectre_dispersion_lua:OnRemoved()
end

function modifier_spectre_dispersion_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_spectre_dispersion_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_spectre_dispersion_lua:GetModifierIncomingDamage_Percentage( params )
	if self.parent:PassivesDisabled() then return 0 end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.max_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- get distance percentage damage
		local distance = (enemy:GetOrigin()-self.parent:GetOrigin()):Length2D()
		local pct = (self.max_radius-distance)/self.delta
		pct = math.min( pct, 1 )

		-- apply damage
		self.damageTable.victim = enemy
		self.damageTable.damage = params.damage * pct * self.reflect/100
		self.damageTable.damage_type = params.damage_type
		ApplyDamage( self.damageTable )

		-- play effects
		self:PlayEffects( enemy )
	end

	return -self.reflect
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_spectre_dispersion_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_spectre/spectre_dispersion.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	-- ParticleManager:SetParticleControl( effect_cast, 1, vControlVector )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end




