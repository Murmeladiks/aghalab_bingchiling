LinkLuaModifier( "modifier_creature_gaoler_attacked", "modifiers/hellmodemodifier/modifier_creature_gaoler_attacked", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_undead_tusk_mage_passive", "modifiers/hellmodemodifier/modifier_undead_tusk_mage_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pudge_flesh_heap_dark_moon", "modifiers/hellmodemodifier/modifier_pudge_flesh_heap_dark_moon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_void_spirit_damage_enhence", "modifiers/hellmodemodifier/modifier_boss_void_spirit_damage_enhence", LUA_MODIFIER_MOTION_NONE )


if CDotaSpawner == nil then
	CDotaSpawner = class({})
end

----------------------------------------------------------------------------

function CDotaSpawner:constructor( szSpawnerNameInput, szLocatorNameInput, rgUnitsInfoInput )
	self.szSpawnerName = szSpawnerNameInput
	self.szLocatorName = szLocatorNameInput
	self.rgUnitsInfo = rgUnitsInfoInput
	self.rgSpawners = {}
	self.Encounter = nil
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnerType()
	return "CDotaSpawner"
end

----------------------------------------------------------------------------

function CDotaSpawner:Precache( context )
	--print( "CDotaSpawner:Precache called for " .. self.szSpawnerName )

	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		PrecacheUnitByNameSync( rgUnitInfo.EntityName, context, -1 )
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:OnEncounterLoaded( EncounterInput )
	print( "CDotaSpawner:OnEncounterLoaded called for " .. self.szSpawnerName )
	self.Encounter = EncounterInput
	self.rgSpawners = self.Encounter:GetRoom():FindAllEntitiesInRoomByName( self.szLocatorName, false )
	if #self.rgSpawners == 0 then
		print( "Failed to find entity " .. self.szSpawnerName .. " as spawner position in map " .. self.Encounter:GetRoom():GetMapName() )
	end
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnPositionCount()
	return #self.rgSpawners
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnCountPerSpawnPosition()

	local nCount = 0
	for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
		nCount = nCount + rgUnitInfo.Count
	end
	return nCount

end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnUnits()
	
	if #self.rgSpawners == 0 then
		print( "ERROR - Spawner " .. self.szSpawnerName .. " found no spawn entities, cannot spawn" )
		return
	end

	local nSpawned = 0

	local hSpawnedUnits = {}

	for nSpawnerIndex,hSpawner in pairs( self.rgSpawners ) do
		local vLocation = hSpawner:GetAbsOrigin()
		for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
			local hSingleSpawnedUnits = self:SpawnSingleUnitType( rgUnitInfo, vLocation )
			nSpawned = nSpawned + rgUnitInfo.Count

			for _,hUnit in pairs ( hSingleSpawnedUnits ) do
				table.insert( hSpawnedUnits, hUnit )
			end
		end
	end

	printf( "%s spawning %d units", self.szSpawnerName, nSpawned )

	if #hSpawnedUnits > 0 then
		self.Encounter:OnSpawnerFinished( self, hSpawnedUnits )
	end

	return hSpawnedUnits
end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnSingleUnitType( rgUnitInfo, vLocation )
	local hSpawnedUnits = {}
	for i=1,rgUnitInfo.Count do
		local vSpawnPos = vLocation
		if rgUnitInfo.PositionNoise ~= nil then
			vSpawnPos = vSpawnPos + RandomVector( RandomFloat( 0.0, rgUnitInfo.PositionNoise ) )
		end
		
		
		local hUnit = CreateUnitByName( rgUnitInfo.EntityName, vSpawnPos, true, nil, nil, rgUnitInfo.Team )
		
		local hell = CustomNetTables:GetTableValue( "hell_mode", "hell" )
		
		if hell and  hell.hell == 0 then
			--hUnit:CreatureLevelUp( 1 )
			if  rgUnitInfo.EntityName =="npc_dota_creature_frostbitten_ranged" then
				local unitname = "npc_dota_creature_frostbitten_ranged1"
				local hellunit = CreateUnitByName( unitname, vSpawnPos, true, nil, nil, rgUnitInfo.Team )
			end
			-- if  rgUnitInfo.EntityName =="npc_dota_creature_temple_guardian" then
			-- 	local unitname = "npc_dota_creature_temple_guardian"
			-- 	local hellunit = CreateUnitByName( unitname, vSpawnPos, true, nil, nil, rgUnitInfo.Team )
			-- end
			if  rgUnitInfo.EntityName =="npc_dota_creature_treant_miniboss" then
				local unitname = "npc_dota_creature_treant_miniboss1"
				local hellunit = CreateUnitByName( unitname, vSpawnPos, true, nil, nil, rgUnitInfo.Team )
			end
			if  rgUnitInfo.EntityName =="npc_dota_creature_drow_ranger_miniboss" then
				local sniper_headshot = hUnit:AddAbility("sniper_headshot")
				local nLevel = GameRules.Aghanim:GetAscensionLevel()
				print("sniper_headshot set level")
				print(nLevel)
				sniper_headshot:SetLevel(nLevel)
			end
			if  rgUnitInfo.EntityName =="npc_dota_creature_dazzle" then
				local troll_warlord_fervor = hUnit:AddAbility("troll_warlord_fervor")
				local nLevel = GameRules.Aghanim:GetAscensionLevel()
				troll_warlord_fervor:SetLevel(nLevel)
			end

			
			if  rgUnitInfo.EntityName =="npc_dota_creature_monkey_king" then
				local item  = CreateItem("item_echo_sabre", hUnit, hUnit)
				hUnit:AddItem(item)
			end
			
			if  rgUnitInfo.EntityName =="npc_dota_creature_gaoler" then
				
				hUnit:AddNewModifier(hUnit, nil, "modifier_creature_gaoler_attacked", {})
			end
			if  rgUnitInfo.EntityName =="npc_dota_creature_skeleton_mage" then
				
				hUnit:AddNewModifier(hUnit, nil, "modifier_undead_tusk_mage_passive", {})
			end
			if  rgUnitInfo.EntityName =="npc_dota_creature_pudge_miniboss" then
				
				hUnit:AddNewModifier(hUnit, nil, "modifier_pudge_flesh_heap_dark_moon", {})
			end
			if  rgUnitInfo.EntityName =="npc_dota_creature_stonehall_ranged_creep" then
				local unitname = "npc_dota_creature_legion_commander"
				local hellunit = CreateUnitByName( unitname, vSpawnPos, true, nil, nil, rgUnitInfo.Team )
			end
			if  rgUnitInfo.EntityName =="npc_dota_creature_pugna_grandmaster" then
				local unitname = "npc_dota_creature_tidehunter_large"
				local hellunit = CreateUnitByName( unitname, vSpawnPos, true, nil, nil, rgUnitInfo.Team )
			end

			if  rgUnitInfo.EntityName =="npc_dota_creature_year_beast" then
				local unitname = "npc_dota_creature_spectre"
				local hellunit = CreateUnitByName( unitname, vSpawnPos, true, nil, nil, rgUnitInfo.Team )	
			end
			if  rgUnitInfo.EntityName =="npc_aghsfort_creature_dire_assault_captain" then
				
				local unitname = "npc_dota_creature_ogre_tank_boss"
				local hellunit = CreateUnitByName( unitname, vSpawnPos, true, nil, nil, rgUnitInfo.Team )	
			end
			if  rgUnitInfo.EntityName =="npc_dota_boss_void_spirit" then
				
				hUnit:AddNewModifier(hUnit, nil, "modifier_boss_void_spirit_damage_enhence", {})
			end
		end
		

		if hUnit == nil then
			print( "ERROR! Failed to spawn unit named " .. rgUnitInfo.EntityName )

		else
			hUnit:FaceTowards( vLocation )
			if rgUnitInfo.PostSpawn ~= nil then
				rgUnitInfo.PostSpawn( hUnit )
			end
			table.insert( hSpawnedUnits, hUnit )
		end
	end

	return hSpawnedUnits
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawners()
	return self.rgSpawners
end

----------------------------------------------------------------------------

function CDotaSpawner:SpawnUnitsFromRandomSpawners( nSpawners )
	print( "spawning from " .. nSpawners .. " " .. self.szSpawnerName .. " spawners out of " .. #self.rgSpawners )
	local hAllSpawnedUnits = {}
	local Spawners = nil
	for n=1,nSpawners do
		if Spawners == nil or #Spawners == 0 then
			Spawners = deepcopy( self.rgSpawners )
		end

		--print ( #Spawners .. " potential spawners to use." )

		local nIndex = math.random( 1, #Spawners )
		local Spawner = Spawners[ nIndex ]
		if Spawner == nil then
			print ( "ERROR!  SpawnUnitsFromRandomSpawners went WRONG!!!!!!!!!!!!!" )
		else
			local vLocation = Spawner:GetAbsOrigin()
			for _,rgUnitInfo in pairs ( self.rgUnitsInfo ) do
				local hSpawnedUnits = self:SpawnSingleUnitType( rgUnitInfo, vLocation )
				for _,hUnit in pairs ( hSpawnedUnits ) do
					table.insert( hAllSpawnedUnits, hUnit )
				end
			end
		end 
		table.remove( Spawners, nIndex )
	end

	if #hAllSpawnedUnits > 0 then
		self.Encounter:OnSpawnerFinished( self, hAllSpawnedUnits )
	end

	return hAllSpawnedUnits
end

----------------------------------------------------------------------------

function CDotaSpawner:GetSpawnerName()
	return self.szSpawnerName
end

----------------------------------------------------------------------------

function CDotaSpawner:GetLocatorName()
	return self.szLocatorName
end