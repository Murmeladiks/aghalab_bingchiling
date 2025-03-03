aghsfort_special_juggernaut_blade_dance_fever = class({})
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_blade_dance_fever", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_fever", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_blade_dance_fever_buff", "heroes/juggernaut/aghsfort_special_juggernaut_blade_dance_fever", LUA_MODIFIER_MOTION_NONE )

function aghsfort_special_juggernaut_blade_dance_fever:GetIntrinsicModifierName()
	return "modifier_aghsfort_special_juggernaut_blade_dance_fever"
end


modifier_aghsfort_special_juggernaut_blade_dance_fever = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_juggernaut_blade_dance_fever:IsHidden()
    return true
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever:IsPurgeException()
    return false
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever:IsPurgable()
    return false
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever:IsPermanent()
    return true
end



function modifier_aghsfort_special_juggernaut_blade_dance_fever:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever:OnCreated(kv)
    if IsServer() then
        self.caster = self:GetCaster()
        
        self:SetHasCustomTransmitterData( true )
    end
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end
function modifier_aghsfort_special_juggernaut_blade_dance_fever:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end


function modifier_aghsfort_special_juggernaut_blade_dance_fever:OnAttackLanded(params)
    if not IsServer() then
        return
    end
    
    local attacker = params.attacker

    if attacker ~= self:GetParent() then
        return
    end

    if attacker:IsNull() or not attacker:IsAlive() then
        return
    end

    if params.target:IsNull() or not params.target:IsAlive() or params.target:IsBuilding() or params.target:IsOther() then
        return
    end

    if params.no_attack_cooldown then
		return
	end
    self.ability = self:GetCaster():FindAbilityByName("juggernaut_blade_dance")
    self.chance = math.floor(self.ability:GetSpecialValueFor("blade_dance_crit_chance")/2)
    
    print(self.chance)
    if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
        params.attacker:AddNewModifier(params.attacker, nil,"modifier_aghsfort_special_juggernaut_blade_dance_fever_buff", {duration=2})

    end
end


modifier_aghsfort_special_juggernaut_blade_dance_fever_buff = class({})


function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:IsPurgable()
	return false
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:IsPurgeException()
	return false
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:OnCreated( kv )
   
    self.attackspeed  = 100
	self.attackrange = 200
	
end
function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:OnRefresh( kv )
   
    self.attackspeed  = 100
	self.attackrange = 200
end
--------------------------------------------------------------------------------

function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:OnRefresh( kv )
	
end



function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end



function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:GetModifierAttackSpeedPercentage(params)
	return self.attackspeed
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:GetModifierAttackSpeed_Limit(params)
	return 1
end

function modifier_aghsfort_special_juggernaut_blade_dance_fever_buff:GetModifierAttackRangeBonus(params)
	return self.attackrange 
end


--------------------------------------------------------------------------------

