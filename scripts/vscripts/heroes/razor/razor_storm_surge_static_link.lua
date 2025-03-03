razor_storm_surge_static_link = class( {} )

LinkLuaModifier( "modifier_razor_storm_surge_static_link", "heroes/razor/razor_storm_surge_static_link", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function razor_storm_surge_static_link:GetIntrinsicModifierName()
	return "modifier_razor_storm_surge_static_link"
end

modifier_razor_storm_surge_static_link = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_storm_surge_static_link:IsHidden()
	return true
end

function modifier_razor_storm_surge_static_link:IsPurgeException()
	return false
end

function modifier_razor_storm_surge_static_link:IsPurgable()
	return false
end

function modifier_razor_storm_surge_static_link:IsPermanent()
	return true
end


function modifier_razor_storm_surge_static_link:OnCreated( kv )
	if IsServer() then
    end
end

function modifier_razor_storm_surge_static_link:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end


function  modifier_razor_storm_surge_static_link:OnTakeDamage( params )
    if not IsServer() then
        return
    end
	if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end
    
        
    if params.inflictor and params.inflictor:GetAbilityName() == "razor_storm_surge" then
        self.razor_static_link = self:GetCaster():FindAbilityByName("razor_static_link")
		if self.razor_static_link:GetLevel()>0 then
			if params.unit and not params.unit:IsNull() and params.unit:IsAlive() then
				local pos1 = params.unit:GetAbsOrigin()
				local pos2  = self:GetParent():GetAbsOrigin()
				local distance = (pos1-pos2):Length2D()
				local range = self.razor_static_link:GetSpecialValueFor("AbilityCastRange")
				if distance<range then
					self:GetParent():SetCursorCastTarget(params.unit)
					self.razor_static_link:OnSpellStart()
				end
			end
		end
    end



end

