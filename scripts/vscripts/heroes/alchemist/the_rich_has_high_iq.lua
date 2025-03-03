the_rich_has_high_IQ = class( {} )

LinkLuaModifier( "modifier_the_rich_has_high_IQ", "heroes/alchemist/the_rich_has_high_IQ", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function the_rich_has_high_IQ:GetIntrinsicModifierName()
	return "modifier_the_rich_has_high_IQ"
end

modifier_the_rich_has_high_IQ = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_the_rich_has_high_IQ:IsHidden()
	return true
end

function modifier_the_rich_has_high_IQ:IsPurgeException()
	return false
end

function modifier_the_rich_has_high_IQ:IsPurgable()
	return false
end

function modifier_the_rich_has_high_IQ:IsPermanent()
	return true
end


function modifier_the_rich_has_high_IQ:OnCreated( kv )
	if IsServer() then
		local gold  = self:GetCaster():GetGold()
		self.gold = math.floor(gold/100)
		print(self.gold)
      self:StartIntervalThink(0.25)
	  self:OnIntervalThink()
    end
end


function modifier_the_rich_has_high_IQ:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
       
	}

	return funcs
end

function modifier_the_rich_has_high_IQ:OnIntervalThink()
	self:ForceRefresh()

end
function modifier_the_rich_has_high_IQ:OnRefresh()
	if IsServer() then
		local gold  = self:GetCaster():GetGold()
		self.gold = math.floor(gold/100)
		print(self.gold)
	end
end
function modifier_the_rich_has_high_IQ:GetModifierBonusStats_Intellect( params )
    return self.gold
end
