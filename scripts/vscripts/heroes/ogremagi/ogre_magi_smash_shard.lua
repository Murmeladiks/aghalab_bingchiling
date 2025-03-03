ogre_magi_smash_shard = class( {} )

LinkLuaModifier( "modifier_ogre_magi_smash_shard", "heroes/ogremagi/ogre_magi_smash_shard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_smash_shard_buff", "heroes/ogremagi/ogre_magi_smash_shard", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ogre_magi_smash_shard:GetIntrinsicModifierName()
	return "modifier_ogre_magi_smash_shard"
end
function ogre_magi_smash_shard:OnSpellStart()
	self.ogre_magi_smash = self:GetCaster():FindAbilityByName("ogre_magi_smash")
    local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local projectile_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf"
	local projectile_speed = 1400
	local projectile_vision = 200
    local info = {
		Target = target,
		Source = caster,
		Ability = self.ogre_magi_smash,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
		ExtraData = {
			
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- Play effects
	local sound_cast = "Hero_OgreMagi.FireShield.Cast"
	EmitSoundOn( sound_cast, caster )
end
modifier_ogre_magi_smash_shard = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_smash_shard:IsHidden()
	return true
end

function modifier_ogre_magi_smash_shard:IsPurgeException()
	return false
end

function modifier_ogre_magi_smash_shard:IsPurgable()
	return false
end

function modifier_ogre_magi_smash_shard:IsPermanent()
	return true
end
function modifier_ogre_magi_smash_shard:OnCreated(kv)
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
function modifier_ogre_magi_smash_shard:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function  modifier_ogre_magi_smash_shard:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker == self:GetParent() then
        if params.inflictor and params.inflictor:GetAbilityName() == "ogre_magi_smash" then
			self.ogre_magi_fireblast =self:GetParent():FindAbilityByName("ogre_magi_fireblast")
	
			if self.ogre_magi_fireblast and self.ogre_magi_fireblast:GetLevel()>0 then
				self:GetParent():SetCursorCastTarget(params.unit)
				self.ogre_magi_fireblast:OnSpellStart()
			end
		end
    end
    
        
   
    

end
function  modifier_ogre_magi_smash_shard:OnAttackLanded(params)
    if IsServer() then
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then return end
		if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
		if params.attacker:IsOther() or params.attacker:IsBuilding() then return end

		-- roll dice
		if params.target:HasModifier("modifier_ogre_magi_smash_buff")  then
			local buff = params.target:FindModifierByName("modifier_ogre_magi_smash_buff")
			self.ability= self:GetAbility()
			self:GetParent():SetCursorCastTarget(params.attacker)
			self.ability:OnSpellStart()
			if buff:GetStackCount()> 1 then
				buff:SetStackCount(buff:GetStackCount()-1)
			elseif buff:GetStackCount() == 1 then
				params.target:RemoveModifierByName("modifier_ogre_magi_smash_buff")
				local buff = params.target:FindModifierByName("modifier_ogre_magi_smash_shard_buff")
				if buff then
					params.target:RemoveModifierByName("modifier_ogre_magi_smash_shard_buff")
				end
			end	
			
        end
        
	
	end
		
	

    

end


function modifier_ogre_magi_smash_shard:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "ogre_magi_smash" then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("ogre_magi_smash")
    local duration = self.ability:GetSpecialValueFor("duration")
	if params.target then
		params.target:AddNewModifier(self:GetParent(),self.ability,"modifier_ogre_magi_smash_shard_buff",{duration = duration})
	end
        
end
modifier_ogre_magi_smash_shard_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_smash_shard_buff:IsHidden()
	return true
end

function modifier_ogre_magi_smash_shard_buff:IsPurgeException()
	return false
end

function modifier_ogre_magi_smash_shard_buff:IsPurgable()
	return false
end

function modifier_ogre_magi_smash_shard_buff:IsPermanent()
	return false
end
function modifier_ogre_magi_smash_shard_buff:OnCreated(kv)
    if IsServer() then	
    end
end
function modifier_ogre_magi_smash_shard_buff:DeclareFunctions()
    local funcs =
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end
function modifier_ogre_magi_smash_shard_buff:GetModifierIncomingDamage_Percentage(params)
    return -85
end