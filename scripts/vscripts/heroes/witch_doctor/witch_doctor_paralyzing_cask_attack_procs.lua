witch_doctor_paralyzing_cask_attack_procs = class( {} )

LinkLuaModifier( "modifier_witch_doctor_paralyzing_cask_attack_procs", "heroes/witch_doctor/witch_doctor_paralyzing_cask_attack_procs", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function witch_doctor_paralyzing_cask_attack_procs:GetIntrinsicModifierName()
	return "modifier_witch_doctor_paralyzing_cask_attack_procs"
end


modifier_witch_doctor_paralyzing_cask_attack_procs = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_paralyzing_cask_attack_procs:IsHidden()
	return true
end

function modifier_witch_doctor_paralyzing_cask_attack_procs:IsPurgeException()
	return false
end

function modifier_witch_doctor_paralyzing_cask_attack_procs:IsPurgable()
	return false
end

function modifier_witch_doctor_paralyzing_cask_attack_procs:IsPermanent()
	return true
end



function modifier_witch_doctor_paralyzing_cask_attack_procs:OnCreated(kv)
    if IsServer() then
        self.chance = 15
        self:SetHasCustomTransmitterData( true )
       
   
    end
end
function modifier_witch_doctor_paralyzing_cask_attack_procs:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_witch_doctor_paralyzing_cask_attack_procs:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_witch_doctor_paralyzing_cask_attack_procs:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end


function modifier_witch_doctor_paralyzing_cask_attack_procs:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("witch_doctor_paralyzing_cask") 

	if self.ability and self.ability:GetLevel()> 0 then	
        if RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then    
            if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() and not params.target:IsMagicImmune() then
                self:GetParent():SetCursorCastTarget(params.target)
                self.ability:OnSpellStart()

            end 
        end
	end
      
end


