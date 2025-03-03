enchantress_impetus_hurricane = class( {} )


--------------------------------------------------------------------------------

function enchantress_impetus_hurricane:GetIntrinsicModifierName()
	return "modifier_enchantress_impetus_hurricane"
end
modifier_enchantress_impetus_hurricane = class({})
function modifier_enchantress_impetus_hurricane:IsHidden()
	return true
end

function modifier_enchantress_impetus_hurricane:IsPurgeException()
	return false
end

function modifier_enchantress_impetus_hurricane:IsPurgable()
	return false
end

function modifier_enchantress_impetus_hurricane:IsPermanent()
	return false
end

function modifier_enchantress_impetus_hurricane:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end


function modifier_enchantress_impetus_hurricane:OnCreated(kv)
    if IsServer() then

    end
end
function modifier_enchantress_impetus_hurricane:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_enchantress_impetus_hurricane:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target

        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end
		--Attacker:AddNewModifier(Attacker,self:GetAbility(),"modifier_item_hurricane_pike_active",{})
		Attacker:AddNewModifier(Attacker,self:GetAbility(),"modifier_item_hurricane_pike_range",{duration = 6})
		--Target:AddNewModifier(Attacker,self:GetAbility(),"modifier_item_hurricane_pike_active_alternate",{})
        

        
    end

    return 0
end




