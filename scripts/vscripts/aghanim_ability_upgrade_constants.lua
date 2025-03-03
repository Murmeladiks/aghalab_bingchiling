LinkLuaModifier( "modifier_minor_ability_upgrades", "modifiers/modifier_minor_ability_upgrades", LUA_MODIFIER_MOTION_NONE )

_G.MINOR_ABILITY_UPGRADE_OP_ADD = 1
_G.MINOR_ABILITY_UPGRADE_OP_MUL = 2

_G.MINOR_ABILITY_COOLDOWN_MANACOST_PCT = 7

_G.MINOR_ABILITY_UPGRADES =
{
   npc_dota_hero_kez = require( "minor_ability_upgrades/minor_ability_upgrades_kez" ),
   npc_dota_hero_magnataur = require( "minor_ability_upgrades/minor_ability_upgrades_magnataur" ),
   npc_dota_hero_phantom_assassin = require( "minor_ability_upgrades/minor_ability_upgrades_phantom_assassin" ),
   npc_dota_hero_snapfire = require( "minor_ability_upgrades/minor_ability_upgrades_snapfire" ),
   npc_dota_hero_disruptor = require( "minor_ability_upgrades/minor_ability_upgrades_disruptor" ),
   npc_dota_hero_winter_wyvern = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_tusk = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_ursa = require( "minor_ability_upgrades/minor_ability_upgrades_ursa" ),
   npc_dota_hero_sniper = require( "minor_ability_upgrades/minor_ability_upgrades_sniper" ),
   npc_dota_hero_mars = require( "minor_ability_upgrades/minor_ability_upgrades_mars" ),
   npc_dota_hero_viper = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_weaver = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_omniknight = require( "minor_ability_upgrades/minor_ability_upgrades_omniknight" ),
   npc_dota_hero_witch_doctor = require( "minor_ability_upgrades/minor_ability_upgrades_witch_doctor" ),
   npc_dota_hero_templar_assassin = require( "minor_ability_upgrades/minor_ability_upgrades_templar_assassin" ),
   npc_dota_hero_slark = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_queenofpain = require( "minor_ability_upgrades/minor_ability_upgrades_queenofpain" ),
   npc_dota_hero_undying = require( "minor_ability_upgrades/minor_ability_upgrades_undying" ),
   npc_dota_hero_juggernaut = require( "minor_ability_upgrades/minor_ability_upgrades_juggernaut" ),
   npc_dota_hero_drow_ranger = require( "minor_ability_upgrades/minor_ability_upgrades_drow_ranger" ),
   npc_dota_hero_luna = require( "minor_ability_upgrades/minor_ability_upgrades_luna" ),
   npc_dota_hero_void_spirit = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_lich = require( "minor_ability_upgrades/minor_ability_upgrades_lich" ),
   npc_dota_hero_lina = require( "minor_ability_upgrades/minor_ability_upgrades_lina" ),
   npc_dota_hero_gyrocopter = require( "minor_ability_upgrades/minor_ability_upgrades_gyrocopter" ),
   npc_dota_hero_dawnbreaker = require( "minor_ability_upgrades/minor_ability_upgrades_dawnbreaker" ),
   npc_dota_hero_bane = require( "minor_ability_upgrades/minor_ability_upgrades_bane" ),
   npc_dota_hero_phoenix = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_kunkka = require( "minor_ability_upgrades/minor_ability_upgrades_kunkka" ),
   npc_dota_hero_sand_king = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_clinkz = require( "minor_ability_upgrades/minor_ability_upgrades_clinkz" ),
   npc_dota_hero_invoker = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
   npc_dota_hero_abaddon  = require( "minor_ability_upgrades/minor_ability_upgrades_abaddon" ),
    
   
   npc_dota_hero_abyssal_underlord  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_alchemist  = require( "minor_ability_upgrades/minor_ability_upgrades_alchemist" ),
 

   npc_dota_hero_ancient_apparition  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_antimage  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_arc_warden  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_axe  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_batrider  = require( "minor_ability_upgrades/minor_ability_upgrades_batrider" ),
 

   npc_dota_hero_beastmaster  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_bloodseeker  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 
 
   npc_dota_hero_bounty_hunter  = require( "minor_ability_upgrades/minor_ability_upgrades_bounty_hunter" ),
 

   npc_dota_hero_brewmaster  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_bristleback  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_broodmother  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_centaur  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_chaos_knight  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_chen  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

 

   npc_dota_hero_crystal_maiden  = require( "minor_ability_upgrades/minor_ability_upgrades_crystal_maiden" ),
 

   npc_dota_hero_dark_seer  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_dark_willow  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_dazzle  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_death_prophet  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_doom_bringer  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_dragon_knight  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_earth_spirit  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_earthshaker  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_elder_titan  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_ember_spirit  = require( "minor_ability_upgrades/minor_ability_upgrades_ember_spirit" ),
 

   npc_dota_hero_enchantress  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_enigma  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_faceless_void  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_furion  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_grimstroke  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_hoodwink  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_huskar  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_jakiro  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_keeper_of_the_light  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_legion_commander  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_leshrac  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_life_stealer  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_lion  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_lycan  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_marci  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_medusa  = require( "minor_ability_upgrades/minor_ability_upgrades_medusa" ),
 

   npc_dota_hero_meepo  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_mirana  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_monkey_king  = require( "minor_ability_upgrades/minor_ability_upgrades_monkey_king" ),
 

   npc_dota_hero_morphling  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_muerta  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_naga_siren  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_necrolyte  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_nevermore  = require( "minor_ability_upgrades/minor_ability_upgrades_nevermore" ),
 

   npc_dota_hero_night_stalker  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_nyx_assassin  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_obsidian_destroyer  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_ogre_magi  = require( "minor_ability_upgrades/minor_ability_upgrades_ogre_magi" ),
 
 
   npc_dota_hero_oracle  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_pangolier  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 
 

   npc_dota_hero_phantom_lancer  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_primal_beast  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_puck  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_pudge  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_pugna  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_rattletrap  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_razor  = require( "minor_ability_upgrades/minor_ability_upgrades_razor" ),
 

   npc_dota_hero_riki  = require( "minor_ability_upgrades/minor_ability_upgrades_riki" ),
 

   npc_dota_hero_rubick  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_shadow_demon  = require( "minor_ability_upgrades/minor_ability_upgrades_shadow_demon" ),
 

   npc_dota_hero_shadow_shaman  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_shredder  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_silencer  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_skeleton_king  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_skywrath_mage  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_slardar  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 



   npc_dota_hero_spectre  = require( "minor_ability_upgrades/minor_ability_upgrades_spectre" ),
 

   npc_dota_hero_spirit_breaker  = require( "minor_ability_upgrades/minor_ability_upgrades_spirit_breaker"  ),
 

   npc_dota_hero_storm_spirit  = require( "minor_ability_upgrades/minor_ability_upgrades_storm_spirit" ),
 

   npc_dota_hero_sven  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_techies  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

 

   npc_dota_hero_terrorblade  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_tidehunter  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_tinker  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_tiny  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_treant  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_troll_warlord  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_vengefulspirit  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_venomancer  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_visage  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_warlock  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_windrunner  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   npc_dota_hero_wisp  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 


   npc_dota_hero_zuus  = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
 

   --non hero specific upgrades (bonus HP/mana/damage/etc.)
   base_stats_upgrades = require( "minor_ability_upgrades/base_minor_stats_upgrades" ),
}

_G.STAT_UPGRADE_EXCLUDES =
{
   npc_dota_hero_omniknight =
   {
      "aghsfort_minor_stat_upgrade_bonus_attack_speed",
   },

    npc_dota_hero_magnataur = 
    {
       "aghsfort_minor_stat_upgrade_bonus_health",
    },
   
   npc_dota_hero_winter_wyvern = 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_disruptor =
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_snapfire = 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_tusk = 
   {
      "aghsfort_minor_stat_upgrade_bonus_health",
   },

   npc_dota_hero_ursa = 
   {
      "aghsfort_minor_stat_upgrade_bonus_spell_amp",
   },

   npc_dota_hero_sniper = 
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_mars = 
   {
      "aghsfort_minor_stat_upgrade_bonus_health",
   },

   npc_dota_hero_viper = 
   {
      "aghsfort_minor_stat_upgrade_bonus_magic_resist",
   },

   npc_dota_hero_weaver = 
   {
      "aghsfort_minor_stat_upgrade_bonus_spell_amp",
   },

   npc_dota_hero_witch_doctor = 
   {
      "aghsfort_minor_stat_upgrade_bonus_attack_damage",
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },
   npc_dota_hero_kez = {},
   npc_dota_hero_queenofpain = 
   {
   },

   npc_dota_hero_templar_assassin = 
   {
   },

   npc_dota_hero_slark = 
   {
   },

   npc_dota_hero_lich =
   {
      "aghsfort_minor_stat_upgrade_bonus_evasion",
   },

   npc_dota_hero_luna =
   {
   },

   npc_dota_hero_kunkka = 
   {
   },

   npc_dota_hero_undying = 
   {
   },

   npc_dota_hero_juggernaut =
   {
   },

   npc_dota_hero_drow_ranger =
   {
   },

   npc_dota_hero_void_spirit = 
   {
   },
   npc_dota_hero_lina = 
   {
   },   
   npc_dota_hero_gyrocopter = 
   {
   }, 
   npc_dota_hero_dawnbreaker = 
   {
   }, 

   npc_dota_hero_bane = 
   {
   },      

   npc_dota_hero_phoenix = 
   {
   },

   npc_dota_hero_sand_king = 
   {
   },

   npc_dota_hero_clinkz = 
   {
   },
   npc_dota_hero_invoker =
   {},
   npc_dota_hero_abaddon  ={},  
   npc_dota_hero_abyssal_underlord  ={},  
   npc_dota_hero_alchemist  ={},  
   npc_dota_hero_ancient_apparition  ={},  
   npc_dota_hero_antimage  ={},  
   npc_dota_hero_arc_warden  ={},  
   npc_dota_hero_axe  ={},  
 
   npc_dota_hero_batrider  ={},  
   npc_dota_hero_beastmaster  ={},  
   npc_dota_hero_bloodseeker  ={},  
   npc_dota_hero_bounty_hunter  ={},  
   npc_dota_hero_brewmaster  ={},  
   npc_dota_hero_bristleback  ={},  
   npc_dota_hero_broodmother  ={},  
   npc_dota_hero_centaur  ={},  
   npc_dota_hero_chaos_knight  ={},  
   npc_dota_hero_chen  ={},  
   npc_dota_hero_crystal_maiden  ={},  
   npc_dota_hero_dark_seer  ={},  
   npc_dota_hero_dark_willow  ={},  

   npc_dota_hero_dazzle  ={},  
   npc_dota_hero_death_prophet  ={},  

   npc_dota_hero_doom_bringer  ={},  
   npc_dota_hero_dragon_knight  ={},  

   npc_dota_hero_earth_spirit  ={},  
   npc_dota_hero_earthshaker  ={},  
   npc_dota_hero_elder_titan  ={},  
   npc_dota_hero_ember_spirit  ={},  
   npc_dota_hero_enchantress  ={},  
   npc_dota_hero_enigma  ={},  
   npc_dota_hero_faceless_void  ={},  
   npc_dota_hero_furion  ={},  
   npc_dota_hero_grimstroke  ={},  

   npc_dota_hero_hoodwink     ={},
   npc_dota_hero_huskar  ={},  
   npc_dota_hero_jakiro  ={},  

   npc_dota_hero_keeper_of_the_light  ={},  

   npc_dota_hero_legion_commander  ={},  
   npc_dota_hero_leshrac  ={},  
  
   npc_dota_hero_life_stealer  ={},  

   npc_dota_hero_lion  ={},  

   npc_dota_hero_lycan  ={},  
   npc_dota_hero_marci  ={},
 
   npc_dota_hero_medusa  ={},  
   npc_dota_hero_meepo  ={},  
   npc_dota_hero_mirana  ={},  
   npc_dota_hero_monkey_king  ={},  
   npc_dota_hero_morphling  ={},  
   npc_dota_hero_muerta  ={},  
   npc_dota_hero_naga_siren  ={},  
   npc_dota_hero_necrolyte  ={},  
   npc_dota_hero_nevermore  ={},  
   npc_dota_hero_night_stalker  ={},  
   npc_dota_hero_nyx_assassin  ={},  
   npc_dota_hero_obsidian_destroyer  ={},  
   npc_dota_hero_ogre_magi  ={},  
   npc_dota_hero_oracle  ={},  
   npc_dota_hero_pangolier  ={},  
   npc_dota_hero_phantom_assassin  ={},  
   npc_dota_hero_phantom_lancer  ={},  
  
   npc_dota_hero_primal_beast     ={},
   npc_dota_hero_puck  ={},  
   npc_dota_hero_pudge  ={},  
   npc_dota_hero_pugna  ={},  

   npc_dota_hero_rattletrap  ={},  
   npc_dota_hero_razor  ={},  
   npc_dota_hero_riki  ={},  
   npc_dota_hero_rubick  ={},  
   npc_dota_hero_shadow_demon  ={},  
   npc_dota_hero_shadow_shaman  ={},  
   npc_dota_hero_shredder  ={},  
   npc_dota_hero_silencer  ={},  
   npc_dota_hero_skeleton_king  ={},  
   npc_dota_hero_skywrath_mage  ={},  
   npc_dota_hero_slardar  ={},  


   npc_dota_hero_spectre  ={},  
   npc_dota_hero_spirit_breaker  ={},  
   npc_dota_hero_storm_spirit  ={},  
   npc_dota_hero_sven  ={},  
   npc_dota_hero_techies  ={},  

   npc_dota_hero_terrorblade  ={},  
   npc_dota_hero_tidehunter  ={},  
   npc_dota_hero_tinker  ={},  
   npc_dota_hero_tiny  ={},  
   npc_dota_hero_treant  ={},  
   npc_dota_hero_troll_warlord  ={},  
  
 
   npc_dota_hero_vengefulspirit  ={},  
   npc_dota_hero_venomancer   ={},
   npc_dota_hero_visage  ={},  

   npc_dota_hero_warlock  ={},  
  
   npc_dota_hero_windrunner  ={},   
   npc_dota_hero_wisp  ={},  

   npc_dota_hero_zuus  ={},  
}

-- NOTE: These are substrings to search for in SPECIAL_ABILITY_UPGRADES
_G.ULTIMATE_ABILITY_NAMES =
{
    npc_dota_hero_omniknight = "omniknight_guardian_angel",
   npc_dota_hero_magnataur = "magnataur_reverse_polarity",
    npc_dota_hero_phantom_assassin = "phantom_assassin_coup_de_grace",
   -- npc_dota_hero_winter_wyvern = "winter_wyvern_winters_curse",
    npc_dota_hero_disruptor = "disruptor_static_storm",
    npc_dota_hero_snapfire = "snapfire_mortimer_kisses", 
    --npc_dota_hero_tusk = "tusk_walrus_punch",
    npc_dota_hero_ursa = "ursa_enrage",
    npc_dota_hero_sniper = "sniper_assassinate",
    npc_dota_hero_mars = "mars_arena_of_blood",
   -- npc_dota_hero_viper = "_strike", -- Not "viper_viper_strike" because the viper strike names in SPECIAL_ABILITY_UPGRADES are wierd
   -- npc_dota_hero_weaver = "weaver_time_lapse",
    npc_dota_hero_witch_doctor = "witch_doctor_death_ward",
    npc_dota_hero_queenofpain = "queenofpain_sonic_wave",
    npc_dota_hero_templar_assassin = "templar_assassin_psionic_trap",
    --npc_dota_hero_slark = "slark_shadow_dance",
    npc_dota_hero_lina = "lina_laguna_blade",
   npc_dota_hero_juggernaut = "juggernaut_omni_slash",
   -- npc_dota_hero_drow_ranger = "drow_ranger_marksmanship",
   -- npc_dota_hero_luna = "luna_eclipse",
   -- npc_dota_hero_lich = "lich_chain_frost",
   -- npc_dota_hero_kunkka = "kunkka_ghostship",
    npc_dota_hero_undying = "undying_flesh_golem",
   -- npc_dota_hero_void_spirit = "void_spirit_astral_step",
   npc_dota_hero_gyrocopter = "gyrocopter_call_down",
   -- npc_dota_hero_dawnbreaker = "dawnbreaker_solar_guardian",
   -- npc_dota_hero_bane = "bane_fiends_grip",
   -- npc_dota_hero_phoenix = "phoenix_supernova",
   -- npc_dota_hero_sand_king = "sand_king_epicenter",
   -- npc_dota_hero_clinkz = "clinkz_burning_army",
   -- npc_dota_hero_invoker = "",
    npc_dota_hero_abaddon  ="",  
   -- npc_dota_hero_abyssal_underlord  ="",  
    npc_dota_hero_alchemist  ="",  
   -- npc_dota_hero_ancient_apparition  ="",  
   -- npc_dota_hero_antimage  ="",  
   -- npc_dota_hero_arc_warden  ="",  
   -- npc_dota_hero_axe  ="",   
    npc_dota_hero_batrider  ="",  
   -- npc_dota_hero_beastmaster  ="",  
    --npc_dota_hero_bloodseeker  ="",  
    npc_dota_hero_bounty_hunter  ="",  
   -- npc_dota_hero_brewmaster  ="",  
   -- npc_dota_hero_bristleback  ="",  
   -- npc_dota_hero_broodmother  ="",  
   -- npc_dota_hero_centaur  ="",  
   -- npc_dota_hero_chaos_knight  ="",  
   -- npc_dota_hero_chen  ="",   
    --npc_dota_hero_crystal_maiden  ="",  
   -- npc_dota_hero_dark_seer  ="",  
   -- npc_dota_hero_dark_willow  ="",  
   -- npc_dota_hero_dazzle  ="",  
   -- npc_dota_hero_death_prophet  ="",  
   -- npc_dota_hero_doom_bringer  ="",  
   -- npc_dota_hero_dragon_knight  ="",  
   -- npc_dota_hero_earth_spirit  ="",  
   -- npc_dota_hero_earthshaker  ="",  
   -- npc_dota_hero_elder_titan  ="",  
    npc_dota_hero_ember_spirit  ="",  
    --npc_dota_hero_enchantress  ="",  
   -- npc_dota_hero_enigma  ="",  
   -- npc_dota_hero_faceless_void  ="",  
   -- npc_dota_hero_furion  ="",  
   -- npc_dota_hero_grimstroke  ="",  
   -- npc_dota_hero_hoodwink     ="" ,
   -- npc_dota_hero_huskar  ="",  
   -- npc_dota_hero_jakiro  ="",  
   -- npc_dota_hero_keeper_of_the_light  ="",  
   -- npc_dota_hero_legion_commander  ="",  
   -- npc_dota_hero_leshrac  ="",  
   -- npc_dota_hero_life_stealer  ="",  
   -- npc_dota_hero_lion  ="",  
   -- npc_dota_hero_lycan  ="",  
   -- npc_dota_hero_marci  ="",
    npc_dota_hero_medusa  ="",  
   -- npc_dota_hero_meepo  ="",  
   -- npc_dota_hero_mirana  ="",  
    --npc_dota_hero_monkey_king  ="",  
   -- npc_dota_hero_morphling  ="",  
   -- npc_dota_hero_muerta  ="",  
   -- npc_dota_hero_naga_siren  ="",  
   -- npc_dota_hero_necrolyte  ="", 
   npc_dota_hero_kez ="", 
    npc_dota_hero_nevermore  ="",  
   -- npc_dota_hero_night_stalker  ="",  
   -- npc_dota_hero_nyx_assassin  ="",  
   -- npc_dota_hero_obsidian_destroyer  ="",  
    npc_dota_hero_ogre_magi  ="",  
   -- npc_dota_hero_oracle  ="",  
   -- npc_dota_hero_pangolier  ="",  
   -- npc_dota_hero_phantom_lancer  ="",  
   -- npc_dota_hero_primal_beast      ="",
   -- npc_dota_hero_puck  ="",  
    --npc_dota_hero_pudge  ="",  
   -- npc_dota_hero_pugna  ="",   
   -- npc_dota_hero_rattletrap  ="",  
    npc_dota_hero_razor  ="",  
    npc_dota_hero_riki  ="",  
   -- npc_dota_hero_rubick  ="",  
    npc_dota_hero_shadow_demon  ="",  
   -- npc_dota_hero_shadow_shaman  ="",  
   -- npc_dota_hero_shredder  ="",  
   -- npc_dota_hero_silencer  ="",  
   -- npc_dota_hero_skeleton_king  ="",  
   -- npc_dota_hero_skywrath_mage  ="",  
   -- npc_dota_hero_slardar  ="",  
    npc_dota_hero_spectre  ="",  
    npc_dota_hero_spirit_breaker  ="",  
    --npc_dota_hero_storm_spirit  ="",  
   -- npc_dota_hero_sven  ="",  
   -- npc_dota_hero_techies  ="",  
   -- npc_dota_hero_terrorblade  ="",  
   -- npc_dota_hero_tidehunter  ="",  
   -- npc_dota_hero_tinker  ="",  
   -- npc_dota_hero_tiny  ="",  
   -- npc_dota_hero_treant  ="",  
   -- npc_dota_hero_troll_warlord  ="",  
   -- npc_dota_hero_vengefulspirit  ="",  
   -- npc_dota_hero_venomancer   ="",
   -- npc_dota_hero_visage  ="",  
   -- npc_dota_hero_warlock  ="",  
   -- npc_dota_hero_windrunner  ="",  
   -- npc_dota_hero_wisp  ="",  

   -- npc_dota_hero_zuus  ="",  
}

-- Lists for ability upgrades go here
_G.SPECIAL_ABILITY_UPGRADES = {}
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_abaddon"] ={
   "special_bonus_unique_abaddon_death_coil_heal", --变伤为奶 1
   "abaddon_borrowed_time_scepter",   --A  4
   "abaddon_death_coil_shard",         --shard 3
   "special_bonus_unique_abaddon_death_coil_aoe" ,  --AOE 1
   "abaddon_aphotic_shield_death_coil",  --加罩加奶 加奶加罩 奶罩合一 2
   "abaddon_aphotic_shield_attacked",     --挨打加罩 2
   "special_bonus_unique_abaddon_frostmourne_no_count",  --三技能不再计算攻击次数 3
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_abyssal_underlord"] ={
   "empty_undefined_ability"
}  
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_kez"] ={
   "empty_undefined_ability",
   "aghanim_scepter_ability",
   "kez_kazurai_katana_shard",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_alchemist"] ={
   "money_is_power",
   "money_make_things_easier",
   "the_rich_has_high_IQ",
   "warren_e_buffett",
   "alchemist_we_ogres",
   "alchemist_berserk_potion_shard",
   "alchemist_chemical_rage_potion",
   "alchemist_unstable_concoction_acid",


   --"alchemist_unstable_concoction_bounce",
   
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_ancient_apparition"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_antimage"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_arc_warden"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_axe"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_batrider"] ={
   "special_bonus_unique_batrider_sticky_napalm_infinity",
   "batrider_sticky_napalm_protection",
   "batrider_sticky_napalm_shard",
   "batrider_flamebreak_toss",
   "batrider_flamebreak_napalm",
   "batrider_flamebreak_protection",
   "batrider_firefly_allies",
   "batrider_firefly_enemies",
   "batrider_flaming_lasso_magnet",
   "batrider_flaming_lasso_scepter",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_beastmaster"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_bloodseeker"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_bounty_hunter"] ={
      "aghsfort_bounty_hunter_legend_toss_track",
      "aghsfort_bounty_hunter_legend_toss_jinada",
      "aghsfort_bounty_hunter_legend_toss_tripple",
   
      "aghsfort_bounty_hunter_legend_jinada_konyiji",
      "aghsfort_bounty_hunter_legend_jinada_loan",
      "aghsfort_bounty_hunter_legend_jinada_murder",
   
      "aghsfort_bounty_hunter_legend_walk_windy",
      "aghsfort_bounty_hunter_legend_walk_pickup",
      "aghsfort_bounty_hunter_legend_walk_track",
   
      "aghsfort_bounty_hunter_legend_track_invis",
      "aghsfort_bounty_hunter_legend_track_ally",
      "aghsfort_bounty_hunter_legend_track_pass",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_brewmaster"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_bristleback"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_broodmother"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_centaur"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_chaos_knight"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_chen"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_clinkz"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_crystal_maiden"] ={
      "aghsfort_rylai_legend_snowman",
      "aghsfort_rylai_legend_nova_strike",
      "aghsfort_rylai_legend_crystal_field",
   
       "aghsfort_rylai_legend_frost_chain",
       "aghsfort_rylai_legend_frost_touch",
       "aghsfort_rylai_legend_frost_split",
   
       "aghsfort_rylai_legend_arcane_field",
       "aghsfort_rylai_legend_arcane_enhance",
       "aghsfort_rylai_legend_cool_mind",
   
       "aghsfort_rylai_legend_letgo",
       "aghsfort_rylai_legend_nova_storm",
       "aghsfort_rylai_legend_absolute_zero",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_dark_seer"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_dark_willow"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_dazzle"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_death_prophet"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_doom_bringer"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_dragon_knight"] ={
   "empty_undefined_ability"
}  
 
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_earth_spirit"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_earthshaker"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_elder_titan"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_ember_spirit"] ={
   "ember_spirit_fire_remnant_shard",
   "ember_spirit_searing_chains_attack",
   "ember_spirit_searing_chains_attack_remnant",
   "ember_spirit_sleight_of_fist_chains",
   "ember_spirit_sleight_of_fist_crit",
   "ember_spirit_flame_guard_ally",
   "ember_spirit_flame_guard_heal",
   "ember_spirit_flame_guard_attack",
   "ember_spirit_fire_remnant_scepter",
   "ember_spirit_searing_chains_stack",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_enchantress"] ={
   "enchantress_impetus_hurricane"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_enigma"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_faceless_void"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_furion"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_grimstroke"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_hoodwink"] ={
   "empty_undefined_ability"
}
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_huskar"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_jakiro"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_keeper_of_the_light"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_legion_commander"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_leshrac"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_life_stealer"] ={
   "empty_undefined_ability"
}  
 
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_lion"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_lycan"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_marci"] ={
   "empty_undefined_ability"
}
  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_medusa"] ={
  
   "medusa_mystic_snake_speed",
   "medusa_mystic_snake_attack_proc",
  
   "medusa_mystic_snake_life_saving",
   "medusa_mystic_snake_shard",
   "medusa_mystic_snake_scepter",
   "medusa_mystic_snake_stone",
   "medusa_stone_gaze_mark",
   "medusa_stone_gaze_stone_buff",
   "medusa_stone_gaze_crit",
   "medusa_gorgon_grasp_stone",


   --"medusa_mystic_snake_split",
    --"medusa_split_shot_ally",
   --"special_bonus_unique_medusa_gorgon_grasp_nets",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_meepo"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_mirana"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_monkey_king"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_morphling"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_muerta"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_naga_siren"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_necrolyte"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_nevermore"] ={
      "aghsfort_nevermore_legend_shadow_waltz",
      "aghsfort_nevermore_legend_shadow_overlay",
      "aghsfort_nevermore_legend_shadow_volley",
      
        "aghsfort_nevermore_legend_necro_fusion", --吸收灵魂现在提供叠加的生命值/魔法回复效果。每次吸收2魂。死亡支付的灵魂数超过一定数值时，影魔不会消耗生命数。
        "aghsfort_nevermore_legend_soul_thirst",
        "aghsfort_nevermore_legend_unstable_spirit",
      
        "aghsfort_nevermore_legend_lord_assault",
        "aghsfort_nevermore_legend_advanced_darkness",
       "aghsfort_nevermore_legend_overlord",
      
        "aghsfort_nevermore_legend_reiatsu",
        "aghsfort_nevermore_legend_soul_callback",
        "aghsfort_nevermore_legend_made_in_hell",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_night_stalker"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_nyx_assassin"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_obsidian_destroyer"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_ogre_magi"] ={
   "ogre_magi_smash_shard",
   "ogre_magi_fireblast_aoe",
   "ogre_magi_fireblast_ignite",
   "ogre_magi_ignite_fireblast",
   "ogre_magi_ignite_bounce",
   "ogre_magi_bloodlust_ally_multicast",
   "ogre_magi_multicast_random",
   "ogre_magi_multicast_casino",
   "ogre_magi_unrefined_fireblast_scepter",
   "ogre_magi_multicast_lucky_femur",
}   
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_oracle"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_pangolier"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_phantom_assassin"] ={
    "aghsfort_phantom_assassin_stifling_dagger_auto",
    "aghsfort_phantom_assassin_stifling_dagger_attack",
    "aghsfort_phantom_assassin_stifling_dagger_multiple",
    "aghsfort_phantom_assassin_phantom_strike_damage_reduction",
    "aghsfort_phantom_assassin_phantom_strike_allies",
    "aghsfort_phantom_assassin_phantom_strike_lifesteal",
    "aghsfort_phantom_assassin_blur_regeneration",
    "aghsfort_phantom_assassin_blur_strike",
    "aghsfort_phantom_assassin_blur_immediate",
   "aghsfort_phantom_assassin_coup_de_grace_execute",
   "aghsfort_phantom_assassin_coup_de_grace_debuff",
   "aghsfort_phantom_assassin_coup_de_grace_multiple",

}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_phantom_lancer"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_primal_beast"] ={
   "empty_undefined_ability"
}
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_puck"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_pudge"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_pugna"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_rattletrap"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_razor"] ={
   "special_bonus_unique_razor_plasma_field_nanfu",
   "special_bonus_unique_razor_plasma_field_double",
   "razor_plasma_field_storm_surge",
   "razor_eye_of_the_storm_scepter",
   "razor_static_link_heal",
   "razor_static_link_units",
   "razor_static_link_shard",
   "razor_storm_surge_plasma_field",
   "razor_storm_surge_static_link",
   "special_bonus_unique_razor_storm_surge_chance",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_riki"] ={
   "riki_smoke_screen_shard",
   "riki_smoke_screen_agi",
   "riki_smoke_screen_invisibility",
   "riki_blink_strike_stun",
   "riki_blink_strike_attackspeed",
   "riki_tricks_of_the_trade_scepter",
   "riki_tricks_of_the_trade_cudgel",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_rubick"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_shadow_demon"] ={
   "more_layer",

   
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_shadow_shaman"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_shredder"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_silencer"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_skeleton_king"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_skywrath_mage"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_slardar"] ={
   "empty_undefined_ability"
}  


     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_spectre"] ={
     "spectre_spectral_dagger_protection",
      "spectre_spectral_dagger_trail",
      "spectre_desolate_aoe",
      "spectre_desolate_heal",
      "spectre_dispersion_proc",
      "spectre_reality_cooldown",
      "spectre_haunt_heal",
      "spectre_haunt_scepter",
      "spectre_haunt_dispersion",
      "spectre_dispersion_desolate",
      "spectre_spectral_dagger_desolate",
     "spectre_spectral_dagger_attackspeed",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_spirit_breaker"] ={
      "aghsfort_spirit_breaker_legend_orienteering",
      "aghsfort_spirit_breaker_legend_drift",
      "aghsfort_spirit_breaker_legend_unstoppable",
   
      "aghsfort_spirit_breaker_legend_sparking",
      "aghsfort_spirit_breaker_legend_niubility",
      "aghsfort_spirit_breaker_legend_rampage",
   
      "aghsfort_spirit_breaker_legend_serial",
      "aghsfort_spirit_breaker_legend_rush",
      "aghsfort_spirit_breaker_legend_schizophrenia",
   
      "aghsfort_spirit_breaker_legend_rise",
      "aghsfort_spirit_breaker_legend_crash",
      "aghsfort_spirit_breaker_legend_runup"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_storm_spirit"] ={
      "aghsfort_storm_spirit_legend_remnant_vortex",
     
      "aghsfort_storm_spirit_legend_remnant_taunt",
      
       "aghsfort_storm_spirit_legend_vortex_attack",
       "aghsfort_storm_spirit_legend_vortex_aoe",
       "aghsfort_storm_spirit_legend_vortex_overload",
   
       "aghsfort_storm_spirit_legend_overload_ally",
       "aghsfort_storm_spirit_legend_overload_mana",
       "aghsfort_storm_spirit_legend_overload_remnant",
   
       "aghsfort_storm_spirit_legend_ball_ally",
       "aghsfort_storm_spirit_legend_ball_fenzy",
       "aghsfort_storm_spirit_legend_ball_overload",

       --"aghsfort_storm_spirit_legend_remnant_giant",
      -- "aghsfort_storm_spirit_legend_remnant_power",
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_sven"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_techies"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_templar_assassin"] ={
   "templar_assassin_refraction_allies",
   "templar_assassin_refraction_absorption",
   "templar_assassin_refraction_trap",
   "templar_assassin_meld_vanishing",
   "templar_assassin_meld_step",
   "templar_assassin_meld_charge",
   "templar_assassin_psi_blades_devices",
   "templar_assassin_psi_blades_burst",
   "templar_assassin_psionic_trap_cuts",
   "templar_assassin_psionic_trap_resurgence",
   "templar_assassin_psionic_trap_echo",
   
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_terrorblade"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_tidehunter"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_tinker"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_tiny"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_treant"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_troll_warlord"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_vengefulspirit"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_venomancer"] ={
   "empty_undefined_ability"
}

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_visage"] ={
   "empty_undefined_ability"
}  
 
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_warlock"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_windrunner"] ={
   "empty_undefined_ability"
}  
     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_wisp"] ={
   "empty_undefined_ability"
}  

     SPECIAL_ABILITY_UPGRADES["npc_dota_hero_zuus"] ={
   "empty_undefined_ability"
}  
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_invoker"] ={
   "empty_undefined_ability"
}
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_omniknight"] =
{
	"omniknight_purification_holy_place",
   "omniknight_purification_stalwart",
   "omniknight_purification_cure",
   "omniknight_purification_shard",
   "omniknight_martyr_purification",
   "omniknight_martyr_zeal",
   "omniknight_martyr_barrier",
   "omniknight_martyr_judgement",
   "omniknight_guardian_angel_heal_life",
   "omniknight_guardian_angel_flight",
   "omniknight_guardian_angel_scepter",
   "special_bonus_unique_omniknight_hammer_of_purity_no_cooldown",



   --"omniknight_degen_aura_condemnation",
    --"omniknight_purification_benevolence",
}

 SPECIAL_ABILITY_UPGRADES["npc_dota_hero_magnataur"] =
 {
   "aghsfort_special_magnataur_empower_charges",
   "aghsfort_special_magnataur_shockwave_multishot",
 	"aghsfort_special_magnataur_shockwave_damage_reduction",
    "aghsfort_special_magnataur_shockwave_boomerang",
    "aghsfort_special_magnataur_empower_lifesteal",
    "aghsfort_special_magnataur_empower_shockwave_on_attack",
    "aghsfort_special_magnataur_skewer_bonus_strength",
    "aghsfort_magnataur_horn_toss",
    "aghsfort_special_magnataur_skewer_shockwave",
    "aghsfort_special_magnataur_reverse_polarity_polarity_dummy",
    "aghsfort_special_magnataur_reverse_polarity_allies_crit",
    "aghsfort_special_magnataur_reverse_polarity_steroid",
 
 
    --	"aghsfort_special_magnataur_empower_all_allies",
   

    --"aghsfort_special_magnataur_skewer_original_scepter",
    --"aghsfort_special_magnataur_friendly_skewer",
   
    --"aghsfort_special_magnataur_skewer_heal",
   

    --"aghsfort_special_magnataur_reverse_polarity_radius",
   
 }




SPECIAL_ABILITY_UPGRADES["npc_dota_hero_winter_wyvern"] =
{
   "empty_undefined_ability"
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_disruptor"] =
{
	"disruptor_thunder_strike_mana_storm",
   "special_bonus_unique_disruptor_thunder_strike_cover",
   "disruptor_thunder_strike_critical",
   "disruptor_thunder_strike_weapon",
   "disruptor_glimpse_past",
   "disruptor_kinetic_field_damage",
   "disruptor_kinetic_field_heal",
   "disruptor_kinetic_field_ring",
   "disruptor_static_storm_perfect",
   "disruptor_static_storm_dreams",
   "disruptor_static_storm_pacific",
   "special_bonus_unique_disruptor_electromagnetic_repulsion_no_cooldown",
   "disruptor_electromagnetic_repulsion_damage",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_snapfire"] =
{
   
   "snapfire_scatterblast_sawed_off",
   "snapfire_scatterblast_double_barreled",
   "snapfire_scatterblast_stopping_power",
   "special_bonus_unique_snapfire_firesnap_cookie_enemy",
   "snapfire_firesnap_cookie_bakers_dozen",
   "snapfire_firesnap_cookie_freshly_baked",
   "snapfire_lil_shredder_explosive_shells",
   "snapfire_lil_shredder_allies",
   --"special_bonus_unique_snapfire_lil_shredder_gunner"

}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_tusk"] =
{
   "tusk_ice_shards_icebreaker",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_ursa"] =
{
   "ursa_earthshock_cannonball",
   "special_bonus_unique_ursa_earthshock_digging",
   "ursa_earthshock_relentless",
   "ursa_overpower_torn",
   "ursa_overpower_elusive",
   "ursa_overpower_reckless",
   "ursa_fury_swipes_armor",
   --"ursa_fury_swipes_minor",
   "ursa_enrage_rampage",
   "ursa_enrage_ferocity",
   "ursa_enrage_cubs",
   --"ursa_earthshock_shard",
   "ursa_enrage_scepter",

  -- "ursa_fury_swipes_rend",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_sniper"] =
{
   
      "sniper_shrapnel_death_explode",
      "sniper_shrapnel_death_attackspeed",
      "sniper_shrapnel_death_blinding",
      "sniper_assassinate_scepter",
      "sniper_concussive_grenade_shard",
      "sniper_take_aim_purge",
     "sniper_assassinate_attack",
     "sniper_assassinate_accumulate",
    "sniper_take_aim_shrapnel",
    "sniper_take_aim_shooter",
    "sniper_headshot_corrosion",
   "sniper_assassinate_cone",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_mars"] = 
{
   "special_bonus_unique_mars_spear_impale_targets", --男子标枪世锦赛冠军
   "mars_spear_trail_blazer", --魔晶效果
   "mars_spear_boomstick", --回旋矛
   "special_bonus_unique_mars_gods_rebuke_circle", --全圆环
   "mars_gods_rebuke_stun", --振聋发聩
   "mars_gods_rebuke_strength",  --强力谴戒
   "mars_bulwark_scepter",  --密集方阵
   "mars_bulwark_bastion",    --堡垒
   "mars_bulwark_retort",    --反戈一击
   "special_bonus_unique_mars_arena_range",
   "mars_arena_buff",
   "special_bonus_unique_mars_arena_spear_distance",
}
SPECIAL_ABILITY_UPGRADES["npc_dota_hero_viper"] = 
{
   "empty_undefined_ability"
}
            


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_weaver"] = 
{
   "empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_witch_doctor"] = 
{
   --"witch_doctor_paralyzing_cask_multicask",
   --"witch_doctor_paralyzing_cask_applies_maledict",
   --"witch_doctor_paralyzing_cask_attack_procs",
   --"witch_doctor_maledict_mumbo",
   --"witch_doctor_maledict_blighted",
   --"witch_doctor_maledict_infectious",
   --"witch_doctor_voodoo_restoration_charm",
   --"witch_doctor_voodoo_restoration_cursed",
   "witch_doctor_death_ward_scepter",
   "witch_doctor_death_ward_shard",
   --"witch_doctor_death_ward_wise",
   "witch_doctor_death_ward_bewitched",
   --"aghsfort_special_witch_doctor_paralyzing_cask_multicask",
   --"aghsfort_special_witch_doctor_paralyzing_cask_applies_maledict",
   --"aghsfort_special_witch_doctor_paralyzing_cask_aoe_damage",
   --"aghsfort_special_witch_doctor_paralyzing_cask_attack_procs",
   
   --"aghsfort_special_witch_doctor_maledict_ground_curse",
   --"aghsfort_special_witch_doctor_maledict_aoe_procs",
  -- "aghsfort_special_witch_doctor_maledict_death_restoration",
  -- "aghsfort_special_witch_doctor_maledict_affects_allies",
   --"aghsfort_special_witch_doctor_maledict_infectious",
   
   --"aghsfort_special_witch_doctor_voodoo_restoration_enemy_damage",
   --"aghsfort_special_witch_doctor_voodoo_restoration_lifesteal",
   --"aghsfort_special_witch_doctor_voodoo_restoration_damage_amp",
   --"aghsfort_special_witch_doctor_voodoo_restoration_mana_restore",
   
   --"aghsfort_special_witch_doctor_death_ward_no_channel",
  -- "aghsfort_special_witch_doctor_death_ward_splitshot",
  -- "aghsfort_special_witch_doctor_death_ward_damage_resist",
   --"aghsfort_special_witch_doctor_death_ward_bounce",
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_queenofpain"] =
{
      "queenofpain_shadow_strike_attack",
      "queenofpain_blink_scream",
      "queenofpain_blink_shadow_strike",
      "queenofpain_blink_attackspeed",
     "queenofpain_scream_of_pain_refresh",
     "queenofpain_scream_of_pain_heal",
     "queenofpain_scream_of_pain_knockback",
   "special_bonus_unique_queenofpain_shadow_strike_spread",
  "special_bonus_unique_queenofpain_shadow_strike_scream",
   
}




SPECIAL_ABILITY_UPGRADES["npc_dota_hero_slark"] =
{
   "empty_undefined_ability"

}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_lina"] =
{
   
    "lina_light_strike_array_three_times",
    "lina_light_strike_array_attack",
    "lina_dragon_slave_rocket",
    "lina_dragon_slave_strike",
    "lina_dragon_slave_trislaves",
    "lina_flame_cloak_scepter",
    "lina_fiery_soul_shard",
    "lina_fiery_soul_attack",
   "lina_laguna_blade_snake",
   "lina_laguna_blade_root",
  
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_undying"] =
{
   "undying_decay_zombies",
   "undying_decay_attack",
   "undying_decay_triple",
   "undying_soul_rip_taunt",
   "undying_soul_rip_tear",
   "undying_tombstone_bury",
   "undying_tombstone_corpses",
   "undying_tombstone_hunger",
   "undying_flesh_golem_march",
   "undying_flesh_golem_rot",
   "undying_flesh_golem_smash",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_juggernaut"] =
{
   "aghsfort_special_juggernaut_blade_fury_sparks", --风暴闪光 距离越远伤害越高
   "aghsfort_special_juggernaut_blade_fury_force", --暴风吸入 
   "aghsfort_special_juggernaut_blade_dance_launches_blade_fury",   --横扫千军改为大家一起转 

   "aghsfort_special_juggernaut_healing_ward_blade_fury", --释放守卫时 守卫转起来
   "aghsfort_special_juggernaut_healing_ward_damage",--巫毒医疗兵
   "aaghsfort_special_juggernaut_zen_ward",   --禅宗守卫
   "aghsfort_special_juggernaut_blade_dance_fever", --狂热
   "aghsfort_special_juggernaut_blade_dance_cooldown", --快节奏
   "aghsfort_special_juggernaut_blade_dance_buff",       --刀光剑影
   "aghsfort_special_juggernaut_omni_slash_white_hot_katana", --白热武士刀
   "aghsfort_special_juggernaut_swift_slash",         --迅风斩
   "aghsfort_special_juggernaut_omni_slash_fury",  --风暴斩


    
   -- "aghsfort_special_juggernaut_omni_slash_shared",
   -- "aghsfort_special_juggernaut_omni_slash_spin",
   -- "aghsfort_special_juggernaut_omni_slash_ignite",
    --"aghsfort_special_juggernaut_blade_dance_teleport",
   --"aghsfort_special_juggernaut_blade_fury_lifesteal_hit",
   -- "aghsfort_special_juggernaut_blade_fury_shared",
   -- "aghsfort_special_juggernaut_healing_ward_crit",
   -- "aghsfort_special_juggernaut_blade_dance_shared",
   -- "aghsfort_special_juggernaut_omni_slash_range",
   -- "aghsfort_special_juggernaut_omni_slash_illusion",
   -- "aghsfort_special_juggernaut_omni_slash_crit_extend",
   -- "aghsfort_special_juggernaut_healing_ward_detonate",
}


SPECIAL_ABILITY_UPGRADES["npc_dota_hero_drow_ranger"] =
{
   "empty_undefined_ability"
}



SPECIAL_ABILITY_UPGRADES["npc_dota_hero_luna"] =
{
	"empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_lich"] =
{
   "empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES["npc_dota_hero_kunkka"] =
{
	"empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_void_spirit" ] =
{
   "empty_undefined_ability"
}


SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_gyrocopter" ] =
{
   "gyrocopter_rocket_barrage_attack",
   "gyrocopter_rocket_barrage_turret",
   "gyrocopter_rocket_barrage_shard",
   "gyrocopter_flak_cannon_scepter",
   "gyrocopter_homing_missile_calldown",
   "gyrocopter_homing_missile_minimissiles",
   "gyrocopter_flak_cannon_missile", 
   "gyrocopter_homing_missile_sledmissiles",
   "gyrocopter_call_down_strafe",
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_dawnbreaker" ] =
{
   "empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_bane" ] =
{
   "empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_phoenix" ] =
{
   "empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_sand_king" ] =
{
   "empty_undefined_ability"
}

SPECIAL_ABILITY_UPGRADES[ "npc_dota_hero_clinkz" ] =
{
   "empty_undefined_ability"
}

require( "items/item_small_scepter_fragment" )

_G.PURCHASABLE_SHARDS = {}

--Disruptor
item_aghsfort_disruptor_thunder_strike_flat_strikes = item_small_scepter_fragment
item_aghsfort_disruptor_thunder_strike_flat_strike_damage = item_small_scepter_fragment
item_aghsfort_disruptor_glimpse_flat_bonus_damage = item_small_scepter_fragment
item_aghsfort_disruptor_glimpse_flat_cast_radius = item_small_scepter_fragment
item_aghsfort_disruptor_kinetic_field_flat_duration = item_small_scepter_fragment
item_aghsfort_disruptor_kinetic_field_formation_time = item_small_scepter_fragment
item_aghsfort_disruptor_static_storm_flat_duration = item_small_scepter_fragment
item_aghsfort_disruptor_static_storm_flat_damage_max = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_disruptor" ] =
{
   "item_aghsfort_disruptor_thunder_strike_flat_strikes",
   "item_aghsfort_disruptor_thunder_strike_flat_strike_damage",
   "item_aghsfort_disruptor_glimpse_flat_bonus_damage",
   "item_aghsfort_disruptor_glimpse_flat_cast_radius",
   "item_aghsfort_disruptor_kinetic_field_flat_duration",
   "item_aghsfort_disruptor_kinetic_field_formation_time",
   "item_aghsfort_disruptor_static_storm_flat_duration",
   "item_aghsfort_disruptor_static_storm_flat_damage_max",
}

--Magnus
 item_aghsfort_magnataur_shockwave_flat_damage = item_small_scepter_fragment
 item_aghsfort_magnataur_shockwave_pct_mana_cost = item_small_scepter_fragment
 item_aghsfort_magnataur_empower_flat_damage = item_small_scepter_fragment
 item_aghsfort_magnataur_empower_flat_cleave = item_small_scepter_fragment
 item_aghsfort_magnataur_skewer_flat_damage = item_small_scepter_fragment
 item_aghsfort_magnataur_skewer_pct_cooldown = item_small_scepter_fragment
 item_aghsfort_magnataur_reverse_polarity_flat_damage = item_small_scepter_fragment
 item_aghsfort_magnataur_reverse_polarity_flat_radius = item_small_scepter_fragment

 PURCHASABLE_SHARDS[ "npc_dota_hero_magnataur" ] =
 {
    "item_aghsfort_magnataur_shockwave_flat_damage",
    "item_aghsfort_magnataur_shockwave_pct_mana_cost",
    "item_aghsfort_magnataur_empower_flat_damage",
    "item_aghsfort_magnataur_empower_flat_cleave",
    "item_aghsfort_magnataur_skewer_flat_damage",
    "item_aghsfort_magnataur_skewer_pct_cooldown",
    "item_aghsfort_magnataur_reverse_polarity_flat_damage",
    "item_aghsfort_magnataur_reverse_polarity_flat_radius",
 }

--Mars
item_aghsfort_mars_spear_flat_damage = item_small_scepter_fragment
item_aghsfort_mars_spear_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_mars_gods_rebuke_percent_cooldown = item_small_scepter_fragment
item_aghsfort_mars_gods_rebuke_flat_crit_mult = item_small_scepter_fragment
item_aghsfort_mars_bulwark_damage_reduction_front = item_small_scepter_fragment
item_aghsfort_mars_bulwark_active_duration = item_small_scepter_fragment
item_aghsfort_mars_arena_of_blood_duration = item_small_scepter_fragment
item_aghsfort_mars_arena_of_blood_spear_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_mars" ] =
{
   "item_aghsfort_mars_spear_flat_damage",
   "item_aghsfort_mars_spear_flat_stun_duration",
   "item_aghsfort_mars_gods_rebuke_percent_cooldown",
   "item_aghsfort_mars_gods_rebuke_flat_crit_mult",
   "item_aghsfort_mars_bulwark_damage_reduction_front",
   "item_aghsfort_mars_bulwark_active_duration",
   "item_aghsfort_mars_arena_of_blood_duration",
   "item_aghsfort_mars_arena_of_blood_spear_damage",
}

--Omni
item_aghsfort_omniknight_purification_manacost = item_small_scepter_fragment
item_aghsfort_omniknight_purification_flat_heal = item_small_scepter_fragment
item_aghsfort_omniknight_repel_flat_duration = item_small_scepter_fragment
item_aghsfort_omniknight_repel_flat_damage_reduction = item_small_scepter_fragment
item_aghsfort_omniknight_degen_aura_flat_radius = item_small_scepter_fragment
item_aghsfort_omniknight_degen_aura_flat_move_speed_bonus = item_small_scepter_fragment
item_aghsfort_omniknight_guardian_angel_flat_duration = item_small_scepter_fragment
item_aghsfort_omniknight_guardian_angel_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_omniknight" ] =
{
   "item_aghsfort_omniknight_purification_manacost",
   "item_aghsfort_omniknight_purification_flat_heal",
   "item_aghsfort_omniknight_repel_flat_duration",
   "item_aghsfort_omniknight_repel_flat_damage_reduction",
   "item_aghsfort_omniknight_degen_aura_flat_radius",
   "item_aghsfort_omniknight_degen_aura_flat_move_speed_bonus",
   "item_aghsfort_omniknight_guardian_angel_flat_duration",
   "item_aghsfort_omniknight_guardian_angel_cooldown",
}

-- Queen Of Pain
item_aghsfort_queenofpain_shadow_strike_strike_damage = item_small_scepter_fragment
item_aghsfort_queenofpain_shadow_strike_dot_damage = item_small_scepter_fragment
item_aghsfort_queenofpain_blink_percent_cooldown = item_small_scepter_fragment
item_aghsfort_queenofpain_blink_range = item_small_scepter_fragment
item_aghsfort_queenofpain_scream_of_pain_damage = item_small_scepter_fragment
item_aghsfort_queenofpain_scream_of_pain_radius = item_small_scepter_fragment
item_aghsfort_queenofpain_sonic_wave_percent_cooldown = item_small_scepter_fragment
item_aghsfort_queenofpain_sonic_wave_damage = item_small_scepter_fragment


PURCHASABLE_SHARDS[ "npc_dota_hero_queenofpain" ] =
{
   "item_aghsfort_queenofpain_shadow_strike_strike_damage",
   "item_aghsfort_queenofpain_shadow_strike_dot_damage",
   "item_aghsfort_queenofpain_blink_percent_cooldown",
   "item_aghsfort_queenofpain_blink_range",
   "item_aghsfort_queenofpain_scream_of_pain_damage",
   "item_aghsfort_queenofpain_scream_of_pain_radius",
   "item_aghsfort_queenofpain_sonic_wave_percent_cooldown",
   "item_aghsfort_queenofpain_sonic_wave_damage",
}

--Slark
item_aghsfort_slark_dark_pact_cooldown = item_small_scepter_fragment
item_aghsfort_slark_dark_pact_total_damage = item_small_scepter_fragment
item_aghsfort_slark_pounce_distance = item_small_scepter_fragment
item_aghsfort_slark_pounce_damage = item_small_scepter_fragment
item_aghsfort_slark_essence_shift_agi_gain = item_small_scepter_fragment
item_aghsfort_slark_essence_shift_max_stacks = item_small_scepter_fragment
item_aghsfort_slark_shadow_dance_duration = item_small_scepter_fragment
item_aghsfort_slark_shadow_dance_bonus_bonus_regen_pct = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_slark" ] =
{
   "item_aghsfort_slark_dark_pact_cooldown",
   "item_aghsfort_slark_dark_pact_total_damage",
   "item_aghsfort_slark_pounce_distance",
   "item_aghsfort_slark_pounce_damage",
   "item_aghsfort_slark_essence_shift_agi_gain",
   "item_aghsfort_slark_essence_shift_max_stacks",
   "item_aghsfort_slark_shadow_dance_duration",
   "item_aghsfort_slark_shadow_dance_bonus_bonus_regen_pct",
}

--Snapfire
item_aghsfort_snapfire_scatterblast_flat_damage = item_small_scepter_fragment
item_aghsfort_snapfire_scatterblast_pct_cooldown = item_small_scepter_fragment
item_aghsfort_snapfire_firesnap_cookie_flat_impact_damage = item_small_scepter_fragment
item_aghsfort_snapfire_firesnap_cookie_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_snapfire_lil_shredder_flat_damage = item_small_scepter_fragment
item_aghsfort_snapfire_lil_shredder_flat_attacks = item_small_scepter_fragment
item_aghsfort_snapfire_mortimer_kisses_flat_projectile_count = item_small_scepter_fragment
item_aghsfort_snapfire_mortimer_kisses_flat_burn_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_snapfire" ] =
{
   "item_aghsfort_snapfire_scatterblast_flat_damage",
   "item_aghsfort_snapfire_scatterblast_pct_cooldown",
   "item_aghsfort_snapfire_firesnap_cookie_flat_impact_damage",
   "item_aghsfort_snapfire_firesnap_cookie_flat_stun_duration",
   "item_aghsfort_snapfire_lil_shredder_flat_damage",
   "item_aghsfort_snapfire_lil_shredder_flat_attacks",
   "item_aghsfort_snapfire_mortimer_kisses_flat_projectile_count",
   "item_aghsfort_snapfire_mortimer_kisses_flat_burn_damage",
}

--Sniper
item_aghsfort_sniper_shrapnel_flat_damage = item_small_scepter_fragment
item_aghsfort_sniper_shrapnel_flat_radius = item_small_scepter_fragment
item_aghsfort_sniper_shrapnel_duration = item_small_scepter_fragment
item_aghsfort_sniper_headshot_flat_damage = item_small_scepter_fragment
item_aghsfort_sniper_headshot_proc_chance = item_small_scepter_fragment
item_aghsfort_sniper_take_aim_flat_bonus_attack_range = item_small_scepter_fragment
item_aghsfort_sniper_assassinate_flat_damage = item_small_scepter_fragment
item_aghsfort_sniper_assassinate_percent_cast_point = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_sniper" ] =
{
   "item_aghsfort_sniper_shrapnel_flat_damage",
   "item_aghsfort_sniper_shrapnel_flat_radius",
   "item_aghsfort_sniper_shrapnel_duration",
   "item_aghsfort_sniper_headshot_flat_damage",
   "item_aghsfort_sniper_headshot_proc_chance",
   "item_aghsfort_sniper_take_aim_flat_bonus_attack_range",
   "item_aghsfort_sniper_assassinate_flat_damage",
   "item_aghsfort_sniper_assassinate_percent_cast_point",
}

--Templar Assassin
item_aghsfort_templar_assassin_refraction_instances = item_small_scepter_fragment
item_aghsfort_templar_assassin_refraction_bonus_damage = item_small_scepter_fragment
item_aghsfort_templar_assassin_meld_bonus_damage = item_small_scepter_fragment
item_aghsfort_templar_assassin_meld_bonus_armor = item_small_scepter_fragment
item_aghsfort_templar_assassin_psi_blades_bonus_attack_range = item_small_scepter_fragment
item_aghsfort_templar_assassin_psi_blades_attack_spill_width = item_small_scepter_fragment
item_aghsfort_templar_assassin_psionic_trap_max_traps = item_small_scepter_fragment
item_aghsfort_templar_assassin_psionic_trap_trap_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_templar_assassin" ] =
{
   "item_aghsfort_templar_assassin_refraction_instances",
   "item_aghsfort_templar_assassin_refraction_bonus_damage",
   "item_aghsfort_templar_assassin_meld_bonus_damage",
   "item_aghsfort_templar_assassin_meld_bonus_armor",
   "item_aghsfort_templar_assassin_psi_blades_bonus_attack_range",
   "item_aghsfort_templar_assassin_psi_blades_attack_spill_width",
   "item_aghsfort_templar_assassin_psionic_trap_max_traps",
   "item_aghsfort_templar_assassin_psionic_trap_trap_damage",
}

--Tusk
item_aghsfort_tusk_ice_shards_flat_damage = item_small_scepter_fragment
item_aghsfort_tusk_ice_shards_flat_shard_duration = item_small_scepter_fragment
item_aghsfort_tusk_snowball_flat_snowball_damage = item_small_scepter_fragment
item_aghsfort_tusk_snowball_flat_stun_duration = item_small_scepter_fragment
item_aghsfort_tusk_tag_team_flat_damage = item_small_scepter_fragment
item_aghsfort_tusk_tag_team_pct_cooldown = item_small_scepter_fragment
item_aghsfort_tusk_walrus_punch_pct_cooldown = item_small_scepter_fragment
item_aghsfort_tusk_walrus_punch_flat_crit_multiplier = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_tusk" ] =
{
   "item_aghsfort_tusk_ice_shards_flat_damage",
   "item_aghsfort_tusk_ice_shards_flat_shard_duration",
   "item_aghsfort_tusk_snowball_flat_snowball_damage",
   "item_aghsfort_tusk_snowball_flat_stun_duration",
   "item_aghsfort_tusk_tag_team_flat_damage",
   "item_aghsfort_tusk_tag_team_pct_cooldown",
   "item_aghsfort_tusk_walrus_punch_pct_cooldown",
   "item_aghsfort_tusk_walrus_punch_flat_crit_multiplier",
}

--Ursa
item_aghsfort_ursa_earthshock_flat_damage = item_small_scepter_fragment
item_aghsfort_ursa_earthshock_flat_radius = item_small_scepter_fragment
item_aghsfort_ursa_overpower_flat_max_attacks = item_small_scepter_fragment
item_aghsfort_ursa_overpower_percent_cooldown = item_small_scepter_fragment
item_aghsfort_ursa_fury_swipes_flat_damage_per_stack = item_small_scepter_fragment
item_aghsfort_ursa_fury_swipes_flat_max_swipe_stack = item_small_scepter_fragment
item_aghsfort_ursa_enrage_flat_duration = item_small_scepter_fragment
item_aghsfort_ursa_enrage_percent_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_ursa" ] =
{
   "item_aghsfort_ursa_earthshock_flat_damage",
   "item_aghsfort_ursa_earthshock_flat_radius",
   "item_aghsfort_ursa_overpower_flat_max_attacks",
   "item_aghsfort_ursa_overpower_percent_cooldown",
   "item_aghsfort_ursa_fury_swipes_flat_damage_per_stack",
   "item_aghsfort_ursa_fury_swipes_flat_max_swipe_stack",
   "item_aghsfort_ursa_enrage_flat_duration",
   "item_aghsfort_ursa_enrage_percent_cooldown",
}

--Viper
item_aghsfort_viper_poison_attack_damage = item_small_scepter_fragment
item_aghsfort_viper_poison_attack_magic_resistance = item_small_scepter_fragment
item_aghsfort_viper_nethertoxin_max_damage = item_small_scepter_fragment
item_aghsfort_viper_nethertoxin_radius = item_small_scepter_fragment
item_aghsfort_viper_corrosive_skin_bonus_magic_resistance = item_small_scepter_fragment
item_aghsfort_viper_corrosive_skin_damage = item_small_scepter_fragment
item_aghsfort_viper_viper_strike_duration = item_small_scepter_fragment
item_aghsfort_viper_viper_strike_damage = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_viper" ] =
{
   "item_aghsfort_viper_poison_attack_damage",
   "item_aghsfort_viper_poison_attack_magic_resistance",
   "item_aghsfort_viper_nethertoxin_max_damage",
   "item_aghsfort_viper_nethertoxin_radius",
   "item_aghsfort_viper_corrosive_skin_bonus_magic_resistance",
   "item_aghsfort_viper_corrosive_skin_damage",
   "item_aghsfort_viper_viper_strike_duration",
   "item_aghsfort_viper_viper_strike_damage",
}

--Weaver
item_aghsfort_weaver_the_swarm_flat_armor_reduction = item_small_scepter_fragment
item_aghsfort_weaver_the_swarm_flat_damage = item_small_scepter_fragment
item_aghsfort_weaver_the_swarm_percent_cooldown = item_small_scepter_fragment
item_aghsfort_weaver_shukuchi_flat_damage = item_small_scepter_fragment
item_aghsfort_weaver_shukuchi_duration = item_small_scepter_fragment
item_aghsfort_weaver_geminate_attack_cooldown = item_small_scepter_fragment
item_aghsfort_weaver_geminate_attack_flat_bonus_damage = item_small_scepter_fragment
item_aghsfort_weaver_time_lapse_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_weaver" ] =
{
   "item_aghsfort_weaver_the_swarm_flat_armor_reduction",
   "item_aghsfort_weaver_the_swarm_flat_damage",
   "item_aghsfort_weaver_the_swarm_percent_cooldown",
   "item_aghsfort_weaver_shukuchi_flat_damage",
   "item_aghsfort_weaver_shukuchi_duration",
   "item_aghsfort_weaver_geminate_attack_cooldown",
   "item_aghsfort_weaver_geminate_attack_flat_bonus_damage",
   "item_aghsfort_weaver_time_lapse_cooldown",
}

--Winter Wyvern
item_aghsfort_winter_wyvern_arctic_burn_flat_damage = item_small_scepter_fragment
item_aghsfort_winter_wyvern_arctic_burn_flat_duration = item_small_scepter_fragment
item_aghsfort_winter_wyvern_splinter_blast_flat_radius = item_small_scepter_fragment
item_aghsfort_winter_wyvern_splinter_blast_flat_damage = item_small_scepter_fragment
item_aghsfort_winter_wyvern_cold_embrace_flat_heal_percentage = item_small_scepter_fragment
item_aghsfort_winter_wyvern_cold_embrace_pct_cooldown = item_small_scepter_fragment
item_aghsfort_winter_wyvern_winters_curse_flat_duration = item_small_scepter_fragment
item_aghsfort_winter_wyvern_winters_curse_pct_cooldown = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_winter_wyvern" ] =
{
   "item_aghsfort_winter_wyvern_arctic_burn_flat_damage",
   "item_aghsfort_winter_wyvern_arctic_burn_flat_duration",
   "item_aghsfort_winter_wyvern_splinter_blast_flat_radius",
   "item_aghsfort_winter_wyvern_splinter_blast_flat_damage",
   "item_aghsfort_winter_wyvern_cold_embrace_flat_heal_percentage",
   "item_aghsfort_winter_wyvern_cold_embrace_pct_cooldown",
   "item_aghsfort_winter_wyvern_winters_curse_flat_duration",
   "item_aghsfort_winter_wyvern_winters_curse_pct_cooldown",
}

--WD
item_aghsfort_witch_doctor_voodoo_restoration_manacost = item_small_scepter_fragment
item_aghsfort_witch_doctor_voodoo_restoration_flat_heal = item_small_scepter_fragment
item_aghsfort_witch_doctor_paralyzing_cask_flat_damage = item_small_scepter_fragment
item_aghsfort_witch_doctor_paralyzing_cask_flat_bounces = item_small_scepter_fragment
item_aghsfort_witch_doctor_maledict_flat_ticks = item_small_scepter_fragment
item_aghsfort_witch_doctor_maledict_flat_max_bonus_damage = item_small_scepter_fragment
item_aghsfort_witch_doctor_death_ward_flat_damage = item_small_scepter_fragment
item_aghsfort_witch_doctor_death_ward_flat_channel_duration = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_witch_doctor" ] =
{
   "item_aghsfort_witch_doctor_voodoo_restoration_manacost",
   "item_aghsfort_witch_doctor_voodoo_restoration_flat_heal",
   "item_aghsfort_witch_doctor_paralyzing_cask_flat_damage",
   "item_aghsfort_witch_doctor_paralyzing_cask_flat_bounces",
   "item_aghsfort_witch_doctor_maledict_flat_ticks",
   "item_aghsfort_witch_doctor_maledict_flat_max_bonus_damage",
   "item_aghsfort_witch_doctor_death_ward_flat_damage",
   "item_aghsfort_witch_doctor_death_ward_flat_channel_duration",
}

-- Void Spirit
item_aghsfort_void_spirit_aether_remnant_mana_cost_cooldown = item_small_scepter_fragment
item_aghsfort_void_spirit_aether_remnant_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_dissimilate_mana_cost_cooldown = item_small_scepter_fragment
item_aghsfort_void_spirit_dissimilate_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_mana_cost_cooldown = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_base_absorb = item_small_scepter_fragment
item_aghsfort_void_spirit_resonant_pulse_absorb_per_unit = item_small_scepter_fragment
item_aghsfort_void_spirit_astral_step_pop_damage = item_small_scepter_fragment
item_aghsfort_void_spirit_astral_step_max_travel_distance = item_small_scepter_fragment
item_aghsfort_void_spirit_astral_step_charge_restore_time = item_small_scepter_fragment

PURCHASABLE_SHARDS[ "npc_dota_hero_void_spirit" ] =
{
   "item_aghsfort_void_spirit_aether_remnant_mana_cost_cooldown",
   "item_aghsfort_void_spirit_aether_remnant_damage",
   "item_aghsfort_void_spirit_dissimilate_mana_cost_cooldown",
   "item_aghsfort_void_spirit_dissimilate_damage",
   "item_aghsfort_void_spirit_resonant_pulse_mana_cost_cooldown",
   "item_aghsfort_void_spirit_resonant_pulse_damage",
   "item_aghsfort_void_spirit_resonant_pulse_base_absorb",
   "item_aghsfort_void_spirit_resonant_pulse_absorb_per_unit",
   "item_aghsfort_void_spirit_astral_step_pop_damage",
   "item_aghsfort_void_spirit_astral_step_max_travel_distance",
   "item_aghsfort_void_spirit_astral_step_charge_restore_time",
}

