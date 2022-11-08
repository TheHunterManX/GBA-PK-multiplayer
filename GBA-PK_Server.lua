local IPAddress, Port = "127.0.0.1", 4096
local GameID = ""
local GameCode = "None"
local Nickname = ""
local ConfirmPackett = 0
local EnableScript = false
local u32 GameInitializedByteAddress1 = 0
local u32 GameInitializedByteAddress2 = 0
local u32 GameInitializedByteAddress3 = 0
local ClientConnection

local u32 SpriteTempVar0 = 0
local u32 SpriteTempVar1 = 0

--Map ID
local u32 MapAddress = 0
local u32 MapAddress2 = 0
local PlayerID = 1
local ScriptTime = 0
local ScriptTimePrev = 0
local initialized = 0
local ScriptTimeFrame = 4

--Internet Play
--local tcp = assert(socket.tcp())
local SocketMain = socket:tcp()
local Player2 = socket:tcp()
local Player3 = socket:tcp()
local Player4 = socket:tcp()
local Player1ID = "None"
local Player2ID = "None"
local Player3ID = "None"
local Player4ID = "None"
local Packett
local MasterClient = "a"
--timout = every connection attempt
local timeoutmax = 600
local timeout1 = 0
local timeout2 = 0
local timeout3 = 0
local ReturnConnectionType = ""
local FramesPS = 0

--Server Switches
local Player1Vis = 1
local Player2Vis = 0
local Player3Vis = 0
local Player4Vis = 0

--Player 1
local Player1Visible = true
local MapID = 0
local MapX = 0
local MapY = 0
local MapStartX = 0
local MapStartY = 0
local MapXPrev = 0
local MapYPrev = 0
local NewMapX = 0
local NewMapY = 0
local PlayerX = 0
local PlayerY = 0
local NewMapXPos = 0
local NewMapYPos = 0
local Facing = 0
local PlayerExtra1 = 0
local PlayerExtra2 = 0
local PlayerExtra3 = 0
local PlayerExtra4 = 0
local PlayerDirection = 0
local PlayerDirectionPrev = 0

--Player 2
local Player2Visible = false
local MapID2 = 0
local MapX2 = 0
local MapY2 = 0
local MapStartX2 = 0
local MapStartY2 = 0
local MapX2Prev = 0
local MapY2Prev = 0
local NewMapX2 = 0
local NewMapY2 = 0
local Player2X = 0
local Player2Y = 0
local NewMapX2Pos = 0
local NewMapY2Pos = 0
local Facing2 = 0
local Player2Extra1 = 0
local Player2Extra2 = 0
local Player2Direction = 0
local Player2DirectionPrev = 0

--Player 3
local Player3Visible = false
local MapID3 = 0
local MapX3 = 0
local MapY3 = 0
local Player3X = 0
local Player3Y = 0
local NewMapX3 = 0
local NewMapY3 = 0
local NewMapX3Pos = 0
local NewMapY3Pos = 0
local Facing3 = 0
local Player3Extra1 = 0
local Player3Extra2 = 0

--Player 4
local Player4Visible = false
local MapID4 = 0
local MapX4 = 0
local MapY4 = 0
local Player4X = 0
local Player4Y = 0
local NewMapX4 = 0
local NewMapY4 = 0
local NewMapX4Pos = 0
local NewMapY4Pos = 0
local Facing4 = 0
local Player4Extra1 = 0
local Player4Extra2 = 0

--Player char start addresses

--Player Stats
local PlayerMapID = 0
local PlayerMapIDPrev = 0
local u8 PlayerMapX = 0
local u8 PlayerMapY = 0
local PlayerMapXMove = 0
local PlayerMapYMove = 0
local PlayerMapXMovePrev = 0
local PlayerMapYMovePrev = 0
local PlayerDirection = 0
local PlayerDirectionPrev = 0


--To check if map is new
local PlayerNewMap = 0
local NewMap = 0
local NewMap2 = 0
local NewMap3 = 0
local NewMap4 = 0

--To check if map was teleported to or entered through connection (0 for teleport, 1 for enter)
local NewMapConnect = 0
local NewMapConnect2 = 0
local NewMapConnect3 = 0
local NewMapConnect4 = 0

--Prev maps
local NewMapConnectPrev = 0
local NewMapConnect2Prev = 0
local NewMapConnect3Prev = 0
local NewMapConnect4Prev = 0


--Add camera movement. from +16 to -16
local PlayerXCamera = 0
local PlayerYCamera = 0
local PlayerXCamera2 = 0
local PlayerYCamera2 = 0
local u8 PlayerFacing = 0
local u16 ActualPlayerExtra1 = 0
local u8 ActualPlayerExtra2 = 0
--If 0 then don't render players

--Animation frames
local Player1AnimationFrame = 0
local Player1AnimationFrame2 = 0
local Player2AnimationFrame = 0
local Player2AnimationFrame2 = 0
local Player3AnimationFrame = 0
local Player3AnimationFrame2 = 0
local Player4AnimationFrame = 0
local Player4AnimationFrame2 = 0
local PlayerPrevAnimation = {0,0,0,0}

--Addresses
local u32 Player1Address = 0
local u32 Player2Address = 0
local u32 Player3Address = 0
local u32 Player4Address = 0


local AnimatePlayerMoveX = 0
local AnimatePlayerMoveY = 0

local NewMapNewX = 0
local NewMapNewY = 0
			
local FFTimer = 0
local FFTimer2 = 0
local ScreenData = 0

local Pokemon = {"","","","","",""}

local EnemyPokemon = {"","","","","",""}

local ConsoleForText
local Keypressholding = 0
local LockFromScript = 0
local HideSeek = 0
local HideSeekTimer = 0
local ROMCARD
if not (emu == nil) then ROMCARD = emu.memory.cart0 end
local BufferString = "None"
local PrevExtraAdr = 0
local SendTimer = 0
local Var8000 = {}
local u32 Var8000Adr = {}
local Startvaraddress = 0
local TextSpeedWait = 0
local OtherPlayerHasCancelled = 0
local TradeVars = {0,0,0,0,0}
local EnemyTradeVars = {0,0,0,0,0}
local BattleVars = {0,0,0,0,0,0,0,0,0,0,0}
local EnemyBattleVars = {0,0,0,0,0,0,0,0,0,0,0}
local BufferVars = {0,0,0}
TradeVars[5] = 1000000000100000000010000000001000000000


					--Decryption for positioning/small packetts
					local ReceiveDataSmall = {}
					
--Debug time is how long in frames each message should show. once every 300 frames, or 5 seconds, should be plenty
local DebugTime = 300
local DebugTime2 = 30
local DebugTime3 = 1
local TempVar1 = 0
local TempVar2 = 0
local TempVar3 = 0

function ClearAllVar()

	LockFromScript = 0
	
	 GameID = ""
	 GameCode = "None"
--	 Nickname = ""
	 ConfirmPackett = 0
	 EnableScript = false
	 GameInitializedByteAddress1 = 0
	 GameInitializedByteAddress2 = 0
	 GameInitializedByteAddress3 = 0

	 SpriteTempVar0 = 0
	 SpriteTempVar1 = 0

--Map ID
	 MapAddress = 0
	 MapAddress2 = 0
--	 PlayerID = 1
	 ScriptTime = 0
	 initialized = 0

--Server Switches
	 Player1Vis = 1
	 Player2Vis = 0
	 Player3Vis = 0
	 Player4Vis = 0

--Player 1
	 Player1Visible = true
	 MapID = 0
	 MapX = 0
	 MapY = 0
	 NewMapX = 0
	 NewMapY = 0
	 PlayerX = 0
	 PlayerY = 0
	 NewMapXPos = 0
	 NewMapYPos = 0
	 Facing = 0
	 PlayerExtra1 = 0
	 PlayerExtra2 = 0
	 PlayerExtra3 = 0
	 PlayerExtra4 = 0

--Player 2
	 Player2Visible = false
	 MapID2 = 0
	 MapX2 = 0
	 MapY2 = 0
	 NewMapX2 = 0
	 NewMapY2 = 0
	 Player2X = 0
	 Player2Y = 0
	 NewMapX2Pos = 0
	 NewMapY2Pos = 0
	 Facing2 = 0
	 Player2Extra1 = 0
	 Player2Extra2 = 0

--Player 3
	 Player3Visible = false
	 MapID3 = 0
	 MapX3 = 0
	 MapY3 = 0
	 Player3X = 0
	 Player3Y = 0
	 NewMapX3 = 0
	 NewMapY3 = 0
	 NewMapX3Pos = 0
	 NewMapY3Pos = 0
	 Facing3 = 0
	 Player3Extra1 = 0
	 Player3Extra2 = 0

--Player 4
	 Player4Visible = false
	 MapID4 = 0
	 MapX4 = 0
	 MapY4 = 0
	 Player4X = 0
	 Player4Y = 0
	 NewMapX4 = 0
	 NewMapY4 = 0
	 NewMapX4Pos = 0
	 NewMapY4Pos = 0
	 Facing4 = 0
	 Player4Extra1 = 0
	 Player4Extra2 = 0

--Player char start addresses

--Player Stats
	 PlayerMapID = 0
	 PlayerMapX = 0
	 PlayerMapY = 0
	 PlayerMapXMove = 0
	 PlayerMapYMove = 0
	 PlayerMapXMovePrev = 0
	 PlayerMapYMovePrev = 0
--Add camera movement. from +16 to -16
	 PlayerXCamera = 0
	 PlayerYCamera = 0
	 PlayerFacing = 0
	 ActualPlayerExtra1 = 0
	 ActualPlayerExtra2 = 0
--If 0 then don't render players
	ScreenData = 0


--Debug time is how long in frames each message should show. once every 300 frames, or 5 seconds, should be plenty
	DebugTime = 300
	DebugTime2 = 30
	DebugTime3 = 1
	TempVar1 = 0
	TempVar2 = 0
	TempVar3 = 0
	 
end


function GetGameVersion()
	GameCode = emu:getGameCode()
	if (GameCode == "AGB-BPRE") or (GameCode == "AGB-ZBDM")
	then
		local GameVersion = emu:read16(134217916)
		if GameVersion == 26624 then
			ConsoleForText:print("Pokemon Firered 1.0 detected. Script enabled.")
			EnableScript = true
			GameID = "BPR1"
		elseif GameVersion == 26369 then
			ConsoleForText:print("Pokemon Firered 1.1 detected. Script enabled.")
			EnableScript = true
			GameID = "BPR2"
		else
			ConsoleForText:print("Unknown version of Pokemon Firered detected. Defaulting to 1.0. Script enabled.")
			EnableScript = true
			GameID = "BPR1"
		end
	elseif (GameCode == "AGB-BPGE")
		then
		local GameVersion = emu:read16(134217916)
		if GameVersion == 33024 then
			ConsoleForText:print("Pokemon Leafgreen 1.0 detected. Script enabled.")
			EnableScript = true
			GameID = "BPG1"
		elseif GameVersion == 32769 then
			ConsoleForText:print("Pokemon Leafgreen 1.1 detected. Script enabled.")
			EnableScript = true
			GameID = "BPG2"
		else
			ConsoleForText:print("Unknown version of Pokemon Leafgreen detected. Defaulting to 1.0. Script enabled.")
			EnableScript = true
			GameID = "BPG1"
		end
	elseif (GameCode == "AGB-BPEE")
		then
			ConsoleForText:print("Pokemon Emerald detected. Script disabled.")
			EnableScript = true
			GameID = "BPEE"
	elseif (GameCode == "AGB-AXVE")
		then
			ConsoleForText:print("Pokemon Ruby detected. Script disabled.")
			EnableScript = true
			GameID = "AXVE"
	elseif (GameCode == "AGB-AXPE")
		then
			ConsoleForText:print("Pokemon Sapphire detected. Script disabled.")
			EnableScript = true
			GameID = "AXPE"
	else
		ConsoleForText:print("Unknown game. Script disabled.")
		EnableScript = false
	end
	ConsoleForText:moveCursor(0,2)
end

--To fit everything in 1 file, I must unfortunately clog this file with a lot of sprite data. Luckily, this does not lag the game. It is just hard to read.
--Also, if you are looking at this, then I am sorry. Truly      -TheHunterManX
function createChars(StartAddressNo, SpriteID, SpriteNo)
	--0 = Tile 184, 1 = Tile 188, etc...
	--Tile number 184 = Player1
	--Tile number 188 = Player2
	--Tile number 192 = Player3
	--Tile number 196 = Player4
	--First will be the 4 bytes, or 32 bits
	--SpriteID means a sprite from the chart below
	--1 = Side Left (Right must be set with facing variable)
	--2 = Side Up
	--3 = Side Down
	--4-9 = Walking
	--10-12 = Biking Idle Positions
	--13-18 = Biking
	--19-21 = Running Idle Positions
	--22-27 = Running
	--28-33 = Surfing stuff
	
	
	--Start address. 100745216 = 06014000 = 184th tile. can safely use 32.
	--Because the actual data doesn't start until 06013850, we will skip 50 hexbytes, or 80 decibytes
	local ActualAddress = 100745216 + (StartAddressNo * 1024) + 80
	--Firered Male Sprite
	if SpriteNo == 0 then
		if SpriteID == 1 then
			--Side Left
			SpriteTempVar0 = ActualAddress
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149633664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149699231
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973279
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435834096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290639872
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 871576576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 843202560
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859045888
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227195
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16305356
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16025804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008328
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1000225
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 62243
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1041475
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098359296
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1875378176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1758396416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1072693248
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1206910976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3337617408
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16637583
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16047862
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16664822
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044467
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65396
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 246
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 2 then
		--Side Up
			SpriteTempVar0 = ActualAddress
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149711360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435974400
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435958016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4240982512
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290414576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1095040768
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1157623808
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293160704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227195
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16305356
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253005007
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255805576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729108
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048388
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16731903
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3438043712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3712762688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3723490304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4008140800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1317007360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284936192
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16711680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 69652172
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 70567133
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 5242589
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 425710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1009407
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 3 then
		--Side Down
			SpriteTempVar0 = ActualAddress
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713152
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2630668032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3402269168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576806896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717784320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790839040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607338496
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860843776
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567497
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253275308
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255814041
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16004710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15938290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 275266
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16184371
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4291191360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2898670400
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2614096896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284964864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4152356864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258404352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16711680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 69627135
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 70479050
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 5242041
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 423679
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1009392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 4 then
		--Side Left Walk Cycle 1
			SpriteTempVar0 = ActualAddress 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290614272
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149692928
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149645824
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 20 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 34952
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 576443
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 572347
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149633664
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149699231
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435965599
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435973279
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435834096
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290639872
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 871576576
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 843202560
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9223099
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9227195
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9227468
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16305356
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16025804
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16008328
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1000228
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 62243
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 859045888
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1682898944
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1713565696
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1714679808
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4283367424
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4293918720
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 8 
			SpriteTempVar1 = 1041475
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16637512
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16047814
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16664783
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1042039
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1009263
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 65520
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 5 then
		--Side Left Walk Cycle 2
			SpriteTempVar0 = ActualAddress 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290614272
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149692928
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149645824
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 20 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 34952
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 576443
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 572347
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149633664
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149699231
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435965599
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435973279
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435834096
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290639872
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 871576576
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 843202560
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9223099
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9227195
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9227468
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16305356
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16025804
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16008328
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1000228
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 62243
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 859045888
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4098359296
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1825046528
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4244570112
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2146889728
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4140822528
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 268369920
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 8 
			SpriteTempVar1 = 1041475
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16637542
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16007718
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16663350
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1000703
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 65535
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
		elseif SpriteID == 6 then
		--Side Up Walk Cycle 1
			SpriteTempVar0 = ActualAddress 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290614272
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149692928
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149627392
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 20 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 34952
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 576443
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 572347
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149645824
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149711360
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435974400
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435958016
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4240982512
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290414576
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1095040832
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1157587776
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9223099
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9227195
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16567500
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16305356
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 253005007
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255805576
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16729108
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 327492
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4282672704
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3438046976
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3712761856
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3723292672
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3739676672
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1315307520
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4152295424
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 8 
			SpriteTempVar1 = 1008895
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16142028
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255247581
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255053533
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16740077
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 65508
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
		elseif SpriteID == 7 then
		--Side Up Walk Cycle 2
			SpriteTempVar0 = ActualAddress 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290614272
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149692928
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149627392
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 20 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 34952
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 576443
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 572347
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149645824
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149711360
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435974400
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3435958016
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4240982512
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290414576
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1095040768
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1157578752
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9223099
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9227195
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16567500
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16305356
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 253005007
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255805576
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 83837972
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 70713156
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4282839040
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3437522688
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3712771056
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3723244528
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3739680512
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1325334528
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4278190080
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 8 
			SpriteTempVar1 = 73811199
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16174796
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 312541
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1035997
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1011437
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 26340
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 63359
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4080
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
		elseif SpriteID == 8 then
		--Side Down Walk Cycle 1
			SpriteTempVar0 = ActualAddress 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290614272
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149692928
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149627392
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 20 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 34952
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 576443
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 572347
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149645824
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149713152
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2630668032
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3402269168
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2576806896
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1717784320
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 790839104
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 607340084
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9223099
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16567227
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16567497
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 253275308
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255814041
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16004710
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 15938290
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 275266
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 860878388
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4287393776
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2899066880
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2614095872
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4285001728
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1736376320
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4134469632
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 8 
			SpriteTempVar1 = 1045555
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16149759
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4334794
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4404409
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 282623
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			--End of block
		elseif SpriteID == 9 then
		--Side Down Walk Cycle 2
			SpriteTempVar0 = ActualAddress 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2290614272
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149692928
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149627392
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 20 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 34952
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 576443
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 572347
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149645824
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3149713152
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2630668032
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 3402269168
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2576806896
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1717784320
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 790839040
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 607338496
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 9223099
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16567227
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16567497
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 253275308
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 255814041
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 16004710
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 83047154
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1130640194
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 860876800
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4291194624
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2890015744
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 2604872704
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4294197248
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4278190080
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 8 
			SpriteTempVar1 = 1131410483
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 267831551
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 314570
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1047737
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 1013503
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 63350
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 63087
			emu:write32(SpriteTempVar0, SpriteTempVar1) 
			SpriteTempVar0 = SpriteTempVar0 + 4 
			SpriteTempVar1 = 4080
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			SpriteTempVar0 = SpriteTempVar0 + 4
			SpriteTempVar1 = 0
			emu:write32(SpriteTempVar0, SpriteTempVar1)
			--End of block
		elseif SpriteID == 10 then
		--Side Left Bike Facing
		--Due to it being a 64x64, it requires far more space
			SpriteTempVar0 = ActualAddress - 80
			 	SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 2290614272
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3149692928
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3149645824
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3149633664
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3149699231
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3435965599
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 34952
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 576443
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 572347
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 9223099
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 9227195
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 9227468
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3435973279
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3435834096
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 2290639872
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 871576576
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 843203584
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 859062016
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1867493120
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1713568496
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 16305356
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 16025804
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 16008328
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1000228
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 62243
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1041475
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 16637512
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 16047686
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1610612736
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 4127195136
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1331691520
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 4210032640
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1794113536
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 2936012800
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 4026531840
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1714682608
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 4287614966
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 2298466303
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 2147482697
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 3338334400
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 4294601209
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1026730
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 65535
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 16664783
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 107999112
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 1879048184
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 4131671287
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 2936852470
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 2795476655
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 4205488880
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 268435200
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 6
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 15
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 15
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
				SpriteTempVar0 = SpriteTempVar0 + 4 
				SpriteTempVar1 = 0
				emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 11 then
		--Side Up Bike Facing
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149711360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435974400
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227195
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435958016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4240982512
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290414576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1095040768
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1157575664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293288944
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3712773888
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3723292672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16305356
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253005007
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255805576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729108
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255065924
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255225599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16172253
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1035997
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1313665024
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1149235200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2901409792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1033444
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046340
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 12 then
		--Side Down Bike Facing
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713152
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2630668032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3402269168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576806896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717784320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790839040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607342336
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860843776
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284690176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567497
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253275308
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255814041
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16004710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15938290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16003906
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16184371
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15873791
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2858630912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3488890880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294963200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2901409792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 282620
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 13 then
		--Side Left Bike Cycle 1
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290089984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150446592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149498368
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150547440
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435842032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 559240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9157563
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147569595
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147635131
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147639500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435964912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3433737984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290499584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1060323328
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 606356480
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860110592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1867493120
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1713568496
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 260885708
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256412876
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256133256
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16003651
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 995891
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16663603
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266200198
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256763126
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4127195136
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1868562432
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4210032640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1794113536
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1714682608
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4287614966
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2298466303
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003827785
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1828384960
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294602655
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026730
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266636534
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 117374856
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879048184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4131671295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936852479
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2801399471
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205488880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268435200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 14 then
		--Side Left Bike Cycle 2
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290647040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149642880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149642120
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149646217
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973321
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 36027
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 35771
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576699
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576716
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973801
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965103
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290648640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1128215360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 858006528
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859000576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1716498176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1713568496
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1019084
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1001612
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1000520
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 62514
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3890
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65092
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1039844
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1002980
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4127195136
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1331691520
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4210032640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1794113536
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4130601712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4287614966
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2298466303
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294966345
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2147152064
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3338301343
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4279216810
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1041548
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 107413240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879048184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4131671295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936852471
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2801399542
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205488895
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268435200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 15 then
		--Side Up Bike Cycle 1
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290647040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149641728
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149642880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149646976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973872
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 36027
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 35771
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576699
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1035468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435972848
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4291593247
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290634559
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1142181872
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1146090480
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294861808
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3721711360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3722366720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1019084
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15812812
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15987848
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16774209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255066100
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255223023
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16739405
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1002733
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1155854336
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1146052608
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294963200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2901409792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046350
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65396
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 16 then
		--Side Up Bike Cycle 2
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290089984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150446592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149398016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150741504
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435982848
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 559240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9157563
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147569595
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147635131
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 265080012
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435720704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3431210752
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2286894848
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 340786944
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1342125040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4266025968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3569811200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3737448448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 260885708
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4048080127
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4092889224
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267665732
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255849540
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255258623
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16535005
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16575965
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3833528320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1207894016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1003076
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 455748
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 17 then
		--Side Down Bike Cycle 1
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290647040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149641728
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149642880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149647088
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 36027
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 35771
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1035451
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2580335856
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3433867295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576969535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717974256
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 586298352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 574829808
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859109104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294127360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1035468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15829706
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15988377
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1000294
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 996143
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 17204
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1011523
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15873647
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2858630912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3488890880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294336512
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2902454272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 282620
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 18 then
		--Side Down Bike Cycle 2
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290089984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150446592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149398016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150770176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 559240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9157563
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147569595
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 265075643
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435982848
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896699136
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2574204672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1714745344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4063490048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1127481344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 888598528
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133695232
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 265079961
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4052404940
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4093024665
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256075366
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255012642
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256062498
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258949939
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15876095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2858630912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3488890880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 282620
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 421887
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048527
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 19 then
		--Run Side Left Idle
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149633664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149699231
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973279
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435834096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290639872
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 871576576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 843202560
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859045888
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227195
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16305356
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16025804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008328
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1000228
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16708387
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266200131
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4236247040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1693450240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 804257792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1056964608
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256763078
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266637254
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16711666
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046515
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3948
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 20 then
		--Run Side Left Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149633664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149699231
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973279
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435834096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290639872
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 871576576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 843202560
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227195
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16305356
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16025804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 150226056
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2166309668
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2180969251
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859340800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4143065088
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1727215616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415915008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266200131
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256765516
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266635468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16707468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16289655
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1033983
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 21 then
		--Run Side Left Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149633664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149699231
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973279
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435834096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290639872
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 871576704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 843202944
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227195
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227468
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16305356
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16025804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008328
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16728868
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266269475
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859080704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1149239296
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3488612352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003763200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1828651008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 265847875
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 260190052
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 260259695
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16777164
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 22 then
		--Run Side Up Idle
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713152
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435954672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435676656
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4169416448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1095300096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1157587520
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293276480
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253283532
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255102156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15943823
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 5211156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 69664580
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 70479615
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3712970496
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3723292672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1307045888
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4009689088
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4134469632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267386880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16184541
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1035997
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1015508
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65518
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 63087
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 23 then
		--Run Side Up Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713152
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435954672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435676656
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4169416448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1095302912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1157578496
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253283532
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255102156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15943823
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1016852
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048388
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4176015360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3722244096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3722440704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1155465216
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4009099264
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1727004672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2867855360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16740351
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253906925
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255065325
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16738285
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4094
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 24 then
		--Run Side Up Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713152
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435954672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435676656
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4169416448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1095299072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1157623808
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253283532
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255102156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15943823
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16745492
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15990596
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294377216
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3740541680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3738121200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3732340480
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4025483264
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1019535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1035741
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048029
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64836
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 28654
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3942
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4010
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 25 then
		--Run Side Down Idle
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149647616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2899083760
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3402298352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576764672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717778160
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790886128
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860827392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16563131
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268225467
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253283530
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255831212
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16017817
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258160230
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258945778
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15922227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1156789248
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2898718720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4285464576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4134469632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267386880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4407108
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1010890
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 63231
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 63087
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 26 then
		--Run Side Down Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149647616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713152
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2899083760
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3402298352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576764672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717780224
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790884352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 143440827
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2180823995
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2180828091
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253283530
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255831212
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16017817
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939174
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 996082
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860876800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284936192
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2283732992
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 587137024
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 871366656
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1045555
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1036287
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1010858
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 63224
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65400
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4010
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 27 then
		--Run Side Down Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149647640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2899083760
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3402298352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576764672
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717780224
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790884352
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16563131
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253283530
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255831212
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16017817
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939174
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 996082
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860876800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294766592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2865164288
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2406416384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2281635840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2867855360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1045555
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1009407
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 61832
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65314
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3891
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 28 then
		--Surf down idle Cycle 1
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1727987712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003201792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65382
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148087
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718265455
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1722459897
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1722808576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4285071360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4134184550
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674567782
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10484326
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 38655
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 29 then
		--Surf up idle Cycle 1
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2013200384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004250368
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148343
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987065
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718615952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2583064320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9857280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 626688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674288230
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 167769702
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16150425
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9857280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 626688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 30 then
		--Surf side idle Cycle 1
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718025984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046118
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199728
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199590
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987942
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267806311
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986919
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2559
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3942
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717988089
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718024592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294545408
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284900966
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577360486
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 630783
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 40806
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 31 then
		--Surf down idle Cycle 2
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4186963968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1727987712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003201792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65382
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148087
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2463
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576351232
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718265593
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1722460569
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1869191424
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674566758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577050214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10065654
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 32 then
		--Surf up idle Cycle 2
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4186963968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2013200384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004250368
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148343
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2463
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576351232
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987065
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4194303897
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576771472
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10066176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674288230
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2583691167
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 160852377
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10066176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 33 then
		--Surf side idle Cycle 2
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718025984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199728
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199590
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987942
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004390
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046118
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267806311
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986919
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 40959
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2463
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004393
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718024601
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1869191568
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576941056
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1777755750
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2426011503
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 629145
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 40806
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 39270
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 34 then
		--Surf sit down
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149713152
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2630668032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3402269168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576806896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717784320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790839040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607338496
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860843776
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567227
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567497
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253275308
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255814041
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16004710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15938290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 275266
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16184371
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4291781184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2898670400
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4135056384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2137452544
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284936192
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16711680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 69663999
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 70479050
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 5207919
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1009399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1009407
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 35 then
		--Surf sit up
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 2290614272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149627392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149645824
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 34952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 576443
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 572347
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149711360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435974400
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435958016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4240982512
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290414576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1095040768
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1157623808
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293160704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9227195
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16567500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16305356
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 253005007
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255805576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729108
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048388
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16731903
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3438043712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3712762688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3723490304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4008112128
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1325334528
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 69652172
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 70567133
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 5242589
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1011438
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65508
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 36 then
		--Surf sit side
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 2290089984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150446592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149692928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3149498368
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 559240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9223099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9157563
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147569595
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3150547440
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435842032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435964912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3433737984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2290499584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1060323328
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 606339072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859832320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147635131
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 147639500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 260885708
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256412876
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256133256
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16003651
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 995891
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16663619
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1156579328
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4244631552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2406444800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4160515840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4143378432
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268369920
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266201316
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256764159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 266637158
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16711526
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048371
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 136
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
			end
	--Female Sprite
	elseif SpriteNo == 1 then
		if SpriteID == 1 then
			--Side Left
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16423321
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833696
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863310336
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1140012032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1111638016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080271360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262842777
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262851242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4110068940
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282821290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047791718
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132164
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256119169
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132340
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4134404096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 645267456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 685244416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 954728448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1323302912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3404726272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132340
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008271
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048562
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3907
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4068
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 250
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 2 then
		--Side Up
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435832896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863293680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717653488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286543616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 289689344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807722
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 74099916
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289450
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267654758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16007441
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145372416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145369584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4283417584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1726930688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3277778688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205834240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267386880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255804484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255653119
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16764006
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 62780
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 3 then
		--Side Down
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717847280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790843376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607384816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860833008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807754
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258649292
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 83274137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267662066
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256848706
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256177203
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293326064
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1835216640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3613605632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1724706816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3277783040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205772800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267386880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256861695
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15873622
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939198
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044182
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 62780
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 4 then
		--Side Left Walk Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833696
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863310336
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1140012032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1111638016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16423321
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262842777
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262851242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4110068940
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282821290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098123366
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132164
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256119169
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080271360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4134404096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4252368896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2391277568
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4009422848
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4138528768
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16711680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098114804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098114804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256134946
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16731955
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65524
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 63231
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 5 then
		--Side Left Walk Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833696
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863310336
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1140012032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1111638016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16423321
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262842777
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262851242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4110068940
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282821290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047791718
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132164
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255924244
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080271360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4100325376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1109917696
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1127804928
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3830444032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294901760
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098114804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098114804
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132351
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16777198
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044462
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1034863
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65520
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 6 then
		--Side Up Walk Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435832896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863293680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717653488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286543616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807722
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 74099916
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289450
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267654758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16007441
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 289689344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145327360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145369584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4283417584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1825505024
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294901760
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255083588
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 849151
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3955
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4010
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 7 then
		--Side Up Walk Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435832896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863293680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717653488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286543616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807722
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 74099916
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289450
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267654758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16007441
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 289689344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145324528
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145372416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4283428608
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827598080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 905965568
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2867855360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008260
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255804484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255653119
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16777158
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		elseif SpriteID == 8 then
		--Side Down Walk Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717847280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790843376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607384816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807754
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258649292
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 83274137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267662066
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256848706
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860828912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293279728
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3580165888
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1986850816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1825505280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 904921088
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2867855360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256177203
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256180223
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16720886
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 996350
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65478
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 9 then
		--Side Down Walk Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717847280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790843376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607384816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807754
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258649292
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 83274137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267662066
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256848706
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860833008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294919408
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3744661248
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2134110208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1828651008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256111667
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267611903
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729686
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1039982
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1043654
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65363
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4010
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 10 then
		--Side Left Bike Facing
		--Due to it being a 64x64, it requires far more space
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717985280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576979456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984726
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863319702
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1638
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27289
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27033
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16427673
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16428202
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965078
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863311456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1144992576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 337912832
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1328762624
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1330622208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4062378736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256879308
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267676330
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252986982
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008260
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16007448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008271
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008271
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1000516
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4127195136
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1331691520
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4210032640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1794113536
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1663302384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879035894
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3909079039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294966345
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3405443264
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294601209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026730
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 107376605
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879048174
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4131671295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936852474
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2795478959
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205488880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268435200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)  
			--End of block
		elseif SpriteID == 11 then
		--Side Up Bike Facing
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807722
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435832896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863293680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717653488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286543616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 289689584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145369584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145372416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 74099916
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289450
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267654758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16007441
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267666449
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255804484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4283408384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3439325184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2901409792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 718079
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048524
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 12 then
		--Side Down Bike Facing
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717847280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790843376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607384816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860833008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284690416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807754
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258649292
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 83274137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267662066
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256848706
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256177203
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267532031
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2858630912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3488890880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294963200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2901409792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 282620
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 13 then
		--Side Left Bike Cycle 1
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980390
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980649
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863312041
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 102
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1705
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1689
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026729
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026762
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435973289
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863311526
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986916
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145303860
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2168603200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1156789248
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1330622208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4062378736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16054956
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729770
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15811686
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1000516
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1000465
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008260
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008271
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008271
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4127195136
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1331691520
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4210032640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1794113536
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4079221488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879035894
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3875524607
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294966345
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294635712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3405410207
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4279216810
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048574
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 107376605
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879048174
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4131671295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936852479
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2801399546
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205488895
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268435200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		elseif SpriteID == 14 then
		--Side Left Bike Cycle 2
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16423321
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262842777
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262851242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833696
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863310336
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1140012032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1111638016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080287488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1330622208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4062378736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4110068940
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282821290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047791718
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132164
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256119169
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132340
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132340
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132351
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4127195136
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1868562432
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4210032640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1794113536
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4079221488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879035894
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026519551
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4289723465
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2902126784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294602655
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026730
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16777062
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 107376605
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1879048174
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4131671295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936852479
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2801399471
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205488880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268435200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 15 then
		--Side Up Bike Cycle 1
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717985280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576979456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984726
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863319702
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1638
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27289
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27033
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6924953
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6925482
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965028
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863310415
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717966079
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286331935
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286541040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145327600
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145369584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282711808
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4631244
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16018090
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16728422
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15798545
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256119057
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267666500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255804484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16732159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294963200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3438977024
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294963200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2901409792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4044
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 16 then
		--Side Up Bike Cycle 2
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717567488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577793024
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576744448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2578093568
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2865403392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 419430
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6920601
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 111778201
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1772788121
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1772923562
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3433718784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863025920
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1712652032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286334720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286344432
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145327600
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145369584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282711808
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1185598668
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4100631210
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282476134
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047573265
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256131345
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267666500
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255804484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16732159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294963200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3438280704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 700364
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 17 then
		--Side Down Bike Cycle 1
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717985280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576979456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3147410070
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1638
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27289
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27033
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6924953
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2865416854
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983796
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717978191
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 586298623
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 574832463
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 859108592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294127360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6925484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16165580
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 5204633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267666534
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098835247
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098159412
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256134979
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15873647
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2858630912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3488890880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294615040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2902454272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1862270976
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 282620
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 18 then
		--Side Down Bike Cycle 2
			SpriteTempVar0 = ActualAddress - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717567488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577793024
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576744448
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2578093568
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 419430
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6920601
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 111778201
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1772788155
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3402274304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3433721600
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577855488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1715752944
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4063556687
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1128219727
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 888423664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133695232
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1772924074
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4138388684
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1332386201
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098123366
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282593058
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4109579298
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256852787
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267534335
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2858630912
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3488890880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1827667968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1610612736
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15939242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 282620
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 700415
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048527
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 19 then
		--Run Side Left Idle
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717985280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576979456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1638
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27289
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27033
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984726
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863319702
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965078
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863311456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1144992576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 522462208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080222208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16427673
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268086442
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098861772
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282673834
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098115174
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145115716
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4098114696
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256133137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2264858624
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 804257792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1065353216
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4269801472
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2936012800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16732008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 52578
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65267
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65263
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4012
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 20 then
		--Run Side Left Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717985280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576979456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1638
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27289
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27033
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984726
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863319702
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965078
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863311456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1144992576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 522462208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16427673
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16428202
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256879308
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267676330
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008260
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256119112
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 523452416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1996423168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3633250304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2365255680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4289523712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16711680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256149576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16720639
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 7287800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 7340014
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044206
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65535
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 21 then
		--Run Side Left Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717985280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576979456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1638
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27289
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 27033
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576980576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984726
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863319702
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435965078
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863311456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1144992576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 522462208
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1026457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16427673
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16428202
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256879308
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267676330
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252986982
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008260
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256119112
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 523517952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4148307968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3745724416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4009750528
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4009099264
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008447
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16777215
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16710894
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16560110
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044735
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 22 then
		--Run Side Up Idle
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863441648
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435816176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717653488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286347008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286543856
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110795161
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258656938
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289996
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267654758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15995153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267665681
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145369584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145372656
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4283417584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3439259392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205834240
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267386880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255804484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268387396
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16577791
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1036236
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 23 then
		--Run Side Up Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863441648
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435816176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717653488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286347008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110795161
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258656938
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289996
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267654758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15995153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 289689344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145372416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4283387648
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1727983360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3439325184
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2867855360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2867855360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 254014719
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255066060
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16715772
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 24 then
		--Run Side Up Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863441648
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435816176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718570992
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286347008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110795161
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258656938
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289996
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267712102
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15995153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 289689344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145372416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294243056
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3436131312
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3489550080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4027576320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1003519
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4044
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4010
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4010
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 25 then
		--Run Side Down Idle
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717997312
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576966896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044865
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16279142
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16165273
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256285081
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258644377
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996719
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435832911
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035087
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718568176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 791936768
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860831488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110795161
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4137339594
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4100631756
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4109805977
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256177766
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16724978
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15987763
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294131456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1724182528
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3439263744
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205772800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267386880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15941631
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1003118
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1040076
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 26 then
		--Run Side Down Cycle 1
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718022144
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576969472
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1009254
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16165273
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16161177
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718568176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 791936768
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110795161
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807754
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258649292
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4093028761
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4081383014
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268383218
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860876800
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294373376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1144979456
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 575602688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 871366656
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16708659
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16642047
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1043558
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 64719
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4088
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4010
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 27 then
		--Run Side Down Cycle 2
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718022144
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576969472
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1009254
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16165273
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16161177
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576984416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035071
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718567999
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 791937008
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110795161
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807754
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258649292
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16165273
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256177766
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16724978
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860880640
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294766592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1724706816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4241424384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2414870528
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2867855360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1045555
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1019903
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1016644
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1037346
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65331
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 28 then
		--Surf down idle Cycle 1
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1727987712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003201792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65382
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148087
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718265455
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1722459897
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1722808576
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4285071360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4134184550
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674567782
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10484326
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 38655
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 29 then
		--Surf up idle Cycle 1
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2013200384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004250368
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148343
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987065
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718615952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2583064320
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9857280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 626688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674288230
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 167769702
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16150425
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9857280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 626688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
			--End of block
		elseif SpriteID == 30 then
		--Surf side idle Cycle 1
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718025984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046118
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199728
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199590
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987942
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267806311
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986919
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2559
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3942
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717988089
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718024592
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4294545408
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4284900966
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577360486
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 630783
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 40806
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
			--End of block
		elseif SpriteID == 31 then
		--Surf down idle Cycle 2
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4186963968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1727987712
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003201792
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65382
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148087
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906295
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 9
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2463
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576351232
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718265593
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1722460569
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1869191424
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674566758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577050214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10065654
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 32 then
		--Surf up idle Cycle 2
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4186963968
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4278190080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2013200384
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004250368
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199599
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16148343
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258369399
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2463
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576351232
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986927
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987065
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4194303897
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576771472
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10066176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2674288230
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2583691167
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 160852377
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 10066176
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 153
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 33 then
		--Surf side idle Cycle 2
		--Skip 2 tiles, aka put in 3rd and 4th tiles to fit sit char
		SpriteTempVar0 = ActualAddress + 512
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293918720
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4026531840
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4177526784
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2566914048
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718025984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199728
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2004248175
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2003199590
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717987942
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004390
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046118
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267806311
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906039
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986919
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986918
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4095
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 40959
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2463
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 159
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2415919104
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718004393
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1718024601
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1869191568
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576941056
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4133906022
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1777755750
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2426011503
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 629145
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 40806
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 39270
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2457
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 34 then
		--Surf sit down
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3113920864
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2896996704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435835376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577035072
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717847280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 790843376
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 607384816
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 860878064
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799259
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807754
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 258649292
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 83274137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132710
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267662066
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256848706
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256898099
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4293869360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3981899328
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3865887552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205367040
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4205375488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267386880
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15987967
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 74409302
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 71091822
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16550575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1018543
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 35 then
		--Surf sit up
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 6986137
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435832896
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863293680
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717653488
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286343664
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 286543616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 289689344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110799257
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 110807722
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 74099916
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256289450
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267654758
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 252973329
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16007441
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008209
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145372416
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1145369584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4283417584
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1726930688
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3439259392
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4279234560
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16729156
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255804484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255653119
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16764006
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65484
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 255
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		elseif SpriteID == 36 then
		--Surf sit side
		SpriteTempVar0 = ActualAddress 
 		SpriteTempVar1 = 1717960704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577031168
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576965632
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2576983552
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 26214
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 436633
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 432537
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16423321
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2577049952
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863442272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3435833696
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2863310336
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1717986304
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1140012032
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1111638016
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4080271360
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262842777
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262851242
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4110068940
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4282821290
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4047791718
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132164
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256119169
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132340
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4134404096
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1744826368
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1869590272
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2186063616
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2202726400
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268369920
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 256132340
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16008271
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1046770
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044274
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 63539
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 68
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
			--End of block
		end
	end
end

function GetPokemonTeam()
	local PokemonTeamAddress = 0
	local PokemonTeamADRTEMP = 0
	local ReadTemp = ""
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			PokemonTeamAddress = 33702532
		elseif GameID == "BPG1" or GameID == "BPG2" then
			--Addresses for Leafgreen
			PokemonTeamAddress = 33702532
		end
		PokemonTeamADRTEMP = PokemonTeamAddress
		for j = 1, 6 do
			for i = 1, 25 do
				ReadTemp = emu:read32(PokemonTeamADRTEMP) 
				PokemonTeamADRTEMP = PokemonTeamADRTEMP + 4 
				ReadTemp = tonumber(ReadTemp)
				ReadTemp = ReadTemp + 1000000000
				if i == 1 then Pokemon[j] = ReadTemp
				else Pokemon[j] = Pokemon[j] .. ReadTemp
				end
			end
		end
	--	ConsoleForText:print("EnemyPokemon 1 data: " .. Pokemon[2])
end
function SetEnemyPokemonTeam(EnemyPokemonNo, EnemyPokemonPos)
	local PokemonTeamAddress = 0
	local PokemonTeamADRTEMP = 0
	local ReadTemp = ""
	local String1 = 0
	local String2 = 0
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			PokemonTeamAddress = 33701932
		elseif GameID == "BPG1" or GameID == "BPG2" then
			--Addresses for Leafgreen
			PokemonTeamAddress = 33701932
		end
		PokemonTeamADRTEMP = PokemonTeamAddress
		if EnemyPokemonNo == 0 then
			for j = 1, 6 do
				for i = 1, 25 do
					if i == 1 then String1 = i
					else String1 = String1 + 10
					end
					String2 = String1 + 9
					ReadTemp = string.sub(EnemyPokemon[j],String1,String2)
					ReadTemp = tonumber(ReadTemp)
					ReadTemp = ReadTemp - 1000000000
					emu:write32(PokemonTeamADRTEMP, ReadTemp)
					PokemonTeamADRTEMP = PokemonTeamADRTEMP + 4
				end
			end
		else
			PokemonTeamADRTEMP = PokemonTeamADRTEMP + ((EnemyPokemonPos - 1) * 100)
			for i = 1, 25 do
				if i == 1 then String1 = i
				else String1 = String1 + 10
				end
				String2 = String1 + 9
				ReadTemp = string.sub(EnemyPokemon[EnemyPokemonNo],String1,String2)
				ReadTemp = tonumber(ReadTemp)
				ReadTemp = ReadTemp - 1000000000
				emu:write32(PokemonTeamADRTEMP, ReadTemp)
				PokemonTeamADRTEMP = PokemonTeamADRTEMP + 4
			end
		end
end

function FixAddress()
	local MultichoiceAdr = 0
		if GameID == "BPR1" then
			MultichoiceAdr = 138282176
		elseif GameID == "BPR2" then
			MultichoiceAdr = 138282288
		elseif GameID == "BPG1" then
			MultichoiceAdr = 138281724
		elseif GameID == "BPG2" then
			MultichoiceAdr = 138281836
		end
	if PrevExtraAdr ~= 0 then
		emu:write32(MultichoiceAdr, PrevExtraAdr)
	end
end

function Loadscript(ScriptNo)
	local ScriptAddressTemp = 0
	local ScriptAddressTemp1 = 0
	--2 is where the script itself is, whereas 1 is the memory to force it to read that. 3 is an extra address to use alongside it, such as multi-choice
	local u32 ScriptAddress2 = 145227776
	
	local u32 ScriptAddress3 = 145227712
	
	local MultichoiceAdr2 = ScriptAddress3 - 32
	local TextToNum = 0
	local NickNameNum
	local Buffer = {0,0,0,0}
	local Buffer1 = 33692880
	local Buffer2 = 33692912
	local Buffer3 = 33692932
	local MultichoiceAdr = 0
		if GameID == "BPR1" then
			MultichoiceAdr = 138282176
		elseif GameID == "BPR2" then
			MultichoiceAdr = 138282288
		elseif GameID == "BPG1" then
			MultichoiceAdr = 138281724
		elseif GameID == "BPG2" then
			MultichoiceAdr = 138281836
		end
	
			--Convert 4-byte buffer to readable bytes in case its needed
				TextToNum = 0
				for i = 1, 4 do
					NickNameNum = string.sub(Player2ID,i,i)
					NickNameNum = string.byte(NickNameNum)
					NickNameNum = tonumber(NickNameNum)
					if NickNameNum > 64 and NickNameNum < 93 then
						NickNameNum = NickNameNum + 122
					
					elseif NickNameNum > 92 and NickNameNum < 128 then
						NickNameNum = NickNameNum + 116
					else
						NickNameNum = NickNameNum + 113
					end
					Buffer[i] = NickNameNum
					if Buffer[i] == "" or Buffer[i] == nil then Buffer[i] = "A" end
				end
			
			if ScriptNo == 0 then
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 4294902380
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
		--		LoadScriptIntoMemory()
			--Host script
			elseif ScriptNo == 1 then 
				emu:write16(Var8000Adr[2], 0) 
				emu:write16(Var8000Adr[5], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 603983722
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2148344069
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 17170433
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 145227804
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 25166870
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4278348800
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 41944086
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4278348800
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3773424593
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3823960280
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3722445033
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3892369887
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3805872355
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655390933
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3638412030
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3034710233
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3654929664
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 16755935
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--Interaction Menu	Multi Choice
			elseif ScriptNo == 2 then
				emu:write16(Var8000Adr[1], 0) 
				emu:write16(Var8000Adr[2], 0) 
				emu:write16(Var8000Adr[14], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 1664873
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 1868957864
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 132117
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 226492441
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147489664
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40566785
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3588018687
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3823829224
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14213353
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 15328237
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655327200
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14936318
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3942704088
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14477533
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289463293
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967040
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				--For buffer 2
				ScriptAddressTemp = 33692912
				ScriptAddressTemp1 = Buffer[1]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 1
				ScriptAddressTemp1 = Buffer[2]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 2
				ScriptAddressTemp1 = Buffer[3]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 3
				ScriptAddressTemp1 = Buffer[4]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 4
				ScriptAddressTemp1 = 255
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				--First save multichoice in case it's needed later
				PrevExtraAdr = ROMCARD:read32(MultichoiceAdr)
				--Overwrite multichoice 0x2 with a custom at address MultichoiceAdr2
				ScriptAddressTemp = MultichoiceAdr
				ScriptAddressTemp1 = MultichoiceAdr2
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				--Multi-Choice
				ScriptAddressTemp = MultichoiceAdr2
				ScriptAddressTemp1 = ScriptAddress3
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 0
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = ScriptAddress3 + 7
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 0
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = ScriptAddress3 + 13
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 0
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = ScriptAddress3 + 18
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 0
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				--Text
				ScriptAddressTemp = ScriptAddress3
				ScriptAddressTemp1 = 3907573180
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 3472873952
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 3654866406
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 3872767487
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 3972005848
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4
				ScriptAddressTemp1 = 4294961373
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--Placeholder
			elseif ScriptNo == 3 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3907242239
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3689078236
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3839220736
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655522788
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 16756952
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967295
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
		--Waiting message
			elseif ScriptNo == 4 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 1271658
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 375785640
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 5210113
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 654415909
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3523150444
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3723025877
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3657489378
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3808487139
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3873037544
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3588285440
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2967919085
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294902015
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
		--Cancel message
			elseif ScriptNo == 5 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632325
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655126783
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3706249984
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3825264345
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3656242656
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587965158
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587637479
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772372962
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289583321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)  
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967040
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--Trade request
			elseif ScriptNo == 6 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 469765994
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2148344069
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 393217
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 145227850
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 41943318
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4278348800
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3942646781
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655133149
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3823632615
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3588679680
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3942701528
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)  
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14477533
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2917786605
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14925566
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 15328237
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3654801365
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289521892
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 18284288
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 1811939712
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967042
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
				--For buffer 2
				ScriptAddressTemp = 33692912
				ScriptAddressTemp1 = Buffer[1]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 1
				ScriptAddressTemp1 = Buffer[2]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 2
				ScriptAddressTemp1 = Buffer[3]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 3
				ScriptAddressTemp1 = Buffer[4]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 4
				ScriptAddressTemp1 = 255
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
		--Trade request denied
			elseif ScriptNo == 7 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655126783
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3706249984
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3825264345
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3656242656
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3822584038
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3808356313
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3942705379
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14477277
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)  
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3892372456
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3654866406
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4278255533
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--Trade offer
			elseif ScriptNo == 8 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 469765994
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2148344069
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 393217
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 145227866
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 41943318
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4278348800
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 15328211
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3656046044
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3671778048
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3638159065
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2902719744
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)  
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655126782
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587965165
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3808483818
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3873037018
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4244691161
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3522931970
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14737629
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 15328237
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3654801365
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289521892
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 18284288
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 1811939712
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967042
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--Trade offer denied
			elseif ScriptNo == 9 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655126783
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3588679680
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3691043288
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3590383573
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14866905
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772242392
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3638158045
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4278255533
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--Battle request
			elseif ScriptNo == 10 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 469765994
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2148344069
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 393217
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 145227846
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 41943318
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4278348800
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3942646781
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655133149
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3823632615
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3906328064
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14278888
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2917786605
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14925566
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 15328237
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3654801365
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289521892
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 18284288
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 1811939712
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967042
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
				--For buffer 2
				ScriptAddressTemp = 33692912
				ScriptAddressTemp1 = Buffer[1]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 1
				ScriptAddressTemp1 = Buffer[2]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 2
				ScriptAddressTemp1 = Buffer[3]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 3
				ScriptAddressTemp1 = Buffer[4]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = 33692912 + 4
				ScriptAddressTemp1 = 255
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
		--Battle request denied
			elseif ScriptNo == 11 then
				emu:write16(Var8000Adr[2], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655126783
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3706249984
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3825264345
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3656242656
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3822584038
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3808356313
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3942705379
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14477277
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3590382568
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3773360341
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 16756185
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967295
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--Select Pokemon for trade
			elseif ScriptNo == 12 then
				emu:write16(Var8000Adr[1], 0) 
				emu:write16(Var8000Adr[2], 0) 
				emu:write16(Var8000Adr[4], 0) 
				emu:write16(Var8000Adr[5], 0) 
				emu:write16(Var8000Adr[14], 0) 
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 10429802
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147754279
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 67502086
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 145227809
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 1199571750
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 50429185
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554944
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632322
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147555071
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967295
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
		--Battle will start
			elseif ScriptNo == 13 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 1416042
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 627443880
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 1009254542
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554816
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632322
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3924022271
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587571942
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655395560
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772640000
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3823239392
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3654680811
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2917326299
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294902015
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
		--Trade will start
			elseif ScriptNo == 14 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 1416042
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 627443880
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 1009254542
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554816
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632322
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3924022271
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3873964262
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14276821
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772833259
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3957580288
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3688486400
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289585885
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967040
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				LoadScriptIntoMemory()
		--You have canceled the battle
			elseif ScriptNo == 15 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632326
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3924022271
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3939884032
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587637465
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772372962
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14211552
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14277864
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3907573206
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289583584
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967040
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
		--You have canceled the trade
			elseif ScriptNo == 16 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632326
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3924022271
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3939884032
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587637465
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772372962
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14211552
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14277864
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3637896936
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 16756185
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967295
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
			--Trading. Your pokemon is stored in 8004, whereas enemy pokemon is already stored through setenemypokemon command
			elseif ScriptNo == 17 then
				emu:write16(Var8000Adr[2], 0)
				emu:write16(Var8000Adr[6], Var8000[5])
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 16655722
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554855
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967295
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
			--Cancel Battle
			elseif ScriptNo == 18 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632325
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655126783
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3706249984
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3825264345
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3656242656
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587965158
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587637479
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772372962
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4275624416
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14277864
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3907573206
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289583584
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967040
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
			--Cancel Trading
			elseif ScriptNo == 19 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632325
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655126783
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3706249984
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3825264345
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3656242656
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587965158
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3587637479
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3772372962
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4275624416
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14277864
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3637896936
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 16756185
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967295
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
			--other player is too busy to battle.
			elseif ScriptNo == 20 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3722235647
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3873964263
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655523797
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655794918
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 15196633
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4276347880
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3991398870
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14936064
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3907573206
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4289780192
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967040
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
			--other player is too busy to trade.
			elseif ScriptNo == 21 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 285216618
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 151562240
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 2147554822
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 40632321
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3722235647
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3873964263
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655523797
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3655794918
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 15196633
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4276347880
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3991398870
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 14936064
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 3637896936
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 16756953
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 4294967295
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
			--battle script
			elseif ScriptNo == 22 then
				emu:write16(Var8000Adr[2], 0)
				ScriptAddressTemp = ScriptAddress2
				ScriptAddressTemp1 = 40656234
				ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				LoadScriptIntoMemory()
			--trade names script.
			elseif ScriptNo == 23 then
				--Other trainer aka other player
				ScriptAddressTemp = Buffer1
				ScriptAddressTemp1 = Buffer[1]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer1 + 1
				ScriptAddressTemp1 = Buffer[2]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer1 + 2
				ScriptAddressTemp1 = Buffer[3]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer1 + 3
				ScriptAddressTemp1 = Buffer[4]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer1 + 4
				ScriptAddressTemp1 = 255
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				--Their pokemon
				WriteBuffers(Buffer3, EnemyTradeVars[6], 5)
			end
			
end

function ApplyMovement(MovementType)
	local u32 ScriptAddress = 50335400
	local u32 ScriptAddress2 = 145227776
	local ScriptAddressTemp = 0
	local ScriptAddressTemp1 = 0
	ScriptAddressTemp = ScriptAddress2
	ScriptAddressTemp1 = 16732010
	ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
	ScriptAddressTemp = ScriptAddressTemp + 4
	ScriptAddressTemp1 = 145227790
	ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
	ScriptAddressTemp = ScriptAddressTemp + 4
	ScriptAddressTemp1 = 1811939409
	ROMCARD:write32(ScriptAddressTemp, ScriptAddressTemp1)
	ScriptAddressTemp = ScriptAddressTemp + 4
	ScriptAddressTemp1 = 65282
	ROMCARD:write16(ScriptAddressTemp, ScriptAddressTemp1)
	if MovementType == 0 then
		ScriptAddressTemp = ScriptAddressTemp + 2
		ScriptAddressTemp1 = 65024
		ROMCARD:write16(ScriptAddressTemp, ScriptAddressTemp1)
		LoadScriptIntoMemory()
	elseif MovementType == 1 then
		ScriptAddressTemp = ScriptAddressTemp + 2
		ScriptAddressTemp1 = 65025
		ROMCARD:write16(ScriptAddressTemp, ScriptAddressTemp1)
		LoadScriptIntoMemory()
	elseif MovementType == 2 then
		ScriptAddressTemp = ScriptAddressTemp + 2
		ScriptAddressTemp1 = 65026
		ROMCARD:write16(ScriptAddressTemp, ScriptAddressTemp1)
		LoadScriptIntoMemory()
	elseif MovementType == 3 then
		ScriptAddressTemp = ScriptAddressTemp + 2
		ScriptAddressTemp1 = 65027
		ROMCARD:write16(ScriptAddressTemp, ScriptAddressTemp1)
		LoadScriptIntoMemory()
	end
end

function LoadScriptIntoMemory()
--This puts the script at ScriptAddress into the memory, forcing it to load

	local u32 ScriptAddress = 50335400
	local u32 ScriptAddress2 = 145227776
	local ScriptAddressTemp = 0
	local ScriptAddressTemp1 = 0
				ScriptAddressTemp = ScriptAddress
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				--Either use 66048, 512, or 513.
				ScriptAddressTemp1 = 513
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4
				--134654353 and 145293312 freezes the game
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = ScriptAddress2 + 1
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1) 
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = ScriptAddressTemp + 4 
				ScriptAddressTemp1 = 0
				emu:write32(ScriptAddressTemp, ScriptAddressTemp1)
				--END Block
end

function SendMultiplayerPackets(Offset, size, Socket)
	local Packet = ""
	local ModifiedSize = 0
	local ModifiedLoop = 0
	local ModifiedLoop2 = 0
	local PacketAmount = 0
	--Using RAM 0263DE00 for packets, as it seems free. If not, will modify later
	if Offset == 0 then Offset = 40099328 end
	local ModifiedRead = ""
	if size > 0 then
		CreatePackettSpecial("SLNK",Player2,size)
		for i = 1, size do
			--Inverse of i, size remaining. 1 = last. Also size represents hex bytes, which goes up to 255 in decimal, so we triple it.
			ModifiedSize = size - i + 1
			if ModifiedSize > 20 and ModifiedLoop == 0 then
				PacketAmount = PacketAmount + 1
				ModifiedLoop = 20
				ModifiedLoop2 = 0
			--	ConsoleForText:print("Packet number: " .. PacketAmount)
			elseif ModifiedSize <= 20 and ModifiedLoop == 0 then
				PacketAmount = PacketAmount + 1
				ModifiedLoop = ModifiedSize
				ModifiedLoop2 = 0
			--	ConsoleForText:print("Last packet. Number: " .. PacketAmount)
			end
			if ModifiedLoop ~= 0 then
				ModifiedLoop2 = ModifiedLoop2 + 1
				ModifiedRead = emu:read8(Offset)
				ModifiedRead = tonumber(ModifiedRead)
				ModifiedRead = ModifiedRead + 100
				if Packet == "" then Packet = ModifiedRead
				else Packet = Packet .. ModifiedRead
				end
				if ModifiedLoop == 1 then
					Socket:send(Packet)
			--		ConsoleForText:print("Packet sent! Packet " .. Packet .. " end. Amount of loops: " .. ModifiedLoop2 .. " " .. Offset)
					Packet = ""
					ModifiedLoop = 0
				else
					ModifiedLoop = ModifiedLoop - 1
				end
			end
			Offset = Offset + 1
		end
	end
end

function ReceiveMultiplayerPackets(size, Socket)
	local Packet = ""
	local ModifiedSize = 0
	local ModifiedLoop = 0
	local ModifiedLoop2 = 0
	local PacketAmount = 0
	local ModifiedRead
	local ModifiedLoop3 = 0
	local SizeMod = 0
	--Using RAM 0263D000-0263DDFF for received data, as it seems free. If not, will modify later
	local MultiplayerPacketSpace = 40095744
	--ConsoleForText:print("TEST 1")
	for i = 1, size do
		--Inverse of i, size remaining. 1 = last. Also size represents hex bytes, which goes up to 255 in decimal
		ModifiedSize = size - i + 1
		if ModifiedSize > 20 and ModifiedLoop == 0 then
			PacketAmount = PacketAmount + 1
			Packet = Socket:receive(60)
			ModifiedLoop = 20
			ModifiedLoop2 = 0
	--		ConsoleForText:print("Packet number: " .. PacketAmount)
		elseif ModifiedSize <= 20 and ModifiedLoop == 0 then
			PacketAmount = PacketAmount + 1
			SizeMod = ModifiedSize * 3
			Packet = Socket:receive(SizeMod)
			ModifiedLoop = ModifiedSize
			ModifiedLoop2 = 0
	--		ConsoleForText:print("Last packet. Number: " .. PacketAmount)
		end
		if ModifiedLoop ~= 0 then
			ModifiedLoop3 = ModifiedLoop2 * 3 + 1
			ModifiedLoop2 = ModifiedLoop2 + 1
			SizeMod = ModifiedLoop3 + 2
			ModifiedRead = string.sub(Packet, ModifiedLoop3, SizeMod)
			ModifiedRead = tonumber(ModifiedRead)
			ModifiedRead = ModifiedRead - 100
			emu:write8(MultiplayerPacketSpace, ModifiedRead)
	--		ConsoleForText:print("Num: " .. ModifiedRead)
	--		ConsoleForText:print("NUM: " .. ModifiedRead)
			if ModifiedLoop == 1 then
		--		ConsoleForText:print("Packet " .. PacketAmount .. " end. Amount of loops: " .. ModifiedLoop2 .. " " .. MultiplayerPacketSpace)
				Packet = ""
				ModifiedLoop = 0
			else
				ModifiedLoop = ModifiedLoop - 1
			end
		end
		MultiplayerPacketSpace = MultiplayerPacketSpace + 1
	end
end

function Battlescript()


end

function BattlescriptClassic()
	--Cursor
	
	BattleVars[2] = emu:read8(33701880)
	--Battle finished. 1 = yes, 0 = is still ongoing
	BattleVars[3] = emu:read8(33701514)
	--Phase. 4 = finished moves.
	BattleVars[4] = emu:read8(33701506)
	--Speed. 256 = You move first. 1 = You move last
	BattleVars[5] = emu:read16(33700830)
	if BattleVars[5] > 10 then BattleVars[5] = 1
	else BattleVars[5] = 0
	end
		
	--Initialize battle
	if BattleVars[1] == 0 then
		BattleVars[1] = 1
		BattleVars[11] = 1
		
		Loadscript(22)
		--Trainerbattleoutro
		local Buffer1 = 33785528
		local Buffer2 = 145227780
		--Outro for battle. "Thanks for the great battle."
		local Bufferloc = "1145227780"
		local Bufferstring = "48056665104657492447489237321946742660764906329062490632806439167372565294967295"
	
		--514 = Player red ID, 515 = Leaf aka female
		emu:write16(33785518, 514)
		--Cursor. Set to 0
		emu:write8(33701880, 0)
		--Set win to 0
		emu:write8(33701514, 0)
		--Set speeds to 0
		emu:write16(33700830, 0)
		--Set turn to 0
		emu:write8(33700834, 0)
				
		WriteBuffers(Buffer1, Bufferloc, 1)
		WriteRom(Buffer2, Bufferstring, 8)
		
	--Wait 150 frames for other vars to load
	elseif BattleVars[1] == 1 and BattleVars[11] < 150 then
		BattleVars[11] = BattleVars[11] + 1
			--514 = Player red ID, 515 = Leaf aka female
			emu:write16(33785518, 514)
			--Cursor. Set to 0
			emu:write8(33701880, 0)
			--Set win to 0
			emu:write8(33701514, 0)
			--Set speeds to 0
			emu:write16(33700830, 0)
			--Set turn to 0
			emu:write8(33700834, 0)
			if BattleVars[11] >= 150 then
				--Set enemy team
				SetEnemyPokemonTeam(0,1)
				BattleVars[1] = 2
			end
		
	--Battle loop
	elseif BattleVars[1] == 2 then
		BattleVars[12] = emu:read8(33700808)
		BufferVars[20] = ""
		
		--If both players have not gone
		if BattleVars[6] == 0 then
			--You have not decided on a move
			if BattleVars[4] >= 1 and EnemyBattleVars[4] ~= 4 then
				--Pause until other player has made a move
				if BattleVars[12] < 32 then
					BattleVars[12] = BattleVars[12] + 32
					emu:write8(33700808, BattleVars[12])
				end
			elseif BattleVars[4] >= 4 and EnemyBattleVars[4] >= 4 then
				if MasterClient == "h" then
					if BattleVars[5] == 1 then
						BattleVars[6] = 1
					else
						BattleVars[6] = 2
					end
				else
					if EnemyBattleVars[5] == 1 then
						BattleVars[6] = 2
					else
						BattleVars[6] = 1
					end
				end
			end
		--You go first
		elseif BattleVars[6] == 1 then
			local TurnTime = emu:read8(33700834)
			--Write speed to 256
			emu:write16(33700830, 256)
			if BattleVars[7] == 0 then
				BattleVars[7] = 1
			--	BattleVars[13] = ReadBuffers()
			--	ConsoleForText:print("First")
			-- SEND DATA
				CreatePackettSpecial("BAT2", Player2)
				
			--Animate
			elseif BattleVars[7] == 1 and EnemyBattleVars[7] == 1 and TurnTime == 0 then
				if BattleVars[12] >= 32 then
					BattleVars[12] = BattleVars[12] - 32
					emu:write8(33700808, BattleVars[12])
				end
				
			--Other player's turn. Pause.
			elseif BattleVars[7] == 1 and TurnTime == 1 then
				if BattleVars[12] < 32 then
					BattleVars[12] = BattleVars[12] + 32
					emu:write8(33700808, BattleVars[12])
				end
				BattleVars[7] = 2
			--Once received then set 7 to 3.
			elseif BattleVars[7] == 2 and string.len(BattleVars[20]) == 280 and string.len(BattleVars[21]) == 244 then
				BattleVars[7] = 3
			--Animate
			elseif BattleVars[7] == 3 and EnemyBattleVars[7] == 3 then
				if BattleVars[12] >= 32 then
					BattleVars[12] = BattleVars[12] - 32
					emu:write8(33700808, BattleVars[12])
				end
				BattleVars[7] = 4
			--Lock after animations while waiting for other player
			elseif BattleVars[7] == 4 and TurnTime == 2 then
				if BattleVars[12] < 32 then
					BattleVars[12] = BattleVars[12] + 32
					emu:write8(33700808, BattleVars[12])
				end
			--Unlock if both players finish animations
			elseif BattleVars[7] == 4 and TurnTime == 2 then
				if BattleVars[12] < 32 then
					BattleVars[12] = BattleVars[12] + 32
					emu:write8(33700808, BattleVars[12])
				end
				BattleVars[7] = 4
			end
		--You go second
		elseif BattleVars[6] == 2 then
		local TurnTime = emu:read8(33700834)
			--Write speed to 1
			emu:write16(33700830, 1)
			if BattleVars[7] == 0 and string.len(BattleVars[20]) == 280 and string.len(BattleVars[21]) == 244 then
				BattleVars[7] = 1
			--	BattleVars[13] = ReadBuffers()
			-- RECEIVEDATA
			--	ConsoleForText:print("Second")
			elseif BattleVars[7] == 1 and EnemyBattleVars[7] == 1 then
				if BattleVars[12] >= 32 then
					BattleVars[12] = BattleVars[12] - 32
					emu:write8(33700808, BattleVars[12])
				end
			end
		end
	end
	
	--Prevent item use
	if BattleVars[1] >= 2 and BattleVars[2] == 1 then emu:write8(33696589, 1)
	else emu:write8(33696589, 0)
	end
	
	--Unlock once battle ends
	if BattleVars[1] >= 2 and BattleVars[3] == 1 then LockFromScript = 0 end
	
	
	if SendTimer == 0 then CreatePackettSpecial("BATT", Player2) end
end

function WriteBuffers(BufferOffset, BufferVar, Length)
	local BufferOffset2 = BufferOffset
	local BufferVarSeperate
	local String1 = 0
	local String2 = 0
	for i = 1, Length do
		if i == 1 then String1 = 1
		else String1 = String1 + 10
		end
		String2 = String1 + 9
		BufferVarSeperate = string.sub(BufferVar, String1, String2)
		BufferVarSeperate = tonumber(BufferVarSeperate)
		BufferVarSeperate = BufferVarSeperate - 1000000000
		emu:write32(BufferOffset2, BufferVarSeperate)
		BufferOffset2 = BufferOffset2 + 4
	end
end
function WriteRom(RomOffset, RomVar, Length)
	local RomOffset2 = RomOffset
	local RomVarSeperate
	local String1 = 0
	local String2 = 0
	for i = 1, Length do
		if i == 1 then String1 = 1
		else String1 = String1 + 10
		end
		String2 = String1 + 9
		RomVarSeperate = string.sub(RomVar, String1, String2)
		RomVarSeperate = tonumber(RomVarSeperate)
		RomVarSeperate = RomVarSeperate - 1000000000
		ROMCARD:write32(RomOffset2, RomVarSeperate)
		RomOffset2 = RomOffset2 + 4
	end
end
function ReadBuffers(BufferOffset, Length)
	local BufferOffset2 = BufferOffset
	local BufferVar
	local BufferVarSeperate
	for i = 1, Length do
		BufferVarSeperate = emu:read32(BufferOffset2)
		BufferVarSeperate = tonumber(BufferVarSeperate)
		BufferVarSeperate = BufferVarSeperate + 1000000000
		if i == 1 then BufferVar = BufferVarSeperate
		else BufferVar = BufferVar .. BufferVarSeperate
		end
		BufferOffset2 = BufferOffset2 + 4
	end
	return BufferVar
end
function Tradescript()
	--Buffer 1 is enemy pokemon, 2 is our pokemon
	local Buffer1 = 33692880
	local Buffer2 = 33692912
	local Buffer3 = 33692932


--	if TempVar2 == 0 then ConsoleForText:print("1: " .. TradeVars[1] .. " 8001: " .. Var8000[2] .. " OtherPlayerHasCancelled: " .. OtherPlayerHasCancelled .. " EnemyTradeVars[1]: " .. EnemyTradeVars[1]) end

	--Text is finished before trade
	if Var8000[2] ~= 0 and TradeVars[1] == 0 then
		TradeVars[1] = 1
		Loadscript(12)
	
	--You have canceled or have not selected a valid pokemon slot
	elseif Var8000[2] == 1 and TradeVars[1] == 1 then
		Loadscript(16)
		SendData("CTRA",Player2)
		LockFromScript = 0
		TradeVars[1] = 0
		TradeVars[2] = 0
		TradeVars[3] = 0
	--The other player has canceled
	elseif Var8000[2] == 2 and TradeVars[1] == 1 and OtherPlayerHasCancelled ~= 0 then
		OtherPlayerHasCancelled = 0
		Loadscript(19)
		LockFromScript = 7
		TradeVars[1] = 0
		TradeVars[2] = 0
		TradeVars[3] = 0
	
	--You have finished your selection
	elseif Var8000[2] == 2 and TradeVars[1] == 1 and OtherPlayerHasCancelled == 0 then
		--You just finished. Display waiting
		TradeVars[3] = Var8000[5]
		TradeVars[5] = ReadBuffers(Buffer2, 4)
	--	TradeVars[6] = TradeVars[5] .. 5294967295
	--	WriteBuffers(Buffer1, TradeVars[6], 5)
		if EnemyTradeVars[1] == 2 then
			EnemyTradeVars[6] = EnemyTradeVars[5] .. 5294967295
			WriteBuffers(Buffer1, EnemyTradeVars[6], 5)
			TradeVars[1] = 3
			Loadscript(8)
		else
			Loadscript(4)
			TradeVars[1] = 2
		end
	elseif TradeVars[1] == 2 then
		--Wait for other player
		if Var8000[2] ~= 0 then TradeVars[2] = 1 end
		--If they cancel
		if Var8000[2] ~= 0 and OtherPlayerHasCancelled ~= 0 then
			OtherPlayerHasCancelled = 0
			Loadscript(19)
			LockFromScript = 7
			TradeVars[1] = 0
			TradeVars[2] = 0
			TradeVars[3] = 0
			
		--If other player has finished selecting
		elseif Var8000[2] ~= 0 and ((EnemyTradeVars[2] == 1 and EnemyTradeVars[1] == 2) or EnemyTradeVars[1] == 3) then
			EnemyTradeVars[6] = EnemyTradeVars[5] .. 5294967295
			WriteBuffers(Buffer1, EnemyTradeVars[6], 5)
			TradeVars[1] = 3
			TradeVars[2] = 0
			Loadscript(8)
			
		end
	elseif TradeVars[1] == 3 then
		--If you decline
		if Var8000[2] == 1 then
			SendData("ROFF", Player2)
			Loadscript(16)
			LockFromScript = 7
			TradeVars[1] = 0
			TradeVars[2] = 0
			TradeVars[3] = 0
			
		--If you accept and they deny
		elseif Var8000[2] == 2 and OtherPlayerHasCancelled ~= 0 then
			OtherPlayerHasCancelled = 0
			Loadscript(9)
			LockFromScript = 7
			TradeVars[1] = 0
			TradeVars[2] = 0
			TradeVars[3] = 0
	
		--If you accept and there is no denial
		elseif Var8000[2] == 2 and OtherPlayerHasCancelled == 0 then
			--If other player isn't finished selecting, wait. Otherwise, go straight into trade.
			if EnemyTradeVars[1] == 4 and EnemyTradeVars[2] == 2 then
				TradeVars[1] = 5
				TradeVars[2] = 2
				local TeamPos = EnemyTradeVars[3] + 1
				SetEnemyPokemonTeam(TeamPos, 1)
				Loadscript(17)
			else
				Loadscript(4)
				TradeVars[1] = 4
				TradeVars[2] = 0
			end
	end
	elseif TradeVars[1] == 4 then
		--Wait for other player
		if Var8000[2] ~= 0 then TradeVars[2] = 2 end
		--If they cancel
		if Var8000[2] ~= 0 and OtherPlayerHasCancelled ~= 0 then
			OtherPlayerHasCancelled = 0
			Loadscript(19)
			LockFromScript = 7
			TradeVars[1] = 0
			TradeVars[2] = 0
			TradeVars[3] = 0
			
		--If other player has finished selecting
		elseif Var8000[2] ~= 0 and (EnemyTradeVars[2] == 2 or EnemyTradeVars[1] == 5) then
			TradeVars[2] = 2
			TradeVars[1] = 5
			local TeamPos = EnemyTradeVars[3] + 1
			SetEnemyPokemonTeam(TeamPos, 1)
			Loadscript(17)
		else
	--		console:log("VARS: " .. Var8000[2] .. " " .. EnemyTradeVars[2] .. " " .. EnemyTradeVars[1])
		end
	elseif TradeVars[1] == 5 then
		--Text for trade
		if Var8000[2] == 0 then
			Loadscript(23)
		--After trade
		elseif Var8000[2] ~= 0 then
			TradeVars[1] = 0
			TradeVars[2] = 0
			TradeVars[3] = 0
			TradeVars[4] = 0
			TradeVars[5] = 0
			EnemyTradeVars[1] = 0
			EnemyTradeVars[2] = 0
			EnemyTradeVars[3] = 0
			EnemyTradeVars[4] = 0
			EnemyTradeVars[5] = 0
			LockFromScript = 0
		end
	end
	
	if SendTimer == 0 then CreatePackettSpecial("TRAD", Player2) end
end
		--	if Var8000[2] ~= 0 then
		--		Loadscript(16)
		--		SendData("CTRA", Player2)
		--		LockFromScript = 7
		--		TradeVars[1] = 0
		--		TradeVars[2] = 0
		--		TradeVars[3] = 0

function FixPositionPlayer1()
	--Fix values
	if NewMapX > 9 then NewMapX = NewMapX - 10 end
	if NewMapY > 9 then NewMapY = NewMapY - 10 end
	if MapXPrev > 9 then MapXPrev = MapXPrev - 10 end
	if MapYPrev > 9 then MapYPrev = MapYPrev - 10 end
	PlayerExtra1 = PlayerExtra1 - 10
	PlayerExtra2 = PlayerExtra2 - 10
end
function FixPositionPlayer2()
	--Fix values
	if NewMapX2 > 9 then NewMapX2 = NewMapX2 - 10 end
	if NewMapY2 > 9 then NewMapY2 = NewMapY2 - 10 end
	Player2Extra1 = Player2Extra1 - 10
	Player2Extra2 = Player2Extra2 - 10
end
function FixPositionPlayer3()
	--Fix values
end
function FixPositionPlayer4()
	--Fix values
end

function FixPositionActualPlayer1()
	--Fix values
	if MapX > 9 then MapX = MapX - 10 end
	if MapY > 9 then MapY = MapY - 10 end
	PlayerExtra1 = PlayerExtra1 - 10
	PlayerExtra2 = PlayerExtra2 - 10
end
function FixPositionActualPlayer2()
	--Fix values
	if MapX2 > 9 then MapX2 = MapX2 - 10 end
	if MapY2 > 9 then MapY2 = MapY2 - 10 end
	Player2Extra1 = Player2Extra1 - 10
	Player2Extra2 = Player2Extra2 - 10
end
function FixPositionActualPlayer3()
	--Fix values
	if MapX3 > 9 then MapX3 = MapX3 - 10 end
	if MapY3 > 9 then MapY3 = MapY3 - 10 end
	Player3Extra1 = Player3Extra1 - 10
	Player3Extra2 = Player3Extra2 - 10
end
function FixPositionActualPlayer4()
	--Fix values
	if MapX4 > 9 then MapX4 = MapX4 - 10 end
	if MapY4 > 9 then MapY4 = MapY4 - 10 end
	Player4Extra1 = Player4Extra1 - 10
	Player4Extra2 = Player4Extra2 - 10
end
function FixAllPositions()
	FixPositionActualPlayer1()
	FixPositionActualPlayer2()
	FixPositionActualPlayer3()
	FixPositionActualPlayer4()
end

function FixSentPositions()
	if PlayerID ~= 1 then FixPositionPlayer1() end
	if PlayerID ~= 2 then FixPositionPlayer2() end
	if PlayerID ~= 3 then FixPositionPlayer3() end
	if PlayerID ~= 4 then FixPositionPlayer4() end
end

function GetPlayerCamera(ResetCamera)
	local u32 PlayerMapXMoveAddress = 0
	local u32 PlayerMapYMoveAddress = 0
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		elseif GameID == "BPG1" or GameID == "BPG2"  then
			--Addresses for Leafgreen
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		end
		
			PlayerMapXMovePrev = PlayerMapXMove
			PlayerMapYMovePrev = PlayerMapYMove
			PlayerMapXMove = emu:read16(PlayerMapXMoveAddress)
			PlayerMapYMove = emu:read16(PlayerMapYMoveAddress)
			
		if ResetCamera == 1 then
		--	if PlayerMapX > 2 then
	--		PlayerXCamera2 = PlayerXCamera2 - 16
		--	elseif PlayerMapX < 3 then
		--	PlayerXCamera2 = PlayerXCamera2 + 16
		--	elseif PlayerMapY > 1 then
		--	PlayerYCamera2 = PlayerYCamera2 - 16
		--	elseif PlayerMapY < 2 then
		--	PlayerYCamera2 = PlayerYCamera2 + 16
		--	end
		end
end

function HidePlayers()
	MapID2 = tonumber(MapID2)
	MapID3 = tonumber(MapID3)
	MapID4 = tonumber(MapID4)
	local TempMapStuff = tonumber(PlayerMapID)
	local PlayerCurrentMap = 0
	local PlayerPrevMap = 0
	local PlayerConnectionMap = 0
	local MAXX = 0
	local MAXY = 0
	local CURRX = 0
	local CURRY = 0
	local PlayerMAXX = 0
	local PlayerMAXY = 0
	local PlayerCURRX = 0
	local PlayerCURRY = 0
	local PlayerVis = 0
	local PlayerDir = 0
	local PlayerDirPrev = 0
	
	if TempMapStuff ~= 0 then
		if PlayerID == 1 then
			PlayerCurrentMap = MapID
			PlayerPrevMap = NewMapConnectPrev
			PlayerConnectionMap = NewMapConnect
			PlayerMAXX = MapXPrev
			PlayerMAXY = MapYPrev
			PlayerCURRX = MapStartX
			PlayerCURRY = MapStartY
			PlayerVis = Player1Vis
			PlayerDir = PlayerDirection
			PlayerDirPrev = PlayerDirectionPrev
				
		elseif PlayerID == 2 then
			PlayerCurrentMap = MapID2
			PlayerPrevMap = NewMapConnect2Prev
			PlayerConnectionMap = NewMapConnect2
			PlayerMAXX = MapX2Prev
			PlayerMAXY = MapY2Prev
			PlayerCURRX = MapStartX2
			PlayerCURRY = MapStartY2
			PlayerVis = Player2Vis
			PlayerDir = Player2Direction
			PlayerDirPrev = Player2DirectionPrev
		elseif PlayerID ~= 3 then
		elseif PlayerID ~= 4 then
		end
		
		if PlayerID ~= 1 then
			if PlayerMapID == MapID then
				if PlayerXCamera2 > 16 then PlayerXCamera2 = 16 end
				if PlayerXCamera2 < -16 then PlayerXCamera2 = -16 end
				if PlayerYCamera2 > 16 then PlayerYCamera2 = 16 end
				if PlayerYCamera2 < -16 then PlayerYCamera2 = -16 end
				if PlayerXCamera2 > 0 then PlayerXCamera2 = PlayerXCamera2 - 1 Player1Vis = 0
				elseif PlayerXCamera2 < 0 then PlayerXCamera2 = PlayerXCamera2 + 1 Player1Vis = 0 end
				if PlayerYCamera2 > 0 then PlayerYCamera2 = PlayerYCamera2 - 1 Player1Vis = 0
				elseif PlayerYCamera2 < 0 then PlayerYCamera2 = PlayerYCamera2 + 1 Player1Vis = 0 end
				if PlayerXCamera2 == 0 and PlayerYCamera2 == 0 then Player1Vis = 1 end
				PlayerDirectionPrev = 0
				if ActualPlayerDirectionPrev ~= 0 then
					if PlayerNewMap ~= 0 then
				--		ConsoleForText:print("PLAYER MAP CHANGE! DIR: " .. ActualPlayerDirectionPrev)
						--Up
						if ActualPlayerDirectionPrev == 1 then
							NewMapNewX = -1
						--Down
						elseif ActualPlayerDirectionPrev == 2 then
							NewMapNewX = 1
						--Left
						elseif ActualPlayerDirectionPrev == 3 then
							NewMapNewY = -1
						--Right
						elseif ActualPlayerDirectionPrev == 4 then
							NewMapNewY = 1
						end
					end
					ActualPlayerDirectionPrev = 0
				end
		--		if TempVar2 == 0 then ConsoleForText:print("Player 2 and player 1 same map") end
			elseif (PlayerMapID == NewMapConnectPrev and NewMapConnect == 1) or (PlayerPrevMap == MapID and PlayerConnectionMap == 1) then
				
						
					--	if TempVar2 == 0 then ConsoleForText:print("Test 2") end
						if (PlayerMapID == NewMapConnectPrev and PlayerDirectionPrev ~= 0 and NewMapConnect == 1) then MAXX = MapXPrev CURRX = MapStartX MAXY = MapYPrev CURRY = MapStartY
						else MAXX = PlayerMAXX CURRX = PlayerCURRX MAXY = PlayerMAXY CURRY = PlayerCURRY
						end
						Player1Vis = 1
						
				--		if TempVar2 == 0 then ConsoleForText:print("VARS: " .. PlayerDirectionPrev .. " " .. MAXY .. " " .. CURRY) end
											--Down
						if PlayerDirectionPrev == 4 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						--Up
						elseif PlayerDirectionPrev == 3 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						--Right
						elseif PlayerDirectionPrev == 1 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						--Left
						elseif PlayerDirectionPrev == 2 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						end

				--		if TempVar2 == 0 then ConsoleForText:print("Test 3") end
					
					--IF PLAYER UPDATES MAP
					
					--Down (P2 UP)
					if ActualPlayerDirectionPrev == 4 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16 -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Up (P2 DOWN)
					elseif ActualPlayerDirectionPrev == 3 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16 +16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Right (P2 LEFT)
					elseif ActualPlayerDirectionPrev == 2 then
				--			ConsoleForText:print("MAXX: " .. MAXX .. " CURRX: " .. CURRX)
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Left (P2 RIGHT)
					elseif ActualPlayerDirectionPrev == 1 then
				--			ConsoleForText:print("MAXX: " .. MAXX .. " CURRX: " .. CURRX)
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 +16
						end
					end
			--			if TempVar2 == 0 then ConsoleForText:print("Test 4") end
			else
				Player1Vis = 0
			end
		end
		if PlayerID ~= 2 then
			if PlayerMapID == MapID2 then
				if PlayerXCamera2 > 16 then PlayerXCamera2 = 16 end
				if PlayerXCamera2 < -16 then PlayerXCamera2 = -16 end
				if PlayerYCamera2 > 16 then PlayerYCamera2 = 16 end
				if PlayerYCamera2 < -16 then PlayerYCamera2 = -16 end
				if PlayerXCamera2 > 0 then PlayerXCamera2 = PlayerXCamera2 - 1 Player2Vis = 0
				elseif PlayerXCamera2 < 0 then PlayerXCamera2 = PlayerXCamera2 + 1 Player2Vis = 0 end
				if PlayerYCamera2 > 0 then PlayerYCamera2 = PlayerYCamera2 - 1 Player2Vis = 0
				elseif PlayerYCamera2 < 0 then PlayerYCamera2 = PlayerYCamera2 + 1 Player2Vis = 0 end
				if PlayerXCamera2 == 0 and PlayerYCamera2 == 0 then Player2Vis = 1 end
				Player2DirectionPrev = 0
				if ActualPlayerDirectionPrev ~= 0 then
					if PlayerNewMap ~= 0 then
				--		ConsoleForText:print("PLAYER MAP CHANGE! DIR: " .. ActualPlayerDirectionPrev)
						--Up
						if ActualPlayerDirectionPrev == 1 then
							NewMapNewX = -1
						--Down
						elseif ActualPlayerDirectionPrev == 2 then
							NewMapNewX = 1
						--Left
						elseif ActualPlayerDirectionPrev == 3 then
							NewMapNewY = -1
						--Right
						elseif ActualPlayerDirectionPrev == 4 then
							NewMapNewY = 1
						end
					end
					ActualPlayerDirectionPrev = 0
				end
			--	if TempVar2 == 0 then ConsoleForText:print("Player 2 and player 1 same map") end
			--			if TempVar2 == 0 then ConsoleForText:print("TEST1") end
			elseif (PlayerMapID == NewMapConnect2Prev and NewMapConnect2 == 1) or (PlayerPrevMap == MapID2 and PlayerConnectionMap == 1) then
					Player2Vis = 1
											--Down
				--		if TempVar2 == 0 then ConsoleForText:print("TEST2") end
						if (PlayerMapID == NewMapConnect2Prev and Player2DirectionPrev ~= 0 and NewMapConnect2 == 1) then MAXX = MapX2Prev CURRX = MapStartX2 MAXY = MapY2Prev CURRY = MapStartY2
						else MAXX = PlayerMAXX CURRX = PlayerCURRX MAXY = PlayerMAXY CURRY = PlayerCURRY
						end
					--	if TempVar2 == 0 then ConsoleForText:print("TEST3") end
					--	if TempVar2 == 0 then ConsoleForText:print("MAXY: " .. MAXY .. " CURRY: " .. CURRY .. " Dir: " .. Player2DirectionPrev) end
						if Player2DirectionPrev == 4 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						--Up
						elseif Player2DirectionPrev == 3 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						--Right
						elseif Player2DirectionPrev == 1 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						--Left
						elseif Player2DirectionPrev == 2 then
					--		ConsoleForText:print("P2 LEFT")
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * 16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * 16
							end
						end

					
					--IF PLAYER UPDATES MAP
					
					--Down (P2 UP)
					if ActualPlayerDirectionPrev == 4 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16 -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Up (P2 DOWN)
					elseif ActualPlayerDirectionPrev == 3 then
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16 +16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Right (P2 LEFT)
					elseif ActualPlayerDirectionPrev == 2 then
				--			ConsoleForText:print("MAXX: " .. MAXX .. " CURRX: " .. CURRX)
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Left (P2 RIGHT)
					elseif ActualPlayerDirectionPrev == 1 then
					--		ConsoleForText:print("P1 LEFT")
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 +16
						end
					end
			else
		--		if TempVar2 == 0 then ConsoleForText:print("PlayerMapID" .. PlayerMapID .. "NewMapConnect2Prev: " .. NewMapConnect2Prev .. " " .. NewMapConnect2) end
				Player2Vis = 0
			end
		end
		if PlayerID ~= 3 then
		end
		if PlayerID ~= 4 then
		end
	else
		Player2Vis = 0
		Player3Vis = 0
		Player4Vis = 0
	end
end

function GetPosition()
	local u32 BikeAddress = 0
	local u32 PrevMapIDAddress = 0
	local u32 ConnectionTypeAddress = 0
	local u32 NewMapXAddress = 0
	local u32 NewMapYAddress = 0
	local Bike = 0
	if GameID == "BPR1" or GameID == "BPR2" then
		--Addresses for Firered
		PlayerXAddress = 33779272
		PlayerYAddress = 33779274
		NewMapXAddress = 33779276
		NewMapYAddress = 33779278
		PlayerFaceAddress = 33779284
		MapAddress = 33813416
		BikeAddress = 33687112
		PrevMapIDAddress = 33813418
		ConnectionTypeAddress = 33785351
	elseif GameID == "BPG1" or GameID == "BPG2" then
		--Addresses for Leafgreen
		PlayerXAddress = 33779272
		PlayerYAddress = 33779274
		NewMapXAddress = 33779276
		NewMapYAddress = 33779278
		PlayerFaceAddress = 33779284
		MapAddress = 33813416
		BikeAddress = 33687112
		PrevMapIDAddress = 33813418
		ConnectionTypeAddress = 33785351
	end
	
	
		PlayerMapX = emu:read16(PlayerXAddress)
		PlayerMapY = emu:read16(PlayerYAddress)
		PlayerFacing = emu:read8(PlayerFaceAddress)
		Bike = emu:read16(BikeAddress)
		Bike = tonumber(Bike)
		local TempMapData = emu:read16(MapAddress)
		TempMapData = tonumber(TempMapData)
		TempMapData = TempMapData + 100000
		if TempMapData ~= PlayerMapID then
				GetPlayerCamera(1)
			--ConsoleForText:print("New map detected! Reloading sprites...")
			--Starts at 100733010, each number will add it by 256 ex. 1 = 100733266
			--HandleSprites()
		else
		end
		PlayerMapID = TempMapData
		--Prev map
		TempMapData = emu:read16(PrevMapIDAddress)
		TempMapData = tonumber(TempMapData)
		TempMapData = TempMapData + 100000
		
	if PlayerID == 1 then
		NewMapConnectPrev = tonumber(TempMapData)
		--1 if travel, otherwise 0 like teleport
		NewMapConnect = emu:read8(ConnectionTypeAddress)
		NewMapConnect = tonumber(NewMapConnect)
		
		if NewMapConnect == 0 then NewMapConnect = 1
		else NewMapConnect = 0
		end
		--Male sprite
		if MapID ~= PlayerMapID then
			MapXPrev = tonumber(NewMapX)
			MapYPrev = tonumber(NewMapY)
	--		ConsoleForText:print("MAPX: " .. MapX .. " PlayerMapX: " .. PlayerMapX)
		end
		NewMapX = emu:read16(NewMapXAddress)
		NewMapY = emu:read16(NewMapYAddress)
		MapX = emu:read16(PlayerXAddress)
		if MapX > 99 then MapX = 99 end
		MapY = emu:read16(PlayerYAddress)
		if MapY > 99 then MapY = 99 end
	--	if TempVar2 == 0 then ConsoleForText:print("BIKE: " .. Bike) end
		--Male Firered Sprite from 1.0, 1.1, and leafgreen
		if ((Bike == 160 or Bike == 272) or (Bike == 128 or Bike == 240)) then
			PlayerExtra2 = 0
			Bike = 0
		--	if TempVar2 == 0 then ConsoleForText:print("Male on Foot") end
		--Male Firered Biking Sprite
		elseif (Bike == 320 or Bike == 432 or Bike == 288 or Bike == 400) then
			PlayerExtra2 = 0
			Bike = 1
		--	if TempVar2 == 0 then ConsoleForText:print("Male on Bike") end
		--Male Firered Surfing Sprite
		elseif (Bike == 624 or Bike == 736 or Bike == 592 or Bike == 704) then
			PlayerExtra2 = 0
			Bike = 2
		--Female sprite
		elseif ((Bike == 392 or Bike == 504) or (Bike == 360 or Bike == 472)) then
			PlayerExtra2 = 1
			Bike = 0
		--	if TempVar2 == 0 then ConsoleForText:print("Female on Foot") end
		--Female Biking sprite
		elseif ((Bike == 552 or Bike == 664) or (Bike == 520 or Bike == 632)) then
			PlayerExtra2 = 1
			Bike = 1
		--Female Firered Surfing Sprite
		elseif (Bike == 720 or Bike == 832 or Bike == 688 or Bike == 800) then
			PlayerExtra2 = 1
			Bike = 2
		else
		--If in bag when connecting will automatically be firered male
		--	if TempVar2 == 0 then ConsoleForText:print("Bag/Unknown") end
		end
		Facing = tonumber(PlayerFacing)
		if Bike == 2 then
			--Facing
			if Facing == 0 then PlayerExtra1 = 33 PlayerDirection = 4 end
			if Facing == 1 then PlayerExtra1 = 34 PlayerDirection = 3 end
			if Facing == 2 then PlayerExtra1 = 35 PlayerDirection = 1 end
			if Facing == 3 then PlayerExtra1 = 36 PlayerDirection = 2 end
			--Surfing
			if Facing == 29 then PlayerExtra1 = 37 PlayerDirection = 4 end
			if Facing == 30 then PlayerExtra1 = 38 PlayerDirection = 3 end
			if Facing == 31 then PlayerExtra1 = 39 PlayerDirection = 1 end
			if Facing == 32 then PlayerExtra1 = 40 PlayerDirection = 2 end
			--Turning
			if Facing == 41 then PlayerExtra1 = 33 PlayerDirection = 4 end
			if Facing == 42 then PlayerExtra1 = 34 PlayerDirection = 3 end
			if Facing == 43 then PlayerExtra1 = 35 PlayerDirection = 1 end
			if Facing == 44 then PlayerExtra1 = 36 PlayerDirection = 2 end
			--hitting a wall
			if Facing == 33 then PlayerExtra1 = 33 PlayerDirection = 4 end
			if Facing == 34 then PlayerExtra1 = 34 PlayerDirection = 3 end
			if Facing == 35 then PlayerExtra1 = 35 PlayerDirection = 1 end
			if Facing == 36 then PlayerExtra1 = 36 PlayerDirection = 2 end
		elseif Bike == 1 then
			if Facing == 0 then PlayerExtra1 = 17 PlayerDirection = 4 end
			if Facing == 1 then PlayerExtra1 = 18 PlayerDirection = 3 end
			if Facing == 2 then PlayerExtra1 = 19 PlayerDirection = 1 end
			if Facing == 3 then PlayerExtra1 = 20 PlayerDirection = 2 end
			--Standard speed
			if Facing == 49 then PlayerExtra1 = 21 PlayerDirection = 4 end
			if Facing == 50 then PlayerExtra1 = 22 PlayerDirection = 3 end
			if Facing == 51 then PlayerExtra1 = 23 PlayerDirection = 1 end
			if Facing == 52 then PlayerExtra1 = 24 PlayerDirection = 2 end
			--In case you use a fast bike
			if Facing == 61 then PlayerExtra1 = 25 PlayerDirection = 4 end
			if Facing == 62 then PlayerExtra1 = 26 PlayerDirection = 3 end
			if Facing == 63 then PlayerExtra1 = 27 PlayerDirection = 1 end
			if Facing == 64 then PlayerExtra1 = 28 PlayerDirection = 2 end
			--hitting a wall
			if Facing == 37 then PlayerExtra1 = 29 PlayerDirection = 4 end
			if Facing == 38 then PlayerExtra1 = 30 PlayerDirection = 3 end
			if Facing == 39 then PlayerExtra1 = 31 PlayerDirection = 1 end
			if Facing == 40 then PlayerExtra1 = 32 PlayerDirection = 2 end
		else
			if Facing == 0 then PlayerExtra1 = 1 PlayerDirection = 4 end
			if Facing == 1 then PlayerExtra1 = 2 PlayerDirection = 3 end
			if Facing == 2 then PlayerExtra1 = 3 PlayerDirection = 1 end
			if Facing == 3 then PlayerExtra1 = 4 PlayerDirection = 2 end
			if Facing == 33 then PlayerExtra1 = 5 PlayerDirection = 4 end
			if Facing == 34 then PlayerExtra1 = 6 PlayerDirection = 3 end
			if Facing == 35 then PlayerExtra1 = 7 PlayerDirection = 1 end
			if Facing == 36 then PlayerExtra1 = 8 PlayerDirection = 2 end
			if Facing == 37 then PlayerExtra1 = 1 PlayerDirection = 4 end
			if Facing == 38 then PlayerExtra1 = 2 PlayerDirection = 3 end
			if Facing == 39 then PlayerExtra1 = 3 PlayerDirection = 1 end
			if Facing == 40 then PlayerExtra1 = 4 PlayerDirection = 2 end
			if Facing == 16 then PlayerExtra1 = 5 PlayerDirection = 4 end
			if Facing == 17 then PlayerExtra1 = 6 PlayerDirection = 3 end
			if Facing == 18 then PlayerExtra1 = 7 PlayerDirection = 1 end
			if Facing == 19 then PlayerExtra1 = 8 PlayerDirection = 2 end
			if Facing == 41 then PlayerExtra1 = 9 PlayerDirection = 4 end
			if Facing == 42 then PlayerExtra1 = 10 PlayerDirection = 3 end
			if Facing == 43 then PlayerExtra1 = 11 PlayerDirection = 1 end
			if Facing == 44 then PlayerExtra1 = 12 PlayerDirection = 2 end
			if Facing == 61 then PlayerExtra1 = 13 PlayerDirection = 4 end
			if Facing == 62 then PlayerExtra1 = 14 PlayerDirection = 3 end
			if Facing == 63 then PlayerExtra1 = 15 PlayerDirection = 1 end
			if Facing == 64 then PlayerExtra1 = 16 PlayerDirection = 2 end
		--	if Facing == 255 then PlayerExtra1 = 0 end
		end
		ActualPlayerDirection = PlayerDirection
	--	if TempVar2 == 0 then ConsoleForText:print("MapID: " .. MapID .. "PlayerMapID" .. PlayerMapID) end
		if PlayerNewMap ~= 0 then
			if PlayerDirectionPrev == 1 then
			MapStartX = tonumber(NewMapX)
			MapStartY = tonumber(NewMapY)
			MapStartX = MapStartX - 1
			PlayerNewMap = 0
			elseif PlayerDirectionPrev == 2 then
			MapStartX = tonumber(NewMapX)
			MapStartY = tonumber(NewMapY)
			MapStartX = MapStartX + 1
			PlayerNewMap = 0
			elseif PlayerDirectionPrev == 3 then
			MapStartX = tonumber(NewMapX)
			MapStartY = tonumber(NewMapY)
			MapStartY = MapStartY - 1
			PlayerNewMap = 0
			elseif PlayerDirectionPrev == 4 then
			MapStartX = tonumber(NewMapX)
			MapStartY = tonumber(NewMapY)
			MapStartY = MapStartY + 1
			PlayerNewMap = 0
			end
		end
		if MapID ~= PlayerMapID then
	--	ConsoleForText:print("NEW MAP!")
			PlayerDirectionPrev = PlayerDirection
			ActualPlayerDirectionPrev = ActualPlayerDirection
			
			MapStartX = tonumber(NewMapX)
			MapStartY = tonumber(NewMapY)
	--		ConsoleForText:print("MAPX: " .. MapX)
			PlayerNewMap = 1
			MapID = tonumber(PlayerMapID)
		end
	elseif PlayerID == 2 then
		NewMapConnect2Prev = tonumber(TempMapData)
		--1 if travel, otherwise 0 like teleport
		NewMapConnect2 = emu:read8(ConnectionTypeAddress)
		NewMapConnect2 = tonumber(NewMapConnect2)
		
		if NewMapConnect2 == 0 then NewMapConnect2 = 1
		else NewMapConnect2 = 0
		end
		if MapID2 ~= PlayerMapID then
			MapX2Prev = tonumber(NewMapX2)
			MapY2Prev = tonumber(NewMapY2)
		end
		NewMapX2 = emu:read16(NewMapXAddress)
		NewMapY2 = emu:read16(NewMapYAddress)
		MapX2 = emu:read16(PlayerXAddress)
		if MapX2 > 99 then MapX2 = 99 end
		MapY2 = emu:read16(PlayerYAddress)
		if MapY2 > 99 then MapY2 = 99 end
		Facing2 = tonumber(PlayerFacing)
		--Male Firered Sprite from 1.0, 1.1, and leafgreen
		--Male Firered Sprite from 1.0, 1.1, and leafgreen
		if ((Bike == 160 or Bike == 272) or (Bike == 128 or Bike == 240)) then
			Player2Extra2 = 0
			Bike = 0
		--	if TempVar2 == 0 then ConsoleForText:print("Male on Foot") end
		--Male Firered Biking Sprite
		elseif (Bike == 320 or Bike == 432 or Bike == 288 or Bike == 400) then
			Player2Extra2 = 0
			Bike = 1
		--	if TempVar2 == 0 then ConsoleForText:print("Male on Bike") end
		--Male Firered Surfing Sprite
		elseif (Bike == 624 or Bike == 736 or Bike == 592 or Bike == 704) then
			Player2Extra2 = 0
			Bike = 2
		--Female sprite
		elseif ((Bike == 392 or Bike == 504) or (Bike == 360 or Bike == 472)) then
			Player2Extra2 = 1
			Bike = 0
		--	if TempVar2 == 0 then ConsoleForText:print("Female on Foot") end
		--Female Biking sprite
		elseif ((Bike == 552 or Bike == 664) or (Bike == 520 or Bike == 632)) then
			Player2Extra2 = 1
			Bike = 1
		--	if TempVar2 == 0 then ConsoleForText:print("Female on Bike") end
		--Female Firered Surfing Sprite
		elseif (Bike == 720 or Bike == 832 or Bike == 688 or Bike == 800) then
			Player2Extra2 = 1
			Bike = 2
		else
		--If in bag when connecting will automatically be firered male
		--	if TempVar2 == 0 then ConsoleForText:print("Bag/Unknown") end
		end
		if Bike == 2 then
			--Facing
			if Facing2 == 0 then Player2Extra1 = 33 Player2Direction = 4 end
			if Facing2 == 1 then Player2Extra1 = 34 Player2Direction = 3 end
			if Facing2 == 2 then Player2Extra1 = 35 Player2Direction = 1 end
			if Facing2 == 3 then Player2Extra1 = 36 Player2Direction = 2 end
			--Surfing
			if Facing2 == 29 then Player2Extra1 = 37 Player2Direction = 4 end
			if Facing2 == 30 then Player2Extra1 = 38 Player2Direction = 3 end
			if Facing2 == 31 then Player2Extra1 = 39 Player2Direction = 1 end
			if Facing2 == 32 then Player2Extra1 = 40 Player2Direction = 2 end
			--Turning
			if Facing2 == 41 then Player2Extra1 = 33 Player2Direction = 4 end
			if Facing2 == 42 then Player2Extra1 = 34 Player2Direction = 3 end
			if Facing2 == 43 then Player2Extra1 = 35 Player2Direction = 1 end
			if Facing2 == 44 then Player2Extra1 = 36 Player2Direction = 2 end
			--hitting a wall
			if Facing2 == 33 then Player2Extra1 = 33 Player2Direction = 4 end
			if Facing2 == 34 then Player2Extra1 = 34 Player2Direction = 3 end
			if Facing2 == 35 then Player2Extra1 = 35 Player2Direction = 1 end
			if Facing2 == 36 then Player2Extra1 = 36 Player2Direction = 2 end
		elseif Bike == 1 then
			if Facing2 == 0 then Player2Extra1 = 17 Player2Direction = 4 end
			if Facing2 == 1 then Player2Extra1 = 18 Player2Direction = 3 end
			if Facing2 == 2 then Player2Extra1 = 19 Player2Direction = 1 end
			if Facing2 == 3 then Player2Extra1 = 20 Player2Direction = 2 end
			--Standard speed
			if Facing2 == 49 then Player2Extra1 = 21 Player2Direction = 4 end
			if Facing2 == 50 then Player2Extra1 = 22 Player2Direction = 3 end
			if Facing2 == 51 then Player2Extra1 = 23 Player2Direction = 1 end
			if Facing2 == 52 then Player2Extra1 = 24 Player2Direction = 2 end
			--In case you use a fast bike
			if Facing2 == 61 then Player2Extra1 = 25 Player2Direction = 4 end
			if Facing2 == 62 then Player2Extra1 = 26 Player2Direction = 3 end
			if Facing2 == 63 then Player2Extra1 = 27 Player2Direction = 1 end
			if Facing2 == 64 then Player2Extra1 = 28 Player2Direction = 2 end
			--hitting a wall
			if Facing2 == 37 then Player2Extra1 = 29 Player2Direction = 4 end
			if Facing2 == 38 then Player2Extra1 = 30 Player2Direction = 3 end
			if Facing2 == 39 then Player2Extra1 = 31 Player2Direction = 1 end
			if Facing2 == 40 then Player2Extra1 = 32 Player2Direction = 2 end
		else
			if Facing2 == 0 then Player2Extra1 = 1 Player2Direction = 4 end
			if Facing2 == 1 then Player2Extra1 = 2 Player2Direction = 3 end
			if Facing2 == 2 then Player2Extra1 = 3 Player2Direction = 1 end
			if Facing2 == 3 then Player2Extra1 = 4 Player2Direction = 2 end
			if Facing2 == 33 then Player2Extra1 = 5 Player2Direction = 4 end
			if Facing2 == 34 then Player2Extra1 = 6 Player2Direction = 3 end
			if Facing2 == 35 then Player2Extra1 = 7 Player2Direction = 1 end
			if Facing2 == 36 then Player2Extra1 = 8 Player2Direction = 2 end
			if Facing2 == 37 then Player2Extra1 = 1 Player2Direction = 4 end
			if Facing2 == 38 then Player2Extra1 = 2 Player2Direction = 3 end
			if Facing2 == 39 then Player2Extra1 = 3 Player2Direction = 1 end
			if Facing2 == 40 then Player2Extra1 = 4 Player2Direction = 2 end
			if Facing2 == 16 then Player2Extra1 = 5 Player2Direction = 4 end
			if Facing2 == 17 then Player2Extra1 = 6 Player2Direction = 3 end
			if Facing2 == 18 then Player2Extra1 = 7 Player2Direction = 1 end
			if Facing2 == 19 then Player2Extra1 = 8 Player2Direction = 2 end
			if Facing2 == 41 then Player2Extra1 = 9 Player2Direction = 4 end
			if Facing2 == 42 then Player2Extra1 = 10 Player2Direction = 3 end
			if Facing2 == 43 then Player2Extra1 = 11 Player2Direction = 1 end
			if Facing2 == 44 then Player2Extra1 = 12 Player2Direction = 2 end
			if Facing2 == 61 then Player2Extra1 = 13 Player2Direction = 4 end
			if Facing2 == 62 then Player2Extra1 = 14 Player2Direction = 3 end
			if Facing2 == 63 then Player2Extra1 = 15 Player2Direction = 1 end
			if Facing2 == 64 then Player2Extra1 = 16 Player2Direction = 2 end
		--	if Facing2 == 255 then Player2Extra1 = 0 end
		end
		ActualPlayerDirection = Player2Direction
	--	if TempVar2 == 0 then ConsoleForText:print("MapID: " .. MapID .. "PlayerMapID" .. PlayerMapID) end
		if PlayerNewMap ~= 0 then
			if Player2DirectionPrev == 1 then
			MapStartX2 = tonumber(NewMapX2)
			MapStartY2 = tonumber(NewMapY2)
			MapStartX2 = MapStartX2 - 1
			PlayerNewMap = 0
			elseif Player2DirectionPrev == 2 then
			MapStartX2 = tonumber(NewMapX2)
			MapStartY2 = tonumber(NewMapY2)
			MapStartX2 = MapStartX2 + 1
			PlayerNewMap = 0
			elseif Player2DirectionPrev == 3 then
			MapStartX2 = tonumber(NewMapX2)
			MapStartY2 = tonumber(NewMapY2)
			MapStartY2 = MapStartY2 - 1
			PlayerNewMap = 0
			elseif Player2DirectionPrev == 4 then
			MapStartX2 = tonumber(NewMapX2)
			MapStartY2 = tonumber(NewMapY2)
			MapStartY2 = MapStartY2 + 1
			PlayerNewMap = 0
			end
		end
		if MapID2 ~= PlayerMapID then
			Player2DirectionPrev = Player2Direction
			ActualPlayerDirectionPrev = ActualPlayerDirection
			MapStartX2 = tonumber(NewMapX2)
			MapStartY2 = tonumber(NewMapY2)
			PlayerNewMap = 1
			MapID2 = tonumber(PlayerMapID)
		end
	elseif PlayerID == 3 then
	elseif PlayerID == 4 then
	end
end

function NoPlayersIfScreen()
	local ScreenData1 = 0
	local ScreenData2 = 0
	local ScreenData3 = 0
	local u32 ScreenDataAddress1 = 0
	local u32 ScreenDataAddress2 = 0
	local u32 ScreenDataAddress3 = 0
	if GameID == "BPR1" or GameID == "BPR2" then
		--Addresses for Firered
		ScreenDataAddress1 = 33686722
		ScreenDataAddress2 = 33686723
		--For intro
		ScreenDataAddress3 = 33686716
	elseif GameID == "BPG1" or GameID == "BPG2" then
		--Addresses for Leafgreen
		ScreenDataAddress1 = 33686722
		ScreenDataAddress2 = 33686723
		--For intro
		ScreenDataAddress3 = 33686716
	end
		ScreenData1 = emu:read8(ScreenDataAddress1)
		ScreenData2 = emu:read8(ScreenDataAddress2)
		ScreenData3 = emu:read8(ScreenDataAddress3)
		
	--	if TempVar2 == 0 then ConsoleForText:print("ScreenData: " .. ScreenData1 .. " " .. ScreenData2 .. " " .. ScreenData3) end
		--If screen data are these then hide players
		if ScreenData3 ~= 80 or (ScreenData1 > 1 and ScreenData1 < 28) or ScreenData2 == 18 or ScreenData2 == 27 then
			ScreenData = 0
		else
			ScreenData = 1
		end
end


function AnimatePlayerMovement(PlayerNo, AnimateID)
		--This is for updating the previous coords with new ones, without looking janky
		--AnimateID List
		--0 = Standing Still
		--1 = Walking Down
		--2 = Walking Up
		--3 = Walking Left/Right
		--4 = Running Down
		--5 = Running Up
		--6 = Running Left/Right
		--7 = Bike Down
		--8 = Bike Up
		--9 = Bike left/right
		--10 = Face down
		--11 = Face up
		--12 = Face left/right
		
	if MapX == 0 then MapX = NewMapX end
	if MapY == 0 then MapY = NewMapY end
	if MapX2 == 0 then MapX2 = NewMapX2 end
	if MapY2 == 0 then MapY2 = NewMapY2 end
	if MapX3 == 0 then MapX3 = NewMapX3 end
	if MapY3 == 0 then MapY3 = NewMapY3 end
	if MapX4 == 0 then MapX4 = NewMapX4 end
	if MapY4 == 0 then MapY4 = NewMapY4 end
		local XMap = 0
		local YMap = 0
		local NewXMap = 0
		local NewYMap = 0
		local NewMapPosX = 0
		local NewMapPosY = 0
		local Charpic = 0
		local PlayerAnimationFrame = 0
		local PlayerAnimationFrame2 = 0
		local PlayerExtra = 0
		local PlayerAnimationFrameMax = 16
		local Direction = 0
		local FacingDir = 0
		local SpriteNumber = 0
		local PrevAnim = 0
		--PLAYERS
		if PlayerNo == 1 then
			XMap = MapX
			YMap = MapY
			NewXMap = NewMapX
			NewYMap = NewMapY
			NewMapPosX = NewMapXPos
			NewMapPosY = NewMapYPos
			Charpic = 0
			PlayerAnimationFrame = Player1AnimationFrame
			PlayerAnimationFrame2 = Player1AnimationFrame2
			PlayerExtra = PlayerExtra1
			Direction = PlayerDirection
			FacingDir = Facing
			SpriteNumber = PlayerExtra2
			PrevAnim = PlayerPrevAnimation[1]
		elseif PlayerNo == 2 then
			XMap = MapX2
			YMap = MapY2
			NewXMap = NewMapX2
			NewYMap = NewMapY2
			NewMapPosX = NewMapX2Pos
			NewMapPosY = NewMapY2Pos
			Charpic = 1
			PlayerAnimationFrame = Player2AnimationFrame
			PlayerAnimationFrame2 = Player2AnimationFrame2
			PlayerExtra = Player2Extra1
			Direction = Player2Direction
			FacingDir = Facing2
			SpriteNumber = Player2Extra2
			PrevAnim = PlayerPrevAnimation[2]
		elseif PlayerNo == 3 then
			XMap = MapX3
			YMap = MapY3
			NewXMap = NewMapX3
			NewYMap = NewMapY3
			NewMapPosX = NewMapX3Pos
			NewMapPosY = NewMapY3Pos
			Charpic = 2
			PlayerAnimationFrame = Player3AnimationFrame
			PlayerAnimationFrame2 = Player3AnimationFrame2
			PlayerExtra = Player3Extra1
			SpriteNumber = Player3Extra2
			PrevAnim = PlayerPrevAnimation[3]
		elseif PlayerNo == 4 then
			XMap = MapX4
			YMap = MapY4
			NewXMap = NewMapX4
			NewYMap = NewMapY4
			NewMapPosX = NewMapX4Pos
			NewMapPosY = NewMapY4Pos
			Charpic = 3
			PlayerAnimationFrame = Player4AnimationFrame
			PlayerAnimationFrame2 = Player4AnimationFrame2
			PlayerExtra = Player4Extra1
			SpriteNumber = Player4Extra2
			PrevAnim = PlayerPrevAnimation[4]
		end
			AnimatePlayerMoveX = ((NewXMap * 16) - NewMapPosX) - (XMap * 16)
			AnimatePlayerMoveY = ((NewYMap * 16) - NewMapPosY) - (YMap * 16)
			
			if PlayerAnimationFrame < 0 then PlayerAnimationFrame = 0 end
	--		if PlayerAnimationFrame > 20 then PlayerAnimationFrame = 0 end
			--16 is the standard for 1 movement.
			PlayerAnimationFrame = PlayerAnimationFrame + 1
			
		--	if AnimateID ~= 255 then
		--	log("Max frame: " .. PlayerAnimationFrameMax .. "Current frame: " .. PlayerAnimationFrame)
		--	end
			
			--Animate left movement
			if AnimatePlayerMoveX < 0 then
		
	--	if AnimateID < 250 then ConsoleForText:print("Extra: " .. PlayerExtra .. "  " .. AnimateID) end
				
				--Walk
				if AnimateID == 3 then
					PlayerAnimationFrameMax = 14
					NewMapPosX = NewMapPosX - 1
					if PlayerAnimationFrame == 5 then NewMapPosX = NewMapPosX - 1 end
					if PlayerAnimationFrame == 9 then NewMapPosX = NewMapPosX - 1 end
					if PlayerAnimationFrame >= 3 and PlayerAnimationFrame <= 11 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4,SpriteNumber)
						else
						createChars(Charpic,5,SpriteNumber)
						end
					else
						createChars(Charpic,1,SpriteNumber)
					end
				--Run
				elseif AnimateID == 6 then
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX - 4
				--	ConsoleForText:print("Frame: " .. PlayerAnimationFrame)
					if PlayerAnimationFrame == 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,20,SpriteNumber)
						else
						createChars(Charpic,21,SpriteNumber)
						end
					else
						createChars(Charpic,19,SpriteNumber)
					end
				--Bike
				elseif AnimateID == 9 then
					PlayerAnimationFrameMax = 6
					NewMapPosX = NewMapPosX - 4
					if PlayerAnimationFrame > 2 and PlayerAnimationFrame <= 4 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,13,SpriteNumber)
						else
						createChars(Charpic,14,SpriteNumber)
						end
					else
						createChars(Charpic,10,SpriteNumber)
					end
				--Surf
				elseif AnimateID == 23 then
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX - 4
					createChars(Charpic,30,SpriteNumber)
					createChars(Charpic,36,SpriteNumber)
				else
				
				end
				
			--Animate right movement
			elseif AnimatePlayerMoveX > 0 then
				if AnimateID == 13 then
					PlayerAnimationFrameMax = 14
					NewMapPosX = NewMapPosX + 1
					if PlayerAnimationFrame == 5 then NewMapPosX = NewMapPosX + 1 end
					if PlayerAnimationFrame == 9 then NewMapPosX = NewMapPosX + 1 end
					if PlayerAnimationFrame >= 3 and PlayerAnimationFrame <= 11 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4,SpriteNumber)
						else
						createChars(Charpic,5,SpriteNumber)
						end
					else
						createChars(Charpic,1,SpriteNumber)
					end
				elseif AnimateID == 14 then
				--	ConsoleForText:print("Running")
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX + 4
					if PlayerAnimationFrame == 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,20,SpriteNumber)
						else
						createChars(Charpic,21,SpriteNumber)
						end
					else
						createChars(Charpic,19,SpriteNumber)
					end
				elseif AnimateID == 15 then
				--	ConsoleForText:print("Bike")
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX + 4
					if PlayerAnimationFrame > 2 and PlayerAnimationFrame <= 4 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,13,SpriteNumber)
						else
						createChars(Charpic,14,SpriteNumber)
						end
					else
						createChars(Charpic,10,SpriteNumber)
					end
				--Surf
				elseif AnimateID == 24 then
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX + 4
					createChars(Charpic,30,SpriteNumber)
					createChars(Charpic,36,SpriteNumber)
				else
				
				end
			else
				XMap = NewXMap
				NewMapPosX = 0
				--Turn player left/right
				if AnimateID == 12 then
					PlayerAnimationFrameMax = 8
					if PlayerAnimationFrame > 1 and PlayerAnimationFrame < 6 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4,SpriteNumber)
						else
						createChars(Charpic,5,SpriteNumber)
						end
					else
						createChars(Charpic,1,SpriteNumber)
					end
				--If they are now equal
				end
				--Surfing animation
				if AnimateID == 19 then
					createChars(Charpic,36,SpriteNumber)
					if PrevAnim ~= 19 then PlayerAnimationFrame2 = 0 PlayerAnimationFrame = 24 end
					PlayerAnimationFrameMax = 48
					if PlayerAnimationFrame2 == 0 then createChars(Charpic,30,SpriteNumber)
					elseif PlayerAnimationFrame2 == 1 then createChars(Charpic,33,SpriteNumber)
					end
				elseif AnimateID == 20 then
					createChars(Charpic,36,SpriteNumber)
					if PrevAnim ~= 20 then PlayerAnimationFrame2 = 0 PlayerAnimationFrame = 24 end
					PlayerAnimationFrameMax = 48
					if PlayerAnimationFrame2 == 0 then createChars(Charpic,30,SpriteNumber)
					elseif PlayerAnimationFrame2 == 1 then createChars(Charpic,33,SpriteNumber)
					end
				end
			end
			
			
			--Animate up movement
			if AnimatePlayerMoveY < 0 then
				if AnimateID == 2 then
					PlayerAnimationFrameMax = 14
					NewMapPosY = NewMapPosY - 1
					if PlayerAnimationFrame == 5 then NewMapPosY = NewMapPosY - 1 end
					if PlayerAnimationFrame == 9 then NewMapPosY = NewMapPosY - 1 end
					if PlayerAnimationFrame >= 3 and PlayerAnimationFrame <= 11 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,6,SpriteNumber)
						else
						createChars(Charpic,7,SpriteNumber)
						end	
					else
						createChars(Charpic,2,SpriteNumber)
					end
				elseif AnimateID == 5 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY - 4
					if PlayerAnimationFrame == 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,23,SpriteNumber)
						else
						createChars(Charpic,24,SpriteNumber)
						end
					else
						createChars(Charpic,22,SpriteNumber)
					end
				elseif AnimateID == 8 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY - 4
					if PlayerAnimationFrame > 2 and PlayerAnimationFrame <= 4 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,15,SpriteNumber)
						else
						createChars(Charpic,16,SpriteNumber)
						end
					else
						createChars(Charpic,11,SpriteNumber)
					end
				--Surf
				elseif AnimateID == 22 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY - 4
					createChars(Charpic,29,SpriteNumber)
					createChars(Charpic,35,SpriteNumber)
				end
					
			--Animate down movement
			elseif AnimatePlayerMoveY > 0 then
				if AnimateID == 1 then
					PlayerAnimationFrameMax = 14
					NewMapPosY = NewMapPosY + 1
					if PlayerAnimationFrame == 5 then NewMapPosY = NewMapPosY + 1 end
					if PlayerAnimationFrame == 9 then NewMapPosY = NewMapPosY + 1 end
					if PlayerAnimationFrame >= 3 and PlayerAnimationFrame <= 11 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,8,SpriteNumber)
						else
						createChars(Charpic,9,SpriteNumber)
						end
					else
						createChars(Charpic,3,SpriteNumber)
					end
				elseif AnimateID == 4 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY + 4
					if PlayerAnimationFrame == 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,26,SpriteNumber)
						else
						createChars(Charpic,27,SpriteNumber)
						end
					else
						createChars(Charpic,25,SpriteNumber)
					end
				elseif AnimateID == 7 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY + 4
					if PlayerAnimationFrame > 2 and PlayerAnimationFrame <= 4 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,17,SpriteNumber)
						else
						createChars(Charpic,18,SpriteNumber)
						end
					else
						createChars(Charpic,12,SpriteNumber)
					end
				--Surf
				elseif AnimateID == 21 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY + 4
					createChars(Charpic,28,SpriteNumber)
					createChars(Charpic,34,SpriteNumber)
				--If they are now equal
				end
			else
					YMap = NewYMap
					NewMapPosY = 0
				--Turn player down
				if AnimateID == 10 then
					PlayerAnimationFrameMax = 8
					if PlayerAnimationFrame > 1 and PlayerAnimationFrame < 6 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,8,SpriteNumber)
						else
						createChars(Charpic,9,SpriteNumber)
						end
					else
						createChars(Charpic,3,SpriteNumber)
					end
				--Turn player up
				
				elseif AnimateID == 11 then
					PlayerAnimationFrameMax = 8
					if PlayerAnimationFrame > 1 and PlayerAnimationFrame < 6 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,6,SpriteNumber)
						else
						createChars(Charpic,7,SpriteNumber)
						end
					else
						createChars(Charpic,2,SpriteNumber)
					end
				else
				--		createChars(Charpic,3,SpriteNumber)
				end
				
				--Surfing animation
				if AnimateID == 17 then
					createChars(Charpic,34,SpriteNumber)
					if PrevAnim ~= 17 then PlayerAnimationFrame2 = 0 PlayerAnimationFrame = 24 end
					PlayerAnimationFrameMax = 48
					if PlayerAnimationFrame2 == 0 then createChars(Charpic,28,SpriteNumber)
					elseif PlayerAnimationFrame2 == 1 then createChars(Charpic,31,SpriteNumber)
					end
				elseif AnimateID == 18 then
					createChars(Charpic,35,SpriteNumber)
					if PrevAnim ~= 18 then PlayerAnimationFrame2 = 0 PlayerAnimationFrame = 24 end
					PlayerAnimationFrameMax = 48
					if PlayerAnimationFrame2 == 0 then createChars(Charpic,29,SpriteNumber)
					elseif PlayerAnimationFrame2 == 1 then createChars(Charpic,32,SpriteNumber)
					end
				--If they are now equal
				end
			end
			
			if AnimateID == 251 then
				PlayerAnimationFrame = 0
				XMap = NewXMap
				YMap = NewYMap
				NewMapPosX = 0
				NewMapPosY = 0
			elseif AnimateID == 252 then
				PlayerAnimationFrame = 0
				XMap = NewXMap
				YMap = NewYMap
				NewMapPosX = 0
				NewMapPosY = 0
			elseif AnimateID == 253 then
				PlayerAnimationFrame = 0
				XMap = NewXMap
				YMap = NewYMap
				NewMapPosX = 0
				NewMapPosY = 0
			elseif AnimateID == 254 then
				PlayerAnimationFrame = 0
				XMap = NewXMap
				YMap = NewYMap
				NewMapPosX = 0
				NewMapPosY = 0
			end
			
			if PlayerAnimationFrameMax <= PlayerAnimationFrame then
				PlayerAnimationFrame = 0
				if PlayerAnimationFrame2 == 0 then
					PlayerAnimationFrame2 = 1
				else
					PlayerAnimationFrame2 = 0
				end
			end
			
		PrevAnim = AnimateID
		--PLAYERS
		if PlayerNo == 1 then
			MapX = XMap
			MapY = YMap
			NewMapX = NewXMap
			NewMapY = NewYMap
			NewMapXPos = NewMapPosX
			NewMapYPos = NewMapPosY
			Player1AnimationFrame = PlayerAnimationFrame
			Player1AnimationFrame2 = PlayerAnimationFrame2
			PlayerExtra1 = PlayerExtra
			PlayerDirection = Direction
			Facing = FacingDir
			PlayerPrevAnimation[1] = PrevAnim
		elseif PlayerNo == 2 then
			MapX2 = XMap
			MapY2 = YMap
			NewMapX2 = NewXMap
			NewMapY2 = NewYMap
			NewMapX2Pos = NewMapPosX
			NewMapY2Pos = NewMapPosY
			Player2AnimationFrame = PlayerAnimationFrame
			Player2AnimationFrame2 = PlayerAnimationFrame2
			Player2Extra1 = PlayerExtra
			Player2Direction = Direction
			Facing2 = FacingDir
			PlayerPrevAnimation[2] = PrevAnim
		elseif PlayerNo == 3 then
			MapX3 = XMap
			MapY3 = YMap
			NewMapX3 = NewXMap
			NewMapY3 = NewYMap
			NewMapX3Pos = NewMapPosX
			NewMapY3Pos = NewMapPosY
			Player3AnimationFrame = PlayerAnimationFrame
			Player3AnimationFrame2 = PlayerAnimationFrame2
			Player3Extra1 = PlayerExtra
			PlayerPrevAnimation[3] = PrevAnim
		elseif PlayerNo == 4 then
			MapX4 = XMap
			MapY4 = YMap
			NewMapX4 = NewXMap
			NewMapY4 = NewYMap
			NewMapX4Pos = NewMapPosX
			NewMapY4Pos = NewMapPosY
			Player4AnimationFrame = PlayerAnimationFrame
			Player4AnimationFrame2 = PlayerAnimationFrame2
			Player4Extra1 = PlayerExtra
			PlayerPrevAnimation[4] = PrevAnim
		end
end

function HandleSprites()
	--Because handling images every time would become a hassle, this will automatically set the image of every player
	
	
	--PlayerExtra 1 = Down Face
	--PlayerExtra 2 = Up Face
	--PlayerExtra 3 or 4 = Left/Right Face
	--PlayerExtra 5 = Down Walk
	--PlayerExtra 6 = Up Walk
	--PlayerExtra 7 or 8 = Left/Right Walk
	--PlayerExtra 9 = Down Turn
	--PlayerExtra 10 = Up Turn
	--PlayerExtra 11 or 12 = Left/Right Turn
	--PlayerExtra 13 = Down Run
	--PlayerExtra 14 = Up Run
	--PlayerExtra 15 or 16 = Left/Right Run
	--PlayerExtra 17 = Down Bike
	--PlayerExtra 18 = Up Bike
	--PlayerExtra 19 or 20 = Left/Right Bike
	
	--PlayerExtra 33 - 36 = Surf still
	--PlayerExtra 37 - 40 = Surf moving
	
	--Player 1 sprite
	if PlayerID ~= 1 then
	
		--While another player is loading into another map. One time
		if NewMap ~= 0 then
			MapX = MapStartX
			MapY = MapStartY
		end
		
		--Facing down
		if PlayerExtra1 == 1 then createChars(0,3,PlayerExtra2) PlayerDirection = 4 Facing = 0 AnimatePlayerMovement(1, 251)
		
		--Facing up
		elseif PlayerExtra1 == 2 then createChars(0,2,PlayerExtra2) PlayerDirection = 3 Facing = 0 AnimatePlayerMovement(1, 252)
		
		--Facing left
		elseif PlayerExtra1 == 3 then createChars(0,1,PlayerExtra2) PlayerDirection = 1 Facing = 0 AnimatePlayerMovement(1, 253)
		
		--Facing right
		elseif PlayerExtra1 == 4 then createChars(0,1,PlayerExtra2) PlayerDirection = 2 Facing = 1 AnimatePlayerMovement(1, 254)
		
		--walk down
		elseif PlayerExtra1 == 5 then Facing = 0 PlayerDirection = 4 AnimatePlayerMovement(1, 1)
		
		--walk up
		elseif PlayerExtra1 == 6 then Facing = 0 PlayerDirection = 3 AnimatePlayerMovement(1, 2)
		
		--walk left
		elseif PlayerExtra1 == 7 then Facing = 0 PlayerDirection = 1 AnimatePlayerMovement(1, 3)
		
		--walk right
		elseif PlayerExtra1 == 8 then Facing = 1 PlayerDirection = 2 AnimatePlayerMovement(1, 13)
		
		--turn down
		elseif PlayerExtra1 == 9 then Facing = 0 PlayerDirection = 4 AnimatePlayerMovement(1, 10)
		
		--turn up
		elseif PlayerExtra1 == 10 then Facing = 0 PlayerDirection = 3 AnimatePlayerMovement(1, 11)
		
		--turn left
		elseif PlayerExtra1 == 11 then Facing = 0 PlayerDirection = 1 AnimatePlayerMovement(1, 12)
		
		--turn right
		elseif PlayerExtra1 == 12 then Facing = 1 PlayerDirection = 2 AnimatePlayerMovement(1, 12)
		
		--run down
		elseif PlayerExtra1 == 13 then Facing = 0 PlayerDirection = 4 AnimatePlayerMovement(1, 4)
		
		--run up
		elseif PlayerExtra1 == 14 then Facing = 0 PlayerDirection = 3 AnimatePlayerMovement(1, 5)
		
		--run left
		elseif PlayerExtra1 == 15 then Facing = 0 PlayerDirection = 1 AnimatePlayerMovement(1, 6)
		
		--run right
		elseif PlayerExtra1 == 16 then Facing = 1 PlayerDirection = 2 AnimatePlayerMovement(1, 14)
		
		--bike face down
		elseif PlayerExtra1 == 17 then createChars(0,12,PlayerExtra2) PlayerDirection = 4 Facing = 0 AnimatePlayerMovement(1, 251)
		
		--bike face up
		elseif PlayerExtra1 == 18 then createChars(0,11,PlayerExtra2) PlayerDirection = 3 Facing = 0 AnimatePlayerMovement(1, 252)
		
		--bike face left
		elseif PlayerExtra1 == 19 then createChars(0,10,PlayerExtra2) PlayerDirection = 1 Facing = 0 AnimatePlayerMovement(1, 253)
		
		--bike face right
		elseif PlayerExtra1 == 20 then createChars(0,10,PlayerExtra2) PlayerDirection = 2 Facing = 1 AnimatePlayerMovement(1, 254)
		
		--bike move down
		elseif PlayerExtra1 == 21 then Facing = 0 PlayerDirection = 4 AnimatePlayerMovement(1, 7)
		
		--bike move up
		elseif PlayerExtra1 == 22 then Facing = 0 PlayerDirection = 3 AnimatePlayerMovement(1, 8)
		
		--bike move left
		elseif PlayerExtra1 == 23 then Facing = 0 PlayerDirection = 1 AnimatePlayerMovement(1, 9)
		
		--bike move right
		elseif PlayerExtra1 == 24 then Facing = 1 PlayerDirection = 2 AnimatePlayerMovement(1, 15)
		
		--bike fast move down
		elseif PlayerExtra1 == 25 then Facing = 0 PlayerDirection = 4 AnimatePlayerMovement(1, 7)
		
		--bike fast move up
		elseif PlayerExtra1 == 26 then Facing = 0 PlayerDirection = 3 AnimatePlayerMovement(1, 8)
		
		--bike fast move left
		elseif PlayerExtra1 == 27 then Facing = 0 PlayerDirection = 1 AnimatePlayerMovement(1, 9)
		
		--bike fast move right
		elseif PlayerExtra1 == 28 then Facing = 1 PlayerDirection = 2 AnimatePlayerMovement(1, 15)
		
		--bike hit wall down
		elseif PlayerExtra1 == 29 then createChars(0,12,PlayerExtra2) PlayerDirection = 4 Facing = 0 AnimatePlayerMovement(1, 251)
		
		--bike hit wall up
		elseif PlayerExtra1 == 30 then createChars(0,11,PlayerExtra2) PlayerDirection = 3 Facing = 0 AnimatePlayerMovement(1, 252)
		
		--bike hit wall left
		elseif PlayerExtra1 == 31 then createChars(0,10,PlayerExtra2) PlayerDirection = 1 Facing = 0 AnimatePlayerMovement(1, 253)
		
		--bike hit wall right
		elseif PlayerExtra1 == 32 then createChars(0,10,PlayerExtra2) PlayerDirection = 2 Facing = 1 AnimatePlayerMovement(1, 254)
		
		
		--Surfing
		
		--Facing down
		elseif PlayerExtra1 == 33 then PlayerDirection = 4 Facing = 0 AnimatePlayerMovement(1, 17)
		
		--Facing up
		elseif PlayerExtra1 == 34 then PlayerDirection = 3 Facing = 0 AnimatePlayerMovement(1, 18)
		
		--Facing left
		elseif PlayerExtra1 == 35 then PlayerDirection = 1 Facing = 0 AnimatePlayerMovement(1, 19)
		
		--Facing right
		elseif PlayerExtra1 == 36 then PlayerDirection = 2 Facing = 1 AnimatePlayerMovement(1, 20)
		
		--surf down
		elseif PlayerExtra1 == 37 then Facing = 0 PlayerDirection = 4 AnimatePlayerMovement(1, 21)
		
		--surf up
		elseif PlayerExtra1 == 38 then Facing = 0 PlayerDirection = 3 AnimatePlayerMovement(1, 22)
		
		--surf left
		elseif PlayerExtra1 == 39 then Facing = 0 PlayerDirection = 1 AnimatePlayerMovement(1, 23)
		
		--surf right
		elseif PlayerExtra1 == 40 then Facing = 1 PlayerDirection = 2 AnimatePlayerMovement(1, 24)
		
		
		
		--default position
		elseif PlayerExtra1 == 0 then Facing = 0 AnimatePlayerMovement(1, 255)
		
		end
		if NewMap ~= 0 then
			NewMap = 0
			PlayerDirectionPrev = PlayerDirection
			if PlayerDirectionPrev ~= 0 then
				if PlayerDirectionPrev == 1 then
			--		ConsoleForText:print("Left" .. Player2Extra1)
					MapStartX = MapStartX + 1
				--	MapX2 = MapX2 + 1
				--Down
				elseif PlayerDirectionPrev == 2 then
			--		ConsoleForText:print("Right" .. Player2Extra1)
					MapStartX = MapStartX - 1
				--	MapX2 = MapX2 - 1
				--Left
				elseif PlayerDirectionPrev == 3 then
			--		ConsoleForText:print("P2 Up")
					MapStartY = MapStartY + 1
				--	MapY2 = MapY2 + 1
				--Right
				elseif PlayerDirectionPrev == 4 then
			--		ConsoleForText:print("P2 Down")
					MapStartY = MapStartY - 1
			--		MapY2 = MapY2 - 1
				end
			end
		end
	end
	
	--Player 2 sprite
	if PlayerID ~= 2 then
	
		--While another player is loading into another map. One time
		if NewMap2 ~= 0 then
			MapX2 = MapStartX2
			MapY2 = MapStartY2
		end
		--if TempVar2 == 0 then ConsoleForText:print("PlayerExtra2: " .. Player2Extra2) end
		--Facing down
		if Player2Extra1 == 1 then createChars(1,3,Player2Extra2) Player2Direction = 4 Facing2 = 0 AnimatePlayerMovement(2, 251)
		
		--Facing up
		elseif Player2Extra1 == 2 then createChars(1,2,Player2Extra2) Player2Direction = 3 Facing2 = 0 AnimatePlayerMovement(2, 252)
		
		--Facing left
		elseif Player2Extra1 == 3 then createChars(1,1,Player2Extra2) Player2Direction = 1 Facing2 = 0 AnimatePlayerMovement(2, 253)
		
		--Facing right
		elseif Player2Extra1 == 4 then createChars(1,1,Player2Extra2) Player2Direction = 2 Facing2 = 1 AnimatePlayerMovement(2, 254)
		
		--walk down
		elseif Player2Extra1 == 5 then Facing2 = 0 Player2Direction = 4 AnimatePlayerMovement(2, 1)
		
		--walk up
		elseif Player2Extra1 == 6 then Facing2 = 0 Player2Direction = 3 AnimatePlayerMovement(2, 2)
		
		--walk left
		elseif Player2Extra1 == 7 then Facing2 = 0 Player2Direction = 1 AnimatePlayerMovement(2, 3)
		
		--walk right
		elseif Player2Extra1 == 8 then Facing2 = 1 Player2Direction = 2 AnimatePlayerMovement(2, 13)
		
		--turn down
		elseif Player2Extra1 == 9 then Facing2 = 0 Player2Direction = 4 AnimatePlayerMovement(2, 10)
		
		--turn up
		elseif Player2Extra1 == 10 then Facing2 = 0 Player2Direction = 3 AnimatePlayerMovement(2, 11)
		
		--turn left
		elseif Player2Extra1 == 11 then Facing2 = 0 Player2Direction = 1 AnimatePlayerMovement(2, 12)
		
		--turn right
		elseif Player2Extra1 == 12 then Facing2 = 1 Player2Direction = 2 AnimatePlayerMovement(2, 12)
		
		--run down
		elseif Player2Extra1 == 13 then Facing2 = 0 Player2Direction = 4 AnimatePlayerMovement(2, 4)
		
		--run up
		elseif Player2Extra1 == 14 then Facing2 = 0 Player2Direction = 3 AnimatePlayerMovement(2, 5)
		
		--run left
		elseif Player2Extra1 == 15 then Facing2 = 0 Player2Direction = 1 AnimatePlayerMovement(2, 6)
		
		--run right
		elseif Player2Extra1 == 16 then Facing2 = 1 Player2Direction = 2 AnimatePlayerMovement(2, 14)
		
		--bike face down
		elseif Player2Extra1 == 17 then createChars(1,12,Player2Extra2) Player2Direction = 4 Facing2 = 0 AnimatePlayerMovement(2, 251)
		
		--bike face up
		elseif Player2Extra1 == 18 then createChars(1,11,Player2Extra2) Player2Direction = 3 Facing2 = 0 AnimatePlayerMovement(2, 252)
		
		--bike face left
		elseif Player2Extra1 == 19 then createChars(1,10,Player2Extra2) Player2Direction = 1 Facing2 = 0 AnimatePlayerMovement(2, 253)
		
		--bike face right
		elseif Player2Extra1 == 20 then createChars(1,10,Player2Extra2) Player2Direction = 2 Facing2 = 1 AnimatePlayerMovement(2, 254)
		
		--bike move down
		elseif Player2Extra1 == 21 then Facing2 = 0 Player2Direction = 4 AnimatePlayerMovement(2, 7)
		
		--bike move up
		elseif Player2Extra1 == 22 then Facing2 = 0 Player2Direction = 3 AnimatePlayerMovement(2, 8)
		
		--bike move left
		elseif Player2Extra1 == 23 then Facing2 = 0 Player2Direction = 1 AnimatePlayerMovement(2, 9)
		
		--bike move right
		elseif Player2Extra1 == 24 then Facing2 = 1 Player2Direction = 2 AnimatePlayerMovement(2, 15)
		
		--bike fast move down
		elseif Player2Extra1 == 25 then Facing2 = 0 Player2Direction = 4 AnimatePlayerMovement(2, 7)
		
		--bike fast move up
		elseif Player2Extra1 == 26 then Facing2 = 0 Player2Direction = 3 AnimatePlayerMovement(2, 8)
		
		--bike fast move left
		elseif Player2Extra1 == 27 then Facing2 = 0 Player2Direction = 1 AnimatePlayerMovement(2, 9)
		
		--bike fast move right
		elseif Player2Extra1 == 28 then Facing2 = 1 Player2Direction = 2 AnimatePlayerMovement(2, 15)
		
		--bike hit wall down
		elseif Player2Extra1 == 29 then createChars(1,12,Player2Extra2) Player2Direction = 4 Facing2 = 0 AnimatePlayerMovement(2, 251)
		
		--bike hit wall up
		elseif Player2Extra1 == 30 then createChars(1,11,Player2Extra2) Player2Direction = 3 Facing2 = 0 AnimatePlayerMovement(2, 252)
		
		--bike hit wall left
		elseif Player2Extra1 == 31 then createChars(1,10,Player2Extra2) Player2Direction = 1 Facing2 = 0 AnimatePlayerMovement(2, 253)
		
		--bike hit wall right
		elseif Player2Extra1 == 32 then createChars(1,10,Player2Extra2) Player2Direction = 2 Facing2 = 1 AnimatePlayerMovement(2, 254)
		
		
		--Surfing
		
		--Facing down
		elseif Player2Extra1 == 33 then Player2Direction = 4 Facing2 = 0 AnimatePlayerMovement(2, 17)
		
		--Facing up
		elseif Player2Extra1 == 34 then Player2Direction = 3 Facing2 = 0 AnimatePlayerMovement(2, 18)
		
		--Facing left
		elseif Player2Extra1 == 35 then Player2Direction = 1 Facing2 = 0 AnimatePlayerMovement(2, 19)
		
		--Facing right
		elseif Player2Extra1 == 36 then Player2Direction = 2 Facing2 = 1 AnimatePlayerMovement(2, 20)
		
		--surf down
		elseif Player2Extra1 == 37 then Facing2 = 0 Player2Direction = 4 AnimatePlayerMovement(2, 21)
		
		--surf up
		elseif Player2Extra1 == 38 then Facing2 = 0 Player2Direction = 3 AnimatePlayerMovement(2, 22)
		
		--surf left
		elseif Player2Extra1 == 39 then Facing2 = 0 Player2Direction = 1 AnimatePlayerMovement(2, 23)
		
		--surf right
		elseif Player2Extra1 == 40 then Facing2 = 1 Player2Direction = 2 AnimatePlayerMovement(2, 24)
		
		
		
		--default position
		elseif Player2Extra1 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 255)
		
		end
		
		if NewMap2 ~= 0 then
			NewMap2 = 0
			Player2DirectionPrev = Player2Direction
			if Player2DirectionPrev ~= 0 then
				if Player2Direction == 1 then
			--		ConsoleForText:print("Left" .. Player2Extra1)
					MapStartX2 = MapStartX2 + 1
				--	MapX2 = MapX2 + 1
				--Down
				elseif Player2Direction == 2 then
			--		ConsoleForText:print("Right" .. Player2Extra1)
					MapStartX2 = MapStartX2 - 1
				--	MapX2 = MapX2 - 1
				--Left
				elseif Player2Direction == 3 then
			--		ConsoleForText:print("P2 Up")
					MapStartY2 = MapStartY2 + 1
				--	MapY2 = MapY2 + 1
				--Right
				elseif Player2Direction == 4 then
			--		ConsoleForText:print("P2 Down")
					MapStartY2 = MapStartY2 - 1
			--		MapY2 = MapY2 - 1
				end
			end
		end
	end
	
	--Player 3 sprite
	if PlayerID ~= 3 then
	end
	
	--Player 4 sprite
	if PlayerID ~= 4 then
	end
		if PlayerNewMap ~= 0 then
			if ActualPlayerDirectionPrev ~= 0 then
			--	ConsoleForText:print("PLAYER MAP CHANGE! DIR: " .. ActualPlayerDirectionPrev)
				--Up
				if ActualPlayerDirectionPrev == 1 then
					NewMapNewX = -1
				--Down
				elseif ActualPlayerDirectionPrev == 2 then
					NewMapNewX = 1
				--Left
				elseif ActualPlayerDirectionPrev == 3 then
					NewMapNewY = -1
				--Right
				elseif ActualPlayerDirectionPrev == 4 then
					NewMapNewY = 1
				end
			end
		end
end

function CalculateCamera()
		GetPlayerCamera(0)
	--	ConsoleForText:print("Player X camera: " .. PlayerMapXMove .. "Player Y camera: " .. PlayerMapYMove)
	--	ConsoleForText:print("PlayerMapXMove: " .. PlayerMapXMove .. "PlayerMapYMove: " .. PlayerMapYMove .. "PlayerMapXMovePREV: " .. PlayerMapXMovePrev .. "PlayerMapYMovePrev: " .. PlayerMapYMovePrev)
		
		local ResetXPos = 0
		local ResetYPos = 0
		
		if (PlayerMapXMovePrev > 65500 and PlayerMapXMove < 100) then PlayerMapXMove = PlayerMapXMove + 65536 ResetXPos = 1
		elseif (PlayerMapXMovePrev < 100 and PlayerMapXMove > 65500) then PlayerMapXMove = PlayerMapXMove - 65536 ResetXPos = 2 end
		if (PlayerMapYMovePrev > 65500 and PlayerMapYMove < 100) then PlayerMapYMove = PlayerMapYMove + 65536 ResetYPos = 1
		elseif (PlayerMapYMovePrev < 100 and PlayerMapYMove > 65500) then PlayerMapYMove = PlayerMapYMove - 65536 ResetYPos = 2 end
		
		local PlayerXCameraTemp = PlayerMapXMovePrev - PlayerMapXMove
		local PlayerYCameraTemp = PlayerMapYMovePrev - PlayerMapYMove
		
		if ResetXPos == 1 then PlayerMapXMove = PlayerMapXMove - 65536 ResetXPos = 0
		elseif ResetXPos == 2 then PlayerMapXMove = PlayerMapXMove + 65536 ResetXPos = 0 end
		if ResetYPos == 1 then PlayerMapYMove = PlayerMapYMove - 65536 ResetYPos = 0
		elseif ResetYPos == 2 then PlayerMapYMove = PlayerMapYMove + 65536 ResetYPos = 0 end
	--	if PlayerXCameraTemp > 30000 then PlayerXCameraTemp = PlayerXCameraTemp - 62355 end
	--	if PlayerYCameraTemp > 30000 then PlayerYCameraTemp = PlayerYCameraTemp - 62355 end
	--	if PlayerXCameraTemp < -30000 then PlayerXCameraTemp = PlayerXCameraTemp + 62355 end
	--	if PlayerYCameraTemp < -30000 then PlayerYCameraTemp = PlayerYCameraTemp + 62355 end
	--	if PlayerXCameraTemp ~= 0 then ConsoleForText:print("PlayerXMove: " .. PlayerMapXMove .. "PlayerXMovePrev: " .. PlayerMapXMovePrev) end
		
		--Animate left movement
	--	if TempVar2 == 0 then ConsoleForText:print("PlayerYCameraTemp: " .. PlayerYCameraTemp .. " PlayerMapYMovePrev: " .. PlayerMapYMovePrev .. " PlayerMapYMove: " .. PlayerMapYMove) end
		if PlayerXCameraTemp > 0 then
			PlayerXCamera = PlayerXCamera + PlayerXCameraTemp
		--	ConsoleForText:print("Moving left.")
			
		--Animate right movement
		elseif PlayerXCameraTemp < 0 then
			PlayerXCamera = PlayerXCamera + PlayerXCameraTemp
	--		ConsoleForText:print("Moving right.")
		else
			PlayerXCamera = 0
		end
		
		
		--Animate down movement
		if PlayerYCameraTemp > 0 then
			PlayerYCamera = PlayerYCamera + PlayerYCameraTemp
	--		ConsoleForText:print("Moving up.")
			
		--Animate up movement
		elseif PlayerYCameraTemp < 0 then
			PlayerYCamera = PlayerYCamera + PlayerYCameraTemp
	--		ConsoleForText:print("Moving down.")
		else
			PlayerYCamera = 0
		end
		
	--		if NewMapNewX == -15 then PlayerXCamera = 0 end
			if NewMapNewX < 0 then if NewMapNewX > -16 then NewMapNewX = NewMapNewX - 1 PlayerXCamera = PlayerXCamera -1 end end
	--		if NewMapNewX == 15 then PlayerXCamera = 0 end
			if NewMapNewX > 0 then if NewMapNewX < 16 then NewMapNewX = NewMapNewX + 1 PlayerXCamera = PlayerXCamera +1 end end
	--		if NewMapNewY == -15 then PlayerYCamera = 0 end
	 		if NewMapNewY < 0 then if NewMapNewY > -16 then NewMapNewY = NewMapNewY - 1 PlayerYCamera = PlayerYCamera -1 end end
	--		if NewMapNewY == 15 then PlayerYCamera = 0 end
			if NewMapNewY > 0 then if NewMapNewY < 16 then NewMapNewY = NewMapNewY + 1 PlayerYCamera = PlayerYCamera +1 end end
end


function DrawChars()
	if EnableScript == true then
		NoPlayersIfScreen()
		if ScreenData == 1 then
				--Make sure the sprites are loaded
			
		HidePlayers()
		HandleSprites()
		CalculateCamera()
			if PlayerID ~= 1 then
				DrawPlayer1()
			else
				ErasePlayer1()
			end
			if PlayerID ~= 2 then
				DrawPlayer2()
			else
				ErasePlayer2()
			end
		--	if PlayerID ~= 3 then DrawPlayer3() end
		--	if PlayerID ~= 4 then DrawPlayer4() end
		end
	end
end


function DrawPlayer1()
		local u32 PlayerYAddress = 0
		local u32 PlayerXAddress = 0
		local u32 PlayerFaceAddress = 0
		local u32 PlayerSpriteAddress = 0
		local u32 PlayerExtra1Address = 0
		local u32 PlayerExtra2Address = 0
		local u32 PlayerExtra3Address = 0
		local u32 PlayerExtra4Address = 0
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			Player1Address = 50345168
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		elseif GameID == "BPG1" or GameID == "BPG2" then
			--Addresses for Leafgreen
			Player1Address = 50345168
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		end
		--X and Y vars
		local FinalMapX = MapX * 16 + PlayerXCamera + PlayerXCamera2
		local FinalMapY = MapY * 16 + PlayerYCamera + PlayerYCamera2
		
		--Freeze position of player character until after animation
		if PlayerXCamera == 0 then PlayerX = PlayerMapX * 16 end
		if PlayerYCamera == 0 then PlayerY = PlayerMapY * 16 end
		--Screen size (take into account movement)
		local MinX = -16
		local MaxX = 240
		local MinY = -32
		local MaxY = 144
		if PlayerExtra1 >= 17 and PlayerExtra1 <= 32 then MinX = -8 end
		FinalMapX = FinalMapX + NewMapXPos - PlayerX + 112
		FinalMapY = FinalMapY + NewMapYPos - PlayerY + 56
		
		--Flip sprite if facing right
		local FacingTemp = Facing
		if FacingTemp == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
		
	--	if TempVar2 == 0 then ConsoleForText:print("Player2Vis: " .. Player2Vis .. " Player2Y: " .. FinalMapY .. " Player2X: " .. FinalMapX) end
	--	ConsoleForText:print("Attempting to create player 1. X: " .. MapX .. " Y: " .. MapY)
--		if TempVar2 == 0 then ConsoleForText:print("CURRY PLAYER2: " .. MapStartY2 .. "MAXY PLAYER2: " .. MapY2Prev) end
--		if TempVar2 == 0 then ConsoleForText:print("FINALYP1: " .. FinalMapY .. "CURRY PLAYER1: " .. MapStartY .. "MAXY PLAYER1: " .. MapYPrev) end
		if not ((FinalMapX > MaxX or FinalMapX < MinX) or (FinalMapY > MaxY or FinalMapY < MinY)) then 
			--128 = left, 144 = right facing
			--Facing = 128
			--Sprite effects. 128 is standard, 131 is water effects
			-- extra 1 and 2 are connected to the sprite
			-- 16/152 or 10/98 are for multiplayer rooms
			--extra 1 is the sprite bank, as well as the priority and pallete. Binary.
			--PlayerExtra1 = 2176
			--extra 3 goes from 0 to FC, then to 4. extra 4 adds/subtracts 1 every time this hits 0
			--PlayerExtra3 = 255
			--PlayerExtra4 = 0
			
			--38 and 70 are the middle of the screen
			--16 bytes per up or down. 1 bit up or down per frame for animation
			
			--Subtract camera and player position from the final result
			
			
			if Player1Vis == 1 then
				--Bikes need different vars
				if PlayerExtra1 >= 17 and PlayerExtra1 <= 32 then
				FinalMapX = FinalMapX - 8
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 2560)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				--Surfing char
				PlayerYAddress = Player1Address + 8
				PlayerXAddress = PlayerYAddress + 2
				PlayerFaceAddress = PlayerYAddress + 3
				PlayerSpriteAddress = PlayerYAddress + 1
				PlayerExtra1Address = PlayerYAddress + 4
				PlayerExtra2Address = PlayerYAddress + 5
				PlayerExtra3Address = PlayerYAddress + 6
				PlayerExtra4Address = PlayerYAddress + 7
				emu:write8(PlayerYAddress, 160)
				emu:write8(PlayerXAddress, 48)
				emu:write8(PlayerFaceAddress, 1)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
				--Same with surf
				elseif PlayerExtra1 >= 33 and PlayerExtra1 <= 40 then
				if Player1AnimationFrame2 == 1 and PlayerExtra1 <= 36 then FinalMapY = FinalMapY + 1 end
				--Sitting char
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2560)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				--Surfing char
				if Player1AnimationFrame2 == 1 and PlayerExtra1 <= 36 then FinalMapY = FinalMapY - 1 end
				FinalMapX = FinalMapX - 8
				FinalMapY = FinalMapY + 8
				PlayerYAddress = Player1Address + 8
				PlayerXAddress = PlayerYAddress + 2
				PlayerFaceAddress = PlayerYAddress + 3
				PlayerSpriteAddress = PlayerYAddress + 1
				PlayerExtra1Address = PlayerYAddress + 4
				PlayerExtra2Address = PlayerYAddress + 5
				PlayerExtra3Address = PlayerYAddress + 6
				PlayerExtra4Address = PlayerYAddress + 7
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 2578)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				else
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2560)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				--Surfing char
				PlayerYAddress = Player1Address + 8
				PlayerXAddress = PlayerYAddress + 2
				PlayerFaceAddress = PlayerYAddress + 3
				PlayerSpriteAddress = PlayerYAddress + 1
				PlayerExtra1Address = PlayerYAddress + 4
				PlayerExtra2Address = PlayerYAddress + 5
				PlayerExtra3Address = PlayerYAddress + 6
				PlayerExtra4Address = PlayerYAddress + 7
				emu:write8(PlayerYAddress, 160)
				emu:write8(PlayerXAddress, 48)
				emu:write8(PlayerFaceAddress, 1)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
				end
			--Remove sprite
			else
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
			end
		--Remove sprite
		else
				emu:write8(PlayerYAddress, 160)
				emu:write8(PlayerXAddress, 48)
				emu:write8(PlayerFaceAddress, 1)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
		end
end
function ErasePlayer1()
		local u32 PlayerYAddress = 0
		local u32 PlayerXAddress = 0
		local u32 PlayerFaceAddress = 0
		local u32 PlayerSpriteAddress = 0
		local u32 PlayerExtra1Address = 0
		local u32 PlayerExtra2Address = 0
		local u32 PlayerExtra3Address = 0
		local u32 PlayerExtra4Address = 0
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			Player1Address = 50345168
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		elseif GameID == "BPG1" or GameID == "BPG2" then
			--Addresses for Leafgreen
			Player1Address = 50345168
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		end
				emu:write8(PlayerYAddress, 160)
				emu:write8(PlayerXAddress, 48)
				emu:write8(PlayerFaceAddress, 1)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
end
function DrawPlayer2()
		local u32 PlayerYAddress = 0
		local u32 PlayerXAddress = 0
		local u32 PlayerFaceAddress = 0
		local u32 PlayerSpriteAddress = 0
		local u32 PlayerExtra1Address = 0
		local u32 PlayerExtra2Address = 0
		local u32 PlayerExtra3Address = 0
		local u32 PlayerExtra4Address = 0
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			Player1Address = 50345184
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		elseif GameID == "BPG1" or GameID == "BPG2" then
			--Addresses for Leafgreen
			Player1Address = 50345184
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		end
		
		
		--X and Y vars
		local FinalMapX = MapX2 * 16 + PlayerXCamera + PlayerXCamera2
		local FinalMapY = MapY2 * 16 + PlayerYCamera + PlayerYCamera2
		local TempTemp = MapY2 * 16	
		
		--Freeze position of player character until after animation
		if PlayerXCamera == 0 then PlayerX2 = PlayerMapX * 16 end
		if PlayerYCamera == 0 then PlayerY2 = PlayerMapY * 16 end
		--Screen size (take into account movement)
		local MinX = -16
		local MaxX = 240
		local MinY = -32
		local MaxY = 144
		if Player2Extra1 >= 17 and Player2Extra1 <= 32 then MinX = -8 end
		FinalMapX = FinalMapX + NewMapX2Pos - PlayerX2 + 112
		FinalMapY = FinalMapY + NewMapY2Pos - PlayerY2 + 56
--		FinalMapX = FinalMapX - PlayerX2 + 112
--		FinalMapY = FinalMapY - PlayerY2 + 56
--		if TempVar2 == 0 then ConsoleForText:print("PlayerY2POS: " .. NewMapY2Pos .. " PlayerY2: " .. PlayerY2) end
		
		--Flip sprite if facing right
		local FacingTemp = Facing2
		if FacingTemp == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
--		if TempVar2 == 0 then ConsoleForText:print("MapX: " .. MapX2 .. " PlayerXCamera2: " .. PlayerXCamera2) end
	--	if TempVar2 == 0 then ConsoleForText:print("MapY: " .. MapY2 .. " PlayerXCamera2: " .. PlayerYCamera2) end
		if not ((FinalMapX > MaxX or FinalMapX < MinX) or (FinalMapY > MaxY or FinalMapY < MinY)) then 
			
			if Player2Vis == 1 then
		--		if TempVar2 == 0 then ConsoleForText:print("EXTRA 1: " .. Player2Extra1) end
				--Bikes need different vars
				if Player2Extra1 >= 17 and Player2Extra1 <= 32 then
				FinalMapX = FinalMapX - 8
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 2592)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
				--Same with surf
				elseif Player2Extra1 >= 33 and Player2Extra1 <= 40 then
				--Sitting char
				if Player2AnimationFrame2 == 1 and Player2Extra1 <= 36 then FinalMapY = FinalMapY + 1 end
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2592)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				--Surfing char
				if Player2AnimationFrame2 == 1 and Player2Extra1 <= 36 then FinalMapY = FinalMapY - 1 end
				FinalMapX = FinalMapX - 8
				FinalMapY = FinalMapY + 8
				PlayerYAddress = Player1Address + 8
				PlayerXAddress = PlayerYAddress + 2
				PlayerFaceAddress = PlayerYAddress + 3
				PlayerSpriteAddress = PlayerYAddress + 1
				PlayerExtra1Address = PlayerYAddress + 4
				PlayerExtra2Address = PlayerYAddress + 5
				PlayerExtra3Address = PlayerYAddress + 6
				PlayerExtra4Address = PlayerYAddress + 7
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 2610)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				else
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2592)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
				end
			--Remove sprite
			else
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
			end
		--Remove sprite
		else
				emu:write8(PlayerYAddress, 160)
				emu:write8(PlayerXAddress, 48)
				emu:write8(PlayerFaceAddress, 1)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
		end
end
function ErasePlayer2()
		local u32 PlayerYAddress = 0
		local u32 PlayerXAddress = 0
		local u32 PlayerFaceAddress = 0
		local u32 PlayerSpriteAddress = 0
		local u32 PlayerExtra1Address = 0
		local u32 PlayerExtra2Address = 0
		local u32 PlayerExtra3Address = 0
		local u32 PlayerExtra4Address = 0
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			Player1Address = 50345184
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		elseif GameID == "BPG1" or GameID == "BPG2" then
			--Addresses for Leafgreen
			Player1Address = 50345184
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		end
				emu:write8(PlayerYAddress, 160)
				emu:write8(PlayerXAddress, 48)
				emu:write8(PlayerFaceAddress, 1)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
					--Surfing char
					PlayerYAddress = Player1Address + 8
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, 160)
					emu:write8(PlayerXAddress, 48)
					emu:write8(PlayerFaceAddress, 1)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
end
function DrawPlayer3()
		if GameID == "BPRE" then
			--Addresses for Firered
			Player1Address = 50345200
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		end
		
		--X and Y vars
		local FinalMapX = MapX3 * 16 + PlayerXCamera
		local FinalMapY = MapY3 * 16 + PlayerYCamera
		
		
		--Freeze position of player character until after animation
		if PlayerXCamera == 0 then PlayerX3 = PlayerMapX * 16 end
		if PlayerYCamera == 0 then PlayerY3 = PlayerMapY * 16 end
		--Screen size (take into account movement)
		local MinX = PlayerMapX - 7
		local MaxX = PlayerMapX + 7
		local MinY = PlayerMapY - 5
		local MaxY = PlayerMapY + 5
		NewMapX3Pos = Math.floor(NewMapX3Pos)
		NewMapY3Pos = Math.floor(NewMapY3Pos)
		FinalMapX = FinalMapX + NewMapX3Pos - PlayerX3 + 112
		FinalMapY = FinalMapY + NewMapY3Pos - PlayerY3 + 56
		
		--Flip sprite if facing right
		local FacingTemp = Facing3
		if FacingTemp == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
		
	--	ConsoleForText:print("MinX" .. MinX .. " " .. MinY .. " " .. MaxX .. " " .. MaxY .. "Player 2 var: " .. FinalMapX .. " " .. FinalMapY .. " " .. PlayerX .. " " .. PlayerY .. " " .. PlayerXCamera .. " " .. PlayerYCamera .. " " .. NewMapX2Pos .. " " .. NewMapY2Pos)
	--	ConsoleForText:print("Drawing Player 2. X: " .. FinalMapX .. " Y: " .. FinalMapY .. " Player2X: " .. PlayerX2)
		if not ((MapX3 > MaxX or MapX3 < MinX) or (MapY3 > MaxY or MapY3 < MinY)) then 
		
			if Player3Vis == 1 then
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2624)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
			--Remove sprite
			else
					emu:write8(PlayerXAddress, 160)
					emu:write8(PlayerYAddress, 48)
					emu:write8(PlayerFaceAddress, 0)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
			end
		--Remove sprite
		else
				emu:write8(PlayerXAddress, 160)
				emu:write8(PlayerYAddress, 48)
				emu:write8(PlayerFaceAddress, 0)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
		end
end
function DrawPlayer4()
		if GameID == "BPRE" then
			--Addresses for Firered
			Player1Address = 50345216
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		end
		
		--X and Y vars
		local FinalMapX = MapX4 * 16 + PlayerXCamera
		local FinalMapY = MapY4 * 16 + PlayerYCamera
		
		
		--Freeze position of player character until after animation
		if PlayerXCamera == 0 then PlayerX4 = PlayerMapX * 16 end
		if PlayerYCamera == 0 then PlayerY4 = PlayerMapY * 16 end
		--Screen size (take into account movement)
		local MinX = PlayerMapX - 7
		local MaxX = PlayerMapX + 7
		local MinY = PlayerMapY - 5
		local MaxY = PlayerMapY + 5
		NewMapX4Pos = Math.floor(NewMapX4Pos)
		NewMapY4Pos = Math.floor(NewMapY4Pos)
		FinalMapX = FinalMapX + NewMapX4Pos - PlayerX4 + 112
		FinalMapY = FinalMapY + NewMapY4Pos - PlayerY4 + 56
		
		--Flip sprite if facing right
		local FacingTemp = Facing4
		if FacingTemp == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
		
	--	ConsoleForText:print("MinX" .. MinX .. " " .. MinY .. " " .. MaxX .. " " .. MaxY .. "Player 2 var: " .. FinalMapX .. " " .. FinalMapY .. " " .. PlayerX .. " " .. PlayerY .. " " .. PlayerXCamera .. " " .. PlayerYCamera .. " " .. NewMapX2Pos .. " " .. NewMapY2Pos)
	--	ConsoleForText:print("Drawing Player 2. X: " .. FinalMapX .. " Y: " .. FinalMapY .. " Player2X: " .. PlayerX2)
		if not ((MapX4 > MaxX or MapX4 < MinX) or (MapY4 > MaxY or MapY4 < MinY)) then 
			
			if Player4Vis == 1 then
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2656)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
			--Remove sprite
			else
					emu:write8(PlayerXAddress, 160)
					emu:write8(PlayerYAddress, 48)
					emu:write8(PlayerFaceAddress, 0)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, 12)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
			end
		--Remove sprite
		else
				emu:write8(PlayerXAddress, 160)
				emu:write8(PlayerYAddress, 48)
				emu:write8(PlayerFaceAddress, 0)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 12)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 1)
		end
end





--Unique for server

function GetNewGame()
    ClearAllVar()
	if ConsoleForText == nil then
		ConsoleForText = console:createBuffer("GBA-PK SERVER")
	end
	ConsoleForText:clear()
	ConsoleForText:moveCursor(0,0)
	ConsoleForText:print("A new game has started")
	ConsoleForText:moveCursor(0,1)
	FFTimer2 = os.clock()
	GetGameVersion()
end

function shutdownGame()
    ClearAllVar()
	ConsoleForText:clear()
	ConsoleForText:moveCursor(0,0)
	ConsoleForText:print("The game was shutdown")
end

--Begin Networking

--Create Server

function CreateNetwork()
	if MasterClient ~= "h" then
		SocketMain:bind(nil, Port)
		SocketMain:listen()
		MasterClient = "h"
		ConsoleForText:moveCursor(0,3)
		ConsoleForText:print("Hosting game. Port forwarding may be required.")
		ConsoleForText:moveCursor(0,4)
		ConsoleForText:print("Searching for player...                                                ")
		ConsoleForText:moveCursor(0,15)
		ConsoleForText:print("Player 2: Disconnected                     ")
	else
		ConsoleForText:moveCursor(0,3)
		ConsoleForText:print("Hosting game. Port forwarding may be required.")
		if Player2ID ~= "None" then
			ConsoleForText:moveCursor(0,4)
			ConsoleForText:print("Player " .. Player2ID .. " has successfully connected.                                                             ")
			ConsoleForText:moveCursor(0,15)
			ConsoleForText:print("Player 2: Connected                      ")
		else
			ConsoleForText:moveCursor(0,4)
			ConsoleForText:print("Searching for player...                                                ")
			ConsoleForText:moveCursor(0,15)
			ConsoleForText:print("Player 2: Disconnected                     ")
		end
	end
--	if SocketMain.ERRORS == OK then
	--	ConsoleForText:moveCursor(0,16)
	--	ConsoleForText:print("Player 3: Disconnected")
	--	ConsoleForText:moveCursor(0,17)
	--	ConsoleForText:print("Player 4: Disconnected")
end
function SetPokemonData(PokeData)
	if string.len(EnemyPokemon[1]) < 250 then EnemyPokemon[1] = EnemyPokemon[1] .. PokeData
	elseif string.len(EnemyPokemon[2]) < 250 then EnemyPokemon[2] = EnemyPokemon[2] .. PokeData
	elseif string.len(EnemyPokemon[3]) < 250 then EnemyPokemon[3] = EnemyPokemon[3] .. PokeData
	elseif string.len(EnemyPokemon[4]) < 250 then EnemyPokemon[4] = EnemyPokemon[4] .. PokeData
	elseif string.len(EnemyPokemon[5]) < 250 then EnemyPokemon[5] = EnemyPokemon[5] .. PokeData
	elseif string.len(EnemyPokemon[6]) < 250 then EnemyPokemon[6] = EnemyPokemon[6] .. PokeData
	end
end
function ReceiveData(Clientell)
			if EnableScript == true then
			--Check if anybody wants to connect
				if (Clientell:hasdata()) then
				local ReadData = Clientell:receive(64)
			--	local StringLen = 0
					
				if ReadData ~= nil then
					--Encryption key
					ReceiveDataSmall[29] = 0
					ReceiveDataSmall[1] = string.sub(ReadData,1,4)
					ReceiveDataSmall[2] = string.sub(ReadData,5,8)
					ReceiveDataSmall[3] = tonumber(string.sub(ReadData,9,9))
					ReceiveDataSmall[4] = string.sub(ReadData,10,13)
					ReceiveDataSmall[29] = string.sub(ReadData,64,64)
					ReceiveDataSmall[29] = tonumber(ReceiveDataSmall[29])
			--		if ReceiveDataSmall[4] == "BATT" then ConsoleForText:print("Valid package! Contents: " .. ReadData) end
					if ReceiveDataSmall[3] == ReceiveDataSmall[29] and ReceiveDataSmall[4] == "SLNK" then
					--		ConsoleForText:print("RECEIVED DATA")
							ReceiveDataSmall[5] = string.sub(ReadData,14,23)
							ReceiveDataSmall[5] = tonumber(ReceiveDataSmall[5])
							if ReceiveDataSmall[5] ~= 0 then
								ReceiveDataSmall[5] = ReceiveDataSmall[5] - 1000000000
								ReceiveMultiplayerPackets(ReceiveDataSmall[5], Player2)
							end
					elseif ReceiveDataSmall[3] == ReceiveDataSmall[29] and ReceiveDataSmall[4] == "POKE" then
							if ReceiveDataSmall[3] == 2 then timeout1 = timeoutmax end
							local PokeTemp2 = string.sub(ReadData,14,63)
							SetPokemonData(PokeTemp2)
					elseif ReceiveDataSmall[3] == ReceiveDataSmall[29] and ReceiveDataSmall[4] == "TRAD" then
						EnemyTradeVars[1] = string.sub(ReadData,14,14)
						EnemyTradeVars[2] = string.sub(ReadData,15,15)
						EnemyTradeVars[3] = string.sub(ReadData,16,16)
						EnemyTradeVars[4] = string.sub(ReadData,17,17)
						EnemyTradeVars[5] = string.sub(ReadData,24,63)
						EnemyTradeVars[1] = tonumber(EnemyTradeVars[1])
						EnemyTradeVars[2] = tonumber(EnemyTradeVars[2])
						EnemyTradeVars[3] = tonumber(EnemyTradeVars[3])
						EnemyTradeVars[4] = tonumber(EnemyTradeVars[4])
					elseif ReceiveDataSmall[3] == ReceiveDataSmall[29] and ReceiveDataSmall[4] == "BATT" then
						EnemyBattleVars[1] = string.sub(ReadData,14,14)
						EnemyBattleVars[2] = string.sub(ReadData,15,15)
						EnemyBattleVars[3] = string.sub(ReadData,16,16)
						EnemyBattleVars[4] = string.sub(ReadData,17,17)
						EnemyBattleVars[5] = string.sub(ReadData,18,18)
						EnemyBattleVars[6] = string.sub(ReadData,19,19)
						EnemyBattleVars[7] = string.sub(ReadData,20,20)
						EnemyBattleVars[8] = string.sub(ReadData,21,21)
						EnemyBattleVars[9] = string.sub(ReadData,22,22)
						EnemyBattleVars[10] = string.sub(ReadData,23,23)
						EnemyBattleVars[1] = tonumber(EnemyBattleVars[1])
						EnemyBattleVars[2] = tonumber(EnemyBattleVars[2])
						EnemyBattleVars[3] = tonumber(EnemyBattleVars[3])
						EnemyBattleVars[4] = tonumber(EnemyBattleVars[4])
						EnemyBattleVars[5] = tonumber(EnemyBattleVars[5])
						EnemyBattleVars[6] = tonumber(EnemyBattleVars[6])
						EnemyBattleVars[7] = tonumber(EnemyBattleVars[7])
						EnemyBattleVars[8] = tonumber(EnemyBattleVars[8])
						EnemyBattleVars[9] = tonumber(EnemyBattleVars[9])
						EnemyBattleVars[10] = tonumber(EnemyBattleVars[10])
					
					elseif ReceiveDataSmall[3] == ReceiveDataSmall[29] then
								--Decryption for packet
							--Type of packet
							ReceiveDataSmall[4] = string.sub(ReadData,10,13)
							--Packet Temp 1
							ReceiveDataSmall[5] = string.sub(ReadData,14,14)
							--X Player 1
							ReceiveDataSmall[6] = string.sub(ReadData,15,16)
							--Y Player 1
							ReceiveDataSmall[7] = string.sub(ReadData,17,18)
							--Player 1 Vis
							ReceiveDataSmall[8] = string.sub(ReadData,19,19)
							ReceiveDataSmall[8] = tonumber(ReceiveDataSmall[8])
							--Player 2
							ReceiveDataSmall[9] = string.sub(ReadData,20,21)
							ReceiveDataSmall[10] = string.sub(ReadData,22,23)
							ReceiveDataSmall[11] = string.sub(ReadData,24,24)
							--Player 3
							ReceiveDataSmall[12] = string.sub(ReadData,25,26)
							ReceiveDataSmall[13] = string.sub(ReadData,27,28)
							ReceiveDataSmall[14] = string.sub(ReadData,29,29)
							--Player 4
							ReceiveDataSmall[15] = string.sub(ReadData,30,31)
							ReceiveDataSmall[16] = string.sub(ReadData,32,33)
							ReceiveDataSmall[17] = string.sub(ReadData,34,34)
							--Extra 1 and 2 for players 1-4
							ReceiveDataSmall[18] = string.sub(ReadData,35,36)
							ReceiveDataSmall[19] = string.sub(ReadData,37,38)
							ReceiveDataSmall[20] = string.sub(ReadData,39, 40)
							ReceiveDataSmall[21] = string.sub(ReadData,41,42)
							ReceiveDataSmall[22] = string.sub(ReadData,43,44)
							ReceiveDataSmall[23] = string.sub(ReadData,45,46)
							ReceiveDataSmall[24] = string.sub(ReadData,47,48)
							ReceiveDataSmall[25] = string.sub(ReadData,49,50)
							--Map ID
							ReceiveDataSmall[26] = string.sub(ReadData,50,56)
							--Prev Map ID
							ReceiveDataSmall[27] = string.sub(ReadData,57,62)
							--ConnectionType
							ReceiveDataSmall[28] = string.sub(ReadData,63,63)
						
						--Set connection type to var
							ReturnConnectionType = ReceiveDataSmall[4]
						
					--	ConsoleForText:print("Valid package! Contents: " .. ReadData)
				--	if ReceiveDataSmall[4] == "DTRA" then ConsoleForText:print("Locktype: " .. LockFromScript) end
						
						if ReceiveDataSmall[4] == "RPOK" and ReceiveDataSmall[3] == 2 then
							CreatePackettSpecial("POKE",Player2)
						end
						
						--If player 2 requests for a battle
						if ReceiveDataSmall[4] == "RBAT" and ReceiveDataSmall[3] == 20 then
							local TooBusyByte = emu:read8(50335644)
							if (TooBusyByte ~= 0 or LockFromScript ~= 0) then
								SendData("TBUS", Player2)
							else
								OtherPlayerHasCancelled = 0
								LockFromScript = 12
								Loadscript(10)
							end
						end
						
						--If player 2 requests for a trade
						if ReceiveDataSmall[4] == "RTRA" and ReceiveDataSmall[3] == 2 then
							local TooBusyByte = emu:read8(50335644)
							if (TooBusyByte ~= 0 or LockFromScript ~= 0) then
								SendData("TBUS", Player2)
							else
								OtherPlayerHasCancelled = 0
								LockFromScript = 13
								Loadscript(6)
							end
						end
						
						--If player 2 is too busy to battle
						if ReceiveDataSmall[4] == "TBUS" and ReceiveDataSmall[3] == 2 and LockFromScript == 4 then
						--	ConsoleForText:print("Other player is too busy to battle.")
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(20)
							else
								TextSpeedWait = 5
							end
						--If player 2 is too busy to trade
						elseif ReceiveDataSmall[4] == "TBUS" and ReceiveDataSmall[3] == 2 and LockFromScript == 5 then
						--	ConsoleForText:print("Other player is too busy to trade.")
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(21)
							else
								TextSpeedWait = 6
							end
						end
						
						--If player 2 cancels battle
						if ReceiveDataSmall[4] == "CBAT" and ReceiveDataSmall[3] == 2 then
					--		ConsoleForText:print("Other player has canceled battle.")
							OtherPlayerHasCancelled = 1
						end
						--If player 2 cancels trade
						if ReceiveDataSmall[4] == "CTRA" and ReceiveDataSmall[3] == 2 then
					--		ConsoleForText:print("Other player has canceled trade.")
							OtherPlayerHasCancelled = 2
						end
						
						--If player 2 accepts your battle request
						if ReceiveDataSmall[4] == "SBAT" and ReceiveDataSmall[3] == 2 and LockFromScript == 4 then
							SendData("RPOK", Player2)
							if Var8000[2] ~= 0 then
								LockFromScript = 8
								Loadscript(13)
							else
								TextSpeedWait = 1
							end
						end
						--If player 2 accepts your trade request
						if ReceiveDataSmall[4] == "STRA" and ReceiveDataSmall[3] == 2 and LockFromScript == 5 then
							SendData("RPOK", Player2)
							if Var8000[2] ~= 0 then
								LockFromScript = 9
								Loadscript(14)
							else
								TextSpeedWait = 2
							end
						end
						
						--If player 2 denies your battle request
						if ReceiveDataSmall[4] == "DBAT" and ReceiveDataSmall[3] == 2 and LockFromScript == 4 then
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(11)
							else
								TextSpeedWait = 3
							end
						end
						--If player 2 denies your trade request
						if ReceiveDataSmall[4] == "DTRA" and ReceiveDataSmall[3] == 2 and LockFromScript == 5 then
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(7)
							else
								TextSpeedWait = 4
							end
						end
						
						--If player 2 refuses trade offer
						if ReceiveDataSmall[4] == "ROFF" and ReceiveDataSmall[3] == 2 and LockFromScript == 9 then
							OtherPlayerHasCancelled = 3
						end
						
						
						--GPOS
						if ReceiveDataSmall[4] == "GPOS" then
				--			if ReceiveDataSmall[3] == 1 then
				--				MapX = tonumber(ReceiveDataSmall[6])
				--				MapY = tonumber(ReceiveDataSmall[7])
				--				Facing = tonumber(ReceiveDataSmall[8])
				--				PlayerExtra1 = tonumber(Player1ExtraTemp)
				--				Player1Vis = tonumber(Player1VisibleTemp)
				--			end
							if Player2ID ~= "None" and ReceiveDataSmall[3] == 2 then
								timeout1 = timeoutmax
								ReceiveDataSmall[26] = tonumber(ReceiveDataSmall[26])
								Player2ID = ReceiveDataSmall[2]
								if MapID2 ~= ReceiveDataSmall[26] then
									NewMap2 = 1
									MapStartX2 = tonumber(ReceiveDataSmall[9])
									MapStartY2 = tonumber(ReceiveDataSmall[10])
									if MapStartX2 > 9 then MapStartX2 = MapStartX2 - 10 end
									if MapStartY2 > 9 then MapStartY2 = MapStartY2 - 10 end
									MapID2 = ReceiveDataSmall[26]
						--			ConsoleForText:print("MapIDP2: " .. MapID2 .. " MapIDP2Prev: " .. ReceiveDataSmall[27])
								end
								if MapID2 == PlayerMapID then
									MapX2Prev = tonumber(ReceiveDataSmall[9])
									MapY2Prev = tonumber(ReceiveDataSmall[10])
									if MapX2Prev > 9 then MapX2Prev = MapX2Prev - 10 end
									if MapY2Prev > 9 then MapY2Prev = MapY2Prev - 10 end
								end
								NewMapX2 = tonumber(ReceiveDataSmall[9])
								NewMapY2 = tonumber(ReceiveDataSmall[10])
						--		ConsoleForText:print("MapX: " .. NewMapX2 .. " MapY: " .. NewMapY2)
						--		Facing2 = tonumber(ReceiveDataSmall[11])
								Player2Extra1 = tonumber(ReceiveDataSmall[20])
								Player2Extra2 = tonumber(ReceiveDataSmall[21])
					--			ConsoleForText:print("Player2Extra2: " .. ReceiveDataSmall[21])
								FixPositionPlayer2()
								NewMapConnect2Prev = tonumber(ReceiveDataSmall[27])
								NewMapConnect2 = tonumber(ReceiveDataSmall[28])
							end
							if Player3ID ~= "None" and ReceiveDataSmall[3] == 3 then
							end
							if Player4ID ~= "None" and ReceiveDataSmall[3] == 4 then
							end
						end
						--TIME
			--			if ReceiveDataSmall[4] == "TIME" then
			--				if PlayerTempVar1 == 2 then
			--					timeout1 = 5
			--				elseif PlayerTempVar1 == 3 then
			--					timeout2 = 5
			--				elseif PlayerTempVar1 == 4 then
			--					timeout3 = 5
			--				end
			--			end
						
						
						--If nickname doesn't already exist on server and request to join
						if ReceiveDataSmall[4] == "JOIN" then
						
						--	if (ReceiveDataSmall[2] ~= None) then if (ReceiveDataSmall[2] ~= Player2ID and ReceiveDataSmall[2] ~= Player3ID  and ReceiveDataSmall[2] ~= Player4ID) then
							if (ReceiveDataSmall[2] ~= "None") then
								if (ReceiveDataSmall[2] ~= Player2ID) then
									ConsoleForText:moveCursor(0,4)
									ConsoleForText:print("Player " .. ReceiveDataSmall[2] .. " has successfully connected.                                                             ")
									if Connected == 0 then Connected = 1 end
									if Player2ID == "None" then
											ConsoleForText:moveCursor(0,15)
											ConsoleForText:print("Player 2: Connected                      ")
											Player2ID = ReceiveDataSmall[2]
											console:log("Player " .. Player2ID .. " has successfully connected")
											Player2 = Clientell
											Player2Vis = 1
											MapX2Prev = tonumber(ReceiveDataSmall[6])
											MapY2Prev = tonumber(ReceiveDataSmall[7])
											MapX2 = tonumber(ReceiveDataSmall[6])
											MapY2 = tonumber(ReceiveDataSmall[7])
											NewMapX2 = tonumber(ReceiveDataSmall[6])
											NewMapY2 = tonumber(ReceiveDataSmall[7])
											SendData("NewPlayer2", Player2)
											timeout1 = timeoutmax
							--4 Player Support in the future, too unstable now and need to add many more things first
							--		elseif Player3ID == "None" then
							--				Player3ID = ReceiveDataSmall[2]
							--				Player3 = Clientell
							--				Player3Vis = 1
							--				SendData("NewPlayer3", Player3)
							--				timeout2 = timeoutmax
							--		elseif Player4ID == "None" then
							--				Player4ID = ReceiveDataSmall[2]
							--				Player4 = Clientell
							--				Player4Vis = 1
							--				SendData("NewPlayer4", Player4)
							--				timeout3 = timeoutmax
									else
										ConsoleForText:moveCursor(0,4)
										ConsoleForText:print("A player is unable to join due to capacity limit.                ")
									--	SendData("DENY", Clientell)
									end
								else
									ConsoleForText:moveCursor(0,4)
									ConsoleForText:print("A player that is already in the game is trying to join!                ")
								end
							
							end
				--	else
				--		ConsoleForText:print("INVALID PACKAGE: " .. ReadData)
					end
				end
			end
		end
	end
end

function CreatePackettSpecial(RequestTemp, Socket2, OptionalData)
	if RequestTemp == "POKE" then
		GetPokemonTeam()
		local PokeTemp
	--	local Filler = "FFFFFFFFFFFFFFFFFFFF"
		for j = 1, 6 do
			PokeTemp = string.sub(Pokemon[j],1,50)
			Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. PokeTemp .. PlayerID
			Socket2:send(Packett)
		--	ConsoleForText:print("Packett: " .. Packett)
			PokeTemp = string.sub(Pokemon[j],51,100)
			Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. PokeTemp .. PlayerID
			Socket2:send(Packett)
			PokeTemp = string.sub(Pokemon[j],101,150)
			Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. PokeTemp .. PlayerID
			Socket2:send(Packett)
			PokeTemp = string.sub(Pokemon[j],151,200)
			Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. PokeTemp .. PlayerID
			Socket2:send(Packett)
			PokeTemp = string.sub(Pokemon[j],201,250)
			Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. PokeTemp .. PlayerID
			Socket2:send(Packett)
		--		ConsoleForText:print("Packett: " .. Packett)
		end
	elseif RequestTemp == "TRAD" then
		local FillerSend = "100000"
		Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. TradeVars[1] .. TradeVars[2] .. TradeVars[3] .. TradeVars[4] .. FillerSend .. TradeVars[5] .. PlayerID
		Socket2:send(Packett)
	elseif RequestTemp == "BATT" then
		local FillerSend = "1000000000000000000000000000000000000000"
		Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. BattleVars[1] .. BattleVars[2] .. BattleVars[3] .. BattleVars[4] .. BattleVars[5] .. BattleVars[6] .. BattleVars[7] .. BattleVars[8] .. BattleVars[9] .. BattleVars[10] .. FillerSend .. PlayerID
	--	ConsoleForText:print("Packett: " .. Packett)
		Socket2:send(Packett)
	elseif RequestTemp == "SLNK" then
		OptionalData = OptionalData or 0
		local Filler = "1000000000000000000000000000000000000000"
		local SizeAct = OptionalData + 1000000000
 --		SizeAct = tostring(SizeAct)
--		SizeAct = string.format("%.0f",SizeAct)
		Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. SizeAct .. Filler .. PlayerID
--		ConsoleForText:print("Packett: " .. Packett)
		Socket2:send(Packett)
	end
end
--Send Data to clients
function CreatePackett(RequestTemp, PackettTemp)
	PlayerExtra1 = PlayerExtra1 + 10
	PlayerExtra2 = PlayerExtra2 + 10
	Player2Extra1 = Player2Extra1 + 10
	Player2Extra2 = Player2Extra2 + 10
	Player3Extra1 = Player3Extra1 + 10
	Player3Extra2 = Player3Extra2 + 10
	Player4Extra1 = Player4Extra1 + 10
	Player4Extra2 = Player4Extra2 + 10
	if MapX < 90 then MapX = MapX + 10 end
	if MapX2 < 90 then MapX2 = MapX2 + 10 end
	if MapX3 < 90 then MapX3 = MapX3 + 10 end
	if MapX4 < 90 then MapX4 = MapX4 + 10 end
	if MapY < 90 then MapY = MapY + 10 end
	if MapY2 < 90 then MapY2 = MapY2 + 10 end
	if MapY3 < 90 then MapY3 = MapY3 + 10 end
	if MapY4 < 90 then MapY4 = MapY4 + 10 end
	Facing = 5
	Facing2 = 5
	Facing3 = 5
	Facing4 = 5
	local Player1VisTemp = 0
	local Player2VisTemp = 0
	local Player3VisTemp = 0
	local Player4VisTemp = 0
	if RequestTemp == "SPO2" then
		Player1VisTemp = string.sub(PackettTemp,1,1)
		Player2VisTemp = string.sub(PackettTemp,2,2)
		Player3VisTemp = string.sub(PackettTemp,3,3)
		Player4VisTemp = string.sub(PackettTemp,4,4)
		PackettTemp = "100"
		RequestTemp = "SPOS"
	--	ConsoleForText:print("SPO2 RECEIVED! Sending to " .. TempVar1 .. " Map 1: " .. MapID .. " Map 2: " .. MapID2 .. " Vars: " .. PackettTemp )
	end
	Packett =  GameID .. Nickname .. PlayerID .. RequestTemp .. PackettTemp .. NewMapConnect .. MapX .. MapY .. Facing .. Player1VisTemp .. MapX2 .. MapY2 .. Facing2 .. Player2VisTemp .. MapX3 .. MapY3 .. Facing3 .. Player3VisTemp .. MapX4 .. MapY4 .. Facing4 .. Player4VisTemp .. PlayerExtra1 .. PlayerExtra2 .. Player2Extra1 .. Player2Extra2 .. Player3Extra1 .. Player3Extra2 .. Player4Extra1 .. Player4Extra2 .. PlayerMapID .. PlayerID
	FixAllPositions()
end

function SendData(DataType, Socket)
	--If you have made a server
	if (DataType == "NewPlayer2") then
	--	ConsoleForText:print("Request accepted!")
		CreatePackett("STRT", "200")
		Socket:send(Packett)
	elseif (DataType == "NewPlayer3") then
	--	ConsoleForText:print("Request accepted!")
		CreatePackett("STRT", "300")
		Socket:send(Packett)
	elseif (DataType == "NewPlayer4") then
	--	ConsoleForText:print("Request accepted!")
		CreatePackett("STRT", "400")
		Socket:send(Packett)
	elseif (DataType == "DENY") then
		CreatePackett("DENY", "100")
		Socket:send(Packett)
	elseif (DataType == "KICK") then
		CreatePackett("KICK", "100")
		Socket:send(Packett)
	elseif (DataType == "GPos") then
		CreatePackett("GPOS", "100")
		Socket:send(Packett)
	elseif (DataType == "SPos") then
		local Player1Visibility = 0
		local Player2Visibility = 0
		local Player3Visibility = 0
		local Player4Visibility = 0
	--Hide players that aren't on the same map
		MapID2 = tonumber(MapID2)
		MapID3 = tonumber(MapID3)
		MapID4 = tonumber(MapID4)
		if TempVar1 == "Player 2" then
			if MapID2 ~= 0 then
				if MapID2 == PlayerMapID then Player1Visibility = 1 end
				if MapID2 == MapID2 then Player2Visibility = 1 end
				if MapID2 == MapID3 then Player3Visibility = 1 end
				if MapID2 == MapID4 then Player4Visibility = 1 end
			else
				Player1Visibility = 0
				Player2Visibility = 0
				Player3Visibility = 0
				Player4Visibility = 0
			end
			Player1Visibility = Player1Visibility .. Player2Visibility .. Player3Visibility .. Player4Visibility
			CreatePackett("SPO2", Player1Visibility )
		elseif TempVar1 == "Player 3" then
			if MapID3 ~= 0 then
				if MapID3 == PlayerMapID then Player1Visibility = 1 end
				if MapID3 == MapID2 then Player2Visibility = 1 end
				if MapID3 == MapID3 then Player3Visibility = 1 end
				if MapID3 == MapID4 then Player4Visibility = 1 end
				else
				Player1Visibility = 0
				Player2Visibility = 0
				Player3Visibility = 0
				Player4Visibility = 0
			end
			Player1Visibility = Player1Visibility .. Player2Visibility .. Player3Visibility .. Player4Visibility
			CreatePackett("SPO2", Player1Visibility )
		elseif TempVar1 == "Player 4" then
			if MapID4 ~= 0 then
				if MapID4 == PlayerMapID then Player1Visibility = 1 end
				if MapID4 == MapID2 then Player2Visibility = 1 end
				if MapID4 == MapID3 then Player3Visibility = 1 end
				if MapID4 == MapID4 then Player4Visibility = 1 end
				else
				Player1Visibility = 0
				Player2Visibility = 0
				Player3Visibility = 0
				Player4Visibility = 0
			end
			Player1Visibility = Player1Visibility .. Player2Visibility .. Player3Visibility .. Player4Visibility
			CreatePackett("SPO2", Player1Visibility )
		else
			CreatePackett("SPOS", "100")
		end
		--Dummy packett
	--	CreatePackett("DMMY", "1000")
		Socket:send(Packett)
	elseif (DataType == "Request") then
		CreatePackett("JOIN", "100")
		Socket:send(Packett)
	elseif (DataType == "Hide") then
		CreatePackett("HIDE", "100")
		Socket:send(Packett)
	elseif (DataType == "POKE") then
		CreatePackettSpecial("POKE",Socket)
	elseif (DataType == "RPOK") then
		local whiletempmax = 100000
		EnemyPokemon[1] = ""
		EnemyPokemon[2] = ""
		EnemyPokemon[3] = ""
		EnemyPokemon[4] = ""
		EnemyPokemon[5] = ""
		EnemyPokemon[6] = ""
		CreatePackett("RPOK", "100")
		Socket:send(Packett)
		while (string.len(EnemyPokemon[6]) < 100 and whiletempmax > 0) do
			ReceiveData(Socket)
			ReceiveData(Socket)
			ReceiveData(Socket)
			ReceiveData(Socket)
			ReceiveData(Socket)
		whiletempmax = whiletempmax - 1
		end
	elseif (DataType == "RTRA") then
		CreatePackett("RTRA", "100")
		Socket:send(Packett)
	elseif (DataType == "RBAT") then
		CreatePackett("RBAT", "100")
		Socket:send(Packett)
	elseif (DataType == "STRA") then
		CreatePackett("STRA", "100")
		Socket:send(Packett)
	elseif (DataType == "SBAT") then
		CreatePackett("SBAT", "100")
		Socket:send(Packett)
	elseif (DataType == "DTRA") then
		CreatePackett("DTRA", "100")
		Socket:send(Packett)
	elseif (DataType == "DBAT") then
		CreatePackett("DBAT", "100")
		Socket:send(Packett)
	elseif (DataType == "CTRA") then
		CreatePackett("CTRA", "100")
		Socket:send(Packett)
	elseif (DataType == "CBAT") then
		CreatePackett("CBAT", "100")
		Socket:send(Packett)
	elseif (DataType == "TBUS") then
		CreatePackett("TBUS", "100")
		Socket:send(Packett)
	elseif (DataType == "ROFF") then
		CreatePackett("ROFF", "100")
		Socket:send(Packett)
	elseif (DataType == "TRAD") then
		CreatePackettSpecial("TRAD")
	elseif (DataType == "BATT") then
		CreatePackettSpecial("BATT")
	end
end


function ConnectNetwork()
	--To prevent package overrunning, sending will be every 20 frames, unlike recieve, which is every frame
	--Send timer
	--Receive timer
	local ReceiveTimer = ScriptTime % 1
	
	--If you have made a server
	if (MasterClient == "h") then
		
		if ReceiveTimer == 0 then
		--Receive data
		local PlayerData = SocketMain:accept()
		if (PlayerData ~= nil) then ReceiveData(PlayerData) end
	--	ReceiveData(PlayerData)
		if Player2ID ~= "None" then ReceiveData(Player2) end
		if Player3ID ~= "None" then ReceiveData(Player3) end
		if Player4ID ~= "None" then ReceiveData(Player4) end
	end
		

		--Request and send positions from all players
		if SendTimer == 0 then 
		
		if timeout1 > 0 then timeout1 = timeout1 - 4 end
		if timeout2 > 0 then timeout2 = timeout2 - 4 end
		if timeout3 > 0 then timeout3 = timeout3 - 4 end
		if Player2ID ~= "None" then
			if timeout1 <= 0 then
				console:log("Player " .. Player2ID .. " has timed out")
				ConsoleForText:moveCursor(0,4)
				ConsoleForText:print("Player " .. Player2ID .. " has been disconnected due to timeout.                              ")
				ConsoleForText:moveCursor(0,15)
				ConsoleForText:print("Player 2: Disconnected           ")
				Player2ID = "None"
				Player2:close()
			end
		end
		if Player3ID ~= "None" then
			if timeout2 <= 0 then
				ConsoleForText:moveCursor(0,16)
				ConsoleForText:print("Player 3: Disconnected")
				ConsoleForText:moveCursor(0,4)
				ConsoleForText:print("Player 3 has been disconnected due to timeout")
				Player3ID = "None"
			end
		end
		if Player4ID ~= "None" then
			if timeout3 <= 0 then
				ConsoleForText:moveCursor(0,17)
				ConsoleForText:print("Player 4: Disconnected")
				ConsoleForText:moveCursor(0,4)
				ConsoleForText:print("Player 4 has been disconnected due to timeout")
				Player4ID = "None"
			end
		end
		
		if Player2ID ~= "None" then SendData("GPos", Player2) end
		if Player3ID ~= "None" then SendData("GPos", Player3) end
		if Player4ID ~= "None" then SendData("GPos", Player4) end
		--Hide players after GPOS
		TempVar1 = "Player 2"
		if Player2ID ~= "None" then SendData("SPos", Player2) end
		TempVar1 = "Player 3"
		if Player3ID ~= "None" then SendData("SPos", Player3) end
		TempVar1 = "Player 4"
		if Player4ID ~= "None" then SendData("SPos", Player4) end
		end
		
	end
end

--End Networking

function RandomizeNickname()
	local res = ""
	for i = 1, 4 do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

function Interact()
	local Keypress = emu:getKeys()
	local TalkingDirX = 0
	local TalkingDirY = 0
	local ScriptAddressTemp = 0
	local ScriptAddressTemp1 = 0
	local TooBusyByte = emu:read8(50335644)
	local AddressGet = ""
		
		--Hide n seek
		if LockFromScript == 1 then
			if Var8000[5] == 2 then
		--		ConsoleForText:print("Hide n' Seek selected")
				LockFromScript = 0
				Loadscript(3)
				Keypressholding = 1
				Keypress = 1
			
			elseif Var8000[5] == 1 then
		--		ConsoleForText:print("Hide n' Seek not selected")
				LockFromScript = 0
				Loadscript(3)
				Keypressholding = 1
				Keypress = 1
			end
		--Interaction Multi-choice
		elseif LockFromScript == 2 then
			if Var8000[1] ~= Var8000[14] then
				if Var8000[1] == 1 then
		--			ConsoleForText:print("Battle selected")
					FixAddress()
		--			LockFromScript = 4
		--			Loadscript(4)
					LockFromScript = 7
					Loadscript(3)
					Keypressholding = 1
					Keypress = 1
		--			SendData("RBAT", Player2)
				
				elseif Var8000[1] == 2 then
		--			ConsoleForText:print("Trade selected")
					FixAddress()
					LockFromScript = 5
					Loadscript(4)
					Keypressholding = 1
					Keypress = 1
					SendData("RTRA", Player2)
				
				elseif Var8000[1] == 3 then
		--			ConsoleForText:print("Card selected")
					FixAddress()
					LockFromScript = 6
					Loadscript(3)
					Keypressholding = 1
					Keypress = 1
				
				elseif Var8000[1] ~= 0 then
		--			ConsoleForText:print("Exit selected")
					FixAddress()
					LockFromScript = 0
					Keypressholding = 1
					Keypress = 1
				end
			end
		end
	if Keypress ~= 0 then
		if Keypress == 1 or Keypress == 65 or Keypress == 129 or Keypress == 33 or Keypress == 17 then
	--		ConsoleForText:print("Pressed A")
	
			--SCRIPTS. LOCK AND PREVENT SPAM PRESS. 
			if LockFromScript == 0 and Keypressholding == 0 and TooBusyByte == 0 then
				--HIDE N SEEK AT DESK IN ROOM
				if MasterClient == "h" and ActualPlayerDirection == 3 and MapX == 9 and MapY == 9 and PlayerMapID == 100260 then
				--Server config through bedroom drawer
					--For temp ram to load up script in 145227776 - 08A80000
					--8004 is the temp var to get yes or no
					Loadscript(1)
					LockFromScript = 1
				end
				--Interact with player 2
				
				if PlayerID ~= 2 and Player2ID ~= "None" then
					TalkingDirX = PlayerMapX - MapX2
					TalkingDirY = PlayerMapY - MapY2
					if ActualPlayerDirection == 1 and TalkingDirX == 1 and TalkingDirY == 0 then
				--		ConsoleForText:print("Player2 Left")
						
					elseif ActualPlayerDirection == 2 and TalkingDirX == -1 and TalkingDirY == 0 then
				--		ConsoleForText:print("Player2 Right")
					elseif ActualPlayerDirection == 3 and TalkingDirY == 1 and TalkingDirX == 0 then
				--		ConsoleForText:print("Player2 Up")
					elseif ActualPlayerDirection == 4 and TalkingDirY == -1 and TalkingDirX == 0 then
				--		ConsoleForText:print("Player2 Down")
					end
					if (ActualPlayerDirection == 1 and TalkingDirX == 1 and TalkingDirY == 0) or (ActualPlayerDirection == 2 and TalkingDirX == -1 and TalkingDirY == 0) or (ActualPlayerDirection == 3 and TalkingDirX == 0 and TalkingDirY == 1) or (ActualPlayerDirection == 4 and TalkingDirX == 0 and TalkingDirY == -1) then
					
				--		ConsoleForText:print("Player2 Any direction")
						emu:write16(Var8000Adr[1], 0) 
						emu:write16(Var8000Adr[2], 0) 
						emu:write16(Var8000Adr[14], 0)
						BufferString = Player2ID
						Loadscript(2)
						LockFromScript = 2
					end
				end
			end
			Keypressholding = 1
		elseif Keypress == 2 then
			if LockFromScript == 4 and Keypressholding == 0 and Var8000[2] ~= 0 then
				--Cancel battle request
				Loadscript(15)
				SendData("CBAT",Player2)
				LockFromScript = 0
			elseif LockFromScript == 5 and Keypressholding == 0 and Var8000[2] ~= 0 then
				--Cancel trade request
				Loadscript(16)
					SendData("CTRA",Player2)
				LockFromScript = 0
				TradeVars[1] = 0
				TradeVars[2] = 0
				TradeVars[3] = 0
				OtherPlayerHasCancelled = 0
			elseif LockFromScript == 9 and (TradeVars[1] == 2 or TradeVars[1] == 4) and Keypressholding == 0 and Var8000[2] ~= 0 then
				--Cancel trade request
				Loadscript(16)
				SendData("CTRA",Player2)
				LockFromScript = 0
				TradeVars[1] = 0
				TradeVars[2] = 0
				TradeVars[3] = 0
				OtherPlayerHasCancelled = 0
			end
			Keypressholding = 1
		elseif Keypress == 4 then
	--		GetPokemonTeam()
	--		SetEnemyPokemonTeam()
	--		ConsoleForText:print("Pressed Select")
		elseif Keypress == 8 then
	--		ConsoleForText:print("Pressed Start")
		elseif Keypress == 16 then
	--		ConsoleForText:print("Pressed Right")
		elseif Keypress == 32 then
	--		ConsoleForText:print("Pressed Left")
		elseif Keypress == 64 then
	--		ConsoleForText:print("Pressed Up")
		elseif Keypress == 128 then
	--		ConsoleForText:print("Pressed Down")
		elseif Keypress == 256 then
		--	if LockFromScript == 0 and Keypressholding == 0 then
		--	ConsoleForText:print("Pressed R-Trigger")
			--	ApplyMovement(0)
		--		emu:write16(Var8001Adr, 0) 
			--	BufferString = Player2ID
		--		Loadscript(12)
		--		LockFromScript = 5
		--		local TestString = ReadBuffers(33692880, 4)
		--		WriteBuffers(33692912, TestString, 4)
			--	ConsoleForText:print("String: " .. TestString)
			
		--		SendData("RPOK",Player2)
		--		if EnemyPokemon[6] ~= 0 then
		--			SetEnemyPokemonTeam(0,1)
		--		end
				
			--	LockFromScript = 8
		--		SendMultiplayerPackets(0,256,Player2)
		--	Loadscript(17)
		--	end
			Keypressholding = 1
		elseif Keypress == 512 then
	--		ConsoleForText:print("Pressed L-Trigger")
	--		Loadscript(22)
		end
	else
		Keypressholding = 0
	end
end

function mainLoop()
	FFTimer = os.clock() - FFTimer2
	FFTimer = math.floor(FFTimer)
	ScriptTime = ScriptTime + 1
	SendTimer = ScriptTime % ScriptTimeFrame
	
	if FFTimer > FramesPS then
		--This is our framerate
		local ScriptTimeSpeed = ScriptTime - ScriptTimePrev
		ScriptTimePrev = ScriptTime
		
		if ScriptTimeSpeed < 100 then
			ScriptTimeFrame = 4
		elseif ScriptTimeSpeed < 200 then
			ScriptTimeFrame = 10
		elseif ScriptTimeSpeed < 300 then
			ScriptTimeFrame = 16
		elseif ScriptTimeSpeed < 400 then
			ScriptTimeFrame = 22
		elseif ScriptTimeSpeed < 500 then
			ScriptTimeFrame = 28
		elseif ScriptTimeSpeed < 600 then
			ScriptTimeFrame = 34
		elseif ScriptTimeSpeed < 700 then
			ScriptTimeFrame = 40
		elseif ScriptTimeSpeed < 800 then
			ScriptTimeFrame = 46
		elseif ScriptTimeSpeed < 900 then
			ScriptTimeFrame = 52
		elseif ScriptTimeSpeed >= 900 then
			ScriptTimeFrame = 60
		end
	end
	
	FramesPS = FFTimer
	if initialized == 0 and EnableScript == true then
		ROMCARD = emu.memory.cart0
		initialized = 1
		GetPosition()
	--	Loadscript(0)
		if Nickname == "" then
			Nickname = RandomizeNickname()
		end
		ConsoleForText:moveCursor(0,2)
		ConsoleForText:print("Nickname is now " .. Nickname)
			
		CreateNetwork()
		ConsoleForText:moveCursor(0,4)
	elseif EnableScript == true then
			--Debugging
			TempVar2 = ScriptTime % DebugTime2
			local TempVarTimer = ScriptTime % DebugTime
			if TempVarTimer == 0 then
			end
			--Update once every frame
			TempVarTimer = ScriptTime % DebugTime3
			if TempVarTimer == 0 then
				GetPosition()
				ConnectNetwork()
			end
			--Create a network if not made every half
			TempVarTimer = ScriptTime % DebugTime2
			if TempVarTimer == 0 then
				if MasterClient == "a" then
					ConsoleForText:moveCursor(0,3)
					CreateNetwork()
					ConsoleForText:moveCursor(0,4)
				end
			end
							--VARS--
		if GameID == "BPR1" or GameID == "BPR2" then
			Startvaraddress = 33779896
		elseif GameID == "BPG1" or GameID == "BPG2" then
			Startvaraddress = 33779896
		end
		Var8000Adr[1] = Startvaraddress
		Var8000Adr[2] = Startvaraddress + 2
		Var8000Adr[3] = Startvaraddress + 4
		Var8000Adr[4] = Startvaraddress + 6
		Var8000Adr[5] = Startvaraddress + 8
		Var8000Adr[6] = Startvaraddress + 10
		Var8000Adr[14] = Startvaraddress + 26
		Var8000[1] = emu:read16(Var8000Adr[1])
		Var8000[2] = emu:read16(Var8000Adr[2])
		Var8000[3] = emu:read16(Var8000Adr[3])
		Var8000[4] = emu:read16(Var8000Adr[4])
		Var8000[5] = emu:read16(Var8000Adr[5])
		Var8000[6] = emu:read16(Var8000Adr[6])
		Var8000[14] = emu:read16(Var8000Adr[14])
		Var8000[1] = tonumber(Var8000[1])
		Var8000[2] = tonumber(Var8000[2])
		Var8000[3] = tonumber(Var8000[3])
		Var8000[4] = tonumber(Var8000[4])
		Var8000[5] = tonumber(Var8000[5])
		Var8000[6] = tonumber(Var8000[6])
		Var8000[14] = tonumber(Var8000[14])
			
						--BATTLE/TRADE--
			
		--	if TempVar2 == 0 then ConsoleForText:print("OtherPlayerCanceled: " .. OtherPlayerHasCancelled) end
			
			--Wait until other player accepts battle
			if LockFromScript == 4 then
				if Var8000[2] ~= 0 then
					if TextSpeedWait == 1 then
						TextSpeedWait = 0
						LockFromScript = 8
						Loadscript(13)
					elseif TextSpeedWait == 3 then
						TextSpeedWait = 0
						LockFromScript = 7
						Loadscript(11)
					elseif TextSpeedWait == 5 then
						TextSpeedWait = 0
						LockFromScript = 7
						Loadscript(20)
					end
				end
--				if SendTimer == 0 then SendData("RBAT") end
				
			--Wait until other player accepts trade
			elseif LockFromScript == 5 then
				if Var8000[2] ~= 0 then
					if TextSpeedWait == 2 then
						TextSpeedWait = 0
						LockFromScript = 9
						Loadscript(14)
					elseif TextSpeedWait == 4 then
						TextSpeedWait = 0
						LockFromScript = 7
						Loadscript(7)
					elseif TextSpeedWait == 6 then
						TextSpeedWait = 0
						LockFromScript = 7
						Loadscript(21)
					end
				end
				
			--Show card. Placeholder for now
			elseif LockFromScript == 6 then
				if Var8000[2] ~= 0 then
		--			ConsoleForText:print("Var 8001: " .. Var8000[2])
					LockFromScript = 0
				--	if SendTimer == 0 then SendData("RTRA") end
				end
				
			--Exit message
			elseif LockFromScript == 7 then
				if Var8000[2] ~= 0 then LockFromScript = 0 Keypressholding = 1 end
			
			--Battle script
			elseif LockFromScript == 8 then
			
				Battlescript()
			
			--Trade script
			elseif LockFromScript == 9 then
			
				Tradescript()
			
			
			--Player 2 has requested to battle
			elseif LockFromScript == 12 then
		--	if Var8000[2] ~= 0 then ConsoleForText:print("Var8001: " .. Var8000[2]) end
				if Var8000[2] == 2 then
					if OtherPlayerHasCancelled == 0 then
						SendData("RPOK", Player2)
						SendData("SBAT", Player2)
						LockFromScript = 8
						Loadscript(13)
					else
						OtherPlayerHasCancelled = 0
						LockFromScript = 7
						Loadscript(18)
					end
				elseif Var8000[2] == 1 then LockFromScript = 0 SendData("DBAT", Player2) Keypressholding = 1 end
				
			--Player 2 has requested to trade
			elseif LockFromScript == 13 then
		--	if Var8000[2] ~= 0 then ConsoleForText:print("Var8001: " .. Var8000[2]) end
				--If accept, then send that you accept
				if Var8000[2] == 2 then
					if OtherPlayerHasCancelled == 0 then
						SendData("RPOK", Player2)
						SendData("STRA", Player2)
						LockFromScript = 9
						Loadscript(14)
					else
						OtherPlayerHasCancelled = 0
						LockFromScript = 7
						Loadscript(19)
					end
				elseif Var8000[2] == 1 then LockFromScript = 0 SendData("DTRA", Player2) Keypressholding = 1 end
			end
	end
end

if not (emu == nil) then
	if ConsoleForText == nil then ConsoleForText = console:createBuffer("GBA-PK SERVER") end
	console:log("Started GBA-PK_Server.lua")
	ConsoleForText:clear()
	ConsoleForText:moveCursor(0,1)
	FFTimer2 = os.clock()
    GetGameVersion()
end

SocketMain:add("received", ReceiveData)
--Player2:add("received", Player2Network)
--Player3:add("received", Player3Network)
--Player4:add("received", Player4Network)
callbacks:add("reset", GetNewGame)
callbacks:add("shutdown", shutdownGame)
callbacks:add("frame", mainLoop)
callbacks:add("frame", DrawChars)


callbacks:add("keysRead", Interact)