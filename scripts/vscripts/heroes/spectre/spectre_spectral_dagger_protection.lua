spectre_spectral_dagger_protection= class( {} )

LinkLuaModifier( "modifier_spectre_spectral_dagger_protection", "heroes/spectre/spectre_spectral_dagger_protection", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function spectre_spectral_dagger_protection:GetIntrinsicModifierName()
	return "modifier_spectre_spectral_dagger_protection"
end



modifier_spectre_spectral_dagger_protection= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_spectre_spectral_dagger_protection:IsHidden()
	return true
end

function modifier_spectre_spectral_dagger_protection:IsPurgeException()
	return false
end

function modifier_spectre_spectral_dagger_protection:IsPurgable()
	return false
end

function modifier_spectre_spectral_dagger_protection:IsPermanent()
	return true
end


function modifier_spectre_spectral_dagger_protection:OnCreated( kv )
	if IsServer() then
        self.damagetake = 0
    end
end

function modifier_spectre_spectral_dagger_protection:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end



function  modifier_spectre_spectral_dagger_protection:OnTakeDamage(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
    
    self.spectre_spectral_dagger = self:GetParent():FindAbilityByName("spectre_spectral_dagger")
    if self.spectre_spectral_dagger  and self.spectre_spectral_dagger:GetLevel()>0 then
        
        if params.damage - 300 >= 0 then
            local count  = math.floor(params.damage/300)
            
            for i = 1, count, 1 do
                if params.unit then
                    self:GetParent():SetCursorCastTarget(params.unit)
                    self.spectre_spectral_dagger:OnSpellStart()
                else
                    break
                end
            end
        else
            self.damagetake = self.damagetake + params.damage
            if self.damagetake > 300 then
                if params.unit then 
                    self:GetParent():SetCursorCastTarget(params.unit)
                    self.spectre_spectral_dagger:OnSpellStart()
                    self.damagetake =0
                end
            end
        end

    end
end