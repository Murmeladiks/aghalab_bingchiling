money_make_things_easier = class( {} )

LinkLuaModifier( "modifier_money_make_things_easier", "heroes/alchemist/money_make_things_easier", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function money_make_things_easier:GetIntrinsicModifierName()
	return "modifier_money_make_things_easier"
end

modifier_money_make_things_easier = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_money_make_things_easier:IsHidden()
	return true
end

function modifier_money_make_things_easier:IsPurgeException()
	return false
end

function modifier_money_make_things_easier:IsPurgable()
	return false
end

function modifier_money_make_things_easier:IsPermanent()
	return true
end


function modifier_money_make_things_easier:OnCreated( kv )
	if IsServer() then
		local gold  = self:GetCaster():GetGold()
		self.gold = math.floor(gold/100)
		print(self.gold)
      self:StartIntervalThink(0.25)
	  self:OnIntervalThink()
    end
end


function modifier_money_make_things_easier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
       
	}

	return funcs
end

function modifier_money_make_things_easier:OnIntervalThink()
	self:ForceRefresh()

end
function modifier_money_make_things_easier:OnRefresh()
	if IsServer() then
		local gold  = self:GetCaster():GetGold()
		self.gold = math.floor(gold/100)
		print(self.gold)
	end
end
function modifier_money_make_things_easier:GetModifierBonusStats_Agility( params )
    return self.gold
end
