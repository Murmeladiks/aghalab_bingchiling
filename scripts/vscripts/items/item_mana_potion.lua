
item_mana_potion = class({})

--------------------------------------------------------------------------------

function item_mana_potion:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_mana_potion:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )

        local Heroes = HeroList:GetAllHeroes()

        for _,Hero in pairs ( Heroes ) do
            if Hero ~= nil and Hero:IsRealHero() and Hero:IsAlive() then
                Hero:EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
                local flManaAmount = Hero:GetMaxMana() * mana_restore_pct / 100
                Hero:GiveMana( flManaAmount)
                
                local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, Hero )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
            end
        end
        
        local container = self:GetContainer()

        self:SetCurrentCharges(1)
        self:SpendCharge(0)
    
        if container and not container:IsNull() then
            UTIL_Remove(container)
        end
    
        UTIL_Remove(self)
	end
end

--------------------------------------------------------------------------------
