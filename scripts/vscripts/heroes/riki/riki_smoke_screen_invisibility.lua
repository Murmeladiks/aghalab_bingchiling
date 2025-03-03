riki_smoke_screen_invisibility = class( {} )

LinkLuaModifier( "modifier_riki_smoke_screen_invisibility", "heroes/riki/riki_smoke_screen_invisibility", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_smoke_screen_invisibility_thinker", "heroes/riki/riki_smoke_screen_invisibility", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function riki_smoke_screen_invisibility:GetIntrinsicModifierName()
	return "modifier_riki_smoke_screen_invisibility"
end

modifier_riki_smoke_screen_invisibility = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_riki_smoke_screen_invisibility:IsHidden()
	return true
end

function modifier_riki_smoke_screen_invisibility:IsPurgeException()
	return false
end

function modifier_riki_smoke_screen_invisibility:IsPurgable()
	return false
end

function modifier_riki_smoke_screen_invisibility:IsPermanent()
	return true
end



function modifier_riki_smoke_screen_invisibility:OnCreated(kv)
    if IsServer() then
		
    end
end

function modifier_riki_smoke_screen_invisibility:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
end

function modifier_riki_smoke_screen_invisibility:OnAbilityExecuted(params)
	if IsServer() then
		if params.unit == self:GetParent() and params.ability:GetAbilityName() == "riki_smoke_screen" then
			local cursorPos = params.ability:GetCursorPosition()
			
			if not cursorPos then
				return
			end

			local duration = params.ability:GetSpecialValueFor("AbilityDuration")
	
			CreateModifierThinker( self:GetParent(), params.ability, "modifier_riki_smoke_screen_invisibility_thinker", { duration = duration }, cursorPos, self:GetParent():GetTeamNumber(), false )
			
		end
	end
end

modifier_riki_smoke_screen_invisibility_thinker = class({})

----------------------------------------------------------------------------------------
function modifier_riki_smoke_screen_invisibility_thinker:IsHidden()
	return true
end
function modifier_riki_smoke_screen_invisibility_thinker:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.agi = self:GetCaster():GetAgility()

		self:OnIntervalThink()
		self:StartIntervalThink( 0.25 )
	end
end



----------------------------------------------------------------------------------------

function modifier_riki_smoke_screen_invisibility_thinker:OnIntervalThink()
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
               
				ally:AddNewModifier(self.caster, self:GetAbility(), "modifier_invisible", {duration = duration})
				
            end
        end	

	end
end


function modifier_riki_smoke_screen_invisibility_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

----------------------------------------------------------------------------------------

-- modifier_riki_smoke_screen_invisibility_thinker_buff = class({})
-- function modifier_riki_smoke_screen_invisibility_thinker_buff:IsHidden()
-- 	return true
-- end

-- function modifier_riki_smoke_screen_invisibility_thinker_buff:IsPurgable()
-- 	return false
-- end

-- function modifier_riki_smoke_screen_invisibility_thinker_buff:IsPurgeException()
-- 	return false
-- end

-- function modifier_riki_smoke_screen_invisibility_thinker_buff:IsPermanent()
-- 	return false
-- end

-- --------------------------------------------------------------------------------

-- function modifier_riki_smoke_screen_invisibility_thinker_buff:OnCreated( kv )
		
-- end
-- function modifier_riki_smoke_screen_invisibility_thinker_buff:OnRefresh( kv )
	

	
    
-- end
-- function modifier_riki_smoke_screen_invisibility_thinker_buff:AddStack( kv )	
-- 	self:ForceRefresh()
-- end



-- function modifier_riki_smoke_screen_invisibility_thinker_buff:CheckState()
-- 	local state =
-- 	{
		
--         [MODIFIER_STATE_INVISIBLE] = true,
        
-- 	}
-- 	return state
-- end


--------------------------------------------------------------------------------

