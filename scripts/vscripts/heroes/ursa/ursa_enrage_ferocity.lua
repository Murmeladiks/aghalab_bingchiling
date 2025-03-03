ursa_enrage_ferocity = class( {} )

LinkLuaModifier( "modifier_ursa_enrage_ferocity", "heroes/ursa/ursa_enrage_ferocity", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ursa_enrage_ferocity_buff", "heroes/ursa/ursa_enrage_ferocity", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function ursa_enrage_ferocity:GetIntrinsicModifierName()
	return "modifier_ursa_enrage_ferocity"
end

modifier_ursa_enrage_ferocity = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ursa_enrage_ferocity:IsHidden()
	return true
end

function modifier_ursa_enrage_ferocity:IsPurgeException()
	return false
end

function modifier_ursa_enrage_ferocity:IsPurgable()
	return false
end

function modifier_ursa_enrage_ferocity:IsPermanent()
	return true
end


function modifier_ursa_enrage_ferocity:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_ursa_enrage_ferocity:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end


function  modifier_ursa_enrage_ferocity:OnAbilityExecuted(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    

    if params.ability:GetAbilityName() == "ursa_enrage" then
       
        self.ursa_enrage = params.unit:FindAbilityByName("ursa_enrage")
        local duration = self.ursa_enrage:GetSpecialValueFor("duration")
        local Range = 700
        local heroes = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),	-- int, your team number
            self:GetParent():GetAbsOrigin(),	-- point, center point
            nil,	-- handle, cacheUnit. (not known)
            Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_CLOSEST,	-- int, order filter
            false
        )
        
            
        for _, hero in pairs(heroes) do
            if hero and not hero:IsNull() and not hero:IsInvulnerable()  then
               
                hero:AddNewModifier(self:GetParent(),self.ursa_enrage,"modifier_ursa_enrage_ferocity_buff",{duration = duration})
                
            end
        end
    end
     
  
   
    
		
	

    

end

modifier_ursa_enrage_ferocity_buff = class({})


function modifier_ursa_enrage_ferocity_buff:IsPurgable()
	return false
end

function modifier_ursa_enrage_ferocity_buff:IsPurgeException()
	return false
end

function modifier_ursa_enrage_ferocity_buff:IsPermanent()
	return false
end
function modifier_ursa_enrage_ferocity_buff:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_ursa_enrage_ferocity_buff:OnCreated( kv )
    if not IsServer() then
        return
    end
    self.attackspeed  = 80
	self:SetHasCustomTransmitterData(true)
	
end
function modifier_ursa_enrage_ferocity_buff:AddCustomTransmitterData()
    return {
       
		
		attackspeed=self.attackspeed ,
		
    }
end
function modifier_ursa_enrage_ferocity_buff:HandleCustomTransmitterData( data )
   
	  self.attackspeed = data.attackspeed
	
end
--------------------------------------------------------------------------------

function modifier_ursa_enrage_ferocity_buff:OnRefresh( kv )
	
end



function modifier_ursa_enrage_ferocity_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end



function modifier_ursa_enrage_ferocity_buff:GetModifierAttackSpeedPercentage(params)
	return self.attackspeed
end



--------------------------------------------------------------------------------

