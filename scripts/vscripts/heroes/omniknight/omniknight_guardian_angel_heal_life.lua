omniknight_guardian_angel_heal_life = class( {} )

LinkLuaModifier( "modifier_omniknight_guardian_angel_heal_life", "heroes/omniknight/omniknight_guardian_angel_heal_life", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function omniknight_guardian_angel_heal_life:GetIntrinsicModifierName()
	return "modifier_omniknight_guardian_angel_heal_life"
end

modifier_omniknight_guardian_angel_heal_life = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_guardian_angel_heal_life:IsHidden()
	return true
end

function modifier_omniknight_guardian_angel_heal_life:IsPurgeException()
	return false
end

function modifier_omniknight_guardian_angel_heal_life:IsPurgable()
	return false
end

function modifier_omniknight_guardian_angel_heal_life:IsPermanent()
	return true
end


function modifier_omniknight_guardian_angel_heal_life:OnCreated( kv )
	if IsServer() then
        self.caster = self:GetCaster()
        self.chance = 20
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_omniknight_guardian_angel_heal_life:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end

function modifier_omniknight_guardian_angel_heal_life:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_omniknight_guardian_angel_heal_life:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function  modifier_omniknight_guardian_angel_heal_life:OnAttackLanded(params)
    if IsServer() then
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then return end
		if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
		if params.attacker:IsOther() or params.attacker:IsBuilding() then return end
		if params.target:HasModifier("modifier_omninight_guardian_angel") then
		-- roll dice
			if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
				
					self.omniknight_purification = self:GetParent():FindAbilityByName("omniknight_purification")
					if self.omniknight_purification and self.omniknight_purification:GetLevel()>0 then
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
        
	
	end
		
	

    

end