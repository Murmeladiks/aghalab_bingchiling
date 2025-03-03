ogre_magi_fireblast_ignite = class( {} )

LinkLuaModifier( "modifier_ogre_magi_fireblast_ignite", "heroes/ogremagi/ogre_magi_fireblast_ignite", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ogre_magi_fireblast_ignite:GetIntrinsicModifierName()
	return "modifier_ogre_magi_fireblast_ignite"
end

modifier_ogre_magi_fireblast_ignite = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_fireblast_ignite:IsHidden()
	return true
end

function modifier_ogre_magi_fireblast_ignite:IsPurgeException()
	return false
end

function modifier_ogre_magi_fireblast_ignite:IsPurgable()
	return false
end

function modifier_ogre_magi_fireblast_ignite:IsPermanent()
	return true
end
function modifier_ogre_magi_fireblast_ignite:OnCreated(kv)
    if IsServer() then
		self.chance = 35
        self:SetHasCustomTransmitterData( true )
    end
end
function modifier_ogre_magi_fireblast_ignite:AddCustomTransmitterData()
	-- on server
	local data = {
		chance =  self.chance
		
	}

	return data
end

function modifier_ogre_magi_fireblast_ignite:HandleCustomTransmitterData( data )
	-- on client
	self.chance = data.chance
	
end
function modifier_ogre_magi_fireblast_ignite:DeclareFunctions()
	local funcs = {
        
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		
	}

	return funcs
end
function  modifier_ogre_magi_fireblast_ignite:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self:GetParent() then
        return
		
    end
    
	if params.inflictor and params.inflictor:GetAbilityName() == "ogre_magi_fireblast" then
		self.ogre_magi_ignite =self:GetParent():FindAbilityByName("ogre_magi_ignite")

		if self.ogre_magi_ignite and self.ogre_magi_ignite:GetLevel()>0 then
			if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
				if params.unit and not params.unit:IsMagicImmune() then
					self:GetParent():SetCursorCastTarget(params.unit)
					self.ogre_magi_ignite:OnSpellStart()
				end
			end
		end
	end 
   
    

end



