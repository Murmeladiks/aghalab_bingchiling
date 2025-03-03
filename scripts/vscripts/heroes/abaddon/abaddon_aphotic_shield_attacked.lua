abaddon_aphotic_shield_attacked = class( {} )

LinkLuaModifier( "modifier_abaddon_aphotic_shield_attacked", "heroes/abaddon/abaddon_aphotic_shield_attacked", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function abaddon_aphotic_shield_attacked:GetIntrinsicModifierName()
	return "modifier_abaddon_aphotic_shield_attacked"
end

modifier_abaddon_aphotic_shield_attacked = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_abaddon_aphotic_shield_attacked:IsHidden()
	return true
end

function modifier_abaddon_aphotic_shield_attacked:IsPurgeException()
	return false
end

function modifier_abaddon_aphotic_shield_attacked:IsPurgable()
	return false
end

function modifier_abaddon_aphotic_shield_attacked:IsPermanent()
	return true
end


function modifier_abaddon_aphotic_shield_attacked:OnCreated( kv )
	if IsServer() then
        self.caster = self:GetCaster()
        self.chance = 10
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_abaddon_aphotic_shield_attacked:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end

function modifier_abaddon_aphotic_shield_attacked:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_abaddon_aphotic_shield_attacked:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_abaddon_aphotic_shield_attacked:OnAttackLanded(params)
    if IsServer() then
		if params.target~=self:GetCaster() then return end
		if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
		if params.attacker:IsOther() or params.attacker:IsBuilding() then return end

		-- roll dice
		if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
			
				self.abaddon_aphotic_shield = self:GetParent():FindAbilityByName("abaddon_aphotic_shield")
                if self.abaddon_aphotic_shield and self.abaddon_aphotic_shield:GetLevel()>0 then
                    self:GetCaster():SetCursorCastTarget(self:GetCaster())
                    self.abaddon_aphotic_shield:OnSpellStart()
                end
        end
        
	
	end
		
	

    

end