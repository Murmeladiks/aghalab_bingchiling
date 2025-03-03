-- CDOTA_BaseNPC -----------------------------------------------------------------
function CDOTA_BaseNPC:GetIllusionParent()
	local modifier_illusion = self:FindModifierByName("modifier_illusion")
	if modifier_illusion then
		return modifier_illusion:GetCaster()
	end

    return nil
end

function CDOTA_BaseNPC:HasLearnedTalent(talentName)
	if self:FindAbilityByName(talentName) and self:FindAbilityByName(talentName):GetLevel() > 0 then
		return true
	end

	return false
end



function CDOTA_BaseNPC:HasUnitItemInInventoryOrBackpack_SB2023(itemName)
	local LAST_BACK_PACK_ITEM_SLOT = 8

	if not self:HasInventory() then
		return false
	end

	for itemSlot = 0, LAST_BACK_PACK_ITEM_SLOT, 1 do
        local item = self:GetItemInSlot( itemSlot )
        if item and not item:IsMuted() and item:GetAbilityName() == itemName then
			return true
		end
	end

	return false
end

function CDOTA_BaseNPC:IsItemInStash_SB2023(itemToVerify)
	if not self:HasInventory() then
		return false
	end

	if not itemToVerify or itemToVerify:IsNull() then
		return false
	end

	for itemSlot = DOTA_ITEM_STASH_MIN, DOTA_ITEM_STASH_MAX, 1 do
        local item = self:GetItemInSlot( itemSlot )
        if item and item == itemToVerify then
			return true
		end
	end

	return false
end

function CDOTA_BaseNPC:_IsMonkeyKingArmyClone()
	if self.monkeyArmyCloneDetected then
		return true
	end

	if self:GetUnitName() == "npc_dota_hero_monkey_king" then
		if GameRules.Aghanim.realMonkeyKingPlayerEntIndex and self:entindex() ~= GameRules.Aghanim.realMonkeyKingPlayerEntIndex then
			self.monkeyArmyCloneDetected  = true
			return true
		end

		if (self:HasModifier("modifier_monkey_king_fur_army_soldier") or 
			self:HasModifier("modifier_monkey_king_fur_army_soldier_inactive") or
			self:HasModifier("modifier_monkey_king_fur_army_soldier_hidden"))
			
		then

			self.monkeyArmyCloneDetected = true
			return true
		end
	end

	return false
end

function CDOTA_BaseNPC:_IsMeepoClone()
	if self.meepoCloneDetected then
		return true
	end

	if self:GetUnitName() == "npc_dota_hero_meepo" then
		if GameRules.Aghanim.realMeepoPlayerEntIndex and self:entindex() ~= GameRules.Aghanim.realMeepoPlayerEntIndex then
			self.meepoCloneDetected  = true
			return true
		end

		if self:IsClone() then
			self.meepoCloneDetected = true
			return true
		end
	end

	return false
end

function CDOTA_BaseNPC:_IsUnitOnTreeDance()
	local modifier = self:HasModifier("modifier_monkey_king_tree_dance_activity")
	local modifier2 = self:HasModifier("modifier_monkey_king_tree_dance_hidden")

	if modifier or modifier2 then
		return true
	end

	return false
end

function CDOTA_BaseNPC:_IsUnitJumpingOnTree()
	local modifier1 = self:HasModifier("modifier_monkey_king_bounce_perch")
	local modifier2 = self:HasModifier("modifier_monkey_king_bounce_leap")

	if modifier1 or modifier2  then
		return true
	end

	return false
end

function CDOTA_BaseNPC:_HasHeroAghanimShard()
    return self:HasModifier("modifier_item_aghanims_shard")
end

function CDOTA_BaseNPC:_IsPlayerAFK_SB2023()
	if not self:IsRealHero() then
		return false
	end

	local playerID = self:GetPlayerID()
	local afkPlayersList = GameRules.Aghanim.checkForAFKPlayers

	if not playerID or not afkPlayersList or not afkPlayersList[playerID] then
		return false
	end

	return afkPlayersList[playerID]
end

function CDOTA_BaseNPC:_IsPlayerLongAFK_SB2023()
	if not self:IsRealHero() then
		return false
	end

	local playerID = self:GetPlayerID()
	local afkPlayersList = GameRules.Aghanim.checkForLongAFKPlayers

	if not playerID or not afkPlayersList or not afkPlayersList[playerID] then
		return false
	end

	return true
end

function CDOTA_BaseNPC:_HasAppliedState_SB2023(state)
	local buffs = self:FindAllModifiers()

	for _,buff in pairs( buffs ) do
		if buff ~= nil and buff then
			local states = {}
			buff:CheckStateToTable(states)

			local activeStates = {}
			for key, value in pairs(states) do
				if value == true then
					local string = tostring(key)
					activeStates[string] = true
				end
			end

			--Check state
			if activeStates[tostring(state)]then
				return true
			end
		end
	end

	return false
end

--in Siltbreaker neutral items are shareable, so player can have more than one from each tier
function CDOTA_BaseNPC:GetAllOwnNeutralItems_SB2023()
	--this table is updated in token item
	if not self.ownNeutralItems then
		self.ownNeutralItems = {}
	end

	local result = {}

	for _, itemNames in pairs(self.ownNeutralItems) do
		for _, itemName in pairs(itemNames) do
			if itemName and itemName ~= "" then
				table.insert(result, itemName)
			end
		end
	end

	return result
end

function CDOTA_BaseNPC:GetOwnNeutralItemsByTiers_SB2023()
	--this table is updated in token item
	if not self.ownNeutralItems then
		self.ownNeutralItems = {}
	end

	return self.ownNeutralItems
end

--update table (in Siltbreaker neutral items are shareable, so player can have more than one from each tier)
function CDOTA_BaseNPC:UpdateOwnNeutralItems_SB2023()
	local item = self:GetItemInSlot( DOTA_ITEM_NEUTRAL_SLOT )
	if item and not item.isNeutralToken and item:IsNeutralDrop() and item:GetPurchaser() == self then
		self:AddOwnNeutralItem_SB2023(item)
	end
end

function CDOTA_BaseNPC:AddOwnNeutralItem_SB2023(item, tokenTier)
	if not self.ownNeutralItems then
		self.ownNeutralItems = {}
	end

	local itemName = item:GetAbilityName()
		
	if not tokenTier or not tonumber(tokenTier) or tokenTier == 0 then
		local ItemData = LoadKeyValues( "scripts/npc/neutral_items.txt" )
		if ItemData ~= nil then
			for tier, tierData in pairs( ItemData ) do
				if tierData["items"] then
	
					for neutralName, _ in pairs(tierData["items"]) do
						if neutralName == itemName then
							tokenTier = tier
							
							break
						end
					end
				end
			end
		end
	end

	if itemName == "item_recipe_trident" then
		itemName = "item_trident"
	end

	if tokenTier and tonumber(tokenTier) then
		if not self.ownNeutralItems[tonumber(tokenTier)] then
			self.ownNeutralItems[tonumber(tokenTier)] = {}
		end
		
		table.insert(self.ownNeutralItems[tonumber(tokenTier)], itemName)
	end
end

--remove this when valve fix ForceKill() will trigger entity_killed event
function CDOTA_BaseNPC:ForceKill_SB_2023(bReincarnate)
	if not self.entityKilledEventFired then
		FireGameEvent("entity_killed",
			{
				entindex_killed = self:entindex(),
				entindex_attacker = self:entindex(),
				entindex_inflictor = nil,
			}
		)
	end

	self.entityKilledEventFired = true

	self:ForceKill(bReincarnate)
end

------------------------------------------------------------------ CDOTA_BaseNPC --

-- CDOTABaseAbility -----------------------------------------------------------------
function CDOTABaseAbility:_IsNeutralItem_Aghanim_2023()
	if not self or self:IsNull() then
		return false
	end

    if not self:IsItem() then
        return false
    end

    local itemKV = self:GetAbilityKeyValues()
    if itemKV and itemKV["ItemIsNeutralDrop"] and itemKV["ItemIsNeutralDrop"] == "1" then
        print("neutral: ", itemKV["ItemIsNeutralDrop"])
        return true
    end

    return false
end

function CDOTABaseAbility:_GetAbilityRealCastRange_SB2023(pos)
	if not self or self:IsNull() then
		return 0
	end

	local CastRangeValueName = {
		faceless_void_time_walk = "range",
		mirana_leap = "leap_distance",
		void_spirit_astral_step = "max_travel_distance",
		mars_gods_rebuke = "radius",
        primal_beast_onslaught = "max_distance",
	
		--items
		item_havoc_hammer = "range",
	}
	
	local AghanimShardRangeBuff = {
		faceless_void_time_walk = 150
	}
	
	local ItemsRangeBuff = {
		item_aether_lens = 225
	}
	
	local abilityRange = self:GetEffectiveCastRange(pos, nil) or 0

	if CastRangeValueName[self:GetAbilityName()] then
		abilityRange = self:GetSpecialValueFor(CastRangeValueName[self:GetAbilityName()])

		if self:GetCaster() then
			if AghanimShardRangeBuff[self:GetAbilityName()] and self:GetCaster():_HasHeroAghanimShard() then
				abilityRange = abilityRange + AghanimShardRangeBuff[self:GetAbilityName()]
			end

			if  ItemsRangeBuff["item_aether_lens"] and self:GetCaster():HasItemInInventory("item_aether_lens") then
				abilityRange = abilityRange + ItemsRangeBuff["item_aether_lens"]
			end
		end
	end

	return abilityRange
end

function CDOTABaseAbility:_ShowAbilityExtraInfo_SB2023()
	if not self:GetCaster() then
		return
	end

	local requiresHeroLevel = 1

	if self:IsItem() then
		if self.bIsRelic and self.bIsRelic == true then
			requiresHeroLevel = self:GetSpecialValueFor("required_level")
		end
	end

	local abilityInfo = {
		ability_name = self:GetAbilityName(),
		ability_entindex = self:entindex(),
		requires_hero_level = requiresHeroLevel
	}
	
	CustomGameEventManager:Send_ServerToPlayer(self:GetCaster():GetPlayerOwner(), "player_extra_info", abilityInfo )
end

------------------------------------------------------------------ CDOTABaseAbility --

-- CDOTA_Item  -----------------------------------------------------------------------
function CDOTA_Item:ChangeItemCurrentCharges(chargeCount)
	if not chargeCount or not tonumber(chargeCount) then
		self:SetCurrentCharges(0)
	else
		self:SetCurrentCharges(self:GetCurrentCharges() + chargeCount)
	end

	if self:GetCurrentCharges() <= 0 then
		self:RemoveSelf_Aghanim2024()
	end
end

function CDOTA_Item:RemoveSelf_Aghanim2024()
	if self:GetContainer() then
		UTIL_Remove(self:GetContainer())
	end

	self:RemoveSelf()
end

function CDOTA_Item:SetLifeTime_Aghanim2024(duration, useParticles)
	if self.destroyItemTime then
		self.previousDestroyItemTime = self.destroyItemTime
	end

	self.useParticles = useParticles or false
	self.destroyItemTime = GameRules:GetGameTime() + duration

	if not self.previousDestroyItemTime or self.previousDestroyItemTime ~= self.destroyItemTime then
		self:SetContextThink(DoUniqueString("item_life_time"), function()
			if self and not self:IsNull() then

				--use some safety buffer (0.1s)?
				--function runs with duration delay anyway but checking the time will avoid some delays in program(if possible?)
				if GameRules:GetGameTime() >= self.destroyItemTime - 0.1  and GameRules:GetGameTime() <= self.destroyItemTime + 0.1 then
					if self.useParticles then
						local container = self:GetContainer()
						
						if container and not container:IsNull() then
							local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, container)
							ParticleManager:SetParticleControl( nFXIndex, 0, container:GetAbsOrigin() )
							ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
							ParticleManager:ReleaseParticleIndex( nFXIndex )
						end
					end
	
					self:RemoveSelf_Aghanim2024()
				end
			end
		end, duration)
	end
end
------------------------------------------------------------------ CDOTA_Item --