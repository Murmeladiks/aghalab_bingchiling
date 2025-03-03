templar_assassin_refraction_absorption = class( {} )

LinkLuaModifier( "modifier_templar_assassin_refraction_absorption", "heroes/templar_assassin/templar_assassin_refraction_absorption", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function templar_assassin_refraction_absorption:GetIntrinsicModifierName()
	return "modifier_templar_assassin_refraction_absorption"
end

modifier_templar_assassin_refraction_absorption = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_refraction_absorption:IsHidden()
	return true
end

function modifier_templar_assassin_refraction_absorption:IsPurgeException()
	return false
end

function modifier_templar_assassin_refraction_absorption:IsPurgable()
	return false
end

function modifier_templar_assassin_refraction_absorption:IsPermanent()
	return true
end


function modifier_templar_assassin_refraction_absorption:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_refraction_absorption:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end


function  modifier_templar_assassin_refraction_absorption:OnDeath(params)
    if not IsServer() then return end



	if params.attacker ~= self:GetParent()  then
		return
	end


    if self:GetParent():HasModifier("modifier_templar_assassin_refraction_absorb") then
        local buff =self:GetParent():FindModifierByName("modifier_templar_assassin_refraction_absorb")

        if buff then
            buff:SetStackCount(buff:GetStackCount()+1)
        end
    end



   
    
		
	

    

end