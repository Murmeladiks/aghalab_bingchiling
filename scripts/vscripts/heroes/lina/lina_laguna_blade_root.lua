lina_laguna_blade_root = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_lina_laguna_blade_root", "heroes/lina/lina_laguna_blade_root", LUA_MODIFIER_MOTION_NONE )

function lina_laguna_blade_root:GetIntrinsicModifierName()
	return "modifier_lina_laguna_blade_root"
end
function lina_laguna_blade_root:OnSpellStart()

	

end

modifier_lina_laguna_blade_root = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lina_laguna_blade_root:IsHidden()
	return true
end

function modifier_lina_laguna_blade_root:IsPurgeException()
	return false
end

function modifier_lina_laguna_blade_root:IsPurgable()
	return false
end

function modifier_lina_laguna_blade_root:IsPermanent()
	return true
end



function modifier_lina_laguna_blade_root:OnCreated(kv)
    if IsServer() then
    end
end
function modifier_lina_laguna_blade_root:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end
function modifier_lina_laguna_blade_root:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "lina_laguna_blade" then
        return
    end
    local unit = self:GetParent()
    self.lina_laguna_blade = unit:FindAbilityByName("lina_laguna_blade")
   
    
    for i = 1, 10 do
        Timers:CreateTimer(i * 0.3, function ()
            if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
                self:GetParent():SetCursorCastTarget(params.target)
                self.lina_laguna_blade:OnSpellStart()
            end    
        end)
    end
    unit:AddNewModifier(self:GetParent(),nil,"modifier_rooted",{duration = 3})


  

   
end
