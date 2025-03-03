snapfire_scatterblast_stopping_power = class( {} )

LinkLuaModifier( "modifier_snapfire_scatterblast_stopping_power", "heroes/snapfire/snapfire_scatterblast_stopping_power", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/snapfire/snapfire_scatterblast_stopping_power", LUA_MODIFIER_MOTION_BOTH )
--------------------------------------------------------------------------------

function snapfire_scatterblast_stopping_power:GetIntrinsicModifierName()
	return "modifier_snapfire_scatterblast_stopping_power"
end


modifier_snapfire_scatterblast_stopping_power = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_snapfire_scatterblast_stopping_power:IsHidden()
	return true
end

function modifier_snapfire_scatterblast_stopping_power:IsPurgeException()
	return false
end

function modifier_snapfire_scatterblast_stopping_power:IsPurgable()
	return false
end

function modifier_snapfire_scatterblast_stopping_power:IsPermanent()
	return true
end



function modifier_snapfire_scatterblast_stopping_power:OnCreated(kv)
    if IsServer() then
        
       
   
end
end
function modifier_snapfire_scatterblast_stopping_power:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end
function modifier_snapfire_scatterblast_stopping_power:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    if params.attacker ~= self:GetParent() then
        return
    end
     
    if params.inflictor and params.inflictor:GetAbilityName() == "aghsfort_snapfire_scatterblast" then
		self.snapfire_mortimer_kisses = params.attacker:FindAbilityByName("snapfire_mortimer_kisses")
       local origin =params.attacker:GetOrigin()
       local duration = 0.3
	    local distance = 300
        local enemy_direction = (params.unit:GetOrigin() - origin):Normalized()
        params.unit:AddNewModifier(
            params.attacker,
            self:GetAbility(),
            "modifier_generic_knockback_lua",
            {
                duration = duration,
                distance = distance,
                height = 30,
                direction_x = enemy_direction.x,
                direction_y = enemy_direction.y,
            } 
        )
		
		if self.snapfire_mortimer_kisses:GetLevel()>0 then
			local durationkiss = self.snapfire_mortimer_kisses:GetSpecialValueFor("burn_linger_duration")
			params.unit:AddNewModifier(
            params.attacker,
            self.snapfire_mortimer_kisses,
            "modifier_snapfire_magma_burn_slow",
            {
                duration = durationkiss,
            
            } 
        )
		end
        
     end
    
end
modifier_generic_knockback_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_knockback_lua:IsHidden()
	return true
end

function modifier_generic_knockback_lua:IsPurgable()
	return false
end

function modifier_generic_knockback_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_knockback_lua:OnCreated( kv )
	if IsServer() then
		-- creation data (default)
			-- kv.distance (0)
			-- kv.height (-1)
			-- kv.duration (0)
			-- kv.direction_x, kv.direction_y, kv.direction_z (xy:-forward vector, z:0)
			-- kv.tree_destroy_radius (hull-radius), can be null if -1 
			-- kv.IsStun (false)
			-- kv.IsFlail (true)
			-- kv.IsPurgable() // later 
			-- kv.IsMultiple() // later

		-- references
		self.distance = kv.distance or 0
		self.height = kv.height or -1
		self.duration = kv.duration or 0
		if kv.direction_x and kv.direction_y then
			self.direction = Vector(kv.direction_x,kv.direction_y,0):Normalized()
		else
			self.direction = -(self:GetParent():GetForwardVector())
		end
		self.tree = kv.tree_destroy_radius or self:GetParent():GetHullRadius()

		if kv.IsStun then self.stun = kv.IsStun==1 else self.stun = false end
		if kv.IsFlail then self.flail = kv.IsFlail==1 else self.flail = true end

		-- check duration
		if self.duration == 0 then
			self:Destroy()
			return
		end

		-- load data
		self.parent = self:GetParent()
		self.origin = self.parent:GetOrigin()

		-- horizontal init
		self.hVelocity = self.distance/self.duration

		-- vertical init
		local half_duration = self.duration/2
		self.gravity = 2*self.height/(half_duration*half_duration)
		self.vVelocity = self.gravity*half_duration

		-- apply motion controllers
		if self.distance>0 then
			if self:ApplyHorizontalMotionController() == false then 
				self:Destroy()
				return
			end
		end
		if self.height>=0 then
			if self:ApplyVerticalMotionController() == false then 
				self:Destroy()
				return
			end
		end

		-- tell client of activity
		if self.flail then
			self:SetStackCount( 1 )
		elseif self.stun then
			self:SetStackCount( 2 )
		end
	else
		self.anim = self:GetStackCount()
		self:SetStackCount( 0 )
	end
end

function modifier_generic_knockback_lua:OnRefresh( kv )
	if not IsServer() then return end
end

function modifier_generic_knockback_lua:OnDestroy( kv )
	if not IsServer() then return end

	if not self.interrupted then
		-- destroy trees
		if self.tree>0 then
			GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree, true )
		end
	end

	if self.EndCallback then
		self.EndCallback( self.interrupted )
	end

	self:GetParent():InterruptMotionControllers( true )
end

--------------------------------------------------------------------------------
-- Setter
function modifier_generic_knockback_lua:SetEndCallback( func ) 
	self.EndCallback = func
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_knockback_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_generic_knockback_lua:GetOverrideAnimation( params )
	if self.anim==1 then
		return ACT_DOTA_FLAIL
	elseif self.anim==2 then
		return ACT_DOTA_DISABLED
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_generic_knockback_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.stun,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_generic_knockback_lua:UpdateHorizontalMotion( me, dt )
	local parent = self:GetParent()
	
	-- set position
	local target = self.direction*self.distance*(dt/self.duration)

	-- change position
	parent:SetOrigin( parent:GetOrigin() + target )
end

function modifier_generic_knockback_lua:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_generic_knockback_lua:UpdateVerticalMotion( me, dt )
	-- set time
	local time = dt/self.duration

	-- change height
	self.parent:SetOrigin( self.parent:GetOrigin() + Vector( 0, 0, self.vVelocity*dt ) )

	-- calculate vertical velocity
	self.vVelocity = self.vVelocity - self.gravity*dt
end

function modifier_generic_knockback_lua:OnVerticalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_generic_knockback_lua:GetEffectName()
	if not IsServer() then return end
	if self.stun then
		return "particles/generic_gameplay/generic_stunned.vpcf"
	end
end

function modifier_generic_knockback_lua:GetEffectAttachType()
	if not IsServer() then return end
	return PATTACH_OVERHEAD_FOLLOW
end
   
    



