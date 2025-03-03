alchemist_berserk_potion_shard = class( {} )

LinkLuaModifier( "modifier_alchemist_berserk_potion_shard", "heroes/alchemist/alchemist_berserk_potion_shard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_berserk_potion_shard_randombuff_hero", "heroes/alchemist/alchemist_berserk_potion_shard", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function alchemist_berserk_potion_shard:GetIntrinsicModifierName()
	return "modifier_alchemist_berserk_potion_shard"
end

modifier_alchemist_berserk_potion_shard = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_alchemist_berserk_potion_shard:IsHidden()
	return true
end

function modifier_alchemist_berserk_potion_shard:IsPurgeException()
	return false
end

function modifier_alchemist_berserk_potion_shard:IsPurgable()
	return false
end

function modifier_alchemist_berserk_potion_shard:IsPermanent()
	return true
end



function modifier_alchemist_berserk_potion_shard:OnCreated(kv)
    if IsServer() then

		local firstitem = self:GetCaster():GetItemInSlot(0)
		if firstitem then
			--print(firstitem:GetName())
			local removeditem = self:GetCaster():TakeItem(firstitem)
			--print(removeditem:GetName())
			local item = CreateItem( "item_aghanims_shard", self:GetCaster(), self:GetCaster() )
			--如果身上没格子 直接加添加魔晶会失效
			--使用置换的方式添加魔晶
			--添加魔晶后给不能直接添加移除的物品
			if item then
				item:SetPurchaseTime( 0 )
				item:SetPurchaser( self:GetCaster() )
				self:GetCaster():AddItem( item )
				
				Timers:CreateTimer(0.1, function()
					if(self and not self:IsNull()) then
						self:GetCaster():AddItemByName(firstitem:GetName())
					end
				end)
				
			end
		else
			local item = CreateItem( "item_aghanims_shard", self:GetCaster(), self:GetCaster() )
			item:SetPurchaseTime( 0 )
			item:SetPurchaser( self:GetCaster() )
			self:GetCaster():AddItem( item )
		end
    end
end
function modifier_alchemist_berserk_potion_shard:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_alchemist_berserk_potion_shard:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    if not params.target then return end

    if params.ability:GetAbilityName() == "alchemist_berserk_potion" then
		math.randomseed(Time())
		local goldremain  = self:GetCaster():GetGold()
		local gold = math.random(0,99)
		if gold< goldremain then
			self:GetCaster():SpendGold(gold, DOTA_ModifyGold_AbilityCost)
			EmitGlobalSound("General.Sell")
			--if params.target:GetTeamName() == self:GetParent():GetTeamName() then
				if not params.target:HasModifier("modifier_alchemist_berserk_potion_shard_randombuff_hero") then
					params.target:AddNewModifier(self:GetParent(), params.ability, "modifier_alchemist_berserk_potion_shard_randombuff_hero", {})
				else
					local buff = params.target:FindModifierByName("modifier_alchemist_berserk_potion_shard_randombuff_hero")
					if buff then
						buff:updatebuff()
					end
				end
			--else
				--params.target:AddNewModifier(self:GetParent(), params.ability, "modifier_alchemist_berserk_potion_shard_randombuff_creep", {})
			--end
		else
			self:GetCaster():EmitSound("General.NoGold")
			return
		end
    end
end

modifier_alchemist_berserk_potion_shard_randombuff_hero = class({})

function modifier_alchemist_berserk_potion_shard_randombuff_hero:IsHidden()
	return false
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:IsPurgeException()
	return false
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:IsPurgable()
	return false
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:IsPermanent()
	return true
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA + 1
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:OnCreated(kv)
    

    if IsServer() then
      --初始化BUFF的基础数值
	  self.bonus_damage = 0
	  self.armor = 0
	  self.magical_resistance = 0
	 
	  self.casttime = 0
	  
	  self.manacost = 0
	  self.attackspeed = 0
	  self.evasion = 0
	  
	  self.healthregen = 0
	  self.manaregen = 0
	  
	  self.extrahealth = 0
	  self.extramana = 0
	  
	  self.spellamplify = 0
	  
	  self.cooldown = 0
	 
	  self.str = 0
	  self.int = 0
	  self.agi =0
	  
	--随机选定一个buff
	local buffs = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
	}
	math.randomseed(Time())
	local randomIndex = math.random(1, #buffs)
	local buff = buffs[randomIndex]
	print(buff)
	--随机选定正负值
	local randomint = math.random(1, 5)
		if randomint > 3 then 
			if buff == 1 then
				self.bonus_damage = -1
			end
			if buff == 2 then
				self.armor = -1
			end
			if buff == 3 then
				self.magical_resistance =  -1
			end
			if buff == 4 then
				self.casttime = -1
			end
			if buff == 5 then
				self.manacost = -1
			end
			if buff == 6 then
				self.attackspeed = -1
			end
			if buff == 7 then
				self.evasion = -1
			end
			if buff == 8 then
				self.healthregen = -1
			end
			if buff == 9 then
				self.self.manaregen = -1
			end
			if buff == 10 then
				self.extrahealth = -10
			end
			if buff == 11 then
				self.extramana = -5
			end
			if buff == 12 then
				self.spellamplify = -1
			end
			if buff == 13 then
				self.cooldown = -1
			end
			if buff == 14 then
				self.str = -1
			end
			if buff == 15 then
				self.int = -1
			end
			if buff == 15 then
				self.agi = -1
			end
		else	
			if buff == 1 then
				self.bonus_damage = 1
			end
			if buff == 2 then
				self.armor = 1
			end
			if buff == 3 then
				self.magical_resistance =  1
			end
			if buff == 4 then
				self.casttime = 1
			end
			if buff == 5 then
				self.manacost = 1
			end
			if buff == 6 then
				self.attackspeed = 1
			end
			if buff == 7 then
				self.evasion = 1
			end
			if buff == 8 then
				self.healthregen = 1
			end
			if buff == 9 then
				self.self.manaregen = 1
			end
			if buff == 10 then
				self.extrahealth = 10
			end
			if buff == 11 then
				self.extramana = 5
			end
			if buff == 12 then
				self.spellamplify = 1
			end
			if buff == 13 then
				self.cooldown = 1
			end
			if buff == 14 then
				self.str = 1
			end
			if buff == 15 then
				self.int = 1
			end
			if buff == 15 then
				self.agi = 1
			end
			
			
			
		end
		self:SetHasCustomTransmitterData(true)
    end

  
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:updatebuff()
	if IsServer() then
	local buffs = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
	}
	local randomIndex = math.random(1, #buffs)
	local buff = buffs[randomIndex]
	print(buff)
	local randomint = math.random(1, 5)
--随机选定正负值
	if randomint > 3 then 
		if buff == 1 then
			self.bonus_damage = self.bonus_damage -1
		end
		if buff == 2 then
			self.armor = self.armor -1
		end
		if buff == 3 then
			self.magical_resistance = self.magical_resistance -1
		end
		if buff == 4 then
			self.casttime = self.casttime-1
		end
		if buff == 5 then
			self.manacost = self.manacost-1
		end
		if buff == 6 then
			self.attackspeed = self.attackspeed-1
		end
		if buff == 7 then
			self.evasion = self.evasion-1
		end
		if buff == 8 then
			self.healthregen = self.healthregen-1
		end
		if buff == 9 then
			self.manaregen = self.manaregen-1
		end
		if buff == 10 then
			self.extrahealth = self.extrahealth-10
		end
		if buff == 11 then
			self.extramana = self.extramana-5
		end
		if buff == 12 then
			self.spellamplify = self.spellamplify-1
		end
		if buff == 13 then
			self.cooldown = self.cooldown-1
		end
		if buff == 14 then
			self.str = self.str-1
		end
		if buff == 15 then
			self.int = self.int-1
		end
		if buff == 15 then
			self.agi = self.agi-1
		end
		
		
	else
		if buff == 1 then
			self.bonus_damage = self.bonus_damage +1
		end
		if buff == 2 then
			self.armor = self.armor +1
		end
		if buff == 3 then
			self.magical_resistance = self.magical_resistance +1
		end
		if buff == 4 then
			self.casttime = self.casttime+1
		end
		if buff == 5 then
			self.manacost = self.manacost+1
		end
		if buff == 6 then
			self.attackspeed = self.attackspeed+1
		end
		if buff == 7 then
			self.evasion = self.evasion+1
		end
		if buff == 8 then
			self.healthregen = self.healthregen+1
		end
		if buff == 9 then
			self.manaregen = self.manaregen+1
		end
		if buff == 10 then
			self.extrahealth = self.extrahealth+10
		end
		if buff == 11 then
			self.extramana = self.extramana+5
		end
		if buff == 12 then
			self.spellamplify = self.spellamplify+1
		end
		if buff == 13 then
			self.cooldown = self.cooldown+1
		end
		if buff == 14 then
			self.str = self.str+1
		end
		if buff == 15 then
			self.int = self.int+1
		end
		if buff == 15 then
			self.agi = self.agi+1
		end
	end
end
	self:ForceRefresh()
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:OnRefresh()
	if IsServer() then
		self:SendBuffRefreshToClients()
	end
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:AddCustomTransmitterData()
    return {
       
		bonus_damage = self.bonus_damage,
		armor = self.armor,
		magical_resistance=self.magical_resistance ,
		casttime=self.casttime ,
		manacost=self.manacost ,
		attackspeed=self.attackspeed ,
		evasion=self.evasion ,
		healthregen=self.healthregen ,
		manaregen=self.manaregen ,
		extrahealth=self.extrahealth ,
		extramana=self.extramana ,
		spellamplify=self.spellamplify ,
		cooldown=self.cooldown,
		str=self.str ,
		int=self.int ,
		agi=self.agi ,
    }
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:HandleCustomTransmitterData( data )
    self.bonus_damage = data.bonus_damage
	  self.armor = data.armor
	  self.magical_resistance = data.magical_resistance
	  self.casttime = data.casttime
	  self.manacost = data.manacost
	  self.attackspeed = data.attackspeed
	  self.evasion = data.evasion
	  self.healthregen = data.healthregen
	  self.manaregen = data.manaregen
	  self.extrahealth = data.extrahealth
	  self.extramana = data.extramana
	  self.spellamplify = data.spellamplify
	  self.cooldown = data.cooldown
	  self.str = data.str
	  self.int = data.int
	  self.agi =data.agi
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
        MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
        MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,

    }

end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierPreAttack_BonusDamage(params)
    return self.bonus_damage*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierPhysicalArmorBonus(params)
    return self.armor*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierAttackSpeedBonus_Constant(params)
    return self.attackspeed*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierSpellAmplify_Percentage(params)
    return self.spellamplify*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierExtraHealthBonus(params)
    return self.extrahealth*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierEvasion_Constant(params)
    return self.evasion*self:GetCaster():GetLevel()
end
function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierConstantHealthRegen(params)
    return self.healthregen*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierConstantManaRegen(params)
    return self.manaregen*self:GetCaster():GetLevel()
end


function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierMagicalResistanceBonus( params )
    return self.magical_resistance*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierPercentageCasttime( params )
    return self.casttime*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierPercentageManacostStacking( params )
    return self.manacost*self:GetCaster():GetLevel()
end



function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierExtraManaBonus(params)
    return self.extramana*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierBonusStats_Strength(params) 
    return self.str*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierBonusStats_Agility(params)
    return self.agi*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierBonusStats_Intellect(params)
    return self.int*self:GetCaster():GetLevel()
end

function modifier_alchemist_berserk_potion_shard_randombuff_hero:GetModifierPercentageCooldown( params )
    return self.cooldown*self:GetCaster():GetLevel()
end
