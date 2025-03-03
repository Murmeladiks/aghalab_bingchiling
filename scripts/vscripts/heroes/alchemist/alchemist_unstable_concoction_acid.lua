alchemist_unstable_concoction_acid = class( {} )

LinkLuaModifier( "modifier_alchemist_unstable_concoction_acid", "heroes/alchemist/alchemist_unstable_concoction_acid", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function alchemist_unstable_concoction_acid:GetIntrinsicModifierName()
	return "modifier_alchemist_unstable_concoction_acid"
end



modifier_alchemist_unstable_concoction_acid = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_alchemist_unstable_concoction_acid:IsHidden()
	return true
end

function modifier_alchemist_unstable_concoction_acid:IsPurgeException()
	return false
end

function modifier_alchemist_unstable_concoction_acid:IsPurgable()
	return false
end

function modifier_alchemist_unstable_concoction_acid:IsPermanent()
	return true
end


function modifier_alchemist_unstable_concoction_acid:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_alchemist_unstable_concoction_acid:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_alchemist_unstable_concoction_acid:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "alchemist_unstable_concoction_throw" then
        self.aghsfort_alchemist_acid_spray =self:GetParent():FindAbilityByName("aghsfort_alchemist_acid_spray")
        local pos = params.unit:GetAbsOrigin()
        if self.aghsfort_alchemist_acid_spray:GetLevel()>0 then
            self:GetParent():SetCursorPosition(pos)
            self.aghsfort_alchemist_acid_spray:OnSpellStart()
        end
    end
    

end