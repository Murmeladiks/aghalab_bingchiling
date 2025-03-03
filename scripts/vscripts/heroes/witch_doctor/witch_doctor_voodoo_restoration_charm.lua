witch_doctor_voodoo_restoration_charm = class( {} )

LinkLuaModifier( "modifier_witch_doctor_voodoo_restoration_charm", "heroes/witch_doctor/witch_doctor_voodoo_restoration_charm", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function witch_doctor_voodoo_restoration_charm:GetIntrinsicModifierName()
	return "modifier_witch_doctor_voodoo_restoration_charm"
end


modifier_witch_doctor_voodoo_restoration_charm = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_witch_doctor_voodoo_restoration_charm:IsHidden()
	return true
end

function modifier_witch_doctor_voodoo_restoration_charm:IsPurgeException()
	return false
end

function modifier_witch_doctor_voodoo_restoration_charm:IsPurgable()
	return false
end

function modifier_witch_doctor_voodoo_restoration_charm:IsPermanent()
	return true
end



function modifier_witch_doctor_voodoo_restoration_charm:OnCreated(kv)
    if IsServer() then
       
    end
end

function modifier_witch_doctor_voodoo_restoration_charm:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
    }
end


function modifier_witch_doctor_voodoo_restoration_charm:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
        if params.attacker:HasModifier("modifier_voodoo_restoration_heal") then
            if params.attacker ~= nil and params.target ~= nil then
                local heal = ( params.damage * 15 / 100 ) 
    
                print("heal")
                print(heal)
                params.attacker:Heal( heal, self:GetAbility() )
    
                local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
                
            end
        end
    end

    
      
end


