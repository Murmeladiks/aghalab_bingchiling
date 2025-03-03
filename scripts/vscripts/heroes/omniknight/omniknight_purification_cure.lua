omniknight_purification_cure = class( {} )

LinkLuaModifier( "modifier_omniknight_purification_cure", "heroes/omniknight/omniknight_purification_cure", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function omniknight_purification_cure:GetIntrinsicModifierName()
	return "modifier_omniknight_purification_cure"
end

modifier_omniknight_purification_cure = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_purification_cure:IsHidden()
	return true
end

function modifier_omniknight_purification_cure:IsPurgeException()
	return false
end

function modifier_omniknight_purification_cure:IsPurgable()
	return false
end

function modifier_omniknight_purification_cure:IsPermanent()
	return true
end


function modifier_omniknight_purification_cure:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_purification_cure:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_omniknight_purification_cure:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "omniknight_purification" then
        self.omniknight_purification = params.unit:FindAbilityByName("omniknight_purification")
        if  RollPseudoRandomPercentage(50, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
            Timers:CreateTimer(0.1, function()
            self:GetParent():SetCursorCastTarget(params.target)
            self.omniknight_purification:OnSpellStart()
            end)
           
        end
    end
     
  
   
    
		
	

    

end