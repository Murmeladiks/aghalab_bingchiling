spectre_desolate_heal= class( {} )

LinkLuaModifier( "modifier_spectre_desolate_heal", "heroes/spectre/spectre_desolate_heal", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_desolate_heal:GetIntrinsicModifierName()
	return "modifier_spectre_desolate_heal"
end



modifier_spectre_desolate_heal= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_desolate_heal:IsHidden()
	return true
end

function modifier_spectre_desolate_heal:IsPurgeException()
	return false
end

function modifier_spectre_desolate_heal:IsPurgable()
	return false
end

function modifier_spectre_desolate_heal:IsPermanent()
	return true
end


function modifier_spectre_desolate_heal:OnCreated( kv )
	if IsServer() then
       
    end
end

function modifier_spectre_desolate_heal:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_spectre_desolate_heal:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "spectre_desolate" then
        local heal = math.ceil(params.damage*0.5)
        self:GetParent():Heal(heal, params.inflictor)
    end
    

end