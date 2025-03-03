boss_dark_willow_cursed_crown = class({})

----------------------------------------------------

function boss_dark_willow_cursed_crown:Precache( context )
end

----------------------------------------------------

function boss_dark_willow_cursed_crown:OnAbilityPhaseStart()
	if IsServer() == false then 
		return true
	end
	return true
end

----------------------------------------------------

function boss_dark_willow_cursed_crown:OnAbilityPhaseInterrupted()
	if IsServer() == false then 
		return
	end
end

----------------------------------------------------

function boss_dark_willow_cursed_crown:OnSpellStart()
	if IsServer() == false then 
		return
	end
end