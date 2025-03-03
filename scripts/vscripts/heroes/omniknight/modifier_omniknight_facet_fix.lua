modifier_omniknight_facet_fix = class( {} )





--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_facet_fix:IsHidden()
	return true
end

function modifier_omniknight_facet_fix:IsPurgeException()
	return false
end

function modifier_omniknight_facet_fix:IsPurgable()
	return false
end

function modifier_omniknight_facet_fix:IsPermanent()
	return true
end


function  modifier_omniknight_facet_fix:OnCreated( kv )
	if IsServer() then
    end
end

function  modifier_omniknight_facet_fix:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end


function   modifier_omniknight_facet_fix:OnTakeDamage(params)
    if not IsServer() then
        return
    end

  

    if params.attacker ~= self:GetParent() then
        return
    end


    if params.unit == self:GetParent() then
        return
    end
   
    if params.attacker == self:GetParent() then
        if self:GetParent():GetHeroFacetID() == 2 then
            if params.inflictor then
                if params.inflictor:GetAbilityName() == "omniknight_purification" or params.inflictor:GetAbilityName() == "omniknight_hammer_of_purity" then
                    for i = 1, 5, 1 do
            
                        Timers:CreateTimer(i*1.0, function()
                            local heal = math.ceil(params.damage*0.04)
                            if self:GetParent():IsAlive() then
                                self:GetParent():Heal(heal, params.inflictor)
                            end
                        end)
                    end
                end
            end
        end
  
    end
    
		
	

    

end