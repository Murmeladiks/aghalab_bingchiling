HeroSelection = HeroSelection or class({})
require("libraries/keyvalues")


HeroSelection.supporter_heroes = {
--  hero_name = min_supporter_level,
	--npc_dota_hero_zuus = 1,
	--npc_dota_hero_medusa = 2,
}

function HeroSelection:Init()
	if HeroSelection.bInitiated then return end
	HeroSelection.bInitiated = true
	CustomGameEventManager:RegisterListener("HeroSelection:hero_picked", 		Dynamic_Wrap(HeroSelection, "OnHeroPicked"))
	CustomGameEventManager:RegisterListener("HeroSelection:hero_list_request", 	Dynamic_Wrap(HeroSelection, "OnHeroListRequested"))

	HeroSelection.herolist_kv = LoadKeyValues("scripts/npc/herolist_pathfinders.txt")
	HeroSelection:ParseHeroListKV()

	HeroSelection.vo_replacements = {
		legion_commander 	= "legioncommander",
		witch_doctor 		= "wd",
		templar_assassin 	= "ta",
		phantom_assassin 	= "pa",
		omniknight 			= "omni",
		windrunner 			= "wr",
		auroth 				= "winter_wyvern",
		venomancer 			= "veno",
		ogre_magi 			= "ogremagi",
		queenofpain 		= "qop",
		nevermore 			= "shadowfiend",
		tidehunter 			= "tide",
		dragon_knight 		= "dk",
	}

	HeroSelection.vo_direct_emission = {
		viper 				= "viper_vipe_spawn_05",
		tusk 				= "announcer_dlc_bastion_announcer_pick_tuskkar_follow_02",
		mars 				= "mars_mars_respawn_08",
		snapfire 			= "snapfire_snapfire_immort_02",
		hoodwink 			= "hoodwink_hoodwink_idle_01",
		dawnbreaker 		= "dawnbreaker_valora_intro_07_03",
		void_spirit			= "announcer_dlc_bastion_announcer_pick_vs_follow",
	}

	HeroSelection.PickedHeroes = {
		[0] = nil,
		[1] = nil,
		[2] = nil,
		[3] = nil,
	}

	CustomNetTables:SetTableValue("game", "supporter_heroes", self.supporter_heroes)
end


function HeroSelection:ForceAssignHeroes()
	for player_id = 0, (DOTA_MAX_TEAM_PLAYERS - 1) do
		if PlayerResource:GetTeam(player_id) == DOTA_TEAM_GOODGUYS then
			local player = PlayerResource:GetPlayer(player_id)
			if player and not PlayerResource:HasSelectedHero(player_id) then
				self:MakeRandomHeroSelection(player)
			end
		end
	end

	if not HeroSelection.bStrategyStarted then
		HeroSelection.bStrategyStarted = true
		HeroSelection:StrategyTime()
	end
end

function HeroSelection:MakeRandomHeroSelection(player)
	local player_id = player:GetPlayerID()

	local hero_list = table.make_key_table(self.herolist_kv)
	hero_list = table.filter(hero_list, function(hero_name)
		return self:IsHeroAvailableForPlayer(player_id, hero_name)
	end)

	--PrintTable(hero_list)

	local hero_name = table.random(hero_list)
	--print("choosing " .. hero_name)
	--player:SetSelectedHero(hero_name)
	--print("forcing hero")
	CustomGameEventManager:Send_ServerToPlayer(player, "force_random", {forced_hero = hero_name})
	--print("Player", player_id, "randomed hero", hero_name)
end


function HeroSelection:Start() 
	local selection_time = HERO_SELECTION_TIME

	Timers:CreateTimer(function()
		for player_id = 0, AGHANIM_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(player_id) then
				local player_name = PlayerResource:GetPlayerName(player_id)
				CustomGameEventManager:Send_ServerToAllClients("player_name_init", {
					id = player_id,
					name = player_name
				})
			end
		end
		selection_time = math.floor(selection_time - 1)
		if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_HERO_SELECTION then 
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME and not HeroSelection.bStrategyStarted then
				HeroSelection.bStrategyStarted = true
				HeroSelection:ForceAssignHeroes()
			end

			return
		end

		CustomGameEventManager:Send_ServerToAllClients("picking_time_update", {
			time = selection_time
		})

		if selection_time == 30 then
			if RandomInt(1, 100) < 50 then
				EmitGlobalSound("announcer_dlc_bastion_announcer_count_battle_30_01")
			else
				EmitGlobalSound("announcer_dlc_bastion_announcer_count_battle_30_02")
			end
		elseif selection_time == 10 then
			if RandomInt(1, 100) < 50 then
				EmitGlobalSound("announcer_dlc_bastion_announcer_count_battle_10_01")
			else
				EmitGlobalSound("announcer_dlc_bastion_announcer_count_battle_10_02")
			end
		end

		if selection_time > 0 then
			--print("TICKING PICK")
			return 1
		else
			HeroSelection:ForceAssignHeroes()
			return nil
		end
	end)

	local system_time = tonumber(string.sub(LocalTime().Hours, 1, 2))
	if system_time >= 4 and system_time < 12 then
		EmitGlobalSound("announcer_dlc_bastion_announcer_welcome_morning")
	elseif system_time >= 12 and system_time < 18 then
		EmitGlobalSound("announcer_dlc_bastion_announcer_welcome_afternoon")
	elseif system_time >= 18 and system_time < 22 then
		EmitGlobalSound("announcer_dlc_bastion_announcer_welcome_evening")
	elseif (system_time >= 22 and system_time < 25) or (system_time >= 0 and system_time < 4) then
		EmitGlobalSound("announcer_dlc_bastion_announcer_welcome_night")
	end

	TimeSound(5, "bastion_choose_hero")
end

function HeroSelection:StrategyTime()
	local nStratTimeRemaining = STRATEGY_TIME

	Timers:CreateTimer(function() 
		nStratTimeRemaining = math.floor(nStratTimeRemaining - 1)
		CustomGameEventManager:Send_ServerToAllClients("picking_time_update", {
			time = nStratTimeRemaining
		})

		if GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then return 1 end
	end)

	CustomGameEventManager:Send_ServerToAllClients("strategy_started", {})
end


function HeroSelection:OnHeroSelected(event)
	--CAghanim:GetAnnouncer():OnHeroSelected(event.hero_unit)
end


function HeroSelection:LockFaceVoiceLine(hero_name)
	if not IsServer() then
		return
	end

	if HeroSelection.vo_replacements[hero_name] then
		hero_name = HeroSelection.vo_replacements[hero_name]
	end

	if HeroSelection.vo_direct_emission[hero_name] then
		EmitGlobalSound(HeroSelection.vo_direct_emission[hero_name])
	else
		EmitGlobalSound("announcer_dlc_bastion_announcer_pick_" .. hero_name .. "_follow")
	end
end


function HeroSelection:OnHeroPicked(event)
	local player_id = event.PlayerID
	local hero_name = event.hero

	if not HeroSelection.herolist_kv[hero_name] or HeroSelection.herolist_kv[hero_name] == "0" then return end
	if not HeroSelection:IsHeroAvailableForPlayer(player_id, hero_name) then return end

	local player = PlayerResource:GetPlayer(player_id)
	--player:SetSelectedHero(hero_name)
	HeroSelection:LockFaceVoiceLine(string.sub(hero_name, 15))
	HeroSelection.PickedHeroes[player_id] = hero_name

	--print("[HeroSelection] hero selected: ", hero_name, player_id)
	--[[PrecacheUnitByNameAsync(hero_name, 
		function(precache_id)
			--print("[HeroSelection] precache finished => ", hero_name, player_id)
			HeroSelection:LockFaceVoiceLine(string.sub(hero_name, 15))
			Timers:CreateTimer(1, function()
				UniquePortraits:UpdatePortraitsDataFromPlayer(player_id)
			end)
		end,
		player_id
	)]]
end


function HeroSelection:ParseHeroListKV()
	local fixed_list = {}
	HeroSelection.heroes_by_attribute = {}
	for hero_name, enabled in pairs(HeroSelection.herolist_kv) do
		if enabled == 1 then
			fixed_list[hero_name] = enabled

			local attribute = GetUnitKV(hero_name, "AttributePrimary")
			local parsed_attribute = _G[attribute]
			if parsed_attribute then
				if not HeroSelection.heroes_by_attribute[parsed_attribute] then HeroSelection.heroes_by_attribute[parsed_attribute] = {} end
				table.insert(HeroSelection.heroes_by_attribute[parsed_attribute], hero_name)
			else
				print("[Hero Selection] WARNING: unknown primary attribute for hero", hero_name, attribute)
			end
		end
	end

	HeroSelection.herolist_kv = fixed_list
end


function HeroSelection:OnHeroListRequested(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)

	if not HeroSelection.heroes_by_attribute then
		HeroSelection:ParseHeroListKV()
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "HeroSelection:hero_list_response", HeroSelection.heroes_by_attribute)
	
	Timers:CreateTimer(1, function()
		for player_id = 0, AGHANIM_PLAYERS - 1 do
			if HeroSelection.PickedHeroes[player_id] then
				CustomGameEventManager:Send_ServerToAllClients("broadcast_pick", {hero = HeroSelection.PickedHeroes[player_id], pid = player_id})
				CustomGameEventManager:Send_ServerToAllClients("HeroSelection:hero_locked", {hero = HeroSelection.PickedHeroes[player_id], pid = player_id})
			end

			CustomGameEventManager:Send_ServerToAllClients("player_name_init", {
				id = player_id,
				name = PlayerResource:GetPlayerName(player_id)
			})
		end
	end)
	CustomGameEventManager:Send_ServerToPlayer(player, "HeroSelection:picked_heroes", HeroSelection.PickedHeroes)
end

function HeroSelection:IsHeroAvailableForPlayer(player_id, hero_name)
	if not self.supporter_heroes[hero_name] then return true end

	return Supporters:GetLevel(player_id) >= self.supporter_heroes[hero_name]
end

HeroSelection:Init()
