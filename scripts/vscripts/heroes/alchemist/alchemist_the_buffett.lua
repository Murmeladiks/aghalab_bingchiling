alchemist_the_buffett = class( {} )

LinkLuaModifier( "modifier_alchemist_the_buffett", "heroes/alchemist/alchemist_the_buffett", LUA_MODIFIER_MOTION_NONE )
function alchemist_the_buffett:OnSpellStart()
	--获取身上剩余金钱
    local gold  = self:GetCaster():GetGold()
    --按一次扣100 buff记一次数
    local investment  = 100
    if investment <= gold then
        self:GetCaster():SpendGold(investment, DOTA_ModifyGold_AbilityCost)
        EmitGlobalSound("General.Sell")
        if not self:GetCaster():HasModifier("modifier_alchemist_the_buffett") then
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alchemist_the_buffett", {})
        else
            local buff = self:GetCaster():FindModifierByName("modifier_alchemist_the_buffett")
            if buff then
                buff:AddStack()
            end
        end
    else
        self:GetCaster():EmitSound("General.NoGold")
        return
    end
   
end
modifier_alchemist_the_buffett = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_alchemist_the_buffett:IsHidden()
	return false
end

function modifier_alchemist_the_buffett:IsPurgeException()
	return false
end

function modifier_alchemist_the_buffett:IsPurgable()
	return false
end

function modifier_alchemist_the_buffett:IsPermanent()
	return true
end


function modifier_alchemist_the_buffett:OnCreated( kv )
	if IsServer() then		
        self:SetStackCount(1)
        print(self:GetStackCount())	
    end
end
function modifier_alchemist_the_buffett:AddStack(  )
	if IsServer() then		
        self:IncrementStackCount()
        print(self:GetStackCount())	
    end
end
