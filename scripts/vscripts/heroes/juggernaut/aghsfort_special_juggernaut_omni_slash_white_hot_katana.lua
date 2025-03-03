aghsfort_special_juggernaut_omni_slash_white_hot_katana = class({})
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana", "heroes/juggernaut/aghsfort_special_juggernaut_omni_slash_white_hot_katana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff", "heroes/juggernaut/aghsfort_special_juggernaut_omni_slash_white_hot_katana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker", "heroes/juggernaut/aghsfort_special_juggernaut_omni_slash_white_hot_katana", LUA_MODIFIER_MOTION_NONE )
function aghsfort_special_juggernaut_omni_slash_white_hot_katana:GetIntrinsicModifierName()
	return "modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana"
end


modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:IsHidden()
    return true
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:IsPurgeException()
    return false
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:IsPurgable()
    return false
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:IsPermanent()
    return true
end



function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PRE_ATTACK,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:OnCreated(kv)
    if IsServer() then
        
    end
end
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:OnAbilityFullyCast(params)
    if not IsServer() then
        return
    end
    if params.unit ~= self:GetParent() then
        return
    end

    if params.ability:GetAbilityName() ~= "juggernaut_omni_slash" then
        return
    end
    
    local buffmodifier = params.unit:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker",{})
    print("thinking")
    if buffmodifier then
        buffmodifier:StartIntervalThink(0.1)
    end
    
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana:GetModifierPreAttack(params)
    if not IsServer() then
        return
    end
   

    
    if self:GetParent():HasModifier("modifier_juggernaut_omnislash") then
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_dragon_scale_burn", {duration = 5})
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
        
    end
end
modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker:IsHidden()
    return true
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker:IsPurgeException()
    return false
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker:IsPurgable()
    return false
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker:IsPermanent()
    return false
end
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker:OnCreated(kv)
    
    if IsServer() then
        self:OnIntervalThink()
        self:StartIntervalThink(0.1)
    end
end
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_thinker:OnIntervalThink()
    if IsServer() then
        print("no")
        if not self:GetParent():HasModifier("modifier_juggernaut_omnislash") then
           print("yes")
            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff", {duration = 2.5})
            
            self:StartIntervalThink(-1)
            
        end
    end
end

modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff:IsHidden()
    return true
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff:IsPurgeException()
    return false
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff:IsPurgable()
    return false
end

function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff:IsPermanent()
    return false
end
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff:OnCreated(kv)
    if IsServer() then
        local sound_cast = "Hero_Omniknight.GuardianAngel.Cast"
	    EmitSoundOn( sound_cast, self:GetParent() )
        self:PlayEffects()
    end
end
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff:CheckState()
 

    local hState = {
        [MODIFIER_STATE_INVULNERABLE] = true,  
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    

    return hState
end
function modifier_aghsfort_special_juggernaut_omni_slash_white_hot_katana_buff:PlayEffects()
	local sound_cast = "Hero_Omniknight.GuardianAngel"
	EmitSoundOn( sound_cast, self:GetParent() )

	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf"

	 local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	
	

	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end