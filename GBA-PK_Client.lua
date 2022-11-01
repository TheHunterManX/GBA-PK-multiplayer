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
local initialized = 0

--Internet Play
--local tcp = assert(socket.tcp())
local SocketMain = socket:tcp()
local Player2 = socket:tcp()
local Player3 = socket:tcp()
local Player4 = socket:tcp()
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

--Player 2
local Player2Visible = false
local MapID2 = 0
local MapX2 = 0
local MapY2 = 0
local MapStartX2 = 0
local MapStartY2 = 0
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
local ActualPlayerDirection = 0
local ActualPlayerDirectionPrev = 0


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
local u8 ActualPlayerExtra3 = 0
local u8 ActualPlayerExtra4 = 0
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

--Addresses
local u32 Player1Address = 0
local u32 Player2Address = 0
local u32 Player3Address = 0
local u32 Player4Address = 0
local u32 PlayerYAddress = 0
local u32 PlayerYAddress = 0
local u32 PlayerXAddress = 0
local u32 PlayerFaceAddress = 0
local u32 PlayerSpriteAddress = 0
local u32 PlayerExtra1Address = 0
local u32 PlayerExtra2Address = 0
local u32 PlayerExtra3Address = 0
local u32 PlayerExtra4Address = 0


local AnimatePlayerMoveX = 0
local AnimatePlayerMoveY = 0

local NewMapNewX = 0
local NewMapNewY = 0

			
local PlayerXCameraTemp = 0
local PlayerYCameraTemp = 0

local FFTimer = 0
local FFTimer2 = 0
local ScreenData = 0


					--Decryption for packet (unfortunately if I do not initialize it here it won't work)
					local GameCodeTemp = ""
					local NicknameTemp = ""
					local PlayerIDTemp = 0
					local ConnectionTypeTemp = ""
					local Connection1TempVar1 = 0
					local Connection1TempVar2 = 0
					local Connection1TempVar3 = 0
					local Connection1TempVar4 = 0
					local Player1XTemp = 0
					local Player1YTemp = 0
					local Player1FacingTemp = 0
					local Player1VisibleTemp = 0
					local Player2XTemp = 0
					local Player2YTemp = 0
					local Player2FacingTemp = 0
					local Player2VisibleTemp = 0
					local Player3XTemp = 0
					local Player3YTemp = 0
					local Player3FacingTemp = 0
					local Player3VisibleTemp = 0
					local Player4XTemp = 0
					local Player4YTemp = 0
					local Player4FacingTemp = 0
					local Player4VisibleTemp = 0
					local Player1ExtraTemp1 = 0
					local Player1ExtraTemp2 = 0
					local Player2ExtraTemp1 = 0
					local Player2ExtraTemp2 = 0
					local Player3ExtraTemp1 = 0
					local Player3ExtraTemp2 = 0
					local Player4ExtraTemp1 = 0
					local Player4ExtraTemp2 = 0
					local MapIDTemp = ""
					local ConfirmEncrypt = 0
					local MapIDConnection = 0
					
--Debug time is how long in frames each message should show. once every 300 frames, or 5 seconds, should be plenty
local DebugTime = 300
local DebugTime2 = 30
local DebugTime3 = 1
local TempVar1 = 0
local TempVar2 = 0
local TempVar3 = 0

function ClearAllVar()
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
	 PlayerID = 1
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
	 ActualPlayerExtra3 = 0
	 ActualPlayerExtra4 = 0
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
		console:createBuffer("Pokemon Firered detected. Script enabled.")
		EnableScript = true
		GameID = "BPRE"
		elseif (GameCode == "AGB-BPGE")
		then
			console:createBuffer("Pokemon Leafgreen detected. Script enabled.")
			EnableScript = true
			GameID = "BPGE"
		elseif (GameCode == "AGB-BPEE")
		then
			console:createBuffer("Pokemon Emerald detected. Script disabled.")
			EnableScript = true
			GameID = "BPEE"
		elseif (GameCode == "AGB-AXVE")
		then
			console:createBuffer("Pokemon Ruby detected. Script disabled.")
			EnableScript = true
			GameID = "AXVE"
		elseif (GameCode == "AGB-AXPE")
		then
			console:createBuffer("Pokemon Sapphire detected. Script disabled.")
			EnableScript = true
			GameID = "AXPE"
		else
		console:createBuffer("Unknown game. Script disabled.")
		EnableScript = false
	end
end

--To fit everything in 1 file, I must unfortunately clog this file with a lot of sprite data. Luckily, this does not lag the game. It is just hard to read.
--Also, if you are looking at this, then I am sorry. Truly      -TheHunterManX
function createChars(StartAddressNo, SpriteID, SpriteNo)
	--0 = Tile 120, 1 = Tile 126, etc...
	--Tile number 120 = Player1
	--Tile number 122 = Player2
	--Tile number 124 = Player3
	--Tile number 126 = Player4
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
	
	
	--Start address. 100743168 = 06013800 = 120th tile. can safely use 16.
	--Because the actual data doesn't start until 06013850, we will skip 50 hexbytes, or 80 decibytes
	local ActualAddress = 100743168 + (StartAddressNo * 512) + 80
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
		end
	end
end

function FixPositionPlayer1()
	--Fix values
	if NewMapX > 9 then NewMapX = NewMapX - 10 end
	if NewMapY > 9 then NewMapY = NewMapY - 10 end
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
	if NewMapX3 > 9 then NewMapX3 = NewMapX3 - 10 end
	if NewMapY3 > 9 then NewMapY3 = NewMapY3 - 10 end
	Player3Extra1 = Player3Extra1 - 10
	Player3Extra2 = Player3Extra2 - 10
end
function FixPositionPlayer4()
	--Fix values
	if NewMapX4 > 9 then NewMapX4 = NewMapX4 - 10 end
	if NewMapY4 > 9 then NewMapY4 = NewMapY4 - 10 end
	Player4Extra1 = Player4Extra1 - 10
	Player4Extra2 = Player4Extra2 - 10
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
		if GameID == "BPRE" then
			--Addresses for Firered
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		elseif GameID == "BPGE" then
			--Addresses for Leafgreen
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		end
		
			PlayerMapXMovePrev = PlayerMapXMove
			PlayerMapYMovePrev = PlayerMapYMove
			PlayerMapXMove = emu:read16(PlayerMapXMoveAddress)
			PlayerMapYMove = emu:read16(PlayerMapYMoveAddress)
			
		if ResetCamera == 1 then
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
				--		console:createBuffer("PLAYER MAP CHANGE! DIR: " .. ActualPlayerDirectionPrev)
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
		--		if TempVar2 == 0 then console:createBuffer("Player 2 and player 1 same map") end
			elseif (PlayerMapID == NewMapConnectPrev and NewMapConnect == 1) or (PlayerPrevMap == MapID and PlayerConnectionMap == 1) then
				
						
					--	if TempVar2 == 0 then console:createBuffer("Test 2") end
						if (PlayerMapID == NewMapConnectPrev and PlayerDirectionPrev ~= 0 and NewMapConnect == 1) then MAXX = MapXPrev CURRX = MapStartX MAXY = MapYPrev CURRY = MapStartY
						else MAXX = PlayerMAXX CURRX = PlayerCURRX MAXY = PlayerMAXY CURRY = PlayerCURRY
						end
						Player1Vis = 1
						
				--		if TempVar2 == 0 then console:createBuffer("VARS: " .. PlayerDirectionPrev .. " " .. MAXY .. " " .. CURRY) end
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

				--		if TempVar2 == 0 then console:createBuffer("Test 3") end
					
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
				--			console:createBuffer("MAXX: " .. MAXX .. " CURRX: " .. CURRX)
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Left (P2 RIGHT)
					elseif ActualPlayerDirectionPrev == 1 then
				--			console:createBuffer("MAXX: " .. MAXX .. " CURRX: " .. CURRX)
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 +16
						end
					end
			--			if TempVar2 == 0 then console:createBuffer("Test 4") end
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
				--		console:createBuffer("PLAYER MAP CHANGE! DIR: " .. ActualPlayerDirectionPrev)
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
			--	if TempVar2 == 0 then console:createBuffer("Player 2 and player 1 same map") end
			--			if TempVar2 == 0 then console:createBuffer("TEST1") end
			elseif (PlayerMapID == NewMapConnect2Prev and NewMapConnect2 == 1) or (PlayerPrevMap == MapID2 and PlayerConnectionMap == 1) then
					Player2Vis = 1
											--Down
				--		if TempVar2 == 0 then console:createBuffer("TEST2") end
						if (PlayerMapID == NewMapConnect2Prev and Player2DirectionPrev ~= 0 and NewMapConnect2 == 1) then MAXX = MapX2Prev CURRX = MapStartX2 MAXY = MapY2Prev CURRY = MapStartY2
						else MAXX = PlayerMAXX CURRX = PlayerCURRX MAXY = PlayerMAXY CURRY = PlayerCURRY
						end
					--	if TempVar2 == 0 then console:createBuffer("TEST3") end
					--	if TempVar2 == 0 then console:createBuffer("MAXY: " .. MAXY .. " CURRY: " .. CURRY .. " Dir: " .. Player2DirectionPrev) end
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
					--		console:createBuffer("P2 LEFT")
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
				--			console:createBuffer("MAXX: " .. MAXX .. " CURRX: " .. CURRX)
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
						end
					--Left (P2 RIGHT)
					elseif ActualPlayerDirectionPrev == 1 then
					--		console:createBuffer("P1 LEFT")
							if MAXY > CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							elseif MAXY < CURRY then PlayerYCamera2 = (MAXY - CURRY) * -16
							end
							if MAXX > CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16
							elseif MAXX < CURRX then PlayerXCamera2 = (MAXX - CURRX) * -16 +16
						end
					end
			else
		--		if TempVar2 == 0 then console:createBuffer("PlayerMapID" .. PlayerMapID .. "NewMapConnect2Prev: " .. NewMapConnect2Prev .. " " .. NewMapConnect2) end
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
	if GameID == "BPRE" then
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
	elseif GameID == "BPGE" then
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
			--console:createBuffer("New map detected! Reloading sprites...")
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
	--		console:createBuffer("MAPX: " .. MapX .. " PlayerMapX: " .. PlayerMapX)
		end
		NewMapX = emu:read16(NewMapXAddress)
		NewMapY = emu:read16(NewMapYAddress)
		MapX = emu:read16(PlayerXAddress)
		if MapX > 99 then MapX = 99 end
		MapY = emu:read16(PlayerYAddress)
		if MapY > 99 then MapY = 99 end
		--Male Firered Sprite from 1.0, 1.1, and leafgreen
		if (Bike == 160 or Bike == 272) then
			PlayerExtra2 = 0
			Bike = 0
		--	if TempVar2 == 0 then console:createBuffer("Male on Foot") end
		--Male Firered Biking Sprite
		elseif (Bike == 320 or Bike == 432 or Bike == 288 or Bike == 400) then
			PlayerExtra2 = 0
			Bike = 1
		--	if TempVar2 == 0 then console:createBuffer("Male on Bike") end
		--Female sprite
		elseif ((Bike == 392 or Bike == 504) or (Bike == 360 or Bike == 472)) then
			PlayerExtra2 = 1
			Bike = 0
		--	if TempVar2 == 0 then console:createBuffer("Female on Foot") end
		--Female Biking sprite
		elseif ((Bike == 552 or Bike == 664) or (Bike == 520 or Bike == 632)) then
			PlayerExtra2 = 1
			Bike = 1
		--	if TempVar2 == 0 then console:createBuffer("Female on Bike") end
		else
		--If in bag when connecting will automatically be firered male
		--	if TempVar2 == 0 then console:createBuffer("Bag/Unknown") end
		end
		Facing = tonumber(PlayerFacing)
		if Bike == 1 then
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
			if Facing == 255 then PlayerExtra1 = 0 end
		end
		ActualPlayerDirection = PlayerDirection
	--	if TempVar2 == 0 then console:createBuffer("MapID: " .. MapID .. "PlayerMapID" .. PlayerMapID) end
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
	--	console:createBuffer("NEW MAP!")
			PlayerDirectionPrev = PlayerDirection
			ActualPlayerDirectionPrev = ActualPlayerDirection
			
			MapStartX = tonumber(NewMapX)
			MapStartY = tonumber(NewMapY)
	--		console:createBuffer("MAPX: " .. MapX)
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
		if (Bike == 160 or Bike == 272) then
			Player2Extra2 = 0
			Bike = 0
		--Male Firered Biking Sprite
		elseif (Bike == 320 or Bike == 432 or Bike == 288 or Bike == 400) then
			Player2Extra2 = 0
			Bike = 1
		--Female sprite
		elseif ((Bike == 392 or Bike == 504) or (Bike == 360 or Bike == 472)) then
			Player2Extra2 = 1
			Bike = 0
		--Female Biking sprite
		elseif ((Bike == 552 or Bike == 664) or (Bike == 520 or Bike == 632)) then
			Player2Extra2 = 1
			Bike = 1
		else
		--If in bag when connecting will automatically be firered male
		end
		if Bike == 1 then
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
			if Facing2 == 255 then Player2Extra1 = 0 end
		end
		ActualPlayerDirection = Player2Direction
	--	if TempVar2 == 0 then console:createBuffer("MapID: " .. MapID .. "PlayerMapID" .. PlayerMapID) end
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
	if GameID == "BPRE" then
		--Addresses for Firered
		ScreenDataAddress1 = 33686722
		ScreenDataAddress2 = 33686723
		--For intro
		ScreenDataAddress3 = 33686716
	elseif GameID == "BPGE" then
		--Addresses for Leafgreen
		ScreenDataAddress1 = 33686722
		ScreenDataAddress2 = 33686723
		--For intro
		ScreenDataAddress3 = 33686716
	end
		ScreenData1 = emu:read8(ScreenDataAddress1)
		ScreenData2 = emu:read8(ScreenDataAddress2)
		ScreenData3 = emu:read8(ScreenDataAddress3)
		
	--	if TempVar2 == 0 then console:createBuffer("ScreenData: " .. ScreenData1 .. " " .. ScreenData2 .. " " .. ScreenData3) end
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
		end
			AnimatePlayerMoveX = ((NewXMap * 16) - NewMapPosX) - (XMap * 16)
			AnimatePlayerMoveY = ((NewYMap * 16) - NewMapPosY) - (YMap * 16)
			
			if PlayerAnimationFrame < 0 then PlayerAnimationFrame = 0 end
	--		if PlayerAnimationFrame > 20 then PlayerAnimationFrame = 0 end
			--16 is the standard for 1 movement.
			PlayerAnimationFrame = PlayerAnimationFrame + 1
			
			
		--	if AnimateID ~= 255 then
		--	createBuffer("Max frame: " .. PlayerAnimationFrameMax .. "Current frame: " .. PlayerAnimationFrame)
		--	end
			
			--Animate left movement
			if AnimatePlayerMoveX < 0 then
		
	--	if AnimateID < 250 then console:createBuffer("Extra: " .. PlayerExtra .. "  " .. AnimateID) end
				
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
				--	console:createBuffer("Frame: " .. PlayerAnimationFrame)
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
				--	console:createBuffer("Running")
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
				--	console:createBuffer("Bike")
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
		
		
		--default position
		elseif PlayerExtra1 == 0 then Facing = 0 AnimatePlayerMovement(1, 255)
		
		end
		if NewMap ~= 0 then
			NewMap = 0
			PlayerDirectionPrev = PlayerDirection
			if PlayerDirectionPrev ~= 0 then
				if PlayerDirectionPrev == 1 then
			--		console:createBuffer("Left" .. Player2Extra1)
					MapStartX = MapStartX + 1
				--	MapX2 = MapX2 + 1
				--Down
				elseif PlayerDirectionPrev == 2 then
			--		console:createBuffer("Right" .. Player2Extra1)
					MapStartX = MapStartX - 1
				--	MapX2 = MapX2 - 1
				--Left
				elseif PlayerDirectionPrev == 3 then
			--		console:createBuffer("P2 Up")
					MapStartY = MapStartY + 1
				--	MapY2 = MapY2 + 1
				--Right
				elseif PlayerDirectionPrev == 4 then
			--		console:createBuffer("P2 Down")
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
		--if TempVar2 == 0 then console:createBuffer("PlayerExtra2: " .. Player2Extra2) end
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
		
		
		--default position
		elseif Player2Extra1 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 255)
		
		end
		
		if NewMap2 ~= 0 then
			NewMap2 = 0
			Player2DirectionPrev = Player2Direction
			if Player2DirectionPrev ~= 0 then
				if Player2Direction == 1 then
			--		console:createBuffer("Left" .. Player2Extra1)
					MapStartX2 = MapStartX2 + 1
				--	MapX2 = MapX2 + 1
				--Down
				elseif Player2Direction == 2 then
			--		console:createBuffer("Right" .. Player2Extra1)
					MapStartX2 = MapStartX2 - 1
				--	MapX2 = MapX2 - 1
				--Left
				elseif Player2Direction == 3 then
			--		console:createBuffer("P2 Up")
					MapStartY2 = MapStartY2 + 1
				--	MapY2 = MapY2 + 1
				--Right
				elseif Player2Direction == 4 then
			--		console:createBuffer("P2 Down")
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
			--	console:createBuffer("PLAYER MAP CHANGE! DIR: " .. ActualPlayerDirectionPrev)
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
	--	console:createBuffer("Player X camera: " .. PlayerMapXMove .. "Player Y camera: " .. PlayerMapYMove)
	--	console:createBuffer("PlayerMapXMove: " .. PlayerMapXMove .. "PlayerMapYMove: " .. PlayerMapYMove .. "PlayerMapXMovePREV: " .. PlayerMapXMovePrev .. "PlayerMapYMovePrev: " .. PlayerMapYMovePrev)
		
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
	--	if PlayerXCameraTemp ~= 0 then console:createBuffer("PlayerXMove: " .. PlayerMapXMove .. "PlayerXMovePrev: " .. PlayerMapXMovePrev) end
		
		--Animate left movement
	--	if TempVar2 == 0 then console:createBuffer("PlayerYCameraTemp: " .. PlayerYCameraTemp .. " PlayerMapYMovePrev: " .. PlayerMapYMovePrev .. " PlayerMapYMove: " .. PlayerMapYMove) end
		if PlayerXCameraTemp > 0 then
			PlayerXCamera = PlayerXCamera + PlayerXCameraTemp
		--	console:createBuffer("Moving left.")
			
		--Animate right movement
		elseif PlayerXCameraTemp < 0 then
			PlayerXCamera = PlayerXCamera + PlayerXCameraTemp
	--		console:createBuffer("Moving right.")
		else
			PlayerXCamera = 0
		end
		
		
		--Animate down movement
		if PlayerYCameraTemp > 0 then
			PlayerYCamera = PlayerYCamera + PlayerYCameraTemp
	--		console:createBuffer("Moving up.")
			
		--Animate up movement
		elseif PlayerYCameraTemp < 0 then
			PlayerYCamera = PlayerYCamera + PlayerYCameraTemp
	--		console:createBuffer("Moving down.")
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
			if PlayerID ~= 1 then DrawPlayer1() end
			if PlayerID ~= 2 then DrawPlayer2() end
			if PlayerID ~= 3 then DrawPlayer3() end
			if PlayerID ~= 4 then DrawPlayer4() end
		end
	end
end

function DrawPlayer1()
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
		elseif GameID == "BPGE" then
			--Addresses for Leafgreen
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
		
	--	if TempVar2 == 0 then console:createBuffer("Player2Vis: " .. Player2Vis .. " Player2Y: " .. FinalMapY .. " Player2X: " .. FinalMapX) end
	--	console:createBuffer("Attempting to create player 1. X: " .. MapX .. " Y: " .. MapY)
--		if TempVar2 == 0 then console:createBuffer("CURRY PLAYER2: " .. MapStartY2 .. "MAXY PLAYER2: " .. MapY2Prev) end
--		if TempVar2 == 0 then console:createBuffer("FINALYP1: " .. FinalMapY .. "CURRY PLAYER1: " .. MapStartY .. "MAXY PLAYER1: " .. MapYPrev) end
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
				emu:write16(PlayerExtra1Address, 2496)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				else
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2496)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
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
		end
end
function DrawPlayer2()
		local u32 Player2Extra4Address = 0
		if GameID == "BPRE" then
			--Addresses for Firered
			Player1Address = 50345208
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		elseif GameID == "BPGE" then
			--Addresses for Leafgreen
			Player1Address = 50345208
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
--		if TempVar2 == 0 then console:createBuffer("PlayerY2POS: " .. NewMapY2Pos .. " PlayerY2: " .. PlayerY2) end
		
		--Flip sprite if facing right
		local FacingTemp = Facing2
		if FacingTemp == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
--		if TempVar2 == 0 then console:createBuffer("MapX: " .. MapX2 .. " PlayerXCamera2: " .. PlayerXCamera2) end
	--	if TempVar2 == 0 then console:createBuffer("MapY: " .. MapY2 .. " PlayerXCamera2: " .. PlayerYCamera2) end
		if not ((FinalMapX > MaxX or FinalMapX < MinX) or (FinalMapY > MaxY or FinalMapY < MinY)) then 
			
			if Player2Vis == 1 then
				--Bikes need different vars
				if Player2Extra1 >= 17 and Player2Extra1 <= 32 then
				FinalMapX = FinalMapX - 8
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, 2512)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				else
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2512)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
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
		end
end
function DrawPlayer3()
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
		
	--	console:createBuffer("MinX" .. MinX .. " " .. MinY .. " " .. MaxX .. " " .. MaxY .. "Player 2 var: " .. FinalMapX .. " " .. FinalMapY .. " " .. PlayerX .. " " .. PlayerY .. " " .. PlayerXCamera .. " " .. PlayerYCamera .. " " .. NewMapX2Pos .. " " .. NewMapY2Pos)
	--	console:createBuffer("Drawing Player 2. X: " .. FinalMapX .. " Y: " .. FinalMapY .. " Player2X: " .. PlayerX2)
		if not ((MapX3 > MaxX or MapX3 < MinX) or (MapY3 > MaxY or MapY3 < MinY)) then 
		
			if Player3Vis == 1 then
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2528)
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
			Player1Address = 50345224
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
		
	--	console:createBuffer("MinX" .. MinX .. " " .. MinY .. " " .. MaxX .. " " .. MaxY .. "Player 2 var: " .. FinalMapX .. " " .. FinalMapY .. " " .. PlayerX .. " " .. PlayerY .. " " .. PlayerXCamera .. " " .. PlayerYCamera .. " " .. NewMapX2Pos .. " " .. NewMapY2Pos)
	--	console:createBuffer("Drawing Player 2. X: " .. FinalMapX .. " Y: " .. FinalMapY .. " Player2X: " .. PlayerX2)
		if not ((MapX4 > MaxX or MapX4 < MinX) or (MapY4 > MaxY or MapY4 < MinY)) then 
			
			if Player4Vis == 1 then
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2544)
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
	console:createBuffer("A new game has started")
	FFTimer2 = os.clock()
	GetGameVersion()
end

function shutdownGame()
    ClearAllVar()
	console:createBuffer("The game was shutdown")
end

--Begin Networking

--Create Server

function CreateNetwork()
	SocketMain:bind(nil, Port)
	SocketMain:listen()
--	if SocketMain.ERRORS == OK then
		MasterClient = "h"
		console:createBuffer("Hosting game. Port forwarding may be required.")
--	else
--		if ErrorAmount < 3 then
--			console:createBuffer("There was an error binding a port. Please relaunch the emulator.")
--			ErrorAmount = ErrorAmount + 1
--		end
--	end
end
--Unique for client

function GetNewGame()
    ClearAllVar()
	console:createBuffer("A new game has started")
	GetGameVersion()
end

function shutdownGame()
    ClearAllVar()
	console:createBuffer("The game was shutdown")
end

--Network code starts here

function CreateNetwork()
		console:createBuffer("Searching for an open game on IP ".. IPAddress .. " and port " .. Port)
		SocketMain:connect(IPAddress, Port)
		SendData("Request", SocketMain)
		ReceiveData()
end

--Receive Data from server

function ReceiveData()
	if EnableScript == true then
			--If host has package sent
			if SocketMain:hasdata() then
				local ReadData = SocketMain:receive(64)
				if ReadData ~= nil then
					ConfirmEncrypt = 0
					--Decryption for packet
					GameCodeTemp = string.sub(ReadData,1,4)
					NicknameTemp = string.sub(ReadData,5,8)
					PlayerIDTemp = tonumber(string.sub(ReadData,9,9))
					ConnectionTypeTemp = string.sub(ReadData,10,13)
					Connection1TempVar1 = string.sub(ReadData,14,14)
					Connection1TempVar2 = string.sub(ReadData,15,15)
					Connection1TempVar3 = string.sub(ReadData,16,16)
				--	Connection1TempVar4 = string.sub(ReadData,17,17)
					MapIDConnection = string.sub(ReadData,17,17)
					MapIDConnection = tonumber(MapIDConnection)
					Player1XTemp = string.sub(ReadData,18,19)
					Player1YTemp = string.sub(ReadData,20,21)
					Player1FacingTemp = string.sub(ReadData,22,22)
					Player1FacingTemp = tonumber(Player1FacingTemp)
					Player1VisibleTemp = string.sub(ReadData,23,23)
					Player2XTemp = string.sub(ReadData,24,25)
					Player2YTemp = string.sub(ReadData,26,27)
					Player2FacingTemp = string.sub(ReadData,28,28)
					Player2VisibleTemp = string.sub(ReadData,29,29)
					Player3XTemp = string.sub(ReadData,30,31)
					Player3YTemp = string.sub(ReadData,32,33)
					Player3FacingTemp = string.sub(ReadData,34,34)
					Player3VisibleTemp = string.sub(ReadData,35,35)
					Player4XTemp = string.sub(ReadData,36,37)
					Player4YTemp = string.sub(ReadData,38,39)
					Player4FacingTemp = string.sub(ReadData,40,40)
					Player4VisibleTemp = string.sub(ReadData,41,41)
					Player1ExtraTemp1 = string.sub(ReadData,42,43)
					Player1ExtraTemp2 = string.sub(ReadData,44,45)
					Player2ExtraTemp1 = string.sub(ReadData,46, 47)
					Player2ExtraTemp2 = string.sub(ReadData,48,49)
					Player3ExtraTemp1 = string.sub(ReadData,50,51)
					Player3ExtraTemp2 = string.sub(ReadData,52,53)
					Player4ExtraTemp1 = string.sub(ReadData,54,55)
					Player4ExtraTemp2 = string.sub(ReadData,56,57)
					MapIDTemp = string.sub(ReadData,58,63)
					ConfirmEncrypt = string.sub(ReadData,64,64)
					ConfirmEncrypt = tonumber(ConfirmEncrypt)
					
					
					
	--					console:createBuffer("Valid package! Contents: " .. ReadData)
					if ConfirmEncrypt ~= 0 and (Player1FacingTemp == ConfirmEncrypt) then
					timeout1 = timeoutmax
			--			console:createBuffer("Valid package! Contents: " .. ReadData)
						--Set connection type to var
							ReturnConnectionType = ConnectionTypeTemp
						--If host asks for positions
						if ConnectionTypeTemp == "GPOS" then
							SendData("GPOS", SocketMain)
						end
						
							--If host accepts your join request
						if ConnectionTypeTemp == "STRT" then
							Player1AnimationFrame = 0
							Player2AnimationFrame = 0
							Player3AnimationFrame = 0
							Player4AnimationFrame = 0
							PlayerID = tonumber(Connection1TempVar1)
							Player1Vis = tonumber(Player1VisibleTemp)
							Player2Vis = tonumber(Player2VisibleTemp)
							Player3Vis = tonumber(Player3VisibleTemp)
							Player4Vis = tonumber(Player4VisibleTemp)
							if PlayerID ~= 1 then
								NewMapX = tonumber(Player1XTemp)
								NewMapY = tonumber(Player1YTemp)
						--		Facing = tonumber(Player1FacingTemp)
								--Action type -> can be walk or run
								PlayerExtra1 = tonumber(Player1ExtraTemp1)
								PlayerExtra2 = tonumber(Player1ExtraTemp2)
								FixPositionPlayer1()
								MapX = NewMapX
								MapY = NewMapY
							end
							if PlayerID ~= 2 then
								NewMapX2 = tonumber(Player2XTemp)
								NewMapY2 = tonumber(Player2YTemp)
						--		Facing2 = tonumber(Player2FacingTemp)
								Player2Extra1 = tonumber(Player2ExtraTemp1)
								Player2Extra2 = tonumber(Player2ExtraTemp2)
								FixPositionPlayer2()
								MapX2 = NewMapX2
								MapY2 = NewMapY2
							end
							if PlayerID ~= 3 then
								
							end
							if PlayerID ~= 4 then	
							end
						end
						--If host sends positions of players
						if ConnectionTypeTemp == "SPOS" then
							Player1Vis = tonumber(Player1VisibleTemp)
							Player2Vis = tonumber(Player2VisibleTemp)
							Player3Vis = tonumber(Player3VisibleTemp)
							Player4Vis = tonumber(Player4VisibleTemp)
							
							if PlayerIDTemp == 1 then
								MapIDTemp = tonumber(MapIDTemp)
								if MapID ~= MapIDTemp then
									NewMap = 1
									NewMapConnectPrev = MapID
									MapStartX = tonumber(Player1XTemp)
									MapStartY = tonumber(Player1YTemp)
									if MapStartX > 9 then MapStartX = MapStartX - 10 end
									if MapStartY > 9 then MapStartY = MapStartY - 10 end
									MapID = MapIDTemp
								end
								if MapID == PlayerMapID then
									MapXPrev = tonumber(Player1XTemp)
									MapYPrev = tonumber(Player1YTemp)
									if MapXPrev > 9 then MapXPrev = MapXPrev - 10 end
									if MapYPrev > 9 then MapYPrev = MapYPrev - 10 end
								end
								NewMapX = tonumber(Player1XTemp)
								NewMapY = tonumber(Player1YTemp)
								PlayerExtra1 = tonumber(Player1ExtraTemp1)
								PlayerExtra2 = tonumber(Player1ExtraTemp2)
								FixPositionPlayer1()
								NewMapConnect = tonumber(MapIDConnection)
							elseif PlayerIDTemp == 2 then
								MapIDTemp = tonumber(MapIDTemp)
								if MapID2 ~= MapIDTemp then
									NewMap2 = 1
									NewMapConnect2Prev = MapID2
									MapStartX2 = tonumber(Player2XTemp)
									MapStartY2 = tonumber(Player2YTemp)
									if MapStartX2 > 9 then MapStartX2 = MapStartX2 - 10 end
									if MapStartY2 > 9 then MapStartY2 = MapStartY2 - 10 end
									MapID2 = MapIDTemp
								end
								if MapID2 == PlayerMapID then
									MapX2Prev = tonumber(Player2XTemp)
									MapY2Prev = tonumber(Player2YTemp)
									if MapX2Prev > 9 then MapX2Prev = MapX2Prev - 10 end
									if MapY2Prev > 9 then MapY2Prev = MapY2Prev - 10 end
								end
								NewMapX2 = tonumber(Player2XTemp)
								NewMapY2 = tonumber(Player2YTemp)
								Player2Extra1 = tonumber(Player2ExtraTemp1)
								Player2Extra2 = tonumber(Player2ExtraTemp2)
								FixPositionPlayer2()
								NewMapConnect2 = tonumber(MapIDConnection)
							elseif PlayerIDTemp == 3 then
								
							elseif PlayerIDTemp == 4 then
								
							end
						end
		--			if TempVar2 == 0 then console:createBuffer("Test 4") end
			--		else
			--			console:createBuffer("INVALID PACKAGE: " .. ReadData)
					end
				end
			end
	end
end

--Send Data to server
function CreatePackett(RequestTemp, PackettTemp)
	local PrevMapTemp = 0
	--console:createBuffer("Test 1")
	PlayerExtra1 = PlayerExtra1 + 10
	PlayerExtra2 = PlayerExtra2 + 10
	Player2Extra1 = Player2Extra1 + 10
	Player2Extra2 = Player2Extra2 + 10
	Player3Extra1 = Player3Extra1 + 10
	Player3Extra2 = Player3Extra2 + 10
	Player4Extra1 = Player4Extra1 + 10
	Player4Extra2 = Player4Extra2 + 10
	Facing = 5
	Facing2 = 5
	Facing3 = 5
	Facing4 = 5
	if MapX < 90 then MapX = MapX + 10 end
	if MapX2 < 90 then MapX2 = MapX2 + 10 end
	if MapX3 < 90 then MapX3 = MapX3 + 10 end
	if MapX4 < 90 then MapX4 = MapX4 + 10 end
	if MapY < 90 then MapY = MapY + 10 end
	if MapY2 < 90 then MapY2 = MapY2 + 10 end
	if MapY3 < 90 then MapY3 = MapY3 + 10 end
	if MapY4 < 90 then MapY4 = MapY4 + 10 end
	if PlayerID == 1 then PrevMapTemp = NewMapConnectPrev
	elseif PlayerID == 2 then PrevMapTemp = NewMapConnect2Prev
	elseif PlayerID == 3 then PrevMapTemp = NewMapConnect3Prev
	elseif PlayerID == 4 then PrevMapTemp = NewMapConnect4Prev
	end
	Packett = GameID .. Nickname .. PlayerID .. RequestTemp .. PackettTemp .. MapX .. MapY .. Facing .. MapX2 .. MapY2 .. Facing2 .. MapX3 .. MapY3 .. Facing3 .. MapX4 .. MapY4 .. Facing4 .. PlayerExtra1 .. PlayerExtra2 .. Player2Extra1 .. Player2Extra2 .. Player3Extra1 .. Player3Extra2 .. Player4Extra1 .. Player4Extra2 .. PlayerMapID .. PrevMapTemp .. NewMapConnect .. Facing
--	console:createBuffer("Packett: " .. Packett)
	FixAllPositions()
end

function SendData(DataType)
	--If you have made a server
	if (DataType == "NewPlayer2") then
		console:createBuffer("Request accepted!")
		CreatePackett("STRT", "2")
		SocketMain:send(Packett)
	elseif (DataType == "NewPlayer3") then
		console:createBuffer("Request accepted!")
		CreatePackett("STRT", "3")
		SocketMain:send(Packett)
	elseif (DataType == "NewPlayer4") then
		console:createBuffer("Request accepted!")
		CreatePackett("STRT", "4")
		SocketMain:send(Packett)
	elseif (DataType == "DENY") then
		CreatePackett("DENY", "0")
		SocketMain:send(Packett)
	elseif (DataType == "KICK") then
		CreatePackett("KICK", "0")
		SocketMain:send(Packett)
	elseif (DataType == "GPos") then
		CreatePackett("GPOS", "0")
		SocketMain:send(Packett)
--		SocketMain:send("BPREABCD1DMMY111111111111111111111111111111111111111111111111111")
	elseif (DataType == "SPos") then
		CreatePackett("SPOS", "0")
		SocketMain:send(Packett)
	elseif (DataType == "Request") then
		CreatePackett("JOIN", "0")
		SocketMain:send(Packett)
	end
end

function ConnectNetwork()
	--If you are currently connected to a server
	if (timeout1 > 0) then
	--To prevent package overrunning, sending will be every 8 frames, unlike recieve, which is every frame
	--Send timer
	local SendTimer = ScriptTime % 4
	--Receive timer
	local ReceiveTimer = ScriptTime % 1
	
		if ReceiveTimer == 0 then
		timeout1 = timeout1 - 1
		--Recieve data from server (GPOS and SPOS)
		ReceiveData()
		if timeout1 == 0 then console:createBuffer("You have been disconnected due to timeout") end
		end
		if SendTimer == 0 then 
		--Ask for some data relating to position
		SendData("GPos")
		end
		
	else 
		--You might be connected to one
		ReceiveData()
	--	console:createBuffer("Connection Type: " .. ReturnConnectionType)
		if ReturnConnectionType == "STRT" then
			Connected = 1
			console:createBuffer("You have successfully connected.")
			timeout1 = timeoutmax
			--Since ID has changed, get real position
			GetPosition()
		end
	end
end

--End network code

function RandomizeNickname()
	local res = ""
	for i = 1, 4 do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end
function mainLoop()
	FFTimer = os.clock() - FFTimer2
	ScriptTime = ScriptTime + 1
	if initialized == 0 and EnableScript == true then
		initialized = 1
		GetPosition()
		if Nickname == "" then Nickname = RandomizeNickname() console:createBuffer("Nickname is now " .. Nickname) end
		if MasterClient == "a" then CreateNetwork() end
	elseif EnableScript == true then
			--Debugging
			local TempVarTimer = ScriptTime % DebugTime
			if TempVarTimer == 0 then
		--		console:createBuffer("Current Frame: " .. emu:currentFrame())
		--		console:createBuffer("Current X: " .. MapX .. " Current Y: " .. MapY)
		--		console:createBuffer("Master/Slave: " .. MasterClient )
			end
			TempVar2 = ScriptTime % DebugTime2
			--Update once every 10 frames
			TempVarTimer = ScriptTime % DebugTime3
			if TempVarTimer == 0 then
				GetPosition()
				ConnectNetwork()
			end
			--Create a network if not made every half second
			TempVarTimer = ScriptTime % DebugTime2
			if TempVarTimer == 0 then
				if timeout1 == 0 then CreateNetwork() end
			end
	end
end

SocketMain:add("received", ReceiveData)
callbacks:add("reset", GetNewGame)
callbacks:add("shutdown", shutdownGame)
callbacks:add("frame", mainLoop)
callbacks:add("frame", DrawChars)

console:createBuffer("The lua script 'PositionPlayer.lua' has been loaded")
if not (emu == nil) then
	FFTimer2 = os.clock()
    GetGameVersion()
end