undying_tombstone_hunger = class( {} )

LinkLuaModifier( "modifier_undying_tombstone_hunger", "heroes/undying/undying_tombstone_hunger", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function undying_tombstone_hunger:GetIntrinsicModifierName()
	return "modifier_undying_tombstone_hunger"
end
modifier_undying_tombstone_hunger = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_undying_tombstone_hunger:IsHidden()
	return true
end

function modifier_undying_tombstone_hunger:IsPurgeException()
	return false
end

function modifier_undying_tombstone_hunger:IsPurgable()
	return false
end

function modifier_undying_tombstone_hunger:IsPermanent()
	return true
end


function modifier_undying_tombstone_hunger:OnCreated( kv )
	if IsServer() then		
		local aghsfort_special_undying_consume_zombies_dummy = self:GetParent():FindAbilityByName("aghsfort_special_undying_consume_zombies_dummy")
		aghsfort_special_undying_consume_zombies_dummy:SetHidden(false)	
    end
end


