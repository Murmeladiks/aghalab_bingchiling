templar_assassin_meld_step = class( {} )

LinkLuaModifier( "modifier_templar_assassin_meld_step", "heroes/templar_assassin/templar_assassin_meld_step", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function templar_assassin_meld_step:GetIntrinsicModifierName()
	return "modifier_templar_assassin_meld_step"
end

modifier_templar_assassin_meld_step = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_meld_step:IsHidden()
	return true
end

function modifier_templar_assassin_meld_step:IsPurgeException()
	return false
end

function modifier_templar_assassin_meld_step:IsPurgable()
	return false
end

function modifier_templar_assassin_meld_step:IsPermanent()
	return true
end


function modifier_templar_assassin_meld_step:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_meld_step:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_templar_assassin_meld_step:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "templar_assassin_meld" then
        local pos = self:GetParent():GetAbsOrigin() + 600*self:GetParent():GetForwardVector()
        FindClearSpaceForUnit(self:GetParent(), pos, false)   
    end
     
  
   
    
		
	

    

end