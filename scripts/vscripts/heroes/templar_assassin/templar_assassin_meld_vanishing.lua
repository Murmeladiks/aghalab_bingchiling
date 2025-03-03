templar_assassin_meld_vanishing = class( {} )

LinkLuaModifier( "modifier_templar_assassin_meld_vanishing", "heroes/templar_assassin/templar_assassin_meld_vanishing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function templar_assassin_meld_vanishing:GetIntrinsicModifierName()
	return "modifier_templar_assassin_meld_vanishing"
end

modifier_templar_assassin_meld_vanishing = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_templar_assassin_meld_vanishing:IsHidden()
	return true
end

function modifier_templar_assassin_meld_vanishing:IsPurgeException()
	return false
end

function modifier_templar_assassin_meld_vanishing:IsPurgable()
	return false
end

function modifier_templar_assassin_meld_vanishing:IsPermanent()
	return true
end


function modifier_templar_assassin_meld_vanishing:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_templar_assassin_meld_vanishing:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end


function  modifier_templar_assassin_meld_vanishing:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "templar_assassin_meld" then
      local radius = 300
      local enemies = FindUnitsInRadius( 
        self:GetParent():GetTeamNumber(), 
        self:GetParent():GetAbsOrigin(), 
        nil, 
        radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, 
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
        0, 
        false )
        for _,enemy in pairs( enemies ) do
            if enemy then
                self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, true)
            end
        end
    end
     
  
   
    
		
	

    

end