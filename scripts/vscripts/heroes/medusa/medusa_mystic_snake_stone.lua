medusa_mystic_snake_stone= class( {} )

LinkLuaModifier( "modifier_medusa_mystic_snake_stone", "heroes/medusa/medusa_mystic_snake_stone", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function medusa_mystic_snake_stone:GetIntrinsicModifierName()
	return "modifier_medusa_mystic_snake_stone"
end



modifier_medusa_mystic_snake_stone= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_mystic_snake_stone:IsHidden()
	return true
end

function modifier_medusa_mystic_snake_stone:IsPurgeException()
	return false
end

function modifier_medusa_mystic_snake_stone:IsPurgable()
	return false
end

function modifier_medusa_mystic_snake_stone:IsPermanent()
	return true
end


function modifier_medusa_mystic_snake_stone:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_medusa_mystic_snake_stone:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_medusa_mystic_snake_stone:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "medusa_mystic_snake" then
        self.medusa_stone_gaze = self:GetParent():FindAbilityByName("medusa_stone_gaze")
        if self.medusa_stone_gaze and self.medusa_stone_gaze:GetLevel()>0 then
            local duration = self.medusa_stone_gaze:GetSpecialValueFor("duration")
            if not params.unit:HasModifier("modifier_medusa_stone_gaze_stone") then
            
                params.unit:AddNewModifier(params.attacker,self:GetAbility(),"modifier_medusa_stone_gaze_stone",{duration = duration})
            else
                local buffModifier =  params.attacker:FindModifierByName("modifier_medusa_stone_gaze_stone")
            
                if(buffModifier) then
                    buffModifier:ForceRefresh()
                end
            end
        end
    end
    

end
