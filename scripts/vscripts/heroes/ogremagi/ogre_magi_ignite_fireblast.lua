ogre_magi_ignite_fireblast = class( {} )

LinkLuaModifier( "modifier_ogre_magi_ignite_fireblast", "heroes/ogremagi/ogre_magi_ignite_fireblast", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ogre_magi_ignite_fireblast:GetIntrinsicModifierName()
	return "modifier_ogre_magi_ignite_fireblast"
end

modifier_ogre_magi_ignite_fireblast = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_ignite_fireblast:IsHidden()
	return true
end

function modifier_ogre_magi_ignite_fireblast:IsPurgeException()
	return false
end

function modifier_ogre_magi_ignite_fireblast:IsPurgable()
	return false
end

function modifier_ogre_magi_ignite_fireblast:IsPermanent()
	return true
end
function modifier_ogre_magi_ignite_fireblast:OnCreated(kv)
    if IsServer() then
		self.chance = 35
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_ogre_magi_ignite_fireblast:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end

function modifier_ogre_magi_ignite_fireblast:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_ogre_magi_ignite_fireblast:DeclareFunctions()
	local funcs = {
        
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
	}

	return funcs
end
function  modifier_ogre_magi_ignite_fireblast:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self:GetParent() then
        return
		
    end
    
	if params.inflictor and params.inflictor:GetAbilityName() == "ogre_magi_ignite" then
		self.ogre_magi_fireblast =self:GetParent():FindAbilityByName("ogre_magi_fireblast")

		if self.ogre_magi_fireblast and self.ogre_magi_fireblast:GetLevel()>0 then
			if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
				if params.unit and not params.unit:IsMagicImmune() then
					self:GetParent():SetCursorCastTarget(params.unit)
					self.ogre_magi_fireblast:OnSpellStart()
				end
			end
		end
	end 
   
    

end



