special_bonus_unique_snapfire_firesnap_cookie_enemy = class( {} )

LinkLuaModifier( "modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy", "heroes/snapfire/special_bonus_unique_snapfire_firesnap_cookie_enemy", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function special_bonus_unique_snapfire_firesnap_cookie_enemy:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy"
end

modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy:IsHidden()
	return true
end

function modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy:IsPurgeException()
	return false
end

function modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy:IsPurgable()
	return false
end

function modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy:IsPermanent()
	return true
end



function modifier_special_bonus_unique_snapfire_firesnap_cookie_enemy:OnCreated(kv)
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
