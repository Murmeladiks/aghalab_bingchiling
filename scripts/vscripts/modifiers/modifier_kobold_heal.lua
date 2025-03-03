modifier_kobold_heal = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_kobold_heal:IsHidden()
	return true
end

function modifier_kobold_heal:IsPurgeException()
	return false
end

function modifier_kobold_heal:IsPurgable()
	return false
end

function modifier_kobold_heal:IsPermanent()
	return true
end


function modifier_kobold_heal:OnCreated( kv )
	self.caster = self:GetCaster()
    self.chance = 50
    self:SetHasCustomTransmitterData( true )
end
function modifier_kobold_heal:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end

function modifier_kobold_heal:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_kobold_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_kobold_heal:OnAttackLanded( params )
	if IsServer() then
		if params.target~=self:GetCaster() then return end
		if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
		if params.attacker:IsOther() or params.attacker:IsBuilding() then return end
		if params.attacker:IsIllusion() then return end
		-- roll dice
	--	if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
			
				
				self:GetCaster():Heal(200,nil)
				

				
       -- end
        
	
	end
	
	



end