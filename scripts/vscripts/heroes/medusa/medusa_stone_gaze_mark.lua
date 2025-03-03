medusa_stone_gaze_mark = class( {} )

LinkLuaModifier( "modifier_medusa_stone_gaze_mark", "heroes/medusa/medusa_stone_gaze_mark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_stone_gaze_mark_buff", "heroes/medusa/medusa_stone_gaze_mark", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function medusa_stone_gaze_mark:GetIntrinsicModifierName()
	return "modifier_medusa_stone_gaze_mark"
end

modifier_medusa_stone_gaze_mark = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_medusa_stone_gaze_mark:IsHidden()
	return true
end

function modifier_medusa_stone_gaze_mark:IsPurgeException()
	return false
end

function modifier_medusa_stone_gaze_mark:IsPurgable()
	return false
end

function modifier_medusa_stone_gaze_mark:IsPermanent()
	return true
end



function modifier_medusa_stone_gaze_mark:OnCreated(kv)
    if IsServer() then
      
    end
end

function modifier_medusa_stone_gaze_mark:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end


function modifier_medusa_stone_gaze_mark:OnAttackLanded( params )
    if IsServer() then
        local Attacker = params.attacker
        local Target = params.target
       
        if not Attacker or not Target then
            return
        end

        if Attacker ~= self:GetParent()  then
            return
        end
        self.medusa_stone_gaze = Attacker:FindAbilityByName("medusa_stone_gaze")
        local duration = self.medusa_stone_gaze:GetSpecialValueFor("duration")
        if self.medusa_stone_gaze and self.medusa_stone_gaze:GetLevel()>0 then
            if Target and not Target:HasModifier("modifier_medusa_stone_gaze_stone") then
                if not Target:HasModifier("modifier_medusa_stone_gaze_mark_buff") then
                    local buffmodifier = Target:AddNewModifier(Attacker, self:GetAbility(), "modifier_medusa_stone_gaze_mark_buff", {duration = 10})
                    
                else
                    local buff = Target:FindModifierByName("modifier_medusa_stone_gaze_mark_buff")
                    if buff:GetStackCount()<3 then
                        buff:SetStackCount(buff:GetStackCount()+1)
                        buff:ForceRefresh()
                    else
                    
                        Target:RemoveModifierByName("modifier_medusa_stone_gaze_mark_buff")
                        Target:AddNewModifier(Attacker, self.medusa_stone_gaze, "modifier_medusa_stone_gaze_stone", {duration = duration})
                    
                    end
                end
            end
        end

        
    end

    return 0
end


modifier_medusa_stone_gaze_mark_buff = class({})

-----------------------------------------------------------------------------------------

function modifier_medusa_stone_gaze_mark_buff:GetTexture()
    return "medusa_stone_gaze"
end

-----------------------------------------------------------------------------------------

function modifier_medusa_stone_gaze_mark_buff:OnCreated( kv )
    self.nArmorReductionPerStack = math.max( math.floor( 10 * self:GetParent():GetPhysicalArmorValue(false) / 100 ), 1 )
    
end

-----------------------------------------------------------------------------------------

function modifier_medusa_stone_gaze_mark_buff:DeclareFunctions()
    local funcs =
    {
        --MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

-----------------------------------------------------------------------------------------

function modifier_medusa_stone_gaze_mark_buff:GetModifierPhysicalArmorBonus()
    if self.nArmorReductionPerStack == nil then
        return 0
    end
    return self.nArmorReductionPerStack * (self:GetStackCount()+1) * -1
end