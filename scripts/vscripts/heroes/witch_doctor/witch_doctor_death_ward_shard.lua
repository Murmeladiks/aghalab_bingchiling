witch_doctor_death_ward_shard = class( {} )

LinkLuaModifier( "modifier_witch_doctor_death_ward_shard", "heroes/witch_doctor/witch_doctor_death_ward_shard", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function witch_doctor_death_ward_shard:GetIntrinsicModifierName()
	return "modifier_witch_doctor_death_ward_shard"
end

modifier_witch_doctor_death_ward_shard = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_death_ward_shard:IsHidden()
	return true
end

function modifier_witch_doctor_death_ward_shard:IsPurgeException()
	return false
end

function modifier_witch_doctor_death_ward_shard:IsPurgable()
	return false
end

function modifier_witch_doctor_death_ward_shard:IsPermanent()
	return true
end



function modifier_witch_doctor_death_ward_shard:OnCreated(kv)
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
