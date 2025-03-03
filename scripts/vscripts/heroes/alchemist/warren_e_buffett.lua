warren_e_buffett = class( {} )

LinkLuaModifier( "modifier_warren_e_buffett", "heroes/alchemist/warren_e_buffett", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function warren_e_buffett:GetIntrinsicModifierName()
	return "modifier_warren_e_buffett"
end
modifier_warren_e_buffett = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_warren_e_buffett:IsHidden()
	return true
end

function modifier_warren_e_buffett:IsPurgeException()
	return false
end

function modifier_warren_e_buffett:IsPurgable()
	return false
end

function modifier_warren_e_buffett:IsPermanent()
	return true
end


function modifier_warren_e_buffett:OnCreated( kv )
	if IsServer() then		
		local alchemist_the_buffett  = self:GetCaster():FindAbilityByName("alchemist_the_buffett")
		alchemist_the_buffett:SetHidden(false)	
    end
end


