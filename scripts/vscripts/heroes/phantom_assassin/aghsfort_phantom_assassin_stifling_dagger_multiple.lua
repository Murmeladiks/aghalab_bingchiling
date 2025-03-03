aghsfort_phantom_assassin_stifling_dagger_multiple = class( {} )

LinkLuaModifier( "modifier_aghsfort_phantom_assassin_stifling_dagger_multiple", "heroes/phantom_assassin/aghsfort_phantom_assassin_stifling_dagger_multiple", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function aghsfort_phantom_assassin_stifling_dagger_multiple:GetIntrinsicModifierName()
	return "modifier_aghsfort_phantom_assassin_stifling_dagger_multiple"
end


modifier_aghsfort_phantom_assassin_stifling_dagger_multiple = class({})
function modifier_aghsfort_phantom_assassin_stifling_dagger_multiple:IsPurgable()	return false end
function modifier_aghsfort_phantom_assassin_stifling_dagger_multiple:IsPermanent()	return true end
function modifier_aghsfort_phantom_assassin_stifling_dagger_multiple:IsHidden()   return true end
function modifier_aghsfort_phantom_assassin_stifling_dagger_multiple:OnCreated(kv)
   
end
modifier_aghsfort_phantom_assassin_stifling_dagger_multiple.critlevelchance ={}
modifier_aghsfort_phantom_assassin_stifling_dagger_multiple.critlevelchance[0.1] = 5  
modifier_aghsfort_phantom_assassin_stifling_dagger_multiple.critlevelchance[0.2] = 4  
modifier_aghsfort_phantom_assassin_stifling_dagger_multiple.critlevelchance[0.3] = 3 
modifier_aghsfort_phantom_assassin_stifling_dagger_multiple.critlevelchance[0.4] = 2 

function modifier_aghsfort_phantom_assassin_stifling_dagger_multiple:GetCritLevel()
    
    local sum = 0
    for k, v in pairs(self.critlevelchance) do
        sum = sum + k
    end
    local totalProbability = sum
    math.randomseed(Time())
    local randomValue = math.random()  
    local cumulativeProbability = 0
    for key, value in pairs(self.critlevelchance) do
        cumulativeProbability = cumulativeProbability + key   
        if randomValue < cumulativeProbability / totalProbability then 
           local crit_multiplier = value

            return crit_multiplier
        end
    end
    

end


function modifier_aghsfort_phantom_assassin_stifling_dagger_multiple:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end
function modifier_aghsfort_phantom_assassin_stifling_dagger_multiple:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "phantom_assassin_stifling_dagger" then
        return
    end

    local unit = self:GetParent()

    self.phantom_assassin_stifling_dagger = unit:FindAbilityByName("phantom_assassin_stifling_dagger")

    if not self.phantom_assassin_stifling_dagger or self.phantom_assassin_stifling_dagger:GetLevel() == 0 then
        return
    end
   
    local number = self:GetCritLevel()
    
   
    for i = 1, number do
        Timers:CreateTimer(i * 0.25, function ()
            if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsInvulnerable() then
                self:GetParent():SetCursorCastTarget(params.target)
                self.phantom_assassin_stifling_dagger:OnSpellStart()
            end    
        end)
    end
        
end

