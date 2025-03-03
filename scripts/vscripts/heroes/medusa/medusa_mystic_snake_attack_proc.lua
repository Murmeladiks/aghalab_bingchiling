medusa_mystic_snake_attack_proc = class( {} )

LinkLuaModifier( "modifier_medusa_mystic_snake_attack_proc", "heroes/medusa/medusa_mystic_snake_attack_proc", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function medusa_mystic_snake_attack_proc:GetIntrinsicModifierName()
	return "modifier_medusa_mystic_snake_attack_proc"
end

modifier_medusa_mystic_snake_attack_proc = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_mystic_snake_attack_proc:IsHidden()
	return true
end

function modifier_medusa_mystic_snake_attack_proc:IsPurgeException()
	return false
end

function modifier_medusa_mystic_snake_attack_proc:IsPurgable()
	return false
end

function modifier_medusa_mystic_snake_attack_proc:IsPermanent()
	return true
end



function modifier_medusa_mystic_snake_attack_proc:OnCreated(kv)
    if IsServer() then
        self.chance = 15
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_medusa_mystic_snake_attack_proc:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_medusa_mystic_snake_attack_proc:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_medusa_mystic_snake_attack_proc:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_medusa_mystic_snake_attack_proc:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target

        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end
        if Target then
            self.ability = Attacker:FindAbilityByName("medusa_mystic_snake")
            if self.ability and self.ability:GetLevel()>0 then
                if RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                    Attacker:SetCursorCastTarget(Target)
                    self.ability:OnSpellStart()
                    
                end
            end
        end
        

        
    end

    return 0
end

