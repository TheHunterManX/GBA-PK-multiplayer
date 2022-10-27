local IPAddress, Port = "127.0.0.1", 4096
local GameID = ""
local GameCode = "None"
local Nickname = ""
local Nickname2 = ""
local Nickname3 = ""
local Nickname4 = ""
local ConfirmPackett = 0
local EnableScript = false
local u32 GameInitializedByteAddress1 = 0
local u32 GameInitializedByteAddress2 = 0
local u32 GameInitializedByteAddress3 = 0
local ClientConnection

local u32 SpriteTempVar0 = 0
local u32 SpriteTempVar1 = 0
local u16 SpriteTempVar2 = 0
local u8 SpriteTempVar3 = 0

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

--Player 2
local Player2Visible = false
local MapID2 = 0
local MapX2 = 0
local MapY2 = 0
local NewMapX2 = 0
local NewMapY2 = 0
local Player2X = 0
local Player2Y = 0
local NewMapX2Pos = 0
local NewMapY2Pos = 0
local Facing2 = 0
local Player2Extra1 = 0
local Player2Extra2 = 0
local Player2Extra3 = 0
local Player2Extra4 = 0

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
local Player3Extra3 = 0
local Player3Extra4 = 0

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
local Player4Extra3 = 0
local Player4Extra4 = 0

--Player char start addresses

--Player Stats
local PlayerMapID = 0
local u8 PlayerMapX = 0
local u8 PlayerMapY = 0
local PlayerMapXMove = 0
local PlayerMapYMove = 0
local PlayerMapXMovePrev = 0
local PlayerMapYMovePrev = 0
local u32 PlayerMapXMoveAddress = 0
local u32 PlayerMapYMoveAddress = 0

--To check if map is new
local NewMap = 0
local NewMap2 = 0
local NewMap3 = 0
local NewMap4 = 0

--Add camera movement. from +16 to -16
local PlayerXCamera = 0
local PlayerYCamera = 0
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
	 Nickname2 = ""
	 Nickname3 = ""
	 Nickname4 = ""
	 ConfirmPackett = 0
	 EnableScript = false
	 GameInitializedByteAddress1 = 0
	 GameInitializedByteAddress2 = 0
	 GameInitializedByteAddress3 = 0

	 SpriteTempVar0 = 0
	 SpriteTempVar1 = 0
	 SpriteTempVar2 = 0
	 SpriteTempVar3 = 0

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
	 Player2Extra3 = 0
	 Player2Extra4 = 0

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
	 Player3Extra3 = 0
	 Player3Extra4 = 0

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
	 Player4Extra3 = 0
	 Player4Extra4 = 0

--Player char start addresses

--Player Stats
	 PlayerMapID = 0
	 PlayerMapX = 0
	 PlayerMapY = 0
	 PlayerMapXMove = 0
	 PlayerMapYMove = 0
	 PlayerMapXMovePrev = 0
	 PlayerMapYMovePrev = 0
	 PlayerMapXMoveAddress = 0
	 PlayerMapYMoveAddress = 0
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
function createChars(StartAddressNo, SpriteID)
	--0 = Tile 80, 1 = Tile 81, etc...
	--Tile number 80 = Player2
	--Tile number 81 = Player3
	--Tile number 82 = Player4
	--First will be the 4 bytes, or 32 bits
	--SpriteID means a sprite from the chart below
	--1 = Firered Male Side Left (Right must be set with facing variable)
	--2 = Firered Male Side Up
	--3 = Firered Male Side Down
	--4 = Firered Male Side Left Walk (Right must be set with facing variable)
	--5 = Firered Male Side Up Walk
	--6 = Firered Male Side Down Walk
	
	
	--Start address. 100732928 = 06011000 = 80th tile. can safely use 16.
	--Because the actual data doesn't start until 06011050, we will skip 50 hexbytes, or 80 decibytes
	local ActualAddress = 100732928 + (StartAddressNo * 256) + 80
	
	if SpriteID == 1 then
	--Firered Male Side Left
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
		SpriteTempVar0 = SpriteTempVar0 + 20
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
		SpriteTempVar0 = SpriteTempVar0 + 8
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
	--Firered Male Side Up
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
		SpriteTempVar0 = SpriteTempVar0 + 20
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
		SpriteTempVar0 = SpriteTempVar0 + 8
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
	--Firered Male Side Down
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
		SpriteTempVar0 = SpriteTempVar0 + 20
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
		SpriteTempVar0 = SpriteTempVar0 + 8
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
	--Firered Male Side Left Walk Cycle 1
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
	elseif SpriteID == 5 then
	--Firered Male Side Left Walk Cycle 2
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
	elseif SpriteID == 6 then
	--Firered Male Side Up Walk Cycle 1
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
	elseif SpriteID == 7 then
	--Firered Male Side Up Walk Cycle 2
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
	elseif SpriteID == 8 then
	--Firered Male Side Down Walk Cycle 1
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
		--End of block
	elseif SpriteID == 9 then
	--Firered Male Side Down Walk Cycle 2
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
		--End of block
	else
	--If unable to get sprite
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

function GetPosition()
	local u32 BikeAddress = 0
	local Bike = 0
	if GameID == "BPRE" then
		--Addresses for Firered
		PlayerXAddress = 33779272
		PlayerYAddress = 33779274
		PlayerFaceAddress = 33779284
		MapAddress = 33779200
		BikeAddress = 33687113
	elseif GameID == "BPGE" then
		--Addresses for Leafgreen
		PlayerXAddress = 33779272
		PlayerYAddress = 33779274
		PlayerFaceAddress = 33779284
		MapAddress = 33779200
		BikeAddress = 33687113
	end
	
		PlayerMapX = emu:read16(PlayerXAddress)
		PlayerMapY = emu:read16(PlayerYAddress)
		PlayerFacing = emu:read8(PlayerFaceAddress)
		Bike = emu:read8(BikeAddress)
		Bike = tonumber(Bike)
		local TempMapData = emu:read16(MapAddress)
		--55 is a buffer string for package
		TempMapData = tonumber(TempMapData)
		if TempMapData > 99999 then TempMapData = 99999 end
		TempMapData = TempMapData + 100000
		if TempMapData ~= PlayerMapID then
			NewMap = TempMapData
			--console:createBuffer("New map detected! Reloading sprites...")
			--Starts at 100733010, each number will add it by 256 ex. 1 = 100733266
			--HandleSprites()
		end
		PlayerMapID = TempMapData
		
	if PlayerID == 1 then
		MapX = emu:read16(PlayerXAddress)
		if MapX > 99 then MapX = 99 end
		MapY = emu:read16(PlayerYAddress)
		if MapY > 99 then MapY = 99 end
		Facing = tonumber(PlayerFacing)
		--Male sprite
		PlayerExtra2 = 0
		if Bike == 1 then
			if Facing == 0 then PlayerExtra1 = 1 end
			if Facing == 1 then PlayerExtra1 = 2 end
			if Facing == 2 then PlayerExtra1 = 3 end
			if Facing == 3 then PlayerExtra1 = 4 end
			--Standard speed
			if Facing == 49 then PlayerExtra1 = 17 end
			if Facing == 50 then PlayerExtra1 = 18 end
			if Facing == 51 then PlayerExtra1 = 19 end
			if Facing == 52 then PlayerExtra1 = 20 end
			--In case you use a fast bike
			if Facing == 61 then PlayerExtra1 = 17 end
			if Facing == 62 then PlayerExtra1 = 18 end
			if Facing == 63 then PlayerExtra1 = 19 end
			if Facing == 64 then PlayerExtra1 = 20 end
			--hitting a wall
			if Facing == 37 then PlayerExtra1 = 5 end
			if Facing == 38 then PlayerExtra1 = 6 end
			if Facing == 39 then PlayerExtra1 = 7 end
			if Facing == 40 then PlayerExtra1 = 8 end
		else
			if Facing == 0 then PlayerExtra1 = 1 end
			if Facing == 1 then PlayerExtra1 = 2 end
			if Facing == 2 then PlayerExtra1 = 3 end
			if Facing == 3 then PlayerExtra1 = 4 end
			if Facing == 33 then PlayerExtra1 = 5 end
			if Facing == 34 then PlayerExtra1 = 6 end
			if Facing == 35 then PlayerExtra1 = 7 end
			if Facing == 36 then PlayerExtra1 = 8 end
			if Facing == 16 then PlayerExtra1 = 5 end
			if Facing == 17 then PlayerExtra1 = 6 end
			if Facing == 18 then PlayerExtra1 = 7 end
			if Facing == 19 then PlayerExtra1 = 8 end
			if Facing == 41 then PlayerExtra1 = 9 end
			if Facing == 42 then PlayerExtra1 = 10 end
			if Facing == 43 then PlayerExtra1 = 11 end
			if Facing == 44 then PlayerExtra1 = 12 end
			if Facing == 61 then PlayerExtra1 = 13 end
			if Facing == 62 then PlayerExtra1 = 14 end
			if Facing == 63 then PlayerExtra1 = 15 end
			if Facing == 64 then PlayerExtra1 = 16 end
			if Facing == 255 then PlayerExtra1 = 0 end
		end
		MapID = tonumber(PlayerMapID)
	elseif PlayerID == 2 then
		MapX2 = emu:read16(PlayerXAddress)
		if MapX2 > 99 then MapX2 = 99 end
		MapY2 = emu:read16(PlayerYAddress)
		if MapY2 > 99 then MapY2 = 99 end
		Facing2 = tonumber(PlayerFacing)
		--Male sprite
		Player2Extra2 = 0
		if Bike == 1 then
			if Facing2 == 0 then Player2Extra1 = 1 end
			if Facing2 == 1 then Player2Extra1 = 2 end
			if Facing2 == 2 then Player2Extra1 = 3 end
			if Facing2 == 3 then Player2Extra1 = 4 end
			--Standard speed
			if Facing2 == 49 then Player2Extra1 = 17 end
			if Facing2 == 50 then Player2Extra1 = 18 end
			if Facing2 == 51 then Player2Extra1 = 19 end
			if Facing2 == 52 then Player2Extra1 = 20 end
			--In case you use a fast bike
			if Facing2 == 61 then Player2Extra1 = 17 end
			if Facing2 == 62 then Player2Extra1 = 18 end
			if Facing2 == 63 then Player2Extra1 = 19 end
			if Facing2 == 64 then Player2Extra1 = 20 end
			--hitting a wall
			if Facing2 == 37 then Player2Extra1 = 5 end
			if Facing2 == 38 then Player2Extra1 = 6 end
			if Facing2 == 39 then Player2Extra1 = 7 end
			if Facing2 == 40 then Player2Extra1 = 8 end
		else
			if Facing2 == 0 then Player2Extra1 = 1 end
			if Facing2 == 1 then Player2Extra1 = 2 end
			if Facing2 == 2 then Player2Extra1 = 3 end
			if Facing2 == 3 then Player2Extra1 = 4 end
			if Facing2 == 33 then Player2Extra1 = 5 end
			if Facing2 == 34 then Player2Extra1 = 6 end
			if Facing2 == 35 then Player2Extra1 = 7 end
			if Facing2 == 36 then Player2Extra1 = 8 end
			if Facing2 == 16 then Player2Extra1 = 5 end
			if Facing2 == 17 then Player2Extra1 = 6 end
			if Facing2 == 18 then Player2Extra1 = 7 end
			if Facing2 == 19 then Player2Extra1 = 8 end
			if Facing2 == 41 then Player2Extra1 = 9 end
			if Facing2 == 42 then Player2Extra1 = 10 end
			if Facing2 == 43 then Player2Extra1 = 11 end
			if Facing2 == 44 then Player2Extra1 = 12 end
			if Facing2 == 61 then Player2Extra1 = 13 end
			if Facing2 == 62 then Player2Extra1 = 14 end
			if Facing2 == 63 then Player2Extra1 = 15 end
			if Facing2 == 64 then Player2Extra1 = 16 end
			if Facing2 == 255 then Player2Extra1 = 0 end
		end
		MapID2 = tonumber(PlayerMapID)
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
			PlayerExtra = PlayerExtra2
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
			PlayerExtra = PlayerExtra3
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
			PlayerExtra = PlayerExtra4
		end
			local AnimatePlayerMoveX = ((NewXMap * 16) - NewMapPosX) - (XMap * 16)
			local AnimatePlayerMoveY = ((NewYMap * 16) - NewMapPosY) - (YMap * 16)
			
			if PlayerAnimationFrame < 0 then PlayerAnimationFrame = 0 end
	--		if PlayerAnimationFrame > 20 then PlayerAnimationFrame = 0 end
			--16 is the standard for 1 movement.
			PlayerAnimationFrame = PlayerAnimationFrame + 1
			
			
		--	if AnimateID ~= 255 then
		--	createBuffer("Max frame: " .. PlayerAnimationFrameMax .. "Current frame: " .. PlayerAnimationFrame)
		--	end
			
			--Animate left movement
			if AnimatePlayerMoveX < 0 then
				if AnimateID == 3 then
					PlayerAnimationFrameMax = 14
					NewMapPosX = NewMapPosX - 1
					if PlayerAnimationFrame == 5 then NewMapPosX = NewMapPosX - 1 end
					if PlayerAnimationFrame == 9 then NewMapPosX = NewMapPosX - 1 end
					if PlayerAnimationFrame >= 3 and PlayerAnimationFrame <= 11 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4)
						else
						createChars(Charpic,5)
						end
					else
						createChars(Charpic,1)
					end
				elseif AnimateID == 6 then
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX - 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4)
						else
						createChars(Charpic,5)
						end
					else
						createChars(Charpic,1)
					end
				elseif AnimateID == 9 then
					PlayerAnimationFrameMax = 6
					NewMapPosX = NewMapPosX - 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4)
						else
						createChars(Charpic,5)
						end
					else
						createChars(Charpic,1)
					end
				else
				
				end
				
			--Animate right movement
			elseif AnimatePlayerMoveX > 0 then
				if AnimateID == 3 then
					PlayerAnimationFrameMax = 14
					NewMapPosX = NewMapPosX + 1
					if PlayerAnimationFrame == 5 then NewMapPosX = NewMapPosX + 1 end
					if PlayerAnimationFrame == 9 then NewMapPosX = NewMapPosX + 1 end
					if PlayerAnimationFrame >= 3 and PlayerAnimationFrame <= 11 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4)
						else
						createChars(Charpic,5)
						end
					else
						createChars(Charpic,1)
					end
				elseif AnimateID == 6 then
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX + 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4)
						else
						createChars(Charpic,5)
						end
					else
						createChars(Charpic,1)
					end
				elseif AnimateID == 9 then
					PlayerAnimationFrameMax = 4
					NewMapPosX = NewMapPosX + 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,4)
						else
						createChars(Charpic,5)
						end
					else
						createChars(Charpic,1)
					end
				else
				
				end
			else
			--Turn player left/right
			if AnimateID == 12 then
				PlayerAnimationFrameMax = 8
				if PlayerAnimationFrame > 1 and PlayerAnimationFrame < 6 then
					if PlayerAnimationFrame2 == 0 then
					createChars(Charpic,4)
					else
					createChars(Charpic,5)
					end
				else
					createChars(Charpic,1)
				end
			else
		--		createChars(Charpic,1)
			end
			--If they are now equal
			XMap = NewXMap
			NewMapPosX = 0
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
						createChars(Charpic,6)
						else
						createChars(Charpic,7)
						end
					else
						createChars(Charpic,2)
					end
				elseif AnimateID == 5 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY - 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,6)
						else
						createChars(Charpic,7)
						end
					else
						createChars(Charpic,2)
					end
				elseif AnimateID == 8 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY - 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,6)
						else
						createChars(Charpic,7)
						end
					else
						createChars(Charpic,2)
					end
				else
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
						createChars(Charpic,8)
						else
						createChars(Charpic,9)
						end
					else
						createChars(Charpic,3)
					end
				elseif AnimateID == 4 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY + 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,8)
						else
						createChars(Charpic,9)
						end
					else
						createChars(Charpic,3)
					end
				elseif AnimateID == 7 then
					PlayerAnimationFrameMax = 4
					NewMapPosY = NewMapPosY + 4
					if PlayerAnimationFrame >= 1 and PlayerAnimationFrame <= 3 then
						if PlayerAnimationFrame2 == 0 then
						createChars(Charpic,8)
						else
						createChars(Charpic,9)
						end
					else
						createChars(Charpic,3)
					end
				else
				end
			else
			--Turn player down
			if AnimateID == 10 then
				PlayerAnimationFrameMax = 8
				if PlayerAnimationFrame > 1 and PlayerAnimationFrame < 6 then
					if PlayerAnimationFrame2 == 0 then
					createChars(Charpic,8)
					else
					createChars(Charpic,9)
					end
				else
					createChars(Charpic,3)
				end
			--Turn player up
			
			elseif AnimateID == 11 then
				PlayerAnimationFrameMax = 8
				if PlayerAnimationFrame > 1 and PlayerAnimationFrame < 6 then
					if PlayerAnimationFrame2 == 0 then
					createChars(Charpic,6)
					else
					createChars(Charpic,7)
					end
				else
					createChars(Charpic,2)
				end
			else
		--		createChars(Charpic,3)
			end
			--If they are now equal
			YMap = NewYMap
			NewMapPosY = 0
			end
			if AnimateID == 255 then
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
		elseif PlayerNo == 2 then
			MapX2 = XMap
			MapY2 = YMap
			NewMapX2 = NewXMap
			NewMapY2 = NewYMap
			NewMapX2Pos = NewMapPosX
			NewMapY2Pos = NewMapPosY
			Player2AnimationFrame = PlayerAnimationFrame
			Player2AnimationFrame2 = PlayerAnimationFrame2
			PlayerExtra2 = PlayerExtra
		elseif PlayerNo == 3 then
			MapX3 = XMap
			MapY3 = YMap
			NewMapX3 = NewXMap
			NewMapY3 = NewYMap
			NewMapX3Pos = NewMapPosX
			NewMapY3Pos = NewMapPosY
			Player3AnimationFrame = PlayerAnimationFrame
			Player3AnimationFrame2 = PlayerAnimationFrame2
			PlayerExtra3 = PlayerExtra
		elseif PlayerNo == 4 then
			MapX4 = XMap
			MapY4 = YMap
			NewMapX4 = NewXMap
			NewMapY4 = NewYMap
			NewMapX4Pos = NewMapPosX
			NewMapY4Pos = NewMapPosY
			Player4AnimationFrame = PlayerAnimationFrame
			Player4AnimationFrame2 = PlayerAnimationFrame2
			PlayerExtra4 = PlayerExtra
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
	
		--Facing down, male sprite
		if PlayerExtra1 == 1 and PlayerExtra2 == 0 then createChars(0,3) Facing = 0 AnimatePlayerMovement(1, 255)
		
		--Facing up, male sprite
		elseif PlayerExtra1 == 2 and PlayerExtra2 == 0 then createChars(0,2) Facing = 0 AnimatePlayerMovement(1, 255)
		
		--Facing left, male sprite
		elseif PlayerExtra1 == 3 and PlayerExtra2 == 0 then createChars(0,1) Facing = 0 AnimatePlayerMovement(1, 255)
		
		--Facing right, male sprite
		elseif PlayerExtra1 == 4 and PlayerExtra2 == 0 then createChars(0,1) Facing = 1 AnimatePlayerMovement(1, 255)
		
		--walk down, male sprite
		elseif PlayerExtra1 == 5 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 1)
		
		--walk up, male sprite
		elseif PlayerExtra1 == 6 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 2)
		
		--walk left, male sprite
		elseif PlayerExtra1 == 7 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 3)
		
		--walk right, male sprite
		elseif PlayerExtra1 == 8 and PlayerExtra2 == 0 then Facing = 1 AnimatePlayerMovement(1, 3)
		
		--run down, male sprite
		elseif PlayerExtra1 == 13 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 4)
		
		--run up, male sprite
		elseif PlayerExtra1 == 14 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 5)
		
		--run left, male sprite
		elseif PlayerExtra1 == 15 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 6)
		
		--run right, male sprite
		elseif PlayerExtra1 == 16 and PlayerExtra2 == 0 then Facing = 1 AnimatePlayerMovement(1, 6)
		
		--bike down, male sprite
		elseif PlayerExtra1 == 17 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 7)
		
		--bike up, male sprite
		elseif PlayerExtra1 == 18 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 8)
		
		--bike left, male sprite
		elseif PlayerExtra1 == 19 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 9)
		
		--bike right, male sprite
		elseif PlayerExtra1 == 20 and PlayerExtra2 == 0 then Facing = 1 AnimatePlayerMovement(1, 9)
		
		--turn down, male sprite
		elseif PlayerExtra1 == 9 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 10)
		
		--turn up, male sprite
		elseif PlayerExtra1 == 10 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 11)
		
		--turn left, male sprite
		elseif PlayerExtra1 == 11 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 12)
		
		--turn right, male sprite
		elseif PlayerExtra1 == 12 and PlayerExtra2 == 0 then Facing = 1 AnimatePlayerMovement(1, 12)
		
		
		--male sprite default position
		elseif PlayerExtra1 == 0 and PlayerExtra2 == 0 then Facing = 0 AnimatePlayerMovement(1, 255)
		
		end
	end
	
	--Player 2 sprite
	if PlayerID ~= 2 then
	
		--Facing down, male sprite
		if Player2Extra1 == 1 and Player2Extra2 == 0 then createChars(1,3) Facing2 = 0 AnimatePlayerMovement(2, 255)
		
		--Facing up, male sprite
		elseif Player2Extra1 == 2 and Player2Extra2 == 0 then createChars(1,2) Facing2 = 0 AnimatePlayerMovement(2, 255)
		
		--Facing left, male sprite
		elseif Player2Extra1 == 3 and Player2Extra2 == 0 then createChars(1,1) Facing2 = 0 AnimatePlayerMovement(2, 255)
		
		--Facing right, male sprite
		elseif Player2Extra1 == 4 and Player2Extra2 == 0 then createChars(1,1) Facing2 = 1 AnimatePlayerMovement(2, 255)
		
		--walk down, male sprite
		elseif Player2Extra1 == 5 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 1)
		
		--walk up, male sprite
		elseif Player2Extra1 == 6 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 2)
		
		--walk left, male sprite
		elseif Player2Extra1 == 7 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 3)
		
		--walk right, male sprite
		elseif Player2Extra1 == 8 and Player2Extra2 == 0 then Facing2 = 1 AnimatePlayerMovement(2, 3)
		
		--run down, male sprite
		elseif Player2Extra1 == 13 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 4)
		
		--run up, male sprite
		elseif Player2Extra1 == 14 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 5)
		
		--run left, male sprite
		elseif Player2Extra1 == 15 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 6)
		
		--run right, male sprite
		elseif Player2Extra1 == 16 and Player2Extra2 == 0 then Facing2 = 1 AnimatePlayerMovement(2, 6)
		
		--bike down, male sprite
		elseif Player2Extra1 == 17 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 7)
		
		--bike up, male sprite
		elseif Player2Extra1 == 18 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 8)
		
		--bike left, male sprite
		elseif Player2Extra1 == 19 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 9)
		
		--bike right, male sprite
		elseif Player2Extra1 == 20 and Player2Extra2 == 0 then Facing2 = 1 AnimatePlayerMovement(2, 9)
		
		--turn down, male sprite
		elseif Player2Extra1 == 9 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 10)
		
		--turn up, male sprite
		elseif Player2Extra1 == 10 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 11)
		
		--turn left, male sprite
		elseif Player2Extra1 == 11 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 12)
		
		--turn right, male sprite createChars(0,1) 
		elseif Player2Extra1 == 12 and Player2Extra2 == 0 then Facing2 = 1 AnimatePlayerMovement(2, 12)
		
		--male sprite default position
		elseif Player2Extra1 == 0 and Player2Extra2 == 0 then Facing2 = 0 AnimatePlayerMovement(2, 255)
		end
	end
	
	--Player 3 sprite
	if PlayerID ~= 3 then
	end
	
	--Player 4 sprite
	if PlayerID ~= 4 then
	end
end

function CalculateCamera()
		if GameID == "BPRE" then
			--Addresses for Firered
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		elseif GameID == "BPGE" then
			--Addresses for Leafgreen
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		end
		--Can be between -16 and 16
		PlayerMapXMovePrev = PlayerMapXMove
		PlayerMapYMovePrev = PlayerMapYMove
		PlayerMapXMove = emu:read16(PlayerMapXMoveAddress)
		PlayerMapYMove = emu:read16(PlayerMapYMoveAddress)
		
		if PlayerID == 1 then
			if NewMap ~= 0 then
				NewMap = 0
				MapX = NewMapX
				MapY = NewMapY
				MapX2 = NewMapX2
				MapY2 = NewMapY2
				NewMapPosX = 0
				NewMapPosY = 0
				NewMapPosX2 = 0
				NewMapPosY2 = 0
			end
			elseif PlayerID == 2 then
			if NewMap2 ~= 0 then
				NewMap2 = 0
				MapX = NewMapX
				MapY = NewMapY
				MapX2 = NewMapX2
				MapY2 = NewMapY2
				NewMapPosX = 0
				NewMapPosY = 0
				NewMapPosX2 = 0
				NewMapPosY2 = 0
			end
		end
	--	console:createBuffer("Player X camera: " .. PlayerMapXMove .. "Player Y camera: " .. PlayerMapYMove)
	--	console:createBuffer("PlayerMapXMove: " .. PlayerMapXMove .. "PlayerMapYMove: " .. PlayerMapYMove .. "PlayerMapXMovePREV: " .. PlayerMapXMovePrev .. "PlayerMapYMovePrev: " .. PlayerMapYMovePrev)
		
		
		if (PlayerMapXMove < 32000) then PlayerMapXMove = PlayerMapXMove + 62355 end
		if (PlayerMapXMovePrev < 32000) then PlayerMapXMovePrev = PlayerMapXMovePrev + 62355 end
		if (PlayerMapYMove < 32000) then PlayerMapYMove = PlayerMapYMove + 62355 end
		if (PlayerMapYMovePrev < 32000) then PlayerMapYMovePrev = PlayerMapYMovePrev + 62355 end
		
		if (PlayerMapXMove < 64000 and PlayerMapXMovePrev > 64000) then PlayerMapXMovePrev = PlayerMapXMovePrev + 62355
		elseif (PlayerMapXMove > 64000 and PlayerMapXMovePrev < 64000) then PlayerMapXMovePrev = PlayerMapXMovePrev - 62355 end
		if (PlayerMapYMove < 64000 and PlayerMapYMovePrev > 64000) then PlayerMapYMovePrev = PlayerMapYMovePrev + 62355
		elseif (PlayerMapYMove > 64000 and PlayerMapYMovePrev < 64000) then PlayerMapYMovePrev = PlayerMapYMovePrev - 62355 end
		
		local PlayerXCameraTemp = PlayerMapXMovePrev - PlayerMapXMove
		local PlayerYCameraTemp = PlayerMapYMovePrev - PlayerMapYMove
		
		--Animate left movement
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
		--	console:createBuffer("Moving up.")
			
		--Animate up movement
		elseif PlayerYCameraTemp < 0 then
			PlayerYCamera = PlayerYCamera + PlayerYCameraTemp
		--	console:createBuffer("Moving down.")
		else
			PlayerYCamera = 0
		end
		
end


function DrawChars()
	if EnableScript == true then
		NoPlayersIfScreen()
		if ScreenData == 1 then
				--Make sure the sprites are loaded
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
		local FinalMapX = MapX * 16 + PlayerXCamera
		local FinalMapY = MapY * 16 + PlayerYCamera
		
		--Freeze position of player character until after animation
		if PlayerXCamera == 0 then PlayerX = PlayerMapX * 16 end
		if PlayerYCamera == 0 then PlayerY = PlayerMapY * 16 end
		--Screen size (take into account movement)
		local MinX = PlayerMapX - 7
		local MaxX = PlayerMapX + 7
		local MinY = PlayerMapY - 5
		local MaxY = PlayerMapY + 5
		FinalMapX = FinalMapX + NewMapXPos - PlayerX + 112
		FinalMapY = FinalMapY + NewMapYPos - PlayerY + 56
		
		--Flip sprite if facing right
		local FacingTemp = Facing
		if FacingTemp == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
		
	--	console:createBuffer("Attempting to create player 1. X: " .. MapX .. " Y: " .. MapY)
		if not ((NewMapX > MaxX or NewMapX < MinX) or (NewMapY > MaxY or NewMapY < MinY) or (MapX > MaxX or MapX < MinX) or (MapY > MaxY or MapY < MinY)) then 
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
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2176)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
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
		local FinalMapX = MapX2 * 16 + PlayerXCamera
		local FinalMapY = MapY2 * 16 + PlayerYCamera
		
		
		--Freeze position of player character until after animation
		if PlayerXCamera == 0 then PlayerX2 = PlayerMapX * 16 end
		if PlayerYCamera == 0 then PlayerY2 = PlayerMapY * 16 end
		--Screen size (take into account movement)
		local MinX = PlayerMapX - 7
		local MaxX = PlayerMapX + 7
		local MinY = PlayerMapY - 5
		local MaxY = PlayerMapY + 5
		FinalMapX = FinalMapX + NewMapX2Pos - PlayerX2 + 112
		FinalMapY = FinalMapY + NewMapY2Pos - PlayerY2 + 56
		
		--Flip sprite if facing right
		local FacingTemp = Facing2
		if FacingTemp == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
	--	if TempVar2 == 0 then console:createBuffer("Player 2 New Map X: " .. NewMapX2 .. "Player 2 New Map Y: " .. NewMapY2 .. "Player 2 MapX: " .. MapX2 .. "Player 2 MapY: " .. MapY2) end
		if not ((NewMapX2 > MaxX or NewMapX2 < MinX) or (NewMapY2 > MaxY or NewMapY2 < MinY) or (MapX2 > MaxX or MapX2 < MinX) or (MapY2 > MaxY or MapY2 < MinY)) then 
			
			if Player2Vis == 1 then
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, 2184)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
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
				emu:write16(PlayerExtra1Address, 2192)
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
				emu:write16(PlayerExtra1Address, 2200)
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

function ReceiveData(Clientell)
			if EnableScript == true then
			--Check if anybody wants to connect
				if (Clientell:hasdata()) then
					local ReadData = Clientell:receive(64)
				
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
					Connection1TempVar4 = string.sub(ReadData,17,17)
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
					
					if ConfirmEncrypt ~= 0 and (Player1FacingTemp == ConfirmEncrypt) then
						--Set connection type to var
							ReturnConnectionType = ConnectionTypeTemp
						
						
						--GPOS
						if ConnectionTypeTemp == "GPOS" then
				--			if PlayerIDTemp == 1 then
				--				MapX = tonumber(Player1XTemp)
				--				MapY = tonumber(Player1YTemp)
				--				Facing = tonumber(Player1FacingTemp)
				--				PlayerExtra1 = tonumber(Player1ExtraTemp)
				--				Player1Vis = tonumber(Player1VisibleTemp)
				--			end
							if Player2ID ~= "None" and PlayerIDTemp == 2 then
								timeout1 = timeoutmax
								NewMapX2 = tonumber(Player2XTemp)
								NewMapY2 = tonumber(Player2YTemp)
						--		Facing2 = tonumber(Player2FacingTemp)
								Player2Extra1 = tonumber(Player2ExtraTemp1)
								Player2Extra2 = tonumber(Player2ExtraTemp2)
								FixPositionPlayer2()
								MapID2 = tonumber(MapIDTemp)
								if MapID2 ~= NewMap2 then
									MapX2 = NewMapX2
									MapY2 = NewMapY2
								end
								NewMap2 = MapID2
							end
							if Player3ID ~= "None" and PlayerIDTemp == 3 then
							end
							if Player4ID ~= "None" and PlayerIDTemp == 4 then
							end
						end
						--TIME
			--			if ConnectionTypeTemp == "TIME" then
			--				if PlayerTempVar1 == 2 then
			--					timeout1 = 5
			--				elseif PlayerTempVar1 == 3 then
			--					timeout2 = 5
			--				elseif PlayerTempVar1 == 4 then
			--					timeout3 = 5
			--				end
			--			end
						
						
						--If nickname doesn't already exist on server and request to join
						if ConnectionTypeTemp == "JOIN" then
						
						--	if (NicknameTemp ~= None) then if (NicknameTemp ~= Player2ID and NicknameTemp ~= Player3ID  and NicknameTemp ~= Player4ID) then
							if (NicknameTemp ~= None) then
								if (NicknameTemp ~= Player2ID) then
									console:createBuffer("Player " .. NicknameTemp .. " has successfully connected.")
									if Connected == 0 then Connected = 1 end
									if Player2ID == "None" then
											Player2ID = NicknameTemp
											Player2 = Clientell
											Player2Vis = 1
											SendData("NewPlayer2", Player2)
											timeout1 = timeoutmax
							--4 Player Support in the future, too unstable now and need to add many more things first
							--		elseif Player3ID == "None" then
							--				Player3ID = NicknameTemp
							--				Player3 = Clientell
							--				Player3Vis = 1
							--				SendData("NewPlayer3", Player3)
							--				timeout2 = timeoutmax
							--		elseif Player4ID == "None" then
							--				Player4ID = NicknameTemp
							--				Player4 = Clientell
							--				Player4Vis = 1
							--				SendData("NewPlayer4", Player4)
							--				timeout3 = timeoutmax
									else
										console:createBuffer("A player was unable to join due to capacity limit.")
										SendData("DENY", Clientell)
									end
								else
									console:createBuffer("This player is already in the game!")
								end
							
							end
				--	else
				--		console:createBuffer("INVALID PACKAGE: " .. ReadData)
					end
				end
			end
		end
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
	local Player1VisTemp = Player1Vis
	local Player2VisTemp = Player2Vis
	local Player3VisTemp = Player3Vis
	local Player4VisTemp = Player4Vis
	if RequestTemp == "SPO2" then
		Player1VisTemp = string.sub(PackettTemp,1,1)
		Player2VisTemp = string.sub(PackettTemp,2,2)
		Player3VisTemp = string.sub(PackettTemp,3,3)
		Player4VisTemp = string.sub(PackettTemp,4,4)
		RequestTemp = "SPOS"
	--	console:createBuffer("SPO2 RECEIVED! Sending to " .. TempVar1 .. " Map 1: " .. MapID .. " Map 2: " .. MapID2 .. " Vars: " .. PackettTemp )
	end
	Packett =  GameID .. Nickname .. PlayerID .. RequestTemp .. PackettTemp .. MapX .. MapY .. Facing .. Player1VisTemp .. MapX2 .. MapY2 .. Facing2 .. Player2VisTemp .. MapX3 .. MapY3 .. Facing3 .. Player3VisTemp .. MapX4 .. MapY4 .. Facing4 .. Player4VisTemp .. PlayerExtra1 .. PlayerExtra2 .. Player2Extra1 .. Player2Extra2 .. Player3Extra1 .. Player3Extra2 .. Player4Extra1 .. Player4Extra2 .. PlayerMapID .. Facing
	FixAllPositions()
end

function SendData(DataType, Socket)
	--If you have made a server
	if (DataType == "NewPlayer2") then
		console:createBuffer("Request accepted!")
		CreatePackett("STRT", "2000")
		Socket:send(Packett)
	elseif (DataType == "NewPlayer3") then
		console:createBuffer("Request accepted!")
		CreatePackett("STRT", "3000")
		Socket:send(Packett)
	elseif (DataType == "NewPlayer4") then
		console:createBuffer("Request accepted!")
		CreatePackett("STRT", "4000")
		Socket:send(Packett)
	elseif (DataType == "DENY") then
		CreatePackett("DENY", "1000")
		Socket:send(Packett)
	elseif (DataType == "KICK") then
		CreatePackett("KICK", "1000")
		Socket:send(Packett)
	elseif (DataType == "GPos") then
		CreatePackett("GPOS", "1000")
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
		if MapID2 == PlayerMapID then Player1Visibility = 1 end
		if MapID2 == MapID2 then Player2Visibility = 1 end
		if MapID2 == MapID3 then Player3Visibility = 1 end
		if MapID2 == MapID4 then Player4Visibility = 1 end
		Player1Visibility = Player1Visibility .. Player2Visibility .. Player3Visibility .. Player4Visibility
		CreatePackett("SPO2", Player1Visibility )
		elseif TempVar1 == "Player 3" then
		if MapID3 == PlayerMapID then Player1Visibility = 1 end
		if MapID3 == MapID2 then Player2Visibility = 1 end
		if MapID3 == MapID3 then Player3Visibility = 1 end
		if MapID3 == MapID4 then Player4Visibility = 1 end
		Player1Visibility = Player1Visibility .. Player2Visibility .. Player3Visibility .. Player4Visibility
		CreatePackett("SPO2", Player1Visibility )
		elseif TempVar1 == "Player 4" then
		if MapID4 == PlayerMapID then Player1Visibility = 1 end
		if MapID4 == MapID2 then Player2Visibility = 1 end
		if MapID4 == MapID3 then Player3Visibility = 1 end
		if MapID4 == MapID4 then Player4Visibility = 1 end
		Player1Visibility = Player1Visibility .. Player2Visibility .. Player3Visibility .. Player4Visibility
		CreatePackett("SPO2", Player1Visibility )
		else
		CreatePackett("SPOS", "1000")
		end
		--Dummy packett
	--	CreatePackett("DMMY", "1000")
		Socket:send(Packett)
	elseif (DataType == "Request") then
		CreatePackett("JOIN", "1000")
		Socket:send(Packett)
	end
end

function HidePlayers()
		Player2Vis = 0
		Player3Vis = 0
		Player4Vis = 0
		MapID2 = tonumber(MapID2)
		MapID3 = tonumber(MapID3)
		MapID4 = tonumber(MapID4)
		if PlayerMapID == MapID2 then Player2Vis = 1 end
		if PlayerMapID == MapID3 then Player3Vis = 1 end
		if PlayerMapID == MapID4 then Player4Vis = 1 end
end


function ConnectNetwork()
	--To prevent package overrunning, sending will be every 20 frames, unlike recieve, which is every frame
	--Send timer
	local SendTimer = ScriptTime % 8
	--Receive timer
	local ReceiveTimer = ScriptTime % 1
	
	--If you have made a server
	if (MasterClient == "h") then
		
		if ReceiveTimer == 0 then
		--Receive data
		local PlayerData = SocketMain:accept()
		if timeout1 > 0 then timeout1 = timeout1 - 1 end
		if timeout2 > 0 then timeout2 = timeout2 - 1 end
		if timeout3 > 0 then timeout3 = timeout3 - 1 end
		if (PlayerData ~= nil) then ReceiveData(PlayerData) end
		if Player2ID ~= "None" then ReceiveData(Player2) end
		if Player3ID ~= "None" then ReceiveData(Player3) end
		if Player4ID ~= "None" then ReceiveData(Player4) end
		if Player2ID ~= "None" then if timeout1 == 0 then console:createBuffer("Player 2 has been disconnected due to timeout") Player2ID = "None" end end
		if Player3ID ~= "None" then if timeout2 == 0 then console:createBuffer("Player 3 has been disconnected due to timeout") Player3ID = "None" end end
		if Player4ID ~= "None" then if timeout3 == 0 then console:createBuffer("Player 4 has been disconnected due to timeout") Player4ID = "None" end end
		end
		

		--Request and send positions from all players
		if SendTimer == 0 then 
		if Player2ID ~= "None" then SendData("GPos", Player2) end
		if Player3ID ~= "None" then SendData("GPos", Player3) end
		if Player4ID ~= "None" then SendData("GPos", Player4) end
		--Hide players after GPOS
		HidePlayers()
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


function mainLoop()
	ScriptTime = ScriptTime + 1
	if initialized == 0 and EnableScript == true then
		initialized = 1
		GetPosition()
		if Nickname == "" then Nickname = RandomizeNickname() console:createBuffer("Nickname is now " .. Nickname) end
		if MasterClient == "a" then CreateNetwork() end
	elseif EnableScript == true then
			--Debugging
			TempVar2 = ScriptTime % DebugTime2
			local TempVarTimer = ScriptTime % DebugTime
			if TempVarTimer == 0 then
		--		console:createBuffer("Current Frame: " .. emu:currentFrame())
		--		console:createBuffer("Current X: " .. MapX .. " Current Y: " .. MapY)
		--		console:createBuffer("Master/Slave: " .. MasterClient .. " Nickname: " .. Nickname )
		--		console:createBuffer("MapID1: " .. MapID .. " MapID2: " .. MapID2)
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
				if MasterClient == "a" then CreateNetwork() end
			end
	end
end

SocketMain:add("received", ReceiveData)
--Player2:add("received", Player2Network)
--Player3:add("received", Player3Network)
--Player4:add("received", Player4Network)
callbacks:add("reset", GetNewGame)
callbacks:add("shutdown", shutdownGame)
callbacks:add("frame", mainLoop)
callbacks:add("frame", DrawChars)

console:createBuffer("The lua script 'PositionPlayer.lua' has been loaded")
if not (emu == nil) then
    GetGameVersion()
end