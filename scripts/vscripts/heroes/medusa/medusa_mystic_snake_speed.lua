medusa_mystic_snake_speed= class( {} )

LinkLuaModifier( "modifier_medusa_mystic_snake_speed", "heroes/medusa/medusa_mystic_snake_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_mystic_snake_speed_buff", "heroes/medusa/medusa_mystic_snake_speed", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function medusa_mystic_snake_speed:GetIntrinsicModifierName()
	return "modifier_medusa_mystic_snake_speed"
end



modifier_medusa_mystic_snake_speed= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_mystic_snake_speed:IsHidden()
	return true
end

function modifier_medusa_mystic_snake_speed:IsPurgeException()
	return false
end

function modifier_medusa_mystic_snake_speed:IsPurgable()
	return false
end

function modifier_medusa_mystic_snake_speed:IsPermanent()
	return true
end


function modifier_medusa_mystic_snake_speed:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_medusa_mystic_snake_speed:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_medusa_mystic_snake_speed:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "medusa_mystic_snake" then
       
        if not params.attacker:HasModifier("modifier_medusa_mystic_snake_speed_buff") then
        
            params.attacker:AddNewModifier(params.attacker,self:GetAbility(),"modifier_medusa_mystic_snake_speed_buff",{duration = 10})
        else
            local buffModifier =  params.attacker:FindModifierByName("modifier_medusa_mystic_snake_speed_buff")
        
            if(buffModifier) then
                buffModifier:SetStackCount(buffModifier:GetStackCount()+1)
                buffModifier:ForceRefresh()
            end
        end
    end
    

end
modifier_medusa_mystic_snake_speed_buff = class({})


function modifier_medusa_mystic_snake_speed_buff:IsPurgable()
	return false
end

function modifier_medusa_mystic_snake_speed_buff:IsPurgeException()
	return false
end

function modifier_medusa_mystic_snake_speed_buff:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_medusa_mystic_snake_speed_buff:OnCreated( kv )
    if  IsServer() then
       
    end
    
	
	
end
function modifier_medusa_mystic_snake_speed_buff:OnRefresh( kv )
    if  IsServer() then
      
    end
	
end

--------------------------------------------------------------------------------




function modifier_medusa_mystic_snake_speed_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}

	return funcs
end



function modifier_medusa_mystic_snake_speed_buff:GetModifierAttackSpeedPercentage(params)
	return 10*(self:GetStackCount()+1)
end

function modifier_medusa_mystic_snake_speed_buff:GetModifierIgnoreMovespeedLimit(params)
	return 1
end
function modifier_medusa_mystic_snake_speed_buff:GetModifierMoveSpeedBonus_Percentage(params)
	return 10*(self:GetStackCount()+1)
end

function modifier_medusa_mystic_snake_speed_buff:GetModifierIgnoreMovespeedLimit(params)
	return 1
end


--------------------------------------------------------------------------------


