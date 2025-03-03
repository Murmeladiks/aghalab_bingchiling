tusk_ice_shards_icebreaker = class( {} )

LinkLuaModifier( "modifier_tusk_ice_shards_icebreaker", "heroes/tusk/tusk_ice_shards_icebreaker", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function tusk_ice_shards_icebreaker:GetIntrinsicModifierName()
	return "modifier_tusk_ice_shards_icebreaker"
end

modifier_tusk_ice_shards_icebreaker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tusk_ice_shards_icebreaker:IsHidden()
	return true
end

function modifier_tusk_ice_shards_icebreaker:IsPurgeException()
	return false
end

function modifier_tusk_ice_shards_icebreaker:IsPurgable()
	return false
end

function modifier_tusk_ice_shards_icebreaker:IsPermanent()
	return true
end



function modifier_tusk_ice_shards_icebreaker:OnCreated(kv)
    if IsServer() then

		local item = CreateItem( "item_aghanims_shard", self:GetCaster(), self:GetCaster() )

		if item then
			item:SetPurchaseTime( 0 )
			item:SetPurchaser( self:GetCaster() )
			self:GetCaster():AddItem( item )
		end
    end
end
