ogre_magi_bloodlust_ally_multicast = class( {} )

LinkLuaModifier( "modifier_ogre_magi_bloodlust_ally_multicast", "heroes/ogremagi/ogre_magi_bloodlust_ally_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_ally_multicast_buff", "heroes/ogremagi/ogre_magi_bloodlust_ally_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_ally_multicast_buff_proc", "heroes/ogremagi/ogre_magi_bloodlust_ally_multicast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point", "heroes/ogremagi/ogre_magi_bloodlust_ally_multicast", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ogre_magi_bloodlust_ally_multicast:GetIntrinsicModifierName()
	return "modifier_ogre_magi_bloodlust_ally_multicast"
end

modifier_ogre_magi_bloodlust_ally_multicast = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_bloodlust_ally_multicast:IsHidden()
	return true
end

function modifier_ogre_magi_bloodlust_ally_multicast:IsPurgeException()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast:IsPurgable()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast:IsPermanent()
	return true
end
function modifier_ogre_magi_bloodlust_ally_multicast:OnCreated(kv)
    if IsServer() then
		
    end
end



function modifier_ogre_magi_bloodlust_ally_multicast:DeclareFunctions()
	local funcs = {
        
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		
	}

	return funcs
end
function  modifier_ogre_magi_bloodlust_ally_multicast:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    
        
    if  params.ability:GetAbilityName() == "ogre_magi_bloodlust" then
		self.ogre_magi_bloodlust = self:GetParent():FindAbilityByName("ogre_magi_bloodlust")
		local duration = self.ogre_magi_bloodlust:GetSpecialValueFor("duration")
		local connectedPlayers = CAghanim:GetConnectedPlayers()
		self.ogre_magi_multicast = self:GetParent():FindAbilityByName("ogre_magi_multicast")
		if self.ogre_magi_multicast and self.ogre_magi_multicast:GetLevel()>0 then
			for _, nPlayerID in pairs(connectedPlayers) do
				if PlayerResource:IsValidPlayerID(nPlayerID) then
					local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
					if hPlayerHero:HasModifier("modifier_ogre_magi_bloodlust") then
						if  hPlayerHero ~=self:GetParent() then
							if not hPlayerHero:HasModifier("modifier_ogre_magi_bloodlust_ally_multicast_buff") then
								hPlayerHero:AddNewModifier(self:GetParent(),self.ogre_magi_multicast,"modifier_ogre_magi_bloodlust_ally_multicast_buff",{})
							end
						end
					end
				end
			end
		end
    end
   
    

end


modifier_ogre_magi_bloodlust_ally_multicast_buff = class({})


--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_bloodlust_ally_multicast_buff:IsHidden()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff:IsDebuff()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff:IsPurgable()
	return false
end
function modifier_ogre_magi_bloodlust_ally_multicast_buff:IsPermanent()
	return true
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ogre_magi_bloodlust_ally_multicast_buff:OnCreated( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) 
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) 
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) 

	self.buffer_range = 300
	
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff:OnRefresh( kv )
	-- references
	self.chance_2 = self:GetAbility():GetSpecialValueFor( "multicast_2_times" ) 
	self.chance_3 = self:GetAbility():GetSpecialValueFor( "multicast_3_times" ) 
	self.chance_4 = self:GetAbility():GetSpecialValueFor( "multicast_4_times" ) 
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff:OnRemoved()
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ogre_magi_bloodlust_ally_multicast_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff:OnAbilityFullyCast( params )
	if params.unit~=self:GetParent() then return end
	if params.ability==self:GetAbility() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end
	if not self:GetParent():HasModifier("modifier_ogre_magi_bloodlust") then return end

	if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end

	
	-- spells that have target
	if  params.target then  
		
		-- roll multicasts
		local casts = 1
		if RandomInt( 0,100 ) < self.chance_2 then casts = 2 end
		if RandomInt( 0,100 ) < self.chance_3 then casts = 3 end
		if RandomInt( 0,100 ) < self.chance_4 then casts = 4 end

		-- check delay
		local delay =  0.5

		-- only for fireblast multicast to single target
		local single =  false

		-- multicast
		self:GetParent():AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_ogre_magi_bloodlust_ally_multicast_buff_proc", -- modifier name
			{
				ability = params.ability:entindex(),
				target = params.target:entindex(),
				multicast = casts,
				delay = delay,
				single = single,
			} -- kv
		)
	elseif bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then 
		--spell both point and target
		local casts = 1
		if RandomInt( 0,100 ) < self.chance_2 then casts = 2 end
		if RandomInt( 0,100 ) < self.chance_3 then casts = 3 end
		if RandomInt( 0,100 ) < self.chance_4 then casts = 4 end

		-- check delay
		local delay =  0.5

		-- only for fireblast multicast to single target
		local single =  false
		local vPosition  = self:GetParent():GetCursorPosition()
		-- multicast
		self:GetParent():AddNewModifier(
			self:GetParent(), -- player source
			self:GetAbility(), -- ability source
			"modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point", -- modifier name
			{
				ability = params.ability:entindex(),
				multicast = casts,
				delay = delay,
				single = single,
				vPositionX = vPosition.x, 
				vPositionY = vPosition.y, 
				vPositionZ = vPosition.z
			} -- kv
		)

	end
	
end
modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:IsHidden()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:IsDebuff()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:IsStunDebuff()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:IsPurgable()
	return true
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:OnCreated( kv )
	if not IsServer() then return end
	-- load data
	self.caster = self:GetParent()
	self.ability = EntIndexToHScript( kv.ability )
	
	self.multicast = kv.multicast
	self.delay = kv.delay
	self.single = kv.single==1
	self.buffer_range = 300
	self.vPosition = Vector(kv.vPositionX, kv.vPositionY, kv.vPositionZ)
	
	-- set stack count
	self:SetStackCount( self.multicast )

	-- init multicast
	self.casts = 0
	if self.multicast==1 then
		-- no multicast if just 1
		self:Destroy()
		return
	end


	-- play effects
	self:PlayEffects( self.casts )

	-- Start interval
	self:StartIntervalThink( self.delay )
end
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:OnRefresh( kv )
	
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:OnRemoved()
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:OnIntervalThink()
	
	-- cast to target

    self.caster:SetCursorPosition(self.vPosition)
	self.ability:OnSpellStart()
	-- increment count
	self.casts = self.casts + 1
	if self.casts>=(self.multicast-1) then
		self:StartIntervalThink( -1 )
		self:Destroy()
	end

	-- play effects
	self:PlayEffects( self.casts )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc_point:PlayEffects( value )
	value = value + 1

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf"

	-- get data
	local counter_speed = 2
	if value==self.multicast then
		counter_speed = 1
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( value, counter_speed, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound = math.min( value-1, 3 )
	local sound_cast = "Hero_OgreMagi.Fireblast.x" .. sound
	if sound>0 then
		EmitSoundOn( sound_cast, self.caster )
	end
end
--------------------------------------------------------------------------------
modifier_ogre_magi_bloodlust_ally_multicast_buff_proc = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:IsHidden()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:IsDebuff()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:IsStunDebuff()
	return false
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:IsPurgable()
	return true
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:OnCreated( kv )
	if not IsServer() then return end
	-- load data
	self.caster = self:GetParent()
	self.ability = EntIndexToHScript( kv.ability )
	self.target = EntIndexToHScript( kv.target )
	self.multicast = kv.multicast
	self.delay = kv.delay
	self.single = kv.single==1
	self.buffer_range = 300

	-- set stack count
	self:SetStackCount( self.multicast )

	-- init multicast
	self.casts = 0
	if self.multicast==1 then
		-- no multicast if just 1
		self:Destroy()
		return
	end

	-- keep a table of targeted units
	self.targets = {}
	self.targets[self.target] = true

	-- get cast range
	self.radius = self.ability:GetCastRange( self.target:GetOrigin(), self.target ) + self.buffer_range

	-- get unit filters
	-- only target the same team as original target, even if the ability can cast on both team
	self.target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	if self.target:GetTeamNumber()~=self.caster:GetTeamNumber() then
		self.target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	-- if custom, findunitsinradius won't work
	self.target_type = self.ability:GetAbilityTargetType()
	if self.target_type==DOTA_UNIT_TARGET_CUSTOM then
		self.target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end

	-- only check for magic immunity piercing abilities
	self.target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
	if bit.band( self.ability:GetAbilityTargetFlags(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ) ~= 0 then
		self.target_flags = self.target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	
	-- play effects
	self:PlayEffects( self.casts )

	-- Start interval
	self:StartIntervalThink( self.delay )
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:OnRefresh( kv )
	
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:OnRemoved()
end

function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:OnIntervalThink()
	local current_target = nil

	if self.single then
		current_target = self.target
	else
		-- find valid targets
		local units = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			self.caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			self.target_team,	-- int, team filter
			self.target_type,	-- int, type filter
			self.target_flags,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- select valid target
		for _,unit in pairs(units) do
			-- not already a multicast target
			if not self.targets[unit] then

				-- check filter
				local filter = false
				if self.ability.CastFilterResultTarget then -- for customs
					filter = self.ability:CastFilterResultTarget( unit ) == UF_SUCCESS
				else
					filter = true
				end

				if filter then
					-- register unit
					self.targets[unit] = true
					current_target = unit

					break
				end
			end
		end

		-- if no one there, break multicast
		if not current_target then
			self:StartIntervalThink( -1 )
			self:Destroy()
			return
		end
	end

	-- cast to target
	self.caster:SetCursorCastTarget( current_target )
	self.ability:OnSpellStart()

	-- increment count
	self.casts = self.casts + 1
	if self.casts>=(self.multicast-1) then
		self:StartIntervalThink( -1 )
		self:Destroy()
	end

	-- play effects
	self:PlayEffects( self.casts )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ogre_magi_bloodlust_ally_multicast_buff_proc:PlayEffects( value )
	value = value + 1

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf"

	-- get data
	local counter_speed = 2
	if value==self.multicast then
		counter_speed = 1
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( value, counter_speed, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	local sound = math.min( value-1, 3 )
	local sound_cast = "Hero_OgreMagi.Fireblast.x" .. sound
	if sound>0 then
		EmitSoundOn( sound_cast, self.caster )
	end
end