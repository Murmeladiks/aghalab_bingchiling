modifier_boss_void_spirit_damage_enhence = class({})


function modifier_boss_void_spirit_damage_enhence:IsPurgable()
	return false
end

function modifier_boss_void_spirit_damage_enhence:IsPurgeException()
	return false
end

function modifier_boss_void_spirit_damage_enhence:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_void_spirit_damage_enhence:OnCreated( kv )
	


	if IsServer() then	
		
	end
end

--------------------------------------------------------------------------------

function modifier_boss_void_spirit_damage_enhence:OnRefresh( kv )
	

	if IsServer() then
		
	end
end

--------------------------------------------------------------------------------

function modifier_boss_void_spirit_damage_enhence:DeclareFunctions()
	local funcs = {
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
	}

	return funcs
end

--------------------------------------------------------------------------------
function modifier_boss_void_spirit_damage_enhence:OnTakeDamage(params)
	if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    if params.inflictor and params.inflictor:GetAbilityName() == "aghsfort_void_spirit_boss_aether_remnant" then
        
        print("aether remnant attack")
		local maxhealth = params.unit:GetMaxHealth()
		local damage = maxhealth*0.1
		print(damage)
		self.damageTable = {
			victim = params.unit,
			attacker = self:GetParent(),
			damage =damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self.spectre_desolate, 
			
		}
		ApplyDamage( self.damageTable )
        local unitname = "aghsfort_primal_beast_rock_golem"
		local hellunit = CreateUnitByName( unitname, self:GetParent():GetAbsOrigin(), true, nil, nil, self:GetParent():GetTeamNumber() )
		local nLevel = GameRules.Aghanim:GetAscensionLevel()
		hellunit:CreatureLevelUp( nLevel ) 
		FindClearSpaceForUnit(hellunit, self:GetParent():GetAbsOrigin() + RandomVector(250), true)
	elseif params.inflictor and params.inflictor:GetAbilityName() == "aghsfort_void_spirit_boss_dissimilate" then
		print("dissimilate attack")
		local maxhealth = params.unit:GetMaxHealth()
		local damage = maxhealth*0.1
		print(damage)
		self.damageTable = {
			victim = params.unit,
			attacker = self:GetParent(),
			damage =damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self.spectre_desolate, 
			
		}
		ApplyDamage( self.damageTable )
		local unitname = "aghsfort_primal_beast_rock_golem"
		local hellunit = CreateUnitByName( unitname, self:GetParent():GetAbsOrigin(), true, nil, nil, self:GetParent():GetTeamNumber() )
		local nLevel = GameRules.Aghanim:GetAscensionLevel()
		hellunit:CreatureLevelUp( nLevel ) 
		FindClearSpaceForUnit(hellunit, self:GetParent():GetAbsOrigin() + RandomVector(250), true)
	elseif params.inflictor and params.inflictor:GetAbilityName() == "aghsfort_void_spirit_boss_resonant_pulse" then
		print("resonant pulse attack")
		local maxhealth = params.unit:GetMaxHealth()
		local damage = maxhealth*0.15
		print(damage)
		self.damageTable = {
			victim = params.unit,
			attacker = self:GetParent(),
			damage =damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self.spectre_desolate, 
			
		}
		ApplyDamage( self.damageTable )
		local unitname = "aghsfort_primal_beast_rock_golem"
		local hellunit = CreateUnitByName( unitname, self:GetParent():GetAbsOrigin(), true, nil, nil, self:GetParent():GetTeamNumber() )
		local nLevel = GameRules.Aghanim:GetAscensionLevel()
		hellunit:CreatureLevelUp( nLevel ) 
		FindClearSpaceForUnit(hellunit, self:GetParent():GetAbsOrigin() + RandomVector(250), true)
	elseif params.inflictor and params.inflictor:GetAbilityName() == "aghsfort_void_spirit_boss_astral_step" then
		print("astral step attack")
		local maxhealth = params.unit:GetMaxHealth()
		local damage = maxhealth*0.15
		print(damage)
		self.damageTable = {
			victim = params.unit,
			attacker = self:GetParent(),
			damage =damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self.spectre_desolate, 
			
		}
		ApplyDamage( self.damageTable )
		local unitname = "aghsfort_primal_beast_rock_golem"
		local hellunit = CreateUnitByName( unitname, self:GetParent():GetAbsOrigin(), true, nil, nil, self:GetParent():GetTeamNumber() )
		local nLevel = GameRules.Aghanim:GetAscensionLevel()
		hellunit:CreatureLevelUp( nLevel ) 
		FindClearSpaceForUnit(hellunit, self:GetParent():GetAbsOrigin() + RandomVector(250), true)
    end
   
end

--------------------------------------------------------------------------------

