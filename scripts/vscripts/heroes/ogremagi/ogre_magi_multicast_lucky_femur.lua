ogre_magi_multicast_lucky_femur = class( {} )

LinkLuaModifier( "modifier_ogre_magi_multicast_lucky_femur", "heroes/ogremagi/ogre_magi_multicast_lucky_femur", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ogre_magi_multicast_lucky_femur:GetIntrinsicModifierName()
	return "modifier_ogre_magi_multicast_lucky_femur"
end

modifier_ogre_magi_multicast_lucky_femur = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ogre_magi_multicast_lucky_femur:IsHidden()
	return true
end

function modifier_ogre_magi_multicast_lucky_femur:IsPurgeException()
	return false
end

function modifier_ogre_magi_multicast_lucky_femur:IsPurgable()
	return false
end

function modifier_ogre_magi_multicast_lucky_femur:IsPermanent()
	return true
end
function modifier_ogre_magi_multicast_lucky_femur:OnCreated(kv)
    if IsServer() then

        self.itemsAllowed = true
        self.item_bottle = {

            --bottle
            item_bottle = true,
        }
        self.forbiddenItemsRefresh = {
            item_refresher = true,
            item_tome_of_greater_knowledge = true,
            item_tome_of_smaller_knowledge = true,
        }
       
    end
end

function modifier_ogre_magi_multicast_lucky_femur:OnRefresh( kv )
	-- references
	
end

function modifier_ogre_magi_multicast_lucky_femur:OnRemoved()
end

function modifier_ogre_magi_multicast_lucky_femur:OnDestroy()
end
function modifier_ogre_magi_multicast_lucky_femur:DeclareFunctions()
    local funcs = 
    {
       
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
       
    }
    return funcs
end


function modifier_ogre_magi_multicast_lucky_femur:OnAbilityFullyCast( params )
    if IsServer() then
        if params.unit ~= self:GetParent() then
            return
        end

        local Ability = params.ability

        if not Ability or Ability:IsNull()  or self.item_bottle[Ability:GetAbilityName()] then
            return
        end

        if self:GetAbility() == nil or self:GetAbility():IsCooldownReady() == false then
            return
        end


        if not self.itemsAllowed and Ability:IsItem() == true then
            return
        end

        if self.forbiddenItemsRefresh[Ability:GetAbilityName()] then
            return
        end
        self.ogre_magi_multicast = self:GetParent():FindAbilityByName("ogre_magi_multicast")
        if  self.ogre_magi_multicast:GetLevel()> 0 then  
            local refresh_pct = 25

            if RollPseudoRandomPercentage(refresh_pct, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_4, self:GetParent()) then
                local isAbilityWithCharges = not Ability:IsItem() and Ability:GetMaxAbilityCharges(Ability:GetLevel()) > 1

                if Ability:IsRefreshable() and not Ability:IsToggle() and (Ability:GetCooldownTimeRemaining() > 0 or isAbilityWithCharges) then
                    if Ability:IsItem() then
                        Ability:EndCooldown()
                    else
                        local maxCharges = Ability:GetMaxAbilityCharges(Ability:GetLevel())

                        --increase charges!
                        if maxCharges and maxCharges > 1 then
                            local currentCharges = Ability:GetCurrentAbilityCharges()
            
                            if currentCharges < maxCharges then
                                Ability:SetCurrentAbilityCharges(currentCharges + 1)
                            end
                        else
                            Ability:EndCooldown()
                        end
                    end
        
                
                    
        
                    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
                    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 2, 1 ) )
                    ParticleManager:ReleaseParticleIndex( nFXIndex )
                    EmitSoundOn( "Bogduggs.LuckyFemur", self:GetParent() )
                end
            end
        end
    end
end


