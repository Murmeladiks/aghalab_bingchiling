razor_static_link_shard = class( {} )

LinkLuaModifier( "modifier_razor_static_link_shard", "heroes/razor/razor_static_link_shard", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function razor_static_link_shard:GetIntrinsicModifierName()
	return "modifier_razor_static_link_shard"
end

modifier_razor_static_link_shard = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_static_link_shard:IsHidden()
	return true
end

function modifier_razor_static_link_shard:IsPurgeException()
	return false
end

function modifier_razor_static_link_shard:IsPurgable()
	return false
end

function modifier_razor_static_link_shard:IsPermanent()
	return true
end



function modifier_razor_static_link_shard:OnCreated(kv)
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
function modifier_razor_static_link_shard:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function  modifier_razor_static_link_shard:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "razor_static_link" then
        return
    end
	if params.target and not params.target:IsNull() and params.target:IsAlive() then
		local duration = params.ability:GetSpecialValueFor("drain_duration")*2
		for i = 1, duration, 1 do
			Timers:CreateTimer(i*1.0, function()
				if(self and not self:IsNull()) then
					if params.target and not params.target:IsNull() and params.target:IsAlive() then
						params.target:AddNewModifier(self:GetParent(),params.ability,"modifier_stunned",{duration=0.15})
					end
				end
			end)
		end
		
		
		
	end

end