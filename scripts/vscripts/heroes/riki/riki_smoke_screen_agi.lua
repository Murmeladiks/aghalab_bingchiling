riki_smoke_screen_agi = class( {} )

LinkLuaModifier( "modifier_riki_smoke_screen_agi", "heroes/riki/riki_smoke_screen_agi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_smoke_screen_agi_thinker", "heroes/riki/riki_smoke_screen_agi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_smoke_screen_agi_thinker_buff", "heroes/riki/riki_smoke_screen_agi", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function riki_smoke_screen_agi:GetIntrinsicModifierName()
	return "modifier_riki_smoke_screen_agi"
end

modifier_riki_smoke_screen_agi = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_smoke_screen_agi:IsHidden()
	return true
end

function modifier_riki_smoke_screen_agi:IsPurgeException()
	return false
end

function modifier_riki_smoke_screen_agi:IsPurgable()
	return false
end

function modifier_riki_smoke_screen_agi:IsPermanent()
	return true
end



function modifier_riki_smoke_screen_agi:OnCreated(kv)
    if IsServer() then
		
    end
end

function modifier_riki_smoke_screen_agi:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_riki_smoke_screen_agi:OnAbilityExecuted(params)
	if IsServer() then
		if params.unit == self:GetParent() and params.ability:GetAbilityName() == "riki_smoke_screen" then
			local cursorPos = params.ability:GetCursorPosition()
			
			if not cursorPos then
				return
			end

			local duration = params.ability:GetSpecialValueFor("AbilityDuration")
	
			CreateModifierThinker( self:GetParent(), params.ability, "modifier_riki_smoke_screen_agi_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
			
		end
	end
end

modifier_riki_smoke_screen_agi_thinker = class({})

----------------------------------------------------------------------------------------
function modifier_riki_smoke_screen_agi_thinker:IsHidden()
	return true
end
function modifier_riki_smoke_screen_agi_thinker:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.agi = self:GetCaster():GetAgility()

		self:OnIntervalThink()
		self:StartIntervalThink( 0.5 )
	end
end



----------------------------------------------------------------------------------------

function modifier_riki_smoke_screen_agi_thinker:OnIntervalThink()
	if IsServer() then
		if not self.caster or self.caster:IsNull() then
			self:Destroy()
			return
		end
		local duration = self:GetAbility():GetSpecialValueFor("AbilityDuration")
		--enemies
		
		local allies = FindUnitsInRadius(
            self:GetParent():GetTeamNumber(),
            self:GetParent():GetOrigin(),
            nil,
            self.radius + 50, 
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_HERO,
            0,
            FIND_ANY_ORDER,
            false 
        )

        for _,ally in pairs( allies ) do
            if ally and ally:IsAlive() then
                if not ally:HasModifier("modifier_riki_smoke_screen_agi_thinker_buff") then
					ally:AddNewModifier(self.caster, self:GetAbility(), "modifier_riki_smoke_screen_agi_thinker_buff", {duration = duration})
				else
					local buff = ally:FindModifierByName("modifier_riki_smoke_screen_agi_thinker_buff")
					if buff then
						buff:AddStack()
					end
				end
            end
        end	

	end
end


function modifier_riki_smoke_screen_agi_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

----------------------------------------------------------------------------------------

modifier_riki_smoke_screen_agi_thinker_buff = class({})
function modifier_riki_smoke_screen_agi_thinker_buff:IsHidden()
	return true
end

function modifier_riki_smoke_screen_agi_thinker_buff:IsPurgable()
	return false
end

function modifier_riki_smoke_screen_agi_thinker_buff:IsPurgeException()
	return false
end

function modifier_riki_smoke_screen_agi_thinker_buff:IsPermanent()
	return false
end

--------------------------------------------------------------------------------

function modifier_riki_smoke_screen_agi_thinker_buff:OnCreated( kv )
	
	self.agi  = 2
	
	self:SetHasCustomTransmitterData(true)
end
function modifier_riki_smoke_screen_agi_thinker_buff:OnRefresh( kv )
	
	self.agi  = 2
	
    
end
function modifier_riki_smoke_screen_agi_thinker_buff:AddStack( kv )
	self:IncrementStackCount()
	self:ForceRefresh()
end
function  modifier_riki_smoke_screen_agi_thinker_buff:AddCustomTransmitterData()
    return {
       
	
		agi=self.agi ,
		
    }
end
function  modifier_riki_smoke_screen_agi_thinker_buff:HandleCustomTransmitterData( data )

	  self.agi =data.agi
	  
end



function modifier_riki_smoke_screen_agi_thinker_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		
	}

	return funcs
end



function modifier_riki_smoke_screen_agi_thinker_buff:GetModifierBonusStats_Agility(params)
    return self.agi*self:GetStackCount()
end


--------------------------------------------------------------------------------

