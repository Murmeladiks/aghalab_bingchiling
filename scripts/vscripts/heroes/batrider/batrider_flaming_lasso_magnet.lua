batrider_flaming_lasso_magnet = class( {} )

LinkLuaModifier( "modifier_batrider_flaming_lasso_magnet", "heroes/batrider/batrider_flaming_lasso_magnet", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_batrider_flaming_lasso_magnet_buff", "heroes/batrider/batrider_flaming_lasso_magnet", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_batrider_flaming_lasso_magnet_buffer", "heroes/batrider/batrider_flaming_lasso_magnet", LUA_MODIFIER_MOTION_HORIZONTAL )
--------------------------------------------------------------------------------

function batrider_flaming_lasso_magnet:GetIntrinsicModifierName()
	return "modifier_batrider_flaming_lasso_magnet"
end


modifier_batrider_flaming_lasso_magnet = class({})
function modifier_batrider_flaming_lasso_magnet:IsPurgable()	return false end
function modifier_batrider_flaming_lasso_magnet:IsPermanent()	return true end
function modifier_batrider_flaming_lasso_magnet:IsHidden()   return true end

function modifier_batrider_flaming_lasso_magnet:OnCreated(kv)
  
end

function modifier_batrider_flaming_lasso_magnet:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_batrider_flaming_lasso_magnet:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "batrider_flaming_lasso" then
        return
    end

    self.ability = self:GetParent():FindAbilityByName("batrider_flaming_lasso")
    local duration = self.ability:GetSpecialValueFor("duration")
    
        if params.target and not params.target:IsNull() and not params.target:IsInvulnerable()  then 
            params.target:AddNewModifier(self:GetParent(),self.ability,"modifier_batrider_flaming_lasso_magnet_buff",{duration =duration})
        end
    
   
        
   
        
end

modifier_batrider_flaming_lasso_magnet_buff = class({})
function modifier_batrider_flaming_lasso_magnet_buff:IsPurgable()	return false end
function modifier_batrider_flaming_lasso_magnet_buff:IsPermanent()	return true end
function modifier_batrider_flaming_lasso_magnet_buff:IsHidden()   return true end

function modifier_batrider_flaming_lasso_magnet_buff:OnCreated(kv)
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.25)
end
function modifier_batrider_flaming_lasso_magnet_buff:OnIntervalThink()
    local Range = 300
    local point = self:GetParent():GetAbsOrigin()
    local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeamNumber(),	-- int, your team number
        point,	-- point, center point
        nil,	-- handle, cacheUnit. (not known)
        Range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
        DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_CLOSEST,	-- int, order filter
        false
    )
   
    
    for _, enemy in pairs(enemies) do
        if enemy and not enemy:IsNull() and not enemy:IsInvulnerable()  then
            if not enemy:HasModifier("modifier_batrider_flaming_lasso_magnet_buff") then
                if not enemy:HasModifier("modifier_batrider_flaming_lasso_magnet_buffer")  then
                    enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_batrider_flaming_lasso_magnet_buffer",{duration = self:GetAbility():GetSpecialValueFor("duration")}) 
                end 
            end
        end
    end
end

modifier_batrider_flaming_lasso_magnet_buffer = class({})

----------------------------------------------------------------------------------

function modifier_batrider_flaming_lasso_magnet_buffer:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_batrider_flaming_lasso_magnet_buffer:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

-----------------------------------------------------------------------

function modifier_batrider_flaming_lasso_magnet_buffer:GetOverrideAnimation( params )
	
		return ACT_DOTA_FLAIL

end

----------------------------------------------------------------------------------

function modifier_batrider_flaming_lasso_magnet_buffer:OnCreated( kv )
	if IsServer() then
	

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end



--------------------------------------------------------------------------------

function modifier_batrider_flaming_lasso_magnet_buffer:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
		
	end
end

--------------------------------------------------------------------------------

function  modifier_batrider_flaming_lasso_magnet_buffer:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_batrider_flaming_lasso_magnet_buffer:CheckState()
	local state =
	{
		[ MODIFIER_STATE_DISARMED ] = true,	
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_batrider_flaming_lasso_magnet_buffer:UpdateHorizontalMotion( me, dt )
	if IsServer() then
       
        me:SetOrigin( self:GetCaster():GetAbsOrigin() )
		

	end
end

