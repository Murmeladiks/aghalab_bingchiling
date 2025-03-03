
modifier_primal_beast_cinematic_controller = class({})

--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:OnCreated( kv )
	
end

--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:CheckState()
	
end

--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:DeclareFunctions()
	local funcs =
	{
		--MODIFIER_PROPERTY_MIN_HEALTH,
		--MODIFIER_EVENT_ON_DEATH_PREVENTED,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

-- function modifier_primal_beast_cinematic_controller:GetMinHealth( params )
-- 	return 1
-- end 


--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:OnDeath( params )
	if IsServer() then
		if self:GetParent() == params.unit then  --and self:GetParent().AI and self:GetParent().AI.Encounter and self:GetParent().AI.bDefeated == false and self:GetParent().AI.bInVictorySequence == false 
			print( "Outro Cinematic: Game Over - Players win!  Play Primal Beast Victory Sequence" )

			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_primal_beast_outro_aura", {} )

			local AlliedUnits = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			for _,Ally in pairs( AlliedUnits ) do
				if Ally:GetUnitName() == "aghsfort_primal_beast_rock_golem" or Ally:GetUnitName() == "aghsfort_primal_beast_rock" then
					Ally:ForceKill( false )
					FireGameEvent("entity_killed",

    {

      entindex_killed = Ally:entindex(),

      entindex_attacker = Ally:entindex(),

      entindex_inflictor = -1,

    }

  )	
				end
			end
		
			GameRules.Aghanim:MarkGameWon()
			self:GetParent():Interrupt()
			--GameRules.Aghanim:GetAnnouncer():SetServerAuthoritative( true )
			self:GetParent().AI.bInVictorySequence = true 
			self:GetParent().AI.Encounter.bInVictorySequence = true -- don't depend on the AI to set this.
		end
	end
end

--------------------------------------------------------------------------------

function modifier_primal_beast_cinematic_controller:OnIntervalThink()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------
