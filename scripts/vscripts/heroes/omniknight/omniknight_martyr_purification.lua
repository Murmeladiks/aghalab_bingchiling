omniknight_martyr_purification = class( {} )

LinkLuaModifier( "modifier_omniknight_martyr_purification", "heroes/omniknight/omniknight_martyr_purification", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function omniknight_martyr_purification:GetIntrinsicModifierName()
	return "modifier_omniknight_martyr_purification"
end

modifier_omniknight_martyr_purification = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_martyr_purification:IsHidden()
	return true
end

function modifier_omniknight_martyr_purification:IsPurgeException()
	return false
end

function modifier_omniknight_martyr_purification:IsPurgable()
	return false
end

function modifier_omniknight_martyr_purification:IsPermanent()
	return true
end


function modifier_omniknight_martyr_purification:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_omniknight_martyr_purification:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function  modifier_omniknight_martyr_purification:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "omniknight_martyr" then
        self.omniknight_purification = params.unit:FindAbilityByName("omniknight_purification")
        if self.omniknight_purification and self.omniknight_purification:GetLevel()>0  then
            
            self:GetParent():SetCursorCastTarget(params.target)
            self.omniknight_purification:OnSpellStart()
            if self:GetParent():HasAbility("omniknight_purification_cure") then
                if  RollPseudoRandomPercentage(50, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                    Timers:CreateTimer(0.1, function()
                        self:GetParent():SetCursorCastTarget(params.target)
                        self.omniknight_purification:OnSpellStart()
                    end)
                
                end
            end
        end
    end
     
  
   
    
		
	

    

end