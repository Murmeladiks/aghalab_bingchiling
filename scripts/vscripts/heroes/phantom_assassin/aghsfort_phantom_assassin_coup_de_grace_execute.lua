aghsfort_phantom_assassin_coup_de_grace_execute = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_coup_de_grace_execute", "heroes/phantom_assassin/aghsfort_phantom_assassin_coup_de_grace_execute", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function aghsfort_phantom_assassin_coup_de_grace_execute:Precache( context )
	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context )
end

function aghsfort_phantom_assassin_coup_de_grace_execute:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_coup_de_grace_execute"
end
modifier_aghsfort_phantom_assassin_coup_de_grace_execute = class({})
function modifier_aghsfort_phantom_assassin_coup_de_grace_execute:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_coup_de_grace_execute:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_coup_de_grace_execute:IsHidden()   return true end

function modifier_aghsfort_phantom_assassin_coup_de_grace_execute:OnCreated(kv)
	self.chance = 20
end

function modifier_aghsfort_phantom_assassin_coup_de_grace_execute:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_aghsfort_phantom_assassin_coup_de_grace_execute:OnAttackLanded(params)
    if not IsServer() then
        return
    end

    if params.attacker ~= self:GetParent() then
        return
    end

    

    self.ability = self:GetParent():FindAbilityByName("phantom_assassin_coup_de_grace")
	if self.ability and self.ability:GetLevel()> 0 then
		if params.target:HasModifier("modifier_phantom_assassin_mark_of_death") then
			local currentHP =  params.target:GetHealth()
			local maxHP = params.target:GetMaxHealth()
			if currentHP/maxHP < 0.3 then
				if  RollPseudoRandomPercentage(self.chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
					params.target:Kill(nil,self:GetCaster())
					print("victory!!")
					self:GetCaster():EmitSound("Hero_LegionCommander.Duel.Victory")
					
	
				end
			end
		end 
	end
   
        
        
   
        
end










