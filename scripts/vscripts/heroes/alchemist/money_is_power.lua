money_is_power = class( {} )

LinkLuaModifier( "modifier_money_is_power", "heroes/alchemist/money_is_power", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function money_is_power:GetIntrinsicModifierName()
	return "modifier_money_is_power"
end

modifier_money_is_power = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_money_is_power:IsHidden()
	return true
end

function modifier_money_is_power:IsPurgeException()
	return false
end

function modifier_money_is_power:IsPurgable()
	return false
end

function modifier_money_is_power:IsPermanent()
	return true
end


function modifier_money_is_power:OnCreated( kv )
	if IsServer() then
		local gold  = self:GetCaster():GetGold()
		self.gold = math.floor(gold/100)
		print(self.gold)
      self:StartIntervalThink(0.25)
	  self:OnIntervalThink()
    end
end


function modifier_money_is_power:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
       
	}

	return funcs
end

function modifier_money_is_power:OnIntervalThink()
	self:ForceRefresh()

end
function modifier_money_is_power:OnRefresh()
	if IsServer() then
		local gold  = self:GetCaster():GetGold()
		self.gold = math.floor(gold/100)
		print(self.gold)
	end
end
function modifier_money_is_power:GetModifierBonusStats_Strength( params )
    return self.gold
end
