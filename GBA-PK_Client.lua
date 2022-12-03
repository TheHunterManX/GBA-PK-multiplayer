local IPAddress, Port = "127.0.0.1", 4096
local MaxPlayers = 4
local Nickname = ""




local GameID = ""
local GameCode = "None"
local ConfirmPackett = 0
local EnableScript = false
local ClientConnection

local u32 SpriteTempVar0 = 0
local u32 SpriteTempVar1 = 0

--Map ID
local u32 MapAddress = 0
local u32 MapAddress2 = 0
local PlayerID = 1
local PlayerID2 = 1001
local ScriptTime = 0
local ScriptTimePrev = 0
local initialized = 0
local ScriptTimeFrame = 4

--Internet Play
--local tcp = assert(socket.tcp())
local SocketMain = socket:tcp()
local Packett
local MasterClient = "a"
--timout = every connection attempt
local timeoutmax = 600
local ReturnConnectionType = ""
local FramesPS = 0



--MULTIPLAYER VARS
local PlayerReceiveID = 1000
local MultiplayerConsoleFlags = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local PlayerTalkingID = 0
local PlayerTalkingID2 = 1000
local Players = {socket:tcp(),socket:tcp(),socket:tcp(),socket:tcp(),socket:tcp(),socket:tcp(),socket:tcp(),socket:tcp()}
local PlayerIDNick = {"None","None","None","None","None","None","None","None"}
local timeout = {0,0,0,0,0,0,0,0}
local AnimationX = {0,0,0,0,0,0,0,0}
local AnimationY = {0,0,0,0,0,0,0,0}
local FutureX = {0,0,0,0,0,0,0,0}
local FutureY = {0,0,0,0,0,0,0,0}
local CurrentX = {0,0,0,0,0,0,0,0}
local CurrentY = {0,0,0,0,0,0,0,0}
local PreviousX = {0,0,0,0,0,0,0,0}
local PreviousY = {0,0,0,0,0,0,0,0}
local StartX = {2000,2000,2000,2000,2000,2000,2000,2000}
local StartY = {2000,2000,2000,2000,2000,2000,2000,2000}
local DifferentMapX = {0,0,0,0,0,0,0,0}
local DifferentMapY = {0,0,0,0,0,0,0,0}
local RelativeX = {0,0,0,0,0,0,0,0}
local RelativeY = {0,0,0,0,0,0,0,0}
local CurrentFacingDirection = {0,0,0,0,0,0,0,0}
local FutureFacingDirection = {0,0,0,0,0,0,0,0}
local CurrentMapID = {0,0,0,0,0,0,0,0}
local PreviousMapID = {0,0,0,0,0,0,0,0}
local MapEntranceType = {1,1,1,1,1,1,1,1}
local PlayerExtra1 = {0,0,0,0,0,0,0,0}
local PlayerExtra2 = {0,0,0,0,0,0,0,0}
local PlayerExtra3 = {0,0,0,0,0,0,0,0}
local PlayerExtra4 = {0,0,0,0,0,0,0,0}
local PlayerVis = {1,0,0,0,0,0,0,0}
local Facing2 = {0,0,0,0,0,0,0,0}
local MapID = {0,0,0,0,0,0,0,0}
local PrevMapID = {0,0,0,0,0,0,0,0}
local MapChange = {0,0,0,0,0,0,0,0}
local HasErasedPlayer = {false,false,false,false,false,false,false,false}
--Animation frames
local PlayerAnimationFrame = {0,0,0,0,0,0,0,0}
local PlayerAnimationFrame2 = {0,0,0,0,0,0,0,0}
local PlayerAnimationFrameMax = {0,0,0,0,0,0,0,0}
local PreviousPlayerAnimation = {0,0,0,0,0,0,0,0}

--PLAYER VARS
local CameraX = 0
local CameraY = 0
local PlayerMapXMovePrev = 0
local PlayerMapYMovePrev = 0
local PlayerX = 0
local PlayerY = 0
local PlayerMapID = 0
local PlayerMapIDPrev = 0
local PlayerMapEntranceType = 1
local PlayerDirection = 0
local PreviousPlayerDirection = 0
local PlayerMapChange = 0
local PreviousPlayerX = 0
local PreviousPlayerY = 0
local PlayerFacing = 0
local DifferentMapXPlayer = 0
local DifferentMapYPlayer = 0


--Addresses
local u32 PlayerAddress = {0,0,0,0}


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
local TradeVars = {0,0,0,0,"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"}
local EnemyTradeVars = {0,0,0,0,0}
local BattleVars = {0,0,0,0,0,0,0,0,0,0,0}
local EnemyBattleVars = {0,0,0,0,0,0,0,0,0,0,0}
local BufferVars = {0,0,0}
TradeVars[5] = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"


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
	 
	 ScriptTime = 0
	 initialized = 0

--Server Switches

--If 0 then don't render players
	ScreenData = 0
	
	for i = 1, MaxPlayers do
		 PlayerVis[i] = 0
		 MultiplayerConsoleFlags[i] = 0
		 HasErasedPlayer[i] = false
	end

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
--IsBiking is temporary and is used for drawing the extra symbol
function createChars(StartAddressNo, SpriteID, SpriteNo, IsBiking)
	local Chardata = 0
	--0 = Tile 190, 1 = Tile 185, etc...
	--Tile number 190 = Player1
	--Tile number 185 = Player2
	--Tile number 180 = Player3
	--Tile number 175 = Player4
	--First will be the 4 bytes, or 32 bits
	--SpriteID means a sprite from the chart below
	--1 = Side Left (Right must be set with facing variable)
	--3 = Side Down
	--2 = Side Up
	--4-9 = Walking
	--10-12 = Biking Idle Positions
	--13-18 = Biking
	--19-21 = Running Idle Positions
	--22-27 = Running
	--28-33 = Surfing stuff
	
	
	--Start address. 100745216 = 06014000 = 184th tile. can safely use 32.
	--CHANGE 100746752 = 190th tile = 2608
	--Because the actual data doesn't start until 06013850, we will skip 50 hexbytes, or 80 decibytes
	local ActualAddress = (100746752 - (StartAddressNo * 1280)) + 80
	if ScreenData ~= 0 then
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
		SpriteTempVar0 = ActualAddress - 20 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 16
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 12 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 8 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
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
		SpriteTempVar0 = ActualAddress - 20 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 16
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 12 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 8 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
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
		SpriteTempVar0 = ActualAddress - 20 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 16
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 12 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 8 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
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
		SpriteTempVar0 = ActualAddress - 20 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 16
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 12 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 8 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
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
		SpriteTempVar0 = ActualAddress - 20 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 16
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 12 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 8 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
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
		SpriteTempVar0 = ActualAddress - 20 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 16
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 12 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 8 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
		SpriteTempVar0 = ActualAddress - 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1)
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
		--Gender Neutral Sprites
	elseif SpriteNo == 2 then
		--Battle Icon 1
		if SpriteID == 1 then
		SpriteTempVar0 = ActualAddress + 256 + (IsBiking * 256) - 80
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65280
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1023744
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16379904
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262078464
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4193255424
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 2667577344
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 0
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1044480
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1023744
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 63984
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 3999
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 249
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 15
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 4193320704
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 262143744
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16773120
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 268435200
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 267452400
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
 		SpriteTempVar1 = 1044729
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048479
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 65520
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 1048575
		emu:write32(SpriteTempVar0, SpriteTempVar1) 
		SpriteTempVar0 = SpriteTempVar0 + 4 
 		SpriteTempVar1 = 16773375
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
		end
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
					NickNameNum = string.sub(PlayerIDNick[PlayerTalkingID],i,i)
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
				ScriptAddressTemp = Buffer2
				ScriptAddressTemp1 = Buffer[1]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer2 + 1
				ScriptAddressTemp1 = Buffer[2]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer2 + 2
				ScriptAddressTemp1 = Buffer[3]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer2 + 3
				ScriptAddressTemp1 = Buffer[4]
				emu:write8(ScriptAddressTemp, ScriptAddressTemp1)
				ScriptAddressTemp = Buffer2 + 4
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

function SendMultiplayerPackets(Offset, size)
	local Packet = ""
	local ModifiedSize = 0
	local ModifiedLoop = 0
	local ModifiedLoop2 = 0
	local PacketAmount = 0
	--Using RAM 0263DE00 for packets, as it seems free. If not, will modify later
	if Offset == 0 then Offset = 40099328 end
	local ModifiedRead = ""
	if size > 0 then
		CreatePackettSpecial("SLNK",size)
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
					SocketMain:send(Packet)
		--			ConsoleForText:print("Packet sent! Packet " .. Packet .. " end. Amount of loops: " .. ModifiedLoop2 .. " " .. Offset)
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

function ReceiveMultiplayerPackets(size)
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
			Packet = SocketMain:receive(60)
			ModifiedLoop = 20
			ModifiedLoop2 = 0
	--		ConsoleForText:print("Packet number: " .. PacketAmount)
		elseif ModifiedSize <= 20 and ModifiedLoop == 0 then
			PacketAmount = PacketAmount + 1
			SizeMod = ModifiedSize * 3
			Packet = SocketMain:receive(SizeMod)
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
		
		--If both players have not gone
		if BattleVars[6] == 0 then
			--You have not decided on a move
			if BattleVars[4] >= 2 and EnemyBattleVars[4] ~= 4 then
				--Pause until other player has made a move
				if BattleVars[12] < 32 then
					BattleVars[12] = BattleVars[12] + 32
					emu:write8(33700808, BattleVars[12])
				end
			elseif BattleVars[4] >= 4 and EnemyBattleVars[4] >= 4 then
				if BattleVars[12] >= 32 then
					BattleVars[12] = BattleVars[12] - 32
					emu:write8(33700808, BattleVars[12])
				end
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
				ConsoleForText:advance(1)
				ConsoleForText:print("First")
			elseif BattleVars[7] == 1 then
			end
		--You go second
			local TurnTime = emu:read8(33700834)
		elseif BattleVars[6] == 2 then
			--Write speed to 1
			emu:write16(33700830, 1)
			if BattleVars[7] == 0 then
				BattleVars[7] = 1
			--	BattleVars[13] = ReadBuffers()
				ConsoleForText:print("Second")
			elseif BattleVars[7] == 1 then
			end
		end
	end
	
	--Prevent item use
	if BattleVars[1] >= 2 and BattleVars[2] == 1 then emu:write8(33696589, 1)
	else emu:write8(33696589, 0)
	end
	
	--Unlock once battle ends
	if BattleVars[1] >= 2 and BattleVars[3] == 1 then LockFromScript = 0 end
	
	
	if SendTimer == 0 then CreatePackettSpecial("BATT") end
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
	
	
	
	if TradeVars[1] == 0 and TradeVars[4] == 0 and TradeVars[3] == 0 and EnemyTradeVars[3] == 0 then
		OtherPlayerHasCancelled = 0
		TradeVars[3] = 1
		Loadscript(4)
	elseif TradeVars[1] == 0 and TradeVars[4] == 0 and TradeVars[3] == 0 and EnemyTradeVars[3] > 0 then
		TradeVars[3] = 1
		TradeVars[4] = 1
		Loadscript(14)
	elseif TradeVars[1] == 0 and TradeVars[4] == 0 and EnemyTradeVars[3] > 0 and TradeVars[3] > 0 then
		TradeVars[4] = 1
		Loadscript(14)

--	if TempVar2 == 0 then ConsoleForText:print("1: " .. TradeVars[1] .. " 8001: " .. Var8000[2] .. " OtherPlayerHasCancelled: " .. OtherPlayerHasCancelled .. " EnemyTradeVars[1]: " .. EnemyTradeVars[1]) end

	--Text is finished before trade
	elseif Var8000[2] ~= 0 and TradeVars[4] == 1 and TradeVars[1] == 0 then
		TradeVars[1] = 1
		TradeVars[2] = 0
		TradeVars[3] = 0
		TradeVars[4] = 0
		Var8000[1] = 0
		Var8000[2] = 0
		Loadscript(12)
	
	--You have canceled or have not selected a valid pokemon slot
	elseif Var8000[2] == 1 and TradeVars[1] == 1 then
		Loadscript(16)
		SendData("CTRA")
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
			SendData("ROFF")
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
				TradeVars[2] = 0
				Loadscript(4)
				TradeVars[1] = 4
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
	
	if SendTimer == 0 then CreatePackettSpecial("TRAD") end
end

function RenderPlayersOnDifferentMap()
	--if MapChange[1] ~= 0 then console:log("MAP CHANGE PLAYER 1") MapChange[1] = 0 end
	--if MapChange[2] ~= 0 then console:log("MAP CHANGE PLAYER 2") MapChange[2] = 0 end
	for i = 1, MaxPlayers do
		if PlayerID ~= i and PlayerIDNick[i] ~= "None" then
			if PlayerMapID == CurrentMapID[i] then
				PlayerVis[i] = 1
				DifferentMapX[i] = 0
				DifferentMapY[i] = 0
				MapChange[i] = 0
			elseif (PlayerMapIDPrev == CurrentMapID[i] or PlayerMapID == PreviousMapID[i]) and MapEntranceType[i] == 0 then
				PlayerVis[i] = 1
				if MapChange[i] == 1 then
					DifferentMapX[i] = ((PreviousX[i] - StartX[i]) * 16)
					DifferentMapY[i] = ((PreviousY[i] - StartY[i]) * 16)
				end
			else
				PlayerVis[i] = 0
				DifferentMapX[i] = 0
				DifferentMapY[i] = 0
				MapChange[i] = 0
			end
		end
	end
end

function GetPosition()
	local u32 BikeAddress = 0
	local u32 MapAddress = 0
	local u32 PrevMapIDAddress = 0
	local u32 ConnectionTypeAddress = 0
	local u32 PlayerXAddress = 0
	local u32 PlayerYAddress = 0
	local u32 PlayerFaceAddress = 0
	local Bike = 0
	if GameID == "BPR1" or GameID == "BPR2" then
		--Addresses for Firered
		PlayerXAddress = 33779272
		PlayerYAddress = 33779274
		PlayerFaceAddress = 33779284
		MapAddress = 33813416
		BikeAddress = 33687112
		PrevMapIDAddress = 33813418
		ConnectionTypeAddress = 33785351
		Bike = emu:read16(BikeAddress)
		if Bike > 3000 then Bike = Bike - 3352 end
	elseif GameID == "BPG1" or GameID == "BPG2" then
		--Addresses for Leafgreen
		PlayerXAddress = 33779272
		PlayerYAddress = 33779274
		PlayerFaceAddress = 33779284
		MapAddress = 33813416
		BikeAddress = 33687112
		PrevMapIDAddress = 33813418
		ConnectionTypeAddress = 33785351
		Bike = emu:read16(BikeAddress)
		if Bike > 3000 then Bike = Bike - 3320 end
	end
	PlayerFacing = emu:read8(PlayerFaceAddress)
	Facing2[PlayerID] = PlayerFacing + 100
	--Prev map
	PlayerMapIDPrev = emu:read16(PrevMapIDAddress)
	PlayerMapIDPrev = PlayerMapIDPrev + 100000
	if PlayerMapIDPrev == PlayerMapID then
		PreviousX[PlayerID] = CurrentX[PlayerID]
		PreviousY[PlayerID] = CurrentY[PlayerID]
		PlayerMapEntranceType = emu:read8(ConnectionTypeAddress)
		if PlayerMapEntranceType > 10 then PlayerMapEntranceType = 9 end
		PlayerMapChange = 1
		MapChange[PlayerID] = 1
	end
	PlayerMapID = emu:read16(MapAddress)
	PlayerMapID = PlayerMapID + 100000
	PlayerMapX = emu:read16(PlayerXAddress)
	PlayerMapY = emu:read16(PlayerYAddress)
	PlayerMapX = PlayerMapX + 2000
	PlayerMapY = PlayerMapY + 2000
		
	CurrentX[PlayerID] = PlayerMapX
	CurrentY[PlayerID] = PlayerMapY
--	console:log("X: " .. CurrentX[PlayerID])
	--Male Firered Sprite from 1.0, 1.1, and leafgreen
	if ((Bike == 160 or Bike == 272) or (Bike == 128 or Bike == 240)) then
		PlayerExtra2[PlayerID] = 0
		PlayerExtra3[PlayerID] = 0
	--	if TempVar2 == 0 then ConsoleForText:print("Male on Foot") end
	--Male Firered Biking Sprite
	elseif (Bike == 320 or Bike == 432 or Bike == 288 or Bike == 400) then
		PlayerExtra2[PlayerID] = 0
		PlayerExtra3[PlayerID] = 1
	--	if TempVar2 == 0 then ConsoleForText:print("Male on Bike") end
	--Male Firered Surfing Sprite
	elseif (Bike == 624 or Bike == 736 or Bike == 592 or Bike == 704) then
		PlayerExtra2[PlayerID] = 0
		PlayerExtra3[PlayerID] = 2
	--Female sprite
	elseif ((Bike == 392 or Bike == 504) or (Bike == 360 or Bike == 472)) then
		PlayerExtra2[PlayerID] = 1
		PlayerExtra3[PlayerID] = 0
	--	if TempVar2 == 0 then ConsoleForText:print("Female on Foot") end
	--Female Biking sprite
	elseif ((Bike == 552 or Bike == 664) or (Bike == 520 or Bike == 632)) then
		PlayerExtra2[PlayerID] = 1
		PlayerExtra3[PlayerID] = 1
	--	if TempVar2 == 0 then ConsoleForText:print("Female on Bike") end
	--Female Firered Surfing Sprite
	elseif (Bike == 720 or Bike == 832 or Bike == 688 or Bike == 800) then
		PlayerExtra2[PlayerID] = 1
		PlayerExtra3[PlayerID] = 2
	else
	--If in bag when connecting will automatically be firered male
	--	if TempVar2 == 0 then ConsoleForText:print("Bag/Unknown") end
	end
	if PlayerExtra1[PlayerID] ~= 0 then PlayerExtra1[PlayerID] = PlayerExtra1[PlayerID] - 100
	else PlayerExtra1[PlayerID] = 0
	end
	if PlayerExtra3[PlayerID] == 2 then
		PreviousPlayerDirection = PlayerDirection
		--Facing
		if PlayerFacing == 0 then PlayerExtra1[PlayerID] = 33 PlayerDirection = 4 end
		if PlayerFacing == 1 then PlayerExtra1[PlayerID] = 34 PlayerDirection = 3 end
		if PlayerFacing == 2 then PlayerExtra1[PlayerID] = 35 PlayerDirection = 1 end
		if PlayerFacing == 3 then PlayerExtra1[PlayerID] = 36 PlayerDirection = 2 end
		--Surfing
		if PlayerFacing == 29 then PlayerExtra1[PlayerID] = 37 PlayerDirection = 4 end
		if PlayerFacing == 30 then PlayerExtra1[PlayerID] = 38 PlayerDirection = 3 end
		if PlayerFacing == 31 then PlayerExtra1[PlayerID] = 39 PlayerDirection = 1 end
		if PlayerFacing == 32 then PlayerExtra1[PlayerID] = 40 PlayerDirection = 2 end
		--Turning
		if PlayerFacing == 41 then PlayerExtra1[PlayerID] = 33 PlayerDirection = 4 end
		if PlayerFacing == 42 then PlayerExtra1[PlayerID] = 34 PlayerDirection = 3 end
		if PlayerFacing == 43 then PlayerExtra1[PlayerID] = 35 PlayerDirection = 1 end
		if PlayerFacing == 44 then PlayerExtra1[PlayerID] = 36 PlayerDirection = 2 end
		--hitting a wall
		if PlayerFacing == 33 then PlayerExtra1[PlayerID] = 33 PlayerDirection = 4 end
		if PlayerFacing == 34 then PlayerExtra1[PlayerID] = 34 PlayerDirection = 3 end
		if PlayerFacing == 35 then PlayerExtra1[PlayerID] = 35 PlayerDirection = 1 end
		if PlayerFacing == 36 then PlayerExtra1[PlayerID] = 36 PlayerDirection = 2 end
		--getting on pokemon
		if PlayerFacing == 70 then PlayerExtra1[PlayerID] = 37 PlayerDirection = 4 end
		if PlayerFacing == 71 then PlayerExtra1[PlayerID] = 38 PlayerDirection = 3 end
		if PlayerFacing == 72 then PlayerExtra1[PlayerID] = 39 PlayerDirection = 1 end
		if PlayerFacing == 73 then PlayerExtra1[PlayerID] = 40 PlayerDirection = 2 end
		--getting off pokemon
		if PlayerFacing == 166 then PlayerExtra1[PlayerID] = 5 PlayerDirection = 4 end
		if PlayerFacing == 167 then PlayerExtra1[PlayerID] = 6 PlayerDirection = 3 end
		if PlayerFacing == 168 then PlayerExtra1[PlayerID] = 7 PlayerDirection = 1 end
		if PlayerFacing == 169 then PlayerExtra1[PlayerID] = 8 PlayerDirection = 2 end
		--calling pokemon out
		if PlayerFacing == 69 then PlayerExtra1[PlayerID] = 33 PlayerDirection = 4 end
		
		if ScreenData == 0 then
			if PlayerDirection == 4 then PlayerExtra1[PlayerID] = 33 PlayerFacing = 0 end
			if PlayerDirection == 3 then PlayerExtra1[PlayerID] = 34 PlayerFacing = 1 end
			if PlayerDirection == 1 then PlayerExtra1[PlayerID] = 35 PlayerFacing = 2 end
			if PlayerDirection == 2 then PlayerExtra1[PlayerID] = 36 PlayerFacing = 3 end
		end
	elseif PlayerExtra3[PlayerID] == 1 then
		if PlayerFacing == 0 then PlayerExtra1[PlayerID] = 17 PlayerDirection = 4 end
		if PlayerFacing == 1 then PlayerExtra1[PlayerID] = 18 PlayerDirection = 3 end
		if PlayerFacing == 2 then PlayerExtra1[PlayerID] = 19 PlayerDirection = 1 end
		if PlayerFacing == 3 then PlayerExtra1[PlayerID] = 20 PlayerDirection = 2 end
		--Standard speed
		if PlayerFacing == 49 then PlayerExtra1[PlayerID] = 21 PlayerDirection = 4 end
		if PlayerFacing == 50 then PlayerExtra1[PlayerID] = 22 PlayerDirection = 3 end
		if PlayerFacing == 51 then PlayerExtra1[PlayerID] = 23 PlayerDirection = 1 end
		if PlayerFacing == 52 then PlayerExtra1[PlayerID] = 24 PlayerDirection = 2 end
		--In case you use a fast bike
		if PlayerFacing == 61 then PlayerExtra1[PlayerID] = 25 PlayerDirection = 4 end
		if PlayerFacing == 62 then PlayerExtra1[PlayerID] = 26 PlayerDirection = 3 end
		if PlayerFacing == 63 then PlayerExtra1[PlayerID] = 27 PlayerDirection = 1 end
		if PlayerFacing == 64 then PlayerExtra1[PlayerID] = 28 PlayerDirection = 2 end
		--hitting a wall
		if PlayerFacing == 37 then PlayerExtra1[PlayerID] = 29 PlayerDirection = 4 end
		if PlayerFacing == 38 then PlayerExtra1[PlayerID] = 30 PlayerDirection = 3 end
		if PlayerFacing == 39 then PlayerExtra1[PlayerID] = 31 PlayerDirection = 1 end
		if PlayerFacing == 40 then PlayerExtra1[PlayerID] = 32 PlayerDirection = 2 end
		
		--calling pokemon out
		if PlayerFacing == 69 then PlayerExtra1[PlayerID] = 1 PlayerDirection = 4 end
		
		if ScreenData == 0 then
			if PlayerDirection == 4 then PlayerExtra1[PlayerID] = 17 PlayerFacing = 0 end
			if PlayerDirection == 3 then PlayerExtra1[PlayerID] = 18 PlayerFacing = 1 end
			if PlayerDirection == 1 then PlayerExtra1[PlayerID] = 19 PlayerFacing = 2 end
			if PlayerDirection == 2 then PlayerExtra1[PlayerID] = 20 PlayerFacing = 3 end
		end
	else
		--Standing still
		if PlayerFacing == 0 then PlayerExtra1[PlayerID] = 1 PlayerDirection = 4 end
		if PlayerFacing == 1 then PlayerExtra1[PlayerID] = 2 PlayerDirection = 3 end
		if PlayerFacing == 2 then PlayerExtra1[PlayerID] = 3 PlayerDirection = 1 end
		if PlayerFacing == 3 then PlayerExtra1[PlayerID] = 4 PlayerDirection = 2 end
		
		--Hitting stuff
		if PlayerFacing == 33 then PlayerExtra1[PlayerID] = 1 PlayerDirection = 4 end
		if PlayerFacing == 34 then PlayerExtra1[PlayerID] = 2 PlayerDirection = 3 end
		if PlayerFacing == 35 then PlayerExtra1[PlayerID] = 3 PlayerDirection = 1 end
		if PlayerFacing == 36 then PlayerExtra1[PlayerID] = 4 PlayerDirection = 2 end
		
		if PlayerFacing == 37 then PlayerExtra1[PlayerID] = 1 PlayerDirection = 4 end
		if PlayerFacing == 38 then PlayerExtra1[PlayerID] = 2 PlayerDirection = 3 end
		if PlayerFacing == 39 then PlayerExtra1[PlayerID] = 3 PlayerDirection = 1 end
		if PlayerFacing == 40 then PlayerExtra1[PlayerID] = 4 PlayerDirection = 2 end
		
		--Walking
		if PlayerFacing == 16 then PlayerExtra1[PlayerID] = 5 PlayerDirection = 4 end
		if PlayerFacing == 17 then PlayerExtra1[PlayerID] = 6 PlayerDirection = 3 end
		if PlayerFacing == 18 then PlayerExtra1[PlayerID] = 7 PlayerDirection = 1 end
		if PlayerFacing == 19 then PlayerExtra1[PlayerID] = 8 PlayerDirection = 2 end
		
		--Jumping over route
		if PlayerFacing == 20 then PlayerExtra1[PlayerID] = 13 PlayerDirection = 4 end
		if PlayerFacing == 21 then PlayerExtra1[PlayerID] = 14 PlayerDirection = 3 end
		if PlayerFacing == 22 then PlayerExtra1[PlayerID] = 15 PlayerDirection = 1 end
		if PlayerFacing == 23 then PlayerExtra1[PlayerID] = 16 PlayerDirection = 2 end
		--Turning
		if PlayerFacing == 41 then PlayerExtra1[PlayerID] = 9 PlayerDirection = 4 end
		if PlayerFacing == 42 then PlayerExtra1[PlayerID] = 10 PlayerDirection = 3 end
		if PlayerFacing == 43 then PlayerExtra1[PlayerID] = 11 PlayerDirection = 1 end
		if PlayerFacing == 44 then PlayerExtra1[PlayerID] = 12 PlayerDirection = 2 end
		--Running
		if PlayerFacing == 61 then PlayerExtra1[PlayerID] = 13 PlayerDirection = 4 end
		if PlayerFacing == 62 then PlayerExtra1[PlayerID] = 14 PlayerDirection = 3 end
		if PlayerFacing == 63 then PlayerExtra1[PlayerID] = 15 PlayerDirection = 1 end
		if PlayerFacing == 64 then PlayerExtra1[PlayerID] = 16 PlayerDirection = 2 end
		
		--calling pokemon out
		if PlayerFacing == 69 then PlayerExtra1[PlayerID] = 1 PlayerDirection = 4 end
		
		if ScreenData == 0 then
			if PlayerDirection == 4 then PlayerExtra1[PlayerID] = 1 PlayerFacing = 0 end
			if PlayerDirection == 3 then PlayerExtra1[PlayerID] = 2 PlayerFacing = 1 end
			if PlayerDirection == 1 then PlayerExtra1[PlayerID] = 3 PlayerFacing = 2 end
			if PlayerDirection == 2 then PlayerExtra1[PlayerID] = 4 PlayerFacing = 3 end
		end
		--	if Facing == 255 then PlayerExtra1 = 0 end
	end
	PlayerExtra1[PlayerID] = PlayerExtra1[PlayerID] + 100
	CurrentFacingDirection[PlayerID] = PlayerDirection
end


function NoPlayersIfScreen()
	local ScreenData1 = 0
	local ScreenData3 = 0
	local ScreenData4 = 0
	local u32 ScreenDataAddress1 = 0
	local u32 ScreenDataAddress3 = 0
	local u32 ScreenDataAddress4 = 0
	if GameID == "BPR1" or GameID == "BPR2" then
		--Address for Firered
		ScreenDataAddress1 = 33691280
		--For intro
		ScreenDataAddress3 = 33686716
		--Check for battle
		ScreenDataAddress4 = 33685514
	elseif GameID == "BPG1" or GameID == "BPG2" then
		--Address for Leafgreen
		ScreenDataAddress1 = 33691280
		--For intro
		ScreenDataAddress3 = 33686716
		--Check for battle
		ScreenDataAddress4 = 33685514
	end
		ScreenData1 = emu:read32(ScreenDataAddress1)
		ScreenData3 = emu:read8(ScreenDataAddress3)
		ScreenData4 = emu:read8(ScreenDataAddress4)
		
	--	if TempVar2 == 0 then ConsoleForText:print("ScreenData: " .. ScreenData1 .. " " .. ScreenData2 .. " " .. ScreenData3) end
		--If screen data are these then hide players
		if (ScreenData3 ~= 80 or (ScreenData1 > 0)) and (LockFromScript == 0 or LockFromScript == 8 or LockFromScript == 9) then
			ScreenData = 0
		--	console:log("SCREENDATA OFF: " .. LockFromScript)
		else
			ScreenData = 1
		--	console:log("SCREENDATA ON")
		end
		if ScreenData4 == 1 then
			PlayerExtra4[PlayerID] = 1
		else
			PlayerExtra4[PlayerID] = 0
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
		
	if CurrentX[PlayerNo] == 0 then CurrentX[PlayerNo] = FutureX[PlayerNo] end
	if CurrentY[PlayerNo] == 0 then CurrentY[PlayerNo] = FutureY[PlayerNo] end
	local AnimationMovementX = FutureX[PlayerNo] - CurrentX[PlayerNo]
	local AnimationMovementY = FutureY[PlayerNo] - CurrentY[PlayerNo]
	local Charpic = PlayerNo - 1
	local SpriteNumber = PlayerExtra2[PlayerNo]
			
	if PlayerAnimationFrame[PlayerNo] < 0 then PlayerAnimationFrame[PlayerNo] = 0 end
	PlayerAnimationFrame[PlayerNo] = PlayerAnimationFrame[PlayerNo] + 1
	
	--Animate left movement
	if AnimationMovementX < 0 then
	
			--Walk
		if AnimateID == 3 then
			PlayerAnimationFrameMax[PlayerNo] = 14
			AnimationX[PlayerNo] = AnimationX[PlayerNo] - 1
			if PlayerAnimationFrame[PlayerNo] == 5 then AnimationX[PlayerNo] = AnimationX[PlayerNo] - 1 end
			if PlayerAnimationFrame[PlayerNo] == 9 then AnimationX[PlayerNo] = AnimationX[PlayerNo] - 1 end
			if PlayerAnimationFrame[PlayerNo] >= 3 and PlayerAnimationFrame[PlayerNo] <= 11 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,4,SpriteNumber)
				else
				createChars(Charpic,5,SpriteNumber)
				end
			else
				createChars(Charpic,1,SpriteNumber)
			end
		--Run
		elseif AnimateID == 6 then
			PlayerAnimationFrameMax[PlayerNo] = 9
			AnimationX[PlayerNo] = AnimationX[PlayerNo] - 4
		--	ConsoleForText:print("Frame: " .. PlayerAnimationFrame)
			if PlayerAnimationFrame[PlayerNo] > 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,20,SpriteNumber)
				else
				createChars(Charpic,21,SpriteNumber)
				end
			else
				createChars(Charpic,19,SpriteNumber)
			end
		--Bike
		elseif AnimateID == 9 then
			PlayerAnimationFrameMax[PlayerNo] = 6
			AnimationX[PlayerNo] = AnimationX[PlayerNo] + ((AnimationMovementX*16)/3)
			if PlayerAnimationFrame[PlayerNo] >= 1 and PlayerAnimationFrame[PlayerNo] < 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,13,SpriteNumber)
				else
				createChars(Charpic,14,SpriteNumber)
				end
			else
				createChars(Charpic,10,SpriteNumber)
			end
		--Surf
		elseif AnimateID == 23 then
			PlayerAnimationFrameMax[PlayerNo] = 4
			AnimationX[PlayerNo] = AnimationX[PlayerNo] - 4
			createChars(Charpic,30,SpriteNumber)
			createChars(Charpic,36,SpriteNumber)
		else
		
		end
		
		--Animate right movement
		elseif AnimationMovementX > 0 then
		if AnimateID == 13 then
			PlayerAnimationFrameMax[PlayerNo] = 14
			AnimationX[PlayerNo] = AnimationX[PlayerNo] + 1
			if PlayerAnimationFrame[PlayerNo] == 5 then AnimationX[PlayerNo] = AnimationX[PlayerNo] + 1 end
			if PlayerAnimationFrame[PlayerNo] == 9 then AnimationX[PlayerNo] = AnimationX[PlayerNo] + 1 end
			if PlayerAnimationFrame[PlayerNo] >= 3 and PlayerAnimationFrame[PlayerNo] <= 11 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,4,SpriteNumber)
				else
				createChars(Charpic,5,SpriteNumber)
				end
			else
				createChars(Charpic,1,SpriteNumber)
			end
		elseif AnimateID == 14 then
		--	console:log("RUNNING RIGHT. FRAME: " .. PlayerAnimationFrame .. " FRAME2: " .. PlayerAnimationFrame2)
		--	ConsoleForText:print("Running")
			PlayerAnimationFrameMax[PlayerNo] = 9
			AnimationX[PlayerNo] = AnimationX[PlayerNo] + 4
			if PlayerAnimationFrame[PlayerNo] > 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,20,SpriteNumber)
				else
				createChars(Charpic,21,SpriteNumber)
				end
			else
				createChars(Charpic,19,SpriteNumber)
			end
		elseif AnimateID == 15 then
		--	ConsoleForText:print("Bike")
			PlayerAnimationFrameMax[PlayerNo] = 6
			AnimationX[PlayerNo] = AnimationX[PlayerNo] + ((AnimationMovementX*16)/3)
			if PlayerAnimationFrame[PlayerNo] >= 1 and PlayerAnimationFrame[PlayerNo] < 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,13,SpriteNumber)
				else
				createChars(Charpic,14,SpriteNumber)
				end
			else
				createChars(Charpic,10,SpriteNumber)
			end
		--Surf
		elseif AnimateID == 24 then
			PlayerAnimationFrameMax[PlayerNo] = 4
			AnimationX[PlayerNo] = AnimationX[PlayerNo] + 4
			createChars(Charpic,30,SpriteNumber)
			createChars(Charpic,36,SpriteNumber)
		else
		
		end
		else
		AnimationX[PlayerNo] = 0
		CurrentX[PlayerNo] = FutureX[PlayerNo]
		--Turn player left/right
		if AnimateID == 12 then
			PlayerAnimationFrameMax[PlayerNo] = 8
			if PlayerAnimationFrame[PlayerNo] > 1 and PlayerAnimationFrame[PlayerNo] < 6 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
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
			if PreviousPlayerAnimation[PlayerNo] ~= 19 then PlayerAnimationFrame2[PlayerNo] = 0 PlayerAnimationFrame[PlayerNo] = 24 end
			PlayerAnimationFrameMax[PlayerNo] = 48
			if PlayerAnimationFrame2[PlayerNo] == 0 then createChars(Charpic,30,SpriteNumber)
			elseif PlayerAnimationFrame2[PlayerNo] == 1 then createChars(Charpic,33,SpriteNumber)
			end
		elseif AnimateID == 20 then
			createChars(Charpic,36,SpriteNumber)
			if PreviousPlayerAnimation[PlayerNo] ~= 20 then PlayerAnimationFrame2[PlayerNo] = 0 PlayerAnimationFrame[PlayerNo] = 24 end
			PlayerAnimationFrameMax[PlayerNo] = 48
			if PlayerAnimationFrame2[PlayerNo] == 0 then createChars(Charpic,30,SpriteNumber)
			elseif PlayerAnimationFrame2[PlayerNo] == 1 then createChars(Charpic,33,SpriteNumber)
			end
		end
		end
		
		
		--Animate up movement
		if AnimationMovementY < 0 then
		if AnimateID == 2 then
			PlayerAnimationFrameMax[PlayerNo] = 14
			AnimationY[PlayerNo] = AnimationY[PlayerNo] - 1
			if PlayerAnimationFrame[PlayerNo] == 5 then AnimationY[PlayerNo] = AnimationY[PlayerNo] - 1 end
			if PlayerAnimationFrame[PlayerNo] == 9 then AnimationY[PlayerNo] = AnimationY[PlayerNo] - 1 end
			if PlayerAnimationFrame[PlayerNo] >= 3 and PlayerAnimationFrame[PlayerNo] <= 11 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,6,SpriteNumber)
				else
				createChars(Charpic,7,SpriteNumber)
				end	
			else
				createChars(Charpic,2,SpriteNumber)
			end
		elseif AnimateID == 5 then
			PlayerAnimationFrameMax[PlayerNo] = 9
			AnimationY[PlayerNo] = AnimationY[PlayerNo] - 4
			if PlayerAnimationFrame[PlayerNo] > 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,23,SpriteNumber)
				else
				createChars(Charpic,24,SpriteNumber)
				end
			else
				createChars(Charpic,22,SpriteNumber)
			end
		elseif AnimateID == 8 then
			PlayerAnimationFrameMax[PlayerNo] = 6
			AnimationY[PlayerNo] = AnimationY[PlayerNo] + ((AnimationMovementY*16)/3)
			if PlayerAnimationFrame[PlayerNo] >= 1 and PlayerAnimationFrame[PlayerNo] < 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,15,SpriteNumber)
				else
				createChars(Charpic,16,SpriteNumber)
				end
			else
				createChars(Charpic,11,SpriteNumber)
			end
		--Surf
		elseif AnimateID == 22 then
			PlayerAnimationFrameMax[PlayerNo] = 4
			AnimationY[PlayerNo] = AnimationY[PlayerNo] - 4
			createChars(Charpic,29,SpriteNumber)
			createChars(Charpic,35,SpriteNumber)
		end
			
		--Animate down movement
		elseif AnimationMovementY > 0 then
		if AnimateID == 1 then
			PlayerAnimationFrameMax[PlayerNo] = 14
			AnimationY[PlayerNo] = AnimationY[PlayerNo] + 1
			if PlayerAnimationFrame[PlayerNo] == 5 then AnimationY[PlayerNo] = AnimationY[PlayerNo] + 1 end
			if PlayerAnimationFrame[PlayerNo] == 9 then AnimationY[PlayerNo] = AnimationY[PlayerNo] + 1 end
			if PlayerAnimationFrame[PlayerNo] >= 3 and PlayerAnimationFrame[PlayerNo] <= 11 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,8,SpriteNumber)
				else
				createChars(Charpic,9,SpriteNumber)
				end
			else
				createChars(Charpic,3,SpriteNumber)
			end
		elseif AnimateID == 4 then
			PlayerAnimationFrameMax[PlayerNo] = 9
			AnimationY[PlayerNo] = AnimationY[PlayerNo] + 4
			if PlayerAnimationFrame[PlayerNo] > 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,26,SpriteNumber)
				else
				createChars(Charpic,27,SpriteNumber)
				end
			else
				createChars(Charpic,25,SpriteNumber)
			end
		elseif AnimateID == 7 then
			PlayerAnimationFrameMax[PlayerNo] = 6
			AnimationY[PlayerNo] = AnimationY[PlayerNo] + ((AnimationMovementY*16)/3)
			if PlayerAnimationFrame[PlayerNo] >= 1 and PlayerAnimationFrame[PlayerNo] < 5 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,17,SpriteNumber)
				else
				createChars(Charpic,18,SpriteNumber)
				end
			else
				createChars(Charpic,12,SpriteNumber)
			end
		--Surf
		elseif AnimateID == 21 then
			PlayerAnimationFrameMax[PlayerNo] = 4
			AnimationY[PlayerNo] = AnimationY[PlayerNo] + 4
			createChars(Charpic,28,SpriteNumber)
			createChars(Charpic,34,SpriteNumber)
		--If they are now equal
		end
		else
		AnimationY[PlayerNo] = 0
		CurrentY[PlayerNo] = FutureY[PlayerNo]
		--Turn player down
		if AnimateID == 10 then
			PlayerAnimationFrameMax[PlayerNo] = 8
			if PlayerAnimationFrame[PlayerNo] > 1 and PlayerAnimationFrame[PlayerNo] < 6 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,8,SpriteNumber)
				else
				createChars(Charpic,9,SpriteNumber)
				end
			else
				createChars(Charpic,3,SpriteNumber)
			end
		--Turn player up
		
		elseif AnimateID == 11 then
			PlayerAnimationFrameMax[PlayerNo] = 8
			if PlayerAnimationFrame[PlayerNo] > 1 and PlayerAnimationFrame[PlayerNo] < 6 then
				if PlayerAnimationFrame2[PlayerNo] == 0 then
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
			if PreviousPlayerAnimation[PlayerNo] ~= 17 then
				PlayerAnimationFrame2[PlayerNo] = 0
				PlayerAnimationFrame[PlayerNo] = 24
			end
			PlayerAnimationFrameMax[PlayerNo] = 48
			if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,28,SpriteNumber)
			elseif PlayerAnimationFrame2[PlayerNo] == 1 then
				createChars(Charpic,31,SpriteNumber)
			end
		elseif AnimateID == 18 then
			createChars(Charpic,35,SpriteNumber)
			if PreviousPlayerAnimation[PlayerNo] ~= 18 then
				PlayerAnimationFrame2[PlayerNo] = 0
				PlayerAnimationFrame[PlayerNo] = 24
			end
			PlayerAnimationFrameMax[PlayerNo] = 48
			if PlayerAnimationFrame2[PlayerNo] == 0 then
				createChars(Charpic,29,SpriteNumber)
			elseif PlayerAnimationFrame2[PlayerNo] == 1 then
				createChars(Charpic,32,SpriteNumber)
			end
		--If they are now equal
		end
	end
		
	if AnimateID == 251 then
		PlayerAnimationFrame[PlayerNo] = 0
		AnimationX[PlayerNo] = 0
		AnimationY[PlayerNo] = 0
		CurrentX[PlayerNo] = FutureX[PlayerNo]
		CurrentY[PlayerNo] = FutureY[PlayerNo]
	elseif AnimateID == 252 then
		PlayerAnimationFrame[PlayerNo] = 0
		AnimationX[PlayerNo] = 0
		AnimationY[PlayerNo] = 0
		CurrentX[PlayerNo] = FutureX[PlayerNo]
		CurrentY[PlayerNo] = FutureY[PlayerNo]
	elseif AnimateID == 253 then
		PlayerAnimationFrame[PlayerNo] = 0
		AnimationX[PlayerNo] = 0
		AnimationY[PlayerNo] = 0
		CurrentX[PlayerNo] = FutureX[PlayerNo]
		CurrentY[PlayerNo] = FutureY[PlayerNo]
	elseif AnimateID == 254 then
		PlayerAnimationFrame[PlayerNo] = 0
		AnimationX[PlayerNo] = 0
		AnimationY[PlayerNo] = 0
		CurrentX[PlayerNo] = FutureX[PlayerNo]
		CurrentY[PlayerNo] = FutureY[PlayerNo]
	elseif AnimateID == 255 then
		CurrentX[PlayerNo] = FutureX[PlayerNo]
		CurrentY[PlayerNo] = FutureY[PlayerNo]
	end
		
	if PlayerAnimationFrameMax[PlayerNo] <= PlayerAnimationFrame[PlayerNo] then
		PlayerAnimationFrame[PlayerNo] = 0
		if PlayerAnimationFrame2[PlayerNo] == 0 then
			PlayerAnimationFrame2[PlayerNo] = 1
		else
			PlayerAnimationFrame2[PlayerNo] = 0
		end
	end
	if AnimationX[PlayerNo] > 15 or AnimationX[PlayerNo] < -15 then
		CurrentX[PlayerNo] = FutureX[PlayerNo]
		AnimationX[PlayerNo] = 0
	end
	if AnimationY[PlayerNo] > 15 or AnimationY[PlayerNo] < -15 then
		CurrentY[PlayerNo] = FutureY[PlayerNo]
		AnimationY[PlayerNo] = 0
	end
	PreviousPlayerAnimation[PlayerNo] = AnimateID
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
	local PlayerChar = 0
	for i = 1, MaxPlayers do
		PlayerChar = i - 1
		if PlayerID ~= i and PlayerIDNick[i] ~= "None" then
			--Facing down
			if PlayerExtra1[i] == 1 then createChars(PlayerChar,3,PlayerExtra2[i]) CurrentFacingDirection[i] = 4 Facing2[i] = 0 AnimatePlayerMovement(i, 251)
			
			--Facing up
			elseif PlayerExtra1[i] == 2 then createChars(PlayerChar,2,PlayerExtra2[i]) CurrentFacingDirection[i] = 3 Facing2[i] = 0 AnimatePlayerMovement(i, 252)
			
			--Facing left
			elseif PlayerExtra1[i] == 3 then createChars(PlayerChar,1,PlayerExtra2[i]) CurrentFacingDirection[i] = 1 Facing2[i] = 0 AnimatePlayerMovement(i, 253)
			
			--Facing right
			elseif PlayerExtra1[i] == 4 then createChars(PlayerChar,1,PlayerExtra2[i]) CurrentFacingDirection[i] = 2 Facing2[i] = 1 AnimatePlayerMovement(i, 254)
			
			--walk down
			elseif PlayerExtra1[i] == 5 then Facing2[i] = 0 CurrentFacingDirection[i] = 4 AnimatePlayerMovement(i, 1)
			
			--walk up
			elseif PlayerExtra1[i] == 6 then Facing2[i] = 0 CurrentFacingDirection[i] = 3 AnimatePlayerMovement(i, 2)
			
			--walk left
			elseif PlayerExtra1[i] == 7 then Facing2[i] = 0 CurrentFacingDirection[i] = 1 AnimatePlayerMovement(i, 3)
			
			--walk right
			elseif PlayerExtra1[i] == 8 then Facing2[i] = 1 CurrentFacingDirection[i] = 2 AnimatePlayerMovement(i, 13)
			
			--turn down
			elseif PlayerExtra1[i] == 9 then Facing2[i] = 0 CurrentFacingDirection[i] = 4 AnimatePlayerMovement(i, 10)
			
			--turn up
			elseif PlayerExtra1[i] == 10 then Facing2[i] = 0 CurrentFacingDirection[i] = 3 AnimatePlayerMovement(i, 11)
			
			--turn left
			elseif PlayerExtra1[i] == 11 then Facing2[i] = 0 CurrentFacingDirection[i] = 1 AnimatePlayerMovement(i, 12)
			
			--turn right
			elseif PlayerExtra1[i] == 12 then Facing2[i] = 1 CurrentFacingDirection[i] = 2 AnimatePlayerMovement(i, 12)
			
			--run down
			elseif PlayerExtra1[i] == 13 then Facing2[i] = 0 CurrentFacingDirection[i] = 4 AnimatePlayerMovement(i, 4)
			
			--run up
			elseif PlayerExtra1[i] == 14 then Facing2[i] = 0 CurrentFacingDirection[i] = 3 AnimatePlayerMovement(i, 5)
			
			--run left
			elseif PlayerExtra1[i] == 15 then Facing2[i] = 0 CurrentFacingDirection[i] = 1 AnimatePlayerMovement(i, 6)
			
			--run right
			elseif PlayerExtra1[i] == 16 then Facing2[i] = 1 CurrentFacingDirection[i] = 2 AnimatePlayerMovement(i, 14)
			
			--bike face down
			elseif PlayerExtra1[i] == 17 then createChars(PlayerChar,12,PlayerExtra2[i]) CurrentFacingDirection[i] = 4 Facing2[i] = 0 AnimatePlayerMovement(i, 251)
			
			--bike face up
			elseif PlayerExtra1[i] == 18 then createChars(PlayerChar,11,PlayerExtra2[i]) CurrentFacingDirection[i] = 3 Facing2[i] = 0 AnimatePlayerMovement(i, 252)
			
			--bike face left
			elseif PlayerExtra1[i] == 19 then createChars(PlayerChar,10,PlayerExtra2[i]) CurrentFacingDirection[i] = 1 Facing2[i] = 0 AnimatePlayerMovement(i, 253)
			
			--bike face right
			elseif PlayerExtra1[i] == 20 then createChars(PlayerChar,10,PlayerExtra2[i]) CurrentFacingDirection[i] = 2 Facing2[i] = 1 AnimatePlayerMovement(i, 254)
			
			--bike move down
			elseif PlayerExtra1[i] == 21 then Facing2[i] = 0 CurrentFacingDirection[i] = 4 AnimatePlayerMovement(i, 7)
			
			--bike move up
			elseif PlayerExtra1[i] == 22 then Facing2[i] = 0 CurrentFacingDirection[i] = 3 AnimatePlayerMovement(i, 8)
			
			--bike move left
			elseif PlayerExtra1[i] == 23 then Facing2[i] = 0 CurrentFacingDirection[i] = 1 AnimatePlayerMovement(i, 9)
			
			--bike move right
			elseif PlayerExtra1[i] == 24 then Facing2[i] = 1 CurrentFacingDirection[i] = 2 AnimatePlayerMovement(i, 15)
			
			--bike fast move down
			elseif PlayerExtra1[i] == 25 then Facing2[i] = 0 CurrentFacingDirection[i] = 4 AnimatePlayerMovement(i, 7)
			
			--bike fast move up
			elseif PlayerExtra1[i] == 26 then Facing2[i] = 0 CurrentFacingDirection[i] = 3 AnimatePlayerMovement(i, 8)
			
			--bike fast move left
			elseif PlayerExtra1[i] == 27 then Facing2[i] = 0 CurrentFacingDirection[i] = 1 AnimatePlayerMovement(i, 9)
			
			--bike fast move right
			elseif PlayerExtra1[i] == 28 then Facing2[i] = 1 CurrentFacingDirection[i] = 2 AnimatePlayerMovement(i, 15)
			
			--bike hit wall down
			elseif PlayerExtra1[i] == 29 then createChars(PlayerChar,12,PlayerExtra2[i]) CurrentFacingDirection[i] = 4 Facing2[i] = 0 AnimatePlayerMovement(i, 251)
			
			--bike hit wall up
			elseif PlayerExtra1[i] == 30 then createChars(PlayerChar,11,PlayerExtra2[i]) CurrentFacingDirection[i] = 3 Facing2[i] = 0 AnimatePlayerMovement(i, 252)
			
			--bike hit wall left
			elseif PlayerExtra1[i] == 31 then createChars(PlayerChar,10,PlayerExtra2[i]) CurrentFacingDirection[i] = 1 Facing2[i] = 0 AnimatePlayerMovement(i, 253)
			
			--bike hit wall right
			elseif PlayerExtra1[i] == 32 then createChars(PlayerChar,10,PlayerExtra2[i]) CurrentFacingDirection[i] = 2 Facing2[i] = 1 AnimatePlayerMovement(i, 254)
			
			--Surfing
			
			--Facing down
			elseif PlayerExtra1[i] == 33 then CurrentFacingDirection[i] = 4 Facing2[i] = 0 AnimatePlayerMovement(i, 17)
			
			--Facing up
			elseif PlayerExtra1[i] == 34 then CurrentFacingDirection[i] = 3 Facing2[i] = 0 AnimatePlayerMovement(i, 18)
			
			--Facing left
			elseif PlayerExtra1[i] == 35 then CurrentFacingDirection[i] = 1 Facing2[i] = 0 AnimatePlayerMovement(i, 19)
			
			--Facing right
			elseif PlayerExtra1[i] == 36 then CurrentFacingDirection[i] = 2 Facing2[i] = 1 AnimatePlayerMovement(i, 20)
			
			--surf down
			elseif PlayerExtra1[i] == 37 then Facing2[i] = 0 CurrentFacingDirection[i] = 4 AnimatePlayerMovement(i, 21)
			
			--surf up
			elseif PlayerExtra1[i] == 38 then Facing2[i] = 0 CurrentFacingDirection[i] = 3 AnimatePlayerMovement(i, 22)
			
			--surf left
			elseif PlayerExtra1[i] == 39 then Facing2[i] = 0 CurrentFacingDirection[i] = 1 AnimatePlayerMovement(i, 23)
			
			--surf right
			elseif PlayerExtra1[i] == 40 then Facing2[i] = 1 CurrentFacingDirection[i] = 2 AnimatePlayerMovement(i, 24)
			
			
			--default position
			elseif PlayerExtra1[i] == 0 then Facing2[i] = 0 AnimatePlayerMovement(i, 255)
			
			end
		end
	end
end

function CalculateCamera()
	--	ConsoleForText:print("Player X camera: " .. PlayerMapXMove .. "Player Y camera: " .. PlayerMapYMove)
	--	ConsoleForText:print("PlayerMapXMove: " .. PlayerMapXMove .. "PlayerMapYMove: " .. PlayerMapYMove .. "PlayerMapXMovePREV: " .. PlayerMapXMovePrev .. "PlayerMapYMovePrev: " .. PlayerMapYMovePrev)
		
		local PlayerMapXMoveTemp = 0
		local PlayerMapYMoveTemp = 0
		
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		elseif GameID == "BPG1" or GameID == "BPG2"  then
			--Addresses for Leafgreen
			PlayerMapXMoveAddress = 33687132
			PlayerMapYMoveAddress = 33687134
		end
		--if PlayerMapChange == 1 then
			--Update first if map change
			PlayerMapXMovePrev = emu:read16(PlayerMapXMoveAddress) - 8
			PlayerMapYMovePrev = emu:read16(PlayerMapYMoveAddress)
			PlayerMapXMoveTemp = PlayerMapXMovePrev % 16
			PlayerMapYMoveTemp = PlayerMapYMovePrev % 16
			
			if PlayerDirection == 1 then
				CameraX = PlayerMapXMoveTemp * -1
			--	console:log("XTEMP: " .. PlayerMapXMoveTemp)
			elseif PlayerDirection == 2 then
				if PlayerMapXMoveTemp > 0 then
					CameraX = 16 - PlayerMapXMoveTemp
				else
					CameraX = 0
				end
				--console:log("XTEMP: " .. PlayerMapXMoveTemp)
			elseif PlayerDirection == 3 then
				CameraY = PlayerMapYMoveTemp * -1
				--console:log("YTEMP: " .. PlayerMapYMoveTemp)
			elseif PlayerDirection == 4 then
				--console:log("YTEMP: " .. PlayerMapYMoveTemp)
				if PlayerMapYMoveTemp > 0 then
					CameraY = 16 - PlayerMapYMoveTemp
				else
					CameraY = 0
				end
			end
			
			--Calculations for X and Y of new map
			if PlayerMapChange == 1 and (CameraX == 0 and CameraY == 0) then
				PlayerMapChange = 0
				StartX[PlayerID] = PlayerMapX
				StartY[PlayerID] = PlayerMapY
				DifferentMapXPlayer = (StartX[PlayerID] - PreviousX[PlayerID]) * 16
				DifferentMapYPlayer = (StartY[PlayerID] - PreviousY[PlayerID]) * 16
				if PlayerDirection == 1 then
					StartX[PlayerID] = StartX[PlayerID] + 1
				elseif PlayerDirection == 2 then
					StartX[PlayerID] = StartX[PlayerID] - 1
				elseif PlayerDirection == 3 then
					StartY[PlayerID] = StartY[PlayerID] + 1
				elseif PlayerDirection == 4 then
					StartY[PlayerID] = StartY[PlayerID] - 1
				end
			--	console:log("YOU HAVE MOVED MAPS")
				--For New Positions if player moves
			--	console:log("X: " .. DifferentMapX[i] .. " Y: " .. DifferentMapY[i])
				--if PlayerDirection == 4 then
				--	DifferentMapY[i] = DifferentMapY[i] + 16
				--end
			end
end

function CalculateRelativePositions()
	local TempX = 0
	local TempY = 0
	local TempX2 = 0
	local TempY2 = 0
	for i = 1, MaxPlayers do
		TempX = ((CurrentX[i] - PlayerMapX) * 16) + DifferentMapX[i]
		TempY = ((CurrentY[i] - PlayerMapY) * 16) + DifferentMapY[i]
		if PlayerID ~= i and PlayerIDNick[i] ~= "None" then
			if PlayerMapEntranceType == 0 and (PlayerMapIDPrev == CurrentMapID[i] or PlayerMapID == PreviousMapID[i]) and MapChange[i] == 0 then
				PlayerVis[i] = 1
				TempX2 = TempX + DifferentMapXPlayer
				TempY2 = TempY + DifferentMapYPlayer
			else
				TempX2 = TempX
				TempY2 = TempY
			end
			--AnimationX is -16 - 16 and is purely to animate sprites
			--CameraX can be between -16 and 16 and is to get the camera movement while moving
			--Current X is the X the current sprite has
			--Player X is the X the player sprite has
			RelativeX[i] = AnimationX[i] + CameraX + TempX2
			RelativeY[i] = AnimationY[i] + CameraY + TempY2
			--console:log("X: " .. RelativeX[i] .. " " .. CurrentX[i] .. " " .. PlayerMapX .. " " .. DifferentMapX[i])
			--console:log("Y: " .. RelativeY[i] .. " " .. AnimationY[i] .. " " .. CameraY .. " " .. TempY)
		end
	end
end


function DrawChars()
	if EnableScript == true then
		NoPlayersIfScreen()
				--Make sure the sprites are loaded
			
		HandleSprites()
		CalculateCamera()
		RenderPlayersOnDifferentMap()
		CalculateRelativePositions()
		if ScreenData == 1 then
			for i = 1, MaxPlayers do
				if HasErasedPlayer[i] == false then
					HasErasedPlayer[i] = true
					ErasePlayer(i)
				end
				if PlayerID ~= i and PlayerIDNick[i] ~= "None" then
					DrawPlayer(i)
				end
			end
		else
			for i = 1, MaxPlayers do
				HasErasedPlayer[i] = false
			end
		end
	end
end


function DrawPlayer(PlayerNo)
		local u32 PlayerYAddress = 0
		local u32 PlayerXAddress = 0
		local u32 PlayerFaceAddress = 0
		local u32 PlayerSpriteAddress = 0
		local u32 PlayerExtra1Address = 0
		local u32 PlayerExtra2Address = 0
		local u32 PlayerExtra3Address = 0
		local u32 PlayerExtra4Address = 0
		local SpriteNo1 = 2608 - ((PlayerNo - 1) * 40)
		local SpriteNo2 = SpriteNo1 + 18
		--For extra char if not biking
		local SpriteNo3 = SpriteNo1 + 8
		--For extra char if biking
		local SpriteNo4 = SpriteNo1 + 16
		if GameID == "BPR1" or GameID == "BPR2" then
			--Addresses for Firered
			Player1Address = 50345200 - ((PlayerNo - 1) * 24)
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
			Player1Address = 50345200 - ((PlayerNo - 1) * 24)
			PlayerYAddress = Player1Address
			PlayerXAddress = PlayerYAddress + 2
			PlayerFaceAddress = PlayerYAddress + 3
			PlayerSpriteAddress = PlayerYAddress + 1
			PlayerExtra1Address = PlayerYAddress + 4
			PlayerExtra2Address = PlayerYAddress + 5
			PlayerExtra3Address = PlayerYAddress + 6
			PlayerExtra4Address = PlayerYAddress + 7
		end
		
		--Screen size (take into account movement)
		local MinX = -16
		local MaxX = 240
		local MinY = -32
		local MaxY = 144
		--This is for the bike + surf
		if PlayerExtra1[PlayerNo] >= 17 and PlayerExtra1[PlayerNo] <= 40 then MinX = -8 end
		if PlayerExtra1[PlayerNo] >= 33 and PlayerExtra1[PlayerNo] <= 40 then MinX = 8 end
		
		--112 and 56 = middle of screen
		local FinalMapX = RelativeX[PlayerNo] + 112
		local FinalMapY = RelativeY[PlayerNo] + 56
		
		--Flip sprite if facing right
		local FacingTemp = 128
		if Facing2[PlayerNo] == 1 then FacingTemp = 144
		else FacingTemp = 128
		end
		
		if not ((FinalMapX > MaxX or FinalMapX < MinX) or (FinalMapY > MaxY or FinalMapY < MinY)) then 
			
			if PlayerVis[PlayerNo] == 1 then
				--Bikes need different vars
				if PlayerExtra1[PlayerNo] >= 17 and PlayerExtra1[PlayerNo] <= 32 then
				FinalMapX = FinalMapX - 8
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 0)
				emu:write16(PlayerExtra1Address, SpriteNo1)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				--Surfing char erase
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
				--Add fighting symbol if in battle
					if PlayerExtra4[PlayerNo] == 1 then
						local SymbolY = FinalMapY - 8
						local SymbolX = FinalMapX + 8
						local Charpic = PlayerNo - 1
						--Create battle symbol
						createChars(Charpic, 1, 2, 1)
						--Extra Char
						PlayerYAddress = Player1Address + 16
						PlayerXAddress = PlayerYAddress + 2
						PlayerFaceAddress = PlayerYAddress + 3
						PlayerSpriteAddress = PlayerYAddress + 1
						PlayerExtra1Address = PlayerYAddress + 4
						PlayerExtra2Address = PlayerYAddress + 5
						PlayerExtra3Address = PlayerYAddress + 6
						PlayerExtra4Address = PlayerYAddress + 7
						emu:write8(PlayerYAddress, SymbolY)
						emu:write8(PlayerXAddress, SymbolX)
						emu:write8(PlayerFaceAddress, 64)
						emu:write8(PlayerSpriteAddress, 0)
						emu:write16(PlayerExtra1Address, SpriteNo4)
						emu:write8(PlayerExtra3Address, 0)
						emu:write8(PlayerExtra4Address, 1)
					else
						PlayerYAddress = Player1Address + 16
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
				--Same with surf
				elseif PlayerExtra1[PlayerNo] >= 33 and PlayerExtra1[PlayerNo] <= 40 then
				if PlayerAnimationFrame2[PlayerNo] == 1 and PlayerExtra1[PlayerNo] <= 36 then FinalMapY = FinalMapY + 1 end
				--Sitting char
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, SpriteNo1)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				--Add fighting symbol if in battle
				if PlayerExtra4[PlayerNo] == 1 then
					local SymbolY = FinalMapY - 8
					local SymbolX = FinalMapX
					local Charpic = PlayerNo - 1
					--Create battle symbol
					createChars(Charpic, 1, 2, 0)
					--Extra Char
					PlayerYAddress = Player1Address + 16
					PlayerXAddress = PlayerYAddress + 2
					PlayerFaceAddress = PlayerYAddress + 3
					PlayerSpriteAddress = PlayerYAddress + 1
					PlayerExtra1Address = PlayerYAddress + 4
					PlayerExtra2Address = PlayerYAddress + 5
					PlayerExtra3Address = PlayerYAddress + 6
					PlayerExtra4Address = PlayerYAddress + 7
					emu:write8(PlayerYAddress, SymbolY)
					emu:write8(PlayerXAddress, SymbolX)
					emu:write8(PlayerFaceAddress, 64)
					emu:write8(PlayerSpriteAddress, 0)
					emu:write16(PlayerExtra1Address, SpriteNo3)
					emu:write8(PlayerExtra3Address, 0)
					emu:write8(PlayerExtra4Address, 1)
				else
					PlayerYAddress = Player1Address + 16
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
				--Surfing char
				if PlayerAnimationFrame2[PlayerNo] == 1 and PlayerExtra1[PlayerNo] <= 36 then FinalMapY = FinalMapY - 1 end
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
				emu:write16(PlayerExtra1Address, SpriteNo2)
				emu:write8(PlayerExtra3Address, 0)
				emu:write8(PlayerExtra4Address, 0)
				else
				--Player default
				
				emu:write8(PlayerXAddress, FinalMapX)
				emu:write8(PlayerYAddress, FinalMapY)
				emu:write8(PlayerFaceAddress, FacingTemp)
				emu:write8(PlayerSpriteAddress, 128)
				emu:write16(PlayerExtra1Address, SpriteNo1)
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
				--Add fighting symbol if in battle
					if PlayerExtra4[PlayerNo] == 1 then
					--	console:log("PlayerNo: " .. PlayerNo)
						local SymbolY = FinalMapY - 8
						local SymbolX = FinalMapX
						local Charpic = PlayerNo - 1
						--Create battle symbol
						createChars(Charpic, 1, 2, 0)
						--Extra Char
						PlayerYAddress = Player1Address + 16
						PlayerXAddress = PlayerYAddress + 2
						PlayerFaceAddress = PlayerYAddress + 3
						PlayerSpriteAddress = PlayerYAddress + 1
						PlayerExtra1Address = PlayerYAddress + 4
						PlayerExtra2Address = PlayerYAddress + 5
						PlayerExtra3Address = PlayerYAddress + 6
						PlayerExtra4Address = PlayerYAddress + 7
						emu:write8(PlayerYAddress, SymbolY)
						emu:write8(PlayerXAddress, SymbolX)
						emu:write8(PlayerFaceAddress, 64)
						emu:write8(PlayerSpriteAddress, 0)
						emu:write16(PlayerExtra1Address, SpriteNo3)
						emu:write8(PlayerExtra3Address, 0)
						emu:write8(PlayerExtra4Address, 1)
					else
						PlayerYAddress = Player1Address + 16
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
					--Extra Char
					PlayerYAddress = Player1Address + 16
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
					--Extra Char
					PlayerYAddress = Player1Address + 16
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
function ErasePlayer(PlayerNo)
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
			Player1Address = 50345200 - ((PlayerNo - 1) * 24)
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
			Player1Address = 50345200 - ((PlayerNo - 1) * 24)
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
					--Extra Char
					PlayerYAddress = Player1Address + 16
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


--Unique for client

function GetNewGame()
    ClearAllVar()
	if ConsoleForText == nil then
		ConsoleForText = console:createBuffer("GBA-PK CLIENT")
	end
	ConsoleForText:clear()
	ConsoleForText:moveCursor(0,0)
	ConsoleForText:print("A new game has started.")
	ConsoleForText:moveCursor(0,1)
	FFTimer2 = os.time()
	GetGameVersion()
end

function shutdownGame()
    ClearAllVar()
	ConsoleForText:clear()
	ConsoleForText:moveCursor(0,0)
	ConsoleForText:print("The game was shutdown")
end

--Begin Networking

function CreateNetwork()
	if MasterClient ~= "c" then
		SocketMain:connect(IPAddress, Port)
		SendData("Request")
		ConsoleForText:moveCursor(0,3)
		ConsoleForText:print("Searching for an open game on IP ".. IPAddress .. " and port " .. Port)
		ConsoleForText:moveCursor(0,15)
		ConsoleForText:print("Connected to a server: No                   ")
		ReceiveData()
	else
		if PlayerID ~= 1 then
			ConsoleForText:moveCursor(0,3)
			ConsoleForText:print("You have successfully connected.                                                          ")
			ConsoleForText:moveCursor(0,15)
			ConsoleForText:print("Connected to a server: Yes                 ")
		else
			ConsoleForText:moveCursor(0,3)
			ConsoleForText:print("Searching for an open game on IP ".. IPAddress .. " and port " .. Port)
			ConsoleForText:moveCursor(0,15)
			ConsoleForText:print("Connected to a server: No                   ")
		end
	end
end

--Receive Data from server
function SetPokemonData(PokeData)
	if string.len(EnemyPokemon[1]) < 250 then EnemyPokemon[1] = EnemyPokemon[1] .. PokeData
	elseif string.len(EnemyPokemon[2]) < 250 then EnemyPokemon[2] = EnemyPokemon[2] .. PokeData
	elseif string.len(EnemyPokemon[3]) < 250 then EnemyPokemon[3] = EnemyPokemon[3] .. PokeData
	elseif string.len(EnemyPokemon[4]) < 250 then EnemyPokemon[4] = EnemyPokemon[4] .. PokeData
	elseif string.len(EnemyPokemon[5]) < 250 then EnemyPokemon[5] = EnemyPokemon[5] .. PokeData
	elseif string.len(EnemyPokemon[6]) < 250 then EnemyPokemon[6] = EnemyPokemon[6] .. PokeData
	end
end
function ReceiveData()
	local RECEIVEDID = 0
	if EnableScript == true then
			--If host has package sent
			if SocketMain:hasdata() then
				local ReadData = SocketMain:receive(64)
				if ReadData ~= nil then
					--Encryption key
					ReceiveDataSmall[17] = "A"
					ReceiveDataSmall[1] = string.sub(ReadData,1,4)
					ReceiveDataSmall[2] = string.sub(ReadData,5,8)
					ReceiveDataSmall[3] = tonumber(string.sub(ReadData,9,12))
					RECEIVEDID = ReceiveDataSmall[3] - 1000
					ReceiveDataSmall[4] = tonumber(string.sub(ReadData,13,16))
					PlayerReceiveID = ReceiveDataSmall[4]
					ReceiveDataSmall[5] = string.sub(ReadData,17,20)
					ReceiveDataSmall[17] = string.sub(ReadData,64,64)
				--	if ReceiveDataSmall[4] == "BATT" then ConsoleForText:print("Valid package! Contents: " .. ReadData) end
				--	ConsoleForText:print("Type: " .. ReceiveDataSmall[4])
					if ReceiveDataSmall[17] == "U" and ReceiveDataSmall[5] == "SLNK" then
							timeout[1] = timeoutmax
							ReceiveDataSmall[6] = string.sub(ReadData,21,30)
							ReceiveDataSmall[6] = tonumber(ReceiveDataSmall[6])
							if ReceiveDataSmall[6] ~= 0 then
								ReceiveDataSmall[6] = ReceiveDataSmall[6] - 1000000000
								ReceiveMultiplayerPackets(ReceiveDataSmall[6])
							end
					elseif ReceiveDataSmall[17] == "U" and ReceiveDataSmall[5] == "POKE" then
							timeout[1] = timeoutmax
							local PokeTemp2 = string.sub(ReadData,21,45)
							SetPokemonData(PokeTemp2)
							
					elseif ReceiveDataSmall[17] == "U" and ReceiveDataSmall[5] == "TRAD" then
						timeout[1] = timeoutmax
						EnemyTradeVars[1] = string.sub(ReadData,21,21)
						EnemyTradeVars[2] = string.sub(ReadData,22,22)
						EnemyTradeVars[3] = string.sub(ReadData,23,23)
						EnemyTradeVars[5] = string.sub(ReadData,24,63)
						EnemyTradeVars[1] = tonumber(EnemyTradeVars[1])
						EnemyTradeVars[2] = tonumber(EnemyTradeVars[2])
						EnemyTradeVars[3] = tonumber(EnemyTradeVars[3])
					elseif ReceiveDataSmall[17] == "U" and ReceiveDataSmall[5] == "BATT" then
						timeout[1] = timeoutmax
						EnemyBattleVars[1] = string.sub(ReadData,21,21)
						EnemyBattleVars[2] = string.sub(ReadData,22,22)
						EnemyBattleVars[3] = string.sub(ReadData,23,23)
						EnemyBattleVars[4] = string.sub(ReadData,24,24)
						EnemyBattleVars[5] = string.sub(ReadData,25,25)
						EnemyBattleVars[6] = string.sub(ReadData,26,26)
						EnemyBattleVars[7] = string.sub(ReadData,27,27)
						EnemyBattleVars[8] = string.sub(ReadData,28,28)
						EnemyBattleVars[9] = string.sub(ReadData,29,29)
						EnemyBattleVars[10] = string.sub(ReadData,30,30)
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
					
					elseif ReceiveDataSmall[17] == "U" then
						timeout[1] = timeoutmax
							--Decryption for packet
							--Extra bytes connected to sent request
							ReceiveDataSmall[6] = string.sub(ReadData,21,24)
							ReceiveDataSmall[6] = tonumber(ReceiveDataSmall[6])
							--X
							ReceiveDataSmall[7] = string.sub(ReadData,25,28)
							ReceiveDataSmall[7] = tonumber(ReceiveDataSmall[7])
							--Y
							ReceiveDataSmall[8] = string.sub(ReadData,29,32)
							ReceiveDataSmall[8] = tonumber(ReceiveDataSmall[8])
							--Facing (used during comparing for extra1)
							ReceiveDataSmall[9] = string.sub(ReadData,33,35)
							ReceiveDataSmall[9] = tonumber(ReceiveDataSmall[9])
							--Extra 1
							ReceiveDataSmall[10] = string.sub(ReadData,36,38)
							ReceiveDataSmall[10] = tonumber(ReceiveDataSmall[10])
							ReceiveDataSmall[10] = ReceiveDataSmall[10] - 100
							--Extra 2
							ReceiveDataSmall[11] = string.sub(ReadData,39,39)
							ReceiveDataSmall[11] = tonumber(ReceiveDataSmall[11])
							--Extra 3
							ReceiveDataSmall[12] = string.sub(ReadData,40,40)
							ReceiveDataSmall[12] = tonumber(ReceiveDataSmall[12])
							--Extra 4
							ReceiveDataSmall[13] = string.sub(ReadData,41,41)
							ReceiveDataSmall[13] = tonumber(ReceiveDataSmall[13])
							--MapID
							ReceiveDataSmall[14] = string.sub(ReadData,42,47)
							ReceiveDataSmall[14] = tonumber(ReceiveDataSmall[14])
							--PreviousMapID
							ReceiveDataSmall[15] = string.sub(ReadData,48,53)
							ReceiveDataSmall[15] = tonumber(ReceiveDataSmall[15])
							--MapConnectionType
							ReceiveDataSmall[16] = string.sub(ReadData,54,54)
							ReceiveDataSmall[16] = tonumber(ReceiveDataSmall[16])
							--StartX
							ReceiveDataSmall[18] = string.sub(ReadData,55,58)
							ReceiveDataSmall[18] = tonumber(ReceiveDataSmall[18])
							--StartY
							ReceiveDataSmall[19] = string.sub(ReadData,59,62)
							ReceiveDataSmall[19] = tonumber(ReceiveDataSmall[19])
							--Between 53 and 63 there are 11 bytes of filler.
							
				--		console:log("X: " .. ReceiveDataSmall[6] .. " Y: " .. ReceiveDataSmall[7] .. " Extra 1: " .. ReceiveDataSmall[9] .. " Extra 2: " .. ReceiveDataSmall[10] .. " MapID: " .. ReceiveDataSmall[13] .. " ConnectType: " .. ReceiveDataSmall[15])
	--					ConsoleForText:print("Valid package! Contents: " .. ReadData)
			--		if ReceiveDataSmall[34] ~= 0 and (ReceiveDataSmall[11] == ReceiveDataSmall[34]) then
			--			ConsoleForText:print("Valid package! Contents: " .. ReadData)
				--	if ReceiveDataSmall[5] == "DTRA" then ConsoleForText:print("Locktype: " .. LockFromScript) end
						--Set connection type to var
							ReturnConnectionType = ReceiveDataSmall[5]
						--If host asks for positions
						if ReceiveDataSmall[5] == "RPOK" then
							CreatePackettSpecial("POKE")
						--	console:log("YOU ARE NOW SENDING POKE PACKAGE")
						end
						if ReceiveDataSmall[5] == "GPOS" then
							SendData("GPOS")
						end
						
						--If player requests for a battle
						if ReceiveDataSmall[5] == "RBAT" and ReceiveDataSmall[3] ~= PlayerID2 then
							local TooBusyByte = emu:read8(50335644)
							if (TooBusyByte ~= 0 or LockFromScript ~= 0) then
								SendData("TBUS")
							else
								OtherPlayerHasCancelled = 0
								LockFromScript = 10
								PlayerTalkingID = ReceiveDataSmall[3] - 1000
								PlayerTalkingID2 = ReceiveDataSmall[3]
								Loadscript(10)
							end
						end
						
						--If player requests for a trade
						if ReceiveDataSmall[5] == "RTRA" and ReceiveDataSmall[3] ~= PlayerID2 then
							local TooBusyByte = emu:read8(50335644)
							if (TooBusyByte ~= 0 or LockFromScript ~= 0) then
								SendData("TBUS")
							else
								OtherPlayerHasCancelled = 0
								LockFromScript = 11
								PlayerTalkingID = ReceiveDataSmall[3] - 1000
								PlayerTalkingID2 = ReceiveDataSmall[3]
								Loadscript(6)
							end
						end
						
						--If player cancels battle
						if ReceiveDataSmall[5] == "CBAT" and ReceiveDataSmall[3] == PlayerTalkingID2 then
				--			ConsoleForText:print("Other player has canceled battle.")
							OtherPlayerHasCancelled = 1
						end
						--If player cancels trade
						if ReceiveDataSmall[5] == "CTRA" and ReceiveDataSmall[3] == PlayerTalkingID2 then
				--			ConsoleForText:print("Other player has canceled trade.")
							OtherPlayerHasCancelled = 2
						end
						
						--If player is too busy to battle
						if ReceiveDataSmall[5] == "TBUS" and ReceiveDataSmall[3] == PlayerTalkingID2 and LockFromScript == 4 then
					--		ConsoleForText:print("Other player is too busy to battle.")
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(20)
							else
								TextSpeedWait = 5
							end
						--If player is too busy to trade
						elseif ReceiveDataSmall[5] == "TBUS" and ReceiveDataSmall[3] == PlayerTalkingID2 and LockFromScript == 5 then
					--		ConsoleForText:print("Other player is too busy to trade.")
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(21)
							else
								TextSpeedWait = 6
							end
						end
						
						--If player accepts your battle request
						if ReceiveDataSmall[5] == "SBAT" and ReceiveDataSmall[3] == PlayerTalkingID2 and LockFromScript == 4 then
							SendData("RPOK")
							if Var8000[2] ~= 0 then
								LockFromScript = 8
								Loadscript(13)
							else
								TextSpeedWait = 1
							end
						end
						--If player accepts your trade request
						if ReceiveDataSmall[5] == "STRA" and ReceiveDataSmall[3] == PlayerTalkingID2 and LockFromScript == 5 then
							SendData("RPOK")
							if Var8000[2] ~= 0 then
								LockFromScript = 9
							else
								TextSpeedWait = 2
							end
						end
						
						--If player denies your battle request
						if ReceiveDataSmall[5] == "DBAT" and ReceiveDataSmall[3] == PlayerTalkingID2 and LockFromScript == 4 then
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(11)
							else
								TextSpeedWait = 3
							end
						end
						--If player denies your trade request
						if ReceiveDataSmall[5] == "DTRA" and ReceiveDataSmall[3] == PlayerTalkingID2 and LockFromScript == 5 then
							if Var8000[2] ~= 0 then
								LockFromScript = 7
								Loadscript(7)
							else
								TextSpeedWait = 4
							end
						end
						
						--If player refuses trade offer
						if ReceiveDataSmall[5] == "ROFF" and ReceiveDataSmall[3] == PlayerTalkingID2 and LockFromScript == 9 then
							OtherPlayerHasCancelled = 3
						end
						
							--If host accepts your join request
						if ReceiveDataSmall[5] == "STRT" then
							timeout[1] = timeoutmax
							MapChange[1] = 0
							PlayerAnimationFrame[1] = 0
							PlayerAnimationFrame2[1] = 0
							PlayerAnimationFrameMax[1] = 0
							PlayerIDNick[1] = ReceiveDataSmall[2]
							PlayerID2 = tonumber(ReceiveDataSmall[6])
							PlayerID = PlayerID2 - 1000
							FutureX[1] = ReceiveDataSmall[7]
							FutureY[1] = ReceiveDataSmall[8]
						--	Facing = tonumber(ReceiveDataSmall[11])
							--Action type -> can be walk or run
							PlayerExtra1[1] = ReceiveDataSmall[10]
							PlayerExtra2[1] = ReceiveDataSmall[11]
							PlayerExtra3[1] = ReceiveDataSmall[12]
							PlayerExtra4[1] = ReceiveDataSmall[13]
						end
						
						if ReceiveDataSmall[5] == "SPOS" then
									PlayerIDNick[RECEIVEDID] = ReceiveDataSmall[2]
									if CurrentMapID[RECEIVEDID] ~= ReceiveDataSmall[14] then
										PlayerAnimationFrame[RECEIVEDID] = 0
										PlayerAnimationFrame2[RECEIVEDID] = 0
										PlayerAnimationFrameMax[RECEIVEDID] = 0
									--	console:log("Player 1 has changed maps")
										CurrentMapID[RECEIVEDID] = ReceiveDataSmall[14]
										PreviousMapID[RECEIVEDID] = ReceiveDataSmall[15]
										MapEntranceType[RECEIVEDID] = ReceiveDataSmall[16]
										PreviousX[RECEIVEDID] = CurrentX[RECEIVEDID]
										PreviousY[RECEIVEDID] = CurrentY[RECEIVEDID]
										CurrentX[RECEIVEDID] = ReceiveDataSmall[7]
										CurrentY[RECEIVEDID] = ReceiveDataSmall[8]
										MapChange[RECEIVEDID] = 1
									end
									FutureX[RECEIVEDID] = ReceiveDataSmall[7]
									FutureY[RECEIVEDID] = ReceiveDataSmall[8]
									PlayerExtra1[RECEIVEDID] = ReceiveDataSmall[10]
									PlayerExtra2[RECEIVEDID] = ReceiveDataSmall[11]
									PlayerExtra3[RECEIVEDID] = ReceiveDataSmall[12]
									PlayerExtra4[RECEIVEDID] = ReceiveDataSmall[13]
									StartX[RECEIVEDID] = ReceiveDataSmall[18]
									StartY[RECEIVEDID] = ReceiveDataSmall[19]
						end
		--			if TempVar2 == 0 then ConsoleForText:print("Test 4") end
			--		else
			--			ConsoleForText:print("INVALID PACKAGE: " .. ReadData)
					end
				end
			end
	end
end

function CreatePackettSpecial(RequestTemp, OptionalData)
	if RequestTemp == "POKE" then
		PlayerReceiveID = PlayerTalkingID2
		GetPokemonTeam()
		local PokeTemp
		local StartNum = 0
		local StartNum2 = 0
		local Filler = "FFFFFFFFFFFFFFFFFF"
		for j = 1, 6 do
			for i = 1, 10 do
			StartNum = ((i - 1) * 25) + 1
			StartNum2 = StartNum + 24
			PokeTemp = string.sub(Pokemon[j],StartNum,StartNum2)
			Packett = GameID .. Nickname .. PlayerID2 .. PlayerReceiveID .. RequestTemp .. PokeTemp .. Filler .. "U"
			SocketMain:send(Packett)
		--	console:log("PACKETT SENDING TO " .. PlayerReceiveID .. ": " .. Packett)
			end
		end
	elseif RequestTemp == "TRAD" then
		PlayerReceiveID = PlayerTalkingID2
		Packett = GameID .. Nickname .. PlayerID2 .. PlayerReceiveID .. RequestTemp .. TradeVars[1] .. TradeVars[2] .. TradeVars[3] .. TradeVars[5] .. "U"
		--4 + 4 + 4 + 4 + 4 + 3 + 40 + 1
		SocketMain:send(Packett)
	elseif RequestTemp == "BATT" then
		PlayerReceiveID = PlayerTalkingID2
		local FillerSend = "100000000000000000000000000000000"
		Packett = GameID .. Nickname .. PlayerID2 .. PlayerReceiveID .. RequestTemp .. BattleVars[1] .. BattleVars[2] .. BattleVars[3] .. BattleVars[4] .. BattleVars[5] .. BattleVars[6] .. BattleVars[7] .. BattleVars[8] .. BattleVars[9] .. BattleVars[10] .. FillerSend .. "U"
	--	ConsoleForText:print("Packett: " .. Packett)
		SocketMain:send(Packett)
	elseif RequestTemp == "SLNK" then
		PlayerReceiveID = PlayerTalkingID2
		OptionalData = OptionalData or 0
		local Filler = "100000000000000000000000000000000"
		local SizeAct = OptionalData + 1000000000
 --		SizeAct = tostring(SizeAct)
--		SizeAct = string.format("%.0f",SizeAct)
		Packett = GameID .. Nickname .. PlayerID2 .. PlayerReceiveID .. RequestTemp .. SizeAct .. Filler .. "U"
--		ConsoleForText:print("Packett: " .. Packett)
		SocketMain:send(Packett)
	end
end
--Send Data to clients
function CreatePackett(RequestTemp, PackettTemp)
	local FillerStuff = "F"
	Packett = GameID .. Nickname .. PlayerID2 .. PlayerReceiveID .. RequestTemp .. PackettTemp .. CurrentX[PlayerID] .. CurrentY[PlayerID] .. Facing2[PlayerID] .. PlayerExtra1[PlayerID] .. PlayerExtra2[PlayerID] .. PlayerExtra3[PlayerID] .. PlayerExtra4[PlayerID] .. PlayerMapID .. PlayerMapIDPrev .. PlayerMapEntranceType .. StartX[PlayerID] .. StartY[PlayerID] .. FillerStuff .. "U"
end

function SendData(DataType, ExtraData)
	--If you have made a server
	if (DataType == "NewPlayer") then
		PlayerReceiveID = 1000
	--	ConsoleForText:print("Request accepted!")
		CreatePackett("STRT", ExtraData)
		SocketMain:send(Packett)
	elseif (DataType == "DENY") then
		CreatePackett("DENY", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "KICK") then
		CreatePackett("KICK", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "GPOS") then
		CreatePackett("GPOS", "1000")
		SocketMain:send(Packett)
--		SocketMain:send("BPREABCD1DMMY111111111111111111111111111111111111111111111111111")
	elseif (DataType == "SPOS") then
		CreatePackett("SPOS", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "Request") then
		PlayerReceiveID = 1000
		CreatePackett("JOIN", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "Hide") then
		CreatePackett("HIDE", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "POKE") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackettSpecial("POKE")
	elseif (DataType == "RPOK") then
		PlayerReceiveID = PlayerTalkingID2
		local whiletempmax = 100000
		EnemyPokemon[1] = ""
		EnemyPokemon[2] = ""
		EnemyPokemon[3] = ""
		EnemyPokemon[4] = ""
		EnemyPokemon[5] = ""
		EnemyPokemon[6] = ""
		CreatePackett("RPOK", "1000")
		SocketMain:send(Packett)
		while (string.len(EnemyPokemon[6]) < 100 and whiletempmax > 0) do
			ReceiveData()
			ReceiveData()
			ReceiveData()
			ReceiveData()
			ReceiveData()
			whiletempmax = whiletempmax - 1
	--		if string.len(EnemyPokemon[6]) >= 100 then break end
		end
	elseif (DataType == "RTRA") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("RTRA", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "RBAT") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("RBAT", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "STRA") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("STRA", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "SBAT") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("SBAT", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "DTRA") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("DTRA", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "DBAT") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("DBAT", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "CTRA") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("CTRA", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "CBAT") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("CBAT", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "TBUS") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("TBUS", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "ROFF") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackett("ROFF", "1000")
		SocketMain:send(Packett)
	elseif (DataType == "TRAD") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackettSpecial("TRAD")
	elseif (DataType == "BATT") then
		PlayerReceiveID = PlayerTalkingID2
		CreatePackettSpecial("BATT")
	end
end

function ConnectNetwork()
	--If you are currently connected to a server
	if (timeout[1] > 0) then
	--To prevent package overrunning, sending will be every 8 frames, unlike recieve, which is every frame
	--Send timer
	--Receive timer
	
		--Recieve data from server (GPOS and SPOS)
		for j = 1, MaxPlayers do
			for i = 1, MaxPlayers do
				if PlayerID ~= i then ReceiveData() end
			end
		end
		if SendTimer == 0 then 
			--Send your positional data
			for i = 1, MaxPlayers do
				PlayerReceiveID = i + 1000
				if PlayerID2 ~= PlayerReceiveID then
					SendData("SPOS")
				end
			end
			timeout[1] = timeout[1] - 4
					if timeout[1] <= 0 then
						
						SocketMain:close()
						MasterClient = "a"
						PlayerID = 1
						PlayerID2 = 1001
						ConsoleForText:moveCursor(0,3)
						console:log("You have timed out")
						ConsoleForText:print("You have been disconnected due to timeout.                                           ")
						ConsoleForText:moveCursor(0,15)
						ConsoleForText:print("Connected to a server: No         ")
						for i = 1, MaxPlayers do
							PlayerIDNick[i] = "None"
						end
						CreateNetwork()
					end
		end
	else 
		--You might be connected to one
		ReceiveData()
	--	ConsoleForText:print("Connection Type: " .. ReturnConnectionType)
		if ReturnConnectionType == "STRT" then
			console:log("You have connected to " .. PlayerIDNick[1])
			ConsoleForText:moveCursor(0,3)
			ConsoleForText:print("You have successfully connected.                                                          ")
			ConsoleForText:moveCursor(0,15)
			ConsoleForText:print("Connected to a server: Yes                 ")
			--Since ID has changed, get real position
			MasterClient = "c"
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


function Interact()
	if EnableScript == true and initialized ~= 0 then
		local Keypress = emu:getKeys()
		local TalkingDirX = 0
		local TalkingDirY = 0
		local ScriptAddressTemp = 0
		local ScriptAddressTemp1 = 0
		local AddressGet = ""
		local TooBusyByte = emu:read8(50335644)
		
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
					SendData("RTRA")
				
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
				if MasterClient == "h" and PlayerDirection == 3 and PlayerMapX == 1009 and PlayerMapY == 1009 and PlayerMapID == 100260 then
				--Server config through bedroom drawer
					--For temp ram to load up script in 145227776 - 08A80000
					--8004 is the temp var to get yes or no
					Loadscript(1)
					LockFromScript = 1
				end
				--Interact with players
				for i = 1, MaxPlayers do
					if PlayerID ~= i and PlayerIDNick[i] ~= "None" then
						TalkingDirX = PlayerMapX - CurrentX[i]
						TalkingDirY = PlayerMapY - CurrentY[i]
						if PlayerDirection == 1 and TalkingDirX == 1 and TalkingDirY == 0 then
					--		ConsoleForText:print("Player Left")
							
						elseif PlayerDirection == 2 and TalkingDirX == -1 and TalkingDirY == 0 then
					--		ConsoleForText:print("Player Right")
						elseif PlayerDirection == 3 and TalkingDirY == 1 and TalkingDirX == 0 then
					--		ConsoleForText:print("Player Up")
						elseif PlayerDirection == 4 and TalkingDirY == -1 and TalkingDirX == 0 then
					--		ConsoleForText:print("Player Down")
						end
						if (PlayerDirection == 1 and TalkingDirX == 1 and TalkingDirY == 0) or (PlayerDirection == 2 and TalkingDirX == -1 and TalkingDirY == 0) or (PlayerDirection == 3 and TalkingDirX == 0 and TalkingDirY == 1) or (PlayerDirection == 4 and TalkingDirX == 0 and TalkingDirY == -1) then
						
					--		ConsoleForText:print("Player Any direction")
							emu:write16(Var8000Adr[1], 0) 
							emu:write16(Var8000Adr[2], 0) 
							emu:write16(Var8000Adr[14], 0)
							PlayerTalkingID = i
							PlayerTalkingID2 = i + 1000
							LockFromScript = 2
							Loadscript(2)
						end
					end
				end
			end
			Keypressholding = 1
			elseif Keypress == 2 then
				if LockFromScript == 4 and Keypressholding == 0 and Var8000[2] ~= 0 then
					--Cancel battle request
					Loadscript(15)
					SendData("CBAT")
					LockFromScript = 0
				elseif LockFromScript == 5 and Keypressholding == 0 and Var8000[2] ~= 0 then
					--Cancel trade request
					Loadscript(16)
					SendData("CTRA")
					LockFromScript = 0
					TradeVars[1] = 0
					TradeVars[2] = 0
					TradeVars[3] = 0
					OtherPlayerHasCancelled = 0
				elseif LockFromScript == 9 and (TradeVars[1] == 2 or TradeVars[1] == 4) and Keypressholding == 0 and Var8000[2] ~= 0 then
					--Cancel trade request
					Loadscript(16)
					SendData("CTRA")
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
		--		ConsoleForText:print("Pressed R-Trigger")
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
		--		SendMultiplayerPackets(0,256)
		--	end
		--	Keypressholding = 1
			elseif Keypress == 512 then
		--		ConsoleForText:print("Pressed L-Trigger")
			end
		else
			Keypressholding = 0
		end
	end
end

function mainLoop()
	FFTimer = os.time() - FFTimer2
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
		else
			ScriptTimeFrame = 4
		end
	end
	
	FramesPS = FFTimer
	
	if initialized == 0 and EnableScript == true then
		ROMCARD = emu.memory.cart0
		initialized = 1
		GetPosition()
	--	Loadscript(0)
		Nickname = RandomizeNickname()
		ConsoleForText:print("Nickname is now " .. Nickname)
		ConsoleForText:moveCursor(0,3)
		CreateNetwork()
	elseif EnableScript == true then
			--Debugging
			local TempVarTimer = ScriptTime % DebugTime
			
			TempVar2 = ScriptTime % DebugTime2
			GetPosition()
			ConnectNetwork()
			--Create a network if not made every half second
			TempVarTimer = ScriptTime % DebugTime2
			if TempVarTimer == 0 then
				if timeout[1] == 0 then
					CreateNetwork()
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
			
			--If you cancel/stop
			if LockFromScript == 0 then
				PlayerTalkingID = 0
			end
			
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
--				if SendTimer == 0 then SendData("RTRA") end
			
			--Show card. Placeholder for now
			elseif LockFromScript == 6 then
				if Var8000[2] ~= 0 then
			--		ConsoleForText:print("Var 8001: " .. Var8000[2])
					LockFromScript = 0
				--	if SendTimer == 0 then SendData("RTRA") end
				end
				
			--Exit message
			elseif LockFromScript == 7 then
				if Var8000[2] ~= 0 then LockFromScript = 0 Keypressholding = 1 end
				
			--Trade script
			elseif LockFromScript == 8 then
			
				Battlescript()
			
			--Battle script
			elseif LockFromScript == 9 then
			
				Tradescript()
			
			--Player 1 has requested to battle
			elseif LockFromScript == 10 then
		--	if Var8000[2] ~= 0 then ConsoleForText:print("Var8001: " .. Var8000[2]) end
				if Var8000[2] == 2 then
					if OtherPlayerHasCancelled == 0 then
						SendData("RPOK")
						SendData("SBAT")
						LockFromScript = 8
						Loadscript(13)
					else
						OtherPlayerHasCancelled = 0
						LockFromScript = 7
						Loadscript(18)
					end
				elseif Var8000[2] == 1 then LockFromScript = 0 SendData("DBAT") Keypressholding = 1 end
				
			--Player 1 has requested to trade
			elseif LockFromScript == 11 then
		--	if Var8000[2] ~= 0 then ConsoleForText:print("Var8001: " .. Var8000[2]) end
				--If accept, then send that you accept
				if Var8000[2] == 2 then
					if OtherPlayerHasCancelled == 0 then
						SendData("RPOK")
						SendData("STRA")
						LockFromScript = 9
					else
						OtherPlayerHasCancelled = 0
						LockFromScript = 7
						Loadscript(19)
					end
				elseif Var8000[2] == 1 then LockFromScript = 0 SendData("DTRA") Keypressholding = 1 end
			end
	end
end


SocketMain:add("received", ReceiveData)
callbacks:add("reset", GetNewGame)
callbacks:add("shutdown", shutdownGame)
callbacks:add("frame", mainLoop)
callbacks:add("frame", DrawChars)

callbacks:add("keysRead", Interact)

console:log("Started GBA-PK_Client.lua")
if not (emu == nil) then
	if ConsoleForText == nil then ConsoleForText = console:createBuffer("GBA-PK CLIENT") end
	ConsoleForText:clear()
	ConsoleForText:moveCursor(0,1)
	FFTimer2 = os.time()
    GetGameVersion()
end

