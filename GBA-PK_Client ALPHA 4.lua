local IPAddress, Port = "127.0.0.1", 4096
local MaxPlayers = 8
local ServerType = "c" --can change to "h"/"s" for host, "c" for client
local Nickname = "" --this can be up to 10 utf8 chars long.
local Experimental_Features = false --set this to true to enable experimental NPC feature. Currently is only for testing

--don't edit, these are the flags for Battle, which you can edit
local BATTLE_FLAGS = {
	HEAL_PRE_BATTLE = 1, --heals all pokemon pre battle after saving them.
	HEAL_POST_BATTLE = 2, --heals all pokemon post battle. if this and OVERWRITE_POST_BATTLE are not enabled, will send player to pokecenter
	OVERWRITE_POST_BATTLE = 4, --overwrite post battle pokemon with saved pokemon.
	ITEMS_ALLOWED = 8, --allows using items in battle. HP healing items functionally work, but only graphically change HP on damage taken or changing the screen.
	EXP_ALLOWED = 16, --allows gaining exp in battle. This will only apply to battle master.
	FORCE_BATTLE = 32, --forces other player to battle you, unless they are busy. They will use your battle flags, and if using same game type (FRLG, RS, E) they will become battle master.
	DISABLE_VS_SCREEN = 64, --Doesn't do anything atm.
	DOUBLE_BATTLE = 128, --makes the battle a double battle.
	LEVEL_CAP = 256, --this applies the level cap. If OVERWRITE_POST_BATTLE is not applied, the pokemon will permanently stay that level. This also does not edit EXP value, so it may look wierd until you lvl up.
	RAISE_TO_MAX = 512, --this applies the level cap to underleveled pokemon. LEVEL_CAP is needed for this to work.
	POKEMON_CAP = 1024, --applies the max pokemon count. Healthy pokemon over the Pokemon_Cap value will be fainted at the start.
}

--Battle features, whoever proposes the battle has their config applied. To apply more, simply add | BATTLE_FLAGS.x (x is whatever flag you want)
local Battle = 0 | BATTLE_FLAGS.HEAL_PRE_BATTLE | BATTLE_FLAGS.OVERWRITE_POST_BATTLE

--Level cap used in LEVEL_CAP flag. Applies in a similar manner to Battle flags. If 0, defaults to 50
local Level_Cap = 50

--Max pokemon cap used in MAX_POKEMON flag. Applies in a similar manner to Battle flags. If 0, defaults to 3
local Pokemon_Cap = 3

--Don't edit. This is the Battle config set when host begins talk
local BattleMain = 0
local BattleLevelCap = 0
local BattlePokemonCap = 0

--Variables you should be careful editing
local ClientTimeout = 8000 --miliseconds. currently only reduces 1000 / second
local DisableRenderWeather = false --set to true to hide players underwater/in fog

local DebugMessages = {
	Unable_To_Connect = false, --set to true if you are unable to connect despite it saying GAME FOUND
	Network_Count = false,
	Network = false,
	Card = false,
	Trade = false,
	Animation = false,
	Battle = false,
	Scripts = false,
	Render = false,
	Position = false,
	GameType = true,
	Nickname = false,
	GetMenus = false,
	Objects = false,
}

--Variables you *can* edit, but *really* shouldn't
local SeperateGames = true --Seperates game versions (FR/LG and R/S/E). Disable to see others on same map bank and number.
local PartialSeperateGames = true --Does not seperate pokecenters and shops. Not affected by SeperateGames.
local DrawPlayerCount = 8 --Max players that can be rendered at 1 time. Higher than 8 will likely cause tiling issues.

--Variables you shouldn't touch
local Language = "en"
local LanguageTableType = "Western"
local FPS_Network_Send = 30 -- fps / this
local FPS_Network_Receive = 0 -- fps / this
local FPS_Draw = 0
local FPS_MainLogic = 0
local CurrentFrame = 0
local PreviousFrame = 0
local TotalFrame = 0
local CurrentTime = os.time()
local PreviousTime = os.time()
local Frame = 0
local FPS = 0
local Sleep_Timer = 0
local Sleep_Timer_Max = 0

local RestartScript = false
local EnableScript = false
local Hosting = false
local Connected = false
local ConnectType = 0
local NoPlayers = 0
local GameID
local ROMCARD
local SocketMain
local Packet = ""
local PlayerID = 0
local players = {}
local temp_players = {}
local NPCs = {}

--Variables from the game. Also don't touch
local PrevExtraAdr = 0
local PrevExtraAdrNum = 0
local Var8000 = {}
local Var8000Adr = {}
local LockFromScript = 0
local Keypressholding = 0
local OtherPlayerHasCancelled = 0
local TextSpeedWait = 0
local DebugMenus = {}
local DebugMenusPrev = {}
local drawplayertable = {}
local drawspritetable = {}
local renderplayertable = {}
local previousdrawplayertable = {}
local previousdrawspritetable = {}
local IDsToDraw = 0
local ObjectLoaded = false
local ObjectInUse = 0
local NativeLua = false
local MainBattleFunc_Saved = 0

local PositionData = {
	Bike = 0,
	Direction = 0,
	PlayerMapIDPrev = 0,
	PlayerMapID = 0,
	PlayerMapEntranceType = 0,
	PlayerMapChange = 0,
	CurrentX = 0,
	CurrentY = 0,
	PreviousX = 0,
	PreviousY = 0,
	Animation = 0,
	Gender = 0,
	SpriteType = 0,
	BorderX = 9999,
	BorderY = 9999,
	Connections = {},
	AnimationData = 0,
	Animate2 = 0,
	AnimType = 0,
	AnimLength = 0,
	Elevation = 0,
	PrevSurf = false,
	CurrentCameraX = 0,
	CurrentCameraY = 0,
	AnimationByte = 0,
	AnimationDirection = 0,
	isAnimating = 0,
	isCrossingBorder = 0,
	CameraXPos = 0,
	CameraYPos = 0,
	UseMapPos = false,
	ActualX = 0,
	ActualY = 0,
}

--Tables for language chars
LanguageTable = {
	
	Western = {
		["À"] = 1, ["Á"] = 2, ["Â"] = 3, ["Ç"] = 4, ["È"] = 5, ["É"] = 6,
		["Ê"] = 7, ["Ë"] = 8, ["Ì"] = 9, ["Î"] = 11, ["Ï"] = 12, ["Ò"] = 13,
		["Ó"] = 14, ["Ô"] = 15, ["Œ"] = 16, ["Ù"] = 17, ["Ú"] = 18, ["Û"] = 19,
		["Ñ"] = 20, ["ß"] = 21, ["à"] = 22, ["á"] = 23, ["ç"] = 25, ["è"] = 26,
		["é"] = 27, ["ê"] = 28, ["ë"] = 29, ["ì"] = 30, ["î"] = 32, ["ï"] = 33,
		["ò"] = 34, ["ó"] = 35, ["ô"] = 36, ["œ"] = 37, ["ù"] = 38, ["ú"] = 39,
		["û"] = 40, ["ñ"] = 41, ["º"] = 42, ["ª"] = 43, ["ᵉʳ"] = 44, ["&"] = 45,
		["+"] = 46, ["Lv"] = 52, ["="] = 53, [";"] = 54, ["▯"] = 80, ["¿"] = 81,
		["¡"] = 82, ["PK"] = 83, ["MN"] = 84, ["PO"] = 85, ["Ke"] = 86, ["BL"] = 87,
		["OCK"] = 88, ["^<"] = 89, ["Í"] = 90, ["%"] = 91, ["("] = 92, [")"] = 93,
		["......"] = 94, ["......"] = 95, ["......"] = 96, ["......"] = 97, ["......"] = 98, ["......"] = 99,
		["......"] = 100, ["â"] = 104, ["í"] = 111, ["↑"] = 121, ["↓"] = 122, ["←"] = 123,
		["→"] = 124, ["*"] = 125, ["*"] = 126, ["*"] = 127, ["*"] = 128, ["*"] = 129,
		["*"] = 130, ["*"] = 131, ["ᵉ"] = 132, ["<"] = 133, [">"] = 134, ["ʳᵉ"] = 160,
		["0"] = 161, ["1"] = 162, ["2"] = 163, ["3"] = 164, ["4"] = 165, ["5"] = 166,
		["6"] = 167, ["7"] = 168, ["8"] = 169, ["9"] = 170, ["!"] = 171, ["?"] = 172,
		["."] = 173, ["-"] = 174, ["·"] = 175, ["‥"] = 176, ["“"] = 177, ["”"] = 178,
		["‘"] = 179, ["'"] = 180, ["♂"] = 181, ["♀"] = 182, ["$"] = 183, [","] = 184,
		["×"] = 185, ["/"] = 186, ["A"] = 187, ["B"] = 188, ["C"] = 189, ["D"] = 190,
		["E"] = 191, ["F"] = 192, ["G"] = 193, ["H"] = 194, ["I"] = 195, ["J"] = 196,
		["K"] = 197, ["L"] = 198, ["M"] = 199, ["N"] = 200, ["O"] = 201, ["P"] = 202,
		["Q"] = 203, ["R"] = 204, ["S"] = 205, ["T"] = 206, ["U"] = 207, ["V"] = 208,
		["W"] = 209, ["X"] = 210, ["Y"] = 211, ["Z"] = 212, ["a"] = 213, ["b"] = 214,
		["c"] = 215, ["d"] = 216, ["e"] = 217, ["f"] = 218, ["g"] = 219, ["h"] = 220,
		["i"] = 221, ["j"] = 222, ["k"] = 223, ["l"] = 224, ["m"] = 225, ["n"] = 226,
		["o"] = 227, ["p"] = 228, ["q"] = 229, ["r"] = 230, ["s"] = 231, ["t"] = 232,
		["u"] = 233, ["v"] = 234, ["w"] = 235, ["x"] = 236, ["y"] = 237, ["z"] = 238,
		["►"] = 239, [":"] = 240, ["Ä"] = 241, ["Ö"] = 242, ["Ü"] = 243, ["ä"] = 244,
		["ö"] = 245, ["ü"] = 246,
	},
	Japanese = {
		[" "] = 0,
		["あ"] = 1, ["い"] = 2, ["う"] = 3, ["え"] = 4, ["お"] = 5,
		["か"] = 6, ["き"] = 7, ["く"] = 8, ["け"] = 9, ["こ"] = 10,
		["さ"] = 11, ["し"] = 12, ["す"] = 13, ["せ"] = 14, ["そ"] = 15,
		["た"] = 16, ["ち"] = 17, ["つ"] = 18, ["て"] = 19, ["と"] = 20,
		["な"] = 21, ["に"] = 22, ["ぬ"] = 23, ["ね"] = 24, ["の"] = 25,
		["は"] = 26, ["ひ"] = 27, ["ふ"] = 28, ["へ"] = 29, ["ほ"] = 30,
		["ま"] = 31, ["み"] = 32, ["む"] = 33, ["め"] = 34, ["も"] = 35,
		["や"] = 36, ["ゆ"] = 37, ["よ"] = 38, ["ら"] = 39, ["り"] = 40,
		["る"] = 41, ["れ"] = 42, ["ろ"] = 43, ["わ"] = 44, ["を"] = 45,
		["ん"] = 46, ["ぁ"] = 47, ["ぃ"] = 48, ["ぅ"] = 49, ["ぇ"] = 50,
		["ぉ"] = 51, ["ゃ"] = 52, ["ゅ"] = 53, ["ょ"] = 54, ["が"] = 55,
		["ぎ"] = 56, ["ぐ"] = 57, ["げ"] = 58, ["ご"] = 59, ["ざ"] = 60,
		["じ"] = 61, ["ず"] = 62, ["ぜ"] = 63, ["ぞ"] = 64, ["だ"] = 65,
		["ぢ"] = 66, ["づ"] = 67, ["で"] = 68, ["ど"] = 69, ["ば"] = 70,
		["び"] = 71, ["ぶ"] = 72, ["べ"] = 73, ["ぼ"] = 74, ["ぱ"] = 75,
		["ぴ"] = 76, ["ぷ"] = 77, ["ぺ"] = 78, ["ぽ"] = 79, ["っ"] = 80,
		["ア"] = 81, ["イ"] = 82, ["ウ"] = 83, ["エ"] = 84, ["オ"] = 85,
		["カ"] = 86, ["キ"] = 87, ["ク"] = 88, ["ケ"] = 89, ["コ"] = 90,
		["サ"] = 91, ["シ"] = 92, ["ス"] = 93, ["セ"] = 94, ["ソ"] = 95,
		["タ"] = 96, ["チ"] = 97, ["ツ"] = 98, ["テ"] = 99, ["ト"] = 100,
		["ナ"] = 101, ["ニ"] = 102, ["ヌ"] = 103, ["ネ"] = 104, ["ノ"] = 105,
		["ハ"] = 106, ["ヒ"] = 107, ["フ"] = 108, ["ヘ"] = 109, ["ホ"] = 110,
		["マ"] = 111, ["ミ"] = 112, ["ム"] = 113, ["メ"] = 114, ["モ"] = 115,
		["ヤ"] = 116, ["ユ"] = 117, ["ヨ"] = 118, ["ラ"] = 119, ["リ"] = 120,
		["ル"] = 121, ["レ"] = 122, ["ロ"] = 123, ["ワ"] = 124, ["ヲ"] = 125,
		["ン"] = 126, ["ァ"] = 127, ["ィ"] = 128, ["ゥ"] = 129, ["ェ"] = 130,
		["ォ"] = 131, ["ャ"] = 132, ["ュ"] = 133, ["ョ"] = 134, ["ガ"] = 135,
		["ギ"] = 136, ["グ"] = 137, ["ゲ"] = 138, ["ゴ"] = 139, ["ザ"] = 140,
		["ジ"] = 141, ["ズ"] = 142, ["ゼ"] = 143, ["ゾ"] = 144, ["ダ"] = 145,
		["ヂ"] = 146, ["ヅ"] = 147, ["デ"] = 148, ["ド"] = 149, ["バ"] = 150,
		["ビ"] = 151, ["ブ"] = 152, ["ベ"] = 153, ["ボ"] = 154, ["パ"] = 155,
		["ピ"] = 156, ["プ"] = 157, ["ペ"] = 158, ["ポ"] = 159, ["ッ"] = 160,
		["0"] = 161, ["1"] = 162, ["2"] = 163, ["3"] = 164, ["4"] = 165,
		["5"] = 166, ["6"] = 167, ["7"] = 168, ["8"] = 169, ["9"] = 170,
		["！"] = 171, ["？"] = 172, ["。"] = 173, ["ー"] = 174, ["・"] = 175,
		["‥"] = 176, ["『"] = 177, ["』"] = 178, ["「"] = 179, ["」"] = 180,
		["♂"] = 181, ["♀"] = 182, ["円"] = 183, ["．"] = 184, ["×"] = 185,
		["／"] = 186, ["A"] = 187, ["B"] = 188, ["C"] = 189, ["D"] = 190,
		["E"] = 191, ["F"] = 192, ["G"] = 193, ["H"] = 194, ["I"] = 195,
		["J"] = 196, ["K"] = 197, ["L"] = 198, ["M"] = 199, ["N"] = 200,
		["O"] = 201, ["P"] = 202, ["Q"] = 203, ["R"] = 204, ["S"] = 205,
		["T"] = 206, ["U"] = 207, ["V"] = 208, ["W"] = 209, ["X"] = 210,
		["Y"] = 211, ["Z"] = 212, ["a"] = 213, ["b"] = 214, ["c"] = 215,
		["d"] = 216, ["e"] = 217, ["f"] = 218, ["g"] = 219, ["h"] = 220,
		["i"] = 221, ["j"] = 222, ["k"] = 223, ["l"] = 224, ["m"] = 225,
		["n"] = 226, ["o"] = 227, ["p"] = 228, ["q"] = 229, ["r"] = 230,
		["s"] = 231, ["t"] = 232, ["u"] = 233, ["v"] = 234, ["w"] = 235,
		["x"] = 236, ["y"] = 237, ["z"] = 238, ["►"] = 239, ["："] = 240,
		["Ä"] = 241, ["Ö"] = 242, ["Ü"] = 243, ["ä"] = 244, ["ö"] = 245,
		["ü"] = 246, ["↑"] = 247, ["↓"] = 248, ["←"] = 249
	},
	JapaneseWestern = {
		["あ"] = "a", ["い"] = "i", ["う"] = "u", ["え"] = "e", ["お"] = "o",
		["か"] = "ka", ["き"] = "ki", ["く"] = "ku", ["け"] = "ke", ["こ"] = "ko",
		["さ"] = "sa", ["し"] = "shi", ["す"] = "su", ["せ"] = "se", ["そ"] = "so",
		["た"] = "ta", ["ち"] = "chi", ["つ"] = "tsu", ["て"] = "te", ["と"] = "to",
		["な"] = "na", ["に"] = "ni", ["ぬ"] = "nu", ["ね"] = "ne", ["の"] = "no",
		["は"] = "ha", ["ひ"] = "hi", ["ふ"] = "fu", ["へ"] = "he", ["ほ"] = "ho",
		["ま"] = "ma", ["み"] = "mi", ["む"] = "mu", ["め"] = "me", ["も"] = "mo",
		["や"] = "ya", ["ゆ"] = "yu", ["よ"] = "yo", ["ら"] = "ra", ["り"] = "ri",
		["る"] = "ru", ["れ"] = "re", ["ろ"] = "ro", ["わ"] = "wa", ["を"] = "wo",
		["ん"] = "n", ["ぁ"] = "a", ["ぃ"] = "i", ["ぅ"] = "u", ["ぇ"] = "e",
		["ぉ"] = "o", ["ゃ"] = "ya", ["ゅ"] = "yu", ["ょ"] = "yo", ["が"] = "ga",
		["ぎ"] = "gi", ["ぐ"] = "gu", ["げ"] = "ge", ["ご"] = "go", ["ざ"] = "za",
		["じ"] = "ji", ["ず"] = "zu", ["ぜ"] = "ze", ["ぞ"] = "zo", ["だ"] = "da",
		["ぢ"] = "ji", ["づ"] = "zu", ["で"] = "de", ["ど"] = "do", ["ば"] = "ba",
		["び"] = "bi", ["ぶ"] = "bu", ["べ"] = "be", ["ぼ"] = "bo", ["ぱ"] = "pa",
		["ぴ"] = "pi", ["ぷ"] = "pu", ["ぺ"] = "pe", ["ぽ"] = "po", ["っ"] = "tsu",
		["ア"] = "a", ["イ"] = "i", ["ウ"] = "u", ["エ"] = "e", ["オ"] = "o",
		["カ"] = "ka", ["キ"] = "ki", ["ク"] = "ku", ["ケ"] = "ke", ["コ"] = "ko",
		["サ"] = "sa", ["シ"] = "shi", ["ス"] = "su", ["セ"] = "se", ["ソ"] = "so",
		["タ"] = "ta", ["チ"] = "chi", ["ツ"] = "tsu", ["テ"] = "te", ["ト"] = "to",
		["ナ"] = "na", ["ニ"] = "ni", ["ヌ"] = "nu", ["ネ"] = "ne", ["ノ"] = "no",
		["ハ"] = "ha", ["ヒ"] = "hi", ["フ"] = "fu", ["ヘ"] = "he", ["ホ"] = "ho",
		["マ"] = "ma", ["ミ"] = "mi", ["ム"] = "mu", ["メ"] = "me", ["モ"] = "mo",
		["ヤ"] = "ya", ["ユ"] = "yu", ["ヨ"] = "yo", ["ラ"] = "ra", ["リ"] = "ri",
		["ル"] = "ru", ["レ"] = "re", ["ロ"] = "ro", ["ワ"] = "wa", ["ヲ"] = "wo",
		["ン"] = "n", ["ァ"] = "a", ["ィ"] = "i", ["ゥ"] = "u", ["ェ"] = "e",
		["ォ"] = "o", ["ャ"] = "ya", ["ュ"] = "yu", ["ョ"] = "yo", ["ガ"] = "ga",
		["ギ"] = "gi", ["グ"] = "gu", ["ゲ"] = "ge", ["ゴ"] = "go", ["ザ"] = "za",
		["ジ"] = "ji", ["ズ"] = "zu", ["ゼ"] = "ze", ["ゾ"] = "zo", ["ダ"] = "da",
		["ヂ"] = "ji", ["ヅ"] = "zu", ["デ"] = "de", ["ド"] = "do", ["バ"] = "ba",
		["ビ"] = "bi", ["ブ"] = "bu", ["ベ"] = "be", ["ボ"] = "bo", ["パ"] = "pa",
		["ピ"] = "pi", ["プ"] = "pu", ["ペ"] = "pe", ["ポ"] = "po", ["ッ"] = "tsu",
		["！"] = "!", ["？"] = "?", ["。"] = ".", ["ー"] = "-", ["『"] = "“",
		["』"] = "”", ["円"] = "$", ["．"] = ".", ["／"] = "/"
	},
}

local ActualPalette = {
	FRLG = {
	
	},
	RSE = {
		Hot_Springs = {
			[1] = 0x76EE,
			[2] = 0x43F6,
			[3] = 0x3310,
			[4] = 0x1A27,
			[5] = 0x0569,
			[6] = 0x0106,
			[7] = 0x76AC,
			[8] = 0x72AC,
			[9] = 0x7B31,
			[10] = 0x7F92,
			[11] = 0x3212,
			[12] = 0x4AB6,
			[13] = 0x6354,
			[14] = 0x530E,
			[15] = 0x42C8,
			[16] = 0x3683,
		},
		Tall_Grass = {
			[1] = 0x5E4B,
			[2] = 0x3731,
			[3] = 0x266D,
			[4] = 0x11A5,
			[5] = 0x0107,
			[6] = 0x00C4,
			[7] = 0x5E29,
			[8] = 0x4E29,
			[9] = 0x628D,
			[10] = 0x66CE,
			[11] = 0x25AE,
			[12] = 0x3A31,
			[13] = 0x4EB0,
			[14] = 0x426B,
			[15] = 0x3626,
			[16] = 0x2A02,
		},
	},
}

local Objects = {
	Jeff = {
		location = "NPC_Jeff", --Goes through map banks and searches for any matches of NPC_Jeff during load_object
		data = {
			local_id = 255,
			elevation = 3, --default
			movement_range_x = 0,
			movement_range_y = 0,
			trainer_type = 0,
			script = 1, --scripts are in LoadScript()
		}
	}
}

local Objects_Graphics = {
	FRLG = {
		Jeff = 69,
	},
	RS = {
		Jeff = 31,
	},
	E = {
		Jeff = 31,
	},
}

local movement_type_table = {
	Look_Down = 4,
	Look_Up = 3,
	Look_Left = 1,
	Look_Right = 2,
	Look_Around = 4,
	--Moving is unsupported atm
	Walk_Around = 6,
}

local dynamicReads = {
	gPlayerX = true,
	gPlayerY = true,
	gPlayerElevation = true,
	gPlayerAnimate = true,
	gPlayerAnimate2 = true,
	gPlayerAnimateType = true,
	gPlayerAnimateLength = true,
	gPlayerDirection = true,
	gMapFooter = true,
	gMapConnectionsAmount = true,
	gMapConnections = true,
	gMapBorderX = true,
	gMapBorderY = true,
	sNickname = true,
	sOTName = true,
	gPlayerRomSprite = true,
	sLinkOpen = true,
	gLinkType = true,
	gLocalLinkPlayer = true,
	gLinkPlayers = true,
	sSavedLinkPlayers = true,
}

function copyTemplate(template, overrides)
	local copy = {}
	for k, v in pairs(template) do
		copy[k] = v
	end
	for k, v in pairs(overrides) do
		copy[k] = v
	end
	return copy
end

function createMetatable(gameAddressTable)
	return setmetatable(gameAddressTable, {
		__index = function(tbl, key)
			if dynamicReads[key] then
				if key == "gMapFooter" then
					return emu:read32(tbl.gMapHeader)
				elseif key == "gMapConnectionsAmount" then
					return emu:read32(tbl.gMapHeader + 0xC)
				elseif key == "gMapConnections" then
					return emu:read32(tbl.gMapHeader + 0xC) + 4
				elseif key == "gMapBorderX" then
					return emu:read32(tbl.gMapHeader)
				elseif key == "gMapBorderY" then
					return emu:read32(tbl.gMapHeader) + 4
				elseif key == "gMapEventsNPCs" then
					return emu:read32(tbl.gMapHeader + 4) + 4
				elseif key == "sNickname" then
					return tbl.sIngameTrades + 0x3C
				elseif key == "sOTName" then
					return tbl.sIngameTrades + 0x67
				elseif key == "gPlayerRomSprite" then
					return emu:read32(tbl.gPlayerRomSpriteLocation)
				elseif key == "gPlayerX" then
					return tbl.gPlayerData
				elseif key == "gPlayerY" then
					return tbl.gPlayerData + 2
				elseif key == "gPlayerElevation" then
					return tbl.gPlayerData + 0xE
				elseif key == "gPlayerAnimate" then
					return tbl.gPlayerData + 0xC
				elseif key == "gPlayerAnimate2" then
					return tbl.gSpriteData + 0x2A
				elseif key == "gPlayerAnimateType" then
					return tbl.gSpriteData + 0x2B
				elseif key == "gPlayerAnimateLength" then
					return tbl.gSpriteData + 0x2C
				elseif key == "gPlayerDirection" then
					return tbl.gPlayerData + 0x10
				elseif key == "sLinkOpen" then
					return tbl.gSendBuffer + 0x100
				elseif key == "gLinkType" then
					return tbl.gSendBuffer + 0x102
				elseif key == "gLocalLinkPlayer" then
					return tbl.gSendBuffer + 0x108
				elseif key == "gLinkPlayers" then
					return tbl.gSendBuffer + 0x124
				elseif key == "sSavedLinkPlayers" then
					return tbl.gSendBuffer + 0x1B0
				end
			end
			return rawget(tbl, key)
		end
	})
end

-- Template for Firered/Leafgreen
local FRLGTemplate = {
	sGameType = "FRLG",
	sGameVersion = "FRLG",
	sBikeVersion = "FRLG",
	sAnimationTable = 1,
	gBuffer1 = 0x2021cd0,
	gBuffer2 = 0x2021cf0,
	gBuffer3 = 0x2021d04,
	gPartyCount = 0x2024029,
	gParty = 0x2024284,
	gEnemyPartyCount = 0x202402A,
	gEnemyParty = 0x202402c,
	gSprite = 0x30034c0,
	gTrainerCard = 0x2039624,
	gReceiveBuffer = 0x2022118,
	gSendBuffer = 0x2022618,
	gPlayerData = 0x2036e48,
	gCameraX = 0x3000e90,
	gCameraY = 0x3000e91,
	gPlayerSprite = 0x2020648,
	gSpriteData = 0x202063c,
	gMapBank = 0x203f3a8,
	gMapHeader = 0x2036dfc,
	gSpecialVar_8000 = 0x20370b8,
	gMainCallback = 0x30030f4,
	gMainSavedCallback = 0x30030f8,
	gLockControls = 0x3000f9c,
	gPaletteUnfaded = 0x20371f8,
	gPaletteFaded = 0x20375f8,
	gPaletteFade = 0x2037ab8,
	gGraphicsInfo = 0x839fe20,
	sObjectEventSpritePalettes = 0x83a51c8,
	gObjectEvents = 0x2036e38,
	sBlockSend = 0x3000e08,
	gLinkCallback = 0x3003f80,
	gPlayerAvatar = 0x2037078,
	gSaveBlock1Ptr = 0x3005008,
	gSaveBlock2Ptr = 0x300500c,
	
	gScriptData = 0x8a80000,
	gTextData = 0x8a7ffc0,
	gMultiChoiceData = 0x8a7ffa0,
	gNativeData = 0x8a90000,
	gScriptLoad = 0x3000ea8,
	gSelectedObjectEvent = 0x3005074,
	gPlayerRomSpriteLocation = 0x2021844,
	
	gWirelessCommType = 0x3003f3c,
	gBattleCommunication = 0x2023E82,
	gLinkPlayers = 0x202273c,
	gBlockReceivedStatus = 0x3003ebc,
	gReceivedRemoteLinkPlayers = 0x3003f64,
	gBattleControllerExecFlags = 0x2023bc8,
	gBattleBufferA = 0x2022bc4,
	gBattleBufferB = 0x20233c4,
	gActiveBattler = 0x2023bc4,
	gBattlerAttacker = 0x2023d6b,
	gBattlerTarget = 0x2023d6c,
	gEffectBattler = 0x2023d6e,
	gAbsentBattlerFlags = 0x2023d70,
	gBattleMainFunc = 0x3004f84,
	gBattlerControllerFuncs = 0x3004fe0,
	gBattleTypeFlags = 0x2022b4c,
	gChosenActionByBattler = 0x2023d7c,
	gBattleEXP = 0x2023fe0,
	gBattleMoveDamage = 0x2023d50,
}

local RSETemplate = {
	sGameType = "RSE",
	sGameVersion = "RS",
	sBikeVersion = "RS",
	sAnimationTable = 5,
	gBuffer1 = 0x20231cc,
	gBuffer2 = 0x20232cc,
	gBuffer3 = 0x20233cc,
	gPartyCount = 0x3004350,
	gParty = 0x3004360,
	gEnemyPartyCount = 0x30045b8, --not used?
	gEnemyParty = 0x30045c0,
	gSprite = 0x3001b44,
	gTrainerCard = 0x202ffc0,
	gReceiveBuffer = 0x3002b80,
	gSendBuffer = 0x3002a70,
	gPlayerData = 0x30048b0,
	gCameraX = 0x3000590,
	gCameraY = 0x3000591,
	gPlayerSprite = 0x2020010,
	gSpriteData = 0x2020004,
	gMapBank = 0x20392fc,
	gMapHeader = 0x202e828,
	gSpecialVar_8000 = 0x202e8c4,
	gMainCallback = 0x3001774,
	gMainSavedCallback = 0x3001778,
	gLockControls = 0x30006a4,
	gPaletteUnfaded = 0x202eac8,
	gPaletteFaded = 0x202eec8,
	gPaletteFade = 0x202f388,
	gGraphicsInfo = 0x836dc00,
	sObjectEventSpritePalettes = 0x8373724,
	gObjectEvents = 0x30048a0,
	sBlockSend = 0x30003e8,
	gLinkCallback = 0x3002fc0,
	gPlayerAvatar = 0x202e858,
	gSaveBlock1Ptr = 0x2025734,
	gSaveBlock2Ptr = 0x2024ea4,
	
	gScriptData = 0x8a80000,
	gTextData = 0x8a7ffc0,
	gMultiChoiceData = 0x8a7ffa0,
	gNativeData = 0x8a90000,
	gScriptLoad = 0x30005b0,
	gSelectedObjectEvent = 0x3004ae0,
	gPlayerRomSpriteLocation = 0x30024e0,
	
	--gWirelessCommType = , --ruby/sapphire do not use wireless? why?
	gBattleCommunication = 0x2024d1e,
	gLinkPlayers = 0x3002970,
	gBlockReceivedStatus = 0x30029e0,
	gReceivedRemoteLinkPlayers = 0x3002fa4,
	gBattleControllerExecFlags = 0x2024a64,
	gBattleBufferA = 0x2023a60,
	gBattleBufferB = 0x2024260,
	gActiveBattler = 0x2024a60,
	gBattlerAttacker = 0x2024c07,
	gBattlerTarget = 0x2024c08,
	gEffectBattler = 0x2024c0a,
	gAbsentBattlerFlags = 0x2024c0c,
	gBattleMainFunc = 0x30042d4,
	gBattlerControllerFuncs = 0x3004330,
	gBattleTypeFlags = 0x20239f8,
	gChosenActionByBattler = 0x2024c18,
	gBattleEXP = 0x201600F,
	gBattleMoveDamage = 0x2024bec,
}

local EmeraldTemplate = {
	sGameType = "RSE",
	sGameVersion = "E",
	sBikeVersion = "E",
	sAnimationTable = 3,
	gBuffer1 = 0x2021cc4,
	gBuffer2 = 0x2021dc4,
	gBuffer3 = 0x2021ec4,
	gPartyCount = 0x20244e9,
	gParty = 0x20244ec,
	gEnemyParty = 0x2024744,
	gEnemyPartyCount = 0x20244ea,
	gSprite = 0x3002680,
	gTrainerCard = 0x2039b58,
	gReceiveBuffer = 0x20223c4,
	gSendBuffer = 0x20228c4,
	gPlayerData = 0x2037360,
	gCameraX = 0x3000e20,
	gCameraY = 0x3000e21,
	gPlayerSprite = 0x202063c,
	gSpriteData = 0x2020630,
	gMapBank = 0x203bc80,
	gMapHeader = 0x2037318,
	gSpecialVar_8000 = 0x20375d8,
	gMainCallback = 0x30022c4,
	gMainSavedCallback = 0x30022c8,
	gLockControls = 0x3000f2c,
	gPaletteUnfaded = 0x2037714,
	gPaletteFaded = 0x2037b14,
	gPaletteFade = 0x2037fd4,
	gObjectEvents = 0x2037350,
	sBlockSend = 0x3000d10,
	gLinkCallback = 0x3003140,
	gPlayerAvatar = 0x2037590,
	gSaveBlock1Ptr = 0x3005d8c,
	gSaveBlock2Ptr = 0x3005d90,
	
	gScriptData = 0x8a80000,
	gTextData = 0x8a7ffc0,
	gMultiChoiceData = 0x8a7ffa0,
	gNativeData = 0x8a90000,
	gScriptLoad = 0x3000e38,
	gSelectedObjectEvent = 0x3004ae0,
	gPlayerRomSpriteLocation = 0x30024e0,
	
	gWirelessCommType = 0x30030fc,
	gBattleCommunication = 0x2024332,
	gLinkPlayers = 0x20229e8,
	gBlockReceivedStatus = 0x300307c,
	gReceivedRemoteLinkPlayers = 0x3003124,
	gBattleControllerExecFlags = 0x2024068,
	gBattleBufferA = 0x2023064,
	gBattleBufferB = 0x2023864,
	gActiveBattler = 0x2024064,
	gBattlerAttacker = 0x202420b,
	gBattlerTarget = 0x202420c,
	gEffectBattler = 0x202420e,
	gAbsentBattlerFlags = 0x2024210,
	gBattleMainFunc = 0x3005d04,
	gBattlerControllerFuncs = 0x3005d60,
	gBattleTypeFlags = 0x2022fec,
	gChosenActionByBattler = 0x202421c,
	gBattleEXP = 0x2024490,
	gBattleMoveDamage = 0x20241f0,
}

gAddress = {
	--Firered 1.0
	BPR1 = createMetatable(copyTemplate(FRLGTemplate, {
		gMultiChoice = 0x83E04C0,
		gMultiChoiceAmount = 0x83E04C4,
		sIngameTrades = 0x826CF8C,
		GenerateTrainerCard = 0x80898E9,

		gGraphicsInfo = 0x839FDB0,
		sObjectEventSpritePalettes = 0x83A5158,
		gBattleMoves = 0x8250c04,
		gExperienceTables = 0x8253ae4,
	
		Task_StartWiredCableClubBattle = 0x8081318,
		Task_StartWiredTrade = 0x8081850,
		OpenLink = 0x8009804,
		CreateTask = 0x807741C,
		SetUpBattleVars = 0x800d278,
		CB2_HandleStartBattle = 0x8010508,
		InitLocalLinkPlayer = 0x8009708,
		PlayerBufferExecCompleted = 0x802e33c,
		LinkOpponentBufferExecCompleted = 0x803b124,
		PrepareBufferDataTransfer = 0x800d8b0,
		GetMultiplayerId = 0x800a404,
		CB2_ReturnToField = 0x80567dc,
		SetBattleEndCallbacks = 0x802f610, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f610,
		HandleTurnActionSelectionState = 0x8014040,
		CB2_EndLinkBattle = 0x8011b94,
		BattleMainCB2 = 0x8011100,
		CB2_InitEndLinkBattle = 0x8011a1c,
		Cmd_getexp = 0x8021a68,
		InitLinkBattleVsScreen = 0x800f6fc,
		DestroyTask = 0x8077508,
		gSpeciesInfo = 0x8254784,
		CB2_WhiteOut = 0x80566a4,
	})),

	--Firered 1.1
	BPR2 = createMetatable(copyTemplate(FRLGTemplate, {
		gMultiChoice = 0x83E0530,
		gMultiChoiceAmount = 0x83E0534,
		sIngameTrades = 0x826CFFC,
		GenerateTrainerCard = 0x80898FD,

		gGraphicsInfo = 0x839FE20,
		sObjectEventSpritePalettes = 0x83A51C8,
		gBattleMoves = 0x8250c74,
		gExperienceTables = 0x8253b54,
		
		Task_StartWiredCableClubBattle = 0x808132c,
		Task_StartWiredTrade = 0x8081864,
		OpenLink = 0x8009818,
		CreateTask = 0x8077430,
		SetUpBattleVars = 0x800d28C,
		CB2_HandleStartBattle = 0x801051c,
		InitLocalLinkPlayer = 0x800971c,
		PlayerBufferExecCompleted = 0x802e350,
		LinkOpponentBufferExecCompleted = 0x803b138,
		PrepareBufferDataTransfer = 0x800d8c4,
		GetMultiplayerId = 0x800a418,
		CB2_ReturnToField = 0x80567f0,
		SetBattleEndCallbacks = 0x802f624, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f624,
		HandleTurnActionSelectionState = 0x8014054,
		CB2_EndLinkBattle = 0x8011ba8,
		BattleMainCB2 = 0x8011114,
		CB2_InitEndLinkBattle = 0x8011a30,
		Cmd_getexp = 0x8021a7c,
		InitLinkBattleVsScreen = 0x800f710,
		DestroyTask = 0x807751c,
		gSpeciesInfo = 0x82547f4,
		CB2_WhiteOut = 0x80566b8,
	})),

	--Firered Japan
	BPRJ = createMetatable(copyTemplate(FRLGTemplate, {
		gBuffer1 = 0x2021C4C,
		gBuffer2 = 0x2021C60,
		gBuffer3 = 0x2021C6C,
		gPartyCount = 0x2023F89,
		gParty = 0x20241E4,
		gEnemyParty = 0x2023F8C,
		gEnemyPartyCount = 0x2023F8A,
		--gSprite = 0x30034c0,
		gTrainerCard = 0x2039570,
		gReceiveBuffer = 0x2022088,
		gSendBuffer = 0x2022588,
		gPlayerData = 0x2036D7C,
		--gCameraX = 0x3000e90,
		--gCameraY = 0x3000e91,
		gPlayerSprite = 0x20205C4,
		gSpriteData = 0x20205B8,
		gMapBank = 0x203F31C,
		gMapHeader = 0x2036D30,
		gSpecialVar_8000 = 0x2036FEC,
		gMainCallback = 0x3003134,
		gMainSavedCallback = 0x3003138,
		--gLockControls = 0x3000f9c,
		gPaletteUnfaded = 0x203712c,
		gPaletteFaded = 0x203752c,
		gPaletteFade = 0x20379ec,
		gMultiChoice = 0x83A558C,
		gMultiChoiceAmount = 0x83A5590,
		sIngameTrades = 0x822D2F8,
		GenerateTrainerCard = 0x8089499,
		gObjectEvents = 0x2036D6C,
		gLinkCallback = 0x3003fc0,
		gPlayerAvatar = 0x2036fac,
		gSaveBlock1Ptr = 0x3005048,
		gSaveBlock2Ptr = 0x300504c,

		gGraphicsInfo = 0x8363E38,
		sObjectEventSpritePalettes = 0x83691E0,
		
		--4.0 mem stuff
		gWirelessCommType = 0x3003f7c,
		gBattleCommunication = 0x2023de2,
		gLinkPlayers = 0x20226ac,
		gBlockReceivedStatus = 0x3003efc,
		gReceivedRemoteLinkPlayers = 0x3003fa4,
		gBattleControllerExecFlags = 0x2023b28,
		gBattleBufferA = 0x2022b24,
		gBattleBufferB = 0x2023324,
		gActiveBattler = 0x2023b24,
		gBattlerAttacker = 0x2023ccb,
		gBattlerTarget = 0x2023ccc,
		gEffectBattler = 0x2023cce,
		gAbsentBattlerFlags = 0x2023cd0,
		gBattleMainFunc = 0x3004fc4,
		gBattlerControllerFuncs = 0x3005020,
		gBattleTypeFlags = 0x2022aac,
		gChosenActionByBattler = 0x2023cdc,
		gBattleEXP = 0x2023f40,
		gBattleMoveDamage = 0x2023cb0,
		
		--4.0 rom stuff
		gBattleMoves = 0x820d60c,
		gExperienceTables = 0x82104ec,
		Task_StartWiredCableClubBattle = 0x80809f8,
		Task_StartWiredTrade = 0x8080f2c,
		OpenLink = 0x800922c,
		CreateTask = 0x8076bb4,
		SetUpBattleVars = 0x800cc9c,
		CB2_HandleStartBattle = 0x800fec4,
		InitLocalLinkPlayer = 0x8009130,
		PlayerBufferExecCompleted = 0x802db18,
		LinkOpponentBufferExecCompleted = 0x803a890,
		PrepareBufferDataTransfer = 0x800d2d4,
		GetMultiplayerId = 0x8009e24,
		CB2_ReturnToField = 0x805609c,
		SetBattleEndCallbacks = 0x802ed90, --only for emerald
		SetLinkBattleEndCallbacks = 0x802ed90,
		HandleTurnActionSelectionState = 0x8013860,
		CB2_EndLinkBattle = 0x801143c,
		BattleMainCB2 = 0x80109c0,
		CB2_InitEndLinkBattle = 0x80112c4,
		Cmd_getexp = 0x8021278,
		InitLinkBattleVsScreen = 0x800f0b0,
		DestroyTask = 0x8076ca0,
		gSpeciesInfo = 0x821118c,
		CB2_WhiteOut = 0x8055f64,
	})),

	--Firered French
	BPRF = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83D87BC,
		gMultiChoiceAmount = 0x83D87C0,
		sIngameTrades = 0x82673DC,
		GenerateTrainerCard = 0x8089A8D,

		gGraphicsInfo = 0x839A1A0,
		sObjectEventSpritePalettes = 0x839F548,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x824b054,
		gExperienceTables = 0x824dfa4,
		Task_StartWiredCableClubBattle = 0x808133c,
		Task_StartWiredTrade = 0x8081874,
		OpenLink = 0x8009770,
		CreateTask = 0x8077440,
		SetUpBattleVars = 0x800d1e8,
		CB2_HandleStartBattle = 0x8010478,
		InitLocalLinkPlayer = 0x8009674,
		PlayerBufferExecCompleted = 0x802e2ac,
		LinkOpponentBufferExecCompleted = 0x803affc,
		PrepareBufferDataTransfer = 0x800d820,
		GetMultiplayerId = 0x800a370,
		CB2_ReturnToField = 0x80568bc,
		SetBattleEndCallbacks = 0x802f4e8, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f4e8,
		HandleTurnActionSelectionState = 0x8013fb0,
		CB2_EndLinkBattle = 0x8011b04,
		BattleMainCB2 = 0x8011070,
		CB2_InitEndLinkBattle = 0x801198c,
		Cmd_getexp = 0x80219d8,
		InitLinkBattleVsScreen = 0x800f66c,
		DestroyTask = 0x807752c,
		gSpeciesInfo = 0x824ebd4,
		CB2_WhiteOut = 0x8056784,
	})),

	--Firered German
	BPRD = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83DF9B0,
		gMultiChoiceAmount = 0x83DF9B4,
		sIngameTrades = 0x826CEB0,
		GenerateTrainerCard = 0x80899CD,

		gGraphicsInfo = 0x839FC74,
		sObjectEventSpritePalettes = 0x83A501C,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x8250b28,
		gExperienceTables = 0x8253a78,
		Task_StartWiredCableClubBattle = 0x808127c,
		Task_StartWiredTrade = 0x80817b4,
		OpenLink = 0x8009784,
		CreateTask = 0x8077380,
		SetUpBattleVars = 0x800d1fc,
		CB2_HandleStartBattle = 0x801048c,
		InitLocalLinkPlayer = 0x8009688,
		PlayerBufferExecCompleted = 0x802e2d4,
		LinkOpponentBufferExecCompleted = 0x803b024,
		PrepareBufferDataTransfer = 0x800d834,
		GetMultiplayerId = 0x800a384,
		CB2_ReturnToField = 0x80567fc,
		SetBattleEndCallbacks = 0x802f510, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f510,
		HandleTurnActionSelectionState = 0x8013fc4,
		CB2_EndLinkBattle = 0x8011b18,
		BattleMainCB2 = 0x8011084,
		CB2_InitEndLinkBattle = 0x80119a0,
		Cmd_getexp = 0x80219ec,
		InitLinkBattleVsScreen = 0x800f680,
		DestroyTask = 0x807746c,
		gSpeciesInfo = 0x82546a8,
		CB2_WhiteOut = 0x80566c4,
	})),

	--Firered Spanish
	BPRS = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83DA3E8,
		gMultiChoiceAmount = 0x83DA3EC,
		sIngameTrades = 0x8268754,
		GenerateTrainerCard = 0x8089AA1,

		gGraphicsInfo = 0x839B518,
		sObjectEventSpritePalettes = 0x83A08C0,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x824c3cc,
		gExperienceTables = 0x824f31c,
		Task_StartWiredCableClubBattle = 0x8081350,
		Task_StartWiredTrade = 0x8081888,
		OpenLink = 0x8009770,
		CreateTask = 0x8077454,
		SetUpBattleVars = 0x800d1e8,
		CB2_HandleStartBattle = 0x8010478,
		InitLocalLinkPlayer = 0x8009674,
		PlayerBufferExecCompleted = 0x802e2c0,
		LinkOpponentBufferExecCompleted = 0x803b010,
		PrepareBufferDataTransfer = 0x800d820,
		GetMultiplayerId = 0x800a370,
		CB2_ReturnToField = 0x80568d0,
		SetBattleEndCallbacks = 0x802f4fc, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f4fc,
		HandleTurnActionSelectionState = 0x8013fb0,
		CB2_EndLinkBattle = 0x8011b04,
		BattleMainCB2 = 0x8011070,
		CB2_InitEndLinkBattle = 0x801198c,
		Cmd_getexp = 0x80219d8,
		InitLinkBattleVsScreen = 0x800f66c,
		DestroyTask = 0x8077540,
		gSpeciesInfo = 0x824ff4c,
		CB2_WhiteOut = 0x8056798,
	})),

	--Firered Italian
	BPRI = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83D7380,
		gMultiChoiceAmount = 0x83D7384,
		sIngameTrades = 0x826606C,
		GenerateTrainerCard = 0x80899B9,

		gGraphicsInfo = 0x8398E30,
		sObjectEventSpritePalettes = 0x839E1D8,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x8249ce4,
		gExperienceTables = 0x824cc34,
		Task_StartWiredCableClubBattle = 0x8081268,
		Task_StartWiredTrade = 0x80817a0,
		OpenLink = 0x8009784,
		CreateTask = 0x807736c,
		SetUpBattleVars = 0x800d1fc,
		CB2_HandleStartBattle = 0x801048c,
		InitLocalLinkPlayer = 0x8009688,
		PlayerBufferExecCompleted = 0x802e2c0,
		LinkOpponentBufferExecCompleted = 0x803b010,
		PrepareBufferDataTransfer = 0x800d834,
		GetMultiplayerId = 0x800a384,
		CB2_ReturnToField = 0x80567e8,
		SetBattleEndCallbacks = 0x802f4fc, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f4fc,
		HandleTurnActionSelectionState = 0x8013fc4,
		CB2_EndLinkBattle = 0x8011b18,
		BattleMainCB2 = 0x8011084,
		CB2_InitEndLinkBattle = 0x80119a0,
		Cmd_getexp = 0x80219ec,
		InitLinkBattleVsScreen = 0x800f680,
		DestroyTask = 0x8077458,
		gSpeciesInfo = 0x824d864,
		CB2_WhiteOut = 0x80566b0,
	})),

	--Leafgreen 1.0
	BPG1 = createMetatable(copyTemplate(FRLGTemplate, {
		gMultiChoice = 0x83E02FC,
		gMultiChoiceAmount = 0x83E0300,
		sIngameTrades = 0x8268734,
		GenerateTrainerCard = 0x80898BD,

		gGraphicsInfo = 0x839FD90,
		sObjectEventSpritePalettes = 0x83A5138,
		gBattleMoves = 0x8250be0,
		gExperienceTables = 0x8253ac0,
	
		Task_StartWiredCableClubBattle = 0x80812ec,
		Task_StartWiredTrade = 0x8081824,
		OpenLink = 0x8009804,
		CreateTask = 0x807741C,
		SetUpBattleVars = 0x800d278,
		CB2_HandleStartBattle = 0x8010508,
		InitLocalLinkPlayer = 0x8009708,
		PlayerBufferExecCompleted = 0x802e33c,
		LinkOpponentBufferExecCompleted = 0x803b124,
		PrepareBufferDataTransfer = 0x800d8b0,
		GetMultiplayerId = 0x800a404,
		CB2_ReturnToField = 0x80567dc,
		SetBattleEndCallbacks = 0x802f610, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f610,
		HandleTurnActionSelectionState = 0x8014040,
		CB2_EndLinkBattle = 0x8011b94,
		BattleMainCB2 = 0x8011100,
		CB2_InitEndLinkBattle = 0x8011a1c,
		Cmd_getexp = 0x8021a68,
		InitLinkBattleVsScreen = 0x800f6fc,
		DestroyTask = 0x8077508,
		gSpeciesInfo = 0x8254760,
		CB2_WhiteOut = 0x80566a4,
	})),

	--Leafgreen 1.1
	BPG2 = createMetatable(copyTemplate(FRLGTemplate, {
		gMultiChoice = 0x83E036C,
		gMultiChoiceAmount = 0x83E0370,
		sIngameTrades = 0x826CFDC,
		GenerateTrainerCard = 0x80898D1,

		gGraphicsInfo = 0x839FE00,
		sObjectEventSpritePalettes = 0x83A51A8,
		gBattleMoves = 0x8250c50,
		gExperienceTables = 0x8253b30,
		
		Task_StartWiredCableClubBattle = 0x8081300,
		Task_StartWiredTrade = 0x8081838,
		OpenLink = 0x8009818,
		CreateTask = 0x8077430,
		SetUpBattleVars = 0x800d28c,
		CB2_HandleStartBattle = 0x801051c,
		InitLocalLinkPlayer = 0x800971c,
		PlayerBufferExecCompleted = 0x802e350,
		LinkOpponentBufferExecCompleted = 0x803b138,
		PrepareBufferDataTransfer = 0x800d8c4,
		GetMultiplayerId = 0x800a418,
		CB2_ReturnToField = 0x80567f0,
		SetBattleEndCallbacks = 0x802f624, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f624,
		HandleTurnActionSelectionState = 0x8014054,
		CB2_EndLinkBattle = 0x8011ba8,
		BattleMainCB2 = 0x8011114,
		CB2_InitEndLinkBattle = 0x8011a30,
		Cmd_getexp = 0x8021a7c,
		InitLinkBattleVsScreen = 0x800f710,
		DestroyTask = 0x807751c,
		gSpeciesInfo = 0x82547d0,
		CB2_WhiteOut = 0x80566b8,
	})),

	--Leafgreen Japanese
	BPGJ = createMetatable(copyTemplate(FRLGTemplate, {
		gBuffer1 = 0x2021C4C,
		gBuffer2 = 0x2021C60,
		gBuffer3 = 0x2021C6C,
		gPartyCount = 0x2023F89,
		gParty = 0x20241E4,
		gEnemyParty = 0x2023F8C,
		gTrainerCard = 0x2039570,
		gSendBuffer = 0x2022588,
		gPlayerData = 0x2036D7C,
		gPlayerSprite = 0x20205C4,
		gSpriteData = 0x20205B8,
		gMapBank = 0x203F31C,
		gMapHeader = 0x2036D30,
		gSpecialVar_8000 = 0x2036FEC,
		gMainCallback = 0x3003134,
		gMainSavedCallback = 0x3003138,
		gMultiChoice = 0x83A53FC,
		gMultiChoiceAmount = 0x83A5400,
		sIngameTrades = 0x822D2D8,
		GenerateTrainerCard = 0x808946D,

		gGraphicsInfo = 0x8363E18,
		sObjectEventSpritePalettes = 0x83691C0,
		
		--4.0 japan stuff
		gEnemyPartyCount = 0x2023F8A,
		gReceiveBuffer = 0x2022088,
		gPaletteUnfaded = 0x203712c,
		gPaletteFaded = 0x203752c,
		gPaletteFade = 0x20379ec,
		gObjectEvents = 0x2036D6C,
		gLinkCallback = 0x3003fc0,
		gPlayerAvatar = 0x2036fac,
		gSaveBlock1Ptr = 0x3005048,
		gSaveBlock2Ptr = 0x300504c,
		
		--4.0 mem stuff
		gWirelessCommType = 0x3003f7c,
		gBattleCommunication = 0x2023de2,
		gLinkPlayers = 0x20226ac,
		gBlockReceivedStatus = 0x3003efc,
		gReceivedRemoteLinkPlayers = 0x3003fa4,
		gBattleControllerExecFlags = 0x2023b28,
		gBattleBufferA = 0x2022b24,
		gBattleBufferB = 0x2023324,
		gActiveBattler = 0x2023b24,
		gBattlerAttacker = 0x2023ccb,
		gBattlerTarget = 0x2023ccc,
		gEffectBattler = 0x2023cce,
		gAbsentBattlerFlags = 0x2023cd0,
		gBattleMainFunc = 0x3004fc4,
		gBattlerControllerFuncs = 0x3005020,
		gBattleTypeFlags = 0x2022aac,
		gChosenActionByBattler = 0x2023cdc,
		gBattleEXP = 0x2023f40,
		gBattleMoveDamage = 0x2023cb0,
		
		--4.0 rom stuff
		gBattleMoves = 0x820d5e8,
		gExperienceTables = 0x82104c8,
		Task_StartWiredCableClubBattle = 0x80809cc,
		Task_StartWiredTrade = 0x8080f00,
		OpenLink = 0x800922c,
		CreateTask = 0x8076bb4,
		SetUpBattleVars = 0x800cc9c,
		CB2_HandleStartBattle = 0x800fec4,
		InitLocalLinkPlayer = 0x8009130,
		PlayerBufferExecCompleted = 0x802db18,
		LinkOpponentBufferExecCompleted = 0x803a890,
		PrepareBufferDataTransfer = 0x800d2d4,
		GetMultiplayerId = 0x8009e24,
		CB2_ReturnToField = 0x805609c,
		SetBattleEndCallbacks = 0x802ed90, --only for emerald
		SetLinkBattleEndCallbacks = 0x802ed90,
		HandleTurnActionSelectionState = 0x8013860,
		CB2_EndLinkBattle = 0x801143c,
		BattleMainCB2 = 0x80109c0,
		CB2_InitEndLinkBattle = 0x80112c4,
		Cmd_getexp = 0x8021278,
		InitLinkBattleVsScreen = 0x800f0b0,
		DestroyTask = 0x8076ca0,
		gSpeciesInfo = 0x8211168,
		CB2_WhiteOut = 0x8055f64,
	})),

	--Leafgreen French
	BPGF = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83D85F8,
		gMultiChoiceAmount = 0x83D85FC,
		sIngameTrades = 0x82673BC,
		GenerateTrainerCard = 0x8089A61,

		gGraphicsInfo = 0x839A180,
		sObjectEventSpritePalettes = 0x839F528,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x824b030,
		gExperienceTables = 0x824df10,
		Task_StartWiredCableClubBattle = 0x8081310,
		Task_StartWiredTrade = 0x8081848,
		OpenLink = 0x8009770,
		CreateTask = 0x8077440,
		SetUpBattleVars = 0x800d1e8,
		CB2_HandleStartBattle = 0x8010478,
		InitLocalLinkPlayer = 0x8009674,
		PlayerBufferExecCompleted = 0x802e2ac,
		LinkOpponentBufferExecCompleted = 0x803affc,
		PrepareBufferDataTransfer = 0x800d820,
		GetMultiplayerId = 0x800a370,
		CB2_ReturnToField = 0x80568bc,
		SetBattleEndCallbacks = 0x802f4e8, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f4e8,
		HandleTurnActionSelectionState = 0x8013fb0,
		CB2_EndLinkBattle = 0x8011b04,
		BattleMainCB2 = 0x8011070,
		CB2_InitEndLinkBattle = 0x801198c,
		Cmd_getexp = 0x80219d8,
		InitLinkBattleVsScreen = 0x800f66c,
		DestroyTask = 0x807752c,
		gSpeciesInfo = 0x824ebb0,
		CB2_WhiteOut = 0x8056784,
	})),

	--Leafgreen German
	BPGD = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83DF7EC,
		gMultiChoiceAmount = 0x83DF7F0,
		sIngameTrades = 0x826CE90,
		GenerateTrainerCard = 0x80899A1,

		gGraphicsInfo = 0x839FC54,
		sObjectEventSpritePalettes = 0x83A4FFC,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x8250b04,
		gExperienceTables = 0x82539e4,
		Task_StartWiredCableClubBattle = 0x8081250,
		Task_StartWiredTrade = 0x8081888,
		OpenLink = 0x8009784,
		CreateTask = 0x8077380,
		SetUpBattleVars = 0x800d1fc,
		CB2_HandleStartBattle = 0x801048c,
		InitLocalLinkPlayer = 0x8009688,
		PlayerBufferExecCompleted = 0x802e2d4,
		LinkOpponentBufferExecCompleted = 0x803b024,
		PrepareBufferDataTransfer = 0x800d834,
		GetMultiplayerId = 0x800a384,
		CB2_ReturnToField = 0x80567fc,
		SetBattleEndCallbacks = 0x802f510, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f510,
		HandleTurnActionSelectionState = 0x8013fc4,
		CB2_EndLinkBattle = 0x8011b18,
		BattleMainCB2 = 0x8011084,
		CB2_InitEndLinkBattle = 0x80119a0,
		Cmd_getexp = 0x80219ec,
		InitLinkBattleVsScreen = 0x800f680,
		DestroyTask = 0x807746c,
		gSpeciesInfo = 0x8254684,
		CB2_WhiteOut = 0x80566c4,
	})),

	--Leafgreen Spanish
	BPGS = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83DA224,
		gMultiChoiceAmount = 0x83DA228,
		sIngameTrades = 0x8268734,
		GenerateTrainerCard = 0x8089A75,

		gGraphicsInfo = 0x839B4F8,
		sObjectEventSpritePalettes = 0x83A08A0,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x824c3a8,
		gExperienceTables = 0x824f288,
		Task_StartWiredCableClubBattle = 0x8081324,
		Task_StartWiredTrade = 0x808185c,
		OpenLink = 0x8009770,
		CreateTask = 0x8077454,
		SetUpBattleVars = 0x800d1e8,
		CB2_HandleStartBattle = 0x8010478,
		InitLocalLinkPlayer = 0x8009674,
		PlayerBufferExecCompleted = 0x802e2c0,
		LinkOpponentBufferExecCompleted = 0x803b010,
		PrepareBufferDataTransfer = 0x800d820,
		GetMultiplayerId = 0x800a370,
		CB2_ReturnToField = 0x80568d0,
		SetBattleEndCallbacks = 0x802f4fc, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f4fc,
		HandleTurnActionSelectionState = 0x8013fb0,
		CB2_EndLinkBattle = 0x8011b04,
		BattleMainCB2 = 0x8011070,
		CB2_InitEndLinkBattle = 0x801198c,
		Cmd_getexp = 0x80219d8,
		InitLinkBattleVsScreen = 0x800f66c,
		DestroyTask = 0x8077540,
		gSpeciesInfo = 0x824ff28,
		CB2_WhiteOut = 0x8056798,
	})),

	--Leafgreen Italian
	BPGI = createMetatable(copyTemplate(FRLGTemplate, {
		gSprite = 0x3003410,
		gMainCallback = 0x3003044,
		gMainSavedCallback = 0x3003048,
		gMultiChoice = 0x83D71BC,
		gMultiChoiceAmount = 0x83D71C0,
		sIngameTrades = 0x826604C,
		GenerateTrainerCard = 0x808998D,

		gGraphicsInfo = 0x8398E10,
		sObjectEventSpritePalettes = 0x839E1B8,
		
		--4.0 mem stuff
		sBlockSend = 0x3000e08,
		gLinkCallback = 0x3003ed0,
		gSaveBlock1Ptr = 0x3004F58,
		gSaveBlock2Ptr = 0x3004F5C,
	
		--4.0 mem battle stuff
		gWirelessCommType = 0x3003e8c,
		gBlockReceivedStatus = 0x3003e0c,
		gReceivedRemoteLinkPlayers = 0x3003eb4,
		gBattleMainFunc = 0x3004ed4,
		gBattlerControllerFuncs = 0x3004f30,
		
		--4.0 rom stuff
		gBattleMoves = 0x8249cc0,
		gExperienceTables = 0x824cba0,
		Task_StartWiredCableClubBattle = 0x808123c,
		Task_StartWiredTrade = 0x8081874,
		OpenLink = 0x8009784,
		CreateTask = 0x807736c,
		SetUpBattleVars = 0x800d1fc,
		CB2_HandleStartBattle = 0x801048c,
		InitLocalLinkPlayer = 0x8009688,
		PlayerBufferExecCompleted = 0x802e2c0,
		LinkOpponentBufferExecCompleted = 0x803b010,
		PrepareBufferDataTransfer = 0x800d834,
		GetMultiplayerId = 0x800a384,
		CB2_ReturnToField = 0x80567e8,
		SetBattleEndCallbacks = 0x802f4fc, --only for emerald
		SetLinkBattleEndCallbacks = 0x802f4fc,
		HandleTurnActionSelectionState = 0x8013fc4,
		CB2_EndLinkBattle = 0x8011b18,
		BattleMainCB2 = 0x8011084,
		CB2_InitEndLinkBattle = 0x80119a0,
		Cmd_getexp = 0x80219ec,
		InitLinkBattleVsScreen = 0x800f680,
		DestroyTask = 0x8077458,
		gSpeciesInfo = 0x824d840,
		CB2_WhiteOut = 0x80566b0,
	})),

	--Emerald
	BPEE = createMetatable(copyTemplate(EmeraldTemplate, {
		gMultiChoice = 0x858B770,
		gMultiChoiceAmount = 0x858B774,
		sIngameTrades = 0x8338ED0,
		GenerateTrainerCard = 0x80C30A5,

		gGraphicsInfo = 0x8505620,
		sObjectEventSpritePalettes = 0x850BBC8,
		gBattleMoves = 0x831c898,
		gExperienceTables = 0x831f72c,
	
		Task_StartWiredCableClubBattle = 0x80b32b4,
		Task_StartWiredTrade = 0x80b37fc,
		OpenLink = 0x8009734,
		CreateTask = 0x80a8fb0,
		SetUpBattleVars = 0x803269c,
		CB2_HandleStartBattle = 0x8036fac,
		InitLocalLinkPlayer = 0x8009638,
		PlayerBufferExecCompleted = 0x805748c,
		LinkOpponentBufferExecCompleted = 0x8065068,
		PrepareBufferDataTransfer = 0x80331b8,
		GetMultiplayerId = 0x800a468,
		CB2_ReturnToField = 0x80860c8,
		SetBattleEndCallbacks = 0x80587b0,
		SetLinkBattleEndCallbacks = 0x80586f8,
		HandleTurnActionSelectionState = 0x803be74,
		CB2_EndLinkBattle = 0x8038f14,
		BattleMainCB2 = 0x8038420,
		CB2_InitEndLinkBattle = 0x8038d64,
		Cmd_getexp = 0x804a32c,
		InitLinkBattleVsScreen = 0x8035d74,
		DestroyTask = 0x80a909c,
		gSpeciesInfo = 0x83203cc,
		CB2_WhiteOut = 0x8085f58,
	})),

	--Emerald Japanese
	BPEJ = createMetatable(copyTemplate(EmeraldTemplate, {
		gBuffer1 = 0x2021C40,
		gBuffer2 = 0x2021C54,
		gBuffer3 = 0x2021C60,
		gPartyCount = 0x202418D,
		gParty = 0x2024190,
		gEnemyParty = 0x20243E8,
		gTrainerCard = 0x20397F8,
		gSendBuffer = 0x202257C,
		gPlayerData = 0x2037000,
		gPlayerSprite = 0x20205B8,
		gSpriteData = 0x20205AC,
		gMapBank = 0x203B94C,
		gMapHeader = 0x2036FB8,
		gSpecialVar_8000 = 0x2037278,
		gMainCallback = 0x3002364,
		gMainSavedCallback = 0x3002368,
		gMultiChoice = 0x8564228,
		gMultiChoiceAmount = 0x856422C,
		sIngameTrades = 0x830D114,
		GenerateTrainerCard = 0x80C26D5,

		gGraphicsInfo = 0x84DDA74,
		sObjectEventSpritePalettes = 0x84E401C,
		
		--4.0 japan stuff
		gEnemyPartyCount = 0x202418e,
		gReceiveBuffer = 0x202207C,
		gPaletteUnfaded = 0x20373b4,
		gPaletteFaded = 0x20377b4,
		gPaletteFade = 0x2037c74,
		gObjectEvents = 0x2036ff0,
		gLinkCallback = 0x30031e0,
		gPlayerAvatar = 0x2037230,
		gSaveBlock1Ptr = 0x3005aec,
		gSaveBlock2Ptr = 0x3005af0,
		
		--4.0 mem stuff
		gWirelessCommType = 0x300319c,
		gBattleCommunication = 0x2023fd6,
		gLinkPlayers = 0x20226a0,
		gBlockReceivedStatus = 0x300311c,
		gReceivedRemoteLinkPlayers = 0x30031c4,
		gBattleControllerExecFlags = 0x2023d0c,
		gBattleBufferA = 0x2022d08,
		gBattleBufferB = 0x2023508,
		gActiveBattler = 0x2023d08,
		gBattlerAttacker = 0x2023eaf,
		gBattlerTarget = 0x2023eb0,
		gEffectBattler = 0x2023eb2,
		gAbsentBattlerFlags = 0x2023eb4,
		gBattleMainFunc = 0x3005a64,
		gBattlerControllerFuncs = 0x3005ac0,
		gBattleTypeFlags = 0x2022c90,
		gChosenActionByBattler = 0x2023ec0,
		gBattleEXP = 0x2024134,
		gBattleMoveDamage = 0x2023e94,
		
		--4.0 rom stuff
		gBattleMoves = 0x82ed220,
		gExperienceTables = 0x82f00b4,
		Task_StartWiredCableClubBattle = 0x80b2a60,
		Task_StartWiredTrade = 0x80b2f58,
		OpenLink = 0x80092d0,
		CreateTask = 0x80a8878,
		SetUpBattleVars = 0x8032534,
		CB2_HandleStartBattle = 0x8036e00,
		InitLocalLinkPlayer = 0x80091d4,
		PlayerBufferExecCompleted = 0x805709c,
		LinkOpponentBufferExecCompleted = 0x8064c4c,
		PrepareBufferDataTransfer = 0x8033050,
		GetMultiplayerId = 0x800a02c,
		CB2_ReturnToField = 0x8085a30,
		SetBattleEndCallbacks = 0x80583c0,
		SetLinkBattleEndCallbacks = 0x8058308,
		HandleTurnActionSelectionState = 0x803bab8,
		CB2_EndLinkBattle = 0x8038bc8,
		BattleMainCB2 = 0x80380fc,
		CB2_InitEndLinkBattle = 0x8038a18,
		Cmd_getexp = 0x8049f6c,
		InitLinkBattleVsScreen = 0x8035bc8,
		DestroyTask = 0x80a8964,
		gSpeciesInfo = 0x82f0d54,
		CB2_WhiteOut = 0x80858c0,
	})),

	--Emerald French
	BPEF = createMetatable(copyTemplate(EmeraldTemplate, {
		gSprite = 0x3002680,
		gMultiChoice = 0x858FB40,
		gMultiChoiceAmount = 0x858FB44,
		sIngameTrades = 0x8340A54,
		GenerateTrainerCard = 0x80C2E89,

		gGraphicsInfo = 0x850A50C,
		sObjectEventSpritePalettes = 0x8510AB4,
	
		--4.0 rom stuff
		gBattleMoves = 0x8324408,
		gExperienceTables = 0x832729c,
		Task_StartWiredCableClubBattle = 0x80b32c8,
		Task_StartWiredTrade = 0x80b3810,
		OpenLink = 0x8009734,
		CreateTask = 0x80a8fc4,
		SetUpBattleVars = 0x803269c,
		CB2_HandleStartBattle = 0x8036fac,
		InitLocalLinkPlayer = 0x8009638,
		PlayerBufferExecCompleted = 0x805748c,
		LinkOpponentBufferExecCompleted = 0x8065068,
		PrepareBufferDataTransfer = 0x80331b8,
		GetMultiplayerId = 0x800a468,
		CB2_ReturnToField = 0x80860d8,
		SetBattleEndCallbacks = 0x80587b0,
		SetLinkBattleEndCallbacks = 0x80586f8,
		HandleTurnActionSelectionState = 0x803be74,
		CB2_EndLinkBattle = 0x8038f14,
		BattleMainCB2 = 0x8038420,
		CB2_InitEndLinkBattle = 0x8038d64,
		Cmd_getexp = 0x804a32c,
		InitLinkBattleVsScreen = 0x8035d74,
		DestroyTask = 0x80a90b0,
		gSpeciesInfo = 0x8327f3c,
		CB2_WhiteOut = 0x8085f68,
	})),

	--Emerald German
	BPED = createMetatable(copyTemplate(EmeraldTemplate, {
		gSprite = 0x3002690,
		gMultiChoice = 0x859C478,
		gMultiChoiceAmount = 0x859C47C,
		sIngameTrades = 0x834D89C,
		GenerateTrainerCard = 0x80C2E71,

		gGraphicsInfo = 0x8517350,
		sObjectEventSpritePalettes = 0x851D8F8,
	
		--4.0 rom stuff
		gBattleMoves = 0x8331258,
		gExperienceTables = 0x83340ec,
		Task_StartWiredCableClubBattle = 0x80b32d0,
		Task_StartWiredTrade = 0x80b3818,
		OpenLink = 0x8009734,
		CreateTask = 0x80a8fcc,
		SetUpBattleVars = 0x80326a0,
		CB2_HandleStartBattle = 0x8036fb0,
		InitLocalLinkPlayer = 0x8009638,
		PlayerBufferExecCompleted = 0x8057490,
		LinkOpponentBufferExecCompleted = 0x806506c,
		PrepareBufferDataTransfer = 0x80331bc,
		GetMultiplayerId = 0x800a468,
		CB2_ReturnToField = 0x80860e4,
		SetBattleEndCallbacks = 0x80587b4,
		SetLinkBattleEndCallbacks = 0x80586fc,
		HandleTurnActionSelectionState = 0x803be78,
		CB2_EndLinkBattle = 0x8038f18,
		BattleMainCB2 = 0x8038424,
		CB2_InitEndLinkBattle = 0x8038d68,
		Cmd_getexp = 0x804a330,
		InitLinkBattleVsScreen = 0x8035d78,
		DestroyTask = 0x80a90b8,
		gSpeciesInfo = 0x8334d8c,
		CB2_WhiteOut = 0x8085f74,
	})),

	--Emerald Spanish
	BPES = createMetatable(copyTemplate(EmeraldTemplate, {
		gMultiChoice = 0x858E134,
		gMultiChoiceAmount = 0x858E138,
		sIngameTrades = 0x833F1AC,
		GenerateTrainerCard = 0x80C2E69,

		gGraphicsInfo = 0x8508C7C,
		sObjectEventSpritePalettes = 0x850F224,
	
		--4.0 rom stuff
		gBattleMoves = 0x8322b54,
		gExperienceTables = 0x83259e8,
		Task_StartWiredCableClubBattle = 0x80b32c8,
		Task_StartWiredTrade = 0x80b3810,
		OpenLink = 0x8009734,
		CreateTask = 0x80a8fc4,
		SetUpBattleVars = 0x803269c,
		CB2_HandleStartBattle = 0x8036fac,
		InitLocalLinkPlayer = 0x8009638,
		PlayerBufferExecCompleted = 0x805748c,
		LinkOpponentBufferExecCompleted = 0x8065068,
		PrepareBufferDataTransfer = 0x80331b8,
		GetMultiplayerId = 0x800a468,
		CB2_ReturnToField = 0x80860dc,
		SetBattleEndCallbacks = 0x80587b0,
		SetLinkBattleEndCallbacks = 0x80586f8,
		HandleTurnActionSelectionState = 0x803be74,
		CB2_EndLinkBattle = 0x8038f14,
		BattleMainCB2 = 0x8038420,
		CB2_InitEndLinkBattle = 0x8038d64,
		Cmd_getexp = 0x804a32c,
		InitLinkBattleVsScreen = 0x8035d74,
		DestroyTask = 0x80a90b0,
		gSpeciesInfo = 0x8326688,
		CB2_WhiteOut = 0x8085f6c,
	})),

	--Emerald Italian
	BPEI = createMetatable(copyTemplate(EmeraldTemplate, {
		gMultiChoice = 0x8587DB0,
		gMultiChoiceAmount = 0x8587DB4,
		sIngameTrades = 0x83388CC,
		GenerateTrainerCard = 0x80C2E69,

		gGraphicsInfo = 0x8502364,
		sObjectEventSpritePalettes = 0x850890C,
	
		--4.0 rom stuff
		gBattleMoves = 0x831c298,
		gExperienceTables = 0x831f12c,
		Task_StartWiredCableClubBattle = 0x80b32c8,
		Task_StartWiredTrade = 0x80b3810,
		OpenLink = 0x8009734,
		CreateTask = 0x80a8fc4,
		SetUpBattleVars = 0x80326a0,
		CB2_HandleStartBattle = 0x8036fb0,
		InitLocalLinkPlayer = 0x8009638,
		PlayerBufferExecCompleted = 0x8057490,
		LinkOpponentBufferExecCompleted = 0x806506c,
		PrepareBufferDataTransfer = 0x80331bc,
		GetMultiplayerId = 0x800a468,
		CB2_ReturnToField = 0x80860dc,
		SetBattleEndCallbacks = 0x80587b4,
		SetLinkBattleEndCallbacks = 0x80586fc,
		HandleTurnActionSelectionState = 0x803be78,
		CB2_EndLinkBattle = 0x8038f18,
		BattleMainCB2 = 0x8038424,
		CB2_InitEndLinkBattle = 0x8038d68,
		Cmd_getexp = 0x804a330,
		InitLinkBattleVsScreen = 0x8035d78,
		DestroyTask = 0x80a90b0,
		gSpeciesInfo = 0x831fdcc,
		CB2_WhiteOut = 0x8085f6c,
	})),

	--Ruby 1.0
	AXV1 = createMetatable(copyTemplate(RSETemplate, {
		gMultiChoice = 0x83CDE10,
		gMultiChoiceAmount = 0x83CDE14,
		sIngameTrades = 0x8215AC4,
		GenerateTrainerCard = 0x8093391,

		gGraphicsInfo = 0x836DC58,
		sObjectEventSpritePalettes = 0x837377C,
		gBattleMoves = 0x81fb12c,
		gExperienceTables = 0x81fdf78,
	
		Task_StartWiredCableClubBattle = 0x808382c,
		Task_StartWiredTrade = 0x8083b5c,
		OpenLink = 0x8007378,
		CreateTask = 0x807aa88,
		SetUpBattleVars = 0x800b884,
		CB2_HandleStartBattle = 0x800ec9c,
		InitLocalLinkPlayer = 0x8007280,
		PlayerBufferExecCompleted = 0x802bf9c,
		LinkOpponentBufferExecCompleted = 0x8038004,
		PrepareBufferDataTransfer = 0x800be9c,
		GetMultiplayerId = 0x8007e5c,
		CB2_ReturnToField = 0x80545e4,
		SetBattleEndCallbacks = 0x802d18c, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d18c,
		HandleTurnActionSelectionState = 0x8012324,
		CB2_EndLinkBattle = 0x80101b8,
		BattleMainCB2 = 0x800f808,
		CB2_InitEndLinkBattle = 0x8010014,
		Cmd_getexp = 0x8020004,
		InitLinkBattleVsScreen = 0x800de30,
		DestroyTask = 0x807ab74,
		gSpeciesInfo = 0x81fec18,
		CB2_WhiteOut = 0x8054468,
	})),

	--Ruby 1.1/1.2
	AXV2 = createMetatable(copyTemplate(RSETemplate, {
		gMultiChoice = 0x83CDE2C,
		gMultiChoiceAmount = 0x83CDE30,
		sIngameTrades = 0x8215ADC,
		GenerateTrainerCard = 0x80933B1,

		gGraphicsInfo = 0x836DC70,
		sObjectEventSpritePalettes = 0x8373794,
		gBattleMoves = 0x81fb144,
		gExperienceTables = 0x81fdf90,
	
		Task_StartWiredCableClubBattle = 0x808384c,
		Task_StartWiredTrade = 0x8083b7c,
		OpenLink = 0x8007378,
		CreateTask = 0x807aaa8,
		SetUpBattleVars = 0x800b884,
		CB2_HandleStartBattle = 0x800ec9c,
		InitLocalLinkPlayer = 0x8007280,
		PlayerBufferExecCompleted = 0x802bf9c,
		LinkOpponentBufferExecCompleted = 0x8038004,
		PrepareBufferDataTransfer = 0x800be9c,
		GetMultiplayerId = 0x8007e5c,
		CB2_ReturnToField = 0x8054604,
		SetBattleEndCallbacks = 0x802d18c, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d18c,
		HandleTurnActionSelectionState = 0x8012324,
		CB2_EndLinkBattle = 0x80101b8,
		BattleMainCB2 = 0x800f808,
		CB2_InitEndLinkBattle = 0x8010014,
		Cmd_getexp = 0x8020004,
		InitLinkBattleVsScreen = 0x800de30,
		DestroyTask = 0x807ab94,
		gSpeciesInfo = 0x81fec30,
		CB2_WhiteOut = 0x8054488,
	})),

	--Ruby French
	AXVF = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83D5908,
		gMultiChoiceAmount = 0x83D590C,
		sIngameTrades = 0x821DF10,
		GenerateTrainerCard = 0x80935C9,

		gGraphicsInfo = 0x83748BC,
		sObjectEventSpritePalettes = 0x837A3E0,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x8203578,
		gExperienceTables = 0x82063c4,
		Task_StartWiredCableClubBattle = 0x8083d68,
		Task_StartWiredTrade = 0x8084098,
		OpenLink = 0x80074d8,
		CreateTask = 0x807af38,
		SetUpBattleVars = 0x800ba58,
		CB2_HandleStartBattle = 0x800ee70,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c170,
		LinkOpponentBufferExecCompleted = 0x80381d8,
		PrepareBufferDataTransfer = 0x800c070,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x8054a10,
		SetBattleEndCallbacks = 0x802d360, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d360,
		HandleTurnActionSelectionState = 0x80124f8,
		CB2_EndLinkBattle = 0x801038c,
		BattleMainCB2 = 0x800f9dc,
		CB2_InitEndLinkBattle = 0x80101e8,
		Cmd_getexp = 0x80201d8,
		InitLinkBattleVsScreen = 0x800e004,
		DestroyTask = 0x807b024,
		gSpeciesInfo = 0x8207064,
		CB2_WhiteOut = 0x8054894,
	})),

	--Ruby German
	AXVD = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83D9E10,
		gMultiChoiceAmount = 0x83D9E14,
		sIngameTrades = 0x8222A94,
		GenerateTrainerCard = 0x80934E1,

		gGraphicsInfo = 0x8379440,
		sObjectEventSpritePalettes = 0x837EF64,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x82080fc,
		gExperienceTables = 0x820af48,
		Task_StartWiredCableClubBattle = 0x8083c80,
		Task_StartWiredTrade = 0x8083fb0,
		OpenLink = 0x80074d8,
		CreateTask = 0x807ae48,
		SetUpBattleVars = 0x800ba58,
		CB2_HandleStartBattle = 0x800ee70,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c170,
		LinkOpponentBufferExecCompleted = 0x80381d8,
		PrepareBufferDataTransfer = 0x800c070,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x8054924,
		SetBattleEndCallbacks = 0x802d360, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d360,
		HandleTurnActionSelectionState = 0x80124f8,
		CB2_EndLinkBattle = 0x801038c,
		BattleMainCB2 = 0x800f9dc,
		CB2_InitEndLinkBattle = 0x80101e8,
		Cmd_getexp = 0x80201d8,
		InitLinkBattleVsScreen = 0x800e004,
		DestroyTask = 0x807af34,
		gSpeciesInfo = 0x820bbe8,
		CB2_WhiteOut = 0x80547a8,
	})),

	--Ruby Spanish
	AXVS = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83D1918,
		gMultiChoiceAmount = 0x83D191C,
		sIngameTrades = 0x821A840,
		GenerateTrainerCard = 0x80935C1,

		gGraphicsInfo = 0x83711F0,
		sObjectEventSpritePalettes = 0x8376D14,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x81ffea8,
		gExperienceTables = 0x8202cf4,
		Task_StartWiredCableClubBattle = 0x8083d08,
		Task_StartWiredTrade = 0x8084038,
		OpenLink = 0x80074d8,
		CreateTask = 0x807af44,
		SetUpBattleVars = 0x800ba50,
		CB2_HandleStartBattle = 0x800ee68,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c168,
		LinkOpponentBufferExecCompleted = 0x80381d0,
		PrepareBufferDataTransfer = 0x800c068,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x8054a20,
		SetBattleEndCallbacks = 0x802d358, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d358,
		HandleTurnActionSelectionState = 0x80124f0,
		CB2_EndLinkBattle = 0x8010384,
		BattleMainCB2 = 0x800f9d4,
		CB2_InitEndLinkBattle = 0x80101e0,
		Cmd_getexp = 0x80201d0,
		InitLinkBattleVsScreen = 0x800dffc,
		DestroyTask = 0x807b030,
		gSpeciesInfo = 0x8203994,
		CB2_WhiteOut = 0x80548a4,
	})),

	--Ruby Italian
	AXVI = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83CE954,
		gMultiChoiceAmount = 0x83CE958,
		sIngameTrades = 0x821779C,
		GenerateTrainerCard = 0x80934D5,

		gGraphicsInfo = 0x836E148,
		sObjectEventSpritePalettes = 0x8373C6C,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x81fce04,
		gExperienceTables = 0x81ffc50,
		Task_StartWiredCableClubBattle = 0x8083c20,
		Task_StartWiredTrade = 0x8083f50,
		OpenLink = 0x80074d8,
		CreateTask = 0x807ae5c,
		SetUpBattleVars = 0x800ba50,
		CB2_HandleStartBattle = 0x800ee68,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c168,
		LinkOpponentBufferExecCompleted = 0x80381d0,
		PrepareBufferDataTransfer = 0x800c068,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x8054938,
		SetBattleEndCallbacks = 0x802d358, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d358,
		HandleTurnActionSelectionState = 0x80124f0,
		CB2_EndLinkBattle = 0x8010384,
		BattleMainCB2 = 0x800f9d4,
		CB2_InitEndLinkBattle = 0x80101e0,
		Cmd_getexp = 0x80201d0,
		InitLinkBattleVsScreen = 0x800dffc,
		DestroyTask = 0x807af48,
		gSpeciesInfo = 0x82008f0,
		CB2_WhiteOut = 0x80547bc,
	})),


	--Sapphire 1.0
	AXP1 = createMetatable(copyTemplate(RSETemplate, {
		gMultiChoice = 0x83CDE68,
		gMultiChoiceAmount = 0x83CDE6C,
		sIngameTrades = 0x8215A54,
		GenerateTrainerCard = 0x8093391,

		gGraphicsInfo = 0x836DBE8,
		sObjectEventSpritePalettes = 0x837370C,
		gBattleMoves = 0x81fb0bc,
		gExperienceTables = 0x81fdf08,
	
		Task_StartWiredCableClubBattle = 0x808382c,
		Task_StartWiredTrade = 0x808385c,
		OpenLink = 0x8007378,
		CreateTask = 0x807aa8c,
		SetUpBattleVars = 0x800b884,
		CB2_HandleStartBattle = 0x800ec9c,
		InitLocalLinkPlayer = 0x8007280,
		PlayerBufferExecCompleted = 0x802bf9c,
		LinkOpponentBufferExecCompleted = 0x8038004,
		PrepareBufferDataTransfer = 0x800be9c,
		GetMultiplayerId = 0x8007e5c,
		CB2_ReturnToField = 0x80545e8,
		SetBattleEndCallbacks = 0x802d18c, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d18c,
		HandleTurnActionSelectionState = 0x8012324,
		CB2_EndLinkBattle = 0x80101b8,
		BattleMainCB2 = 0x800f808,
		CB2_InitEndLinkBattle = 0x8010014,
		Cmd_getexp = 0x8020004,
		InitLinkBattleVsScreen = 0x800de30,
		DestroyTask = 0x807ab78,
		gSpeciesInfo = 0x81feba8,
		CB2_WhiteOut = 0x805446c,
	})),

	--Sapphire 1.1/1.2
	AXP2 = createMetatable(copyTemplate(RSETemplate, {
		gMultiChoice = 0x83CDE88,
		gMultiChoiceAmount = 0x83CDE8C,
		sIngameTrades = 0x8215A6C,
		GenerateTrainerCard = 0x80933B1,

		gGraphicsInfo = 0x836DC00,
		sObjectEventSpritePalettes = 0x8373724,
		gBattleMoves = 0x81fb0d4,
		gExperienceTables = 0x81fdf20,
	
		Task_StartWiredCableClubBattle = 0x808384c,
		Task_StartWiredTrade = 0x8083b7c,
		OpenLink = 0x8007378,
		CreateTask = 0x807aaac,
		SetUpBattleVars = 0x800b884,
		CB2_HandleStartBattle = 0x800ec9c,
		InitLocalLinkPlayer = 0x8007280,
		PlayerBufferExecCompleted = 0x802bf9c,
		LinkOpponentBufferExecCompleted = 0x8038004,
		PrepareBufferDataTransfer = 0x800be9c,
		GetMultiplayerId = 0x8007e5c,
		CB2_ReturnToField = 0x8054608,
		SetBattleEndCallbacks = 0x802d18c, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d18c,
		HandleTurnActionSelectionState = 0x8012324,
		CB2_EndLinkBattle = 0x80101b8,
		BattleMainCB2 = 0x800f808,
		CB2_InitEndLinkBattle = 0x8010014,
		Cmd_getexp = 0x8020004,
		InitLinkBattleVsScreen = 0x800de30,
		DestroyTask = 0x807ab98,
		gSpeciesInfo = 0x81febc0,
		CB2_WhiteOut = 0x805448c,
	})),

	--Sapphire French
	AXPF = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83D5438,
		gMultiChoiceAmount = 0x83D543C,
		sIngameTrades = 0x821DEA0,
		GenerateTrainerCard = 0x80935C9,

		gGraphicsInfo = 0x837484C,
		sObjectEventSpritePalettes = 0x837A370,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x8203500,
		gExperienceTables = 0x8206354,
		Task_StartWiredCableClubBattle = 0x8083d68,
		Task_StartWiredTrade = 0x8084098,
		OpenLink = 0x80074d8,
		CreateTask = 0x807af3c,
		SetUpBattleVars = 0x800ba58,
		CB2_HandleStartBattle = 0x800ee70,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c170,
		LinkOpponentBufferExecCompleted = 0x80381d8,
		PrepareBufferDataTransfer = 0x800c070,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x8054a14,
		SetBattleEndCallbacks = 0x802d360, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d360,
		HandleTurnActionSelectionState = 0x80124f8,
		CB2_EndLinkBattle = 0x801038c,
		BattleMainCB2 = 0x800f9dc,
		CB2_InitEndLinkBattle = 0x80101e8,
		Cmd_getexp = 0x80201d8,
		InitLinkBattleVsScreen = 0x800e004,
		DestroyTask = 0x807b028,
		gSpeciesInfo = 0x8206ff4,
		CB2_WhiteOut = 0x8054898,
	})),

	--Sapphire German
	AXPD = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83D9D7C,
		gMultiChoiceAmount = 0x83D9D80,
		sIngameTrades = 0x8222A28,
		GenerateTrainerCard = 0x80934E1,

		gGraphicsInfo = 0x83793D4,
		sObjectEventSpritePalettes = 0x837EEF8,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x8208090,
		gExperienceTables = 0x820aedc,
		Task_StartWiredCableClubBattle = 0x8083c80,
		Task_StartWiredTrade = 0x8083fb0,
		OpenLink = 0x80074d8,
		CreateTask = 0x807ae4c,
		SetUpBattleVars = 0x800ba58,
		CB2_HandleStartBattle = 0x800ee70,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c170,
		LinkOpponentBufferExecCompleted = 0x80381d8,
		PrepareBufferDataTransfer = 0x800c070,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x8054928,
		SetBattleEndCallbacks = 0x802d360, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d360,
		HandleTurnActionSelectionState = 0x80124f8,
		CB2_EndLinkBattle = 0x801038c,
		BattleMainCB2 = 0x800f9dc,
		CB2_InitEndLinkBattle = 0x80101e8,
		Cmd_getexp = 0x80201d8,
		InitLinkBattleVsScreen = 0x800e004,
		DestroyTask = 0x807af38,
		gSpeciesInfo = 0x820bb7c,
		CB2_WhiteOut = 0x80547ac, 
	})),

	--Sapphire Spanish
	AXPS = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83D1654,
		gMultiChoiceAmount = 0x83D1658,
		sIngameTrades = 0x821A7D0,
		GenerateTrainerCard = 0x80935C1,

		gGraphicsInfo = 0x8371180,
		sObjectEventSpritePalettes = 0x8376CA4,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x81ffe38,
		gExperienceTables = 0x8202c84,
		Task_StartWiredCableClubBattle = 0x8083d08,
		Task_StartWiredTrade = 0x8084038,
		OpenLink = 0x80074d8,
		CreateTask = 0x807af48,
		SetUpBattleVars = 0x800ba50,
		CB2_HandleStartBattle = 0x800ee68,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c168,
		LinkOpponentBufferExecCompleted = 0x80381d0,
		PrepareBufferDataTransfer = 0x800c068,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x8054a24,
		SetBattleEndCallbacks = 0x802d358, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d358,
		HandleTurnActionSelectionState = 0x80124f0,
		CB2_EndLinkBattle = 0x8010384,
		BattleMainCB2 = 0x800f9d4,
		CB2_InitEndLinkBattle = 0x80101e0,
		Cmd_getexp = 0x80201d0,
		InitLinkBattleVsScreen = 0x800dffc,
		DestroyTask = 0x807b034,
		gSpeciesInfo = 0x8203924,
		CB2_WhiteOut = 0x80548a8,
	})),

	--Sapphire Italian
	AXPI = createMetatable(copyTemplate(RSETemplate, {
		gPartyCount = 0x3004360,
		gParty = 0x3004370,
		gEnemyParty = 0x30045D0,
		gEnemyPartyCount = 0x30045c8, --not used?
		gPlayerData = 0x30048C0,
		gMultiChoice = 0x83CE5F8,
		gMultiChoiceAmount = 0x83CE5FC,
		sIngameTrades = 0x821772C,
		GenerateTrainerCard = 0x80934D5,

		gGraphicsInfo = 0x836E0D8,
		sObjectEventSpritePalettes = 0x8373BFC,
		
		--4.0 mem stuff
		gReceiveBuffer = 0x3002b90,
		gSendBuffer = 0x3002a80,
		gObjectEvents = 0x30048b0,
		gLinkPlayers = 0x3002980,
		gBlockReceivedStatus = 0x30029f0,
		gSelectedObjectEvent = 0x3004af0,
		gBattleMainFunc = 0x30042e4,
		gBattlerControllerFuncs = 0x3004340,
		
		--4.0 rom stuff
		gBattleMoves = 0x81fcd94,
		gExperienceTables = 0x81ffbe0,
		Task_StartWiredCableClubBattle = 0x8083c20,
		Task_StartWiredTrade = 0x8083f50,
		OpenLink = 0x80074d8,
		CreateTask = 0x807ae60,
		SetUpBattleVars = 0x800ba50,
		CB2_HandleStartBattle = 0x800ee68,
		InitLocalLinkPlayer = 0x80073e0,
		PlayerBufferExecCompleted = 0x802c168,
		LinkOpponentBufferExecCompleted = 0x80381d0,
		PrepareBufferDataTransfer = 0x800c068,
		GetMultiplayerId = 0x8008028,
		CB2_ReturnToField = 0x805493c,
		SetBattleEndCallbacks = 0x802d358, --only for emerald
		SetLinkBattleEndCallbacks = 0x802d358,
		HandleTurnActionSelectionState = 0x80124f0,
		CB2_EndLinkBattle = 0x8010384,
		BattleMainCB2 = 0x800f9d4,
		CB2_InitEndLinkBattle = 0x80101e0,
		Cmd_getexp = 0x80201d0,
		InitLinkBattleVsScreen = 0x800dffc,
		DestroyTask = 0x807af4c,
		gSpeciesInfo = 0x8200880,
		CB2_WhiteOut = 0x80547c0,
	})),

	--Ruby Japan
	AXVJ = createMetatable(copyTemplate(RSETemplate, {
		gBuffer1 = 0x20231F0,
		gBuffer2 = 0x2023204,
		gBuffer3 = 0x2023210,
		gPartyCount = 0x3004280,
		gParty = 0x3004290,
		gEnemyParty = 0x30044F0,
		gSprite = 0x3001AA0,
		gTrainerCard = 0x202FCDC,
		gSendBuffer = 0x30029E0,
		gPlayerData = 0x30047E0,
		gCameraX = 0x30004F8,
		gCameraY = 0x30004F9,
		gMapBank = 0x2038FF4,
		gMapHeader = 0x202E588,
		gSpecialVar_8000 = 0x202E618,
		gMainCallback = 0x30016E4,
		gMainSavedCallback = 0x30016E8,
		gLockControls = 0x300060C,
		gScriptLoad = 0x3000518,
		gMultiChoice = 0x83A1B94,
		gMultiChoiceAmount = 0x83A1B98,
		sIngameTrades = 0x81E9C48,
		GenerateTrainerCard = 0x808FADD,

		gGraphicsInfo = 0x83460F8,
		sObjectEventSpritePalettes = 0x834B974,
		
		--4.0 japan stuff
		gEnemyPartyCount = 0x30044d8,
		gReceiveBuffer = 0x3002af0,
		gPaletteUnfaded = 0x202e7e8,
		gPaletteFaded = 0x202ebe8,
		gPaletteFade = 0x202f0a8,
		gObjectEvents = 0x30047d0,
		sBlockSend = 0x3000350,
		gLinkCallback = 0x3002f30,
		gPlayerAvatar = 0x202e5b8,
		gSaveBlock1Ptr = 0x2025494,
		gSaveBlock2Ptr = 0x2024c04,
	
		--4.0 mem stuff
		--gWirelessCommType = , --ruby/sapphire do not use wireless? why?
		gBattleCommunication = 0x2024a7e,
		gLinkPlayers = 0x30028e0,
		gBlockReceivedStatus = 0x3002950,
		gReceivedRemoteLinkPlayers = 0x3002f14,
		gBattleControllerExecFlags = 0x20247c4,
		gBattleBufferA = 0x20237c0,
		gBattleBufferB = 0x2023fc0,
		gActiveBattler = 0x20247c0,
		gBattlerAttacker = 0x2024967,
		gBattlerTarget = 0x2024968,
		gEffectBattler = 0x202496a,
		gAbsentBattlerFlags = 0x202496c,
		gBattleMainFunc = 0x3004204,
		gBattlerControllerFuncs = 0x3004260,
		gBattleTypeFlags = 0x2023758,
		gChosenActionByBattler = 0x2024978,
		gBattleEXP = 0x201600F,
		gBattleMoveDamage = 0x202494c,
		
		--4.0 rom stuff
		gBattleMoves = 0x81ccee0,
		gExperienceTables = 0x81cfd2c,
		Task_StartWiredCableClubBattle = 0x8080618,
		Task_StartWiredTrade = 0x8080948,
		OpenLink = 0x8004a78,
		CreateTask = 0x8077ac4,
		SetUpBattleVars = 0x8008dec,
		CB2_HandleStartBattle = 0x800c198,
		InitLocalLinkPlayer = 0x8004980,
		PlayerBufferExecCompleted = 0x8029224,
		LinkOpponentBufferExecCompleted = 0x8035410,
		PrepareBufferDataTransfer = 0x8009404,
		GetMultiplayerId = 0x8005538,
		CB2_ReturnToField = 0x8051854,
		SetBattleEndCallbacks = 0x802a568, --only for emerald
		SetLinkBattleEndCallbacks = 0x802a568,
		HandleTurnActionSelectionState = 0x800f630,
		CB2_EndLinkBattle = 0x800d4c4,
		BattleMainCB2 = 0x800cb38,
		CB2_InitEndLinkBattle = 0x800bd5c,
		Cmd_getexp = 0x801d2e4,
		InitLinkBattleVsScreen = 0x800d158,
		DestroyTask = 0x8077bb0,
		gSpeciesInfo = 0x81d09cc,
		CB2_WhiteOut = 0x80516dc,
	})),

	--Sapphire Japan
	AXPJ = createMetatable(copyTemplate(RSETemplate, {
		gBuffer1 = 0x20231F0,
		gBuffer2 = 0x2023204,
		gBuffer3 = 0x2023210,
		gPartyCount = 0x3004280,
		gParty = 0x3004290,
		gEnemyParty = 0x30044F0,
		gSprite = 0x3001AA0,
		gTrainerCard = 0x202FCDC,
		gSendBuffer = 0x30029E0,
		gPlayerData = 0x30047E0,
		gCameraX = 0x30004F8,
		gCameraY = 0x30004F9,
		gMapBank = 0x2038FF4,
		gMapHeader = 0x202E588,
		gSpecialVar_8000 = 0x202E618,
		gMainCallback = 0x30016E4,
		gMainSavedCallback = 0x30016E8,
		gLockControls = 0x300060C,
		gScriptLoad = 0x3000518,
		gMultiChoice = 0x83A1B78,
		gMultiChoiceAmount = 0x83A1B7C,
		sIngameTrades = 0x81E9BD8,
		GenerateTrainerCard = 0x808FADD,
		gObjectEvents = 0x2037350,

		gGraphicsInfo = 0x8346088,
		sObjectEventSpritePalettes = 0x834B904,
		
		--4.0 japan stuff
		gEnemyPartyCount = 0x30044d8,
		gReceiveBuffer = 0x3002af0,
		gPaletteUnfaded = 0x202e7e8,
		gPaletteFaded = 0x202ebe8,
		gPaletteFade = 0x202f0a8,
		gObjectEvents = 0x30047d0,
		sBlockSend = 0x3000350,
		gLinkCallback = 0x3002f30,
		gPlayerAvatar = 0x202e5b8,
		gSaveBlock1Ptr = 0x2025494,
		gSaveBlock2Ptr = 0x2024c04,
	
		--4.0 mem stuff
		--gWirelessCommType = , --ruby/sapphire do not use wireless? why?
		gBattleCommunication = 0x2024a7e,
		gLinkPlayers = 0x30028e0,
		gBlockReceivedStatus = 0x3002950,
		gReceivedRemoteLinkPlayers = 0x3002f14,
		gBattleControllerExecFlags = 0x20247c4,
		gBattleBufferA = 0x20237c0,
		gBattleBufferB = 0x2023fc0,
		gActiveBattler = 0x20247c0,
		gBattlerAttacker = 0x2024967,
		gBattlerTarget = 0x2024968,
		gEffectBattler = 0x202496a,
		gAbsentBattlerFlags = 0x202496c,
		gBattleMainFunc = 0x3004204,
		gBattlerControllerFuncs = 0x3004260,
		gBattleTypeFlags = 0x2023758,
		gChosenActionByBattler = 0x2024978,
		gBattleEXP = 0x201600F,
		gBattleMoveDamage = 0x202494c,
		
		--4.0 rom stuff
		gBattleMoves = 0x81cce70,
		gExperienceTables = 0x81cfcbc,
		Task_StartWiredCableClubBattle = 0x8080618,
		Task_StartWiredTrade = 0x8080948,
		OpenLink = 0x8004a78,
		CreateTask = 0x8077ac8,
		SetUpBattleVars = 0x8008dec,
		CB2_HandleStartBattle = 0x800c198,
		InitLocalLinkPlayer = 0x8004980,
		PlayerBufferExecCompleted = 0x8029224,
		LinkOpponentBufferExecCompleted = 0x8035410,
		PrepareBufferDataTransfer = 0x8009404,
		GetMultiplayerId = 0x8005538,
		CB2_ReturnToField = 0x8051858,
		SetBattleEndCallbacks = 0x802a568, --only for emerald
		SetLinkBattleEndCallbacks = 0x802a568,
		HandleTurnActionSelectionState = 0x800f630,
		CB2_EndLinkBattle = 0x800d4c4,
		BattleMainCB2 = 0x800cb38,
		CB2_InitEndLinkBattle = 0x800bd5c,
		Cmd_getexp = 0x801d2e4,
		InitLinkBattleVsScreen = 0x800d158,
		DestroyTask = 0x8077bb4,
		gSpeciesInfo = 0x81d095c,
		CB2_WhiteOut = 0x80516e0,
	})),
}

local MapBanks = {
	FRLG = {
		Pallet = {
			Main_Bank = {Section = 3, Map = 0},
		},
		Veridian = {
			Main_Bank = {Section = 3, Map = 1},
			Shop = {Section = 5, Map = 3},
			Pokecenter_Entrance = {Section = 5, Map = 4},
			Pokecenter_First_Floor = {Section = 5, Map = 5},
			NPC_Jeff = {Section = 3, Map = 1, X = 28, Y = 28, Direction = "Look_Down"},
		},
		Pewter = {
			Main_Bank = {Section = 3, Map = 2},
			Shop = {Section = 6, Map = 3},
			Pokecenter_Entrance = {Section = 6, Map = 5},
			Pokecenter_First_Floor = {Section = 6, Map = 6},
			NPC_Jeff = {Section = 3, Map = 2, X = 19, Y = 27, Direction = "Look_Down"},
		},
		Cerulean = {
			Main_Bank = {Section = 3, Map = 3},
			Shop = {Section = 7, Map = 7},
			Pokecenter_Entrance = {Section = 7, Map = 3},
			Pokecenter_First_Floor = {Section = 7, Map = 4},
			NPC_Jeff = {Section = 3, Map = 3, X = 24, Y = 21, Direction = "Look_Down"},
		},
		Lavender = {
			Main_Bank = {Section = 3, Map = 4},
			Shop = {Section = 8, Map = 5},
			Pokecenter_Entrance = {Section = 8, Map = 0},
			Pokecenter_First_Floor = {Section = 8, Map = 1},
			NPC_Jeff = {Section = 3, Map = 4, X = 8, Y = 7, Direction = "Look_Down"},
		},
		Vermillion = {
			Main_Bank = {Section = 3, Map = 5},
			Shop = {Section = 9, Map = 5},
			Pokecenter_Entrance = {Section = 9, Map = 1},
			Pokecenter_First_Floor = {Section = 9, Map = 2},
			NPC_Jeff = {Section = 3, Map = 5, X = 17, Y = 8, Direction = "Look_Down"},
		},
		Celadon = {
			Main_Bank = {Section = 3, Map = 6},
			Department_Store = {Section = 10, Map = 0},
			Pokecenter_Entrance = {Section = 10, Map = 12},
			Pokecenter_First_Floor = {Section = 10, Map = 13},
			NPC_Jeff = {Section = 3, Map = 6, X = 50, Y = 13, Direction = "Look_Down"},
		},
		Fuchsia = {
			Main_Bank = {Section = 3, Map = 7},
			Shop = {Section = 11, Map = 1},
			Pokecenter_Entrance = {Section = 11, Map = 5},
			Pokecenter_First_Floor = {Section = 11, Map = 6},
			NPC_Jeff = {Section = 3, Map = 7, X = 27, Y = 33, Direction = "Look_Down"},
		},
		Cinnabar = {
			Main_Bank = {Section = 3, Map = 8},
			Shop = {Section = 12, Map = 7},
			Pokecenter_Entrance = {Section = 12, Map = 5},
			Pokecenter_First_Floor = {Section = 12, Map = 6},
			NPC_Jeff = {Section = 3, Map = 8, X = 16, Y = 13, Direction = "Look_Down"},
		},
		Indigo_Plateau = {
			Main_Bank = {Section = 3, Map = 9},
			Indigo = {Section = 13, Map = 0},
			Pokecenter_First_Floor = {Section = 13, Map = 1},
			NPC_Jeff = {Section = 3, Map = 9, X = 13, Y = 8, Direction = "Look_Down"}, 
		},
		Saffron = {
			Main_Bank = {Section = 3, Map = 10},
			Silph_Co = {Section = 1, Map = 47},
			Shop = {Section = 14, Map = 5},
			Pokecenter_Entrance = {Section = 14, Map = 6},
			Pokecenter_First_Floor = {Section = 14, Map = 7},
			NPC_Jeff = {Section = 3, Map = 10, X = 26, Y = 40, Direction = "Look_Down"},
		},
		Route_4 = {
			Main_Bank = {Section = 3, Map = 22},
			Pokecenter_Entrance = {Section = 16, Map = 0},
			Pokecenter_First_Floor = {Section = 16, Map = 1},
			NPC_Jeff = {Section = 3, Map = 22, X = 14, Y = 7, Direction = "Look_Down"},
		},
		Route_10 = {
			Main_Bank = {Section = 3, Map = 28},
			Pokecenter_Entrance = {Section = 21, Map = 0},
			Pokecenter_First_Floor = {Section = 21, Map = 1},
			NPC_Jeff = {Section = 3, Map = 28, X = 15, Y = 22, Direction = "Look_Down"},
		},
		Seven_Island = {
			Main_Bank = {Section = 3, Map = 17},
			Shop = {Section = 31, Map = 2},
			Pokecenter_Entrance = {Section = 31, Map = 3},
			Pokecenter_First_Floor = {Section = 31, Map = 4},
			NPC_Jeff = {Section = 31, Map = 6, X = 10, Y = 4, Direction = "Look_Down"},
		},
		One_Island = {
			Main_Bank = {Section = 3, Map = 12},
			Pokecenter_RSE = {Section = 32, Map = 0},
			Pokecenter_First_Floor = {Section = 32, Map = 1},
			NPC_Jeff = {Section = 32, Map = 4, X = 10, Y = 4, Direction = "Look_Down"},
		},
		Two_Island = {
			Main_Bank = {Section = 3, Map = 13},
			Pokecenter_Entrance = {Section = 33, Map = 2},
			Pokecenter_First_Floor = {Section = 33, Map = 3},
			NPC_Jeff = {Section = 33, Map = 4, X = 10, Y = 4, Direction = "Look_Down"},
		},
		Three_Island = {
			Main_Bank = {Section = 3, Map = 14},
			Shop = {Section = 34, Map = 3},
			Pokecenter_Entrance = {Section = 34, Map = 1},
			Pokecenter_First_Floor = {Section = 34, Map = 2},
			NPC_Jeff = {Section = 38, Map = 0, X = 10, Y = 4, Direction = "Look_Down"},
		},
		Four_Island = {
			Main_Bank = {Section = 3, Map = 15},
			Shop = {Section = 35, Map = 7},
			Pokecenter_Entrance = {Section = 35, Map = 1},
			Pokecenter_First_Floor = {Section = 35, Map = 2},
			NPC_Jeff = {Section = 35, Map = 5, X = 10, Y = 4, Direction = "Look_Down"},
		},
		Five_Island = {
			Main_Bank = {Section = 3, Map = 16},
			Pokecenter_Entrance = {Section = 35, Map = 0},
			Pokecenter_First_Floor = {Section = 35, Map = 1},
			NPC_Jeff = {Section = 36, Map = 2, X = 10, Y = 4, Direction = "Look_Down"},
		},
		Six_Island = {
			Main_Bank = {Section = 3, Map = 18},
			Shop = {Section = 37, Map = 4},
			Pokecenter_Entrance = {Section = 37, Map = 0},
			Pokecenter_First_Floor = {Section = 37, Map = 1},
			NPC_Jeff = {Section = 37, Map = 2, X = 10, Y = 4, Direction = "Look_Down"},
		},
	},
	RSE = {
		Petalburg = {
			Main_Bank = {Section = 0, Map = 0},
			Shop = {Section = 8, Map = 6},
			Pokecenter_Entrance = {Section = 8, Map = 4},
			Pokecenter_First_Floor = {Section = 8, Map = 5},
			NPC_Jeff = {Section = 0, Map = 0, X = 22, Y = 18, Direction = "Look_Down"},
		},
		Slateport = {
			Main_Bank = {Section = 0, Map = 1},
			Shop = {Section = 9, Map = 12},
			Pokecenter_Entrance = {Section = 9, Map = 10},
			Pokecenter_First_Floor = {Section = 9, Map = 11},
			NPC_Jeff = {Section = 0, Map = 1, X = 21, Y = 21, Direction = "Look_Down"},
		},
		Mauvile = {
			Main_Bank = {Section = 0, Map = 2},
			Shop = {Section = 10, Map = 7},
			Pokecenter_Entrance = {Section = 10, Map = 5},
			Pokecenter_First_Floor = {Section = 10, Map = 6},
			NPC_Jeff = {Section = 0, Map = 2, X = 24, Y = 7, Direction = "Look_Down"},
		},
		Rustboro = {
			Main_Bank = {Section = 0, Map = 3},
			Shop = {Section = 11, Map = 7},
			Pokecenter_Entrance = {Section = 11, Map = 5},
			Pokecenter_First_Floor = {Section = 11, Map = 6},
			NPC_Jeff = {Section = 0, Map = 3, X = 18, Y = 40, Direction = "Look_Down"},
		},
		Fortree = {
			Main_Bank = {Section = 0, Map = 4},
			Shop = {Section = 12, Map = 4},
			Pokecenter_Entrance = {Section = 12, Map = 2},
			Pokecenter_First_Floor = {Section = 12, Map = 3},
			NPC_Jeff = {Section = 0, Map = 4, X = 7, Y = 8, Direction = "Look_Down"},
		},
		Lilycove = {
			Main_Bank = {Section = 0, Map = 5},
			Shop = {Section = 13, Map = 8},
			Pokecenter_Entrance = {Section = 13, Map = 6},
			Pokecenter_First_Floor = {Section = 13, Map = 7},
			NPC_Jeff = {Section = 0, Map = 5, X = 26, Y = 17, Direction = "Look_Down"},
		},
		Mossdeep = {
			Main_Bank = {Section = 0, Map = 6},
			Shop = {Section = 14, Map = 5},
			Pokecenter_Entrance = {Section = 14, Map = 3},
			Pokecenter_First_Floor = {Section = 14, Map = 4},
			NPC_Jeff = {Section = 0, Map = 6, X = 30, Y = 18, Direction = "Look_Down"},
		},
		Sootopolis = {
			Main_Bank = {Section = 0, Map = 7},
			Shop = {Section = 15, Map = 4},
			Pokecenter_Entrance = {Section = 15, Map = 2},
			Pokecenter_First_Floor = {Section = 15, Map = 3},
			NPC_Jeff = {Section = 0, Map = 7, X = 45, Y = 33, Direction = "Look_Down"},
		},
		Ever_Grande = {
			Main_Bank = {Section = 0, Map = 8},
			Shop = {Section = 13, Map = 4},
			Indigo = {Section = 16, Map = 10},
			Pokecenter_Entrance = {Section = 16, Map = 12},
			Pokecenter_First_Floor = {Section = 16, Map = 13},
			NPC_Jeff = {Section = 0, Map = 8, X = 29, Y = 50, Direction = "Look_Down"},
		},
		Littleroot = {
			Main_Bank = {Section = 0, Map = 9},
		},
		Oldale = {
			Main_Bank = {Section = 0, Map = 10},
			Shop = {Section = 2, Map = 4},
			Pokecenter_Entrance = {Section = 2, Map = 2},
			Pokecenter_First_Floor = {Section = 2, Map = 3},
			NPC_Jeff = {Section = 0, Map = 10, X = 8, Y = 18, Direction = "Look_Down"},
		},
		Dewford = {
			Main_Bank = {Section = 0, Map = 11},
			Pokecenter_Entrance = {Section = 3, Map = 1},
			Pokecenter_First_Floor = {Section = 3, Map = 2},
			NPC_Jeff = {Section = 0, Map = 11, X = 4, Y = 12, Direction = "Look_Down"},
		},
		Lavaridge = {
			Main_Bank = {Section = 0, Map = 12},
			Shop = {Section = 4, Map = 4},
			Pokecenter_Entrance = {Section = 4, Map = 5},
			Pokecenter_First_Floor = {Section = 4, Map = 6},
			NPC_Jeff = {Section = 0, Map = 12, X = 11, Y = 8, Direction = "Look_Down"},
		},
		Fallarbor = {
			Main_Bank = {Section = 0, Map = 13},
			Shop = {Section = 5, Map = 0},
			Pokecenter_Entrance = {Section = 5, Map = 3},
			Pokecenter_First_Floor = {Section = 5, Map = 4},
			NPC_Jeff = {Section = 0, Map = 13, X = 16, Y = 9, Direction = "Look_Down"},
		},
		Verdanturf = {
			Main_Bank = {Section = 0, Map = 14},
			Shop = {Section = 6, Map = 2},
			Pokecenter_Entrance = {Section = 6, Map = 3},
			Pokecenter_First_Floor = {Section = 6, Map = 4},
			NPC_Jeff = {Section = 0, Map = 14, X = 18, Y = 5, Direction = "Look_Down"},
		},
		Pacifidlog = {
			Main_Bank = {Section = 0, Map = 15},
			Pokecenter_Entrance = {Section = 7, Map = 0},
			Pokecenter_First_Floor = {Section = 7, Map = 1},
			NPC_Jeff = {Section = 0, Map = 15, X = 11, Y = 17, Direction = "Look_Down"},
		},
		Inside_Truck = {
			Main_Bank = {Section = 25, Map = 40},
		},
	},
}

local Callback = {
	BPR1 = {
		Field = 0x80565B4,
		Battle = 0x8011100,
		Pokemon = 0x811EBA0,
		Pokemon_Summary = 0x8137EE8,
		Item = 0x8107EE0,
	},
	BPR2 = {
		Field = 0x80565c8,
		Battle = 0x8011114,
		Pokemon = 0x811ec18,
		Pokemon_Summary = 0x8137f60,
		Item = 0x8107f58,
	},
	BPG1 = {
		Field = 0x80565b4,
		Battle = 0x8011100,
		Pokemon = 0x811eb78,
		Pokemon_Summary = 0x8137ec0,
		Item = 0x8107eb8,
	},
	BPG2 = {
		Field = 0x80565c8,
		Battle = 0x8011114,
		Pokemon = 0x811ebf0,
		Pokemon_Summary = 0x8137f38,
		Item = 0x8107f30,
	},
	BPRJ = {
		Field = 0x8055e74,
		Battle = 0x80109c0,
		Pokemon = 0x811f3a8,
		Pokemon_Summary = 0x813868c,
		Item = 0x81089e4,
	},
	BPGJ = {
		Field = 0x8055e74,
		Battle = 0x80109c0,
		Pokemon = 0x811ec94,
		Pokemon_Summary = 0x8138040,
		Item = 0x810801c,
	},
	BPRF = {
		Field = 0x8056694,
		Battle = 0x8011070,
		Pokemon = 0x811ec94,
		Pokemon_Summary = 0x8138040,
		Item = 0x810801c,
	},
	BPGF = {
		Field = 0x8056694,
		Battle = 0x8011070,
		Pokemon = 0x811ec6c,
		Pokemon_Summary = 0x8138018,
		Item = 0x8107ff4,
	},
	BPRD = {
		Field = 0x80565d4,
		Battle = 0x8011084,
		Pokemon = 0x811ebd4,
		Pokemon_Summary = 0x8137f84,
		Item = 0x8107f5c,
	},
	BPGD = {
		Field = 0x80565d4,
		Battle = 0x8011084,
		Pokemon = 0x811ebac,
		Pokemon_Summary = 0x8137f5c,
		Item = 0x8107f34,
	},
	BPRS = {
		Field = 0x80566a8,
		Battle = 0x8011070,
		Pokemon = 0x811ed00,
		Pokemon_Summary = 0x81380b0,
		Item = 0x8108088,
	},
	BPGS = {
		Field = 0x80566a8,
		Battle = 0x8011070,
		Pokemon = 0x811ecd8,
		Pokemon_Summary = 0x8138088,
		Item = 0x8108060,
	},
	BPRI = {
		Field = 0x80565c0,
		Battle = 0x8011084,
		Pokemon = 0x811ec18,
		Pokemon_Summary = 0x8137fc4,
		Item = 0x8107fa0,
	},
	BPGI = {
		Field = 0x80565c0,
		Battle = 0x8011084,
		Pokemon = 0x811ebf0,
		Pokemon_Summary = 0x8137f9c,
		Item = 0x8107f78,
	},
	BPEE = {
		Field = 0x8085e5c,
		Battle = 0x8038420,
		Pokemon = 0x81b01b0,
		Pokemon_Summary = 0x81bfab4,
		Item = 0x81aad5c,
	},
	BPEJ = {
		Field = 0x80857c4,
		Battle = 0x80380fc,
		Pokemon = 0x81afe88,
		Pokemon_Summary = 0x81bf414,
		Item = 0x81aaad4,
	},
	BPEF = {
		Field = 0x8085e6c,
		Battle = 0x8038420,
		Pokemon = 0x81afdec,
		Pokemon_Summary = 0x81bf6f0,
		Item = 0x81aa988,
	},
	BPED = {
		Field = 0x8085e78,
		Battle = 0x8038424,
		Pokemon = 0x81afcd8,
		Pokemon_Summary = 0x81bf5dc,
		Item = 0x81aa868,
	},
	BPES = {
		Field = 0x8085e70,
		Battle = 0x8038420,
		Pokemon = 0x81afdd0,
		Pokemon_Summary = 0x81bf6d4,
		Item = 0x81aa960,
	},
	BPEI = {
		Field = 0x8085e70,
		Battle = 0x8038424,
		Pokemon = 0x81afcb8,
		Pokemon_Summary = 0x81bf5bc,
		Item = 0x81aa854,
	},
	AXV1 = {
		Field = 0x80543a4,
		Battle = 0x800f808,
		Pokemon = 0x806aedc,
		Pokemon_Summary = 0x809d844,
		Item = 0x80a3118,
	},
	AXV2 = {
		Field = 0x80543c4,
		Battle = 0x800f808,
		Pokemon = 0x806aefc,
		Pokemon_Summary = 0x809d864,
		Item = 0x80a3138,
	},
	AXP1 = {
		Field = 0x80543a8,
		Battle = 0x800f808,
		Pokemon = 0x806aee0,
		Pokemon_Summary = 0x809d844,
		Item = 0x80a3118,
	},
	AXP2 = {
		Field = 0x80543c8,
		Battle = 0x800f808,
		Pokemon = 0x806af00,
		Pokemon_Summary = 0x809d864,
		Item = 0x80a3138,
	},
	AXVJ = {
		Field = 0x8051618,
		Battle = 0x800cb38,
		Pokemon = 0x80681f4,
		Pokemon_Summary = 0x809a178,
		Item = 0x809f6dc,
	},
	AXPJ = {
		Field = 0x805161c,
		Battle = 0x800cb38,
		Pokemon = 0x80681f8,
		Pokemon_Summary = 0x809a178,
		Item = 0x809f6dc,
	},
	AXVF = {
		Field = 0x80547d0,
		Battle = 0x800f9dc,
		Pokemon = 0x806b30c,
		Pokemon_Summary = 0x809da80,
		Item = 0x80a3350,
	},
	AXVD = {
		Field = 0x80546e4,
		Battle = 0x800f9dc,
		Pokemon = 0x806b21c,
		Pokemon_Summary = 0x809d998,
		Item = 0x80a3268,
	},
	AXVS = {
		Field = 0x80547e0,
		Battle = 0x800f9d4,
		Pokemon = 0x806b318,
		Pokemon_Summary = 0x809da78,
		Item = 0x80a3360,
	},
	AXVI = {
		Field = 0x80546f8,
		Battle = 0x800f9d4,
		Pokemon = 0x806b230,
		Pokemon_Summary = 0x809d98c,
		Item = 0x80a325c,
	},
	AXPF = {
		Field = 0x80547d4,
		Battle = 0x800f9dc,
		Pokemon = 0x806b310,
		Pokemon_Summary = 0x809da80,
		Item = 0x80a3350,
	},
	AXPD = {
		Field = 0x80546e8,
		Battle = 0x800f9dc,
		Pokemon = 0x806b220,
		Pokemon_Summary = 0x809d998,
		Item = 0x80a3268,
	},
	AXPS = {
		Field = 0x80547e4,
		Battle = 0x800f9d4,
		Pokemon = 0x806b31c,
		Pokemon_Summary = 0x809da78,
		Item = 0x80a3360,
	},
	AXPI = {
		Field = 0x80546fc,
		Battle = 0x800f9d4,
		Pokemon = 0x806b234,
		Pokemon_Summary = 0x809d98c,
		Item = 0x80a325c,
	},
}

local spriteData = {
	--Male FRLG
	[1] = {
		[1] = {
			Animation = "Side Left",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 3149633664, 0, 0, 0, 0,34952, 576443, 572347, 9223099, 3149699231, 3435965599, 3435973279, 3435834096,2290639872, 871576576, 843202560, 859045888, 9227195, 9227468, 16305356, 16025804,16008328, 1000225, 62243, 1041475, 4098359296, 1875378176, 1758396416, 1072693248,1206910976, 3337617408, 4278190080, 0, 16637583, 16047862, 16664822, 1044467,65396, 246, 15, 0},
		},
		[2] = {
			Animation = "Side Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 0, 0, 0, 0,34952, 576443, 572347, 9223099, 3149711360, 3435974400, 3435958016, 4240982512,2290414576, 1095040768, 1157623808, 4293160704, 9227195, 16567500, 16305356, 253005007,255805576, 16729108, 1048388, 16731903, 3438043712, 3712762688, 3723490304, 4008140800,1317007360, 4284936192, 16711680, 0, 69652172, 70567133, 5242589, 425710,1046500, 1009407, 65280, 0},
		},
		[3] = {
			Animation = "Side Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 0, 0, 0, 0,34952, 576443, 572347, 9223099, 3149713152, 2630668032, 3402269168, 2576806896,1717784320, 790839040, 607338496, 860843776, 16567227, 16567497, 253275308, 255814041,16004710, 15938290, 275266, 16184371, 4291191360, 2898670400, 2614096896, 4284964864,4152356864, 258404352, 16711680, 0, 69627135, 70479050, 5242041, 423679,1046399, 1009392, 65280, 0},
		},
		[4] = {
			Animation = "Walk Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149633664, 3149699231, 3435965599, 3435973279,3435834096, 2290639872, 871576576, 843202560, 9223099, 9227195, 9227468, 16305356,16025804, 16008328, 1000228, 62243, 859045888, 1682898944, 1713565696, 1714679808,4283367424, 4293918720, 0, 0, 1041475, 16637512, 16047814, 16664783,1042039, 1009263, 65520, 0, 0, 0, 0, 0},
		},
		[5] = {
			Animation = "Walk Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149633664, 3149699231, 3435965599, 3435973279,3435834096, 2290639872, 871576576, 843202560, 9223099, 9227195, 9227468, 16305356,16025804, 16008328, 1000228, 62243, 859045888, 4098359296, 1825046528, 4244570112,2146889728, 4140822528, 268369920, 0, 1041475, 16637542, 16007718, 16663350,1000703, 65535, 0, 0, 0, 0, 0, 0},
		},
		[6] = {
			Animation = "Walk Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645824, 3149711360, 3435974400, 3435958016,4240982512, 2290414576, 1095040832, 1157587776, 9223099, 9227195, 16567500, 16305356,253005007, 255805576, 16729108, 327492, 4282672704, 3438046976, 3712761856, 3723292672,3739676672, 1315307520, 4152295424, 0, 1008895, 16142028, 255247581, 255053533,16740077, 65508, 255, 0, 0, 0, 0, 0},
		},
		[7] = {
			Animation = "Walk Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645824, 3149711360, 3435974400, 3435958016,4240982512, 2290414576, 1095040768, 1157578752, 9223099, 9227195, 16567500, 16305356,253005007, 255805576, 83837972, 70713156, 4282839040, 3437522688, 3712771056, 3723244528,3739680512, 1325334528, 4278190080, 0, 73811199, 16174796, 312541, 1035997,1011437, 26340, 63359, 4080, 0, 0, 0, 0},
		},
		[8] = {
			Animation = "Walk Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645824, 3149713152, 2630668032, 3402269168,2576806896, 1717784320, 790839104, 607340084, 9223099, 16567227, 16567497, 253275308,255814041, 16004710, 15938290, 275266, 860878388, 4287393776, 2899066880, 2614095872,4285001728, 1736376320, 4134469632, 0, 1045555, 16149759, 4334794, 4404409,282623, 255, 0, 0, 0, 0, 0, 0},
		},
		[9] = {
			Animation = "Walk Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645824, 3149713152, 2630668032, 3402269168,2576806896, 1717784320, 790839040, 607338496, 9223099, 16567227, 16567497, 253275308,255814041, 16004710, 83047154, 1130640194, 860876800, 4291194624, 2890015744, 2604872704,4294197248, 4278190080, 0, 0, 1131410483, 267831551, 314570, 1047737,1013503, 63350, 63087, 4080, 0, 0, 0, 0},
		},
		[10] = {
			Animation = "Bike Left Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 2290614272, 3149692928, 3149645824, 3149633664, 3149699231, 3435965599,0, 0, 34952, 576443, 572347, 9223099, 9227195, 9227468,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435973279, 3435834096, 2290639872, 871576576, 843203584, 859062016, 1867493120, 1713568496,16305356, 16025804, 16008328, 1000228, 62243, 1041475, 16637512, 16047686,0, 0, 0, 0, 0, 0, 0, 0,0, 1610612736, 4127195136, 1331691520, 4210032640, 1794113536, 2936012800, 4026531840,1714682608, 4287614966, 2298466303, 2147482697, 3338334400, 4294601209, 1026730, 65535,16664783, 107999112, 1879048184, 4131671287, 2936852470, 2795476655, 4205488880, 268435200,0, 0, 0, 6, 15, 15, 0, 0},
		},
		[11] = {
			Animation = "Bike Up Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 3149711360, 3435974400,0, 0, 34952, 576443, 572347, 9223099, 9227195, 16567500,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435958016, 4240982512, 2290414576, 1095040768, 1157575664, 4293288944, 3712773888, 3723292672,16305356, 253005007, 255805576, 16729108, 255065924, 255225599, 16172253, 1035997,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,1313665024, 1149235200, 4293918720, 1827667968, 2901409792, 1862270976, 1610612736, 4026531840,1033444, 1046340, 4095, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[12] = {
			Animation = "Bike Down Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 3149713152,0, 0, 0, 34952, 576443, 572347, 9223099, 16567227,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2630668032, 3402269168, 2576806896, 1717784320, 790839040, 607342336, 860843776, 4284690176,16567497, 253275308, 255814041, 16004710, 15938290, 16003906, 16184371, 15873791,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2858630912, 3488890880, 4294963200, 1827667968, 2901409792, 1862270976, 1610612736, 4026531840,15939242, 282620, 1048575, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[13] = {
			Animation = "Bike Left Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 2290089984, 3150446592, 3149692928, 3149498368, 3150547440, 3435842032,0, 0, 559240, 9223099, 9157563, 147569595, 147635131, 147639500,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435964912, 3433737984, 2290499584, 1060323328, 606356480, 860110592, 1867493120, 1713568496,260885708, 256412876, 256133256, 16003651, 995891, 16663603, 266200198, 256763126,0, 0, 0, 0, 0, 0, 0, 0,0, 1610612736, 4127195136, 1868562432, 4210032640, 1794113536, 2936012800, 4026531840,1714682608, 4287614966, 2298466303, 2003827785, 1828384960, 4294602655, 1026730, 65535,266636534, 117374856, 1879048184, 4131671295, 2936852479, 2801399471, 4205488880, 268435200,0, 0, 0, 6, 15, 15, 0, 0},
		},
		[14] = {
			Animation = "Bike Left Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 4026531840, 4026531840,0, 0, 2290647040, 3149645824, 3149642880, 3149642120, 3149646217, 3435973321,0, 0, 2184, 36027, 35771, 576443, 576699, 576716,0, 0, 0, 0, 0, 0, 0, 0,4026531840, 0, 0, 0, 0, 0, 0, 0,3435973801, 3435965103, 2290648640, 1128215360, 858006528, 859000576, 1716498176, 1713568496,1019084, 1001612, 1000520, 62514, 3890, 65092, 1039844, 1002980,0, 0, 0, 0, 0, 0, 0, 0,0, 1610612736, 4127195136, 1331691520, 4210032640, 1794113536, 2936012800, 4026531840,4130601712, 4287614966, 2298466303, 4294966345, 2147152064, 3338301343, 4279216810, 65535,1041548, 107413240, 1879048184, 4131671295, 2936852471, 2801399542, 4205488895, 268435200,0, 0, 0, 6, 15, 15, 0, 0},
		},
		[15] = {
			Animation = "Bike Up Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 2290647040, 3149645824, 3149641728, 3149642880, 3149646976, 3435973872,0, 0, 2184, 36027, 35771, 576443, 576699, 1035468,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435972848, 4291593247, 2290634559, 1142181872, 1146090480, 4294861808, 3721711360, 3722366720,1019084, 15812812, 15987848, 16774209, 255066100, 255223023, 16739405, 1002733,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,1155854336, 1146052608, 4294963200, 2901409792, 1827667968, 1862270976, 1610612736, 4026531840,1046350, 65396, 4095, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[16] = {
			Animation = "Bike Up Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 2290089984, 3150446592, 3149398016, 3149692928, 3150741504, 3435982848,0, 0, 559240, 9223099, 9157563, 147569595, 147635131, 265080012,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435720704, 3431210752, 2286894848, 340786944, 1342125040, 4266025968, 3569811200, 3737448448,260885708, 4048080127, 4092889224, 267665732, 255849540, 255258623, 16535005, 16575965,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3833528320, 1207894016, 4293918720, 1827667968, 1827667968, 2936012800, 1610612736, 4026531840,1003076, 455748, 1048575, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[17] = {
			Animation = "Bike Down Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 2290647040, 3149645824, 3149641728, 3149642880, 3149647088,0, 0, 0, 2184, 36027, 35771, 576443, 1035451,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2580335856, 3433867295, 2576969535, 1717974256, 586298352, 574829808, 859109104, 4294127360,1035468, 15829706, 15988377, 1000294, 996143, 17204, 1011523, 15873647,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2858630912, 3488890880, 4294336512, 2902454272, 1827667968, 1862270976, 1610612736, 4026531840,15939242, 282620, 4095, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[18] = {
			Animation = "Bike Down Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 2290089984, 3150446592, 3149398016, 3149692928, 3150770176,0, 0, 0, 559240, 9223099, 9157563, 147569595, 265075643,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435982848, 2896699136, 2574204672, 1714745344, 4063490048, 1127481344, 888598528, 4133695232,265079961, 4052404940, 4093024665, 256075366, 255012642, 256062498, 258949939, 15876095,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2858630912, 3488890880, 4293918720, 1827667968, 1827667968, 2936012800, 1610612736, 4026531840,15939242, 282620, 421887, 1048527, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[19] = {
			Animation = "Run Left Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 3149633664, 0, 0, 0, 0,34952, 576443, 572347, 9223099, 3149699231, 3435965599, 3435973279, 3435834096,2290639872, 871576576, 843202560, 859045888, 9227195, 9227468, 16305356, 16025804,16008328, 1000228, 16708387, 266200131, 4236247040, 1693450240, 804257792, 1056964608,1862270976, 4026531840, 0, 0, 256763078, 266637254, 16711666, 1046515,3948, 255, 0, 0},
		},
		[20] = {
			Animation = "Run Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149633664, 3149699231, 3435965599, 3435973279,3435834096, 2290639872, 871576576, 843202560, 9223099, 9227195, 9227468, 16305356,16025804, 150226056, 2166309668, 2180969251, 859340800, 4143065088, 1727215616, 2415915008,4293918720, 0, 0, 0, 266200131, 256765516, 266635468, 16707468,16289655, 1033983, 65280, 0},
		},
		[21] = {
			Animation = "Run Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149633664, 3149699231, 3435965599, 3435973279,3435834096, 2290639872, 871576704, 843202944, 9223099, 9227195, 9227468, 16305356,16025804, 16008328, 16728868, 266269475, 859080704, 1149239296, 3488612352, 2003763200,1828651008, 4293918720, 0, 0, 265847875, 260190052, 260259695, 16777164,1048575, 0, 0, 0},
		},
		[22] = {
			Animation = "Run Up Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 0, 0, 0, 0,34952, 576443, 572347, 9223099, 3149645824, 3149713152, 3435954672, 3435676656,4169416448, 1095300096, 1157587520, 4293276480, 9223099, 16567227, 253283532, 255102156,15943823, 5211156, 69664580, 70479615, 3712970496, 3723292672, 1307045888, 4009689088,4134469632, 267386880, 0, 0, 16184541, 1035997, 1015508, 65518,63087, 4080, 0, 0},
		},
		[23] = {
			Animation = "Run Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645824, 3149645824, 3149713152, 3435954672,3435676656, 4169416448, 1095302912, 1157578496, 9223099, 9223099, 16567227, 253283532,255102156, 15943823, 1016852, 1048388, 4176015360, 3722244096, 3722440704, 1155465216,4009099264, 1727004672, 2867855360, 4278190080, 16740351, 253906925, 255065325, 16738285,4094, 15, 15, 0},
		},
		[24] = {
			Animation = "Run Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645824, 3149645824, 3149713152, 3435954672,3435676656, 4169416448, 1095299072, 1157623808, 9223099, 9223099, 16567227, 253283532,255102156, 15943823, 16745492, 15990596, 4294377216, 3740541680, 3738121200, 3732340480,4025483264, 4026531840, 4026531840, 0, 1019535, 1035741, 1048029, 64836,28654, 3942, 4010, 255},
		},
		[25] = {
			Animation = "Run Down Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 0, 0, 0, 0,34952, 576443, 572347, 9223099, 3149647616, 3149713392, 2899083760, 3402298352,2576764672, 1717778160, 790886128, 860827392, 16563131, 268225467, 253283530, 255831212,16017817, 258160230, 258945778, 15922227, 1156789248, 2898718720, 4285464576, 4134469632,267386880, 0, 0, 0, 4407108, 1010890, 63231, 63087,4080, 0, 0, 0},
		},
		[26] = {
			Animation = "Run Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645824, 3149647616, 3149713152, 2899083760,3402298352, 2576764672, 1717780224, 790884352, 143440827, 2180823995, 2180828091, 253283530,255831212, 16017817, 15939174, 996082, 860876800, 4284936192, 2283732992, 587137024,871366656, 4278190080, 0, 0, 1045555, 1036287, 1010858, 63224,65400, 4010, 255, 0},
		},
		[27] = {
			Animation = "Run Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 0, 0, 0, 0,0, 34952, 576443, 572347, 3149645952, 3149647640, 3149713176, 2899083760,3402298352, 2576764672, 1717780224, 790884352, 9223099, 16563131, 16567227, 253283530,255831212, 16017817, 15939174, 996082, 860876800, 4294766592, 2865164288, 2406416384,2281635840, 2867855360, 4278190080, 0, 1045555, 1009407, 61832, 65314,3891, 255, 0, 0},
		},
		[28] = {
			Animation = "Surf Down Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0,0, 0, 0, 255, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 4026531840, 4177526784, 4177526784, 1727987712, 2003201792, 2004248304, 2004248175,2003199599, 1717986918, 1717986918, 1717986918, 65382, 16148087, 258369399, 4133906295,4133906039, 1717986918, 1717986918, 1717986918, 0, 0, 0, 0,0, 15, 159, 159, 0, 0, 0, 0,0, 0, 0, 0, 1718265455, 1722459897, 1722808576, 4285071360,0, 0, 0, 0, 4134184550, 2674567782, 10484326, 38655,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0},
		},
		[29] = {
			Animation = "Surf Up Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0,0, 0, 0, 255, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 4026531840, 4177526784, 4177526784, 2013200384, 2004250368, 2004248304, 2003199599,1717986927, 1717986918, 1717986918, 1717986918, 65399, 16148343, 258369399, 4133906039,4133906022, 1717986918, 1717986918, 1717986918, 0, 0, 0, 0,0, 15, 159, 159, 0, 0, 0, 0,0, 0, 0, 0, 1717986927, 1717987065, 1718615952, 2583064320,9857280, 626688, 0, 0, 4133906022, 2674288230, 167769702, 16150425,9857280, 626688, 0, 0, 0, 0, 0, 0,0, 0, 0, 0},
		},
		[30] = {
			Animation = "Surf Side Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 1718025984, 0, 0, 0, 0,0, 0, 4095, 1046118, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 4026531840,4026531840, 4026531840, 2415919104, 2415919104, 2003199728, 2004248175, 2004248175, 2003199590,1717986918, 1717987942, 1718004399, 1718004399, 267806311, 4133906039, 4133906039, 1717986919,1717986918, 1717986918, 1717986918, 4133906022, 0, 255, 4095, 4095,2559, 159, 255, 3942, 0, 0, 0, 0,0, 0, 0, 0, 1717988089, 1718024592, 4294545408, 2566914048,0, 0, 0, 0, 4284900966, 2577360486, 630783, 153,0, 0, 0, 0, 40806, 2415, 153, 0,0, 0, 0, 0},
		},
		[31] = {
			Animation = "Surf Down Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2415919104, 4177526784, 4186963968, 4278190080, 1727987712, 2003201792, 2004248304,2004248175, 2003199599, 1717986918, 1717986918, 255, 65382, 16148087, 258369399,4133906295, 4133906039, 1717986918, 1717986918, 0, 0, 0, 0,0, 9, 159, 2463, 2576351232, 2566914048, 0, 0,0, 0, 0, 0, 1717986918, 1718265593, 1722460569, 1869191424,0, 0, 0, 0, 1717986918, 2674566758, 2577050214, 10065654,0, 0, 0, 0, 2457, 153, 0, 0,0, 0, 0, 0},
		},
		[32] = {
			Animation = "Surf Up Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4177526784, 4186963968, 4278190080, 2013200384, 2004250368, 2004248304,2003199599, 1717986927, 1717986918, 1717986918, 255, 65399, 16148343, 258369399,4133906039, 4133906022, 1717986918, 1717986918, 0, 0, 0, 0,0, 0, 159, 2463, 2576351232, 2566914048, 0, 0,0, 0, 0, 0, 1717986918, 1717986927, 1717987065, 4194303897,2576771472, 10066176, 0, 0, 1717986918, 4133906022, 2674288230, 2583691167,160852377, 10066176, 0, 0, 2457, 153, 0, 0,0, 0, 0, 0},
		},
		[33] = {
			Animation = "Surf Side Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 0, 0, 0, 0,0, 0, 0, 4095, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,4026531840, 4026531840, 4177526784, 2566914048, 1718025984, 2003199728, 2004248175, 2004248175,2003199590, 1717986918, 1717987942, 1718004390, 1046118, 267806311, 4133906039, 4133906039,1717986919, 1717986918, 1717986918, 1717986918, 0, 0, 255, 4095,40959, 2463, 159, 255, 2415919104, 0, 0, 0,0, 0, 0, 0, 1718004393, 1718024601, 1869191568, 2576941056,0, 0, 0, 0, 4133906022, 1777755750, 2426011503, 629145,0, 0, 0, 0, 40806, 39270, 2457, 0,0, 0, 0, 0},
		},
		[34] = {
			Animation = "Player Surf Sit Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 0, 0, 0, 0, 34952, 576443, 572347, 9223099, 3149713152, 2630668032, 3402269168, 2576806896, 1717784320, 790839040, 607338496, 860843776, 16567227, 16567497, 253275308, 255814041, 16004710, 15938290, 275266, 16184371, 4291781184, 2898670400, 4135056384, 2137452544, 4284936192, 16711680, 0, 0, 69663999, 70479050, 5207919, 1009399, 1009407, 65280, 0, 0},
		},
		[35] = {
			Animation = "Player Surf Sit Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 0, 0, 0, 0, 34952, 576443, 572347, 9223099, 3149711360, 3435974400, 3435958016, 4240982512, 2290414576, 1095040768, 1157623808, 4293160704, 9227195, 16567500, 16305356, 253005007, 255805576, 16729108, 1048388, 16731903, 3438043712, 3712762688, 3723490304, 4008112128, 1325334528, 4278190080, 0, 0, 69652172, 70567133, 5242589, 1011438, 65508, 255, 0, 0},
		},
		[36] = {
			Animation = "Player Surf Sit Side",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290089984, 3150446592, 3149692928, 3149498368, 0, 0, 0, 0, 559240, 9223099, 9157563, 147569595, 3150547440, 3435842032, 3435964912, 3433737984, 2290499584, 1060323328, 606339072, 859832320, 147635131, 147639500, 260885708, 256412876, 256133256, 16003651, 995891, 16663619, 1156579328, 4244631552, 2406444800, 4160515840, 4143378432, 268369920, 0, 0, 266201316, 256764159, 266637158, 16711526, 1048371, 136, 0, 0},
		},
		[37] = {
			Animation = "Pull out Pokeball 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290089984, 3150479360, 3149645824, 3149645824, 0, 0, 0, 0, 2184, 560059, 834491, 9223099, 3149710848, 3399272800, 2898958944, 2577049088, 1717985280, 586362880, 573787904, 860840768, 9227451, 9227468, 16305356, 69160105, 70530150, 4403759, 275236, 1045555, 4291584832, 606356480, 875884544, 1145528320, 4152356864, 258404352, 16711680, 0, 1033839, 1009219, 1046083, 423679, 1046399, 1009392, 65280, 0},
		},
		[38] = {
			Animation = "Pull out Pokeball 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149694976, 3149642880, 0, 0, 0, 0, 0, 136, 35003, 52155, 3149642880, 3149646944, 3433680022, 3402410406, 2576984672, 1717986816, 4063179520, 1109603392, 576443, 576715, 576716, 1019084, 4322506, 4408134, 275234, 17202, 859108160, 4291183616, 574767104, 860090368, 1149198336, 4284936192, 16711680, 0, 65347, 1035375, 1033796, 1046116, 425983, 1009407, 65280, 0},
		},
		[39] = {
			Animation = "Pull out Pokeball 3",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3150479360, 3149645824, 3149645824, 0, 0, 0, 0, 34952, 560059, 834491, 9223099, 3149710848, 3399272800, 2898958944, 2577049328, 1717989120, 804536064, 4221259520, 4240896832, 9227451, 9227468, 267963596, 69160105, 70530150, 4403759, 275236, 16774195, 4205441856, 805258304, 875885568, 1145528320, 4152356864, 258404352, 16711680, 0, 70239855, 71263811, 5240387, 423679, 1046399, 1009392, 65280, 0},
		},
		[40] = {
			Animation = "Pull out Pokeball 4",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 0, 0, 0, 0, 34952, 576443, 572347, 9223099, 3149713152, 2630668032, 3402269168, 2576806896, 1717784320, 790839040, 607339328, 860877632, 16567227, 16567497, 253275308, 255814041, 16774758, 263828466, 264987458, 262840115, 4287000320, 2864246784, 2580541440, 4284964864, 4152356864, 258404352, 16711680, 0, 16774911, 4334796, 4404427, 280319, 1046399, 1009392, 65280, 0},
		},
		[41] = {
			Animation = "Pull out Pokeball 5",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3435970560, 3149641728, 3435973760, 2580335856, 0, 0, 0, 0, 3276, 35771, 576716, 1035468, 3433876720, 2576984304, 1717989199, 871576639, 574763839, 572732480, 859111168, 4294328064, 1035466, 267668121, 4221302374, 4240896831, 4205441844, 268387122, 1110404931, 1127507663, 2864410368, 2579296256, 2597318656, 4133973760, 4294338048, 1048320, 0, 0, 71722682, 64715, 64716, 423679, 1046390, 1009392, 65280, 0},
		},
		[42] = {
			Animation = "Pull out Fishing Rod side 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4227858432, 4283432960, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2281701376, 3162505216, 3150446592, 0, 0, 0, 0, 0, 1351125128, 4174101435, 4173052859, 267714560, 16732160, 1045760, 65360, 4085, 255, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3147333632, 3164118784, 3433864960, 3435831040, 3400200192, 2288254976, 4080271360, 1111490560, 2361113531, 2362162107, 2362232012, 4174171340, 4102606028, 4098132104, 256058419, 15934258, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 876544000, 1715404800, 1728016128, 3480973056, 2137452544, 4043243520, 0, 0, 16007987, 266203016, 256765883, 266637260, 16707532, 1009407, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[43] = {
			Animation = "Pull out Fishing Rod side 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 264241152, 256901120, 267714560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 3149633664, 16056320, 16732160, 1003520, 1045760, 34952, 576443, 572347, 9223099, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149699231, 3435965599, 3435973279, 3435834096, 2290639872, 871576576, 843202560, 859045888, 9227195, 9227468, 16305356, 16025804, 16008328, 1000228, 62243, 1041475, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4133744640, 4133744640, 3329163264, 3439325184, 2004578048, 4151046144, 268369920, 0, 16637576, 16047867, 16664828, 1044428, 1048575, 1009392, 65280, 0},
		},
		[44] = {
			Animation = "Pull out Fishing Rod side 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13565952, 100597760, 1609564160, 4278190080, 4026531840, 0, 0, 0, 0, 0, 0, 5, 2147483743, 0, 0, 0, 0, 0, 2290649216, 3149642696, 3149642684, 0, 0, 0, 0, 0, 8, 140, 139, 0, 0, 0, 0, 0, 0, 0, 0, 2281702911, 2314231792, 3388342016, 2852122624, 2952724480, 1325400064, 1073741824, 4026531840, 3149642681, 3149642697, 3435973834, 3435973836, 2362231978, 1216907398, 843267891, 842212388, 2251, 2252, 2252, 3980, 3912, 3908, 244, 255, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 0, 0, 0, 0, 0, 0, 0, 1144206147, 2381643631, 4167447536, 3479633664, 3439263744, 2012217344, 1819213824, 4293918720, 4062, 64989, 62685, 65092, 1011711, 1009399, 65295, 0},
		},
		[45] = {
			Animation = "Pull out Fishing Rod side 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149645824, 3149633664, 0, 0, 0, 0, 34952, 576443, 572347, 9223099, 0, 0, 0, 0, 0, 1431683072, 4294963200, 4026531840, 0, 0, 0, 0, 0, 0, 21845, 89522175, 3149699231, 3435965599, 3435973279, 3435834096, 2290639872, 871576576, 843202560, 859063296, 9227195, 9227468, 16305356, 16025804, 16008328, 1000228, 62243, 1041475, 0, 0, 0, 0, 0, 0, 0, 0, 1610608640, 4278190080, 0, 0, 0, 0, 0, 0, 4098368069, 1715417935, 1715422208, 4293918720, 2012217344, 3337617408, 4278190080, 0, 16637583, 16047862, 16664822, 1044428, 65399, 246, 15, 0},
		},
		[46] = {
			Animation = "Pull out Fishing Rod down 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64768, 62976, 62976, 62976, 62976, 62976, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62976, 62976, 2290152960, 3150509568, 3149460992, 3149694464, 3150771712, 3435984384, 0, 0, 559240, 9223099, 9157563, 147569595, 265075643, 265079961, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2896699136, 2574204672, 1714745344, 4063490048, 1127497472, 888553216, 4062638080, 1127215104, 4052404940, 4093024665, 256075366, 255012642, 4404258, 16728883, 16565871, 16541283, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073676288, 4237230080, 4293918720, 4293918720, 4278190080, 0, 0, 0, 16541283, 1013759, 1013350, 65535, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[47] = {
			Animation = "Pull out Fishing Rod down 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 3489660928, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 0, 15, 15, 15, 2290089999, 3150446607, 3149398031, 3149693183, 0, 0, 0, 0, 559240, 9223099, 9157563, 147569595, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3150770422, 3435983094, 2896699382, 2574204918, 1714749280, 4063493984, 1127544320, 888677104, 265075643, 265079961, 4052404940, 4093024665, 256075366, 255012642, 4404258, 1000243, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4062721008, 1127677696, 2219769856, 3439263744, 4293918720, 4026531840, 0, 0, 16561919, 16541283, 1017443, 1046664, 1013631, 63087, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[48] = {
			Animation = "Pull out Fishing Rod down 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290089984, 3150446592, 0, 0, 0, 0, 0, 0, 559240, 9223099, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149398016, 3149692928, 3150770176, 3435982848, 2896699136, 2574204672, 1714745344, 4063490048, 9157563, 147569595, 265075643, 265079961, 4052404940, 4093024665, 256075366, 255012642, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1127505920, 888565504, 4236668672, 4095930368, 875782144, 872374272, 4294964736, 1046016, 4404258, 16728883, 16515071, 16475747, 16543540, 1013759, 63087, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62976, 65376, 3936, 4086, 252, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[49] = {
			Animation = "Pull out Fishing Rod down 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 3149713152, 0, 0, 0, 34952, 576443, 572347, 9223099, 16567227, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2630668032, 3402269168, 2576806896, 1717784320, 790839040, 607338496, 860839936, 4291227648, 16567497, 253275308, 255814041, 16004710, 15938290, 275266, 455731, 1010943, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2892427264, 1279258624, 607608832, 880799744, 1869017088, 1627324416, 1610612736, 1610612736, 1009354, 1045444, 422722, 1046339, 1009407, 65295, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 3221225472, 4026531840, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[50] = {
			Animation = "Pull out Fishing Rod up 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290647040, 3149645824, 3149641728, 3149642880, 3149646976, 3435973872, 3435972848, 4291593247, 2184, 36027, 35771, 576443, 576699, 1035468, 1019084, 15812812, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290634559, 1142181872, 1146093312, 4294504448, 3723489280, 4008640512, 1325334528, 4293918720, 15987848, 16774209, 255262708, 255259871, 16187101, 16187118, 16187364, 16185599, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 0, 0, 0, 0, 0, 0, 0, 16184934, 16125951, 16121856, 16121856, 16121856, 16121856, 16580608, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[51] = {
			Animation = "Pull out Fishing Rod up 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290647040, 3149645824, 0, 0, 0, 0, 0, 0, 2184, 36027, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149641728, 3149642880, 3149646976, 3435973872, 3435972848, 4291593247, 2290634559, 1142181872, 35771, 6867899, 116968635, 117427404, 1879018700, 1878083788, 1878258824, 1863316545, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1146091008, 4294508288, 3723489280, 4008701952, 1324937216, 4294901760, 4026531840, 0, 4278255604, 4027577567, 4027580125, 4026859246, 4026597348, 4026595583, 63078, 4095, 6, 6, 6, 6, 6, 13, 0, 0},
		},
		[52] = {
			Animation = "Pull out Fishing Rod up 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4278190080, 0, 0, 0, 0, 0, 15, 12, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290614272, 3149692928, 3149627392, 3149645824, 3149711360, 1862270976, 1862270976, 1877999616, 116426888, 116968379, 116964283, 9223099, 9227195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3435974400, 3435958016, 4240982512, 2290414576, 1095040768, 1157590784, 4283404032, 3723460608, 16567500, 16305356, 253005007, 255805576, 16729108, 16187204, 16315647, 589533, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4008701952, 1324937216, 4294963200, 268369920, 0, 0, 0, 0, 1048302, 1048548, 1013759, 1013759, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 2290614272, 3149692928, 3149627392, 3149645824, 3149711360, 15, 15, 15, 34959, 576443, 572347, 9223099, 9227195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3435974400, 3435958016, 4240982512, 2290414576, 1095040768, 1157623808, 4293160704, 3438046976, 16567500, 16305356, 253005007, 255805576, 16729108, 1048388, 16142079, 16174796, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3712806912, 3723489280, 4008140800, 1317007360, 4284936192, 16711680, 0, 0, 1033437, 1048285, 425710, 1046500, 1009407, 65280, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
	},
	--Female FRLG
	[2] = {
		[1] = {
			Animation = "Side Left",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0,26214, 436633, 432537, 16423321, 2577049952, 2863442272, 3435833696, 2863310336,1717986304, 1140012032, 1111638016, 4080271360, 262842777, 262851242, 4110068940, 4282821290,4047791718, 256132164, 256119169, 256132340, 4134404096, 645267456, 685244416, 954728448,1323302912, 3404726272, 4278190080, 0, 256132340, 16008271, 1048562, 3907,4068, 250, 15, 0},
		},
		[2] = {
			Animation = "Side Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0,26214, 436633, 432537, 6986137, 2577049952, 2863442272, 3435832896, 2863293680,1717653488, 286343664, 286543616, 289689344, 110799257, 110807722, 74099916, 256289450,267654758, 252973329, 16007441, 16008209, 1145372416, 1145369584, 4283417584, 1726930688,3277778688, 4205834240, 267386880, 0, 16729156, 255804484, 255653119, 16764006,62780, 64175, 4080, 0},
		},
		[3] = {
			Animation = "Side Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0,26214, 436633, 432537, 6986137, 3113920864, 2896996704, 3435833072, 2577035072,1717847280, 790843376, 607384816, 860833008, 110799259, 110807754, 258649292, 83274137,256132710, 267662066, 256848706, 256177203, 4293326064, 1835216640, 3613605632, 1724706816,3277783040, 4205772800, 267386880, 0, 256861695, 15873622, 15939198, 1044182,62780, 64175, 4080, 0},
		},
		[4] = {
			Animation = "Walk Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 2577049952, 2863442272, 3435833696,2863310336, 1717986304, 1140012032, 1111638016, 16423321, 262842777, 262851242, 4110068940,4282821290, 4098123366, 256132164, 256119169, 4080271360, 4134404096, 4252368896, 2391277568,4009422848, 4138528768, 16711680, 0, 4098114804, 4098114804, 256134946, 16731955,65524, 63231, 4080, 0},
		},
		[5] = {
			Animation = "Walk Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 2577049952, 2863442272, 3435833696,2863310336, 1717986304, 1140012032, 1111638016, 16423321, 262842777, 262851242, 4110068940,4282821290, 4047791718, 256132164, 255924244, 4080271360, 4100325376, 1109917696, 1127804928,3830444032, 4294901760, 0, 0, 4098114804, 4098114804, 256132351, 16777198,1044462, 1034863, 65520, 0},
		},
		[6] = {
			Animation = "Walk Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 2577049952, 2863442272, 3435832896,2863293680, 1717653488, 286343664, 286543616, 6986137, 110799257, 110807722, 74099916,256289450, 267654758, 252973329, 16007441, 289689344, 1145327360, 1145369584, 4283417584,1825505024, 4294901760, 4026531840, 0, 16008209, 255083588, 16729156, 849151,64710, 3955, 4010, 255},
		},
		[7] = {
			Animation = "Walk Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 2577049952, 2863442272, 3435832896,2863293680, 1717653488, 286343664, 286543616, 6986137, 110799257, 110807722, 74099916,256289450, 267654758, 252973329, 16007441, 289689344, 1145324528, 1145372416, 4283428608,1827598080, 905965568, 2867855360, 4278190080, 16008209, 16008260, 255804484, 255653119,16777158, 4095, 15, 0},
		},
		[8] = {
			Animation = "Walk Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 3113920864, 2896996704, 3435833072,2577035072, 1717847280, 790843376, 607384816, 6986137, 110799259, 110807754, 258649292,83274137, 256132710, 267662066, 256848706, 860828912, 4293279728, 3580165888, 1986850816,1825505280, 904921088, 2867855360, 4278190080, 256177203, 256180223, 16720886, 996350,65478, 4095, 15, 0},
		},
		[9] = {
			Animation = "Walk Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 3113920864, 2896996704, 3435833072,2577035072, 1717847280, 790843376, 607384816, 6986137, 110799259, 110807754, 258649292,83274137, 256132710, 267662066, 256848706, 860833008, 4294919408, 3744661248, 2134110208,1828651008, 4278190080, 4026531840, 0, 256111667, 267611903, 16729686, 1039982,1043654, 65363, 4010, 255},
		},
		[10] = {
			Animation = "Bike Left Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 1717985280, 2576983552, 2576979456, 2576980576, 2576984726, 2863319702,0, 0, 1638, 27289, 27033, 1026457, 16427673, 16428202,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435965078, 2863311456, 1717986880, 1144992576, 337912832, 1328762624, 1330622208, 4062378736,256879308, 267676330, 252986982, 16008260, 16007448, 16008271, 16008271, 1000516,0, 0, 0, 0, 0, 0, 0, 0,0, 1610612736, 4127195136, 1331691520, 4210032640, 1794113536, 2936012800, 4026531840,1663302384, 1879035894, 3909079039, 4294966345, 3405443264, 4294601209, 1026730, 65535,65535, 107376605, 1879048174, 4131671295, 2936852474, 2795478959, 4205488880, 268435200,0, 0, 0, 6, 15, 15, 0, 0},
		},
		[11] = {
			Animation = "Bike Up Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 2577049952, 2863442272,0, 0, 26214, 436633, 432537, 6986137, 110799257, 110807722,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435832896, 2863293680, 1717653488, 286343664, 286543616, 289689584, 1145369584, 1145372416,74099916, 256289450, 267654758, 252973329, 16007441, 267666449, 255804484, 16729156,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,4283408384, 3439325184, 4293918720, 1827667968, 2901409792, 1862270976, 1610612736, 4026531840,718079, 1048524, 4095, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[12] = {
			Animation = "Bike Down Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 3113920864,0, 0, 0, 26214, 436633, 432537, 6986137, 110799259,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2896996704, 3435833072, 2577035072, 1717847280, 790843376, 607384816, 860833008, 4284690416,110807754, 258649292, 83274137, 256132710, 267662066, 256848706, 256177203, 267532031,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2858630912, 3488890880, 4294963200, 1827667968, 2901409792, 1862270976, 1610612736, 4026531840,15939242, 282620, 1048575, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[13] = {
			Animation = "Bike Left Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 1610612736, 1610612736,0, 0, 1717986816, 2576980576, 2576980320, 2576980390, 2576980649, 2863312041,0, 0, 102, 1705, 1689, 64153, 1026729, 1026762,0, 0, 0, 0, 0, 0, 0, 0,1610612736, 0, 0, 0, 0, 0, 0, 0,3435973289, 2863311526, 1717986916, 1145303860, 2168603200, 1156789248, 1330622208, 4062378736,16054956, 16729770, 15811686, 1000516, 1000465, 16008260, 16008271, 16008271,0, 0, 0, 0, 0, 0, 0, 0,0, 1610612736, 4127195136, 1331691520, 4210032640, 1794113536, 2936012800, 4026531840,4079221488, 1879035894, 3875524607, 4294966345, 4294635712, 3405410207, 4279216810, 65535,1048574, 107376605, 1879048174, 4131671295, 2936852479, 2801399546, 4205488895, 268435200,0, 0, 0, 6, 15, 15, 0, 0},
		},
		[14] = {
			Animation = "Bike Left Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 2577049952, 2863442272,0, 0, 26214, 436633, 432537, 16423321, 262842777, 262851242,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435833696, 2863310336, 1717986304, 1140012032, 1111638016, 4080287488, 1330622208, 4062378736,4110068940, 4282821290, 4047791718, 256132164, 256119169, 256132340, 256132340, 256132351,0, 0, 0, 0, 0, 0, 0, 0,0, 1610612736, 4127195136, 1868562432, 4210032640, 1794113536, 2936012800, 4026531840,4079221488, 1879035894, 4026519551, 4289723465, 2902126784, 4294602655, 1026730, 65535,16777062, 107376605, 1879048174, 4131671295, 2936852479, 2801399471, 4205488880, 268435200,0, 0, 0, 6, 15, 15, 0, 0},
		},
		[15] = {
			Animation = "Bike Up Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 1717985280, 2576983552, 2576979456, 2576980576, 2576984726, 2863319702,0, 0, 1638, 27289, 27033, 436633, 6924953, 6925482,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3435965028, 2863310415, 1717966079, 286331935, 286541040, 1145327600, 1145369584, 4282711808,4631244, 16018090, 16728422, 15798545, 256119057, 267666500, 255804484, 16732159,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,4294963200, 3438977024, 4294963200, 2901409792, 1827667968, 1862270976, 1610612736, 4026531840,1048575, 4044, 4095, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[16] = {
			Animation = "Bike Up Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 1717567488, 2577793024, 2576744448, 2577031168, 2578093568, 2865403392,0, 0, 419430, 6986137, 6920601, 111778201, 1772788121, 1772923562,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3433718784, 2863025920, 1712652032, 286334720, 286344432, 1145327600, 1145369584, 4282711808,1185598668, 4100631210, 4282476134, 4047573265, 256131345, 267666500, 255804484, 16732159,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,4294963200, 3438280704, 4293918720, 1827667968, 1827667968, 2936012800, 1610612736, 4026531840,1048575, 700364, 1048575, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[17] = {
			Animation = "Bike Down Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 1717985280, 2576983552, 2576979456, 2576980576, 3147410070,0, 0, 0, 1638, 27289, 27033, 436633, 6924953,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2865416854, 3435965039, 2576983796, 1717978191, 586298623, 574832463, 859108592, 4294127360,6925484, 16165580, 5204633, 267666534, 4098835247, 4098159412, 256134979, 15873647,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2858630912, 3488890880, 4294615040, 2902454272, 1827667968, 1862270976, 1610612736, 4026531840,15939242, 282620, 4095, 4047, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[18] = {
			Animation = "Bike Down Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 1717567488, 2577793024, 2576744448, 2577031168, 2578093568,0, 0, 0, 419430, 6986137, 6920601, 111778201, 1772788155,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,3402274304, 3433721600, 2577855488, 1715752944, 4063556687, 1128219727, 888423664, 4133695232,1772924074, 4138388684, 1332386201, 4098123366, 4282593058, 4109579298, 256852787, 267534335,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,2858630912, 3488890880, 4293918720, 1827667968, 1827667968, 2936012800, 1610612736, 4026531840,15939242, 282620, 700415, 1048527, 4047, 255, 15, 15,0, 0, 0, 0, 0, 0, 0, 0},
		},
		[19] = {
			Animation = "Run Left Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717985280, 2576983552, 2576979456, 2576980576, 0, 0, 0, 0,1638, 27289, 27033, 1026457, 2576984726, 2863319702, 3435965078, 2863311456,1717986880, 1144992576, 522462208, 4080222208, 16427673, 268086442, 4098861772, 4282673834,4098115174, 1145115716, 4098114696, 256133137, 2264858624, 804257792, 1065353216, 4269801472,2936012800, 4026531840, 0, 0, 16732008, 52578, 65267, 65263,4012, 255, 0, 0},
		},
		[20] = {
			Animation = "Run Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717985280, 2576983552, 2576979456, 0, 0, 0, 0,0, 1638, 27289, 27033, 2576980576, 2576984726, 2863319702, 3435965078,2863311456, 1717986880, 1144992576, 522462208, 1026457, 16427673, 16428202, 256879308,267676330, 256132710, 16008260, 256119112, 523452416, 1996423168, 3633250304, 2365255680,4289523712, 16711680, 0, 0, 256149576, 16720639, 7287800, 7340014,1044206, 65535, 0, 0},
		},
		[21] = {
			Animation = "Run Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717985280, 2576983552, 2576979456, 0, 0, 0, 0,0, 1638, 27289, 27033, 2576980576, 2576984726, 2863319702, 3435965078,2863311456, 1717986880, 1144992576, 522462208, 1026457, 16427673, 16428202, 256879308,267676330, 252986982, 16008260, 256119112, 523517952, 4148307968, 3745724416, 4009750528,4009099264, 4278190080, 0, 0, 256132168, 16008447, 16777215, 16710894,16560110, 1044735, 0, 0},
		},
		[22] = {
			Animation = "Run Up Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0,26214, 436633, 432537, 6986137, 2576984416, 2577049952, 2863441648, 3435816176,1717653488, 286343664, 286347008, 286543856, 110795161, 110799257, 258656938, 256289996,267654758, 252973329, 15995153, 267665681, 1145369584, 1145372656, 4283417584, 3439259392,4205834240, 267386880, 0, 0, 255804484, 268387396, 16577791, 1036236,64175, 4080, 0, 0},
		},
		[23] = {
			Animation = "Run Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 2576984416, 2577049952, 2863441648,3435816176, 1717653488, 286343664, 286347008, 6986137, 110795161, 110799257, 258656938,256289996, 267654758, 252973329, 15995153, 289689344, 1145372416, 4283387648, 1727983360,3439325184, 2867855360, 2867855360, 4278190080, 16008209, 16729156, 254014719, 255066060,16715772, 15, 15, 0},
		},
		[24] = {
			Animation = "Run Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 0, 0, 0, 0,0, 26214, 436633, 432537, 2576983552, 2576984416, 2577049952, 2863441648,3435816176, 1718570992, 286343664, 286347008, 6986137, 110795161, 110799257, 258656938,256289996, 267712102, 252973329, 15995153, 289689344, 1145372416, 4294243056, 3436131312,3489550080, 4027576320, 4026531840, 0, 16008209, 16729156, 1003519, 64758,4044, 4010, 4010, 255},
		},
		[25] = {
			Animation = "Run Down Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 404746240, 1717997312, 2577035008, 2576966896, 2576983792, 0, 0, 4095, 1044865, 16279142, 16165273, 256285081, 258644377, 2576984416, 3113920864, 2896996719, 3435832911, 2577035087, 1718568176, 791936768, 860831488, 110795161, 110799259, 4137339594, 4100631756, 4109805977, 256177766, 16724978, 15987763, 4294131456, 1724182528, 3439263744, 4205772800, 267386880, 0, 0, 0, 15941631, 1003118, 1040076, 64175, 4080, 0, 0, 0},
		},
		[26] = {
			Animation = "Run Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 1718022144, 2577035008, 2576969472, 0, 0, 0, 0, 4095, 1009254, 16165273, 16161177, 2576983552, 2576984416, 3113920864, 2896996704, 3435833072, 2577035071, 1718567999, 791937008, 6986137, 110795161, 110799259, 110807754, 258649292, 16165273, 256177766, 16724978, 860880640, 4294766592, 1724706816, 4241424384, 2414870528, 2867855360, 4278190080, 0, 1045555, 1019903, 1016644, 1037346, 65331, 255, 0, 0},
		},
		[27] = {
			Animation = "Run Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 1718022144, 2577035008, 2576969472, 0, 0, 0, 0, 4095, 1009254, 16165273, 16161177, 2576983552, 2576984416, 3113920864, 2896996704, 3435833072, 2577035008, 1718568176, 791936768, 6986137, 110795161, 110799259, 110807754, 258649292, 4093028761, 4081383014, 268383218, 860876800, 4294373376, 1144979456, 575602688, 871366656, 4278190080, 0, 0, 16708659, 16642047, 1043558, 64719, 4088, 4010, 255, 0},
		},
		[28] = {
			Animation = "Surf Down Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0,0, 0, 0, 255, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 4026531840, 4177526784, 4177526784, 1727987712, 2003201792, 2004248304, 2004248175,2003199599, 1717986918, 1717986918, 1717986918, 65382, 16148087, 258369399, 4133906295,4133906039, 1717986918, 1717986918, 1717986918, 0, 0, 0, 0,0, 15, 159, 159, 0, 0, 0, 0,0, 0, 0, 0, 1718265455, 1722459897, 1722808576, 4285071360,0, 0, 0, 0, 4134184550, 2674567782, 10484326, 38655,0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0},
		},
		[29] = {
			Animation = "Surf Up Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0,0, 0, 0, 255, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,0, 4026531840, 4177526784, 4177526784, 2013200384, 2004250368, 2004248304, 2003199599,1717986927, 1717986918, 1717986918, 1717986918, 65399, 16148343, 258369399, 4133906039,4133906022, 1717986918, 1717986918, 1717986918, 0, 0, 0, 0,0, 15, 159, 159, 0, 0, 0, 0,0, 0, 0, 0, 1717986927, 1717987065, 1718615952, 2583064320,9857280, 626688, 0, 0, 4133906022, 2674288230, 167769702, 16150425,9857280, 626688, 0, 0, 0, 0, 0, 0,0, 0, 0, 0},
		},
		[30] = {
			Animation = "Surf Side Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 1718025984, 0, 0, 0, 0,0, 0, 4095, 1046118, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 4026531840,4026531840, 4026531840, 2415919104, 2415919104, 2003199728, 2004248175, 2004248175, 2003199590,1717986918, 1717987942, 1718004399, 1718004399, 267806311, 4133906039, 4133906039, 1717986919,1717986918, 1717986918, 1717986918, 4133906022, 0, 255, 4095, 4095,2559, 159, 255, 3942, 0, 0, 0, 0,0, 0, 0, 0, 1717988089, 1718024592, 4294545408, 2566914048,0, 0, 0, 0, 4284900966, 2577360486, 630783, 153,0, 0, 0, 0, 40806, 2415, 153, 0,0, 0, 0, 0},
		},
		[31] = {
			Animation = "Surf Down Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2415919104, 4177526784, 4186963968, 4278190080, 1727987712, 2003201792, 2004248304,2004248175, 2003199599, 1717986918, 1717986918, 255, 65382, 16148087, 258369399,4133906295, 4133906039, 1717986918, 1717986918, 0, 0, 0, 0,0, 9, 159, 2463, 2576351232, 2566914048, 0, 0,0, 0, 0, 0, 1717986918, 1718265593, 1722460569, 1869191424,0, 0, 0, 0, 1717986918, 2674566758, 2577050214, 10065654,0, 0, 0, 0, 2457, 153, 0, 0,0, 0, 0, 0},
		},
		[32] = {
			Animation = "Surf Up Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4177526784, 4186963968, 4278190080, 2013200384, 2004250368, 2004248304,2003199599, 1717986927, 1717986918, 1717986918, 255, 65399, 16148343, 258369399,4133906039, 4133906022, 1717986918, 1717986918, 0, 0, 0, 0,0, 0, 159, 2463, 2576351232, 2566914048, 0, 0,0, 0, 0, 0, 1717986918, 1717986927, 1717987065, 4194303897,2576771472, 10066176, 0, 0, 1717986918, 4133906022, 2674288230, 2583691167,160852377, 10066176, 0, 0, 2457, 153, 0, 0,0, 0, 0, 0},
		},
		[33] = {
			Animation = "Surf Side Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 0, 0, 0, 0,0, 0, 0, 4095, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0,4026531840, 4026531840, 4177526784, 2566914048, 1718025984, 2003199728, 2004248175, 2004248175,2003199590, 1717986918, 1717987942, 1718004390, 1046118, 267806311, 4133906039, 4133906039,1717986919, 1717986918, 1717986918, 1717986918, 0, 0, 255, 4095,40959, 2463, 159, 255, 2415919104, 0, 0, 0,0, 0, 0, 0, 1718004393, 1718024601, 1869191568, 2576941056,0, 0, 0, 0, 4133906022, 1777755750, 2426011503, 629145,0, 0, 0, 0, 40806, 39270, 2457, 0,0, 0, 0, 0},
		},
		[34] = {
			Animation = "Player Surf Sit Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0, 26214, 436633, 432537, 6986137, 3113920864, 2896996704, 3435835376, 2577035072, 1717847280, 790843376, 607384816, 860878064, 110799259, 110807754, 258649292, 83274137, 256132710, 267662066, 256848706, 256898099, 4293869360, 3981899328, 3865887552, 4205367040, 4205375488, 267386880, 0, 0, 15987967, 74409302, 71091822, 16550575, 1018543, 4080, 0, 0},
		},
		[35] = {
			Animation = "Player Surf Sit Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0, 26214, 436633, 432537, 6986137, 2577049952, 2863442272, 3435832896, 2863293680, 1717653488, 286343664, 286543616, 289689344, 110799257, 110807722, 74099916, 256289450, 267654758, 252973329, 16007441, 16008209, 1145372416, 1145369584, 4283417584, 1726930688, 3439259392, 4279234560, 0, 0, 16729156, 255804484, 255653119, 16764006, 65484, 255, 0, 0},
		},
		[36] = {
			Animation = "Player Surf Sit Side",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0, 26214, 436633, 432537, 16423321, 2577049952, 2863442272, 3435833696, 2863310336, 1717986304, 1140012032, 1111638016, 4080271360, 262842777, 262851242, 4110068940, 4282821290, 4047791718, 256132164, 256119169, 256132340, 4134404096, 1744826368, 1869590272, 2186063616, 2202726400, 268369920, 0, 0, 256132340, 16008271, 1046770, 1044274, 63539, 68, 0, 0},
		},
		[37] = {
			Animation = "Pull out Pokeball 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 2576769024, 2576982016, 2576983552, 0, 0, 0, 0, 1638, 420505, 6986137, 6986137, 2578106720, 2865539424, 3433731824, 2573627200, 1717847280, 4062465871, 1110701135, 860832847, 110795705, 110938796, 268094668, 16165273, 5203558, 4407074, 996130, 16053299, 1109914864, 1110834944, 1146470144, 1825304576, 3277783040, 4205772800, 267386880, 0, 15953908, 1041442, 16639026, 16641604, 1045820, 64175, 4080, 0},
		},
		[38] = {
			Animation = "Pull out Pokeball 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 2573598720, 2577006592, 0, 0, 0, 0, 0, 26214, 6728089, 111778201, 2577031168, 2595001856, 2898957824, 3400101632, 2523329536, 1715752704, 574944496, 591348976, 111778201, 1772731289, 1775020746, 4289514700, 258644377, 83256934, 70513199, 15938084, 872367344, 1199525632, 660598784, 1180430336, 3434348544, 4205772800, 267386880, 0, 255128627, 255225842, 15999554, 16003652, 1048422, 64175, 4080, 0},
		},
		[39] = {
			Animation = "Pull out Pokeball 3",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2576769024, 2576982016, 2576983552, 0, 0, 0, 0, 26214, 420505, 6986137, 6986137, 2578106720, 2865539424, 3433731824, 2573627200, 1717847280, 4062465871, 1110701135, 860832847, 110795705, 110938796, 268094668, 83274137, 256861798, 256114498, 256883124, 268422255, 1109914864, 1110834944, 1146470144, 1825304576, 3277783040, 4205772800, 267386880, 0, 268413599, 16777202, 16639026, 16641604, 1045820, 64175, 4080, 0},
		},
		[40] = {
			Animation = "Pull out Pokeball 4",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0, 26214, 436633, 432537, 6986137, 3113920864, 2896996704, 3435833072, 2577035072, 1718328304, 791463664, 607824368, 860880640, 110799259, 110807754, 258649292, 83274137, 256132710, 4109644530, 4098831170, 4098880563, 4294124544, 3606262784, 1970270208, 1724706816, 3277783040, 4205772800, 267386880, 0, 267597567, 15943254, 1033838, 1044182, 62780, 64175, 4080, 0},
		},
		[41] = {
			Animation = "Pull out Pokeball 5",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2863267840, 2576965632, 3113920000, 2896864768, 0, 0, 0, 0, 43690, 432537, 6990235, 6990538, 3435983936, 2577381812, 1718602863, 1061137055, 606339056, 573829668, 860832564, 4284694512, 6999244, 110799257, 258369126, 83244019, 256127554, 16724770, 255849523, 255018751, 4267963632, 3581342960, 1467272960, 3435982848, 4097306624, 262860800, 16711680, 0, 16003941, 1048422, 65006, 1003238, 1005055, 65280, 0, 0},
		},
		[42] = {
			Animation = "Pull out Fishing Rod side 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4227858432, 4283432960, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 2589982720, 2573205504, 0, 0, 0, 0, 0, 1348888166, 4138310041, 4137261465, 267714560, 16732160, 1045760, 65360, 4085, 255, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2577793024, 2594791424, 2896781312, 3400097792, 2863005696, 1717829632, 4080271360, 1111490560, 4204370329, 2863241625, 2865408682, 4205628620, 1185589930, 1147561574, 1145324611, 1141997890, 0, 15, 15, 244, 255, 244, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 875495424, 1127153664, 1945923328, 3723276032, 3740987392, 4026466304, 4026531840, 0, 4098117455, 4098117455, 256132342, 16777062, 1036269, 1009406, 65535, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[43] = {
			Animation = "Pull out Fishing Rod side 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 264241152, 256901120, 267714560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 16056320, 16732160, 1003520, 1045760, 26214, 436633, 432537, 16423321, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2577049952, 2863442272, 3435833696, 2863310336, 1717986304, 1140012032, 1111638016, 4080271360, 262842777, 262851242, 4110068940, 4282821290, 256140902, 4098114628, 4098101633, 4098114804, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4282576896, 1932718080, 1715404800, 4002410496, 3723276032, 4138528768, 268369920, 0, 4098117512, 268433126, 63206, 1033966, 1035501, 1009407, 65280, 0},
		},
		[44] = {
			Animation = "Pull out Fishing Rod side 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13565952, 100597760, 1609564160, 4278190080, 4026531840, 0, 0, 0, 0, 0, 0, 5, 95, 0, 0, 0, 0, 0, 1717986912, 2576980390, 2576980374, 0, 0, 0, 0, 0, 6, 106, 105, 0, 0, 0, 0, 0, 0, 0, 0, 1610614271, 2516606960, 2516975360, 2522869760, 1711210496, 1341128704, 1325400064, 4026531840, 2576980378, 2576980394, 2863311562, 3435973802, 2863311530, 1717986918, 1145323315, 403973156, 4009, 64170, 64172, 1003434, 16774250, 256132166, 4098114628, 4098114625, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4098044751, 1156906863, 4285739760, 1718615808, 3741253632, 4008706048, 2897149952, 4293918720, 4282664004, 267666511, 16777206, 1048302, 1035997, 1010894, 65295, 0},
		},
		[45] = {
			Animation = "Pull out Fishing Rod side 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 0, 0, 0, 0, 26214, 436633, 432537, 16423321, 0, 0, 0, 0, 0, 1431683072, 4294963200, 4026531840, 0, 0, 0, 0, 0, 0, 21845, 89522175, 2577049952, 2863442272, 3435833696, 2863310336, 1717986304, 1140012032, 1111638016, 4080306176, 262842777, 262851242, 4110068940, 4282821290, 4047791718, 256132164, 256119169, 256132340, 0, 0, 0, 0, 0, 0, 0, 0, 1610608640, 4278190080, 0, 0, 0, 0, 0, 0, 4098368069, 1932473167, 1668252672, 4008181760, 3722444800, 3404726272, 4278190080, 0, 256132340, 16008271, 1048566, 4078, 4077, 250, 15, 0},
		},
		[46] = {
			Animation = "Pull out Fishing Rod down 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64768, 62976, 62976, 62976, 62976, 62976, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62976, 62976, 1717630464, 2577856000, 2576807424, 2577032704, 2578093568, 3402274304, 0, 0, 419430, 6986137, 6920601, 111778201, 1772788155, 1772924074, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3433758464, 2577855488, 1715752704, 4063559424, 1128218368, 888422144, 4062638080, 1127215104, 4138388684, 1332386201, 4098123366, 4282593058, 4109579298, 4098835251, 16148079, 16152371, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073676288, 4237230080, 2297430016, 4293918720, 4278190080, 0, 0, 0, 16148275, 16701183, 16673446, 1047215, 4095, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[47] = {
			Animation = "Pull out Fishing Rod down 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 3489660928, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 0, 15, 15, 15, 1717567503, 2577793039, 2576744463, 2577031423, 0, 0, 0, 0, 419430, 6986137, 6920601, 111778201, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2578093814, 3402274550, 3433758710, 2577855734, 1715752800, 4063559520, 1128265216, 888414960, 1772788155, 1772924074, 4138388684, 1332386201, 4098123366, 4282593058, 4109579298, 4098835251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4062721008, 2201419520, 1753743360, 3439263744, 4293918720, 4026531840, 0, 0, 256344063, 267810355, 266896948, 267311240, 16761663, 64175, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[48] = {
			Animation = "Pull out Fishing Rod down 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 2577793024, 0, 0, 0, 0, 0, 0, 419430, 6986137, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576744448, 2577031168, 2578093568, 3402274304, 3433758464, 2577855488, 1715752704, 4063559424, 6920601, 111778201, 1772788155, 1772924074, 4138388684, 1332386201, 4098123366, 4282593058, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1128222464, 888426240, 4136005376, 4095930368, 607346688, 872374272, 4294964736, 1046016, 4109579298, 4098835251, 256376831, 267674422, 16639524, 16698470, 1045823, 64175, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62976, 65376, 3936, 4086, 252, 255, 0, 0, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[49] = {
			Animation = "Pull out Fishing Rod down 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 3113920864, 0, 0, 0, 26214, 436633, 432537, 6986137, 110799259, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2896996704, 3435835376, 2577035072, 1717847280, 790843376, 607384816, 860833008, 4281683712, 110807754, 258649292, 83274137, 256132710, 267662066, 256848706, 256177203, 16012287, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1394867968, 4080320512, 617345024, 878641152, 1252982784, 1877999616, 1610612736, 1610612736, 16724533, 803647, 1044034, 62787, 64175, 4095, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 3221225472, 4026531840, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[50] = {
			Animation = "Pull out Fishing Rod up 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717985280, 2576983552, 2576979456, 2576980576, 2576984726, 2863319702, 3435965028, 2863310415, 1638, 27289, 27033, 436633, 6924953, 6925482, 4631244, 16018090, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717966079, 286331935, 286344432, 286541040, 1145324784, 1145327360, 4294246144, 3439255296, 16728422, 15810833, 255804433, 255804481, 16729156, 16184388, 16174927, 16123644, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293914624, 0, 0, 0, 0, 0, 0, 0, 16125866, 16122111, 16121856, 16121856, 16121856, 16121856, 16580608, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[51] = {
			Animation = "Pull out Fishing Rod up 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717985280, 2576983552, 0, 0, 0, 0, 0, 0, 1638, 27289, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576979456, 2576980576, 2576984726, 2863319702, 3435965028, 2863310415, 1717966079, 286331935, 27033, 436633, 107588249, 107588778, 1866902220, 1878289066, 1878999398, 1878081809, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 286344432, 286541040, 1145324784, 1145327360, 4294246144, 3439255296, 4293914624, 0, 4279190545, 4027532353, 4027532356, 4026594372, 4026584911, 4026534140, 4010, 255, 6, 6, 6, 6, 6, 13, 0, 0},
		},
		[52] = {
			Animation = "Pull out Fishing Rod up 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4278190080, 0, 0, 0, 0, 0, 15, 12, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717960704, 2577031168, 2576965632, 2576983552, 2577049952, 1862270976, 1862270976, 1877999616, 116418150, 116828569, 116824473, 6986137, 110799257, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2863442272, 3435832896, 2863293680, 1717653488, 286343664, 286543616, 289689344, 1145327360, 110807722, 74099916, 256289450, 267654758, 252973329, 16007441, 16008209, 16008260, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1145368576, 4283428864, 3488477184, 4278124544, 0, 0, 0, 0, 1000516, 849151, 28620, 64175, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 1717960704, 2577031168, 2576965632, 2576983552, 2577049952, 15, 15, 15, 26214, 436633, 432537, 6986137, 110799257, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2863442272, 3435832896, 2863293680, 1717653488, 286343664, 286543616, 289689344, 1145368576, 110807722, 74099916, 256289450, 267654758, 252973329, 16007441, 16008209, 1000516, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1145368576, 4283420416, 1726930688, 3277778688, 4205834240, 267386880, 0, 0, 1000516, 849151, 1035366, 62780, 64175, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
	},
	
	--Male EMERALD
	[3] = {
		[1] = {
			Animation = "Side Left",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008334592, 2595153920, 0, 0, 1280, 24144, 24293, 5609881, 93952494, 1503238553, 2863328000, 3149640704, 2165388288, 830542848, 847320064, 858996736, 860094464, 1145044992, 100244410, 16353467, 16287880, 16287887, 1045295, 1000227, 63539, 1030980, 4174643200, 3481534464, 3750690816, 4293918720, 4293918720, 2296315904, 4293918720, 0, 16403343, 16496892, 1032189, 65535, 4095, 3915, 255, 0},
		},
		[2] = {
			Animation = "Side Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 2576979200, 4008267776, 3919156480, 0, 0, 0, 0, 1365, 24297, 388846, 5893790, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573784064, 1155526656, 4287119104, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 15960319, 3959376960, 2857360704, 1146093312, 3154112512, 4294242304, 4098158592, 268369920, 0, 80019390, 148763818, 9434180, 1048507, 1003519, 1000527, 65520, 0},
		},
		[3] = {
			Animation = "Side Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008267776, 2862280704, 0, 0, 1280, 24144, 351973, 5872025, 367006, 1026474, 2929442560, 4004208384, 286388800, 403784256, 673395712, 590561280, 860876800, 4287115008, 16497130, 16104174, 70193425, 69472641, 4403842, 275250, 1045555, 15894783, 3633257536, 2295651648, 2370830080, 1157623808, 4294242304, 4105039872, 268369920, 0, 79820941, 148721032, 9434328, 1048388, 1003519, 1038927, 65520, 0},
		},
		[4] = {
			Animation = "Walk Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008334848, 0, 0, 0, 1280, 24144, 24293, 5609881, 93952494, 2595153920, 2863328000, 3149640704, 4044436480, 830542848, 847320064, 858996736, 860094464, 1503238553, 100244410, 16353467, 16287880, 16287887, 1045295, 1000227, 63539, 1212153856, 4286840832, 3438604288, 3724496640, 4294201088, 4282707968, 16711680, 0, 1031048, 16403336, 16496783, 1032191, 16646143, 16629759, 1035504, 65280},
		},
		[5] = {
			Animation = "Walk Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008334848, 0, 0, 0, 1280, 24144, 24293, 5609881, 93952494, 2595153920, 2863328000, 3149640704, 2165388288, 830542848, 847320064, 858996736, 860094464, 1503238553, 100244410, 16353467, 16287880, 16287887, 1045295, 1000227, 63539, 3560964096, 2370043904, 4174643200, 4169461760, 4170174208, 4294692608, 256176128, 16711680, 1030984, 16403455, 16498636, 1032157, 16056319, 16011263, 1044480, 0},
		},
		[6] = {
			Animation = "Walk Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 2576979200, 4008267776, 0, 0, 0, 0, 0, 1365, 24297, 388846, 3919156480, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573784064, 1143472128, 5893790, 16357785, 16292249, 71276697, 70551689, 4407295, 16003874, 16615492, 4286836736, 3958697984, 2857354240, 1146083328, 3154083840, 4293918720, 4026531840, 0, 1046783, 1048510, 1045674, 324676, 65467, 65535, 64836, 4095},
		},
		[7] = {
			Animation = "Walk Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 2576979200, 4008267776, 0, 0, 0, 0, 0, 1365, 24297, 388846, 3919156480, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573787904, 1149812480, 5893790, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 33604, 4287623168, 3959418880, 2857365504, 1146044416, 3154051072, 4294901760, 1155465216, 4293918720, 997631, 1003454, 5043370, 9303108, 589755, 4095, 15, 0},
		},
		[8] = {
			Animation = "Walk Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 2862280704, 2929442560, 4004208384, 286388800, 403784256, 673395712, 590561280, 860876800, 1026474, 16497130, 16104174, 70193425, 69472641, 4403842, 16003890, 79688755, 4286787328, 3633313792, 2298269440, 2231230208, 4294963200, 4293918720, 4026531840, 0, 146798847, 9406605, 62600, 65348, 36863, 62655, 64932, 4095},
		},
		[9] = {
			Animation = "Walk Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 2862280704, 2929442560, 4004208384, 286388800, 403784256, 673395712, 590565120, 860879680, 1026474, 16497130, 16104174, 70193425, 69472641, 4403842, 275250, 1045555, 4287626112, 3632855040, 2286878720, 1157562368, 4294443008, 4216258560, 1256128512, 4293918720, 15874303, 9435277, 16568200, 16637912, 1048575, 4095, 15, 0},
		},
		[10] = {
			Animation = "Bike Left Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431633920, 2582533376, 4008617392, 2578094464, 3149573792, 0, 80, 1509, 1518, 350617, 5872030, 93952409, 6265243, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149642560, 2400260928, 4061663552, 4062720832, 858993887, 859110879, 1146064880, 4079111375, 1022091, 1017992, 1017992, 65330, 324659, 16428932, 262451192, 263979007, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 4109762560, 255787008, 2503933952, 334495744, 4278190080, 4281597407, 4294967286, 4294964447, 2296378189, 4294917964, 1503606175, 89191185, 4095, 16777215, 1718026239, 4294964303, 1145359867, 4042081535, 4182004720, 823213824, 4294963200, 0, 0, 6, 111, 243, 243, 15, 0},
		},
		[11] = {
			Animation = "Bike Up Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 4008613120, 4008267776, 4003045120, 2576981760, 0, 0, 0, 1365, 24302, 368366, 16357870, 16357785, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576977664, 2575954752, 2559066944, 4294198272, 3959418880, 2856857344, 1145597696, 3153653760, 16292249, 71276697, 70551689, 4476927, 1048510, 15893674, 16155716, 1048507, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294242304, 4294901760, 2146435072, 1961885696, 2649751552, 2130706432, 1879048192, 4026531840, 1003519, 65535, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[12] = {
			Animation = "Bike Down Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 4008640256, 2862268160, 0, 1280, 24144, 351973, 5872025, 367086, 16751086, 16492970, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2929442560, 4004217664, 303121216, 673395952, 674448368, 860390128, 2290626304, 1341968224, 16497130, 70826734, 70521121, 256062082, 255079298, 254313523, 15878280, 117231604, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871568880, 4294197248, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 268294390, 282623, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[13] = {
			Animation = "Bike Left Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008401664, 2594826240, 3148540416, 0, 1280, 24144, 24293, 5609881, 93952494, 1503238553, 100243899, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149640704, 4044436480, 562107392, 579024112, 859000287, 860851679, 2228785136, 4079111375, 16353467, 16287880, 16287887, 1045295, 5194547, 262928451, 4199219192, 4223664127, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 2499149824, 255787008, 4114546688, 334495744, 4278190080, 4281597407, 4294967295, 4170054735, 3096444868, 4294917900, 1503606265, 89191185, 4095, 268435455, 1718026239, 4294964303, 1145359839, 4042081525, 1598313456, 823213824, 4294963200, 0, 0, 6, 111, 243, 243, 15, 0},
		},
		[14] = {
			Animation = "Bike Left Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 4008635227, 2577050088, 3149638378, 0, 5, 94, 94, 21913, 367001, 5872025, 391577, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149642676, 2297499956, 2401337620, 790790964, 858993487, 1127436255, 2219806704, 4079111375, 63880, 63624, 63624, 4083, 20291, 1026808, 16403192, 16498687, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 2499149824, 255787008, 4114546688, 334495744, 4278190080, 4080270815, 4294967295, 4294245455, 4294967236, 2382315276, 4288624121, 89191185, 4095, 1048575, 1718026239, 4294964479, 1145360312, 4042081528, 1598313471, 823213824, 4294963200, 0, 0, 6, 111, 243, 243, 15, 0},
		},
		[15] = {
			Animation = "Bike Up Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83886080, 1582301184, 3998547968, 4008267776, 4002742272, 3919179776, 2577002496, 0, 0, 5, 21854, 388846, 5893870, 261725934, 261724569, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576936960, 2560111616, 2290365440, 4282662912, 3221159936, 2760044544, 1149693952, 3213819904, 260675993, 1140427161, 1128827033, 71630847, 16776174, 254298794, 258491460, 16776123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294901760, 4294901760, 2146435072, 1961885696, 2112880640, 2667577344, 1879048192, 4026531840, 1048575, 1048575, 1040383, 65359, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[16] = {
			Animation = "Bike Up Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 90066944, 1592677632, 4008634704, 4008613120, 4008286704, 2576980464, 0, 0, 0, 85, 1518, 23022, 1022366, 1022361, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576980208, 2576916276, 2575860788, 4294919232, 4005560064, 2862908144, 1145341680, 3149893376, 1018265, 4454793, 4409480, 279807, 65531, 993354, 1009732, 65531, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294963200, 4294963200, 2147348480, 2499739648, 2112880640, 2130706432, 1879048192, 4026531840, 65535, 65535, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[17] = {
			Animation = "Bike Down Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 4008701952, 2846617600, 0, 1280, 5267024, 93675237, 93952409, 5873390, 268017390, 263887530, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3921408000, 3938399232, 554972160, 2184396800, 2201239296, 881340160, 2297581312, 1341968224, 263954090, 1140567790, 1128337937, 70461474, 4081268770, 4069016371, 254052488, 117231604, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871568880, 4294197248, 4260364288, 1844445184, 1827667968, 2667577344, 1610612736, 4026531840, 268294390, 282623, 1048543, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[18] = {
			Animation = "Bike Down Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847553024, 2582532096, 4008633600, 4008636400, 2863246320, 0, 5, 20574, 365918, 367001, 22942, 1046942, 1030810, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2867444720, 4008361780, 287380532, 578958144, 579023935, 859080751, 2290631408, 1341968224, 1031070, 4455342, 4407570, 275240, 15942456, 15894595, 16002952, 117231604, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871568880, 4294197248, 4261408768, 2649751552, 1827667968, 1862270976, 1610612736, 4026531840, 268294390, 282623, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[19] = {
			Animation = "Run Left Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 4008634965, 0, 0, 0, 5, 94, 94, 21913, 367001, 2577051368, 3148524523, 3148524468, 2287014196, 2402386196, 791838996, 590558016, 858997760, 5872025, 391579, 63877, 63624, 63624, 4083, 65347, 1031160, 4292673536, 3431923712, 3717136384, 4293918720, 4293918720, 2296315904, 4293918720, 0, 16403336, 16498575, 1032191, 65535, 4095, 3915, 255, 0},
		},
		[20] = {
			Animation = "Run Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 0, 0, 0, 0, 5, 94, 94, 21913, 4008634966, 2577051368, 3148524522, 3148524468, 2287014196, 2402386196, 791838996, 590558016, 367001, 5872025, 391579, 63877, 63624, 63624, 4083, 65347, 858997940, 3713006516, 2380206064, 2298474496, 4170174208, 4294692608, 256176128, 16711680, 1045039, 16567094, 16572296, 1048573, 16056319, 16011263, 1044480, 0},
		},
		[21] = {
			Animation = "Run Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 0, 0, 0, 0, 5, 94, 94, 21913, 4008634966, 2577051368, 3148524522, 3148524468, 2287014196, 2402386196, 791838996, 590558016, 367001, 5872025, 391579, 63877, 63624, 325768, 4964339, 4980547, 859045632, 2379795696, 2298469616, 2298478336, 4294242304, 4282707968, 16711680, 0, 326591, 1025208, 1031048, 1047551, 16646143, 16629759, 1035504, 65280},
		},
		[22] = {
			Animation = "Run Up Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 4008267776, 0, 0, 0, 0, 0, 1365, 24302, 368366, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4294201088, 3952082688, 2856901872, 16357870, 16357785, 16292249, 71276697, 70551689, 16011263, 16775358, 265127082, 1145605616, 3153657600, 2289037312, 4294242304, 4098158592, 268369920, 0, 0, 265847876, 16748475, 1046152, 1003519, 1000527, 65520, 0, 0},
		},
		[23] = {
			Animation = "Run Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 0, 0, 0, 0, 0, 0, 1365, 24302, 4008267776, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4282666752, 3103780864, 368366, 16357870, 16357785, 16292249, 71276697, 70551689, 256770047, 264211438, 2760765440, 1157418752, 3221081856, 2291134464, 4293918720, 4026531840, 4026531840, 0, 16140970, 1000516, 1018811, 63112, 65535, 64989, 63078, 4095},
		},
		[24] = {
			Animation = "Run Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 0, 0, 0, 0, 0, 0, 1365, 24302, 4008267776, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4294956272, 4005100528, 368366, 16357870, 16357785, 16292249, 71276697, 70551689, 16008447, 1048459, 2862903040, 1145368576, 3149459456, 2288975872, 4294901760, 3722379264, 1718550528, 4293918720, 1038410, 16568132, 16572411, 1046664, 4095, 15, 15, 0},
		},
		[25] = {
			Animation = "Run Down Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 4008640256, 2862268160, 2929442560, 4004217664, 303121216, 673395712, 674496256, 860409072, 16751086, 16492970, 16497130, 70826734, 70521121, 4403842, 16724866, 265061427, 3758087664, 2296381184, 2379804672, 1341452288, 4108185600, 268369920, 0, 0, 266207229, 16776584, 1019352, 1003508, 1039695, 65520, 0, 0},
		},
		[26] = {
			Animation = "Run Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 0, 0, 0, 0, 1280, 24144, 351973, 5872025, 4008595456, 4008640256, 2862268160, 2929442560, 4004217664, 303121216, 673395712, 674447360, 16095726, 268409326, 4227574186, 4227578346, 70826734, 70521121, 4403842, 275330, 860876800, 3640623104, 4241485824, 4258201600, 4293918720, 4026531840, 0, 0, 1045555, 1017997, 64904, 36863, 64957, 63078, 4095, 0},
		},
		[27] = {
			Animation = "Run Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 0, 0, 0, 0, 1280, 24144, 351973, 5872025, 4008595456, 4008640496, 2862268351, 2929442751, 4004217664, 303121216, 673395712, 674447360, 367086, 16751086, 16492970, 16497130, 70826734, 70521121, 4403842, 275330, 860876800, 3632852992, 2296315904, 4294443008, 3688824832, 1718550528, 4293918720, 0, 1045555, 589709, 1047759, 64735, 4095, 15, 0, 0},
		},
		[28] = {
			Animation = "Surf Down Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[29] = {
			Animation = "Surf Up Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[30] = {
			Animation = "Surf Side Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[31] = {
			Animation = "Surf Down Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[32] = {
			Animation = "Surf Up Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[33] = {
			Animation = "Surf Side Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[34] = {
			Animation = "Player Surf Sit Down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4008640256, 2862333696, 2929442560, 4005294912, 303121216, 673395712, 674447360, 860876800, 16751086, 16497066, 16497130, 71023598, 70521121, 4403842, 275330, 1045555, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287119104, 3633302592, 2295651648, 2231369472, 1332146176, 4284936192, 16711680, 0, 15960319, 80541837, 148721032, 9437000, 1009396, 1009407, 65280, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[35] = {
			Animation = "Player Surf Sit Up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 4008267776, 0, 0, 0, 0, 0, 1365, 24302, 368366, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4294128640, 573784064, 1155526656, 16357870, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287115008, 3959393344, 2857360704, 1146093312, 3153653760, 4177461248, 4278190080, 0, 15894783, 80281534, 148763818, 16774212, 1019835, 65423, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[36] = {
			Animation = "Player Surf Sit Side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998547968, 4004884480, 0, 0, 0, 20480, 386304, 388693, 89758105, 1503239918, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2867757056, 2863570944, 3149611008, 286474240, 403783680, 674447360, 859045888, 876609536, 2576980377, 1603910586, 261655483, 260606095, 260606194, 16724722, 16003891, 16315187, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 3741323008, 1341191408, 4285528304, 4287618816, 4294471424, 4283166720, 16711680, 263947336, 4199281293, 4223173256, 264209480, 16748532, 1047759, 64991, 4080, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[37] = {
			Animation = "Pull out Pokeball 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3938385920, 2612457472, 2609442816, 2873304064, 289547264, 573784064, 860815360, 1341652992, 261724654, 262777514, 1334438574, 1132916462, 1128366360, 70418984, 15933986, 79643443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4281921536, 1109979136, 1217392640, 4294963200, 4294242304, 4256034816, 268369920, 0, 80541951, 148701132, 9437149, 1048575, 1003519, 1039071, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[38] = {
			Animation = "Pull out Pokeball 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3937927168, 2612588544, 2609442816, 3091407872, 289547264, 573784064, 860815360, 1341652992, 261724654, 268020394, 1334438574, 1132916462, 1128366360, 70418984, 15933986, 79643443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4281921536, 579399680, 2291134464, 4294963200, 4294242304, 4256034816, 268369920, 0, 146538495, 9436356, 1048020, 1048575, 1003519, 1039071, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[39] = {
			Animation = "Pull out Pokeball 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2846818304, 3921408000, 3938185216, 287253504, 2165580800, 2183348224, 591331328, 1157562368, 16161450, 260479402, 260746990, 1139872017, 1128339473, 70395938, 15934532, 16731342, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3749965824, 1328082944, 2677010432, 4294963200, 4294242304, 4256034816, 268369920, 0, 79691724, 146798916, 9393561, 1046937, 1003519, 1039071, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[40] = {
			Animation = "Pull out Pokeball 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 2857893888, 2862149632, 0, 0, 0, 20480, 386384, 5631717, 93952426, 16358046, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 3825205248, 4248829952, 4176478208, 1508900864, 2667577344, 4026531840, 4003196928, 2863394884, 286409948, 293797327, 293752713, 572784357, 592445337, 1342131711, 16493230, 263961258, 263961361, 70513176, 70468136, 4404002, 1045554, 83120116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3565747652, 2291138368, 2286940160, 1157623808, 4294242304, 4256034816, 268369920, 0, 1308133517, 2380221832, 143652056, 1048388, 1003519, 1039071, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[41] = {
			Animation = "Pull out Pokeball 5",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2862972928, 3936980736, 4008296192, 0, 0, 1280, 24149, 351982, 5872026, 1022377, 1030826, 0, 0, 0, 0, 0, 0, 0, 0, 1140850688, 3460300800, 4292083712, 2676948992, 1436483584, 2582642688, 4278190080, 3288334336, 2863314948, 286337101, 2165839052, 2165838728, 572665758, 841105657, 860880719, 4294456573, 16497578, 16497585, 4407073, 4404258, 275250, 72351539, 1307856708, 2380267512, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 0, 0, 0, 0, 0, 0, 0, 3716714495, 2291138304, 2286940160, 1157623808, 4294242304, 4105039872, 268369920, 0, 143653000, 1002888, 1045720, 1048388, 1003519, 1038927, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[42] = {
			Animation = "Pull out Fishing Rod side 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4227858432, 4283432960, 267714560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847225344, 3931439104, 2934439936, 0, 0, 327680, 6180864, 1348396373, 1436129694, 2577002222, 2576980378, 16732160, 1045760, 65360, 4085, 255, 15, 5, 89, 0, 0, 0, 0, 0, 0, 0, 0, 2867527680, 3149135872, 288620544, 2165571584, 2165571584, 860831744, 1341965312, 296604672, 4187732650, 4186487739, 4169697521, 4169699121, 267595570, 256058163, 16745267, 16498673, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 865071104, 2414870528, 4294951936, 4294689792, 4282707968, 16711680, 0, 0, 262455091, 263978888, 16515071, 1048575, 65535, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[43] = {
			Animation = "Pull out Fishing Rod side 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 264241152, 256901120, 267714560, 16056320, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008334592, 2595153920, 16732160, 1003520, 1045760, 24144, 24293, 257268121, 93952494, 1503238553, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2863328000, 3149640704, 4044436480, 830542848, 847320064, 858996736, 860094464, 956235776, 100244410, 16353467, 16287880, 16287887, 1045295, 1000227, 63539, 1031044, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 986464256, 2413641728, 4294901760, 4294963200, 4294692608, 4102942720, 268369920, 0, 16403443, 16498680, 1032191, 65535, 1003519, 1000688, 65280, 0},
		},
		[44] = {
			Animation = "Pull out Fishing Rod side 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13565952, 100597760, 1609564160, 4278190080, 4026531840, 0, 0, 0, 0, 0, 0, 5, 95, 1535, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 4008634965, 0, 0, 0, 5, 94, 94, 21913, 367001, 0, 0, 0, 0, 0, 0, 0, 0, 24560, 392960, 6287360, 100597760, 4293918720, 3204448256, 3019898880, 4026531840, 2577051368, 3131747051, 3149642676, 2290159924, 2402386196, 791838996, 590558022, 858998015, 5872025, 391579, 63880, 63624, 63624, 4083, 3907, 248, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2230648576, 872349696, 952909824, 4292689920, 4294901760, 2414870528, 2380201984, 4293918720, 64445, 1025215, 1031167, 64511, 1003519, 1000692, 65295, 0},
		},
		[45] = {
			Animation = "Pull out Fishing Rod side 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008334592, 2595153920, 0, 0, 1280, 24144, 24293, 5609881, 93952494, 1503238553, 0, 0, 0, 0, 1431683072, 4294963200, 4026531840, 0, 0, 0, 0, 0, 0, 21845, 89522175, 1610608640, 2863328000, 3149640704, 2165388288, 830542848, 847320064, 858996736, 860156928, 1157610309, 100244410, 16353467, 16287880, 16287887, 1045295, 1000227, 63539, 1031048, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0, 0, 0, 0, 885849087, 2413690624, 2298413056, 4293918720, 4293918720, 2296315904, 4293918720, 0, 16403336, 16496776, 1032072, 65535, 4095, 3915, 255, 0},
		},
		[46] = {
			Animation = "Pull out Fishing Rod down 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64768, 62720, 62720, 62720, 62720, 62720, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 62720, 62720, 1426126080, 3998283008, 4008047872, 2846881024, 3921016064, 0, 20480, 386304, 5631573, 93952409, 5873390, 16423594, 257662634, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3937793280, 287296576, 2165628224, 2184511232, 859803392, 888704768, 4287164416, 3489656832, 257666798, 1123094801, 1111562257, 70461474, 4404002, 16728883, 16266495, 1016748, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3755995136, 4165959680, 1157562368, 4294180864, 3571384320, 4293918720, 0, 0, 1048573, 1003519, 1048031, 63087, 4095, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[47] = {
			Animation = "Pull out Fishing Rod down 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3489660928, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 0, 15, 15, 15, 15, 1426063375, 3998220303, 4007985407, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2846818549, 3921015029, 3937792245, 287256565, 2165583696, 2183352144, 859831364, 888733140, 16423594, 257662634, 257666798, 1139872017, 1128339473, 70395938, 4404002, 16728883, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287139824, 4170182656, 4249812992, 4110352384, 4293918720, 4026531840, 0, 0, 15962111, 16267980, 1019869, 1048575, 1003519, 1037535, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[48] = {
			Animation = "Pull out Fishing Rod down 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 0, 0, 0, 0, 0, 20480, 386304, 5631573, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3998220288, 4007985152, 4008701952, 2846879744, 3921014784, 3937743872, 554972160, 2184396800, 93952409, 5873390, 268017390, 268081834, 257662634, 1130082030, 1128337937, 70461474, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2201284608, 889188352, 4170178304, 2298269440, 4294205184, 4279193600, 1045760, 62720, 256063522, 256852787, 255393791, 266129288, 16637764, 1048575, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 65360, 3920, 4085, 252, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[49] = {
			Animation = "Pull out Fishing Rod down 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 2862280704, 0, 0, 1280, 24144, 351973, 5872025, 367086, 1026474, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2929417984, 4004208384, 286388800, 403784256, 673395712, 590561280, 860876800, 4286811904, 16103914, 16104174, 70193425, 69472641, 4403842, 275250, 1045555, 16005375, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3630403328, 4288974592, 3438866432, 3724537856, 4282707968, 1833824256, 1878982656, 1610612736, 16004749, 16035071, 1047759, 1048031, 1003519, 1037535, 65535, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 3221225472, 4026531840, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[50] = {
			Animation = "Pull out Fishing Rod up 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 6180864, 1441682688, 0, 0, 0, 0, 0, 0, 0, 85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576980304, 4008285440, 4003043664, 2576980464, 2576980464, 2576980004, 2576916260, 2575860544, 1518, 24302, 368366, 1022361, 1022361, 4360601, 4389257, 280712, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294915072, 1145962240, 4287164416, 3958960128, 2857365504, 1146028032, 3154051072, 4293918720, 1045503, 16777172, 262863103, 256245694, 16118954, 16118852, 16121787, 16121855, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 0, 0, 0, 0, 0, 0, 0, 16121156, 16060415, 16056320, 16056320, 16056320, 16056320, 16580608, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[51] = {
			Animation = "Pull out Fishing Rod up 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 6180864, 1441682688, 2576980304, 4008285440, 0, 0, 0, 0, 0, 85, 1518, 24302, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4003043664, 2576980464, 2576980208, 2576916260, 2575860772, 4294914880, 572732416, 1145962240, 368366, 6265241, 100632985, 99809673, 1609713800, 1594110975, 1594835762, 1594865876, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287139584, 3958960128, 2857365504, 1146089472, 3154112512, 4294901760, 4026531840, 0, 4279236863, 4027580350, 4027577514, 4026856516, 4026597307, 4026597375, 64836, 4095, 5, 5, 5, 5, 5, 13, 0, 0},
		},
		[52] = {
			Animation = "Pull out Fishing Rod up 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 0, 0, 0, 0, 0, 0, 15, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 4008267776, 4003045120, 2576981760, 4278190080, 1593835520, 1593835520, 1609565525, 99639022, 99983086, 100243950, 16357785, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576977664, 2575926080, 2559066944, 4294128640, 573784064, 1155530496, 4287160064, 3959394048, 16292249, 71276697, 70551689, 4407295, 16003874, 16776516, 16615679, 16318398, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2857336832, 1146089472, 3154112512, 4294963200, 268369920, 0, 0, 0, 586922, 1045572, 1048507, 1039871, 1009407, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1615855616, 1709506560, 1592086528, 2576979200, 4003024896, 2576979200, 15, 15, 15, 15, 1365, 24297, 388846, 5893790, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573784064, 1155526656, 4287160064, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 16615679, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3959394048, 2857336832, 1146089472, 3154112512, 4294242304, 4098158592, 268369920, 0, 16318398, 586922, 1045572, 1048507, 1003519, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1615855616, 1709506560, 1592086528, 2576979200, 4003024896, 2576979200, 15, 15, 15, 15, 1365, 24297, 388846, 5893790, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573784064, 1155526656, 4287160064, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 16615679, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3959394048, 2857336832, 1146089472, 3154112512, 4294242304, 4098158592, 268369920, 0, 16318398, 586922, 1045572, 1048507, 1003519, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[54] = {
			Animation = "Acro Bike Wheelie start side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008336128, 3937331200, 2863328000, 2863379456, 1280, 24144, 24293, 5609881, 93952494, 1503239918, 100243865, 16354218, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 3149607936, 4044428528, 562115775, 579030975, 859111408, 1157627087, 2374548959, 4164141055, 16287931, 16287880, 1046671, 5194543, 262927411, 4199219188, 4223664120, 268435455, 0, 0, 0, 0, 0, 0, 0, 0, 4284481536, 2499149824, 255787008, 4114546688, 334495744, 4278190080, 0, 0, 2415918159, 2298478532, 2415869708, 4187960825, 89191185, 4095, 0, 0, 1048575, 107376520, 1879048184, 4098116831, 1057936463, 905200959, 4077982704, 268435200, 0, 0, 0, 6, 15, 15, 0, 0},
		},
		[55] = {
			Animation = "Acro Bike Wheelie full side Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 1509, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431633920, 2582533376, 4008617392, 4008373888, 2578099888, 2863315776, 3149640512, 2400260416, 1518, 350617, 5872030, 93952494, 6265241, 1018298, 1017995, 1017992, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 4061664240, 4062721264, 858999792, 1146090496, 948489456, 4080786934, 2415919103, 2298477641, 65528, 327474, 16432963, 262451199, 263979007, 16777215, 1048575, 65416, 0, 0, 0, 0, 0, 0, 0, 0, 4092592128, 1408237568, 1056964608, 4026531840, 0, 0, 0, 0, 2405757120, 4187971487, 1342124305, 4278255615, 4026531840, 4026531840, 0, 0, 248, 6711039, 117440500, 1866745028, 4092652868, 4083106899, 254873919, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[56] = {
			Animation = "Acro Bike Wheelie full side turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1280, 24144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008336128, 4004440064, 2594892544, 2863309824, 3149607936, 4044428288, 24293, 5609881, 93952494, 1503239918, 100243865, 16292795, 16288699, 16287880, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 562118400, 579030000, 859094000, 1157579776, 2290666736, 841276918, 4294967295, 2405760073, 1048463, 5239599, 262927411, 4199219188, 4223664114, 268435455, 1048575, 65416, 0, 0, 0, 0, 0, 0, 0, 0, 4092592128, 1408237568, 1056964608, 4026531840, 0, 0, 0, 0, 4288278720, 1342136223, 1342124305, 4278255615, 4026531840, 4026531840, 0, 0, 248, 6706943, 117440500, 1866745028, 4092652868, 4082760019, 254873919, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[57] = {
			Animation = "Acro Bike Wheelie full side turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 0, 0, 0, 0, 0, 0, 5, 94, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3847573504, 2577327440, 4008634971, 4008619752, 2577050347, 3148524196, 3149642548, 2297499924, 94, 21913, 367001, 5872030, 391577, 63643, 63627, 63624, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2401337648, 790791152, 858993904, 4098162496, 4069051632, 4281523702, 4294967295, 2298477641, 4095, 20467, 1027060, 16403199, 16498687, 1048575, 1048575, 65535, 0, 0, 0, 0, 0, 0, 0, 0, 4092592128, 1408237568, 1056964608, 4026531840, 0, 0, 0, 0, 2290413760, 4136591263, 4187959569, 4293984255, 4026531840, 4026531840, 0, 0, 4088, 6706831, 117440500, 1866745028, 4092652868, 4082760019, 254873919, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[58] = {
			Animation = "Acro Bike Wheelie start down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 4008640256, 2862268160, 2929442560, 1280, 24144, 351973, 5872025, 367086, 16751086, 16492970, 16497130, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4004217664, 303121216, 673395952, 674448112, 859082496, 4294758240, 1869471728, 4294197248, 70826734, 70521121, 256062082, 254030722, 16270131, 117231615, 268293878, 282623, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294963200, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 0, 1048575, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[59] = {
			Animation = "Acro Bike Wheelie full down Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 0, 0, 0, 0, 0, 1280, 24144, 351973, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2665807872, 4008595456, 4008640256, 2862268160, 2929442560, 4004217664, 303121216, 673395952, 5872025, 367086, 16751086, 16492970, 16497130, 71285486, 70521121, 256062082, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 674448112, 859082496, 4294758240, 1871568880, 4294197248, 4261412608, 1817812736, 2684354304, 254030722, 16270131, 117231615, 268294390, 282623, 16777183, 16356815, 16777215, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[60] = {
			Animation = "Acro Bike Wheelie full down turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 0, 0, 0, 0, 0, 1280, 5267024, 93675237, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3998220288, 4007985152, 4008701952, 2846617600, 3921408000, 3937940480, 554972160, 2184400368, 93952409, 5873390, 268017390, 263887530, 263954090, 1133227758, 1128337937, 70461474, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2201259504, 881364736, 4294758240, 1871568880, 4294197248, 4260994816, 1828716288, 2672820224, 138623010, 8930099, 117231615, 268294390, 282623, 1048543, 16777167, 16359423, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 16774655, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[61] = {
			Animation = "Acro Bike Wheelie full down turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847553024, 0, 0, 0, 0, 0, 5, 20574, 365918, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2582532096, 4008633600, 4008636400, 2863246320, 2867444720, 4008359988, 287380532, 578958144, 367001, 22942, 1046942, 1030810, 1031070, 4426670, 4407570, 265564968, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 579024112, 859000576, 4294758240, 1871568880, 4294197248, 4261408768, 1828716288, 2683936512, 265569080, 16286771, 117231615, 268294390, 282623, 16359391, 16777167, 1535, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1868562176, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[62] = {
			Animation = "Acro Bike Wheelie start up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 4008613120, 4008267776, 4003045120, 2576981760, 2576977664, 0, 0, 1365, 24302, 368366, 16357870, 16357785, 16292249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2575954752, 2559066944, 4294198272, 4110372608, 1342168832, 3958960128, 2856906752, 1145630720, 71276697, 70551689, 4476927, 16056143, 16646132, 1019838, 1017002, 1045572, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3154051072, 4293918720, 1961885696, 2649751552, 2130706432, 1879048192, 4026531840, 0, 65467, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[63] = {
			Animation = "Acro Bike Wheelie full up Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98893824, 1592086528, 4008613120, 4008267776, 4003045120, 2576981760, 2576977664, 2575954752, 0, 1365, 24302, 368366, 16357870, 16357785, 16292249, 71276697, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2559066944, 4294198512, 4097832176, 1073733376, 4294963200, 3958960128, 2857365504, 1145696256, 70551689, 256135167, 256897871, 16646131, 1048575, 1019838, 1045674, 1020996, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3154051072, 4293918720, 2112880640, 2130706432, 1879048192, 4026531840, 0, 0, 65467, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[64] = {
			Animation = "Acro Bike Wheelie full up turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83886080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1582301184, 3998547968, 4008267776, 4002742272, 3919179776, 2577002496, 2576936960, 2560111616, 5, 21854, 388846, 5893870, 261725934, 261724569, 260675993, 1140427161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290365440, 4282665968, 1140847856, 4294958848, 4294963200, 3213750272, 2760503296, 1157562368, 1128827033, 71630847, 256849151, 16777011, 1048575, 588782, 543402, 16598084, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3220176896, 4293918720, 2112880640, 2130706432, 1879048192, 4026531840, 0, 0, 16382907, 1048575, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[65] = {
			Animation = "Acro Bike Wheelie full up turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 90066944, 1592677632, 4008634704, 4008613120, 4008286704, 2576980464, 2576980208, 2576916276, 0, 85, 1518, 23022, 1022366, 1022361, 1018265, 4454793, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2575860788, 4294919232, 4282643696, 872414976, 4294963200, 4005556224, 2862936064, 1145364224, 4409480, 263472383, 256900916, 16646143, 1048575, 1038587, 1022026, 65348, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149897472, 4294963200, 2112880640, 2130706432, 1879048192, 4026531840, 0, 0, 4091, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
	},
	--Female EMERALD
	[4] = {
		[1] = {
			Animation = "Side Left",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1476395008, 2857893888, 2594799616, 4002969600, 0, 0, 0, 559104, 143178629, 2344323498, 146315753, 9406958, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 2254438400, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2184, 4141350912, 4016570368, 2682191872, 4193255424, 1727004672, 2380201984, 4293918720, 0, 143, 65534, 1025785, 1031071, 65382, 3915, 255, 0},
		},
		[2] = {
			Animation = "Side Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 2310770432, 0, 0, 0, 559104, 9087877, 9157514, 559243, 16300952, 3149430528, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 4284608512, 16223163, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 988927, 3597659904, 2293800704, 2877681664, 3129995264, 1714356224, 4249812992, 267386880, 0, 16709229, 16354184, 1005754, 1046699, 62054, 62687, 4080, 0},
		},
		[3] = {
			Animation = "Side Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488697344, 2857940992, 2863366144, 4002959104, 0, 0, 0, 559104, 9157509, 9143722, 564969, 16026094, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860815360, 4294045696, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 62515, 991231, 3607031552, 3724123904, 2875191296, 3714510848, 1714356224, 4249812992, 267386880, 0, 16707437, 16359389, 1045946, 1009373, 62054, 62687, 4080, 0},
		},
		[4] = {
			Animation = "Walk Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1476395008, 2874671104, 2595979264, 0, 0, 0, 0, 559104, 143178629, 2344323498, 146315758, 4002969600, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 9405854, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2254438400, 805109760, 4277137408, 4188004096, 2415759104, 1720250368, 16711680, 0, 2184, 134, 65533, 1025789, 1031128, 16645990, 1035504, 65280},
		},
		[5] = {
			Animation = "Walk Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1476395008, 2874671104, 2595979264, 0, 0, 0, 0, 559104, 143178629, 2344323498, 146315758, 4002969600, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 9405854, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2254438400, 651689984, 4251451392, 4175425536, 2381762304, 1727778560, 266203136, 16711680, 2184, 2303, 65518, 1027993, 16759807, 16318310, 1048320, 0},
		},
		[6] = {
			Animation = "Walk Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 0, 0, 0, 0, 559104, 9087877, 9157514, 559243, 2310770432, 3149430528, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 16300952, 16223163, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 4284608512, 3596939264, 2290544384, 2864226048, 3148410880, 1717567488, 4026531840, 0, 1021695, 1021549, 1047512, 1006987, 63882, 63030, 4061, 255},
		},
		[7] = {
			Animation = "Walk Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 0, 0, 0, 0, 559104, 9087877, 9157514, 559243, 2310770432, 3149430528, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 16300952, 16223163, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 4285132800, 3597266944, 2378166272, 3101028352, 2828992512, 1668218880, 3723493376, 4278190080, 988927, 1001069, 16672904, 16354218, 1018555, 1638, 15, 0},
		},
		[8] = {
			Animation = "Walk Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488697344, 2857940992, 2863366144, 0, 0, 0, 0, 559104, 9157509, 9143722, 564969, 4002959104, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860815360, 16026094, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 16380979, 4176605184, 3756978176, 3751407616, 2824798208, 3724476416, 4293918720, 4026531840, 0, 16381695, 1017965, 64477, 64954, 63197, 3910, 3917, 255},
		},
		[9] = {
			Animation = "Walk Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488697344, 2857940992, 2863366144, 0, 0, 0, 0, 559104, 9157509, 9143722, 564969, 4002959104, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860856064, 16026094, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 62515, 4285505280, 3599298560, 3720282112, 2883518464, 3715039232, 1693450240, 3572498432, 4278190080, 991119, 1044214, 1022461, 62858, 65501, 4095, 15, 0},
		},
		[10] = {
			Animation = "Bike Left Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1434451968, 2862972928, 3937048576, 4008281984, 2219341696, 0, 0, 34944, 8948664, 146520234, 9144814, 587934, 1013640, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004387696, 2004949056, 2015891776, 1210585408, 2201171103, 2285128095, 1879019504, 3710017263, 1013623, 1012338, 1013623, 62583, 62532, 2116, 16777096, 262827997, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 4109762560, 254738432, 2502885376, 317718528, 4278190080, 3543398815, 1725956086, 3723818207, 2296377933, 4294913868, 1503602079, 89190929, 4095, 263961958, 1727751894, 4294964845, 1145360379, 4042081535, 4182004464, 554774272, 4294963200, 0, 0, 6, 111, 242, 242, 15, 0},
		},
		[11] = {
			Animation = "Bike Up Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 2310770432, 3149430528, 0, 0, 559104, 9087877, 9157514, 559243, 16300952, 16223163, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 4285394944, 3597201408, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 1038079, 1046125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2295656448, 2878275584, 3128950784, 1877999616, 2649751552, 1862270976, 1610612736, 4026531840, 1002888, 63674, 2219, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[12] = {
			Animation = "Bike Down Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 1488683008, 2857926656, 2863300608, 2594721536, 4002905856, 0, 34816, 572288, 572293, 558506, 564906, 16027374, 16206318, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1212622832, 1921545456, 1092125824, 404965504, 673509616, 860827392, 2298437376, 1610542944, 259159172, 256346152, 138969368, 142881409, 252658306, 15922227, 16121736, 117370869, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871290352, 4294963200, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 268015862, 1048575, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[13] = {
			Animation = "Bike Left Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2237136896, 2863290368, 4004161920, 4008614008, 1145341816, 0, 0, 2184, 559291, 9157514, 571550, 36745, 63348, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004322423, 662180228, 2005041428, 1954709780, 1211315023, 1216562335, 2290511856, 3710017263, 63351, 63271, 63351, 3911, 3908, 132, 1048568, 16426749, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 2499149824, 254738432, 4113498112, 317718528, 4278190080, 3543398815, 1668153343, 3605003343, 1073741764, 2382311180, 4288620025, 89190929, 4095, 16497622, 1718597229, 4294964326, 1145360312, 4042081528, 1598313215, 554774272, 4294963200, 0, 0, 6, 111, 242, 242, 15, 0},
		},
		[14] = {
			Animation = "Bike Left Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1434451968, 2862972928, 3937048576, 4008281984, 2219341696, 0, 0, 34944, 8948664, 146520234, 9144814, 587934, 1013640, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004387696, 2004949056, 2015891776, 1210585408, 2201171103, 2285128095, 1879019504, 3710017263, 1013623, 1012338, 1013623, 62583, 62532, 2116, 16777096, 262827997, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 4109762560, 254738432, 2502885376, 317718528, 4278190080, 3543398815, 1725956086, 3723818207, 2296377933, 4294913868, 1503602079, 89190929, 4095, 263961958, 1727751894, 4294964845, 1145360379, 4042081535, 4182004464, 554774272, 4294963200, 0, 0, 6, 111, 242, 242, 15, 0},
		},
		[15] = {
			Animation = "Bike Up Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 1435216512, 2861284224, 3146287104, 2291906800, 3149629424, 0, 0, 34944, 567992, 572344, 34952, 1018809, 1013947, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290644863, 2004317263, 2004109384, 1145341064, 1149779727, 859107328, 4294369024, 3714486016, 16217992, 16009079, 8684615, 8931396, 15790984, 3907, 64879, 65382, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290962176, 2864246784, 3148349440, 4143906816, 1844445184, 1862270976, 1610612736, 4026531840, 62680, 3979, 138, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[16] = {
			Animation = "Bike Up Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 2343206912, 2344321024, 2290614272, 2612588544, 3146248192, 0, 0, 8945664, 145406037, 146520234, 8947899, 260815240, 259570619, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2289532672, 2004111104, 1950894080, 1149536256, 2285833984, 888143872, 4141809664, 1720647680, 4151806088, 4098324343, 2223261559, 2286437444, 4042491972, 1000243, 16609279, 16738013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2370764800, 3102736384, 2818572288, 4293918720, 1844445184, 2667577344, 1610612736, 4026531840, 16046216, 1018794, 35515, 65526, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[17] = {
			Animation = "Bike Down Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 557056, 9156608, 1435219968, 2862974976, 2863310848, 3920266480, 4008278000, 0, 2176, 35768, 35768, 34907, 35306, 1001710, 1012894, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1149530751, 2267580239, 2215741512, 293745800, 578965263, 859109616, 2290631408, 1610542944, 16197448, 16021634, 8685585, 8930088, 16774184, 167747, 16121848, 117370869, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871290352, 4294266880, 4261408768, 2649751552, 1827667968, 1862270976, 1610612736, 4026531840, 268015862, 1048575, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[18] = {
			Animation = "Bike Down Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 142606336, 2344091648, 2344091648, 2777153536, 2864185344, 2877616128, 3916951552, 0, 557056, 9156608, 9156693, 8936106, 9038506, 256437993, 259301102, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2222096128, 679956224, 294144000, 2184480768, 2186278912, 888680192, 2415877888, 1610542944, 4146546756, 4101538439, 2223509892, 2286102545, 4042532898, 261047091, 265586824, 117370869, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871290352, 4294963200, 4260364288, 1844445184, 1827667968, 2667577344, 1610612736, 4026531840, 268015862, 352255, 1048543, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[19] = {
			Animation = "Run Left Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2237136896, 2863290368, 3920275840, 0, 0, 0, 0, 2184, 559291, 9157509, 571550, 4008614008, 1145341816, 2004322423, 662180228, 2005041428, 1954709780, 1211315008, 1216562176, 36745, 63348, 63351, 63271, 63351, 3911, 3908, 132, 4284874752, 4002349056, 2576285696, 4293918720, 1727004672, 2296315904, 4293918720, 0, 65496, 1025759, 1031135, 65501, 3942, 3913, 255, 0},
		},
		[20] = {
			Animation = "Run Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2237136896, 2863290368, 0, 0, 0, 0, 0, 2184, 559291, 9157509, 3920275840, 4008614008, 1145341816, 2004322423, 1920471428, 2005041428, 1211269396, 2201170752, 571550, 36745, 63348, 62583, 1013618, 1013623, 16009079, 1016904, 1212367872, 573107952, 2298452464, 3758096128, 3606331392, 4282707968, 16711680, 0, 1022082, 65528, 1025757, 1031133, 16643693, 16621567, 1035504, 65280},
		},
		[21] = {
			Animation = "Run Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2237136896, 2863290368, 0, 0, 0, 0, 0, 2184, 559291, 9157509, 3920275840, 4008614008, 1145341816, 2004322423, 1920471428, 2005041428, 1211269396, 2201170752, 571550, 36745, 63348, 62583, 1013618, 1013623, 16009079, 1016904, 1715684502, 913308054, 2380206064, 2297462784, 3758083840, 4285128448, 256765952, 16711680, 1046660, 16707362, 16359416, 1048029, 16017117, 16011263, 1044480, 0},
		},
		[22] = {
			Animation = "Run Up Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 2310770432, 0, 0, 0, 559104, 9087877, 9157514, 559243, 16300952, 3149430528, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860880640, 3597180656, 16223163, 259487880, 256145271, 138953847, 142902340, 252655748, 16774195, 266962541, 2295892464, 2877685504, 3129995264, 1714356224, 4259250176, 267386880, 0, 0, 261655944, 16734394, 1046699, 62054, 64991, 4080, 0, 0},
		},
		[23] = {
			Animation = "Run Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 0, 0, 0, 0, 559104, 9087877, 9157514, 559243, 2310770432, 3149428720, 2290579327, 2004305023, 2000979087, 1145589744, 1216606208, 860815360, 16300952, 259492795, 4151801992, 4148459383, 4165485687, 267682884, 997508, 15922227, 3596939264, 2291068672, 2864226048, 3148410880, 1717567488, 4026531840, 4026531840, 0, 15951469, 1048024, 1006987, 1005962, 63030, 4061, 3942, 255},
		},
		[24] = {
			Animation = "Run Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 0, 0, 0, 0, 559104, 9087877, 9157514, 559243, 2310770432, 3149428720, 2290579327, 2004305023, 2000979087, 1145589744, 1216606208, 860827392, 16300952, 259492795, 4151801992, 4148459383, 4165485687, 267682884, 997508, 62515, 3597025024, 2380263424, 3101028352, 2828398592, 1668218880, 3723493376, 1727004672, 4278190080, 1001069, 16705672, 16354218, 1018555, 1638, 15, 15, 0},
		},
		[25] = {
			Animation = "Run Down Idle",	
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 1488683008, 2857926656, 2863366144, 0, 0, 0, 34816, 572288, 572293, 558506, 564906, 2863222528, 4002905856, 1212622832, 1921545456, 1092125824, 404965504, 673513216, 860876528, 16051950, 16218606, 259159172, 256346152, 138969368, 142881409, 16728706, 267318323, 1879022064, 3714055936, 3714641920, 1716453376, 4108255232, 267386880, 0, 0, 261750774, 16774621, 1017565, 62566, 64847, 4080, 0, 0},
		},
		[26] = {
			Animation = "Run Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 1488683008, 2857926656, 0, 0, 0, 0, 34816, 572288, 572293, 558506, 2863367776, 2863222678, 4002904054, 1212622719, 1921545343, 1092126848, 404953088, 673513216, 564906, 16027374, 259488238, 4151473284, 4148660264, 2290647320, 8467073, 16728706, 860876800, 1753608192, 3713921024, 1725431808, 3438280704, 1156579328, 4278190080, 0, 586803, 540550, 1048303, 63903, 4095, 15, 0, 0},
		},
		[27] = {
			Animation = "Run Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 1488683008, 2857926656, 0, 0, 0, 0, 34816, 572288, 572293, 558506, 2863366144, 2863222528, 4002904048, 1212622719, 2189980799, 2165868680, 404953088, 673513216, 107519658, 1777635054, 1870100974, 4151473284, 4148660263, 143163668, 8467073, 16728706, 860848128, 1760788480, 4277137408, 4187947008, 4293918720, 4026531840, 0, 0, 1045555, 1005702, 1037789, 36198, 4044, 3908, 255, 0},
		},
		[28] = {
			Animation = "Surf Down Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[29] = {
			Animation = "Surf Up Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[30] = {
			Animation = "Surf Side Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[31] = {
			Animation = "Surf Down Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[32] = {
			Animation = "Surf Up Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[33] = {
			Animation = "Surf Side Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[34] = {
			Animation = "Player Surf Sit Down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 1488683008, 2857926656, 2863366144, 0, 0, 0, 34816, 572288, 572293, 558506, 564906, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2863156992, 3921116928, 1212622832, 1921545456, 1092125824, 404965504, 673509616, 860876800, 16027369, 16218606, 259159172, 256346152, 138969368, 142881409, 252658306, 1045555, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287115008, 3638554192, 3721697616, 3757375232, 4259311616, 4116643840, 267386880, 0, 15894783, 99548557, 93933021, 16732157, 1048031, 62815, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[35] = {
			Animation = "Player Surf Sit Up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3099240448, 2307635200, 3149430784, 0, 0, 0, 0, 559104, 9087883, 9156760, 560059, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2293993216, 2001243904, 2004318192, 2004305136, 2000979072, 1145587840, 4283429104, 922284032, 16300936, 16286839, 259487607, 256145271, 138953847, 142902340, 252703999, 1019747, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1718476544, 3721825872, 2295896400, 2878209792, 3129536512, 1442775040, 4278190080, 0, 16635494, 99118557, 93977992, 16767162, 1018027, 65365, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[36] = {
			Animation = "Player Surf Sit Side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483648, 2776629248, 2862088192, 0, 0, 0, 0, 8945664, 143374421, 2344135338, 3146378986, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3917971456, 1215791104, 2022141952, 2165850112, 672219136, 672219136, 859045888, 876609536, 2297994990, 259474500, 259487607, 259158647, 259487608, 16021320, 16008323, 541832, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 3640659712, 1341192432, 2533357808, 1646255872, 586706688, 4283166720, 16711680, 34952, 62086, 16744840, 262572024, 263950326, 16776943, 63903, 4080, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[37] = {
			Animation = "Pull out Pokeball 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 2286663680, 2864232448, 2863169536, 0, 0, 0, 0, 559104, 9155717, 543658, 9018026, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2860838912, 2608300032, 2222096128, 679956224, 294144000, 288655360, 592383744, 1341652992, 256417434, 259497710, 4146546756, 4101515143, 2223117441, 2286125608, 4042555944, 73347891, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4279824384, 1378414592, 1658843136, 3714510848, 1714356224, 4249812992, 267386880, 0, 93976831, 93978606, 6291353, 1009254, 62054, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[38] = {
			Animation = "Pull out Pokeball 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 2286663680, 2864232448, 2863169536, 0, 0, 0, 0, 559104, 9155717, 543402, 9018026, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2860838912, 2608300032, 2222096128, 679956224, 294144000, 288655360, 592383744, 1341255680, 256417434, 259497710, 4146546756, 4101515143, 2223117441, 2286125608, 4042555944, 94319411, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1713565696, 640217088, 4287623168, 2573660160, 1714356224, 4249812992, 267386880, 0, 110755839, 7339749, 1046933, 1009407, 62054, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[39] = {
			Animation = "Pull out Pokeball 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 2344321024, 2777382912, 2863136768, 0, 0, 0, 0, 8945664, 146520149, 146299562, 9039514, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2609180672, 2222452736, 678592256, 294080256, 2173192192, 2184480768, 591331328, 1156579328, 256417518, 259475524, 4146561671, 4101509508, 2223511569, 2286102545, 15934532, 16731342, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3744399360, 1332674560, 2677010432, 4284936192, 1714356224, 4249812992, 267386880, 0, 77594572, 144701764, 9393566, 1046937, 65535, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[40] = {
			Animation = "Pull out Pokeball 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 1488683008, 2857926656, 2863366144, 4003000320, 0, 0, 0, 8947712, 146520965, 9143722, 564969, 16026094, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 3825205248, 4248829952, 4176478208, 1508900864, 2667577344, 4026531840, 0, 1149759556, 2267489500, 2216197583, 293769097, 293752549, 572850073, 860819455, 1342177007, 16217224, 259160098, 256344337, 138903832, 138949160, 256394034, 16315443, 83136500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3604150676, 3720347456, 2882924544, 3714510848, 4132372480, 4249812992, 267386880, 0, 1498675309, 1503656925, 91184570, 1009373, 62575, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[41] = {
			Animation = "Pull out Pokeball 5",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 3146481664, 2862972928, 2594879488, 4008283904, 2223472384, 0, 0, 559232, 9157560, 571482, 35310, 1001630, 1013576, 0, 0, 0, 0, 0, 0, 0, 0, 1140850688, 3460300800, 4292083712, 2676948992, 1436483584, 2582642688, 4278190080, 2499805184, 678720244, 406947661, 2165844172, 2165843080, 572673950, 859107577, 1157582687, 3717014265, 16197506, 16218129, 8681489, 8684322, 16024627, 1019715, 1499415807, 1502935149, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 0, 0, 0, 0, 0, 0, 0, 3719849215, 2882924544, 3714510848, 1714356224, 4132372480, 4249812992, 267386880, 0, 90635229, 1007034, 1009373, 62054, 62575, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[42] = {
			Animation = "Pull out Fishing Rod side 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4227858432, 4283432960, 267714560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1476395008, 2843738112, 2558001152, 0, 0, 0, 142934016, 2293990741, 3146427050, 3097422250, 2408181486, 16732160, 1045760, 65360, 4085, 248, 139, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2272788480, 2289500160, 293863424, 2165571584, 2165571584, 860835840, 1157555456, 1761187072, 4151592004, 4151801719, 4146538360, 4151801730, 256341122, 256133171, 8669315, 559238, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 859828224, 3716153344, 1224721408, 3439051776, 1867378688, 16711680, 0, 0, 2150, 1048532, 16412637, 16497732, 1046118, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[43] = {
			Animation = "Pull out Fishing Rod side 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 264241152, 256901120, 267714560, 16056320, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 2857893888, 2863235072, 4002969600, 16732160, 1003520, 1045760, 559104, 143178629, 2344322474, 146317033, 9406958, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 2254766080, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 804147200, 3751366656, 3724476416, 1291841536, 1878773504, 4102942720, 268369920, 0, 134, 65533, 1025789, 1031108, 65382, 1000688, 65280, 0},
		},
		[44] = {
			Animation = "Pull out Fishing Rod side 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13565952, 100597760, 1609564160, 4278190080, 4026531840, 0, 0, 0, 0, 0, 0, 5, 95, 1535, 0, 0, 0, 0, 0, 2236940288, 2863290368, 3920275840, 0, 0, 0, 0, 2181, 559291, 9157509, 571550, 0, 0, 0, 0, 0, 0, 0, 0, 24560, 392960, 6287360, 100597760, 4293918720, 2667577344, 2499805184, 4026531840, 4008614008, 1145341816, 2004322423, 662180228, 2005041428, 1954709780, 1211315014, 1216562431, 36745, 63348, 63351, 63271, 63351, 3911, 3908, 132, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290417408, 1650851840, 3639496704, 1335447552, 1727987712, 2414870528, 2380201984, 4293918720, 8, 4095, 64111, 1047485, 1019903, 1019892, 65295, 0},
		},
		[45] = {
			Animation = "Pull out Fishing Rod side 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 2857893888, 2863235072, 4002969600, 0, 0, 0, 559104, 143178629, 2344322474, 146317033, 9406958, 0, 0, 0, 0, 1431683072, 4294963200, 4026531840, 0, 0, 0, 0, 0, 0, 21845, 89522175, 1610608640, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202293504, 2231343445, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2184, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0, 0, 0, 0, 804190719, 3751411456, 3724476416, 1290797056, 1727004672, 2380201984, 4293918720, 0, 134, 65533, 1025789, 1031124, 65382, 3915, 255, 0},
		},
		[46] = {
			Animation = "Pull out Fishing Rod down 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64768, 62720, 62720, 62720, 62720, 62720, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 62720, 143193344, 2344350976, 2777412864, 2864248064, 3917804800, 2222454016, 0, 0, 8945664, 146520149, 146299562, 9039514, 256417518, 259475524, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 678622464, 294080080, 2173192528, 2184482560, 860827392, 888285184, 4287492096, 3858694144, 4146561671, 4101509508, 2223511569, 2286102545, 4042535714, 16728883, 16592895, 991838, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2514419712, 4255055872, 2574188544, 1693450240, 3572498432, 4278190080, 0, 0, 1048409, 1001727, 64991, 63087, 4095, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[47] = {
			Animation = "Pull out Fishing Rod down 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3489660928, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 0, 15, 15, 15, 143130639, 2344321039, 2777382927, 2864185599, 0, 0, 0, 0, 8945664, 146520149, 146299562, 9039514, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3917803765, 2222452981, 678592501, 294080501, 2173192272, 2184480848, 860880469, 888338837, 256417518, 259475524, 4146561671, 4101509508, 2223511569, 2286102545, 4042535714, 16728883, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290233328, 4141871104, 4255055872, 2230321152, 4293918720, 4026531840, 0, 0, 16617471, 16590318, 1017241, 1011711, 62063, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[48] = {
			Animation = "Pull out Fishing Rod down 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 142606336, 2344091648, 2344091648, 0, 0, 0, 0, 0, 557056, 9156608, 9156693, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2777153536, 2863136768, 2860838912, 3916951552, 2222096128, 679956224, 294144000, 2184480768, 8936106, 9038506, 256417434, 259497710, 4146546756, 4101538439, 2223509892, 2286102545, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2186276864, 889188352, 4170047232, 1761537792, 4193869568, 4279193600, 1045760, 62720, 267659298, 268387123, 265879551, 254734301, 16359270, 1048575, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 65360, 3920, 4085, 252, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[49] = {
			Animation = "Pull out Fishing Rod down 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488697344, 2857940992, 2863300608, 4002959104, 0, 0, 0, 559104, 9157509, 9143722, 564969, 16026094, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860848128, 4287487744, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 586803, 16636159, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3593658112, 4008935424, 2583228416, 4285526016, 1714356224, 1833893888, 1609564160, 1342177280, 16589677, 409327, 1046943, 1009407, 62063, 62687, 4095, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 3221225472, 4026531840, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[50] = {
			Animation = "Pull out Fishing Rod up 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 1435216512, 0, 0, 0, 0, 0, 0, 34944, 567992, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2861284224, 3146287104, 2291906800, 3149629424, 2290644863, 2004317263, 2004109384, 1145341064, 572344, 34952, 1018809, 1013947, 16217992, 16009079, 8684615, 8931396, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1149779727, 859107328, 4294832128, 1725820928, 3721920512, 2877620224, 3129933824, 1727004672, 15790984, 5574467, 267269743, 261438934, 16092637, 16079034, 16119979, 16121702, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 0, 0, 0, 0, 0, 0, 0, 16060372, 16056575, 16056320, 16056320, 16056320, 16056320, 16580608, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[51] = {
			Animation = "Pull out Fishing Rod up 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 1435216512, 2861284224, 3146287104, 0, 0, 0, 0, 34944, 567992, 572344, 34952, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2291906800, 3149629424, 2290644863, 2004317263, 2004109384, 1145341064, 1149779727, 859107328, 1018809, 6256827, 100104072, 99895159, 1602520135, 1602766916, 1609626504, 1594834755, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294151936, 3597614848, 2295918592, 2877681664, 3129933824, 1727004672, 4026531840, 0, 4279187055, 4026594925, 4027551112, 4027537594, 4026595499, 4026597222, 4061, 255, 5, 5, 5, 5, 5, 13, 0, 0},
		},
		[52] = {
			Animation = "Pull out Fishing Rod up 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 0, 0, 0, 0, 0, 0, 15, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 2310770432, 3149430528, 4278190080, 1593835520, 1593870336, 1610132357, 100187018, 99649675, 100645784, 16223163, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860876800, 4284694272, 3597635328, 259487880, 256145271, 138953847, 142902340, 268384388, 15987763, 15939327, 16316013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2295889920, 2877681664, 3129995264, 1727987712, 4293918720, 0, 0, 0, 560520, 1005754, 63659, 64870, 63087, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 1619558400, 1488627712, 2830874624, 3095953408, 2310770432, 15, 15, 15, 559119, 9087877, 9157514, 559243, 16300952, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149430528, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 4284739584, 16223163, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 997119, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3596873728, 2295877632, 2877681664, 3129995264, 1714356224, 4249812992, 267386880, 0, 996973, 363912, 1005754, 1046699, 62054, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1615855616, 1709506560, 1592086528, 2576979200, 4003024896, 2576979200, 15, 15, 15, 15, 1365, 24297, 388846, 5893790, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573784064, 1155526656, 4287160064, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 16615679, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3959394048, 2857336832, 1146089472, 3154112512, 4294242304, 4098158592, 268369920, 0, 16318398, 586922, 1045572, 1048507, 1003519, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[54] = {
			Animation = "Acro Bike Wheelie start side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1476395008, 2864185344, 2863300608, 2863560704, 4002904064, 0, 0, 8947712, 9157515, 143362986, 2344114858, 1488953065, 92768750, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 1149794048, 2004976880, 2014385311, 2189497503, 2189643760, 2201288431, 2291095967, 4064501759, 16217156, 16217975, 16197415, 1013623, 1001332, 33864, 1048568, 16426712, 0, 0, 0, 0, 0, 0, 0, 0, 4284481536, 2499149824, 255787008, 4114546688, 334495744, 4278190080, 0, 0, 587201615, 1725956036, 3724492556, 4259263993, 267449105, 4095, 0, 0, 16497496, 107984630, 1879048189, 4098116831, 1057936463, 905200959, 4077982704, 268435200, 0, 0, 0, 6, 15, 15, 0, 0},
		},
		[55] = {
			Animation = "Acro Bike Wheelie full side Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3045064704, 2863366144, 2863310848, 2594891648, 4008277888, 1145603952, 2004359232, 559232, 572344, 8960186, 146507946, 93059566, 5798046, 1013572, 1013623, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2004947264, 2015891776, 1210594544, 2285061376, 2290675440, 2218105334, 587202559, 1725955145, 1012338, 63351, 62583, 2116, 4088, 1048543, 16426712, 16497494, 0, 0, 0, 0, 0, 0, 0, 0, 4092592128, 1408237568, 1056964608, 4026531840, 0, 0, 0, 0, 3714969792, 4175388575, 1342124305, 4278255615, 4026531840, 4026531840, 0, 0, 1029885, 6711039, 117440500, 1866745028, 4092652868, 4083106899, 254873919, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[56] = {
			Animation = "Acro Bike Wheelie full side turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 34952, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2237136896, 2863290368, 2863311488, 3920277112, 4008613752, 1145342071, 2004320644, 662180116, 35771, 560005, 9156746, 5816222, 362377, 63348, 63351, 63271, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2005041428, 1954710351, 1216558320, 2290650880, 4253609712, 4097153526, 1718484991, 3722443849, 3959, 3911, 132, 65535, 1026669, 1031093, 457583, 65528, 0, 0, 0, 0, 0, 0, 0, 0, 4092592128, 1408237568, 1056964608, 4026531840, 0, 0, 0, 0, 2290413760, 4136591263, 4187959569, 4293984255, 4026531840, 4026531840, 0, 0, 4095, 6706831, 117440500, 1866745028, 4092652868, 4082760019, 254873919, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[57] = {
			Animation = "Acro Bike Wheelie full side turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8947712, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1476395008, 2857893888, 2863300608, 2863560704, 4002904064, 1149794048, 2004976640, 2014385152, 9157509, 143361450, 2344127146, 1488953065, 92768750, 16217156, 16217975, 16197415, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2189497344, 2189642224, 2201262576, 2290650880, 3632656112, 2218760694, 1845493759, 3596942409, 1013623, 1001332, 33864, 16777096, 262827512, 263960056, 117141350, 1048541, 0, 0, 0, 0, 0, 0, 0, 0, 4092592128, 1408237568, 1056964608, 4026531840, 0, 0, 0, 0, 4288278720, 1342136223, 1342124305, 4278255615, 4026531840, 4026531840, 0, 0, 248, 6706943, 117440500, 1866745028, 4092652868, 4082760019, 254873919, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[58] = {
			Animation = "Acro Bike Wheelie start down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 1488683008, 2857926656, 2863366144, 2863156992, 4002905856, 1212622832, 34816, 572288, 572293, 558506, 564906, 16027374, 16218606, 259159172, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1921545456, 1092125824, 404965504, 673513456, 860827392, 4294897504, 1869193200, 4294266880, 256346152, 138969368, 142881409, 268386946, 15922227, 117370879, 268015350, 352255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 0, 4095, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[59] = {
			Animation = "Acro Bike Wheelie full down Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 146505728, 1488683008, 0, 0, 0, 0, 0, 34816, 572288, 572293, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2857926656, 2863366144, 2863156992, 4002905856, 1212622832, 1921545456, 1092125824, 404965504, 558506, 564906, 16027374, 16218606, 259159172, 256346152, 138969368, 142881409, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 673513456, 860827392, 4294897504, 1871290352, 4294266880, 4261412608, 1817812736, 2684354304, 268386946, 15922227, 117370879, 268015862, 352255, 16777183, 16356815, 16777215, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[60] = {
			Animation = "Acro Bike Wheelie full down turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 142606336, 2344091648, 2344091648, 0, 0, 0, 0, 0, 557056, 9156608, 9156693, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2777153536, 2864185344, 2860838912, 3916951552, 2222096128, 679956224, 294144000, 2184480768, 8936106, 9038506, 256437994, 259497710, 4146546756, 4101538439, 2223509892, 2286102545, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2186280704, 881364736, 4294897504, 1871290352, 4294336512, 4260994816, 1828716288, 2672820224, 4294191138, 8930099, 117370879, 268015862, 421887, 1048543, 16777167, 16359423, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 16774655, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[61] = {
			Animation = "Acro Bike Wheelie full down turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 557056, 9156608, 1435219968, 0, 0, 0, 0, 0, 2176, 35768, 35768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2862974976, 2863314944, 3937043696, 4008278000, 1149530751, 2267580239, 2215741512, 293745800, 34906, 35306, 1001710, 1013662, 16197448, 16021634, 8685585, 8930088, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 578965503, 859000576, 4294897504, 1871290352, 4294336512, 4261408768, 1828716288, 2683936512, 16774184, 16286771, 117370879, 268015862, 421887, 16359391, 16777167, 1535, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1868562176, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[62] = {
			Animation = "Acro Bike Wheelie start up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 2310770432, 3149430528, 2290579440, 0, 559104, 9087877, 9157514, 559243, 16300952, 16223163, 259487880, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004305136, 2000979072, 1145587840, 1216606448, 3597610752, 2295918592, 2877878272, 3129536512, 256145271, 138953847, 142902340, 252655748, 15922797, 1019272, 1018042, 1046699, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1725890560, 4293918720, 1693450240, 2649751552, 1862270976, 1610612736, 4026531840, 0, 64870, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[63] = {
			Animation = "Acro Bike Wheelie full up Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 1488627712, 2830874624, 3095953408, 2310770432, 3149430528, 2290579440, 2004305136, 559104, 9087877, 9157514, 559243, 16300952, 16223163, 259487880, 256145271, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2000979072, 2000963712, 1145630960, 1216556800, 1725952000, 2295918592, 2877878272, 3129933824, 138953847, 142886007, 252675140, 15874180, 1047910, 1019272, 1018042, 63659, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3153068032, 4293918720, 1844445184, 1862270976, 1610612736, 4026531840, 0, 0, 4027, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[64] = {
			Animation = "Acro Bike Wheelie full up turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 1435216512, 2861284224, 3146287104, 2291906800, 3149629424, 2290644863, 2004317263, 34944, 567992, 572344, 34952, 1018809, 1013947, 16217992, 16009079, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004109384, 2004108424, 1145343759, 1149777920, 1718480896, 2291003392, 2864246784, 3148406528, 8684615, 8930375, 8452164, 992136, 65494, 1038552, 1022091, 65418, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149897472, 4294963200, 1844445184, 1862270976, 1610612736, 4026531840, 0, 0, 4091, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[65] = {
			Animation = "Acro Bike Wheelie full up turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 2343206912, 2344321024, 2290614272, 2612588544, 3146248192, 2289532672, 2004111104, 8945664, 145406037, 146520234, 8947899, 260815240, 259570619, 4151806088, 4098324343, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1950894080, 1950648320, 1150226176, 2285039616, 1845428224, 2374889472, 3096047616, 2835283968, 2223261559, 2286176119, 4042802244, 8620100, 1037926, 579720, 560042, 16616123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3220176896, 4293918720, 1844445184, 1862270976, 1610612736, 4026531840, 0, 0, 16382907, 1048575, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
	},
	
	--Male RUBY/SAPPHIRE
	[5] = {
		[1] = {
			Animation = "Side Left",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x55500000, 0x9EE55000, 0xEEEE5500, 0x966CC800, 0, 0, 0x00000500, 0x00005E50, 0x00005EE5, 0x00559999, 0x059999EE, 0x59999999, 0x6668DD00, 0x66688400, 0x81113400, 0x31811400, 0x32811400, 0x33334000, 0x33440000, 0x84400000, 0x05F99666, 0x00F98866, 0x00F88888, 0x00F8888F, 0x000FF32F, 0x000F4323, 0x0000F833, 0x000FBB8D, 0xF8D40000, 0xAF840000, 0xBF8F0000, 0xFFF00000, 0xFFF00000, 0x88DF0000, 0xFFF00000, 0, 0x00FA4B8F, 0x00FBB8FA, 0x000FBFFB, 0x0000FFFF, 0x00000FFF, 0x00000F4B, 0x000000FF, 0}
		},
		[2] = {
			Animation = "Side Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 2576979200, 4003024896, 2576979200, 0, 0, 0, 0, 1365, 24297, 388846, 5893790, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573784064, 1155526656, 4287160064, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 16615679, 3959376448, 2857352000, 1146093312, 3154112512, 4294242304, 4098158592, 268369920, 0, 77922238, 146535594, 9434180, 1048507, 1003519, 1000527, 65520, 0},
		},
		[3] = {
			Animation = "Side Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 2361978880, 0, 0, 1280, 24144, 351973, 5872025, 367086, 1019080, 3714617088, 1718128384, 286388800, 403784256, 673395712, 590561280, 860876800, 4287160064, 16287453, 16287334, 70193425, 69472641, 4403842, 275250, 1045555, 16615679, 3633293888, 2295642944, 2370830080, 1157623808, 4294242304, 4249743360, 268369920, 0, 78313613, 146492808, 9434328, 1048388, 1003519, 1037535, 65520, 0},
		},
		[4] = {
			Animation = "Walk Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008596992, 0, 0, 0, 1280, 24144, 24293, 5609881, 93952494, 2523711488, 1718148352, 1718125568, 4044436480, 830542848, 847320064, 858996736, 860094464, 1503238553, 100243046, 16353382, 16287880, 16287887, 1045295, 1000227, 63539, 3628072960, 4286840832, 2868178944, 3154071296, 4294201088, 4282707968, 16711680, 0, 1031048, 16403336, 16496783, 1032191, 16646143, 16629759, 1035504, 65280},
		},
		[5] = {
			Animation = "Walk Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008596992, 0, 0, 0, 1280, 24144, 24293, 5609881, 93952494, 2523711488, 1718148352, 1718125568, 2165388288, 830542848, 847320064, 858996736, 860094464, 1503238553, 100243046, 16353382, 16287880, 16287887, 1045295, 1000227, 63539, 3560964096, 2370043904, 4174643200, 4169461760, 4170174208, 4294692608, 256176128, 16711680, 1031128, 16403455, 16498602, 1032123, 16056319, 16011263, 1044480, 0},
		},
		[6] = {
			Animation = "Walk Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 2576979200, 4003024896, 0, 0, 0, 0, 0, 1365, 24297, 388846, 4008285440, 2576981760, 2576977664, 2575954496, 2559066688, 4294128640, 573787904, 1149812480, 5872030, 16357785, 16292249, 70228121, 69503113, 4407295, 275234, 36164, 4287623168, 3959418880, 2857365504, 1146044416, 3154051072, 4294901760, 1155465216, 4293918720, 1038591, 1003454, 4912298, 9172036, 589755, 4095, 15, 0},
		},
		[7] = {
			Animation = "Walk Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 2576979200, 4003024896, 0, 0, 0, 0, 0, 1365, 24297, 388846, 3919156480, 2576981760, 2576977664, 2575954496, 2559066688, 4294128640, 573784064, 1155006464, 5893870, 16357785, 16292249, 70228121, 69503113, 4407295, 16003874, 16484420, 4287492096, 3958697984, 2857346048, 1146075136, 3154083840, 4293918720, 4026531840, 0, 1046783, 1048510, 1045674, 324676, 65467, 65535, 64836, 4095},
		},
		[8] = {
			Animation = "Walk Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 2361978880, 3714617088, 1718128384, 286388800, 403784256, 673395712, 590565120, 860879680, 1019080, 16287453, 16287334, 70193425, 69472641, 4403842, 275250, 1045555, 4287626112, 3632855040, 2286878720, 1157562368, 4294443008, 1263468544, 1297022976, 4293918720, 16599295, 9435277, 16428936, 16498648, 1048575, 4095, 15, 0},
		},
		[9] = {
			Animation = "Walk Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 2361978880, 3714617088, 1718128384, 286388800, 403784256, 673395712, 590561280, 860876800, 1019080, 16287453, 16287334, 70193425, 69472641, 4403842, 16003890, 79688755, 4286897920, 3633313792, 2298130176, 2231090944, 4294963200, 4293918720, 4026531840, 0, 146798847, 9406605, 62600, 65348, 36863, 62644, 62676, 4095},
		},
		[10] = {
			Animation = "Bike Left Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431633920, 2582533376, 4008633808, 2573651072, 1717997008, 0, 80, 1509, 1518, 350617, 5872030, 93952409, 6265190, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717995584, 2400260928, 4061663552, 4062720832, 858993855, 859110335, 2370801648, 4170009263, 1022086, 1017992, 1017992, 65330, 324659, 16428932, 262451192, 263979007, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 4109762560, 264175616, 2512322560, 2884632576, 4278190080, 4294966207, 4278255606, 4294243551, 2296380237, 4294950732, 1503638943, 89193386, 4095, 16777215, 1718026239, 4294964303, 1145359867, 4042081535, 4182031344, 3131752192, 4294963200, 0, 0, 6, 111, 251, 251, 15, 0},
		},
		[11] = {
			Animation = "Bike Up Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 4008613120, 4008267776, 4003045120, 2576981760, 0, 0, 0, 1365, 24302, 368366, 16357870, 16357785, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576977664, 2575954752, 2559066944, 4294198272, 3959418880, 2856902400, 1145597696, 3153653760, 16292249, 71276697, 70551689, 4476927, 1048510, 16614570, 16155716, 1048507, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294242304, 4294901760, 2146435072, 1961885696, 2649751552, 2130706432, 1879048192, 4026531840, 1003519, 65535, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[12] = {
			Animation = "Bike Down Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 4008640256, 2361982720, 0, 1280, 24144, 351973, 5872025, 367086, 16751086, 16747720, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3714617088, 1718125376, 303121216, 673395952, 674450928, 860392944, 2290634496, 1341828960, 16287453, 70813286, 70521121, 256062082, 265565058, 265847859, 16009352, 117092340, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871429616, 4294197248, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 268155126, 282623, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[13] = {
			Animation = "Bike Left Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 4008635997, 2576772296, 1717987549, 0, 5, 94, 94, 21913, 367001, 5872025, 391574, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717987460, 2297499956, 2401337620, 790790964, 858993487, 1127436223, 2370801648, 4175252143, 63880, 63624, 63624, 4083, 20291, 1026808, 16403192, 16498687, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 2499149824, 264175616, 4122935296, 2884632576, 4278190080, 4294966207, 4283432959, 4294245455, 4294967236, 2382348044, 4288656889, 89193386, 4095, 1048575, 1718026239, 4294964479, 1145360312, 4042081528, 1598340095, 3131752192, 4294963200, 0, 0, 6, 111, 251, 251, 15, 0},
		},
		[14] = {
			Animation = "Bike Left Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008598784, 2523711488, 1718148352, 0, 1280, 24144, 24293, 5609881, 93952494, 1503238553, 100243046, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1718125568, 4044436480, 562107392, 579024112, 858999743, 860851135, 2379780080, 4165261999, 16353382, 16287880, 16287887, 1045295, 5194547, 262928451, 4199219192, 4223664127, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 2499149824, 264175616, 4122935296, 2884632576, 4278190080, 4294966207, 4294967295, 4170054735, 3096444868, 4294950668, 1503639033, 89193386, 4095, 268435455, 1718026239, 4294964303, 1145359839, 4042081525, 1598340080, 3131752192, 4294963200, 0, 0, 6, 111, 251, 251, 15, 0},
		},
		[15] = {
			Animation = "Bike Up Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 90066944, 1592677632, 4008634704, 4008613120, 4008286704, 2576980464, 0, 0, 0, 85, 1518, 23022, 1022366, 1022361, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576980208, 2576916276, 2575860788, 4294919232, 4005560064, 2862910960, 1145341680, 3149893376, 1018265, 4454793, 4409480, 279807, 65531, 1038410, 1009732, 65531, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294963200, 4294963200, 2147348480, 2499739648, 2112880640, 2130706432, 1879048192, 4026531840, 65535, 65535, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[16] = {
			Animation = "Bike Up Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83886080, 1582301184, 3998547968, 4008267776, 4002742272, 3919179776, 2577002496, 0, 0, 5, 21854, 388846, 5893870, 261725934, 261724569, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576936960, 2560111616, 2290365440, 4282662912, 3221159936, 2760765440, 1149693952, 3213819904, 260675993, 1140427161, 1128827033, 71630847, 16776174, 265833130, 258491460, 16776123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294901760, 4294901760, 2146435072, 1961885696, 2112880640, 2667577344, 1879048192, 4026531840, 1048575, 1048575, 1040383, 65359, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[17] = {
			Animation = "Bike Down Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847553024, 2582532096, 4008633600, 4008636400, 2295107568, 0, 5, 20574, 365918, 367001, 22942, 1046942, 1046732, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3721824496, 1717995572, 287380532, 578958144, 579024095, 859080927, 2290634224, 1341828960, 1017965, 4425830, 4407570, 275240, 16597816, 16615491, 16011144, 117092340, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871429616, 4294197248, 4261408768, 2649751552, 1827667968, 1862270976, 1610612736, 4026531840, 268155126, 282623, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[18] = {
			Animation = "Bike Down Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 4008701952, 3431985152, 0, 1280, 5267024, 93675237, 93952409, 5873390, 268017390, 267963528, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3599298560, 1720202240, 554972160, 2184396800, 2201280256, 881385216, 2297712384, 1341828960, 260599261, 1133012582, 1128337937, 70461474, 4249040930, 4253565747, 265586824, 117092340, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871429616, 4294197248, 4260364288, 1844445184, 1827667968, 2667577344, 1610612736, 4026531840, 268155126, 282623, 1048543, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[19] = {
			Animation = "Run Left Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 4008635989, 0, 0, 0, 5, 94, 94, 21913, 367001, 2576772296, 1717987549, 1717987460, 2290159924, 2402386196, 791838996, 590558016, 858997760, 5872025, 391574, 63880, 63624, 63624, 4083, 65347, 1031160, 4292673536, 2861498368, 3146711040, 4293918720, 4293918720, 2296315904, 4293918720, 0, 16403336, 16498575, 1032191, 65535, 4095, 3915, 255, 0},
		},
		[20] = {
			Animation = "Run Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 0, 0, 0, 0, 5, 94, 94, 21913, 4008635990, 2576772296, 1717987549, 1717987460, 2290159924, 2402386196, 791838996, 590558016, 367001, 5872025, 391574, 63880, 63624, 63624, 4083, 65347, 858997940, 3713006516, 2380206064, 2298474496, 4170174208, 4294692608, 256176128, 16711680, 1048031, 16428902, 16433032, 1048573, 16056319, 16011263, 1044480, 0},
		},
		[21] = {
			Animation = "Run Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 0, 0, 0, 0, 5, 94, 94, 21913, 4008635990, 2576772296, 1717987549, 1717987460, 2297499956, 2402386196, 791838996, 590558016, 367001, 5872025, 391574, 63880, 63624, 325768, 4964339, 4980547, 859045632, 2379786992, 2298460912, 2298478336, 4294242304, 4282707968, 16711680, 0, 326591, 1025208, 1031048, 1047551, 16646143, 16629759, 1035504, 65280},
		},
		[22] = {
			Animation = "Run Up Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 4008267776, 0, 0, 0, 0, 0, 1365, 24302, 368366, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4294201088, 3952082688, 2856901360, 16357870, 16357785, 16292249, 71276697, 70551689, 16011263, 16775358, 263029930, 1145605104, 3153657600, 2289037312, 4294242304, 4098158592, 268369920, 0, 0, 263750724, 16748475, 1046152, 1003519, 1000527, 65520, 0, 0},
		},
		[23] = {
			Animation = "Run Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 0, 0, 0, 0, 0, 0, 1365, 24302, 4008267776, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4282666752, 3103780864, 368366, 16357870, 16357785, 16292249, 71276697, 70551689, 256770047, 264211438, 2760765440, 1157279488, 3220942592, 2291134464, 4293918720, 4026531840, 4026531840, 0, 16140970, 1000516, 1018811, 63112, 65535, 64989, 63078, 4095},
		},
		[24] = {
			Animation = "Run Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 0, 0, 0, 0, 0, 0, 1365, 24302, 4008267776, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4294956272, 4005100528, 368366, 16357870, 16357785, 16292249, 71276697, 70551689, 16008447, 1048459, 2862903040, 1145368576, 3149459456, 2288975872, 4294901760, 3722379264, 1718550528, 4293918720, 1038410, 16428868, 16433147, 1046664, 4095, 15, 15, 0},
		},
		[25] = {
			Animation = "Run Down Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 4008640256, 2361982720, 3714617088, 1718125376, 303121216, 673395712, 674496256, 860400368, 16751086, 16747720, 16287453, 70813286, 70521121, 4403842, 16724866, 262833203, 3758078960, 2296381184, 2379804672, 1341452288, 4108185600, 268369920, 0, 0, 263979005, 16776584, 1019352, 1003508, 1039695, 65520, 0, 0},
		},
		[26] = {
			Animation = "Run Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 0, 0, 0, 0, 1280, 24144, 351973, 5872025, 4008595456, 4008640496, 2361982911, 3714617279, 1718125376, 303121216, 673395712, 674447360, 367086, 16751086, 16747720, 16287453, 70813286, 70521121, 4403842, 275330, 860876800, 3632852992, 2296315904, 4294443008, 3688824832, 1718550528, 4293918720, 0, 1045555, 589709, 1047215, 64191, 4095, 15, 0, 0},
		},
		[27] = {
			Animation = "Run Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 0, 0, 0, 0, 1280, 24144, 351973, 5872025, 4008595456, 4008640256, 2361982720, 3714617088, 1718125376, 303121216, 673395712, 674447360, 16095726, 268409326, 4227828936, 4227368669, 70813286, 70521121, 4403842, 275330, 860876800, 3640623104, 4205834240, 4222550016, 4293918720, 4026531840, 0, 0, 1045555, 1017997, 64904, 36863, 64957, 63078, 4095, 0},
		},
		[28] = {
			Animation = "Surf Down Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[29] = {
			Animation = "Surf Up Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[30] = {
			Animation = "Surf Side Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[31] = {
			Animation = "Surf Down Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[32] = {
			Animation = "Surf Up Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[33] = {
			Animation = "Surf Side Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[34] = {
			Animation = "Player Surf Sit Down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 0, 0, 0, 1280, 24144, 351973, 5872025, 367086, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4008640256, 2361982720, 3714617088, 1718125376, 303121216, 673395712, 674447360, 860876800, 16751086, 16747720, 16287453, 70813286, 70521121, 4403842, 275330, 1045555, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287123200, 3633293888, 2295642944, 2231369472, 1332146176, 4284936192, 16711680, 0, 16025855, 78313613, 146492808, 9437000, 1009396, 1009407, 65280, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[35] = {
			Animation = "Player Surf Sit Up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 4008267776, 0, 0, 0, 0, 0, 1365, 24302, 368366, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4003045120, 2576981760, 2576977664, 2575926080, 2559066944, 4294128640, 573784064, 1155526656, 16357870, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287160064, 3959392832, 2857352000, 1146093312, 3153653760, 4177461248, 4278190080, 0, 16615679, 78184382, 146535594, 16774212, 1019835, 65423, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[36] = {
			Animation = "Player Surf Sit Side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998547968, 4008038400, 0, 0, 0, 20480, 386304, 388693, 89758105, 1503239918, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1724678144, 1720569856, 1720205312, 286474240, 403783680, 674447360, 859045888, 876609536, 2576980377, 1603888742, 261654118, 260606095, 260606194, 16724722, 16003891, 16315187, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 3741323008, 1341191408, 4285528304, 4287618816, 4294471424, 4283166720, 16711680, 263947336, 4199284109, 4223176072, 264209480, 16748532, 1047215, 64447, 4080, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[37] = {
			Animation = "Pull out Pokeball 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3599695872, 3632852992, 1753804800, 1749230592, 289547264, 573784064, 860815360, 1341652992, 261724654, 268224652, 1334238685, 1132881510, 1128366360, 70418984, 15933986, 79643443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4282970112, 1306062848, 1217392640, 4294963200, 4294242304, 4249743360, 268369920, 0, 78313727, 146472874, 9437115, 1048575, 1003519, 1037535, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[38] = {
			Animation = "Pull out Pokeball 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3599695872, 3632852992, 1753804800, 1749230592, 289547264, 573784064, 860815360, 1341652992, 261724654, 268224652, 1334238685, 1132881510, 1128366360, 70418984, 15933986, 79643443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4282970112, 3716739072, 2291134464, 4294963200, 4294242304, 4249743360, 268369920, 0, 146538495, 9435812, 1047476, 1048575, 1003519, 1037535, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[39] = {
			Animation = "Pull out Pokeball 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 3998220288, 4007985152, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3431923712, 3599298560, 1753804800, 287253504, 2165580800, 2183348224, 591331328, 1157562368, 16174216, 260468189, 260466278, 1139872017, 1128339473, 70395938, 15934532, 16731342, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3750031360, 1330180096, 2677010432, 4294963200, 4294242304, 4249743360, 268369920, 0, 79691724, 146798916, 9393561, 1046937, 1003519, 1037535, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[40] = {
			Animation = "Pull out Pokeball 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 2656567296, 2294870016, 0, 0, 0, 20480, 386384, 5631717, 93952409, 16357068, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 3825205248, 4248829952, 4176478208, 1508900864, 2667577344, 4026531840, 3721850880, 1718022212, 286409948, 293797327, 293752713, 572784357, 592445337, 1342131199, 16287341, 260606054, 260605969, 70513176, 70468136, 4404002, 1045554, 83120116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3565747108, 2291138368, 2286940160, 1157623808, 4294242304, 4249743360, 268369920, 0, 1274579085, 2344570248, 143652056, 1048388, 1003519, 1037535, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[41] = {
			Animation = "Pull out Pokeball 5",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2581954560, 3364654848, 3722276608, 0, 0, 1280, 24149, 351982, 5872025, 1022316, 1017958, 0, 0, 0, 0, 0, 0, 0, 0, 1140850688, 3460300800, 4292083712, 2676948992, 1436483584, 2582642688, 4278190080, 2751463424, 1717987332, 286337101, 2165839052, 2165838728, 572665758, 841105657, 860880719, 4294497531, 16287878, 16287873, 4407073, 4404258, 275250, 72351539, 1274302276, 2344615928, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 0, 0, 0, 0, 0, 0, 0, 3716714495, 2291138304, 2286940160, 1157623808, 4294242304, 4249743360, 268369920, 0, 143653000, 1002888, 1045720, 1048388, 1003519, 1037535, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[42] = {
			Animation = "Pull out Fishing Rod side 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4227858432, 4283432960, 267714560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847225344, 3998613504, 1825046528, 0, 0, 327680, 6180864, 1348396373, 1436129694, 2577002222, 2576980374, 16732160, 1045760, 65360, 4085, 255, 15, 5, 89, 0, 0, 0, 0, 0, 0, 0, 0, 1759313920, 1753481216, 288620544, 2165571584, 2165571584, 860831744, 1341826048, 3640374272, 4187383398, 4186465894, 4169697521, 4169699121, 267595570, 256058163, 16745267, 16498685, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2291134464, 2414870528, 4294951936, 4294689792, 4282707968, 16711680, 0, 0, 262455176, 263978888, 16515071, 1048575, 65535, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[43] = {
			Animation = "Pull out Fishing Rod side 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 264241152, 256901120, 267714560, 16056320, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008596992, 2523711488, 16732160, 1003520, 1045760, 24144, 24293, 257268121, 93952494, 1503238553, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1718148352, 1718125568, 4044436480, 830542848, 847320064, 858996736, 860094464, 3640590336, 100243046, 16353382, 16287880, 16287887, 1045295, 1000227, 63539, 1031048, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2410299392, 2411413504, 4294901760, 4294963200, 4294692608, 4102942720, 268369920, 0, 16403448, 16498680, 1032191, 65535, 1003519, 1000688, 65280, 0},
		},
		[44] = {
			Animation = "Pull out Fishing Rod side 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13565952, 100597760, 1609564160, 4278190080, 4026531840, 0, 0, 0, 0, 0, 0, 5, 95, 1535, 0, 0, 0, 0, 1342177280, 3847573504, 2577327440, 4008635990, 0, 0, 0, 5, 94, 94, 21913, 367001, 0, 0, 0, 0, 0, 0, 0, 0, 24560, 392960, 6287360, 100597760, 4293918720, 3204448256, 3019898880, 4026531840, 2576772296, 1717987549, 1717987460, 2290159924, 2402386196, 791838996, 590558022, 858998015, 5872025, 391574, 63880, 63624, 63624, 4083, 3907, 248, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2381643520, 2382299136, 4171907072, 4290461696, 4294901760, 2414870528, 2380201984, 4293918720, 64445, 1025215, 1031167, 64511, 1003519, 1000692, 65295, 0},
		},
		[45] = {
			Animation = "Pull out Fishing Rod side 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008596736, 2523711488, 0, 0, 1280, 24144, 24293, 5609881, 93952494, 1503238553, 0, 0, 0, 0, 1431683072, 4294963200, 4026531840, 0, 0, 0, 0, 0, 0, 21845, 89522175, 1610608640, 1718148352, 1718125568, 2165388288, 830542848, 847320064, 858996736, 860156928, 3573529413, 100243046, 16353382, 16287880, 16287887, 1045295, 1000227, 63539, 1031048, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0, 0, 0, 0, 2410347519, 2411462400, 2298413056, 4293918720, 4293918720, 2296315904, 4293918720, 0, 16403336, 16496776, 1032072, 65535, 4095, 3915, 255, 0},
		},
		[46] = {
			Animation = "Pull out Fishing Rod down 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64768, 62720, 62720, 62720, 62720, 62720, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 62720, 62720, 1426126080, 3998283008, 4008047872, 3431986432, 3599299840, 0, 20480, 386304, 5631573, 93952409, 5873390, 16305288, 260599261, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1720251648, 287287872, 2165619520, 2184511232, 859803392, 888704768, 4287164416, 2952785920, 260597350, 1123094801, 1111562257, 70461474, 4404002, 16728883, 16310271, 1019354, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3219124224, 4165959680, 1157562368, 4294180864, 3571384320, 4293918720, 0, 0, 1048571, 1003519, 1048031, 63087, 4095, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[47] = {
			Animation = "Pull out Fishing Rod down 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3489660928, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 0, 15, 15, 15, 15, 1426063375, 3998220303, 4007985407, 0, 0, 0, 20480, 386304, 5631573, 93952409, 5873390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3431923957, 3599298805, 1753805045, 287256565, 2165583696, 2183352144, 859831108, 888732596, 16174216, 260468189, 260466278, 1139872017, 1128339473, 70395938, 4404002, 16728883, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287139824, 4170182656, 4249812992, 4110352384, 4293918720, 4026531840, 0, 0, 16027647, 16309674, 1019835, 1048575, 1003519, 1037535, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[48] = {
			Animation = "Pull out Fishing Rod down 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 0, 0, 0, 0, 0, 20480, 386304, 5631573, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3998220288, 4007985152, 4008701952, 3431985152, 3599298560, 1720202240, 554972160, 2184396800, 93952409, 5873390, 268017390, 267963528, 260599261, 1133012582, 1128337937, 70461474, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2201284608, 889188352, 4170178304, 2298130176, 4294205184, 4279193600, 1045760, 62720, 256063522, 268387123, 265879551, 265990024, 16498500, 1048575, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 65360, 3920, 4085, 252, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[49] = {
			Animation = "Pull out Fishing Rod down 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 2361978880, 0, 0, 1280, 24144, 351973, 5872025, 367086, 1019080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3714617088, 1718128384, 286388800, 403784256, 673395712, 590561280, 860876800, 4287459072, 16287453, 16287334, 70193425, 69472641, 4403842, 275250, 1045555, 16308479, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3631050496, 4291071744, 2868441088, 3154112512, 4282707968, 1833824256, 1878982656, 1610612736, 16307853, 16157951, 1047215, 1047487, 1003519, 1037535, 65535, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 1610612736, 3221225472, 4026531840, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[50] = {
			Animation = "Pull out Fishing Rod up 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 6180864, 1441682688, 0, 0, 0, 0, 0, 0, 0, 85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576980304, 4008285440, 4003043664, 2576980464, 2576980464, 2576980004, 2576916260, 2575860544, 1518, 24302, 368366, 1022361, 1022361, 4360601, 4389257, 280712, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294915072, 1145962240, 4287164416, 3958960128, 2857365504, 1146028032, 3154051072, 4293918720, 1045503, 16777172, 262863103, 256245694, 16118954, 16118852, 16121787, 16121855, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 0, 0, 0, 0, 0, 0, 0, 16121156, 16060415, 16056320, 16056320, 16056320, 16056320, 16580608, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[51] = {
			Animation = "Pull out Fishing Rod up 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 6180864, 1441682688, 2576980304, 4008285440, 0, 0, 0, 0, 0, 85, 1518, 24302, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4003043664, 2576980464, 2576980208, 2576916260, 2575860772, 4294914880, 572732416, 1145962240, 368366, 6265241, 100632985, 99809673, 1609713800, 1594110975, 1594835762, 1594865876, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287139584, 3958960128, 2857365504, 1146089472, 3154112512, 4294901760, 4026531840, 0, 4279236863, 4027580350, 4027577514, 4026856516, 4026597307, 4026597375, 64836, 4095, 5, 5, 5, 5, 5, 13, 0, 0},
		},
		[52] = {
			Animation = "Pull out Fishing Rod up 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 0, 0, 0, 0, 0, 0, 15, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 1441071104, 4008005632, 4008613120, 4008267776, 4003045120, 2576981760, 4278190080, 1593835520, 1593835520, 1609565525, 99639022, 99983086, 100243950, 16357785, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576977664, 2575926080, 2559066944, 4294128640, 573784064, 1155530496, 4287160064, 3959394048, 16292249, 71276697, 70551689, 4407295, 16003874, 16776516, 16615679, 16318398, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2857336832, 1146089472, 3154112512, 4294963200, 268369920, 0, 0, 0, 586922, 1045572, 1048507, 1039871, 1009407, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1615855616, 1709506560, 1592086528, 2576979200, 4003024896, 2576979200, 15, 15, 15, 15, 1365, 24297, 388846, 5893790, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2576981760, 2576977664, 2575954752, 2559066944, 4294128640, 573784064, 1155526656, 4287160064, 16357785, 16292249, 71276697, 70551689, 4407295, 275234, 1047876, 16615679, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3959394048, 2857336832, 1146089472, 3154112512, 4294242304, 4098158592, 268369920, 0, 16318398, 586922, 1045572, 1048507, 1003519, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[54] = {
			Animation = "Acro Bike Wheelie start side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008598784, 4008626176, 2523716864, 1718125568, 1280, 24144, 24293, 5609881, 93952494, 1503239918, 100243865, 16352870, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 1718105088, 4044428528, 562115775, 579030975, 859111408, 1157626543, 2374519743, 4165816319, 16287846, 16287880, 1046671, 5194543, 262927411, 4199219188, 4223664120, 268435455, 0, 0, 0, 0, 0, 0, 0, 0, 4284481536, 2499149824, 264175616, 4122935296, 2884632576, 4278190080, 0, 0, 2415918159, 2298478532, 2415902476, 4187993593, 89193386, 4095, 0, 0, 1048575, 107376520, 1879048184, 4098116831, 3205420111, 3052684735, 4222266352, 268435200, 0, 0, 0, 6, 15, 15, 0, 0},
		},
		[55] = {
			Animation = "Acro Bike Wheelie full side Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 1509, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431633920, 2582533376, 4008633808, 4008635520, 2573651408, 1717995584, 1717994304, 2400260416, 1518, 350617, 5872030, 93952494, 6265241, 1018214, 1017990, 1017992, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 4061664240, 4062721264, 858999792, 1146090496, 3632835312, 4107582454, 2415919103, 2298477641, 65528, 327474, 16432963, 262451199, 263979007, 16777215, 1048575, 65416, 0, 0, 0, 0, 0, 0, 0, 0, 4226809856, 1542455296, 3204448256, 4026531840, 0, 0, 0, 0, 2405757120, 4187971487, 1342159530, 4278255615, 4026531840, 4026531840, 0, 0, 248, 6711039, 117440500, 1866745028, 4226870596, 4217324635, 263891647, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[56] = {
			Animation = "Acro Bike Wheelie full side turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1280, 24144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665828352, 4008598784, 4008626176, 2523716864, 1718125568, 1718105088, 4044428288, 24293, 5609881, 93952494, 1503239918, 100243865, 16291430, 16287846, 16287880, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 562118400, 579030000, 859094000, 1157579776, 2290658032, 1305787382, 4294967295, 2405760073, 1048463, 5239599, 262927411, 4199219188, 4223664125, 268435455, 1048575, 65416, 0, 0, 0, 0, 0, 0, 0, 0, 4226809856, 1542455296, 3204448256, 4026531840, 0, 0, 0, 0, 4288278720, 1342136223, 1342159530, 4278255615, 4026531840, 4026531840, 0, 0, 248, 6706943, 117440500, 1866745028, 4226870596, 4216977755, 263891647, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[57] = {
			Animation = "Acro Bike Wheelie full side turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 0, 0, 0, 0, 0, 0, 5, 94, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3847573504, 2577327440, 4008635997, 4008636104, 2576772317, 1717987460, 1717987380, 2297499924, 94, 21913, 367001, 5872030, 391577, 63638, 63624, 63624, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2401337648, 790791152, 858993904, 4098162496, 4253592304, 4282694646, 4294967295, 2298477641, 4095, 20467, 1027060, 16403199, 16498687, 1048575, 1048575, 65535, 0, 0, 0, 0, 0, 0, 0, 0, 4226809856, 1542455296, 3204448256, 4026531840, 0, 0, 0, 0, 2290413760, 4136591263, 4187994794, 4293984255, 4026531840, 4026531840, 0, 0, 4088, 6706831, 117440500, 1866745028, 4226870596, 4216977755, 263891647, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[58] = {
			Animation = "Acro Bike Wheelie start down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 2665807872, 4008595456, 4008640256, 2361982720, 3714617088, 1280, 24144, 351973, 5872025, 367086, 16751086, 16747720, 16287453, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1718125376, 303121216, 673395952, 674450928, 859082496, 4294618976, 1869332464, 4294197248, 70813286, 70521121, 256062082, 265565058, 16270131, 117092351, 268154614, 282623, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 0, 4095, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[59] = {
			Animation = "Acro Bike Wheelie full down Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1431306240, 0, 0, 0, 0, 0, 1280, 24144, 351973, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2665807872, 4008595456, 4008640256, 2361982720, 3714617088, 1718125376, 303121216, 673395952, 5872025, 367086, 16751086, 16747720, 16287453, 70813286, 70521121, 256062082, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 674450928, 859082496, 4294618976, 1871429616, 4294197248, 4261412608, 1817812736, 2684354304, 265565058, 16270131, 117092351, 268155126, 282623, 16777183, 16356815, 16777215, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[60] = {
			Animation = "Acro Bike Wheelie full down turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 3847553024, 0, 0, 0, 0, 0, 5, 20574, 365918, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2582532096, 4008633600, 4008636400, 2295107568, 3721824496, 1717995572, 287380532, 578958144, 367001, 22942, 1046942, 1046732, 1017965, 4425830, 4407570, 265564968, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 579024112, 859000576, 4294618976, 1871429616, 4294197248, 4261408768, 1828716288, 2683936512, 265569080, 16286771, 117092351, 268155126, 282623, 16359391, 16777167, 1535, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1868562176, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[61] = {
			Animation = "Acro Bike Wheelie full down turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1426063360, 0, 0, 0, 0, 0, 1280, 5267024, 93675237, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3998220288, 4007985152, 4008701952, 3431985152, 3599298560, 1720202240, 554972160, 2184400368, 93952409, 5873390, 268017390, 267963528, 260599261, 1133012582, 1128337937, 70461474, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2201259504, 881364736, 4294618976, 1871429616, 4294197248, 4260994816, 1828716288, 2672820224, 138623010, 8930099, 117092351, 268155126, 282623, 1048543, 16777167, 16359423, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 16774655, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[62] = {
			Animation = "Acro Bike Wheelie start up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 98893824, 1592086528, 4008613120, 4008267776, 4003045120, 2576981760, 2576977664, 0, 0, 1365, 24302, 368366, 16357870, 16357785, 16292249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2575954752, 2559066944, 4294198272, 4110372608, 1342168832, 3958960128, 2856906752, 1145630720, 71276697, 70551689, 4476927, 16056143, 16646132, 1019838, 1017002, 1045572, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3154051072, 4293918720, 1961885696, 2649751552, 2130706432, 1879048192, 4026531840, 0, 65467, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[63] = {
			Animation = "Acro Bike Wheelie full up Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5242880, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98893824, 1592086528, 4008613120, 4008267776, 4003045120, 2576981760, 2576977664, 2575954752, 0, 1365, 24302, 368366, 16357870, 16357785, 16292249, 71276697, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2559066944, 4294198512, 4097832176, 1073733376, 4294963200, 3958960128, 2856906752, 1146028032, 70551689, 256135167, 256897871, 16646131, 1048575, 1019838, 1017002, 62532, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3153068032, 4293918720, 2112880640, 2130706432, 1879048192, 4026531840, 0, 0, 4027, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[64] = {
			Animation = "Acro Bike Wheelie full up turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 327680, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 90066944, 1592677632, 4008634704, 4008613120, 4008286704, 2576980464, 2576980208, 2576916276, 0, 85, 1518, 23022, 1022366, 1022361, 1018265, 4454793, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2575860788, 4294919232, 4282643696, 872414976, 4294963200, 4005556224, 2862936064, 1145364224, 4409480, 263472383, 256900916, 16646143, 1048575, 1038587, 1022026, 65348, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149897472, 4294963200, 2112880640, 2130706432, 1879048192, 4026531840, 0, 0, 4091, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[65] = {
			Animation = "Acro Bike Wheelie full up turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 83886080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1582301184, 3998547968, 4008267776, 4002742272, 3919179776, 2577002496, 2576936960, 2560111616, 5, 21854, 388846, 5893870, 261725934, 261724569, 260675993, 1140427161, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290365440, 4282665968, 1140847856, 4294958848, 4294963200, 3213750272, 2760503296, 1157562368, 1128827033, 71630847, 256849151, 16777011, 1048575, 588782, 543402, 16598084, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3220176896, 4293918720, 2112880640, 2130706432, 1879048192, 4026531840, 0, 0, 16382907, 1048575, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
	},
	--Female RUBY/SAPPHIRE
	[6] = {
		[1] = {
			Animation = "Side Left",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3922493440, 3436738560, 0, 0, 0, 559104, 143187341, 2380106188, 148425886, 9407948, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 2254438400, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2184, 4141350912, 4016570368, 2682191872, 4193255424, 1727004672, 2380201984, 4293918720, 0, 143, 65534, 1025785, 1031071, 65382, 3915, 255, 0},
		},
		[2] = {
			Animation = "Side Up",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 2312998656, 0, 0, 0, 559104, 9227661, 9297292, 559245, 16309656, 3721953024, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 4285394944, 16223709, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 1038079, 3597659904, 2295897856, 2877681664, 3129995264, 1714356224, 4249812992, 267386880, 0, 16709229, 16354696, 1005754, 1046699, 62054, 62687, 4080, 0},
		},
		[3] = {
			Animation = "Side Down",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638417408, 3432568832, 3922493440, 3436728064, 0, 0, 0, 559104, 9297293, 9275852, 576670, 16027084, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860815360, 4285394944, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 62515, 1038079, 3607031552, 1761189632, 3714052096, 2573660160, 1714356224, 4249812992, 267386880, 0, 16707437, 16359302, 1045981, 1009305, 62054, 62687, 4080, 0},
		},
		[4] = {
			Animation = "Walk Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3922493440, 0, 0, 0, 0, 559104, 143187341, 2380106188, 148425886, 3436738560, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 9407948, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2254438400, 1878851584, 4277137408, 4188004096, 1610452736, 1720250368, 16711680, 0, 2184, 134, 65533, 1025789, 1031061, 16645990, 1035504, 65280},
		},
		[5] = {
			Animation = "Walk Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3922493440, 0, 0, 0, 0, 559104, 143187341, 2380106188, 148425886, 3436738560, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 9407948, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2254438400, 1725431808, 4251451392, 4175425536, 1509347072, 1727778560, 266203136, 16711680, 2184, 2303, 65518, 1027993, 16759807, 16318310, 1048320, 0},
		},
		[6] = {
			Animation = "Walk Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 0, 0, 0, 0, 559104, 9227661, 9297292, 559245, 2312998656, 3721953024, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 16309656, 16223709, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 4285394944, 3596939264, 2290544384, 2864226048, 3148410880, 1717567488, 4026531840, 0, 1021695, 1021549, 1048024, 1006987, 63882, 63030, 4061, 255},
		},
		[7] = {
			Animation = "Walk Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 0, 0, 0, 0, 559104, 9227661, 9297292, 559245, 2312998656, 3721953024, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 16309656, 16223709, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 4285132800, 3597266944, 2380263424, 3101028352, 2828992512, 1668218880, 3723493376, 4278190080, 1038079, 1001069, 16672904, 16354218, 1018555, 1638, 15, 0},
		},
		[8] = {
			Animation = "Walk Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638417408, 3432568832, 3922493440, 0, 0, 0, 0, 559104, 9297293, 9275852, 576670, 3436728064, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860815360, 16027084, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 16380979, 4177391616, 3756978176, 1872359424, 3630104576, 2583625728, 4293918720, 4026531840, 0, 16381695, 1017965, 64902, 63965, 63129, 3910, 3917, 255},
		},
		[9] = {
			Animation = "Walk Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638417408, 3432568832, 3922493440, 0, 0, 0, 0, 559104, 9297293, 9275852, 576670, 3436728064, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860856064, 16027084, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 62515, 4285505280, 3599298560, 1759444992, 3718184960, 2574188544, 1693450240, 3572498432, 4278190080, 1040271, 1044221, 1022454, 62861, 65433, 4095, 15, 0},
		},
		[10] = {
			Animation = "Bike Left Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3716153344, 3435757568, 4003252224, 3436021632, 1145599872, 0, 0, 34944, 8949208, 148756636, 9276617, 587996, 1013572, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004387696, 2004949056, 2015891776, 1210585408, 2201171103, 2285128095, 1879019504, 3592642287, 1013623, 1012338, 1013623, 62583, 62532, 2116, 16777096, 262827997, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 4109762560, 264175616, 2512322560, 2884632576, 4278190080, 3715103135, 1721761782, 2582967519, 2296380237, 4294950732, 1503638943, 89193386, 4095, 263960941, 1727751830, 4294964841, 1145360379, 4042081535, 4182006768, 3131752192, 4294963200, 0, 0, 6, 111, 251, 251, 15, 0},
		},
		[11] = {
			Animation = "Bike Up Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 2312998656, 3721953024, 0, 0, 559104, 9227661, 9297292, 559245, 16309656, 16223709, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 4285394944, 3597201408, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 1038079, 1046125, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2295656448, 2878275584, 3128950784, 1877999616, 2649751552, 1862270976, 1610612736, 4026531840, 1002888, 63674, 2219, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[12] = {
			Animation = "Bike Down Facing",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3638394880, 3432546304, 3432808448, 3922218752, 3436674816, 0, 34816, 580992, 581005, 559564, 575948, 16026782, 16219596, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1212622832, 1921545456, 1092125824, 404965504, 673509616, 860872448, 2298437376, 1610542944, 259159172, 256346152, 138969368, 142881409, 252658306, 16643123, 16121736, 117370869, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871290352, 4294963200, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 268015862, 1048575, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[13] = {
			Animation = "Bike Left Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2379743232, 3435960320, 2666122368, 3435976824, 1145341816, 0, 0, 2184, 559325, 9297289, 579788, 36749, 63348, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004322423, 662180228, 2005041428, 1954709780, 1211315023, 1216562335, 2290511856, 3592642287, 63351, 63271, 63351, 3911, 3908, 132, 1048568, 16426749, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 2499149824, 264175616, 4122935296, 2884632576, 4278190080, 3715103135, 1718222847, 2577398863, 1073741764, 2382348044, 4288656889, 89193386, 4095, 16497558, 1718597225, 4294964326, 1145360312, 4042081528, 1598315519, 3131752192, 4294963200, 0, 0, 6, 111, 251, 251, 15, 0},
		},
		[14] = {
			Animation = "Bike Left Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3922493440, 3436738560, 1149728768, 0, 0, 559104, 143187341, 2380106188, 148425886, 9407948, 16217156, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2005432064, 2014413824, 2189497344, 2189497584, 858999199, 2202306975, 2255028208, 3592642287, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 268433544, 4205247965, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 4284481536, 2499149824, 264175616, 4122935296, 2884632576, 4278190080, 3597662623, 1778384895, 2676882511, 3096444868, 4294950668, 1503639033, 89193386, 4095, 4223375069, 1874225510, 4294964889, 1145359839, 4042081525, 1598315504, 3131752192, 4294963200, 0, 0, 6, 111, 251, 251, 15, 0},
		},
		[15] = {
			Animation = "Bike Up Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 2378989568, 2380103680, 2290614272, 2648240128, 3716673536, 0, 0, 8945664, 147642589, 148756684, 8947933, 260954504, 259579357, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2289532672, 2004111104, 1950894080, 1149536256, 2285833984, 888143872, 4141809664, 1727987712, 4151806088, 4098324343, 2223261559, 2286437444, 4042491972, 1000243, 16609279, 16279261, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2370764800, 3103719424, 2835283968, 4293918720, 1844445184, 1862270976, 1610612736, 4026531840, 1038472, 1018794, 64187, 65391, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[16] = {
			Animation = "Bike Up Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 3717057664, 3431849344, 3716712448, 2292046064, 3722282992, 0, 0, 34944, 576728, 581080, 34952, 1019353, 1013981, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290644863, 2004317263, 2004109384, 1145341064, 1149779727, 859107328, 4294369024, 3714486016, 16217992, 16009079, 8684615, 8931396, 15790984, 3907, 64879, 65382, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2291003392, 2864246784, 3148808192, 4142923776, 1844445184, 1862270976, 1610612736, 4026531840, 62680, 65419, 65418, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[17] = {
			Animation = "Bike Down Cycle 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 142606336, 2379743232, 2379743232, 3381133312, 3385327616, 2625957888, 3447189504, 0, 557056, 9295872, 9296093, 8953036, 9215180, 256428526, 259513548, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2222096128, 679956224, 294144000, 2184480768, 2186278912, 888680192, 2415877888, 1610542944, 4146546756, 4101538439, 2223509892, 2286102545, 4042532898, 261047091, 265586824, 117370869, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871290352, 4294963200, 4260364288, 1844445184, 1827667968, 2667577344, 1610612736, 4026531840, 268015862, 352255, 1048543, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[18] = {
			Animation = "Bike Down Cycle 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 557056, 9295872, 3717060608, 3435759616, 3435776000, 4003235056, 3436017648, 0, 2176, 36312, 36312, 34972, 35996, 1001673, 1013724, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1149530751, 2267580239, 2215741512, 293745800, 578965263, 859109616, 2290634224, 1610542944, 16197448, 16021634, 8685585, 8930088, 16774184, 167747, 16121848, 117370869, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1871290352, 4294266880, 4261408768, 2649751552, 1827667968, 1862270976, 1610612736, 4026531840, 268015862, 1048575, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[19] = {
			Animation = "Run Left Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2379743232, 3435960320, 2666122368, 0, 0, 0, 0, 2184, 559325, 9297289, 579788, 3435976824, 1145341816, 2004322423, 662180228, 2005041428, 1954709780, 1211315008, 1216562176, 36749, 63348, 63351, 63271, 63351, 3911, 3908, 132, 4284874752, 4002349056, 2576285696, 4293918720, 1727004672, 2296315904, 4293918720, 0, 65496, 1025759, 1031135, 65433, 3942, 3915, 255, 0},
		},
		[20] = {
			Animation = "Run Left Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2379743232, 3435960320, 0, 0, 0, 0, 0, 2184, 559325, 9297289, 2666122368, 3435976824, 1145341816, 2004322423, 1920471428, 2005041428, 1211269396, 2201170752, 579788, 36749, 63348, 62583, 1013618, 1013623, 16009079, 1016904, 1715684502, 3597662614, 2380206064, 2297462784, 2684342016, 4281065216, 256765952, 16711680, 1046660, 16707366, 16359416, 1047005, 16017049, 16011263, 1044480, 0},
		},
		[21] = {
			Animation = "Run Left Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2379743232, 3435960320, 0, 0, 0, 0, 0, 2184, 559325, 9297289, 2666122368, 3435976824, 1145341816, 2004322423, 1920471428, 2005041428, 1211269396, 2201170752, 579788, 36749, 63348, 62583, 1013618, 1013623, 16009079, 1016904, 1749238784, 3710447344, 3640629744, 3758096128, 2532589568, 4282707968, 16711680, 0, 1022093, 65533, 1025757, 1031069, 16643689, 16629759, 1035504, 65280},
		},
		[22] = {
			Animation = "Run Up Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 2312998656, 0, 0, 0, 559104, 9227661, 9297292, 559245, 16309656, 3721953024, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860880640, 3597180656, 16223709, 259487880, 256145271, 138953847, 142902340, 252655748, 16774195, 266962541, 2295892464, 2877685504, 3129995264, 1714356224, 4259250176, 267386880, 0, 0, 261655944, 16734394, 1046699, 62054, 64991, 4080, 0, 0},
		},
		[23] = {
			Animation = "Run Up Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 0, 0, 0, 0, 559104, 9227661, 9297292, 559245, 2312998656, 3721951216, 2290579327, 2004305023, 2000979087, 1145589744, 1216606208, 860872448, 16309656, 259493341, 4151801992, 4148459383, 4165485687, 267682884, 997508, 62515, 3597065984, 2380263424, 3101028352, 2828398592, 1668218880, 3723493376, 1727004672, 4278190080, 1001069, 16705672, 16354218, 1018555, 1638, 15, 15, 0},
		},
		[24] = {
			Animation = "Run Up Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 0, 0, 0, 0, 559104, 9227661, 9297292, 559245, 2312998656, 3721951216, 2290579327, 2004305023, 2000979087, 1145589744, 1216606208, 860815360, 16309656, 259493341, 4151801992, 4148459383, 4165485687, 267682884, 997508, 16643123, 3596939264, 2291068672, 2864226048, 3148410880, 1717567488, 4026531840, 4026531840, 0, 16606829, 1048024, 1006987, 1005962, 63030, 4061, 3942, 255},
		},
		[25] = {
			Animation = "Run Down Idle",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3638394880, 3432546304, 3432808448, 0, 0, 0, 34816, 580992, 581005, 559564, 575948, 3922218752, 3436674816, 1212622832, 1921545456, 1092125824, 404965504, 673513216, 860876528, 16026782, 16219596, 259159172, 256346152, 138969368, 142881409, 16728706, 267318323, 1879022064, 3714055936, 2573791232, 1716453376, 4108255232, 267386880, 0, 0, 261750774, 16774621, 1017497, 62566, 64847, 4080, 0, 0},
		},
		[26] = {
			Animation = "Run Down Cycle 1",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3638394880, 3432546304, 0, 0, 0, 0, 34816, 580992, 581005, 559564, 3432808448, 3922218752, 3436673008, 1212622719, 2189980799, 2165868680, 404953088, 673513216, 107530700, 1777634462, 1870101964, 4151473284, 4148660263, 143163668, 8467073, 16728706, 860848128, 1760788480, 4277137408, 4187947008, 4293918720, 4026531840, 0, 0, 1045555, 1005702, 1021405, 35174, 4044, 3908, 255, 0},
		},
		[27] = {
			Animation = "Run Down Cycle 2",
			Size = "16x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3638394880, 3432546304, 0, 0, 0, 0, 34816, 580992, 581005, 559564, 3432810080, 3922218902, 3436673014, 1212622719, 1921545343, 1092126848, 404953088, 673513216, 575948, 16026782, 259489228, 4151473284, 4148660264, 2290647320, 8467073, 16728706, 860876800, 1753608192, 3713658880, 1721237504, 3438280704, 1156579328, 4278190080, 0, 586803, 540550, 1048303, 63903, 4095, 15, 0, 0},
		},
		[28] = {
			Animation = "Surf Down Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[29] = {
			Animation = "Surf Up Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[30] = {
			Animation = "Surf Side Idle Cycle 1",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[31] = {
			Animation = "Surf Down Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 1459552256, 1431764736, 1431656176, 0, 0, 0, 0, 255, 65381, 16737621, 258299221, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 4127195136, 4278190080, 4127195136, 4294311936, 4294901760, 1431655791, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 4283782485, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 0, 15, 15, 111, 255, 111, 28671, 65535, 4293918720, 4127195136, 4026531840, 0, 0, 0, 0, 0, 1431662591, 1433403391, 4294967295, 4294967286, 4294967136, 4294926336, 4278190080, 0, 4294333781, 4294964821, 4294967295, 1879048191, 117440511, 458751, 255, 0, 4095, 111, 6, 0, 0, 0, 0, 0},
		},
		[32] = {
			Animation = "Surf Up Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 0, 0, 0, 4278190080, 1450139648, 1431764832, 1431656182, 1431655791, 0, 0, 0, 255, 456293, 117400917, 1868911957, 4132787541, 0, 0, 0, 0, 0, 0, 0, 6, 4127195136, 4284481536, 4294901760, 4294963200, 4294926336, 4294311936, 4127195136, 4127195136, 1431655775, 1431655766, 1431655765, 1431655766, 1431655775, 1431655791, 1431655935, 1431662591, 4116010325, 1700091221, 1431655765, 1700091221, 4116010325, 4132787541, 4283782485, 4294333781, 111, 1791, 65535, 1048575, 458751, 28671, 111, 111, 1610612736, 1610612736, 0, 0, 0, 0, 0, 0, 1433403391, 4294967295, 4294967286, 4294964736, 4294901760, 4278190080, 0, 0, 4294964821, 4294967295, 268435455, 7340031, 28671, 255, 0, 0, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[33] = {
			Animation = "Surf Side Idle Cycle 2",
			Size = "32x32",
			Slot = 2,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1717567488, 4294336512, 1718615808, 1431660287, 0, 0, 0, 0, 0, 0, 28671, 7337573, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 1862270976, 1877999616, 1609564160, 1610547200, 1878982656, 1878982656, 4294901760, 1431655766, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655765, 1431655766, 116806997, 1868911957, 1868911957, 4283782485, 4283782485, 4284831061, 4284831061, 4294333781, 0, 0, 0, 6, 6, 111, 111, 111, 4293918720, 4293918720, 4278190080, 4026531840, 0, 0, 0, 0, 1431660287, 1718616063, 4294967295, 4294967295, 4294967295, 4294927872, 4294311936, 1711276032, 4294964837, 4294967295, 1879048191, 117440511, 458751, 1647, 15, 15, 6, 6, 0, 0, 0, 0, 0, 0},
		},
		[34] = {
			Animation = "Player Surf Sit Down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3638394880, 3432546304, 3432808448, 0, 0, 0, 34816, 580992, 581005, 559564, 575948, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3922218752, 3436674816, 1212622832, 1921545456, 1092125824, 404965504, 673509616, 860876800, 16026782, 16219596, 259159172, 256346152, 138969368, 142881409, 252658306, 1045555, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4287160064, 1759506000, 3717503312, 2683633408, 4259311616, 4116643840, 267386880, 0, 16615679, 99548550, 93931997, 16732153, 1048031, 62815, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[35] = {
			Animation = "Player Surf Sit Up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 2307774464, 3721953280, 0, 0, 0, 0, 559104, 9227661, 9296024, 560605, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2296221440, 2001243904, 2004318192, 2004305136, 2000979072, 1145587840, 4283429104, 922284032, 16309640, 16286839, 259487607, 256145271, 138953847, 142902340, 252703999, 1019747, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1718476544, 1717997136, 2295896400, 2877947648, 3129536512, 1442775040, 4278190080, 0, 16635494, 99116646, 93977992, 16750778, 1018027, 65365, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[36] = {
			Animation = "Player Surf Sit Side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2147483648, 3380609024, 2630352896, 0, 0, 0, 0, 8945664, 143513821, 2379783372, 3716991470, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3448209408, 1215791104, 2022141952, 2165850112, 672219136, 672219136, 859045888, 876609536, 2298010828, 259474500, 259487607, 259158647, 259487608, 16021320, 16008323, 541832, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 3640659712, 1341192432, 2533357808, 1646255872, 586706688, 4283166720, 16711680, 34952, 64902, 16747912, 262571080, 263950326, 16776943, 63903, 4080, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[37] = {
			Animation = "Pull out Pokeball 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 2286802944, 3385382912, 2580054016, 0, 0, 0, 0, 559104, 9294989, 543948, 9215180, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2625957888, 3447160832, 2222096128, 679956224, 294144000, 288655360, 592383744, 1341652992, 256428526, 259513548, 4146546756, 4101515143, 2223117441, 2286125608, 4042555944, 73347891, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4282970112, 1574498304, 1839198208, 2573660160, 1714356224, 4249812992, 267386880, 0, 93976831, 93978606, 6291353, 1009254, 62054, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[38] = {
			Animation = "Pull out Pokeball 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 2286802944, 3385382912, 2580054016, 0, 0, 0, 0, 559104, 9294989, 543948, 9215180, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2625957888, 3447160832, 2222096128, 679956224, 294144000, 288655360, 592383744, 1342042112, 256428526, 259513548, 4146546756, 4101515143, 2223117441, 2286125608, 4042555944, 94319411, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1725820928, 651751424, 4288671744, 2573660160, 1714356224, 4249812992, 267386880, 0, 110755839, 7339749, 1046933, 1009407, 62054, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[39] = {
			Animation = "Pull out Pokeball 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 2380103680, 3381493760, 2630352896, 0, 0, 0, 0, 8945664, 148756701, 148413644, 9226734, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3448041472, 2222452736, 678592256, 294080256, 2173192192, 2184480768, 591331328, 1156579328, 256433356, 259475524, 4146561671, 4101509508, 2223511569, 2286102545, 15934532, 16731342, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3755933696, 1332674560, 2677010432, 4284936192, 1714356224, 4249812992, 267386880, 0, 77594572, 144701764, 9393566, 1046937, 65535, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[40] = {
			Animation = "Pull out Pokeball 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 3638394880, 3432546304, 3922493440, 3436769280, 0, 0, 0, 8947712, 148757901, 9275852, 576670, 16027084, 0, 0, 0, 0, 0, 0, 0, 0, 1073741824, 3825205248, 4248829952, 4176478208, 1508900864, 2667577344, 4026531840, 0, 1149759556, 2267489500, 2216197583, 293769097, 293752549, 572850073, 860819455, 1342177007, 16217224, 259160098, 256344337, 138903832, 138949160, 256394034, 16315443, 83136500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3604150676, 1759510336, 3717591040, 2573660160, 4132372480, 4249812992, 267386880, 0, 1498675309, 1503657350, 91183581, 1009305, 62575, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[41] = {
			Animation = "Pull out Pokeball 5",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3717038080, 3435757568, 4003252224, 3436023552, 2223472384, 0, 0, 559232, 9297368, 579740, 36041, 1001692, 1013576, 0, 0, 0, 0, 0, 0, 0, 0, 1140850688, 3460300800, 4292083712, 2676948992, 1436483584, 2582642688, 4278190080, 2499805184, 678720244, 406947661, 2165844172, 2165843080, 572673950, 859107577, 1157582687, 3599573753, 16197506, 16218129, 8681489, 8684322, 16024627, 1019715, 1499415807, 1502935149, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 0, 0, 0, 0, 0, 0, 0, 1759012095, 3717591040, 2573660160, 1714356224, 4132372480, 4249812992, 267386880, 0, 90635654, 1006045, 1009305, 62054, 62575, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[42] = {
			Animation = "Pull out Fishing Rod side 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4227858432, 4283432960, 267714560, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2550136832, 3430940672, 3631742976, 0, 0, 0, 142606336, 2296221144, 3716795596, 3637288681, 2408434892, 16732160, 1045760, 65360, 4085, 248, 141, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2272788480, 2289500160, 293863424, 2165571584, 2165571584, 860835840, 1157555456, 1761187072, 4151592004, 4151801719, 4146538360, 4151801730, 256341122, 256133171, 8669315, 559238, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3628068864, 3716153344, 1224721408, 2583413760, 1867378688, 16711680, 0, 0, 2150, 1048532, 16412637, 16496981, 1046118, 1000527, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[43] = {
			Animation = "Pull out Fishing Rod side 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 264241152, 256901120, 267714560, 16056320, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3922493440, 3436738560, 16732160, 1003520, 1045760, 559104, 143187341, 2380106188, 148425886, 9407948, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202271744, 2254766080, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3756937216, 3751366656, 3724476416, 1509945344, 1878773504, 4102942720, 268369920, 0, 134, 65533, 1025789, 1031061, 65382, 1000688, 65280, 0},
		},
		[44] = {
			Animation = "Pull out Fishing Rod side 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 13565952, 100597760, 1609564160, 4278190080, 4026531840, 0, 0, 0, 0, 0, 0, 5, 95, 1535, 0, 0, 0, 0, 0, 2379743232, 3435960320, 2666122368, 0, 0, 0, 0, 2176, 559325, 9297289, 579788, 0, 0, 0, 0, 0, 0, 0, 0, 24560, 392960, 6287360, 100597760, 4293918720, 2667577344, 2499805184, 4026531840, 3435976824, 1145341816, 2004322423, 662180228, 2005041428, 1954709780, 1211315014, 1216562431, 36749, 63348, 63351, 63271, 63351, 3911, 3908, 132, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290417408, 1835401216, 3639496704, 1603883008, 1727987712, 2414870528, 2380201984, 4293918720, 8, 4095, 64111, 1047481, 1019903, 1019892, 65295, 0},
		},
		[45] = {
			Animation = "Pull out Fishing Rod side 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3922493440, 3436738560, 0, 0, 0, 559104, 143187341, 2380106188, 148425886, 9407948, 0, 0, 0, 0, 1431683072, 4294963200, 4026531840, 0, 0, 0, 0, 0, 0, 21845, 89522175, 1610608640, 1149728768, 2005432064, 2014413824, 2189497344, 2189497344, 858996736, 2202293504, 2231343445, 16217156, 16217975, 16197415, 16217975, 1001332, 1000520, 33864, 2184, 0, 0, 0, 0, 0, 0, 0, 0, 4278190080, 0, 0, 0, 0, 0, 0, 0, 3756980735, 3751411456, 3724476416, 1508900864, 1727004672, 2380201984, 4293918720, 0, 134, 65533, 1025789, 1031061, 65382, 3915, 255, 0},
		},
		[46] = {
			Animation = "Pull out Fishing Rod down 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64768, 62720, 62720, 62720, 62720, 62720, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 62720, 143193344, 2380133632, 3381523712, 2630415616, 3448042752, 2222454016, 0, 0, 8945664, 148756701, 148413644, 9226734, 256433356, 259475524, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 678622464, 294080080, 2173192528, 2184482560, 860827392, 888285184, 4287492096, 3858694144, 4146561671, 4101509508, 2223511569, 2286102545, 4042535714, 16728883, 16592895, 991838, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2514419712, 4255055872, 2574188544, 1693450240, 3572498432, 4278190080, 0, 0, 1048409, 1001727, 64991, 63087, 4095, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[47] = {
			Animation = "Pull out Fishing Rod down 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3489660928, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 0, 15, 15, 15, 143130639, 2380103695, 3381493775, 2630353151, 0, 0, 0, 0, 8945664, 148756701, 148413644, 9226734, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3448041717, 2222452981, 678592501, 294080501, 2173192272, 2184480848, 860880469, 888338837, 256433356, 259475524, 4146561671, 4101509508, 2223511569, 2286102545, 4042535714, 16728883, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290233328, 4141871104, 4255055872, 2230321152, 4293918720, 4026531840, 0, 0, 16617471, 16590318, 1017241, 1011711, 62063, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[48] = {
			Animation = "Pull out Fishing Rod down 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 142606336, 2379743232, 2379743232, 0, 0, 0, 0, 0, 557056, 9295872, 9296093, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3381133312, 3385327616, 2625957888, 3447189504, 2222096128, 679956224, 294144000, 2184480768, 8953036, 9215180, 256428526, 259513548, 4146546756, 4101538439, 2223509892, 2286102545, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2186276864, 889188352, 4170047232, 1761537792, 4193869568, 4279193600, 1045760, 62720, 267659298, 268387123, 265879551, 254734301, 16359270, 1048575, 65520, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62720, 65360, 3920, 4085, 252, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[49] = {
			Animation = "Pull out Fishing Rod down 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638417408, 3432568832, 3922493440, 3436728064, 0, 0, 0, 559104, 9297293, 9275852, 576670, 16027084, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1212645120, 1921460208, 1092121840, 404259968, 404965504, 590672112, 860848128, 4287487744, 16217220, 259160104, 256344344, 138969473, 142881409, 252658482, 586803, 16636159, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3593658112, 4008935424, 2583228416, 4285526016, 1714356224, 1833893888, 1609564160, 1342177280, 16589677, 409327, 1046943, 1009407, 62063, 62687, 4095, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 1342177280, 3221225472, 4026531840, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[50] = {
			Animation = "Pull out Fishing Rod up 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 3717057664, 0, 0, 0, 0, 0, 0, 34944, 576728, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3431849344, 3716712448, 2292046064, 3722282992, 2290644863, 2004317263, 2004109384, 1145341064, 581080, 34952, 1019353, 1013981, 16217992, 16009079, 8684615, 8931396, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1149779727, 859107328, 4294832128, 3597529088, 2295857152, 2877620224, 3129933824, 1727004672, 15790984, 5574467, 267310703, 261477997, 16092552, 16079034, 16119979, 16121702, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 0, 0, 0, 0, 0, 0, 0, 16060372, 16056575, 16056320, 16056320, 16056320, 16056320, 16580608, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[51] = {
			Animation = "Pull out Fishing Rod up 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 3717057664, 3431849344, 3716712448, 0, 0, 0, 0, 34944, 576728, 581080, 34952, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2292046064, 3722282992, 2290644863, 2004317263, 2004109384, 1145341064, 1149779727, 859107328, 1019353, 6256861, 100104072, 99895159, 1602520135, 1602766916, 1609626504, 1594875715, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4294807296, 3597655808, 2295918592, 2877681664, 3129933824, 1727004672, 4026531840, 0, 4279228015, 4026594925, 4027551112, 4027537594, 4026595499, 4026597222, 4061, 255, 5, 5, 5, 5, 5, 13, 0, 0},
		},
		[52] = {
			Animation = "Pull out Fishing Rod up 3",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 4026531840, 0, 0, 0, 0, 0, 0, 15, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 2312998656, 3721953024, 4278190080, 1593835520, 1593870336, 1610141069, 100195724, 99649677, 100654488, 16223709, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860876800, 4285390592, 3597635328, 259487880, 256145271, 138953847, 142902340, 268384388, 16643123, 16635647, 16316013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2295889920, 2877681664, 3129995264, 1727987712, 4293918720, 0, 0, 0, 560520, 1005754, 63659, 64870, 63087, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[53] = {
			Animation = "Pull out Fishing Rod up 4",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4026531840, 3221225472, 1610612736, 1610612736, 1610612736, 0, 0, 0, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 1610612736, 1610612736, 1619558400, 3638347776, 3369981952, 3632824320, 2312998656, 15, 15, 15, 559119, 9227661, 9297292, 559245, 16309656, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3721953024, 2290579440, 2004305136, 2000979072, 1145587840, 1216606448, 860815360, 4285394944, 16223709, 259487880, 256145271, 138953847, 142902340, 252655748, 62515, 1038079, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3597529088, 2295877632, 2877681664, 3129995264, 1714356224, 4249812992, 267386880, 0, 1037933, 363912, 1005754, 1046699, 62054, 62687, 4080, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[54] = {
			Animation = "Acro Bike Wheelie start side",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3432808448, 3922229248, 3436673024, 0, 0, 8947712, 9297293, 143493580, 2379778508, 1491061918, 92769740, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1711276032, 1149794048, 2004976880, 2014385311, 2189497503, 2189643760, 2201288431, 2291095967, 4249051135, 16217156, 16217975, 16197415, 1013623, 1001332, 33864, 1048568, 16426712, 0, 0, 0, 0, 0, 0, 0, 0, 4284481536, 2499149824, 264175616, 4122935296, 2884632576, 4278190080, 0, 0, 3724541007, 1721761732, 2684337932, 4187993593, 89193386, 4095, 0, 0, 16497496, 107984630, 1879048185, 4098116831, 3205420111, 3052684735, 4222266352, 268435200, 0, 0, 0, 6, 15, 15, 0, 0},
		},
		[55] = {
			Animation = "Acro Bike Wheelie full side Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3716153344, 3435757568, 3435776000, 4003235712, 3436017536, 1145603952, 2004359232, 559232, 581080, 8968348, 148736156, 93191369, 5798108, 1013572, 1013623, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2004947264, 2015891776, 1210594544, 2285061376, 2290675440, 2218105334, 3724541951, 1721760841, 1012338, 63351, 62583, 2116, 4088, 1048543, 16426712, 16497494, 0, 0, 0, 0, 0, 0, 0, 0, 4226809856, 1542455296, 3204448256, 4026531840, 0, 0, 0, 0, 2674782400, 4187971487, 1342159530, 4278255615, 4026531840, 4026531840, 0, 0, 1029881, 6711039, 117440500, 1866745028, 4226870596, 4217324635, 263891647, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[56] = {
			Animation = "Acro Bike Wheelie full side turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8947712, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3623878656, 3432513536, 3432808448, 3922229248, 3436673024, 1149794048, 2004976640, 2014385152, 9297293, 143493580, 2379778508, 1491061918, 92769740, 16217156, 16217975, 16197415, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2189497344, 2189642224, 2201262576, 2290650880, 3632656112, 2218760694, 1778384895, 2523200585, 1013623, 1001332, 33864, 16777096, 262827512, 263960056, 117141350, 1048473, 0, 0, 0, 0, 0, 0, 0, 0, 4226809856, 1542455296, 3204448256, 4026531840, 0, 0, 0, 0, 4288278720, 1342136223, 1342159530, 4278255615, 4026531840, 4026531840, 0, 0, 248, 6706943, 117440500, 1866745028, 4226870596, 4216977755, 263891647, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[57] = {
			Animation = "Acro Bike Wheelie full side turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 34952, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2379743232, 3435960320, 3435961472, 2666121336, 3435976568, 1145342071, 2004320644, 662180116, 36317, 560521, 9296009, 5824460, 362381, 63348, 63351, 63271, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1610612736, 4127195136, 1331691520, 2005041428, 1954710351, 1216558320, 2290650880, 4253609712, 4097153526, 1718222847, 2577398857, 3959, 3911, 132, 65535, 1026669, 1031093, 457583, 65528, 0, 0, 0, 0, 0, 0, 0, 0, 4226809856, 1542455296, 3204448256, 4026531840, 0, 0, 0, 0, 2290413760, 4136591263, 4187994794, 4293984255, 4026531840, 4026531840, 0, 0, 4095, 6706831, 117440500, 1866745028, 4226870596, 4216977755, 263891647, 16777200, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[58] = {
			Animation = "Acro Bike Wheelie start down",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3638394880, 3432546304, 3432808448, 3922218752, 3436674816, 1212622832, 34816, 580992, 581005, 5802444, 575948, 16026782, 16219596, 259159172, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1921545456, 1092125824, 404965504, 673513456, 860872448, 4294897504, 1869193200, 4294266880, 256346152, 138969368, 142881409, 268386946, 16643123, 117370879, 268015350, 352255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4293918720, 4260364288, 1844445184, 2632974336, 1862270976, 1610612736, 4026531840, 0, 4095, 4063, 4063, 4047, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[59] = {
			Animation = "Acro Bike Wheelie full down Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8912896, 148733952, 3638394880, 0, 0, 0, 0, 0, 34816, 580992, 581005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3432546304, 3432808448, 3922218752, 3436674816, 1212622832, 1921545456, 1092125824, 404965504, 559564, 575948, 16026782, 16219596, 259159172, 256346152, 138969368, 142881409, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 673513456, 860872448, 4294897504, 1871290352, 4294266880, 4261412608, 1817812736, 2684354304, 268386946, 16643123, 117370879, 268015862, 352255, 16777183, 16356815, 16777215, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[60] = {
			Animation = "Acro Bike Wheelie full down turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 557056, 9295872, 3717060608, 0, 0, 0, 0, 0, 2176, 36312, 36312, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3435759616, 3435776000, 4003235056, 3436017648, 1149530751, 2267580239, 2215741512, 293745800, 34972, 35996, 1001673, 1013724, 16197448, 16021634, 8685585, 8930088, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 578965503, 859000576, 4294897504, 1871290352, 4294336512, 4261408768, 1828716288, 2683936512, 16774184, 16286771, 117370879, 268015862, 421887, 16359391, 16777167, 1535, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1868562176, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 255, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[61] = {
			Animation = "Acro Bike Wheelie full down turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 142606336, 2379743232, 2379743232, 0, 0, 0, 0, 0, 557056, 9295872, 9296093, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3381133312, 3385327616, 2625957888, 3447189504, 2222096128, 679956224, 294144000, 2184480768, 8953036, 9215180, 256428526, 259513548, 4146546756, 4101538439, 2223509892, 2286102545, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2186280704, 881364736, 4294897504, 1871290352, 4294336512, 4260994816, 1828716288, 2672820224, 4294191138, 8930099, 117370879, 268015862, 421887, 1048543, 16777167, 16359423, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1862270976, 1694498816, 4110417920, 1426063360, 1342177280, 0, 0, 0, 16774655, 95, 95, 85, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[62] = {
			Animation = "Acro Bike Wheelie start up",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 2290647040, 3722284800, 2290646784, 2004318192, 0, 559104, 9227661, 9297292, 559240, 16309725, 16222344, 259487607, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004305136, 2000979072, 1145587840, 1216606448, 3597655808, 2295918592, 2877878272, 3129536512, 256145271, 138953847, 142902340, 252655748, 16643693, 1019272, 1018042, 1046699, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1725890560, 4293918720, 1693450240, 2649751552, 1862270976, 1610612736, 4026531840, 0, 64870, 4095, 3919, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[63] = {
			Animation = "Acro Bike Wheelie full up Idle",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8945664, 3638347776, 3369981952, 3632824320, 2312998656, 3721953024, 2290579440, 2004305136, 559104, 9227661, 9297292, 559245, 16309656, 16223709, 259487880, 256145271, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2000979072, 2000963712, 1145630960, 1216601856, 1725952000, 2295918592, 2877878272, 3129933824, 138953847, 142886007, 252675140, 16595076, 1047910, 1019272, 1018042, 63659, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3153068032, 4293918720, 1844445184, 1862270976, 1610612736, 4026531840, 0, 0, 4027, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[64] = {
			Animation = "Acro Bike Wheelie full up turn 1",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 559104, 3717057664, 3431849344, 3716712448, 2292046064, 3722282992, 2290644863, 2004317263, 34944, 576728, 581080, 34952, 1019353, 1013981, 16217992, 16009079, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2004109384, 2004108424, 1145343759, 1149828864, 1718480896, 2291003392, 2864246784, 3148406528, 8684615, 260588615, 267450436, 16646024, 1048534, 1038552, 1022091, 65418, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3149897472, 4294963200, 1844445184, 1862270976, 1610612736, 4026531840, 0, 0, 4091, 4095, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
		[65] = {
			Animation = "Acro Bike Wheelie full up turn 2",
			Size = "32x32",
			Slot = 1,
			Palette = 0,
			RawData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 143130624, 2378989568, 2380103680, 2290614272, 2648240128, 3716673536, 2289532672, 2004111104, 8945664, 147642589, 148756684, 8947933, 260954504, 259579357, 4151806088, 4098324343, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1950894080, 1950648560, 1150226416, 2298470144, 1845489664, 2374889472, 3096047616, 2835283968, 2223261559, 2286176119, 4042802244, 16746564, 1037926, 579720, 560042, 16616123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3220176896, 4293918720, 1844445184, 1862270976, 1610612736, 4026531840, 0, 0, 16382907, 1048575, 4063, 255, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
	},


	--Extra sprites
	[1000] = {
		[1] = {
			Animation = "Fight Symbol",
			Size = "16x16",
			Slot = 3,
			Palette = 0,
			RawData = {0, 0, 65280, 1023744, 16379904, 262078464, 4193255424, 2667577344,0, 0, 1044480, 1023744, 63984, 3999, 249, 15,4193320704, 262143744, 16773120, 268435200, 267452400, 4080, 0, 0,1044729, 1048479, 65520, 1048575, 16773375, 16711680, 0, 0},
		},
	},
	[1001] = {
		[1] = {
			Animation = "Pokeball Symbol",
			Size = "16x16",
			Slot = 3,
			Palette = 0,
			RawData = {0, 4278190080, 4294901760, 3436179456, 3435986688, 3435974640, 4291612656, 1879048176, 0, 255, 65535, 1047756, 16764108, 268225740, 268225791, 268435446, 1879048176, 4288258032, 2576982000, 2577006336, 2577395712, 4294901760, 4278190080, 0, 268435446, 268016127, 268016025, 16751001, 1046937, 65535, 255, 0},
		},
	},
	[1002] = {--Bag
		[1] = {
			Animation = "Bag Symbol",
			Size = "16x16",
			Slot = 3,
			Palette = 0,
			RawData = {4026531840, 4026531840, 4042260480, 4278190080, 4026531840, 0, 0, 3145728, 15, 15, 3855, 255, 15, 0, 0, 768, 3145728, 570425344, 573571072, 858783744, 50331648, 0, 0, 0, 768, 34, 802, 819, 48, 0, 0, 0},
		},
	},
	[1003] = {--Shadow
		[1] = {
			Animation = "Shadow",
			Size = "16x8",
			Slot = 3,
			Palette = 0,
			RawData = {0, 0, 0, 4294963200, 4294967280, 4294967295, 4294967280, 4294963200, 0, 0, 0, 1048575, 268435455, 4294967295, 268435455, 1048575},
		},
	},
	[1004] = {--Hot springs
		[1] = {
			Animation = "Hot Springs",
			Size = "16x16",
			Slot = 2,
			Palette = 14,
			RawData = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x00008888, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x88880000, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888, 0x88888888},
		},
	},
	[1005] = {--Tall grass
		[1] = {
			Animation = "Tall Grass",
			Size = "16x16",
			Slot = 2,
			Palette = 14,
			RawData = {0x3D3DD33D, 0x133D313D, 0x13332133, 0x13321333, 0x23311313, 0x23212323, 0x23213233, 0x33323233, 0xD3D3DDDD, 0x3133D3D3, 0x31132331, 0x23123331, 0x23113132, 0x33223113, 0x33333313, 0x32333311, 0x33133323, 0x3123423D, 0x3134323D, 0x11343333, 0x12331333, 0x2231233D, 0x33113344, 0x33114324, 0xD3231322, 0xD3231132, 0x33432132, 0x31343114, 0x41143113, 0x43133223, 0xD3213222, 0x43223322}
		},
	},
}

function utf8_to_unicode(utf8)
	local byte1 = utf8:byte(1)
	if byte1 < 0x80 then
		return byte1
	elseif byte1 < 0xE0 then
		return ((byte1 - 0xC0) * 0x40) + (utf8:byte(2) - 0x80)
	elseif byte1 < 0xF0 then
		return ((byte1 - 0xE0) * 0x1000) + ((utf8:byte(2) - 0x80) * 0x40) + (utf8:byte(3) - 0x80)
	elseif byte1 < 0xF8 then
		return ((byte1 - 0xF0) * 0x40000) + ((utf8:byte(2) - 0x80) * 0x1000) + ((utf8:byte(3) - 0x80) * 0x40) + (utf8:byte(4) - 0x80)
	end
end

function safeStringChar(value)
	if value == nil then
		return string.char(0)
	end
	local num = tonumber(value) or 0
	num = math.max(0, math.min(255, num))
	return string.char(num)
end

function is_japanese_char(utf8_char)
	local code_point = utf8_to_unicode(utf8_char)
	
	return (code_point >= 0x3040 and code_point <= 0x309F) or  -- Hiragana
		   (code_point >= 0x30A0 and code_point <= 0x30FF) or  -- Katakana
		   (code_point >= 0x4E00 and code_point <= 0x9FFF) or  -- Kanji (Common)
		   (code_point >= 0x3400 and code_point <= 0x4DBF) or  -- Kanji Extensions A
		   (code_point >= 0x20000 and code_point <= 0x2A6DF) or -- Kanji Extensions B
		   (code_point >= 0x2A700 and code_point <= 0x2B73F) or -- Kanji Extensions C
		   (code_point >= 0x2B740 and code_point <= 0x2B81F) or -- Kanji Extensions D
		   (code_point >= 0x2B820 and code_point <= 0x2CEAF) or -- Kanji Extensions E
		   (code_point >= 0x1B000 and code_point <= 0x1B0FF) or -- Kana Extensions
		   (code_point >= 0x3000 and code_point <= 0x303F)	 -- Japanese Punctuation
end

function decimal_to_reverse_hex(decimal)
	-- Step 1: Convert the decimal to a hexadecimal string
	local hex = string.format("%X", decimal)

	-- Step 2: Reverse the hexadecimal string in 2-character groups
	local reversed_hex = ""
	for i = #hex, 1, -2 do
		local pair = hex:sub(i-1, i)
		reversed_hex = reversed_hex .. pair
	end

	return reversed_hex
end

function tableContains(table, element)
	for _, value in ipairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function findKeyByValue(t, value)
	for key, val in pairs(t) do
		if val == value then
			return key
		end
	end
	return nil
end

function utf8sub(str, startChar, endChar)
	local startIndex = utf8.offset(str, startChar)
	local endIndex = utf8.offset(str, endChar + 1) - 1
	if endIndex == nil then endIndex = #str end
	return string.sub(str, startIndex, endIndex)
end

function utf8_cut(s, n)
	local utf8_len = 0
	local i = 1
	while utf8_len < n and i <= #s do
		local c = string.byte(s, i)
		if c >= 0 and c <= 127 then
			i = i + 1
		elseif c >= 192 and c <= 223 then
			i = i + 2
		elseif c >= 224 and c <= 239 then
			i = i + 3
		elseif c >= 240 and c <= 247 then
			i = i + 4
		else
			i = i + 1
		end
		utf8_len = utf8_len + 1
	end
	return s:sub(1, i-1)
end

function sleeper(max_time)
	if Sleep_Timer_Max == 0 then
		Sleep_Timer = 0
		Sleep_Timer_Max = max_time or 60
		return false
	else
		Sleep_Timer = Sleep_Timer + 1
		if Sleep_Timer_Max < Sleep_Timer then
			Sleep_Timer_Max = 0
			return true
		else
			return false
		end
	end
end

function utf8_length(str)
	local length = 0
	for _ in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
		length = length + 1
	end
	return length
end

function findMapName(mapTable, MapID)
	local targetSection = MapID & 0xFF
	local targetMap = (MapID >> 8) & 0xFF
	if DebugMessages.Position then console:log("SEC: " .. targetSection .. " BANK: " .. targetMap) end
	for locationName, locations in pairs(mapTable) do
		for mapName, mapData in pairs(locations) do
			if mapData.Section == targetSection and mapData.Map == targetMap then
				return mapName, locationName
			end
		end
	end
	return nil, nil
end

function LoadObjects()
	local maxObjectOnScreen = 2
	local id = 0
	local player = FindPlayerByID(PlayerID)
	local function ClearArea(addr, length)
		for i=0, length do
			emu:write8(addr + 1*i, 0)
		end
	end
	if player then
		ObjectLoaded = true
		for i=1, maxObjectOnScreen do
			local offset = gAddress[GameID].gObjectEvents + 576 - (36 * i)
			ClearArea(offset, 36)
		end
		local is_player_on_map
		local Table = MapBanks[gAddress[GameID].sGameType]
		local PlayerX, PlayerY, PlayerDirection, PlayerMapID, PlayerVis, _ = player:GetCoords()
		local targetSection = PlayerMapID & 0xFF
		local targetMap = (PlayerMapID >> 8) & 0xFF
		for locationName, locations in pairs(Table) do
			for mapName, mapData in pairs(locations) do
				if mapData.Section == targetSection and mapData.Map == targetMap then
					is_player_on_map = {mapData.Section, mapData.Map}
					break
				end
			end
		end
		for ObjectName, ObjectData in pairs(Objects) do
			for locationName, locations in pairs(Table) do
				for objectLocation, mapData in pairs(locations) do
					if objectLocation == ObjectData.location then
						if is_player_on_map then
							if is_player_on_map[1] == mapData.Section and is_player_on_map[2] == mapData.Map then
								id = id + 1
								if DebugMessages.Objects then console:log("OBJECT LOADED. OBJECT NAME: " .. ObjectName .. " OBJECT LOC: " .. objectLocation .. " OBJ X: " .. mapData.X .. " PLAY X: " .. PlayerX) end
								local npc = FindNPCByName(ObjectName)
								if npc then
									npc:UpdateCoords(mapData.X, mapData.Y, mapData.Section, mapData.Map, mapData.Direction)
								else
									return false
								end
							end
						end
					end
				end
			end
		end
		return true
	end
	return false
end

--simulated console class (for outside of mgba)
ConsoleTest = {}
ConsoleTest.__index = ConsoleTest
function ConsoleTest:new()
	local self = setmetatable({}, SimuSocket)
	return self
end
function ConsoleTest:log(str)
	print(str)
end

--simulated socket class (for outside of mgba)
SimuSocket = {}
SimuSocket.__index = SimuSocket
function SimuSocket:new(socket)
	local self = setmetatable({}, SimuSocket)
	self.Master = socket
	self.Server = nil
	self.Client = nil
	self.Data = nil
	self.test = true
	self.isReady = false
	return self
end

function SimuSocket:bind(port)
	if self.Master then
		self.Server = self.Master.bind("*", port)
		self.Server:settimeout(0)
	end
end

function SimuSocket:listen()
	if self.Server then
	end
end

function SimuSocket:accept()
	if self.Server then
		local client = self.Server:accept()
		if client then
			self.Client = client
			self.Client:settimeout(0)
			print("CLIENT ACCEPTED")
			return self
		else
			return nil
		end
	else
		print("SERVER NOT CREATED YET. BIND MAY HAVE FAILED.")
		return nil
	end
end

function SimuSocket:hasdata()
	if self.isReady == false then
		if self.Data == nil then
			if self.Client then
				local data = self.Client:receive(1)
				if data then
					self.Data = data
					self.isReady = true
					return true
				else
					return false
				end
			else
				print("WHY IS CLIENT HASDATA NIL!!!")
				return false
			end
		else
			self.isReady = true
			return true
		end
	else
		return true
	end
end

function SimuSocket:receive(num)
	if self.isReady == true then
		--check if more data is available
		while true do
			local data = self.Client:receive(1)
			if data then
				self.Data = self.Data .. data
			else
				break
			end
		end
		print("PACKET SENT!!! PACKET: " .. self.Data)
		if #self.Data > num then
			local data = string.sub(self.Data, 1, num)
			self.Data = string.sub(self.Data, num+1, #self.Data)
			return data
		else
			self.isReady = false
			local data = self.Data
			self.Data = nil
			return data
		end
	end
end

function SimuSocket:send(packet2)
	if packet2 then
		if self.Client then
			self.Client:send(packet2)
			print("PACKET TO SEND: " .. packet2)
		else
			print("WHY IS SEND CLIENT NIL!!!")
		end
	end
end

-- Temp Player class
Temp_Player = {}
Temp_Player.__index = Temp_Player
function Temp_Player:new(socket)
	local self = setmetatable({}, Temp_Player)
	self.Timeout = 4000
	self.Socket = socket
	return self
end

function Temp_Player:GetSocket()
	return self.Socket
end

function Temp_Player:GetTimeout()
	return self.Timeout
end

function Temp_Player:ReduceTimeout(mili)
	self.Timeout = self.Timeout - mili
end

-- Player class
Player = {}
Player.__index = Player

function Player:new(id, socket, nickname, GameID, startX, startY, direction, mapID, animation, gender, spritetype, entrance, borderx, bordery, animdata, tile)
	local self = setmetatable({}, Player)
	self.PlayerID = id or FindFirstFreeID()
	self.Nickname = nickname or "FFFF"
	self.TalkingTargetNick = nil
	self.CurrentX = startX or 1
	self.CurrentY = startY or 1
	self.GameID = GameID or "BPR1" --Set to firered 1.0 by default
	self.PreviousX = startX or 1
	self.PreviousY = startY or 1
	self.MapID = mapID or 0
	self.PreviousMapX = 65535
	self.PreviousMapY = 65535
	self.PreviousMapID = prevmapID or self.MapID
	self.Direction = direction or 0
	self.Socket = socket or socket:tcp()
	self.Animation = animation or 0 --sprite
	self.AnimateID = 0 --animation
	self.CurrentAnim = 0
	self.AnimationData = animdata or 0
	self.PreviousAnimateID = 0
	self.AnimationFrame = 0
	self.AnimationCycle = 0
	self.AnimationX = 0
	self.AnimationY = 0
	self.InitAnim = 0
	self.CameraX = -1
	self.CameraY = -1
	self.dx = 0
	self.dy = 0
	self.Entrance = entrance or 0
	self.Accountable = 0
	self.DrawX = 0
	self.DrawY = 0
	self.BorderX = borderx or 0
	self.BorderY = bordery or 0
	self.MapDirection = 0
	self.Gender = gender or 0 --0 = male, 1 = female
	self.SpriteType = spritetype or 0 --feet, bike, surf
	self.Visible = 1
	self.IsInBattle = false
	self.Timeout = ClientTimeout
	self.isAnimating = 0
	self.UpdateCoords = 0
	self.TalkingInitial = 0
	self.TalkingTarget = 0
	self.Connections = {}
	self.CardPos = 0
	self.LoadingCard = false
	self.MatchBanks = false
	self.Task = "None"
	self.CardTalking = 0
	self.SurfFrame = 0
	self.SurfFrameMax = 0
	self.SpriteSize = 128
	self.BattleID = 0
	self.Language = 0
	self.Battle = 0
	self.Levelcap = 0
	self.Pokemoncap = 0
	self.MetaTile = tile or 0
	self.Elevation = 0
	self.TradeVars = {
		--0 means text not started, 1 is first text start, 2 is first text end, 3 is second text start, 4 is second text end
		Text_Stage = 0,
		--0 means no pokemon selected yet, 1 means pokemon select done, 2 is invalid/exit
		Pokemon_Select = 0,
		--0 means trade not started, 1 means trade has started
		Trade_Start = 0,
		--0 means pokemon aren't sent, 1 means all pokemon are sent
		Waiting_Status = 0,
	}
	self.BattleVars = {
		Text_Stage = 0,
		Waiting_Status = 0,
		Battle_Start = 0,
		Buffer_ID = 0,
		Attacker = 0,
		Target = 0,
		Absent_Battler = 0,
		Effect_Battler = 0,
		Transfer_Stage = 0,
		Send_ID = 0,
		Buffer_A = {},
		Buffer_B = {},
		Battleflags = {},
	}
	self.BattleVars2 = {
		Link_Battle_Header_versionLo = 0,
		Link_Battle_Header_versionHi = 0,
		Link_Battle_Header_vsLo = 0,
		Link_Battle_Header_vsHi = 0,
		Link_Battle_Header_Itemdata = {},
		Transfer_Stage = 0,
	}
	self.PokemonData = {
		pokemon_1 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_2 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_3 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_4 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_5 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_6 = {
			rawdata = 0,
			nickname = "",
			species = 0
		}
	}
	return self
end

function Player:Clear()
	self.Animation = 0 --sprite
	self.AnimateID = 0 --animation
	self.CurrentAnim = 0
	self.AnimationData = 0
	self.PreviousAnimateID = 0
	self.AnimationFrame = 0
	self.AnimationCycle = 0
	self.AnimationX = 0
	self.AnimationY = 0
	self.InitAnim = 0
	self.CameraX = -1
	self.CameraY = -1
	self.dx = 0
	self.dy = 0
	self.Accountable = 0
	self.DrawX = 0
	self.DrawY = 0
	self.BorderX = 0
	self.BorderY = 0
	self.MapDirection = 0
	self.Visible = 0
	self.IsInBattle = false
	self.Timeout = ClientTimeout
	self.isAnimating = 0
	self.UpdateCoords = 0
	self.TalkingInitial = 0
	self.TalkingTarget = 0
	self.Connections = {}
	self.CardPos = 0
	self.LoadingCard = false
	self.MatchBanks = false
	self.Task = "None"
	self.CardTalking = 0
	self.SurfFrame = 0
	self.SurfFrameMax = 0
	self.SpriteSize = 128
	self.BattleID = 0
	self.Language = 0
	self.Battle = 0
	self.Levelcap = 0
	self.Pokemoncap = 0
	self.MetaTile = 0
	self.Elevation = 0
	self.TradeVars = {
		--0 means text not started, 1 is first text start, 2 is first text end, 3 is second text start, 4 is second text end
		Text_Stage = 0,
		--0 means no pokemon selected yet, 1 means pokemon select done, 2 is invalid/exit
		Pokemon_Select = 0,
		--0 means trade not started, 1 means trade has started
		Trade_Start = 0,
		--0 means pokemon aren't sent, 1 means all pokemon are sent
		Waiting_Status = 0,
	}
	self.BattleVars = {
		Text_Stage = 0,
		Waiting_Status = 0,
		Battle_Start = 0,
		Buffer_ID = 0,
		Attacker = 0,
		Target = 0,
		Absent_Battler = 0,
		Effect_Battler = 0,
		Transfer_Stage = 0,
		Send_ID = 0,
		Buffer_A = {},
		Buffer_B = {},
		Battleflags = {},
	}
	self.BattleVars2 = {
		Link_Battle_Header_versionLo = 0,
		Link_Battle_Header_versionHi = 0,
		Link_Battle_Header_vsLo = 0,
		Link_Battle_Header_vsHi = 0,
		Link_Battle_Header_Itemdata = {},
		Transfer_Stage = 0,
	}
	self.PokemonData = {
		pokemon_1 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_2 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_3 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_4 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_5 = {
			rawdata = 0,
			nickname = "",
			species = 0
		},
		pokemon_6 = {
			rawdata = 0,
			nickname = "",
			species = 0
		}
	}
end

function Player:GetPosition()
	return self.CurrentX, self.CurrentY, self.Direction, self.MapID, self.Animation, self.Gender, self.SpriteType, self.MapDirection, self.PreviousMapID, self.Entrance, self.PreviousMapX, self.PreviousMapY, self.BorderX, self.BorderY, self.Connections, self.GameID, self.AnimationData
end

function Player:GetMapData()
	return {
		["x"] = self.CurrentX,
		["y"] = self.CurrentY,
		["dir"] = self.Direction,
		["id"] = self.MapID,
		["mapdir"] = self.MapDirection,
		["prev_id"] = self.PreviousMapID,
		["entrance"] = self.Entrance,
		["prev_x"] = self.PreviousMapX,
		["prev_y"] = self.PreviousMapY,
		["border_x"] = self.BorderX,
		["border_y"] = self.BorderY,
		["connection"] = self.Connections,
		["metatile"] = self.MetaTile,
		["elevation"] = PositionData.Elevation,
	}
end

function Player:GetPlayerData()
	return {
		["anim"] = self.Animation,
		["gender"] = self.Gender,
		["sprite"] = self.SpriteType,
		["id"] = self.GameID,
		["anim_data"] = self.AnimationData,
	}
end

function Player:SetMapData(data)
	if data then
		self.CurrentX = data["x"]
		self.CurrentY = data["y"]
		self.Direction = data["dir"]
		self.MapID = data["id"]
	--	self.MapDirection = data["mapdir"]
		self.PreviousMapID = data["prev_id"]
	--	self.Entrance = data["entrance"]
	--	self.PreviousMapX = data["prev_x"]
	--	self.PreviousMapY = data["prev_y"]
		self.BorderX = data["border_x"]
		self.BorderY = data["border_y"]
		self.Connections = data["connection"]
		self.Elevation = data["elevation"]
	end
end

function Player:SetPlayerData(data)
	if data then
		self.Animation = data["anim"]
		self.Gender = data["gender"]
		self.SpriteType = data["sprite"]
		self.GameID = data["id"]
		self.AnimationData = data["anim_data"]
	end
end

function Player:GetMetaTile()
	return self.MetaTile
end

function Player:GetElevation()
	return self.Elevation
end

function Player:SetMetaTile(tile)
	if tile then
		self.MetaTile = tile
	end
end

function Player:SetPosition(x, y, direction, map, animation, gender, spritetype, entrance, borderx, bordery, connections, animdata, tile)
	self.Animation = animation
	self.AnimationData = animdata
	self.Gender = gender
	self.SpriteType = spritetype
	self.Direction = direction
	self.Entrance = entrance
	self.BorderX = borderx
	self.BorderY = bordery
	self.MetaTile = tile or self.MetaTile
	if connections ~= nil then
		self.Connections = connections
	end
	if self.MapID ~= map then
		self.PreviousMapID = self.MapID
		self.MapID = map
		if x then
			self.PreviousMapX = self.PreviousX - x
			self.CurrentX = x
			self.PreviousX = self.CurrentX
		end
		if y then
			self.PreviousMapY = self.PreviousY - y
			self.CurrentY = y
			self.PreviousY = self.CurrentY
		end
		if direction then
			self.MapDirection = self.Direction
			self.Accountable = 1
		end
	else
		self.CurrentX = x
		self.CurrentY = y
		--This is to fix issues with player coordinates randomly switching when changing maps
		if PlayerID == self.PlayerID then
			local UpdateCoordsAddr = 33779256
			local UpdateCoords = emu:read8(UpdateCoordsAddr)
			if self.UpdateCoords ~= UpdateCoords then
				PreviousX, PreviousY = x, y
			end
			self.UpdateCoords = UpdateCoords
		end
	end
end

function Player:DrawPlayer()
	self.AnimateID = HandleSprite(self.PlayerID, self.Animation, self.Gender, self.AnimateID, self.AnimationData, self.MetaTile)
	self.PreviousAnimateID, self.CurrentX, self.CurrentY, self.PreviousX, self.PreviousY, self.AnimationX, self.AnimationY, self.AnimationFrame, self.AnimationCycle, self.dx, self.dy, self.isAnimating, self.SurfFrame, self.SurfFrameMax, self.SpriteSize, self.InitAnim, self.CurrentAnim = AnimatePlayerMovement(self.PlayerID, self.AnimateID, self.PreviousAnimateID, self.Gender, self.CurrentX, self.CurrentY, self.PreviousX, self.PreviousY, self.AnimationX, self.AnimationY, self.AnimationFrame, self.AnimationCycle, self.dx, self.dy, self.isAnimating, self.SurfFrame, self.SurfFrameMax, self.SpriteSize, self.InitAnim, self.CurrentAnim)
	if self.PlayerID == PlayerID then PositionData.isAnimating = self.isAnimating end
	local player = FindPlayerByID(PlayerID)
	if player then
		local PlayerX, PlayerY, PlayerDirection, PlayerMapID, temp1, temp2, temp3, PlayerMapDirection, PlayerPrevMapID, PlayerMapEntrance, PlayerMapPrevX, PlayerMapPrevY, PlayerBorderX, PlayerBorderY, PlayerConnections, PlayerGameID, AnimationData = player:GetPosition()
		self.DrawX, self.DrawY, self.Visible, self.MatchBanks = CalculateRelative(self.GameID, self.CurrentX, self.CurrentY, self.PreviousX, self.PreviousY, self.AnimationX, self.AnimationY, self.MapID, self.PreviousMapID, self.PreviousMapX, self.PreviousMapY, self.BorderX, self.BorderY, PlayerX, PlayerY, PlayerDirection, PlayerMapID, PlayerPrevMapID, PlayerMapDirection, self.MapDirection, self.CameraX, self.CameraY, self.Entrance, PlayerMapEntrance, PlayerMapPrevX, PlayerMapPrevY, PlayerBorderX, PlayerBorderY, self.Accountable, PlayerConnections, PlayerGameID, self.MatchBanks)
		AddRenderPlayer(self.PlayerID, self.GameID, self.DrawX, self.DrawY, self.Animation, self.Gender, self.SpriteType, self.Direction, self.Visible, self.AnimationFrame, self.AnimationCycle, self.SurfFrame, self.AnimationData)
	end
end

function Player:GetID()
	return self.PlayerID
end

function Player:GetNickname()
	return self.Nickname
end

function Player:UpdateNickname(nickname)
	if nickname then
		if self.Nickname == "FFFF" then
			self.Nickname = nickname
			UpdatePlayerConsole()
			console:log("Player " .. self.Nickname .. " has connected")
		else
			self.Nickname = nickname
			UpdatePlayerConsole()
		end
	end
end

function Player:GetGender()
	return self.Gender
end

function Player:GetLanguage()
	return self.Language
end

function Player:GetAnimateID()
	return self.AnimateID
end

function Player:SetPokemon(pokemontable)
	self.PokemonData = pokemontable or self.PokemonData
end

function Player:GetPokemonRaw(pos)
	if pos < 7 and pos > 0 then
		key = "pokemon_" .. pos
		return self.PokemonData[key].rawdata
	end
end

function Player:SetPokemonRaw(pos, data)
	if DebugMessages.Trade or DebugMessages.Battle then console:log("RECEIVING POKEMON DATA: " .. data .. " to slot " .. pos) end
	if pos < 7 and pos > 0 then
		key = "pokemon_" .. pos
		if self.PokemonData[key].rawdata ~= 0 then
			self.PokemonData[key].rawdata = self.PokemonData[key].rawdata .. data
		else
			self.PokemonData[key].rawdata = data
		end
	end
end

function Player:SetCardData(data)
	local CardAddr = gAddress[GameID].gTrainerCard --0x2039624 is the Card Address needed for special 0x2A
	emu:write32(CardAddr + (4*self.CardPos), data)
	local temp = CardAddr + (4*self.CardPos)
	if DebugMessages.Card then console:log("WRITING " .. data .. " at address " .. temp) end
	self.CardPos = self.CardPos + 1
end

function Player:ClearCardData(data)
	local CardAddr = gAddress[GameID].gTrainerCard --0x2039624 is the Card Address needed for special 0x2A
	self.CardPos = 0
	for i=0, 35 do --clear card buffer. 
		emu:write32(CardAddr + (4*i), 0)
	end
end

function Player:IsLoadingCard()
	return self.LoadingCard
end

function Player:SetLoadingCard(IsLoading, CardTalk)
	self.LoadingCard = IsLoading
	self.CardTalking = CardTalk
end

function Player:LoadingCardTalking()
	return self.CardTalking
end

function Player:SetTask(Task)
	self.Task = Task
end

function Player:ClearTask()
	self.Task = "None"
end

function Player:GetTask()
	return self.Task
end

function Player:GetBattle()
	return self.Battle
end

function Player:SetBattle(battle)
	self.Battle = battle or self.Battle
end

function Player:GetLevelCap()
	return self.Levelcap
end

function Player:SetLevelCap(cap)
	self.Levelcap = cap or self.Levelcap
end

function Player:GetPokemonCap()
	return self.Pokemoncap
end

function Player:SetPokemonCap(cap)
	self.Pokemoncap = cap or self.Pokemoncap
end

function Player:GetBattleID()
	return self.BattleID
end

function Player:SetBattleID(id)
	self.BattleID = id or self.BattleID
end

function Player:ClearPokemonRaw()
	for key, pokemon in pairs(self.PokemonData) do
		pokemon.rawdata = 0
	end
end

function Player:GetPokemonDecrypt(pos)
	--console:log("POKEMON DATA START")
	local pokemontable = {}
	if pos < 7 and pos > 0 then
		key = "pokemon_" .. pos
	--	console:log("DATA: " .. self.PokemonData[key].rawdata)
		pokemontable.personality = tonumber(string.sub(self.PokemonData[key].rawdata,1,10))
	--	console:log("PERSONALITY: " .. pokemontable.personality)
		pokemontable.original_trainer = tonumber(string.sub(self.PokemonData[key].rawdata,11,20))
		local Nick_Start = tonumber(string.sub(self.PokemonData[key].rawdata,21,30)) - 1000000000
		local Nick_Middle = tonumber(string.sub(self.PokemonData[key].rawdata,31,40)) - 1000000000
		local Nick_Split = tonumber(string.sub(self.PokemonData[key].rawdata,41,50)) - 1000000000
		local Nick_End = Nick_Split & 65535
		Nick_End = Nick_End
		local actualnickname = decimal_to_reverse_hex(Nick_Start) .. decimal_to_reverse_hex(Nick_Middle) .. decimal_to_reverse_hex(Nick_End)
		
		pokemontable.nickname = {}
		for i = 1, #actualnickname, 2 do
			local byte_str = actualnickname:sub(i, i+1)
			local byte_val = tonumber(byte_str, 16)
			table.insert(pokemontable.nickname, byte_val)
		end
	--	
		pokemontable.language = Nick_Split >> 16
		pokemontable.language = pokemontable.language & 255
		pokemontable.misc = Nick_Split >> 24
		return pokemontable
	end
end

function Player:GetGameID()
	return self.GameID
end

function Player:GetSocket()
	return self.Socket
end

function Player:GetTimeout()
	return self.Timeout
end

function Player:GetCoords()
	return self.CurrentX, self.CurrentY, self.Direction, self.MapID, self.Visible, self.MatchBanks
end

function Player:GetTradeVar()
	return self.TradeVars
end

function Player:GetBattleVar()
	return self.BattleVars
end

function Player:GetBattleVar2()
	return self.BattleVars2
end

function Player:SetTradeVar(trade)
	self.TradeVars = trade or self.TradeVars
end

function Player:SetTradeVar2(text, pkmn, start)
	self.TradeVars.Text_Stage = text or self.TradeVars.Text_Stage
	self.TradeVars.Pokemon_Select = pkmn or self.TradeVars.Pokemon_Select
	self.TradeVars.Trade_Start = start or self.TradeVars.Trade_Start
end

function Player:ReadBattleVar()
	if self.BattleVars.Buffer_ID > 0 then
		--if not sending, copy data
		self.BattleVars.Attacker = emu:read8(gAddress[GameID].gBattlerAttacker)
		self.BattleVars.Target = emu:read8(gAddress[GameID].gBattlerTarget)
		self.BattleVars.Absent_Battler = emu:read8(gAddress[GameID].gAbsentBattlerFlags)
		self.BattleVars.Effect_Battler = emu:read8(gAddress[GameID].gEffectBattler)
		self.BattleVars.Buffer_A = {}
		self.BattleVars.Buffer_B = {}
		self.BattleVars.Battleflags = {}
		
		local buffer_place = 0x200*(self.BattleVars.Buffer_ID-1)
		for i=1, 256 do
			self.BattleVars.Buffer_A[i] = emu:read8(gAddress[GameID].gBattleBufferA+(i-1)+buffer_place)
		end
		for i=1, 256 do
			self.BattleVars.Buffer_B[i] = emu:read8(gAddress[GameID].gBattleBufferB+(i-1)+buffer_place)
		end
	end
	for i=1, 4 do
		self.BattleVars.Battleflags[i] = emu:read8(gAddress[GameID].gBattleControllerExecFlags+i-1)
	end
end

function Player:SetBattleVar(battle)
	self.BattleVars = battle or self.BattleVars
end

function Player:SetBattleVar2(battle)
	self.BattleVars2 = battle or self.BattleVars2
end

function Player:SetBattleVarBuffer(transfer_stage, buffer_a, buffer_b)
	local transfer_stage = transfer_stage or 1
	transfer_stage = transfer_stage + self.BattleVars.Transfer_Stage
	local bufferaplace = 30 + 20*(transfer_stage-1)
	local bufferbplace = 0 + 20*(transfer_stage-1)
	if buffer_a then
		for i=1, 20 do
			self.BattleVars.Buffer_A[i+bufferaplace] = buffer_a[i]
		end
	end
	if buffer_b then
		for i=1, 20 do
			self.BattleVars.Buffer_B[i+bufferbplace] = buffer_b[i]
		end
	end
	self.BattleVars.Transfer_Stage = transfer_stage
end

function Player:ReduceTimeout(mili)
	self.Timeout = self.Timeout - mili
end

function Player:RefreshTimeout()
	self.Timeout = ClientTimeout
end

function Player:GetTalking()
	return self.IsTalkingTarget
end

function Player:SetTalking(Target, nick)
	self.IsTalkingTarget = Target or self.IsTalkingTarget
	local nickname = nick or false
	if nickname then self.TalkingTargetNick = nick end
end

function Player:GetTalkingNickname()
	return self.TalkingTargetNick
end

-- NPC class
NPC = {}
NPC.__index = NPC

function NPC:New(name, location, local_id, graphics_Id, elevation, movement_type, movement_range_x, movement_range_y, trainer_type, script, flag)
	local self = setmetatable({}, NPC)
	self.id = 0
	self.name = name
	self.location = location or "None"
	self.local_id = local_id or 0
	self.graphics_Id = graphics_Id or 0
	self.animation = 0
	self.subsprite = 0
	self.imagesource = 0
	self.imagesourcesize = 0
	self.palette = 0
	self.paletteslot = 0
	self.current_elevation = elevation or 3
	self.previous_elevation = elevation or 3
	self.movement_type = movement_type or 3
	self.movement_range_x = movement_range_x or 0
	self.movement_range_y = movement_range_y or 0
	self.trainer_type = trainer_type or 0
	self.script = script or 0
	self.flag = flag or 0
	self.initial_x = 0
	self.initial_y = 0
	self.current_x = 0
	self.current_y = 0
	self.previous_x = 0
	self.previous_y = 0
	self.section = 0
	self.map = 0
	self.movement_x = 0
	self.movement_y = 0
	self.direction = 0
	self.active = 1
	self.fullmap = 0
	return self
end

function NPC:UpdateCoords(X, Y, Section, Map, Direction)
	self.initial_x = X
	self.initial_y = Y
	self.current_x = X
	self.current_y = Y
	self.previous_x = X
	self.previous_y = Y
	self.section = Section
	self.map = Map
	self.movement_x = 0
	self.movement_y = 0
	self.direction = movement_type_table[Direction]
	if self.direction == 1 then
		self.subsprite = 2
	elseif self.direction == 2 then
		self.subsprite = 2
	elseif self.direction == 3 then
		self.subsprite = 1
	elseif self.direction == 4 then
		self.subsprite = 0
	else
		self.subsprite = 0
	end
	self.fullmap = (self.map << 8) | self.section
end

function NPC:Update(id)
	self.id = id
	local offset = gAddress[GameID].gObjectEvents + 576 - (36 * id)
	emu:write8(offset, self.active)
	emu:write8(offset + 1, 0)
	emu:write16(offset + 2, 0)
	emu:write8(offset + 4, 16)
	emu:write8(offset + 5, self.graphics_Id)
	emu:write8(offset + 6, self.movement_type)
	emu:write8(offset + 7, self.trainer_type)
	emu:write8(offset + 8, self.local_id)
	emu:write8(offset + 9, self.map)
	emu:write8(offset + 10, self.section)
	emu:write8(offset + 11, (self.current_elevation << 4) + self.previous_elevation)
	emu:write16(offset + 12, self.initial_x + 6)
	emu:write16(offset + 14, self.initial_y + 6)
	emu:write16(offset + 16, self.current_x + 6)
	emu:write16(offset + 18, self.current_y + 6)
	emu:write16(offset + 20, self.previous_x + 6)
	emu:write16(offset + 22, self.previous_y + 6)
	emu:write32(offset + 24, 0)
	emu:write32(offset + 28, 0)
	emu:write32(offset + 32, 0)
end

function NPC:GetInfo()
	return self.current_x, self.current_y, self.fullmap, self.direction
end

function NPC:Talking(direction)
	self.direction = direction
	if self.direction == 1 then
		self.subsprite = 2
	elseif self.direction == 2 then
		self.subsprite = 2
	elseif self.direction == 3 then
		self.subsprite = 1
	elseif self.direction == 4 then
		self.subsprite = 0
	else
		self.subsprite = 0
	end
	self:LoadScript()
end

function NPC:LoadScript()
	if self.script > 0 then
		Loadscript(self.script)
	end
end

function NPC:SetupGraphics(tileset)
	local sprite = ROMCARD:read32(gAddress[GameID].gGraphicsInfo + 4*self.graphics_Id)
	self.palette = ROMCARD:read16(sprite + 2)
	local slot = ROMCARD:read8(sprite + 12)
	self.paletteslot = slot & 0xF
	--console:log("slot: " .. slot .. " pslot: " .. self.paletteslot .. " pal: " .. self.palette .. " spr: " .. sprite)
	local image = ROMCARD:read32(sprite + 28)
	--console:log("SUB: " .. self.subsprite .. " img: " .. image)
	self.imagesource = ROMCARD:read32(image + 8*self.subsprite)
	self.imagesourcesize = ROMCARD:read16(image + 5 + 8*self.subsprite)
	local BeginDrawAddr = 100744192
	local ActualAddress = (BeginDrawAddr - (tileset * 1536))
	for i=0, 63 do
		emu:write32(ActualAddress + 4*i, ROMCARD:read32(self.imagesource + 4*i))
	end
	for i=0, 15 do
		local rawimage = gAddress[GameID].sObjectEventSpritePalettes + 8*i
		local palette = ROMCARD:read16(gAddress[GameID].sObjectEventSpritePalettes + 4 + 8*i)
		if palette == self.palette then
			LoadPalette(gAddress[GameID].sObjectEventSpritePalettes + self.palette * 16, gAddress[GameID].gPaletteUnfaded + 512 + self.paletteslot * 16)
			LoadPalette(gAddress[GameID].sObjectEventSpritePalettes + self.palette * 16, gAddress[GameID].gPaletteFaded + 512 + self.paletteslot * 16)
		end
	end
	return self.imagesourcesize, self.paletteslot
end

function NPC:GetID()
	--console:log("X: " .. self.current_x)
	return self.id
end

function NPC:GetName()
	return self.name
end

function NPC:Remove()
	local offset = gAddress[GameID].gObjectEvents + 576 - (36 * self.id)
	for i=0, 7 do
		emu:write32(offset + 4*i, 0)
	end
	self.id = 0
end

function FindNPCByName(name)
	for _, npc in pairs(NPCs) do
		if npc:GetName() == name then
			return npc
		end
	end
	return nil -- return nil if no player is found with the given ID
end

function FindNPCByID(id)
	for _, npc in pairs(NPCs) do
		if npc:GetID() == id then
			return npc
		end
	end
	return nil -- return nil if no player is found with the given ID
end

function ApplyPalette(palette, slot)
	local Palette_unfaded = gAddress[GameID].gPaletteUnfaded + 0x200 --0x200 is objects
	local Palette_faded = gAddress[GameID].gPaletteFaded + 0x200 --0x200 is objects
	local isLoaded = true
	if palette and slot then
		--check if applied
		for i=1, #palette do
			local adr = Palette_unfaded+(slot*32)+((i-1)*2)
			if emu:read16(adr) ~= palette[i] then
				isLoaded = false
			end
		end
		--if not in menu and not applied
		if IsInMenu() == 0 and isLoaded == false then
			for i=1,#palette do
				local adr = Palette_unfaded+(slot*32)+((i-1)*2)
				emu:write16(adr, palette[i])
			end
			for i=1,#palette do
				local adr = Palette_faded+(slot*32)+((i-1)*2)
				emu:write16(adr, palette[i])
			end
		end
	end
end

function FindPlayerByID(id)
	for _, player in pairs(players) do
		if player:GetID() == id then
			return player
		end
	end
	return nil -- return nil if no player is found with the given ID
end

function FindPlayerByNickname(nickname)
	for _, player in pairs(players) do
		if player.Nickname == nickname then
			return player
		end
	end
	return nil -- return nil if no player is found with the given ID
end

function FindFirstFreeID()
	-- Create a table to track which IDs are taken
	if #players == 0 then
		return 1
	end
	local takenIDs = {}
	for _, player in ipairs(players) do
		takenIDs[player:GetID()] = true
	end
	
	-- Find the first ID that is not taken
	local id = 1
	while takenIDs[id] do
		id = id + 1
	end
	return id
end

function AddTempPlayer(socket)
	local player = Temp_Player:new(socket)
	table.insert(temp_players, player)
end

function RemoveTempPlayer(removeplayer)
	if temp_players then
		for i, player in ipairs(players) do
			if player == removeplayer then
				table.remove(temp_players, i)
			end
		end
	end
end


function AddPlayer(id, socket, nickname, GameID, startX, startY, direction, mapID, animation, gender, spritetype, entrance, borderx, bordery, connections, animdata, tile)
	local player = Player:new(id, socket, nickname, GameID, startX, startY, direction, mapID, animation, gender, spritetype, entrance, borderx, bordery, animdata, tile)
	table.insert(players, player)
	--UpdatePlayerConsole()
	--if id ~= PlayerID then
	--	console:log("Player " .. nickname .. " has successfully connected")
	--end
	if DebugMessages.Network or DebugMessages.Nickname then console:log("Player " .. id .. " connected, getting nickname") end
end

-- Remove a player by ID
function RemovePlayer(id)
	for i, player in ipairs(players) do
		if player:GetID() == id then
			if id ~= PlayerID then
				console:log("Player " .. player:GetNickname() .. " has been disconnected")
			end
			table.remove(players, i)
			UpdatePlayerConsole()
		end
	end
end

-- Clear a player's variables
function ClearPlayer(id)
	for i, player in ipairs(players) do
		if player:GetID() == id then
			player:Clear()
		end
	end
end

function LoadPalette(source, dest)
	for i=0, 7 do
		emu:write32(dest, ROMCARD:read32(source))
	end
end

function GetGameVersion()
	GameCode = emu:getGameCode()
	ConsoleForText:moveCursor(0,1)
	local romadr = 0x80000BC
	if (GameCode == "AGB-BPRE") or (GameCode == "AGB-ZBDM") then
		local GameVersion = emu:read16(romadr)
		if GameVersion == 0x6800 then
			ConsoleForText:print("Pokemon Firered 1.0 detected. Script enabled.")
			EnableScript = true
			GameID = "BPR1"
			Language = "en"
			LanguageTableType = "Western"
		elseif GameVersion == 0x6701 then
			ConsoleForText:print("Pokemon Firered 1.1 detected. Script enabled.")
			EnableScript = true
			GameID = "BPR2"
			Language = "en"
			LanguageTableType = "Western"
		else
			ConsoleForText:print("Unknown version of Pokemon Firered detected. Defaulting to 1.0. Script enabled.")
			EnableScript = true
			GameID = "BPR1"
			Language = "en"
			LanguageTableType = "Western"
		end
		
	elseif (GameCode == "AGB-BPGE") then
		local GameVersion = emu:read16(romadr)
		if GameVersion == 0x8100 then
			ConsoleForText:print("Pokemon Leafgreen 1.0 detected. Script enabled.")
			EnableScript = true
			GameID = "BPG1"
			Language = "en"
			LanguageTableType = "Western"
		elseif GameVersion == 0x8001 then
			ConsoleForText:print("Pokemon Leafgreen 1.1 detected. Script enabled.")
			EnableScript = true
			GameID = "BPG2"
			Language = "en"
			LanguageTableType = "Western"
		else
			ConsoleForText:print("Unknown version of Pokemon Leafgreen detected. Defaulting to 1.0. Script enabled.")
			EnableScript = true
			GameID = "BPG1"
			Language = "en"
			LanguageTableType = "Western"
		end
		
	elseif (GameCode == "AGB-BPRJ") then
		ConsoleForText:print("Pokemon Firered Japanese detected. Script enabled.")
		EnableScript = true
		GameID = "BPRJ"
		Language = "jp"
		LanguageTableType = "Japanese"
			
	elseif (GameCode == "AGB-BPGJ") then
		ConsoleForText:print("Pokemon Leafgreen Japanese detected. Script enabled.")
		EnableScript = true
		GameID = "BPGJ"
		Language = "jp"
		LanguageTableType = "Japanese"

	elseif (GameCode == "AGB-BPRF") then
		ConsoleForText:print("Pokemon Firered French detected. Script enabled.")
		EnableScript = true
		GameID = "BPRF"
		Language = "fr"
		LanguageTableType = "Western"

	elseif (GameCode == "AGB-BPGF") then
		ConsoleForText:print("Pokemon Leafgreen French detected. Script enabled.")
		EnableScript = true
		GameID = "BPGF"
		Language = "fr"
		LanguageTableType = "Western"

	elseif (GameCode == "AGB-BPRD") then
		ConsoleForText:print("Pokemon Firered German detected. Script enabled.")
		EnableScript = true
		GameID = "BPRD"
		Language = "de"
		LanguageTableType = "Western"

	elseif (GameCode == "AGB-BPGD") then
		ConsoleForText:print("Pokemon Leafgreen German detected. Script enabled.")
		EnableScript = true
		GameID = "BPGD"
		Language = "de"
		LanguageTableType = "Western"

	elseif (GameCode == "AGB-BPRS") then
		ConsoleForText:print("Pokemon Firered Spanish detected. Script enabled.")
		EnableScript = true
		GameID = "BPRS"
		Language = "es"
		LanguageTableType = "Western"

	elseif (GameCode == "AGB-BPGS") then
		ConsoleForText:print("Pokemon Leafgreen Spanish detected. Script enabled.")
		EnableScript = true
		GameID = "BPGS"
		Language = "es"
		LanguageTableType = "Western"

	elseif (GameCode == "AGB-BPRI") then
		ConsoleForText:print("Pokemon Firered Italian detected. Script enabled.")
		EnableScript = true
		GameID = "BPRI"
		Language = "it"
		LanguageTableType = "Western"

	elseif (GameCode == "AGB-BPGI") then
		ConsoleForText:print("Pokemon Leafgreen Italian detected. Script enabled.")
		EnableScript = true
		GameID = "BPGI"
		Language = "it"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-BPEE") then
		ConsoleForText:print("Pokemon Emerald detected. Script enabled.")
		EnableScript = true
		GameID = "BPEE"
		Language = "en"
		LanguageTableType = "Western"
			
	elseif (GameCode == "AGB-BPEJ") then
		ConsoleForText:print("Pokemon Emerald Japanese detected. Script enabled.")
		EnableScript = true
		GameID = "BPEJ"
		Language = "jp"
		LanguageTableType = "Japanese"
	
	elseif (GameCode == "AGB-BPEF") then
		ConsoleForText:print("Pokemon Emerald French detected. Script enabled.")
		EnableScript = true
		GameID = "BPEF"
		Language = "fr"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-BPED") then
		ConsoleForText:print("Pokemon Emerald German detected. Script enabled.")
		EnableScript = true
		GameID = "BPED"
		Language = "de"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-BPES") then
		ConsoleForText:print("Pokemon Emerald Spanish detected. Script enabled.")
		EnableScript = true
		GameID = "BPES"
		Language = "es"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-BPEI") then
		ConsoleForText:print("Pokemon Emerald Italian detected. Script enabled.")
		EnableScript = true
		GameID = "BPEI"
		Language = "it"
		LanguageTableType = "Western"
			
	elseif (GameCode == "AGB-AXVE") then
		local GameVersion = emu:read16(romadr)
		if GameVersion == 0x4100 then
			ConsoleForText:print("Pokemon Ruby 1.0 detected. Script enabled.")
			EnableScript = true
			GameID = "AXV1"
			Language = "en"
			LanguageTableType = "Western"
		elseif GameVersion == 0x4001 or GameVersion == 0x3f02 then
			ConsoleForText:print("Pokemon Ruby 1.1/1.2 detected. Script enabled.")
			EnableScript = true
			GameID = "AXV2"
			Language = "en"
			LanguageTableType = "Western"
		else
			ConsoleForText:print("Unknown version of Pokemon Ruby detected. Defaulting to 1.0. Script enabled.")
			EnableScript = true
			GameID = "AXV1"
			Language = "en"
			LanguageTableType = "Western"
		end
		
	elseif (GameCode == "AGB-AXPE") then
		local GameVersion = emu:read16(romadr)
		if GameVersion == 0x5500 then
			ConsoleForText:print("Pokemon Sapphire 1.0 detected. Script enabled.")
			EnableScript = true
			GameID = "AXP1"
			Language = "en"
			LanguageTableType = "Western"
		elseif GameVersion == 0x5401 or GameVersion == 0x5302 then
			ConsoleForText:print("Pokemon Sapphire 1.1/1.2 detected. Script enabled.")
			EnableScript = true
			GameID = "AXP2"
			Language = "en"
			LanguageTableType = "Western"
		else
			ConsoleForText:print("Unknown version of Pokemon Sapphire detected. Defaulting to 1.0. Script enabled.")
			EnableScript = true
			GameID = "AXP1"
			Language = "en"
			LanguageTableType = "Western"
		end
	elseif (GameCode == "AGB-AXVJ") then
		ConsoleForText:print("Pokemon Ruby Japanese detected. Script enabled.")
		EnableScript = true
		GameID = "AXVJ"
		Language = "jp"
		LanguageTableType = "Japanese"
		
	elseif (GameCode == "AGB-AXPJ") then
		ConsoleForText:print("Pokemon Sapphire Japanese detected. Script enabled.")
		EnableScript = true
		GameID = "AXPJ"
		Language = "jp"
		LanguageTableType = "Japanese"
	
	elseif (GameCode == "AGB-AXVF") then
		ConsoleForText:print("Pokemon Ruby French 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXVF"
		Language = "fr"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-AXVD") then
		ConsoleForText:print("Pokemon Ruby German 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXVD"
		Language = "de"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-AXVS") then
		ConsoleForText:print("Pokemon Ruby Spanish 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXVS"
		Language = "es"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-AXVI") then
		ConsoleForText:print("Pokemon Ruby Italian 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXVI"
		Language = "it"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-AXPF") then
		ConsoleForText:print("Pokemon Sapphire French 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXPF"
		Language = "fr"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-AXPD") then
		ConsoleForText:print("Pokemon Sapphire German 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXPD"
		Language = "de"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-AXPS") then
		ConsoleForText:print("Pokemon Sapphire Spanish 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXPS"
		Language = "es"
		LanguageTableType = "Western"
	
	elseif (GameCode == "AGB-AXPI") then
		ConsoleForText:print("Pokemon Sapphire Italian 1.0/1.1 detected. Script enabled.")
		EnableScript = true
		GameID = "AXPI"
		Language = "it"
		LanguageTableType = "Western"
	else
		ConsoleForText:print("Unknown game. Script disabled.")
		if DebugMessages.GameType then console:log("GAME ID: " .. GameCode) end
		EnableScript = false
	end
	if EnableScript then
		if Nickname == "" then 
			Nickname = GetInGameName() --Get in game name instead
		elseif string.len(Nickname) > 40 or utf8_length(Nickname) > 10 then
			Nickname = utf8_cut(Nickname, 10)
		end
		if DebugMessages.GetMenus then console:log("Debug Menus started. Press R on the menu to record it. Start with field/overworld.") end
		ConsoleForText:moveCursor(0,2)
		ConsoleForText:print("Nickname is now " .. Nickname)
	end
end

--To fit everything in 1 file, I must unfortunately clog this file with a lot of sprite data. Luckily, this does not lag the game. It is just hard to read.
--Also, if you are looking at this, then I am sorry. Truly	  -TheHunterManX
function createChars(id, AnimationTable, Animation)
	--0 = Tile 190, 1 = Tile 185, etc...
	--Tile number 190 = Player1
	--Tile number 185 = Player2
	--Tile number 180 = Player3
	--Tile number 175 = Player4
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
	
	--Start address. 100745216 = 06014000 = 184th tile. can safely use 32. 182 = bank 480
	--CHANGE 100746752 = 190th tile = bank 560
	--100744192 = 182 tile = bank 480
	--CHANGE AGAIN BACK TO 182 due to ruby/sapphire
	--Because the actual data doesn't start until 06013850, we will skip 50 hexbytes, or 80 decibytes
	local BeginDrawAddr = 0x6013C00
	local player = FindPlayerByID(id)
	local ActualAddress = (BeginDrawAddr - (id * 0x600))
	local spritetable = spriteData[AnimationTable]
	if spritetable then
		local dataBlock = spritetable[Animation]
		if DebugMessages.Render then console:log("SPRITE FOUND FOR GAME: " .. gAddress[GameID].sGameType) end
		local address = ActualAddress
		if dataBlock.Slot then
			if dataBlock.Slot < 4 then
				address = address + 512 * (dataBlock.Slot - 1)
			elseif dataBlock.Slot < 7 then
				address = address + 256 * (dataBlock.Slot - 3)
			end
		end
		if dataBlock.RawData then
			for _, value in ipairs(dataBlock.RawData) do
				emu:write32(address, value)
				address = address + 4
			end
		end
	end
end

function WriteBuffers(BufferOffset, BufferVar, Language, size)
	local language = Language or 0
	local offset = BufferOffset
	local maxsize = size or 15 --max size of buffer before it returns
	maxsize = BufferOffset + maxsize
	for i = 1, #BufferVar do
		if language == 1 and LanguageTableType == "Western" and BufferVar[i] < 250 then --Japanese for English
			local tempvar = findKeyByValue(LanguageTable["Japanese"], BufferVar[i])
			if tempvar then
				local LanguageTableTemp = LanguageTable["JapaneseWestern"][tempvar]
				if not LanguageTableTemp then
					LanguageTableTemp = LanguageTable["Japanese"][tempvar]
					if LanguageTableTemp then
						LanguageTableTemp = findKeyByValue(LanguageTable["Western"], LanguageTableTemp)
					end
				end
				if LanguageTableTemp then
					for j=1, string.len(LanguageTableTemp) do
						local LanguageTableTemp2 = LanguageTable["Western"][string.sub(LanguageTableTemp,j,j)]
						if not LanguageTableTemp2 then LanguageTableTemp2 = 0 end
						emu:write8(offset, LanguageTableTemp2)
						offset = offset + 1
						if offset >= maxsize then emu:write8(offset, 255) return end
					end
				end
			else
				emu:write8(offset, BufferVar[i])
				offset = offset + 1
				if offset >= maxsize then emu:write8(offset, 255) return end
			end
		else
			emu:write8(offset, BufferVar[i])
			offset = offset + 1
			if offset >= maxsize then emu:write8(offset, 255) return end
		end
		emu:write8(offset, 255)
	end
end
	
function WriteRom(RomOffset, BufferVar, Language, size)
	local language = Language or 0
	local offset = RomOffset
	local maxsize = size or 15 --max size of buffer before it returns
	maxsize = RomOffset + maxsize
	for i = 1, #BufferVar do
		if language == 1 and LanguageTableType == "Western" and BufferVar[i] < 250 then --Japanese for English
			local tempvar = findKeyByValue(LanguageTable["Japanese"], BufferVar[i])
			if tempvar then
				local LanguageTableTemp = LanguageTable["JapaneseWestern"][tempvar]
				if not LanguageTableTemp then
					LanguageTableTemp = LanguageTable["Japanese"][tempvar]
					if LanguageTableTemp then
						LanguageTableTemp = findKeyByValue(LanguageTable["Western"], LanguageTableTemp)
					end
				end
				if LanguageTableTemp then
					for j=1, string.len(LanguageTableTemp) do
						local LanguageTableTemp2 = LanguageTable["Western"][string.sub(LanguageTableTemp,j,j)]
						if not LanguageTableTemp2 then LanguageTableTemp2 = 0 end
						ROMCARD:write8(offset, LanguageTableTemp2)
						offset = offset + 1
						if offset >= maxsize then ROMCARD:write8(offset, 255) return end
					end
				end
			else
				ROMCARD:write8(offset, BufferVar[i])
				offset = offset + 1
				if offset >= maxsize then ROMCARD:write8(offset, 255) return end
			end
		else
			ROMCARD:write8(offset, BufferVar[i])
			offset = offset + 1
			if offset >= maxsize then ROMCARD:write8(offset, 255) return end
		end
		ROMCARD:write8(offset, 255)
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


function GetPosition()
	local MapConnections = 0
	local u32 MapConnectionTable = 0
	
	local SpriteSettings = {
	-- Order is: Foot, Throwing Pokemon, Fishing, Bike Normal/Mach, Surfing, Bike ACRO (if exists)
		BPR1 = {
			{Values = {138018976}, Gender = 0, SpriteType = 0},
			{Values = {138019632}, Gender = 0, SpriteType = 3},
			{Values = {138025792}, Gender = 0, SpriteType = 4},
			{Values = {138019136}, Gender = 0, SpriteType = 1},
			{Values = {138019440}, Gender = 0, SpriteType = 2},
			{Values = {138019208}, Gender = 1, SpriteType = 0},
			{Values = {138019704}, Gender = 1, SpriteType = 3},
			{Values = {138025888}, Gender = 1, SpriteType = 4},
			{Values = {138019368}, Gender = 1, SpriteType = 1},
			{Values = {138019536}, Gender = 1, SpriteType = 2},
		},
		BPG1 = {
			{Values = {138018944}, Gender = 0, SpriteType = 0},
			{Values = {138019600}, Gender = 0, SpriteType = 3},
			{Values = {138025760}, Gender = 0, SpriteType = 4},
			{Values = {138019104}, Gender = 0, SpriteType = 1},
			{Values = {138019408}, Gender = 0, SpriteType = 2},
			{Values = {138019176}, Gender = 1, SpriteType = 0},
			{Values = {138019672}, Gender = 1, SpriteType = 3},
			{Values = {138025856}, Gender = 1, SpriteType = 4},
			{Values = {138019336}, Gender = 1, SpriteType = 1},
			{Values = {138019504}, Gender = 1, SpriteType = 2},
		},
		BPR2 = {
			{Values = {138019088}, Gender = 0, SpriteType = 0},
			{Values = {138019744}, Gender = 0, SpriteType = 3},
			{Values = {138025904}, Gender = 0, SpriteType = 4},
			{Values = {138019248}, Gender = 0, SpriteType = 1},
			{Values = {138019552}, Gender = 0, SpriteType = 2},
			{Values = {138019320}, Gender = 1, SpriteType = 0},
			{Values = {138019816}, Gender = 1, SpriteType = 3},
			{Values = {138026000}, Gender = 1, SpriteType = 4},
			{Values = {138019480}, Gender = 1, SpriteType = 1},
			{Values = {138019648}, Gender = 1, SpriteType = 2},
		},
		BPG2 = {
			{Values = {138019056}, Gender = 0, SpriteType = 0},
			{Values = {138019712}, Gender = 0, SpriteType = 3},
			{Values = {138025872}, Gender = 0, SpriteType = 4},
			{Values = {138019216}, Gender = 0, SpriteType = 1},
			{Values = {138019520}, Gender = 0, SpriteType = 2},
			{Values = {138019288}, Gender = 1, SpriteType = 0},
			{Values = {138019784}, Gender = 1, SpriteType = 3},
			{Values = {138025968}, Gender = 1, SpriteType = 4},
			{Values = {138019448}, Gender = 1, SpriteType = 1},
			{Values = {138019616}, Gender = 1, SpriteType = 2},
		},
		BPRJ = {
			{Values = {137773352}, Gender = 0, SpriteType = 0},
			{Values = {137774008}, Gender = 0, SpriteType = 3},
			{Values = {137780168}, Gender = 0, SpriteType = 4},
			{Values = {137773512}, Gender = 0, SpriteType = 1},
			{Values = {137773816}, Gender = 0, SpriteType = 2},
			{Values = {137773584}, Gender = 1, SpriteType = 0},
			{Values = {137774080}, Gender = 1, SpriteType = 3},
			{Values = {137780264}, Gender = 1, SpriteType = 4},
			{Values = {137773744}, Gender = 1, SpriteType = 1},
			{Values = {137773912}, Gender = 1, SpriteType = 2},
		},
		BPGJ = {
			{Values = {137773320}, Gender = 0, SpriteType = 0},
			{Values = {137773976}, Gender = 0, SpriteType = 3},
			{Values = {137780136}, Gender = 0, SpriteType = 4},
			{Values = {137773480}, Gender = 0, SpriteType = 1},
			{Values = {137773784}, Gender = 0, SpriteType = 2},
			{Values = {137773552}, Gender = 1, SpriteType = 0},
			{Values = {137774048}, Gender = 1, SpriteType = 3},
			{Values = {137780232}, Gender = 1, SpriteType = 4},
			{Values = {137773712}, Gender = 1, SpriteType = 1},
			{Values = {137773880}, Gender = 1, SpriteType = 2},
		},
		BPRF = {
			{Values = {137995408}, Gender = 0, SpriteType = 0},
			{Values = {137996064}, Gender = 0, SpriteType = 3},
			{Values = {138002224}, Gender = 0, SpriteType = 4},
			{Values = {137995568}, Gender = 0, SpriteType = 1},
			{Values = {137995872}, Gender = 0, SpriteType = 2},
			{Values = {137995640}, Gender = 1, SpriteType = 0},
			{Values = {137996136}, Gender = 1, SpriteType = 3},
			{Values = {138002320}, Gender = 1, SpriteType = 4},
			{Values = {137995800}, Gender = 1, SpriteType = 1},
			{Values = {137995968}, Gender = 1, SpriteType = 2},
		},
		BPGF = {
			{Values = {137995376}, Gender = 0, SpriteType = 0},
			{Values = {137996032}, Gender = 0, SpriteType = 3},
			{Values = {138002192}, Gender = 0, SpriteType = 4},
			{Values = {137995536}, Gender = 0, SpriteType = 1},
			{Values = {137995840}, Gender = 0, SpriteType = 2},
			{Values = {137995608}, Gender = 1, SpriteType = 0},
			{Values = {137996104}, Gender = 1, SpriteType = 3},
			{Values = {138002288}, Gender = 1, SpriteType = 4},
			{Values = {137995768}, Gender = 1, SpriteType = 1},
			{Values = {137995936}, Gender = 1, SpriteType = 2},
		},
		BPRD = {
			{Values = {138018660}, Gender = 0, SpriteType = 0},
			{Values = {138019316}, Gender = 0, SpriteType = 3},
			{Values = {138025476}, Gender = 0, SpriteType = 4},
			{Values = {138018820}, Gender = 0, SpriteType = 1},
			{Values = {138019124}, Gender = 0, SpriteType = 2},
			{Values = {138018892}, Gender = 1, SpriteType = 0},
			{Values = {138019388}, Gender = 1, SpriteType = 3},
			{Values = {138025572}, Gender = 1, SpriteType = 4},
			{Values = {138019052}, Gender = 1, SpriteType = 1},
			{Values = {138019220}, Gender = 1, SpriteType = 2},
		},
		BPGD = {
			{Values = {138018628}, Gender = 0, SpriteType = 0},
			{Values = {138019284}, Gender = 0, SpriteType = 3},
			{Values = {138025444}, Gender = 0, SpriteType = 4},
			{Values = {138018788}, Gender = 0, SpriteType = 1},
			{Values = {138019092}, Gender = 0, SpriteType = 2},
			{Values = {138018860}, Gender = 1, SpriteType = 0},
			{Values = {138019356}, Gender = 1, SpriteType = 3},
			{Values = {138025540}, Gender = 1, SpriteType = 4},
			{Values = {138019020}, Gender = 1, SpriteType = 1},
			{Values = {138019188}, Gender = 1, SpriteType = 2},
		},
		BPRS = {
			{Values = {138000392}, Gender = 0, SpriteType = 0},
			{Values = {138001048}, Gender = 0, SpriteType = 3},
			{Values = {138007208}, Gender = 0, SpriteType = 4},
			{Values = {138000552}, Gender = 0, SpriteType = 1},
			{Values = {138000856}, Gender = 0, SpriteType = 2},
			{Values = {138000624}, Gender = 1, SpriteType = 0},
			{Values = {138001120}, Gender = 1, SpriteType = 3},
			{Values = {138007304}, Gender = 1, SpriteType = 4},
			{Values = {138000784}, Gender = 1, SpriteType = 1},
			{Values = {138000952}, Gender = 1, SpriteType = 2},
		},
		BPGS = {
			{Values = {138000360}, Gender = 0, SpriteType = 0},
			{Values = {138001016}, Gender = 0, SpriteType = 3},
			{Values = {138007176}, Gender = 0, SpriteType = 4},
			{Values = {138000520}, Gender = 0, SpriteType = 1},
			{Values = {138000824}, Gender = 0, SpriteType = 2},
			{Values = {138000592}, Gender = 1, SpriteType = 0},
			{Values = {138001088}, Gender = 1, SpriteType = 3},
			{Values = {138007272}, Gender = 1, SpriteType = 4},
			{Values = {138000752}, Gender = 1, SpriteType = 1},
			{Values = {138000920}, Gender = 1, SpriteType = 2},
		},
		BPRI = {
			{Values = {137990432}, Gender = 0, SpriteType = 0},
			{Values = {137991088}, Gender = 0, SpriteType = 3},
			{Values = {137997248}, Gender = 0, SpriteType = 4},
			{Values = {137990592}, Gender = 0, SpriteType = 1},
			{Values = {137990896}, Gender = 0, SpriteType = 2},
			{Values = {137990664}, Gender = 1, SpriteType = 0},
			{Values = {137991160}, Gender = 1, SpriteType = 3},
			{Values = {137997344}, Gender = 1, SpriteType = 4},
			{Values = {137990824}, Gender = 1, SpriteType = 1},
			{Values = {137990992}, Gender = 1, SpriteType = 2},
		},
		BPGI = {
			{Values = {137990400}, Gender = 0, SpriteType = 0},
			{Values = {137991056}, Gender = 0, SpriteType = 3},
			{Values = {137997216}, Gender = 0, SpriteType = 4},
			{Values = {137990560}, Gender = 0, SpriteType = 1},
			{Values = {137990864}, Gender = 0, SpriteType = 2},
			{Values = {137990632}, Gender = 1, SpriteType = 0},
			{Values = {137991128}, Gender = 1, SpriteType = 3},
			{Values = {137997312}, Gender = 1, SpriteType = 4},
			{Values = {137990792}, Gender = 1, SpriteType = 1},
			{Values = {137990960}, Gender = 1, SpriteType = 2},
		},
		BPEE = {
			{Values = {139483788}, Gender = 0, SpriteType = 0},
			{Values = {139484388}, Gender = 0, SpriteType = 3},
			{Values = {139491916}, Gender = 0, SpriteType = 4},
			{Values = {139483932}, Gender = 0, SpriteType = 5},
			{Values = {139484004}, Gender = 0, SpriteType = 1},
			{Values = {139484220}, Gender = 0, SpriteType = 2},
			{Values = {139489604}, Gender = 1, SpriteType = 0},
			{Values = {139490204}, Gender = 1, SpriteType = 3},
			{Values = {139492012}, Gender = 1, SpriteType = 4},
			{Values = {139489748}, Gender = 1, SpriteType = 5},
			{Values = {139489820}, Gender = 1, SpriteType = 1},
			{Values = {139490036}, Gender = 1, SpriteType = 2},
		},
		BPEJ = {
			{Values = {139321056}, Gender = 0, SpriteType = 0},
			{Values = {139321656}, Gender = 0, SpriteType = 3},
			{Values = {139329184}, Gender = 0, SpriteType = 4},
			{Values = {139321200}, Gender = 0, SpriteType = 5},
			{Values = {139321272}, Gender = 0, SpriteType = 1},
			{Values = {139321488}, Gender = 0, SpriteType = 2},
			{Values = {139326872}, Gender = 1, SpriteType = 0},
			{Values = {139327472}, Gender = 1, SpriteType = 3},
			{Values = {139329280}, Gender = 1, SpriteType = 4},
			{Values = {139327016}, Gender = 1, SpriteType = 5},
			{Values = {139327088}, Gender = 1, SpriteType = 1},
			{Values = {139327304}, Gender = 1, SpriteType = 2},
		},
		BPEF = {
			{Values = {139503992}, Gender = 0, SpriteType = 0},
			{Values = {139504592}, Gender = 0, SpriteType = 3},
			{Values = {139512120}, Gender = 0, SpriteType = 4},
			{Values = {139504136}, Gender = 0, SpriteType = 5},
			{Values = {139504208}, Gender = 0, SpriteType = 1},
			{Values = {139504424}, Gender = 0, SpriteType = 2},
			{Values = {139509808}, Gender = 1, SpriteType = 0},
			{Values = {139510408}, Gender = 1, SpriteType = 3},
			{Values = {139512216}, Gender = 1, SpriteType = 4},
			{Values = {139509952}, Gender = 1, SpriteType = 5},
			{Values = {139510024}, Gender = 1, SpriteType = 1},
			{Values = {139510240}, Gender = 1, SpriteType = 2},
		},
		BPED = {
			{Values = {139556796}, Gender = 0, SpriteType = 0},
			{Values = {139557396}, Gender = 0, SpriteType = 3},
			{Values = {139564924}, Gender = 0, SpriteType = 4},
			{Values = {139556940}, Gender = 0, SpriteType = 5},
			{Values = {139557012}, Gender = 0, SpriteType = 1},
			{Values = {139557228}, Gender = 0, SpriteType = 2},
			{Values = {139562612}, Gender = 1, SpriteType = 0},
			{Values = {139563212}, Gender = 1, SpriteType = 3},
			{Values = {139565020}, Gender = 1, SpriteType = 4},
			{Values = {139562756}, Gender = 1, SpriteType = 5},
			{Values = {139562828}, Gender = 1, SpriteType = 1},
			{Values = {139563044}, Gender = 1, SpriteType = 2},
		},
		BPES = {
			{Values = {139497704}, Gender = 0, SpriteType = 0},
			{Values = {139498304}, Gender = 0, SpriteType = 3},
			{Values = {139505832}, Gender = 0, SpriteType = 4},
			{Values = {139497848}, Gender = 0, SpriteType = 5},
			{Values = {139497920}, Gender = 0, SpriteType = 1},
			{Values = {139498136}, Gender = 0, SpriteType = 2},
			{Values = {139503520}, Gender = 1, SpriteType = 0},
			{Values = {139504120}, Gender = 1, SpriteType = 3},
			{Values = {139505928}, Gender = 1, SpriteType = 4},
			{Values = {139503664}, Gender = 1, SpriteType = 5},
			{Values = {139503736}, Gender = 1, SpriteType = 1},
			{Values = {139503952}, Gender = 1, SpriteType = 2},
		},
		BPEI = {
			{Values = {139470800}, Gender = 0, SpriteType = 0},
			{Values = {139471400}, Gender = 0, SpriteType = 3},
			{Values = {139478928}, Gender = 0, SpriteType = 4},
			{Values = {139470944}, Gender = 0, SpriteType = 5},
			{Values = {139471016}, Gender = 0, SpriteType = 1},
			{Values = {139471232}, Gender = 0, SpriteType = 2},
			{Values = {139476616}, Gender = 1, SpriteType = 0},
			{Values = {139477216}, Gender = 1, SpriteType = 3},
			{Values = {139479024}, Gender = 1, SpriteType = 4},
			{Values = {139476760}, Gender = 1, SpriteType = 5},
			{Values = {139476832}, Gender = 1, SpriteType = 1},
			{Values = {139477048}, Gender = 1, SpriteType = 2},
		},
		AXV1 = {
			{Values = {137814096}, Gender = 0, SpriteType = 0},
			{Values = {137814696}, Gender = 0, SpriteType = 3},
			{Values = {137822224}, Gender = 0, SpriteType = 4},
			{Values = {137814240}, Gender = 0, SpriteType = 5},
			{Values = {137814312}, Gender = 0, SpriteType = 1},
			{Values = {137814528}, Gender = 0, SpriteType = 2},
			{Values = {137819912}, Gender = 1, SpriteType = 0},
			{Values = {137820512}, Gender = 1, SpriteType = 3},
			{Values = {137822320}, Gender = 1, SpriteType = 4},
			{Values = {137820056}, Gender = 1, SpriteType = 5},
			{Values = {137820128}, Gender = 1, SpriteType = 1},
			{Values = {137820344}, Gender = 1, SpriteType = 2},
		},
		AXV2 = {
			{Values = {137814120}, Gender = 0, SpriteType = 0},
			{Values = {137814720}, Gender = 0, SpriteType = 3},
			{Values = {137822248}, Gender = 0, SpriteType = 4},
			{Values = {137814264}, Gender = 0, SpriteType = 5},
			{Values = {137814336}, Gender = 0, SpriteType = 1},
			{Values = {137814552}, Gender = 0, SpriteType = 2},
			{Values = {137819936}, Gender = 1, SpriteType = 0},
			{Values = {137820536}, Gender = 1, SpriteType = 3},
			{Values = {137822344}, Gender = 1, SpriteType = 4},
			{Values = {137820080}, Gender = 1, SpriteType = 5},
			{Values = {137820152}, Gender = 1, SpriteType = 1},
			{Values = {137820368}, Gender = 1, SpriteType = 2},
		},
		AXP1 = {
			{Values = {137813984}, Gender = 0, SpriteType = 0},
			{Values = {137814584}, Gender = 0, SpriteType = 3},
			{Values = {137822112}, Gender = 0, SpriteType = 4},
			{Values = {137814128}, Gender = 0, SpriteType = 5},
			{Values = {137814200}, Gender = 0, SpriteType = 1},
			{Values = {137814416}, Gender = 0, SpriteType = 2},
			{Values = {137819800}, Gender = 1, SpriteType = 0},
			{Values = {137820400}, Gender = 1, SpriteType = 3},
			{Values = {137822208}, Gender = 1, SpriteType = 4},
			{Values = {137819944}, Gender = 1, SpriteType = 5},
			{Values = {137820016}, Gender = 1, SpriteType = 1},
			{Values = {137820232}, Gender = 1, SpriteType = 2},
		},
		AXP2 = {
			{Values = {137814008}, Gender = 0, SpriteType = 0},
			{Values = {137814608}, Gender = 0, SpriteType = 3},
			{Values = {137822136}, Gender = 0, SpriteType = 4},
			{Values = {137814152}, Gender = 0, SpriteType = 5},
			{Values = {137814224}, Gender = 0, SpriteType = 1},
			{Values = {137814440}, Gender = 0, SpriteType = 2},
			{Values = {137819824}, Gender = 1, SpriteType = 0},
			{Values = {137820424}, Gender = 1, SpriteType = 3},
			{Values = {137822232}, Gender = 1, SpriteType = 4},
			{Values = {137819968}, Gender = 1, SpriteType = 5},
			{Values = {137820040}, Gender = 1, SpriteType = 1},
			{Values = {137820256}, Gender = 1, SpriteType = 2},
		},
		AXVJ = {
			{Values = {137651440}, Gender = 0, SpriteType = 0},
			{Values = {137652040}, Gender = 0, SpriteType = 3},
			{Values = {137659568}, Gender = 0, SpriteType = 4},
			{Values = {137651584}, Gender = 0, SpriteType = 5},
			{Values = {137651656}, Gender = 0, SpriteType = 1},
			{Values = {137651872}, Gender = 0, SpriteType = 2},
			{Values = {137657256}, Gender = 1, SpriteType = 0},
			{Values = {137657856}, Gender = 1, SpriteType = 3},
			{Values = {137659664}, Gender = 1, SpriteType = 4},
			{Values = {137657400}, Gender = 1, SpriteType = 5},
			{Values = {137657472}, Gender = 1, SpriteType = 1},
			{Values = {137657688}, Gender = 1, SpriteType = 2},
		},
		AXPJ = {
			{Values = {137651328}, Gender = 0, SpriteType = 0},
			{Values = {137651928}, Gender = 0, SpriteType = 3},
			{Values = {137659456}, Gender = 0, SpriteType = 4},
			{Values = {137651472}, Gender = 0, SpriteType = 5},
			{Values = {137651544}, Gender = 0, SpriteType = 1},
			{Values = {137651760}, Gender = 0, SpriteType = 2},
			{Values = {137657144}, Gender = 1, SpriteType = 0},
			{Values = {137657744}, Gender = 1, SpriteType = 3},
			{Values = {137659552}, Gender = 1, SpriteType = 4},
			{Values = {137657288}, Gender = 1, SpriteType = 5},
			{Values = {137657360}, Gender = 1, SpriteType = 1},
			{Values = {137657576}, Gender = 1, SpriteType = 2},
		},
		AXVF = {
			{Values = {137841844}, Gender = 0, SpriteType = 0},
			{Values = {137842444}, Gender = 0, SpriteType = 3},
			{Values = {137849972}, Gender = 0, SpriteType = 4},
			{Values = {137841988}, Gender = 0, SpriteType = 5},
			{Values = {137842060}, Gender = 0, SpriteType = 1},
			{Values = {137842276}, Gender = 0, SpriteType = 2},
			{Values = {137847660}, Gender = 1, SpriteType = 0},
			{Values = {137848260}, Gender = 1, SpriteType = 3},
			{Values = {137850068}, Gender = 1, SpriteType = 4},
			{Values = {137847804}, Gender = 1, SpriteType = 5},
			{Values = {137847876}, Gender = 1, SpriteType = 1},
			{Values = {137848092}, Gender = 1, SpriteType = 2},
		},
		AXVD = {
			{Values = {137861176}, Gender = 0, SpriteType = 0},
			{Values = {137861776}, Gender = 0, SpriteType = 3},
			{Values = {137869304}, Gender = 0, SpriteType = 4},
			{Values = {137861320}, Gender = 0, SpriteType = 5},
			{Values = {137861392}, Gender = 0, SpriteType = 1},
			{Values = {137861608}, Gender = 0, SpriteType = 2},
			{Values = {137866992}, Gender = 1, SpriteType = 0},
			{Values = {137867592}, Gender = 1, SpriteType = 3},
			{Values = {137869400}, Gender = 1, SpriteType = 4},
			{Values = {137867136}, Gender = 1, SpriteType = 5},
			{Values = {137867208}, Gender = 1, SpriteType = 1},
			{Values = {137867424}, Gender = 1, SpriteType = 2},
		},
		AXVS = {
			{Values = {137827816}, Gender = 0, SpriteType = 0},
			{Values = {137828416}, Gender = 0, SpriteType = 3},
			{Values = {137835944}, Gender = 0, SpriteType = 4},
			{Values = {137827960}, Gender = 0, SpriteType = 5},
			{Values = {137828032}, Gender = 0, SpriteType = 1},
			{Values = {137828248}, Gender = 0, SpriteType = 2},
			{Values = {137833632}, Gender = 1, SpriteType = 0},
			{Values = {137834232}, Gender = 1, SpriteType = 3},
			{Values = {137836040}, Gender = 1, SpriteType = 4},
			{Values = {137833776}, Gender = 1, SpriteType = 5},
			{Values = {137833848}, Gender = 1, SpriteType = 1},
			{Values = {137834064}, Gender = 1, SpriteType = 2},
		},
		AXVI = {
			{Values = {137815360}, Gender = 0, SpriteType = 0},
			{Values = {137815960}, Gender = 0, SpriteType = 3},
			{Values = {137823488}, Gender = 0, SpriteType = 4},
			{Values = {137815504}, Gender = 0, SpriteType = 5},
			{Values = {137815576}, Gender = 0, SpriteType = 1},
			{Values = {137815792}, Gender = 0, SpriteType = 2},
			{Values = {137821176}, Gender = 1, SpriteType = 0},
			{Values = {137821776}, Gender = 1, SpriteType = 3},
			{Values = {137823584}, Gender = 1, SpriteType = 4},
			{Values = {137821320}, Gender = 1, SpriteType = 5},
			{Values = {137821392}, Gender = 1, SpriteType = 1},
			{Values = {137821608}, Gender = 1, SpriteType = 2},
		},
		AXPF = {
			{Values = {137841732}, Gender = 0, SpriteType = 0},
			{Values = {137842332}, Gender = 0, SpriteType = 3},
			{Values = {137849860}, Gender = 0, SpriteType = 4},
			{Values = {137841876}, Gender = 0, SpriteType = 5},
			{Values = {137841948}, Gender = 0, SpriteType = 1},
			{Values = {137842164}, Gender = 0, SpriteType = 2},
			{Values = {137847548}, Gender = 1, SpriteType = 0},
			{Values = {137848148}, Gender = 1, SpriteType = 3},
			{Values = {137849956}, Gender = 1, SpriteType = 4},
			{Values = {137847692}, Gender = 1, SpriteType = 5},
			{Values = {137847764}, Gender = 1, SpriteType = 1},
			{Values = {137847980}, Gender = 1, SpriteType = 2},
		},
		AXPD = {
			{Values = {137861068}, Gender = 0, SpriteType = 0},
			{Values = {137861668}, Gender = 0, SpriteType = 3},
			{Values = {137869196}, Gender = 0, SpriteType = 4},
			{Values = {137861212}, Gender = 0, SpriteType = 5},
			{Values = {137861284}, Gender = 0, SpriteType = 1},
			{Values = {137861500}, Gender = 0, SpriteType = 2},
			{Values = {137866884}, Gender = 1, SpriteType = 0},
			{Values = {137867484}, Gender = 1, SpriteType = 3},
			{Values = {137869292}, Gender = 1, SpriteType = 4},
			{Values = {137867028}, Gender = 1, SpriteType = 5},
			{Values = {137867100}, Gender = 1, SpriteType = 1},
			{Values = {137867316}, Gender = 1, SpriteType = 2},

		},
		AXPS = {
			{Values = {137827704}, Gender = 0, SpriteType = 0},
			{Values = {137828304}, Gender = 0, SpriteType = 3},
			{Values = {137835832}, Gender = 0, SpriteType = 4},
			{Values = {137827848}, Gender = 0, SpriteType = 5},
			{Values = {137827920}, Gender = 0, SpriteType = 1},
			{Values = {137828136}, Gender = 0, SpriteType = 2},
			{Values = {137833520}, Gender = 1, SpriteType = 0},
			{Values = {137834120}, Gender = 1, SpriteType = 3},
			{Values = {137835928}, Gender = 1, SpriteType = 4},
			{Values = {137833664}, Gender = 1, SpriteType = 5},
			{Values = {137833736}, Gender = 1, SpriteType = 1},
			{Values = {137833952}, Gender = 1, SpriteType = 2},
		},
		AXPI = {
			{Values = {137815248}, Gender = 0, SpriteType = 0},
			{Values = {137815848}, Gender = 0, SpriteType = 3},
			{Values = {137823376}, Gender = 0, SpriteType = 4},
			{Values = {137815392}, Gender = 0, SpriteType = 5},
			{Values = {137815464}, Gender = 0, SpriteType = 1},
			{Values = {137815680}, Gender = 0, SpriteType = 2},
			{Values = {137821064}, Gender = 1, SpriteType = 0},
			{Values = {137821664}, Gender = 1, SpriteType = 3},
			{Values = {137823472}, Gender = 1, SpriteType = 4},
			{Values = {137821208}, Gender = 1, SpriteType = 5},
			{Values = {137821280}, Gender = 1, SpriteType = 1},
			{Values = {137821496}, Gender = 1, SpriteType = 2},
		},
	}
	
	local Sprites = {
		FRLG = {
			[0] = { --Foot
				--Default
				Default = {
					[0] = {SpriteID = 1, Direction = 4},
					[1] = {SpriteID = 2, Direction = 3},
					[2] = {SpriteID = 3, Direction = 1},
					[3] = {SpriteID = 4, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 1, Direction = 4},
				[1] = {SpriteID = 2, Direction = 3},
				[2] = {SpriteID = 3, Direction = 1},
				[3] = {SpriteID = 4, Direction = 2},
				-- Walking
				[16] = {SpriteID = 5, Direction = 4},
				[17] = {SpriteID = 6, Direction = 3},
				[18] = {SpriteID = 7, Direction = 1},
				[19] = {SpriteID = 8, Direction = 2},
				-- Jumping over route
				[20] = {SpriteID = 13, Direction = 4},
				[21] = {SpriteID = 14, Direction = 3},
				[22] = {SpriteID = 15, Direction = 1},
				[23] = {SpriteID = 16, Direction = 2},
				-- Hitting a wall
				[33] = {SpriteID = 1, Direction = 4},
				[34] = {SpriteID = 2, Direction = 3},
				[35] = {SpriteID = 3, Direction = 1},
				[36] = {SpriteID = 4, Direction = 2},
				
				[37] = {SpriteID = 1, Direction = 4},
				[38] = {SpriteID = 2, Direction = 3},
				[39] = {SpriteID = 3, Direction = 1},
				[40] = {SpriteID = 4, Direction = 2},
				-- Turning
				[41] = {SpriteID = 9, Direction = 4},
				[42] = {SpriteID = 10, Direction = 3},
				[43] = {SpriteID = 11, Direction = 1},
				[44] = {SpriteID = 12, Direction = 2},
				-- Running
				[61] = {SpriteID = 13, Direction = 4},
				[62] = {SpriteID = 14, Direction = 3},
				[63] = {SpriteID = 15, Direction = 1},
				[64] = {SpriteID = 16, Direction = 2},
			},
			[1] = {-- Bike
				--Default
				Default = {
					[0] = {SpriteID = 17, Direction = 4},
					[1] = {SpriteID = 18, Direction = 3},
					[2] = {SpriteID = 19, Direction = 1},
					[3] = {SpriteID = 20, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 17, Direction = 4},
				[1] = {SpriteID = 18, Direction = 3},
				[2] = {SpriteID = 19, Direction = 1},
				[3] = {SpriteID = 20, Direction = 2},
				-- Jumping route
				[20] = {SpriteID = 21, Direction = 4},
				[21] = {SpriteID = 22, Direction = 3},
				[22] = {SpriteID = 23, Direction = 1},
				[23] = {SpriteID = 24, Direction = 2},
				-- Hitting a wall
				[37] = {SpriteID = 29, Direction = 4},
				[38] = {SpriteID = 30, Direction = 3},
				[39] = {SpriteID = 31, Direction = 1},
				[40] = {SpriteID = 32, Direction = 2},
				-- Biking
				[49] = {SpriteID = 21, Direction = 4},
				[50] = {SpriteID = 22, Direction = 3},
				[51] = {SpriteID = 23, Direction = 1},
				[52] = {SpriteID = 24, Direction = 2},
				-- Turning
				[61] = {SpriteID = 25, Direction = 4},
				[62] = {SpriteID = 26, Direction = 3},
				[63] = {SpriteID = 27, Direction = 1},
				[64] = {SpriteID = 28, Direction = 2},
			},
			[2] = { --Surfing
				--Default
				Default = {
					[0] = {SpriteID = 33, Direction = 4},
					[1] = {SpriteID = 34, Direction = 3},
					[2] = {SpriteID = 35, Direction = 1},
					[3] = {SpriteID = 36, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 33, Direction = 4},
				[1] = {SpriteID = 34, Direction = 3},
				[2] = {SpriteID = 35, Direction = 1},
				[3] = {SpriteID = 36, Direction = 2},
				-- Surfing
				[29] = {SpriteID = 37, Direction = 4},
				[30] = {SpriteID = 38, Direction = 3},
				[31] = {SpriteID = 39, Direction = 1},
				[32] = {SpriteID = 40, Direction = 2},
				-- Hitting a wall
				[33] = {SpriteID = 33, Direction = 4},
				[34] = {SpriteID = 34, Direction = 3},
				[35] = {SpriteID = 35, Direction = 1},
				[36] = {SpriteID = 36, Direction = 2},
				-- Turning
				[41] = {SpriteID = 33, Direction = 4},
				[42] = {SpriteID = 34, Direction = 3},
				[43] = {SpriteID = 35, Direction = 1},
				[44] = {SpriteID = 36, Direction = 2},
				-- Getting on pokemon
				[70] = {SpriteID = 37, Direction = 4},
				[71] = {SpriteID = 38, Direction = 3},
				[72] = {SpriteID = 39, Direction = 1},
				[73] = {SpriteID = 40, Direction = 2},
				-- Getting off pokemon
				[166] = {SpriteID = 5, Direction = 4},
				[167] = {SpriteID = 6, Direction = 3},
				[168] = {SpriteID = 7, Direction = 1},
				[169] = {SpriteID = 8, Direction = 2},
			},
			[3] = { --Throwing Pokemon
				--Default
				Default = {
					[69] = {SpriteID = 80, Direction = 4},
				},
				-- Facing
				[69] = {SpriteID = 80, Direction = 4},
			},
			[4] = { --Fishing
				--Default
				Default = {
					[1] = {SpriteID = 81, Direction = 4},
					[2] = {SpriteID = 82, Direction = 3},
					[3] = {SpriteID = 83, Direction = 1},
					[4] = {SpriteID = 84, Direction = 2},
				},
				[1] = {-- surfing fishing
					[1] = {SpriteID = 85, Direction = 4},
					[2] = {SpriteID = 86, Direction = 3},
					[3] = {SpriteID = 87, Direction = 1},
					[4] = {SpriteID = 88, Direction = 2},
				},
				[255] = {-- Facing
					[1] = {SpriteID = 81, Direction = 4},
					[2] = {SpriteID = 82, Direction = 3},
					[3] = {SpriteID = 83, Direction = 1},
					[4] = {SpriteID = 84, Direction = 2},
				},
			},
		},
		
		E = {
			[0] = { --Foot
				--Default
				Default = {
					[0] = {SpriteID = 1, Direction = 4},
					[1] = {SpriteID = 2, Direction = 3},
					[2] = {SpriteID = 3, Direction = 1},
					[3] = {SpriteID = 4, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 1, Direction = 4},
				[1] = {SpriteID = 2, Direction = 3},
				[2] = {SpriteID = 3, Direction = 1},
				[3] = {SpriteID = 4, Direction = 2},
				-- Walking
				[8] = {SpriteID = 5, Direction = 4},
				[9] = {SpriteID = 6, Direction = 3},
				[10] = {SpriteID = 7, Direction = 1},
				[11] = {SpriteID = 8, Direction = 2},
				-- Jumping over route
				[12] = {SpriteID = 13, Direction = 4},
				[13] = {SpriteID = 14, Direction = 3},
				[14] = {SpriteID = 15, Direction = 1},
				[15] = {SpriteID = 16, Direction = 2},
				-- Hitting a wall
				[25] = {SpriteID = 1, Direction = 4},
				[26] = {SpriteID = 2, Direction = 3},
				[27] = {SpriteID = 3, Direction = 1},
				[28] = {SpriteID = 4, Direction = 2},
				-- Turning
				[33] = {SpriteID = 9, Direction = 4},
				[34] = {SpriteID = 10, Direction = 3},
				[35] = {SpriteID = 11, Direction = 1},
				[36] = {SpriteID = 12, Direction = 2},
				-- Running
				[53] = {SpriteID = 13, Direction = 4},
				[54] = {SpriteID = 14, Direction = 3},
				[55] = {SpriteID = 15, Direction = 1},
				[56] = {SpriteID = 16, Direction = 2},
			},
			[1] = {-- Acro Bike
				--Default
				Default = {
					[0] = {SpriteID = 17, Direction = 4},
					[1] = {SpriteID = 18, Direction = 3},
					[2] = {SpriteID = 19, Direction = 1},
					[3] = {SpriteID = 20, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 17, Direction = 4},
				[1] = {SpriteID = 18, Direction = 3},
				[2] = {SpriteID = 19, Direction = 1},
				[3] = {SpriteID = 20, Direction = 2},
				-- Jumping over route
				[12] = {SpriteID = 17, Direction = 4},
				[13] = {SpriteID = 18, Direction = 3},
				[14] = {SpriteID = 19, Direction = 1},
				[15] = {SpriteID = 20, Direction = 2},
				-- Hitting a wall
				[29] = {SpriteID = 29, Direction = 4},
				[30] = {SpriteID = 30, Direction = 3},
				[31] = {SpriteID = 31, Direction = 1},
				[32] = {SpriteID = 32, Direction = 2},
				-- BIKE STATE ACRO 6x/16frame (2.66)
				[41] = {SpriteID = 21, Direction = 4},
				[42] = {SpriteID = 22, Direction = 3},
				[43] = {SpriteID = 23, Direction = 1},
				[44] = {SpriteID = 24, Direction = 2},
				-- Wheelie full
				[100] = {SpriteID = 45, Direction = 4},
				[101] = {SpriteID = 46, Direction = 3},
				[102] = {SpriteID = 47, Direction = 1},
				[103] = {SpriteID = 48, Direction = 2},
				-- Wheelie start
				[104] = {SpriteID = 41, Direction = 4},
				[105] = {SpriteID = 42, Direction = 3},
				[106] = {SpriteID = 43, Direction = 1},
				[107] = {SpriteID = 44, Direction = 2},
				-- Wheelie down
				[108] = {SpriteID = 49, Direction = 4},
				[109] = {SpriteID = 50, Direction = 3},
				[110] = {SpriteID = 51, Direction = 1},
				[111] = {SpriteID = 52, Direction = 2},
				-- Wheelie jump
				[112] = {SpriteID = 65, Direction = 4},
				[113] = {SpriteID = 66, Direction = 3},
				[114] = {SpriteID = 67, Direction = 1},
				[115] = {SpriteID = 68, Direction = 2},
				-- Wheelie jump moving
				[116] = {SpriteID = 69, Direction = 4},
				[117] = {SpriteID = 70, Direction = 3},
				[118] = {SpriteID = 71, Direction = 1},
				[119] = {SpriteID = 72, Direction = 2},
				-- Wheelie hitting wall
				[124] = {SpriteID = 45, Direction = 4},
				[125] = {SpriteID = 46, Direction = 3},
				[126] = {SpriteID = 47, Direction = 1},
				[127] = {SpriteID = 48, Direction = 2},
				-- Wheelie start moving
				[128] = {SpriteID = 53, Direction = 4},
				[129] = {SpriteID = 54, Direction = 3},
				[130] = {SpriteID = 55, Direction = 1},
				[131] = {SpriteID = 56, Direction = 2},
				-- Wheelie full moving
				[132] = {SpriteID = 57, Direction = 4},
				[133] = {SpriteID = 58, Direction = 3},
				[134] = {SpriteID = 59, Direction = 1},
				[135] = {SpriteID = 60, Direction = 2},
				-- Wheelie down moving
				[136] = {SpriteID = 61, Direction = 4},
				[137] = {SpriteID = 62, Direction = 3},
				[138] = {SpriteID = 63, Direction = 1},
				[139] = {SpriteID = 64, Direction = 2},
			},
			[2] = { --Surfing
				--Default
				Default = {
					[0] = {SpriteID = 33, Direction = 4},
					[1] = {SpriteID = 34, Direction = 3},
					[2] = {SpriteID = 35, Direction = 1},
					[3] = {SpriteID = 36, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 33, Direction = 4},
				[1] = {SpriteID = 34, Direction = 3},
				[2] = {SpriteID = 35, Direction = 1},
				[3] = {SpriteID = 36, Direction = 2},
				-- Surfing
				[21] = {SpriteID = 37, Direction = 4},
				[22] = {SpriteID = 38, Direction = 3},
				[23] = {SpriteID = 39, Direction = 1},
				[24] = {SpriteID = 40, Direction = 2},
				-- Hitting a wall
				[25] = {SpriteID = 33, Direction = 4},
				[26] = {SpriteID = 34, Direction = 3},
				[27] = {SpriteID = 35, Direction = 1},
				[28] = {SpriteID = 36, Direction = 2},
				-- Turning
				[33] = {SpriteID = 33, Direction = 4},
				[34] = {SpriteID = 34, Direction = 3},
				[35] = {SpriteID = 35, Direction = 1},
				[36] = {SpriteID = 36, Direction = 2},
				-- Getting on/off pokemon (jumping)
				[58] = {SpriteID = 5, Direction = 4},
				[59] = {SpriteID = 6, Direction = 3},
				[60] = {SpriteID = 7, Direction = 1},
				[61] = {SpriteID = 8, Direction = 2},
			},
			[3] = { --Throwing Pokemon
				--Default
				Default = {
					[57] = {SpriteID = 80, Direction = 4},
				},
				-- Facing
				[57] = {SpriteID = 80, Direction = 4},
			},
			[4] = { --Fishing
				--Default
				Default = {
					[1] = {SpriteID = 81, Direction = 4},
					[2] = {SpriteID = 82, Direction = 3},
					[3] = {SpriteID = 83, Direction = 1},
					[4] = {SpriteID = 84, Direction = 2},
				},
				[1] = {-- surfing fishing
					[1] = {SpriteID = 85, Direction = 4},
					[2] = {SpriteID = 86, Direction = 3},
					[3] = {SpriteID = 87, Direction = 1},
					[4] = {SpriteID = 88, Direction = 2},
				},
				[255] = {-- Facing
					[1] = {SpriteID = 81, Direction = 4},
					[2] = {SpriteID = 82, Direction = 3},
					[3] = {SpriteID = 83, Direction = 1},
					[4] = {SpriteID = 84, Direction = 2},
				},
			},
			[5] = {-- Mach Bike
				--Default
				Default = {
					[0] = {SpriteID = 17, Direction = 4},
					[1] = {SpriteID = 18, Direction = 3},
					[2] = {SpriteID = 19, Direction = 1},
					[3] = {SpriteID = 20, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 17, Direction = 4},
				[1] = {SpriteID = 18, Direction = 3},
				[2] = {SpriteID = 19, Direction = 1},
				[3] = {SpriteID = 20, Direction = 2},
				-- BIKE STATE 1 SLOW 16x/16frame (1)
				[8] = {SpriteID = 21, Direction = 4},
				[9] = {SpriteID = 22, Direction = 3},
				[10] = {SpriteID = 23, Direction = 1},
				[11] = {SpriteID = 24, Direction = 2},
				-- Jumping over route
				[12] = {SpriteID = 17, Direction = 4},
				[13] = {SpriteID = 18, Direction = 3},
				[14] = {SpriteID = 19, Direction = 1},
				[15] = {SpriteID = 20, Direction = 2},
				-- BIKE STATE 2 NORMAL 8x/16frame (2)
				[21] = {SpriteID = 21, Direction = 4},
				[22] = {SpriteID = 22, Direction = 3},
				[23] = {SpriteID = 23, Direction = 1},
				[24] = {SpriteID = 24, Direction = 2},
				-- Hitting a wall
				[25] = {SpriteID = 29, Direction = 4},
				[26] = {SpriteID = 30, Direction = 3},
				[27] = {SpriteID = 31, Direction = 1},
				[28] = {SpriteID = 32, Direction = 2},
				-- Turning
				[33] = {SpriteID = 25, Direction = 4},
				[34] = {SpriteID = 26, Direction = 3},
				[35] = {SpriteID = 27, Direction = 1},
				[36] = {SpriteID = 28, Direction = 2},
				-- BIKE STATE ACRO 6x/16frame (2.66)
				[41] = {SpriteID = 21, Direction = 4},
				[42] = {SpriteID = 22, Direction = 3},
				[43] = {SpriteID = 23, Direction = 1},
				[44] = {SpriteID = 24, Direction = 2},
				-- BIKE STATE 3 NORMAL 4x/16frame (4)
				[45] = {SpriteID = 89, Direction = 4},
				[46] = {SpriteID = 90, Direction = 3},
				[47] = {SpriteID = 91, Direction = 1},
				[48] = {SpriteID = 92, Direction = 2},
			},
		},
		
		RS = {
			[0] = { --Foot
				--Default
				Default = {
					[0] = {SpriteID = 1, Direction = 4},
					[1] = {SpriteID = 2, Direction = 3},
					[2] = {SpriteID = 3, Direction = 1},
					[3] = {SpriteID = 4, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 1, Direction = 4},
				[1] = {SpriteID = 2, Direction = 3},
				[2] = {SpriteID = 3, Direction = 1},
				[3] = {SpriteID = 4, Direction = 2},
				-- Walking
				[8] = {SpriteID = 5, Direction = 4},
				[9] = {SpriteID = 6, Direction = 3},
				[10] = {SpriteID = 7, Direction = 1},
				[11] = {SpriteID = 8, Direction = 2},
				-- Jumping over route
				[12] = {SpriteID = 13, Direction = 4},
				[13] = {SpriteID = 14, Direction = 3},
				[14] = {SpriteID = 15, Direction = 1},
				[15] = {SpriteID = 16, Direction = 2},
				-- Hitting a wall
				[25] = {SpriteID = 1, Direction = 4},
				[26] = {SpriteID = 2, Direction = 3},
				[27] = {SpriteID = 3, Direction = 1},
				[28] = {SpriteID = 4, Direction = 2},
				-- Turning
				[33] = {SpriteID = 9, Direction = 4},
				[34] = {SpriteID = 10, Direction = 3},
				[35] = {SpriteID = 11, Direction = 1},
				[36] = {SpriteID = 12, Direction = 2},
				-- Running
				[53] = {SpriteID = 13, Direction = 4},
				[54] = {SpriteID = 14, Direction = 3},
				[55] = {SpriteID = 15, Direction = 1},
				[56] = {SpriteID = 16, Direction = 2},
			},
			[1] = {-- Acro Bike
				--Default
				Default = {
					[0] = {SpriteID = 17, Direction = 4},
					[1] = {SpriteID = 18, Direction = 3},
					[2] = {SpriteID = 19, Direction = 1},
					[3] = {SpriteID = 20, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 17, Direction = 4},
				[1] = {SpriteID = 18, Direction = 3},
				[2] = {SpriteID = 19, Direction = 1},
				[3] = {SpriteID = 20, Direction = 2},
				-- Jumping over route
				[12] = {SpriteID = 17, Direction = 4},
				[13] = {SpriteID = 18, Direction = 3},
				[14] = {SpriteID = 19, Direction = 1},
				[15] = {SpriteID = 20, Direction = 2},
				-- Hitting a wall
				[29] = {SpriteID = 29, Direction = 4},
				[30] = {SpriteID = 30, Direction = 3},
				[31] = {SpriteID = 31, Direction = 1},
				[32] = {SpriteID = 32, Direction = 2},
				-- BIKE STATE ACRO 6x/16frame (2.66)
				[41] = {SpriteID = 21, Direction = 4},
				[42] = {SpriteID = 22, Direction = 3},
				[43] = {SpriteID = 23, Direction = 1},
				[44] = {SpriteID = 24, Direction = 2},
				-- Wheelie full
				[98] = {SpriteID = 45, Direction = 4},
				[99] = {SpriteID = 46, Direction = 3},
				[100] = {SpriteID = 47, Direction = 1},
				[101] = {SpriteID = 48, Direction = 2},
				-- Wheelie start
				[102] = {SpriteID = 41, Direction = 4},
				[103] = {SpriteID = 42, Direction = 3},
				[104] = {SpriteID = 43, Direction = 1},
				[105] = {SpriteID = 44, Direction = 2},
				-- Wheelie down
				[106] = {SpriteID = 49, Direction = 4},
				[107] = {SpriteID = 50, Direction = 3},
				[108] = {SpriteID = 51, Direction = 1},
				[109] = {SpriteID = 52, Direction = 2},
				-- Wheelie jump
				[110] = {SpriteID = 65, Direction = 4},
				[111] = {SpriteID = 66, Direction = 3},
				[112] = {SpriteID = 67, Direction = 1},
				[113] = {SpriteID = 68, Direction = 2},
				-- Wheelie jump moving
				[114] = {SpriteID = 69, Direction = 4},
				[115] = {SpriteID = 70, Direction = 3},
				[116] = {SpriteID = 71, Direction = 1},
				[117] = {SpriteID = 72, Direction = 2},
				-- Wheelie Hitting a wall
				[122] = {SpriteID = 45, Direction = 4},
				[123] = {SpriteID = 46, Direction = 3},
				[124] = {SpriteID = 47, Direction = 1},
				[125] = {SpriteID = 48, Direction = 2},
				-- Wheelie start moving
				[126] = {SpriteID = 53, Direction = 4},
				[127] = {SpriteID = 54, Direction = 3},
				[128] = {SpriteID = 55, Direction = 1},
				[129] = {SpriteID = 56, Direction = 2},
				-- Wheelie full moving
				[130] = {SpriteID = 57, Direction = 4},
				[131] = {SpriteID = 58, Direction = 3},
				[132] = {SpriteID = 59, Direction = 1},
				[133] = {SpriteID = 60, Direction = 2},
				-- Wheelie down moving
				[134] = {SpriteID = 61, Direction = 4},
				[135] = {SpriteID = 62, Direction = 3},
				[136] = {SpriteID = 63, Direction = 1},
				[137] = {SpriteID = 64, Direction = 2},
				-- jump sudden
				[66] = {SpriteID = 17, Direction = 4},
				[67] = {SpriteID = 18, Direction = 3},
				[68] = {SpriteID = 19, Direction = 1},
				[69] = {SpriteID = 20, Direction = 2},
				-- jump backwards
				[74] = {SpriteID = 17, Direction = 4},
				[75] = {SpriteID = 18, Direction = 3},
				[76] = {SpriteID = 19, Direction = 1},
				[77] = {SpriteID = 20, Direction = 2},
			},
			[2] = { --Surfing
				--Default
				Default = {
					[0] = {SpriteID = 33, Direction = 4},
					[1] = {SpriteID = 34, Direction = 3},
					[2] = {SpriteID = 35, Direction = 1},
					[3] = {SpriteID = 36, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 33, Direction = 4},
				[1] = {SpriteID = 34, Direction = 3},
				[2] = {SpriteID = 35, Direction = 1},
				[3] = {SpriteID = 36, Direction = 2},
				-- Surfing
				[21] = {SpriteID = 37, Direction = 4},
				[22] = {SpriteID = 38, Direction = 3},
				[23] = {SpriteID = 39, Direction = 1},
				[24] = {SpriteID = 40, Direction = 2},
				-- Hitting a wall
				[25] = {SpriteID = 33, Direction = 4},
				[26] = {SpriteID = 34, Direction = 3},
				[27] = {SpriteID = 35, Direction = 1},
				[28] = {SpriteID = 36, Direction = 2},
				-- Turning
				[33] = {SpriteID = 33, Direction = 4},
				[34] = {SpriteID = 34, Direction = 3},
				[35] = {SpriteID = 35, Direction = 1},
				[36] = {SpriteID = 36, Direction = 2},
				-- Getting on/off pokemon (jumping)
				[58] = {SpriteID = 5, Direction = 4},
				[59] = {SpriteID = 6, Direction = 3},
				[60] = {SpriteID = 7, Direction = 1},
				[61] = {SpriteID = 8, Direction = 2},
			},
			[3] = { --Throwing Pokemon
				--Default
				Default = {
					[57] = {SpriteID = 80, Direction = 4},
				},
				-- Facing
				[57] = {SpriteID = 80, Direction = 4},
			},
			[4] = { --Fishing
				--Default
				Default = {
					[1] = {SpriteID = 81, Direction = 4},
					[2] = {SpriteID = 82, Direction = 3},
					[3] = {SpriteID = 83, Direction = 1},
					[4] = {SpriteID = 84, Direction = 2},
				},
				[1] = {-- surfing fishing
					[1] = {SpriteID = 85, Direction = 4},
					[2] = {SpriteID = 86, Direction = 3},
					[3] = {SpriteID = 87, Direction = 1},
					[4] = {SpriteID = 88, Direction = 2},
				},
				[255] = {-- Facing
					[1] = {SpriteID = 81, Direction = 4},
					[2] = {SpriteID = 82, Direction = 3},
					[3] = {SpriteID = 83, Direction = 1},
					[4] = {SpriteID = 84, Direction = 2},
				},
			},
			[5] = {-- Mach Bike
				--Default
				Default = {
					[0] = {SpriteID = 17, Direction = 4},
					[1] = {SpriteID = 18, Direction = 3},
					[2] = {SpriteID = 19, Direction = 1},
					[3] = {SpriteID = 20, Direction = 2},
				},
				-- Facing
				[0] = {SpriteID = 17, Direction = 4},
				[1] = {SpriteID = 18, Direction = 3},
				[2] = {SpriteID = 19, Direction = 1},
				[3] = {SpriteID = 20, Direction = 2},
				-- BIKE STATE 1 SLOW 16x/16frame (1)
				[8] = {SpriteID = 21, Direction = 4},
				[9] = {SpriteID = 22, Direction = 3},
				[10] = {SpriteID = 23, Direction = 1},
				[11] = {SpriteID = 24, Direction = 2},
				-- Jumping over route
				[12] = {SpriteID = 17, Direction = 4},
				[13] = {SpriteID = 18, Direction = 3},
				[14] = {SpriteID = 19, Direction = 1},
				[15] = {SpriteID = 20, Direction = 2},
				-- BIKE STATE 2 NORMAL 8x/16frame (2)
				[21] = {SpriteID = 21, Direction = 4},
				[22] = {SpriteID = 22, Direction = 3},
				[23] = {SpriteID = 23, Direction = 1},
				[24] = {SpriteID = 24, Direction = 2},
				-- Hitting a wall
				[29] = {SpriteID = 29, Direction = 4},
				[30] = {SpriteID = 30, Direction = 3},
				[31] = {SpriteID = 31, Direction = 1},
				[32] = {SpriteID = 32, Direction = 2},
				-- BIKE STATE ACRO 6x/16frame (2.66)
				[41] = {SpriteID = 21, Direction = 4},
				[42] = {SpriteID = 22, Direction = 3},
				[43] = {SpriteID = 23, Direction = 1},
				[44] = {SpriteID = 24, Direction = 2},
				-- BIKE STATE 3 NORMAL 4x/16frame (4)
				[45] = {SpriteID = 89, Direction = 4},
				[46] = {SpriteID = 90, Direction = 3},
				[47] = {SpriteID = 91, Direction = 1},
				[48] = {SpriteID = 92, Direction = 2},
			},
		},
	}
	
	PositionData.Bike = emu:read32(gAddress[GameID].gPlayerSprite)
	PositionData.Animate2 = emu:read8(gAddress[GameID].gPlayerAnimate2)
	PositionData.AnimType = emu:read8(gAddress[GameID].gPlayerAnimateType)
	PositionData.AnimLength = emu:read8(gAddress[GameID].gPlayerAnimateLength)
	PositionData.AnimationByte = emu:read8(gAddress[GameID].gPlayerAnimate)
	PositionData.AnimationDirection = emu:read8(gAddress[GameID].gPlayerDirection)
	local object = emu:read8(gAddress[GameID].gPlayerAvatar+4)
	PositionData.Metatile = emu:read8(gAddress[GameID].gObjectEvents+(36*object)+0x1E)
	PositionData.Elevation = emu:read8(gAddress[GameID].gObjectEvents+(36*object)+0xB)
	local mapx, mapy = emu:read16(gAddress[GameID].gObjectEvents+(36*object)+0x10), emu:read16(gAddress[GameID].gObjectEvents+(36*object)+0x12)
	local Main = emu:read32(gAddress[GameID].gMainCallback)
	local AnimationByte = PositionData.AnimationByte
	local AnimationDirection = PositionData.AnimationDirection
	PositionData.AnimationData = IsInMenu()
	if PositionData.AnimationData > 0 or LockFromScript > 0 then
		if DebugMessages.Position then console:log("IS IN MENU/Lockfromscript. LFS: " .. LockFromScript .. " CURRENT ANIM: " .. PositionData.Animation .. " CALLBACK: " .. Main .. ". CHANGING ANIMATION TO STAND") end
		local anim = 0
		if PositionData.Direction == 4 then anim = 0
		elseif PositionData.Direction == 3 then anim = 1
		elseif PositionData.Direction == 1 then anim = 2
		elseif PositionData.Direction == 2 then anim = 3
		end
		PositionData.Animation = Sprites[gAddress[GameID].sBikeVersion][PositionData.SpriteType][anim].SpriteID
		return PositionData.CurrentX, PositionData.CurrentY, PositionData.Direction, PositionData.PlayerMapID, PositionData.Animation, PositionData.Gender, PositionData.SpriteType, PositionData.PlayerMapEntranceType, PositionData.BorderX, PositionData.BorderY, PositionData.Connections, PositionData.AnimationData
	end
	local SpriteSettingsTable = SpriteSettings[GameID]
	local SpritesTable = Sprites[gAddress[GameID].sBikeVersion]
	
	if SpriteSettingsTable then
		for _, Setting in ipairs(SpriteSettingsTable) do
			if tableContains(Setting.Values, PositionData.Bike) then
				PositionData.Gender = Setting.Gender
				PositionData.SpriteType = Setting.SpriteType
				if DebugMessages.Position then console:log("GENDER: " .. PositionData.Gender .. " SPRITETYPE: " .. PositionData.SpriteType) end
				break
			end
		end
	end
	
	-- Gets sprite and Direction
	if SpritesTable then
		if SpritesTable[PositionData.SpriteType] then
			if PositionData.SpriteType ~= 4 then --Fishing needs different handling
				if PositionData.SpriteType == 2 then PositionData.PrevSurf = true
				else PositionData.PrevSurf = false
				end
				if AnimationByte == 255 then
					if PositionData.Direction == 4 then AnimationByte = 0
					elseif PositionData.Direction == 3 then AnimationByte = 1
					elseif PositionData.Direction == 1 then AnimationByte = 2
					elseif PositionData.Direction == 2 then AnimationByte = 3
					end
				end
				local sprite = SpritesTable[PositionData.SpriteType][AnimationByte]
				if DebugMessages.Position then console:log("ANIM BYTE: " .. AnimationByte) end
				if sprite then
					if sprite.SpriteID > 0 then
						PositionData.Animation = sprite.SpriteID
						PositionData.Direction = sprite.Direction
					else
						if DebugMessages.Position then console:log("FALSE FLAG. BIKE NO: " .. PositionData.Bike) end
					end
				end
			else
				local anim = 255
				if PositionData.PrevSurf then anim = 1 end
				local sprite = SpritesTable[PositionData.SpriteType][anim][AnimationDirection]
				if DebugMessages.Position then console:log("ANIM BYTE: " .. anim .. " DIRECTION: " .. AnimationDirection) end
				if sprite then
					if sprite.SpriteID > 0 then
						PositionData.Animation = sprite.SpriteID
						PositionData.Direction = sprite.Direction
					else
						if DebugMessages.Position then console:log("FALSE FLAG. BIKE NO: " .. PositionData.Bike) end
					end
				end
			end
		end
	end
	if PositionData.PlayerMapIDPrev ~= PositionData.PlayerMapID then
		--New map
		ObjectLoaded = false
	end
	PositionData.PlayerMapIDPrev = PositionData.PlayerMapID
	local save_loc = 0
	if gAddress[GameID].sGameVersion ~= "RS" then
		save_loc = emu:read32(gAddress[GameID].gSaveBlock1Ptr)
	else
		save_loc = gAddress[GameID].gSaveBlock1Ptr --save pointer, RS is already pointed
	end
	PositionData.PlayerMapID = (emu:read8(save_loc+0x4)) | (emu:read8(save_loc+0x5) << 8) --0x4 and 0x5 is the map id
	PositionData.Weather = emu:read8(save_loc+0x2E)--0x2E is weather
	--console:log("POS: " .. PositionData.PlayerMapID .. " ADR: " .. save_loc)
	local CameraMax = 256
	local x, y = emu:read16(save_loc), emu:read16(save_loc+2)
	if x > 9999 then x = 0 end
	if y > 9999 then y = 0 end
	PositionData.CurrentCameraX = emu:read8(gAddress[GameID].gCameraX)
	PositionData.CurrentCameraY = emu:read8(gAddress[GameID].gCameraY)
	PositionData.CameraXPos = (CameraMax - PositionData.CurrentCameraX) % 16
	PositionData.CameraYPos = (CameraMax - PositionData.CurrentCameraY) % 16
	local bord_x = ROMCARD:read32(gAddress[GameID].gMapBorderX)
	local bord_y = ROMCARD:read32(gAddress[GameID].gMapBorderY)
	if bord_x > 9999 then bord_x = 9999 end
	if bord_y > 9999 then bord_y = 9999 end
	local TooBusyByte = emu:read8(gAddress[GameID].gLockControls)
	PositionData.isCrossingBorder = 0
	PositionData.BorderX = bord_x
	PositionData.BorderY = bord_y
	PositionData.PreviousX = PositionData.CurrentX
	PositionData.PreviousY = PositionData.CurrentY
	--if locked in script, use map pos instead of camera pos
	if TooBusyByte ~= 0 then
		PositionData.CurrentX = mapx - 7
		PositionData.CurrentY = mapy - 7
		PositionData.ActualX = x
		PositionData.ActualY = y
		if PositionData.CurrentX < 0 or PositionData.CurrentX > 9999 then PositionData.CurrentX = 0 end
		if PositionData.CurrentY < 0 or PositionData.CurrentY > 9999 then PositionData.CurrentY = 0 end
		PositionData.UseMapPos = true
	else
		PositionData.CurrentX = x
		PositionData.CurrentY = y
		PositionData.UseMapPos = false
	end
	
	MapConnectionTable = ROMCARD:read32(gAddress[GameID].gMapConnections)
	MapConnections = ROMCARD:read8(gAddress[GameID].gMapConnectionsAmount)
	PositionData.Connections = {
		MapConnectAmount = MapConnections
	}
	for i=1,MapConnections do
		local u32 DirectionAddr = (MapConnectionTable - 12) + (12 * i) 
		local u32 OffsetAddr = DirectionAddr + 4
		local u32 MapIDAddr = DirectionAddr + 8
		local OffsetNu = emu:read32(OffsetAddr)
		if OffsetNu > 4000000000 then
			OffsetCorrect = OffsetNu - 4294967296
		else
			OffsetCorrect = OffsetNu
		end
		PositionData.Connections[i] = {
			Direction = emu:read32(DirectionAddr),
			Offset = OffsetCorrect,
			MapID = emu:read32(MapIDAddr)
		}
	end
		
	if DebugMessages.Position then console:log("CURRENT BIKE: " .. PositionData.Bike .. " MAPID: " .. PositionData.PlayerMapID .. " X: " .. PositionData.CurrentX .. " Y: " .. PositionData.CurrentY .. " BorderX: " .. PositionData.BorderX .. " BorderY: " .. PositionData.BorderY .. " GENDER: " .. PositionData.Gender .. " ANIMDATA: " .. PositionData.AnimationData .. " CALLBACK: " .. Main .. " SpriteID: " .. PositionData.Animation) end
	return PositionData.CurrentX, PositionData.CurrentY, PositionData.Direction, PositionData.PlayerMapID, PositionData.Animation, PositionData.Gender, PositionData.SpriteType, PositionData.PlayerMapEntranceType, PositionData.BorderX, PositionData.BorderY, PositionData.Connections, PositionData.AnimationData, PositionData.Metatile
end

function IsInMenu()
	local Main = emu:read32(gAddress[GameID].gMainCallback)

	if Callback[GameID] then
		if Main ~= Callback[GameID].Field+1 then
			if Main == Callback[GameID].Battle+1 then
				if DebugMessages.Position then console:log("IN BATTLE. CURRENT CALLBACK: " .. Main) end
				return 2
			elseif Main == Callback[GameID].Pokemon+1 then
				if DebugMessages.Position then console:log("IN POKEMON MENU. CURRENT CALLBACK: " .. Main) end
				return 3
			elseif Main == Callback[GameID].Pokemon_Summary+1 then
				if DebugMessages.Position then console:log("IN POKEMON SUMMARY. CURRENT CALLBACK: " .. Main) end
				return 4
			elseif Main == Callback[GameID].Item+1 then
				if DebugMessages.Position then console:log("IN IITEM MENU. CURRENT CALLBACK: " .. Main) end
				return 5
			else
				if DebugMessages.Position then console:log("IN MENU. CURRENT CALLBACK: " .. Main) end
				return 1
			end
		end
	end
	
	return 0
end

-- While optimizing this code, I have come to the conclusion that my previous code was pretty bad. I mean, who makes everything global???
-- Actually, because of the poor choices I made at the start, I will now rewrite most of the code
function AnimatePlayerMovement(id, AnimateID, PreviousAnimateID, Gender, CurrentX, CurrentY, PreviousX, PreviousY, AnimationX, AnimationY, AnimationFrame, AnimationCycle, dx, dy, isAnimating, SurfFrame, SurfFrameMax, SpriteSize, InitialAnim, CurrentAnim)
	if DebugMessages.Animation then console:log("ID: " .. id .. " AnimateID: " .. AnimateID .. " Gender: " .. Gender .. " AnimationFrame: " .. AnimationFrame .. " AnimationCycle: " .. AnimationCycle .. " Current Anim: " .. CurrentAnim) end
	
	local frameMax = 0
	local canBeCut = false
	local pre_dx = CurrentX - PreviousX
	local pre_dy = CurrentY - PreviousY
	if (pre_dx ~= 0 or pre_dy ~= 0 or PreviousAnimateID ~= AnimateID) and isAnimating < 2 then canBeCut = true end
	if math.abs(dx) > 3 or math.abs(dy) > 3 then canBeCut = true end
	
	local function updateAnimation(dx, dy, chars1, chars2, chars3, speed)
		if AnimationFrame <= frameMax then
			AnimationX = AnimationX + dx
			AnimationY = AnimationY + dy
			AnimationX = (AnimationX >= 0 and math.min(AnimationX, 16)) or math.max(AnimationX, -16)
			AnimationY = (AnimationY >= 0 and math.min(AnimationY, 16)) or math.max(AnimationY, -16)

				
			if AnimationFrame >= 3 and AnimationFrame <= 11 and speed == 0 then
				AddDrawPlayer(id, AnimationCycle == 0 and chars1 or chars2, Gender)
			elseif AnimationFrame > 3 and speed == 1 then
				AddDrawPlayer(id, AnimationCycle == 0 and chars1 or chars2, Gender)
			elseif (AnimationFrame == 2 or AnimationFrame == 3) and speed == 2 then
				AddDrawPlayer(id, AnimationCycle == 0 and chars1 or chars2, Gender)
			elseif speed == 3 then
				AddDrawPlayer(id, AnimationCycle == 0 and chars1 or chars2, Gender)
				AddDrawPlayer(id, chars3, Gender)
			elseif AnimationFrame >= 2 and AnimationFrame <= 5 and speed == 4 then
				AddDrawPlayer(id, AnimationCycle == 0 and chars1 or chars2, Gender)
			else
				AddDrawPlayer(id, chars3, Gender)
			end
		else
			if DebugMessages.Animation then console:log("Animation is locked due to AnimationFrame being too high! " .. AnimationFrame) end
		end
	end

	local function updateAnimationFrame(initialchars, chars, cycle, initialcharspeed, charspeed)
		local cycle = cycle or 1
		local chartouse = (InitialAnim == 0 and initialchars) or chars or initialchars
		local charspeedtouse = (InitialAnim == 0 and initialcharspeed) or charspeed or initialcharspeed
		
		if charspeedtouse then
			AnimationX = AnimationX + (charspeedtouse.x and (charspeedtouse.x[AnimationFrame] or 0) or 0)
			AnimationY = AnimationY + (charspeedtouse.y and (charspeedtouse.y[AnimationFrame] or 0) or 0)
		else
			AnimationX = AnimationX + dx
			AnimationY = AnimationY + dy
		end
		
		local SpriteID = chartouse[cycle] or chartouse[1]
		if SpriteID then
			SpriteID = SpriteID[AnimationFrame] or SpriteID[1]
			AddDrawPlayer(id, SpriteID, Gender)
		end
		AnimationX = (AnimationX >= 0 and math.min(AnimationX, 16)) or math.max(AnimationX, -16)
		AnimationY = (AnimationY >= 0 and math.min(AnimationY, 16)) or math.max(AnimationY, -16)
	end
	
	if AnimationFrame < 0 then
		AnimationFrame = 0
	end
	
	if PreviousAnimateID ~= AnimateID and AnimateID > 16 and AnimateID < 25 and gAddress[GameID].sGameType == "FRLG" then SurfFrame = 0 AnimationCycle = 0 end
	
	if AnimateID > 16 and AnimateID < 25 and SurfFrameMax == 0 and gAddress[GameID].sGameType == "RSE" then
		SurfFrame = 0
		SurfFrameMax = 32
	elseif AnimateID > 16 and AnimateID < 25 and SurfFrameMax == 0 and gAddress[GameID].sGameType == "FRLG" then
		SurfFrame = 0
		SurfFrameMax = 46
	elseif SurfFrameMax ~= 0 and SurfFrameMax > SurfFrame then
		SurfFrame = SurfFrame + 1
	elseif SurfFrameMax ~= 0 then
		SurfFrame = 0
		AnimationCycle = 1 - AnimationCycle
	else
		SurfFrame = 0
		SurfFrameMax = 0
	end
	if AnimateID < 251 and AnimateID > 0 and AnimationFrame == 1 then
		if AnimateID < 17 or AnimateID > 24 then AnimationCycle = 1 - AnimationCycle end
	end
	
	if isAnimating == 0 or canBeCut then
		dx = CurrentX - PreviousX
		dy = CurrentY - PreviousY
		
		if math.abs(dx) > 3 or math.abs(dy) > 3 then
			-- If the position change is too large, we'll "teleport" instead of animate
			PreviousX = CurrentX
			PreviousY = CurrentY
			AnimationX = 0
			AnimationY = 0
			isAnimating = 0
		else
			isAnimating = 1
			AnimationFrame = 0
			if PreviousAnimateID ~= AnimateID then InitialAnim = 0 end
			CurrentAnim = AnimateID
		end
	end
		local animation = CurrentAnim
		if isAnimating == 1 then
			
			if animation == 10 then --Turn down
				isAnimating = 3
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, 0, 8, 9, 3, 4)
				
			elseif animation == 11 then --Turn up
				isAnimating = 3
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, 0, 6, 7, 2, 4)
				
			elseif animation == 12 then --Turn side
				isAnimating = 3
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, 0, 4, 5, 1, 4)
				
			elseif animation == 17 then --Surf down still
				isAnimating = 3
				frameMax = 48
				AnimationFrame = AnimationFrame + 1
				AddDrawPlayer(id, 34, Gender)
				AddDrawPlayer(id, AnimationCycle == 0 and 28 or 31, Gender)
				
			elseif animation == 18 then --Surf up still
				isAnimating = 3
				frameMax = 48
				AnimationFrame = AnimationFrame + 1
				AddDrawPlayer(id, 35, Gender)
				AddDrawPlayer(id, AnimationCycle == 0 and 29 or 32, Gender)
				
			elseif animation == 19 then --Surf left still
				isAnimating = 3
				frameMax = 48
				AnimationFrame = AnimationFrame + 1
				AddDrawPlayer(id, 36, Gender)
				AddDrawPlayer(id, AnimationCycle == 0 and 30 or 33, Gender)
				
			elseif animation == 20 then --Surf right still
				isAnimating = 3
				frameMax = 48
				AnimationFrame = AnimationFrame + 1
				AddDrawPlayer(id, 36, Gender)
				AddDrawPlayer(id, AnimationCycle == 0 and 30 or 33, Gender)
				
			elseif animation == 25 then --Wheelie start down still
				isAnimating = 3
				frameMax = 5
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = { [1] = 58, [2] = 58, [3] = 58, [4] = 58, [5] = 59 },
				}
				local chars = { [1] = { [1] = 59, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 26 then --Wheelie start up still
				isAnimating = 3
				frameMax = 5
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = { [1] = 62, [2] = 62, [3] = 62, [4] = 62, [5] = 63 },
				}
				local chars = { [1] = { [1] = 63, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 27 or animation == 28 then --Wheelie start side still
				isAnimating = 3
				frameMax = 5
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = { [1] = 54, [2] = 54, [3] = 54, [4] = 54, [5] = 55 },
				}
				local chars = { [1] = { [1] = 55, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 29 then --Wheelie end down still
				isAnimating = 3
				frameMax = 5
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = { [1] = 58, [2] = 58, [3] = 58, [4] = 58, [5] = 12 },
				}
				local chars = { [1] = { [1] = 12, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 30 then --Wheelie end up still
				isAnimating = 3
				frameMax = 5
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = { [1] = 62, [2] = 62, [3] = 62, [4] = 62, [5] = 11 },
				}
				local chars = { [1] = { [1] = 11, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 31 or animation == 32 then --Wheelie end side still
				isAnimating = 3
				frameMax = 5
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = { [1] = 54, [2] = 54, [3] = 54, [4] = 54, [5] = 10 },
				}
				local chars = { [1] = { [1] = 10, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 45 then --Jump in place down
				isAnimating = 3
				frameMax = 16
				AnimationFrame = AnimationFrame + 1
				local chars = { [1] = { [1] = 59, }, }
				local speed = { y = {-1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1} }
				updateAnimationFrame(initialchars, chars, 1, speed)
				AddDrawSprite(id, 3, 1003, 1, AnimationX * -1, AnimationY * -1) --shadow
				
			elseif animation == 46 then --Jump in place up
				isAnimating = 3
				frameMax = 16
				AnimationFrame = AnimationFrame + 1
				local chars = { [1] = { [1] = 63, }, }
				local speed = { y = {-1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1} }
				updateAnimationFrame(initialchars, chars, 1, speed)
				AddDrawSprite(id, 3, 1003, 1, AnimationX * -1, AnimationY * -1) --shadow
				
			elseif animation == 47 or animation == 48 then --Jump in place side
				isAnimating = 3
				frameMax = 16
				AnimationFrame = AnimationFrame + 1
				local chars = { [1] = { [1] = 55, }, }
				local speed = { y = {-1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1} }
				updateAnimationFrame(initialchars, chars, 1, speed)
				AddDrawSprite(id, 3, 1003, 1, AnimationX * -1, AnimationY * -1) --shadow
				
			elseif animation == 53 then --Throw pokemon out
				isAnimating = 3
				frameMax = 18
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = {
						[1] = 37, [2] = 37, [3] = 37, [4] = 37, [5] = 37, [6] = 38, [7] = 38, [8] = 38,
						[9] = 38, [10] = 39, [11] = 39, [12] = 39, [13] = 39, [14] = 40, [15] = 40, [16] = 40,
						[17] = 40, [18] = 41
					},
				}
				local chars = { [1] = { [1] = 41, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 54 then --Fishing down
				isAnimating = 3
				frameMax = 13
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = {
						[1] = 46, [2] = 46, [3] = 46, [4] = 46, [5] = 47, [6] = 47, [7] = 47, [8] = 47,
						[9] = 48, [10] = 48, [11] = 48, [12] = 48, [13] = 49,
					},
				}
				local chars = { [1] = { [1] = 49, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 55 then --Fishing up
				isAnimating = 3
				frameMax = 13
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = {
						[1] = 50, [2] = 50, [3] = 50, [4] = 50, [5] = 51, [6] = 51, [7] = 51, [8] = 51,
						[9] = 52, [10] = 52, [11] = 52, [12] = 52, [13] = 53,
					},
				}
				local chars = { [1] = { [1] = 53, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 56 or animation == 57 then --Fishing side
				isAnimating = 3
				frameMax = 13
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = {
						[1] = 42, [2] = 42, [3] = 42, [4] = 42, [5] = 43, [6] = 43, [7] = 43, [8] = 43,
						[9] = 44, [10] = 44, [11] = 44, [12] = 44, [13] = 45,
					},
				}
				local chars = { [1] = { [1] = 45, }, }
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 58 then --Fishing surfing down
				isAnimating = 3
				frameMax = 48
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = {
						[1] = 46, [2] = 46, [3] = 46, [4] = 46, [5] = 47, [6] = 47, [7] = 47, [8] = 47,
						[9] = 48, [10] = 48, [11] = 48, [12] = 48, [13] = 49,
					},
				}
				local chars = { [1] = { [1] = 49, }, }
				AddDrawPlayer(id, AnimationCycle == 0 and 28 or 31, Gender)
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 59 then --Fishing surfing up
				isAnimating = 3
				frameMax = 48
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = {
						[1] = 50, [2] = 50, [3] = 50, [4] = 50, [5] = 51, [6] = 51, [7] = 51, [8] = 51,
						[9] = 52, [10] = 52, [11] = 52, [12] = 52, [13] = 53,
					},
				}
				local chars = { [1] = { [1] = 53, }, }
				AddDrawPlayer(id, AnimationCycle == 0 and 29 or 32, Gender)
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif animation == 60 or animation == 61 then --Fishing surfing side
				isAnimating = 3
				frameMax = 48
				AnimationFrame = AnimationFrame + 1
				local initialchars = {
					[1] = {
						[1] = 42, [2] = 42, [3] = 42, [4] = 42, [5] = 43, [6] = 43, [7] = 43, [8] = 43,
						[9] = 44, [10] = 44, [11] = 44, [12] = 44, [13] = 45,
					},
				}
				local chars = { [1] = { [1] = 45, }, }
				AddDrawPlayer(id, AnimationCycle == 0 and 30 or 33, Gender)
				updateAnimationFrame(initialchars, chars, 1)
				
			elseif (animation >= 251 and animation <= 255) or animation == 0 then --No animation
				isAnimating = 0
				PreviousX = PreviousX + dx
				PreviousY = PreviousY + dy
				AnimationX = 0
				AnimationY = 0
				AnimationFrame = 0
				PreviousAnimateID = animation
				return PreviousAnimateID, CurrentX, CurrentY, PreviousX, PreviousY, AnimationX, AnimationY, AnimationFrame, AnimationCycle, dx, dy, isAnimating, SurfFrame, SurfFrameMax, SpriteSize, InitialAnim, CurrentAnim
			end
			if AnimationFrame >= frameMax and frameMax ~= 0 then
				InitialAnim = 1
			end
			if isAnimating == 3 then
				isAnimating = 1
				PreviousX = PreviousX + dx
				PreviousY = PreviousY + dy
				dx = 0
				dy = 0
			end
		end

	local function continueAnimation(dx, dy)
		if dx < 0 then
			--Left
			if animation == 3 then --Walk
				isAnimating = 2
				frameMax = 14
				AnimationFrame = AnimationFrame + 1
				updateAnimation(-1, 0, 4, 5, 1, 0)
				if AnimationFrame == 5 or AnimationFrame == 9 then
					AnimationX = AnimationX - 1
				end
				
			elseif animation == 6 then --Run
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(-4, 0, 20, 21, 19, 1)
				
			elseif animation == 9 then --Bike left
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 10, [2] = 13, [3] = 13, [4] = 13, [5] = 13, [6] = 10},
					[2] = { [1] = 10, [2] = 14, [3] = 14, [4] = 14, [5] = 14, [6] = 10},
				}
				local speed = { x = {-3, -3, -3, -4, -3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 23 then --Surf left
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(-4, 0, 30, 30, 36, 3)
				
			elseif animation == 35 then --Wheelie start left move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 54, [2] = 54, [3] = 54, [4] = 54, [5] = 55, [6] = 55, [7] = 55, [8] = 55 }, }
				local chars = {
					[1] = { [1] = 55, [2] = 56, [3] = 56, [4] = 56, [5] = 56, [6] = 55, [7] = 55, [8] = 55 },
					[2] = { [1] = 55, [2] = 57, [3] = 57, [4] = 57, [5] = 57, [6] = 55, [7] = 55, [8] = 55 },
				}
				local speed = { x = {-2, -2, -2, -2, -2, -2, -2, -2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 39 then --Wheelie left move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 55, [2] = 56, [3] = 56, [4] = 56, [5] = 56, [6] = 55, [7] = 55, [8] = 55 },
					[2] = { [1] = 55, [2] = 57, [3] = 57, [4] = 57, [5] = 57, [6] = 55, [7] = 55, [8] = 55 },
				}
				local speed = { x = {-2, -2, -2, -2, -2, -2, -2, -2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 43 then --Wheelie end left move
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 54, [2] = 54, [3] = 54, [4] = 54, [5] = 10, [6] = 10 }, }
				local chars = {
					[1] = { [1] = 10, [2] = 13, [3] = 13, [4] = 13, [5] = 13, [6] = 10},
					[2] = { [1] = 10, [2] = 14, [3] = 14, [4] = 14, [5] = 14, [6] = 10},
				}
				local speed = { x = {-3, -3, -3, -4, -3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 51 then --Jump left
				isAnimating = 2
				frameMax = 16
				AnimationFrame = AnimationFrame + 1
				local chars = { [1] = { [1] = 55, }, }
				local speed = { x = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1}, y = {-1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1} }
				updateAnimationFrame(initialchars, chars, 1, speed)
				if AnimationFrame < frameMax then
					AddDrawSprite(id, 3, 1003, 1, AnimationX * -1 - AnimationFrame, AnimationY * -1) --shadow
				else
					AddDrawSprite(id, 3, 1003, 1, 0, 0)
				end
				
			elseif animation == 64 then --Bike left mach
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 10, [2] = 13, [3] = 13, [4] = 13},
					[2] = { [1] = 10, [2] = 14, [3] = 14, [4] = 14},
				}
				local speed = { x = {-4} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
			end
		elseif dx > 0 then
			--Right
			if animation == 13 then --Walk
				isAnimating = 2
				frameMax = 14
				AnimationFrame = AnimationFrame + 1
				updateAnimation(1, 0, 4, 5, 1, 0)
				if AnimationFrame == 5 or AnimationFrame == 9 then
					AnimationX = AnimationX + 1
				end
			elseif animation == 14 then --Run
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(4, 0, 20, 21, 19, 1)
			elseif animation == 15 then --Bike right
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 10, [2] = 13, [3] = 13, [4] = 13, [5] = 14, [6] = 10},
					[2] = { [1] = 10, [2] = 14, [3] = 14, [4] = 14, [5] = 14, [6] = 10},
				}
				local speed = { x = {3, 3, 3, 4, 3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 24 then --Surf right
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(4, 0, 30, 30, 36, 3)
				
			elseif animation == 36 then --Wheelie start right move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 54, [2] = 54, [3] = 54, [4] = 54, [5] = 55, [6] = 55, [7] = 55, [8] = 55 }, }
				local chars = {
					[1] = { [1] = 55, [2] = 56, [3] = 56, [4] = 56, [5] = 56, [6] = 55, [7] = 55, [8] = 55 },
					[2] = { [1] = 55, [2] = 57, [3] = 57, [4] = 57, [5] = 57, [6] = 55, [7] = 55, [8] = 55 },
				}
				local speed = { x = {2, 2, 2, 2, 2, 2, 2, 2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 40 then --Wheelie right move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 55, [2] = 56, [3] = 56, [4] = 56, [5] = 56, [6] = 55, [7] = 55, [8] = 55 },
					[2] = { [1] = 55, [2] = 57, [3] = 57, [4] = 57, [5] = 57, [6] = 55, [7] = 55, [8] = 55 },
				}
				local speed = { x = {2, 2, 2, 2, 2, 2, 2, 2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 44 then --Wheelie end right move
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 54, [2] = 54, [3] = 54, [4] = 54, [5] = 10, [6] = 10 }, }
				local chars = {
					[1] = { [1] = 10, [2] = 13, [3] = 13, [4] = 13, [5] = 13, [6] = 10},
					[2] = { [1] = 10, [2] = 14, [3] = 14, [4] = 14, [5] = 14, [6] = 10},
				}
				local speed = { x = {3, 3, 3, 4, 3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 52 then --Jump right
				isAnimating = 2
				frameMax = 16
				AnimationFrame = AnimationFrame + 1
				local chars = { [1] = { [1] = 55, }, }
				local speed = { x = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, y = {-1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1} }
				updateAnimationFrame(initialchars, chars, 1, speed)
				if AnimationFrame < frameMax then
					AddDrawSprite(id, 3, 1003, 1, AnimationX * -1 + AnimationFrame, AnimationY * -1) --shadow
				else
					AddDrawSprite(id, 3, 1003, 1, 0, 0)
				end
				
			elseif animation == 65 then --Bike right mach
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 10, [2] = 13, [3] = 13, [4] = 13},
					[2] = { [1] = 10, [2] = 14, [3] = 14, [4] = 14},
				}
				local speed = { x = {4} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
			end
		end
		
		if dy < 0 then
			--Up
			if animation == 2 then --Walk
				isAnimating = 2
				frameMax = 14
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, -1, 6, 7, 2, 0)
				if AnimationFrame == 5 or AnimationFrame == 9 then
					AnimationY = AnimationY - 1
				end
				
			elseif animation == 5 then --Run
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, -4, 23, 24, 22, 1)
				
			elseif animation == 8 then --Bike up
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 11, [2] = 15, [3] = 15, [4] = 15, [5] = 15, [6] = 11},
					[2] = { [1] = 11, [2] = 16, [3] = 16, [4] = 16, [5] = 16, [6] = 11},
				}
				local speed = { y = {-3, -3, -3, -4, -3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 22 then --Surf up
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, -4, 29, 29, 35, 3)
				
			elseif animation == 34 then --Wheelie start up move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 62, [2] = 62, [3] = 62, [4] = 62, [5] = 63, [6] = 63, [7] = 63, [8] = 63 }, }
				local chars = {
					[1] = { [1] = 63, [2] = 64, [3] = 64, [4] = 64, [5] = 64, [6] = 63, [7] = 63, [8] = 63 },
					[2] = { [1] = 63, [2] = 65, [3] = 65, [4] = 65, [5] = 65, [6] = 63, [7] = 63, [8] = 63 },
				}
				local speed = { y = {-2, -2, -2, -2, -2, -2, -2, -2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 38 then --Wheelie up move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 63, [2] = 64, [3] = 64, [4] = 64, [5] = 64, [6] = 63, [7] = 63, [8] = 63 },
					[2] = { [1] = 63, [2] = 65, [3] = 65, [4] = 65, [5] = 65, [6] = 63, [7] = 63, [8] = 63 },
				}
				local speed = { y = {-2, -2, -2, -2, -2, -2, -2, -2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 42 then --Wheelie end up move
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 62, [2] = 62, [3] = 62, [4] = 62, [5] = 11, [6] = 11 }, }
				local chars = {
					[1] = { [1] = 11, [2] = 15, [3] = 15, [4] = 15, [5] = 15, [6] = 11},
					[2] = { [1] = 11, [2] = 16, [3] = 16, [4] = 16, [5] = 16, [6] = 11},
				}
				local speed = { y = {-3, -3, -3, -4, -3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 50 then --Jump up
				isAnimating = 2
				frameMax = 16
				AnimationFrame = AnimationFrame + 1
				local chars = { [1] = { [1] = 63, }, }
				local speed = { y = {-2, -3, -3, -3, -3, -2, -2, -2, -1, -1, 0, 0, 1, 1, 1, 3} }
				updateAnimationFrame(initialchars, chars, 1, speed)
				if AnimationFrame < frameMax then
					AddDrawSprite(id, 3, 1003, 1, AnimationX * -1, AnimationY * -1 - AnimationFrame) --shadow
				else
					AddDrawSprite(id, 3, 1003, 1, 0, 0)
				end
				
			elseif animation == 63 then --Bike up mach
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 11, [2] = 15, [3] = 15, [4] = 15},
					[2] = { [1] = 11, [2] = 16, [3] = 16, [4] = 16},
				}
				local speed = { y = {-4} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
			end
			
		elseif dy > 0 then
			--Down
			if animation == 1 then --Walking
				isAnimating = 2
				frameMax = 14
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, 1, 8, 9, 3, 0)
				if AnimationFrame == 5 or AnimationFrame == 9 then
					AnimationY = AnimationY + 1
				end
			elseif animation == 4 then --Running
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, 4, 26, 27, 25, 1)
				
			elseif animation == 7 then --Bike down
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 12, [2] = 17, [3] = 17, [4] = 17, [5] = 17, [6] = 12},
					[2] = { [1] = 12, [2] = 18, [3] = 18, [4] = 18, [5] = 18, [6] = 12},
				}
				local speed = { y = {3, 3, 3, 4, 3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 21 then --Surf down
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				updateAnimation(0, 4, 28, 28, 34, 3)
				
			elseif animation == 33 then --Wheelie start down move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 58, [2] = 58, [3] = 58, [4] = 58, [5] = 59, [6] = 59, [7] = 59, [8] = 59 }, }
				local chars = {
					[1] = { [1] = 59, [2] = 60, [3] = 60, [4] = 60, [5] = 60, [6] = 59, [7] = 59, [8] = 59 },
					[2] = { [1] = 59, [2] = 61, [3] = 61, [4] = 61, [5] = 61, [6] = 59, [7] = 59, [8] = 59 },
				}
				local speed = { y = {2, 2, 2, 2, 2, 2, 2, 2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 37 then --Wheelie down move
				isAnimating = 2
				frameMax = 8
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 59, [2] = 60, [3] = 60, [4] = 60, [5] = 60, [6] = 59, [7] = 59, [8] = 59 },
					[2] = { [1] = 59, [2] = 61, [3] = 61, [4] = 61, [5] = 61, [6] = 59, [7] = 59, [8] = 59 },
				}
				local speed = { y = {2, 2, 2, 2, 2, 2, 2, 2} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
			
			elseif animation == 41 then --Wheelie end down move
				isAnimating = 2
				frameMax = 6
				AnimationFrame = AnimationFrame + 1
				local initialchars = { [1] = { [1] = 58, [2] = 58, [3] = 58, [4] = 58, [5] = 12, [6] = 12 }, }
				local chars = {
					[1] = { [1] = 12, [2] = 17, [3] = 17, [4] = 17, [5] = 17, [6] = 12},
					[2] = { [1] = 12, [2] = 18, [3] = 18, [4] = 18, [5] = 18, [6] = 12},
				}
				local speed = { y = {3, 3, 3, 4, 3} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
				
			elseif animation == 49 then --Jump down
				isAnimating = 2
				frameMax = 16
				AnimationFrame = AnimationFrame + 1
				local chars = { [1] = { [1] = 59, }, }
				local speed = { y = {0, -1, -1, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2} }
				updateAnimationFrame(initialchars, chars, 1, speed)
				if AnimationFrame < frameMax then
					AddDrawSprite(id, 3, 1003, 1, AnimationX * -1, AnimationY * -1 + AnimationFrame) --shadow
				else
					AddDrawSprite(id, 3, 1003, 1, 0, 0)
				end
			
			elseif animation == 62 then --Bike down mach
				isAnimating = 2
				frameMax = 4
				AnimationFrame = AnimationFrame + 1
				local chars = {
					[1] = { [1] = 12, [2] = 17, [3] = 17, [4] = 17},
					[2] = { [1] = 12, [2] = 18, [3] = 18, [4] = 18},
				}
				local speed = { y = {4} }
				updateAnimationFrame(initialchars, chars, AnimationCycle + 1, speed)
			end
		end
		if AnimationFrame >= frameMax then
			isAnimating = 0
			PreviousX = PreviousX + dx
			PreviousY = PreviousY + dy
			AnimationX = 0
			AnimationY = 0
			AnimationFrame = 0
		end
	end

		
	if isAnimating > 0 then
		continueAnimation(dx, dy)
	end
	
	PreviousAnimateID = animation
	
	return PreviousAnimateID, CurrentX, CurrentY, PreviousX, PreviousY, AnimationX, AnimationY, AnimationFrame, AnimationCycle, dx, dy, isAnimating, SurfFrame, SurfFrameMax, SpriteSize, InitialAnim, CurrentAnim
end

function HandleSprite(id, Animation, Gender, animate, menu, tile)
	local AnimateID = 0
	
	--stand still
	if Animation == 1 then AddDrawPlayer(id,3,Gender) AnimateID = 251
	elseif Animation == 2 then AddDrawPlayer(id,2,Gender) AnimateID = 252
	elseif Animation == 3 then AddDrawPlayer(id,1,Gender) AnimateID = 253
	elseif Animation == 4 then AddDrawPlayer(id,1,Gender) AnimateID = 254
	
	--walking
	elseif Animation == 5 then AnimateID = 1
	elseif Animation == 6 then AnimateID = 2
	elseif Animation == 7 then AnimateID = 3
	elseif Animation == 8 then AnimateID = 13
	
	--turning
	elseif Animation == 9 then AnimateID = 10
	elseif Animation == 10 then AnimateID = 11
	elseif Animation == 11 then AnimateID = 12
	elseif Animation == 12 then AnimateID = 12
	
	--running
	elseif Animation == 13 then AnimateID = 4
	elseif Animation == 14 then AnimateID = 5
	elseif Animation == 15 then AnimateID = 6
	elseif Animation == 16 then AnimateID = 14
	
	--bike still
	elseif Animation == 17 then AddDrawPlayer(id,12,Gender) AnimateID = 251
	elseif Animation == 18 then AddDrawPlayer(id,11,Gender) AnimateID = 252
	elseif Animation == 19 then AddDrawPlayer(id,10,Gender) AnimateID = 253
	elseif Animation == 20 then AddDrawPlayer(id,10,Gender) AnimateID = 254
	
	--bike slow moving
	elseif Animation == 21 then AnimateID = 7
	elseif Animation == 22 then AnimateID = 8
	elseif Animation == 23 then AnimateID = 9
	elseif Animation == 24 then AnimateID = 15
	
	--bike fast move
	elseif Animation == 25 then AnimateID = 7
	elseif Animation == 26 then AnimateID = 8
	elseif Animation == 27 then AnimateID = 9
	elseif Animation == 28 then AnimateID = 15
	
	--bike hit wall
	elseif Animation == 29 then AddDrawPlayer(id,12,Gender) AnimateID = 251
	elseif Animation == 30 then AddDrawPlayer(id,11,Gender) AnimateID = 252
	elseif Animation == 31 then AddDrawPlayer(id,10,Gender) AnimateID = 253
	elseif Animation == 32 then AddDrawPlayer(id,10,Gender) AnimateID = 254
	
	--surf still
	elseif Animation == 33 then AnimateID = 17
	elseif Animation == 34 then AnimateID = 18
	elseif Animation == 35 then AnimateID = 19
	elseif Animation == 36 then AnimateID = 20
	
	--surf moving
	elseif Animation == 37 then AnimateID = 21
	elseif Animation == 38 then AnimateID = 22
	elseif Animation == 39 then AnimateID = 23
	elseif Animation == 40 then AnimateID = 24
	
	--wheelie starting no movement
	elseif Animation == 41 then AnimateID = 25
	elseif Animation == 42 then AnimateID = 26
	elseif Animation == 43 then AnimateID = 27
	elseif Animation == 44 then AnimateID = 28
	
	--wheelie current no movement
	elseif Animation == 45 then AddDrawPlayer(id,59,Gender) AnimateID = 251
	elseif Animation == 46 then AddDrawPlayer(id,63,Gender) AnimateID = 252
	elseif Animation == 47 then AddDrawPlayer(id,55,Gender) AnimateID = 253
	elseif Animation == 48 then AddDrawPlayer(id,55,Gender) AnimateID = 254
	
	--wheelie down no movement
	elseif Animation == 49 then AnimateID = 29
	elseif Animation == 50 then AnimateID = 30
	elseif Animation == 51 then AnimateID = 31
	elseif Animation == 52 then AnimateID = 32
	
	--wheelie starting movement
	elseif Animation == 53 then AnimateID = 33
	elseif Animation == 54 then AnimateID = 34
	elseif Animation == 55 then AnimateID = 35
	elseif Animation == 56 then AnimateID = 36
	
	--wheelie current movement
	elseif Animation == 57 then AnimateID = 37
	elseif Animation == 58 then AnimateID = 38
	elseif Animation == 59 then AnimateID = 39
	elseif Animation == 60 then AnimateID = 40
	
	--wheelie down movement
	elseif Animation == 61 then AnimateID = 41
	elseif Animation == 62 then AnimateID = 42
	elseif Animation == 63 then AnimateID = 43
	elseif Animation == 64 then AnimateID = 44
	
	--wheelie jumping no movement
	elseif Animation == 65 then AnimateID = 45
	elseif Animation == 66 then AnimateID = 46
	elseif Animation == 67 then AnimateID = 47
	elseif Animation == 68 then AnimateID = 48
	
	--wheelie jumping movement
	elseif Animation == 69 then AnimateID = 49
	elseif Animation == 70 then AnimateID = 50
	elseif Animation == 71 then AnimateID = 51
	elseif Animation == 72 then AnimateID = 52
	
	--throwing pokemon out
	elseif Animation == 80 then AnimateID = 53
	
	--fishing
	elseif Animation == 81 then AnimateID = 54
	elseif Animation == 82 then AnimateID = 55
	elseif Animation == 83 then AnimateID = 56
	elseif Animation == 84 then AnimateID = 57
	
	--fishing surfing
	elseif Animation == 85 then AnimateID = 58
	elseif Animation == 86 then AnimateID = 59
	elseif Animation == 87 then AnimateID = 60
	elseif Animation == 88 then AnimateID = 61
	
	--mach bike
	elseif Animation == 89 then AnimateID = 62
	elseif Animation == 90 then AnimateID = 63
	elseif Animation == 91 then AnimateID = 64
	elseif Animation == 92 then AnimateID = 65
	
	elseif Animation == 0 then AnimateID = animate
	else AnimateID = animate
	end
	
	if menu == 2 then --Battle
		AddDrawSprite(id, 3, 1000, 1) --Fighting Symbol
	elseif menu == 3 or menu == 4 then --Pokemon Menu / Summary
		AddDrawSprite(id, 3, 1001, 1) --Pokeball Symbol
	elseif menu == 5 then --Item Menu
		AddDrawSprite(id, 3, 1002, 1) --Bag Symbol
	end
	if tile == 0x28 then
		AddDrawSprite(id, 2, 1004, 1) --Hot springs
	elseif tile == 0x3 then
		AddDrawSprite(id, 2, 1005, 1) --Tall grass
	end
	return AnimateID
end

function CalculateRelative(OtherGameID, CurrentX, CurrentY, PreviousX, PreviousY, AnimationX, AnimationY, MapID, PreviousMapID, PreviousMapX, PreviousMapY, BorderX, BorderY, PlayerX, PlayerY, PlayerDirection, PlayerMapID, PlayerPrevMapID, PlayerMapDirection, MapDirection, CameraX, CameraY, Entrance, PlayerEntrance, PlayerMapPrevX, PlayerMapPrevY, PlayerBorderX, PlayerBorderY, Accountable, PlayerConnections, PlayerGameID, MatchBanks)
	local AnimationX = AnimationX
	local AnimationY = AnimationY
	--console:log("X: " .. CurrentX .. " Y: " .. CurrentY)
	if PositionData.AnimationData > 0 then
		return 0, 0, 0, 0, 0, 0
	end
	
	--if in script, calculate relative position of where actual player is
	local TooBusyByte = emu:read8(gAddress[GameID].gLockControls)
	if PositionData.UseMapPos and TooBusyByte then
		local relx = PositionData.CurrentX - PositionData.ActualX
		local rely = PositionData.CurrentY - PositionData.ActualY
		AnimationX = AnimationX + (relx*16)
		AnimationY = AnimationY + (rely*16)
	end
	
	local OtherPlayerGame = "None"
	local YourGame = gAddress[PlayerGameID].sGameType
	MatchBanks = false
	local FRLG_Games = {BPR1 = true, BPR2 = true, BPG1 = true, BPG2 = true, BPRJ = true, BPGJ = true, BPRF = true, BPGF = true, BPRS = true, BPGS = true, BPRD = true, BPGD = true, BPRI = true, BPGI = true}
	local RSE_Games = {BPEE = true, BPEJ = true, BPEF = true, BPES = true, BPED = true, BPEI = true, AXV1 = true, AXV2 = true, AXP1 = true, AXP2 = true, AXVJ = true, AXPJ = true, AXVF = true, AXPF = true, AXVS = true, AXPS = true, AXVD = true, AXPD = true, AXVI = true, AXPI = true}

	if FRLG_Games[OtherGameID] then OtherPlayerGame = "FRLG" end
	if RSE_Games[OtherGameID] then OtherPlayerGame = "RSE" end

	if PartialSeperateGames then
		if MapBanks[YourGame] and MapBanks[OtherPlayerGame] then
			local PlayerMap, PlayerLocation = findMapName(MapBanks[YourGame], PlayerMapID)
			local Map, Location = findMapName(MapBanks[OtherPlayerGame], MapID)
			if PlayerMap and PlayerLocation and Map and Location then
				if PlayerMap == "Pokecenter_Entrance" and Map == "Pokecenter_Entrance" then
					MatchBanks = true
					if DebugMessages.Position then console:log("Pokecenter_Entrance") end
				elseif PlayerMap == "Pokecenter_First_Floor" and Map == "Pokecenter_First_Floor" then
					MatchBanks = true
					if DebugMessages.Position then console:log("Pokecenter_First_Floor") end
				elseif PlayerMap == "Shop" and Map == "Shop" then
					MatchBanks = true
					if DebugMessages.Position then console:log("Shop") end
				end
			end
		end
	end
		
	if SeperateGames and not MatchBanks then
		if YourGame ~= OtherPlayerGame then
			if DebugMessages.Render then
				console:log("Different game. Your game: " .. YourGame .. " their game: " .. OtherPlayerGame)
			end
			return 0, 0, 0, 0, 0, 0
		end
	end
	
	local RelativeX, RelativeY = 0, 0
	
	if DebugMessages.Render then console:log("CAMERAX: " .. PositionData.CurrentCameraX .. " CAMERAY: " .. PositionData.CurrentCameraY) end
	
	local CameraMax = 256
	
	local dx = PositionData.CameraXPos
	local dy = PositionData.CameraYPos
	local Visible = 0
	 --Route jumping causes camera glitch
	if PositionData.AnimationByte == 12 and dy == 0 and PositionData.PreviousY ~= PositionData.CurrentY then
		dy = 17
	elseif PositionData.AnimationByte == 13 and dy == 0 and PositionData.PreviousY ~= PositionData.CurrentY then
		dy = -17
	elseif PositionData.AnimationByte == 14 and dx == 0 and PositionData.PreviousX ~= PositionData.CurrentX then
		dx = -17
	elseif PositionData.AnimationByte == 15 and dx == 0 and PositionData.PreviousX ~= PositionData.CurrentX then
		dx = 17
	end
	local dx_test = (CameraMax - PositionData.CurrentCameraX) % 16
	local dy_test = (CameraMax - PositionData.CurrentCameraY) % 16
	if PlayerDirection == 1 and dx_test ~= 0 then
		dx = -16 + dx
	elseif PlayerDirection == 3 and dy_test ~= 0 then
		dy = -16 + dy
	end
	
	if MapID == PlayerMapID or MatchBanks then
		RelativeX = (PreviousX - PlayerX) * 16 + AnimationX + dx
		RelativeY = (PreviousY - PlayerY) * 16 + AnimationY + dy
		Visible = 1
	else
		--NEED LATER
		if PlayerConnections.MapConnectAmount then
			if PlayerConnections.MapConnectAmount > 0 then
				for i=1,PlayerConnections.MapConnectAmount do
					if MapID == PlayerConnections[i].MapID then
						if PlayerConnections[i].Direction == 1 then --down from player
							PosX = PreviousX + PlayerConnections[i].Offset
							PosY = PreviousY + PlayerBorderY
							if DebugMessages.Position then console:log("CONNECTION SOUTH! Y: " .. PosY .. " PLAYER Y: " .. PlayerY) end
							Visible = 1
							RelativeX = (PosX - PlayerX) * 16 + AnimationX + dx
							RelativeY = (PosY - PlayerY) * 16 + AnimationY + dy
							if DebugMessages.Position then console:log("RELATIVE Y: " .. RelativeY) end
						elseif PlayerConnections[i].Direction == 2 then --up from player
							PosX = PreviousX + PlayerConnections[i].Offset
							PosY = PreviousY - BorderY
							if DebugMessages.Position then console:log("CONNECTION NORTH! Y: " .. PosY .. " PLAYER Y: " .. PlayerY) end
							Visible = 1
							RelativeX = (PosX - PlayerX) * 16 + AnimationX + dx
							RelativeY = (PosY - PlayerY) * 16 + AnimationY + dy
							if DebugMessages.Position then console:log("RELATIVE Y: " .. RelativeY) end
						elseif PlayerConnections[i].Direction == 3 then --left from player
							PosX = PreviousX - BorderX
							PosY = PreviousY + PlayerConnections[i].Offset
							Visible = 1
							RelativeX = (PosX - PlayerX) * 16 + AnimationX + dx
							RelativeY = (PosY - PlayerY) * 16 + AnimationY + dy
						elseif PlayerConnections[i].Direction == 4 then --right from player
							PosX = PreviousX + PlayerBorderX
							PosY = PreviousY + PlayerConnections[i].Offset
							Visible = 1
							RelativeX = (PosX - PlayerX) * 16 + AnimationX + dx
							RelativeY = (PosY - PlayerY) * 16 + AnimationY + dy
						end
					end
				end
			end
		end
	end
--	console:log("RELATIVE X: " .. RelativeX .. " PREV X: " .. PreviousX .. " PLAYER X: " .. PlayerX .. " dx: " .. dx .. " RELATIVE Y: " .. RelativeY .. " PREV Y: " .. PreviousY .. " PLAYER X: " .. PlayerY .. " dy: " .. dy)
	return RelativeX, RelativeY, Visible, MatchBanks
end

function AddDrawPlayer(id, AnimationID, GenderID)
	local AnimationTableID = gAddress[GameID].sAnimationTable
	local playerIDNum = playerIDNum or 0
	if GenderID == 1 then
		AnimationTableID = AnimationTableID + 1
	end
	local SpriteSizeID = "16x32"
	local SpriteSlotID = 1
	local Sprite = spriteData[AnimationTableID]
	if Sprite then
		if Sprite[AnimationID] then
			SpriteSizeID = Sprite[AnimationID].Size
			SpriteSlotID = Sprite[AnimationID].Slot
		end
	end
	local drawplayertableitem = {
		Animation = AnimationID,
		AnimationTable = AnimationTableID,
		Gender = GenderID,
		SpriteSize = SpriteSizeID,
		SpriteSlot = SpriteSlotID,
	}
	if not drawplayertable[id] then
		drawplayertable[id] = {}
	end
	table.insert(drawplayertable[id], drawplayertableitem)
end

function CreatePlayer(id, tileset)
	local AnimationTable = gAddress[GameID].sAnimationTable
	if drawplayertable[id] then
		for _, item in ipairs(drawplayertable[id]) do
			local anim = AnimationTable
			if item.Gender == 1 then
				anim = anim + 1
			end
			createChars(tileset, anim, item.Animation)
		end
	end
end

function AddDrawSprite(id, pos, AnimationTableID, AnimationID, xoffsetID, yoffsetID)
	local SpriteSizeID = "16x16"
	local SpriteSlotID = 3
	local Sprite = spriteData[AnimationTableID]
	if Sprite then
		if Sprite[AnimationID] then
			SpriteSizeID = Sprite[AnimationID].Size
			SpriteSlotID = Sprite[AnimationID].Slot
		end
	end
	local drawspritetableitem = {
		Animation = AnimationID,
		AnimationTable = AnimationTableID,
		SpriteSize = SpriteSizeID,
		SpriteSlot = SpriteSlotID,
		x = xoffsetID,
		y = yoffsetID
	}
	if not drawspritetable[id] then
		drawspritetable[id] = {}
	end
	if not drawspritetable[id][pos] then
		drawspritetable[id][pos] = {}
	end
	drawspritetable[id][pos] = drawspritetableitem
end

function GetDrawSpriteOffsets(pos)
	local x = 0
	local y = 0
	if drawspritetable[id] then
		if drawspritetable[id][pos] then
			if drawspritetable[id][pos].x then x = drawspritetable[id][pos].x end
			if drawspritetable[id][pos].y then y = drawspritetable[id][pos].y end
		end
	end
	return x, y
end

function RefreshDrawSprite(id, pos)
	if drawspritetable[id] then
		if drawspritetable[id][pos] then
			drawspritetable[id][pos] = nil
		end
	end
end

function CreateSprite(id, tileset)
	if drawspritetable[id] then
		for pos, sprite in pairs(drawspritetable[id]) do
			if sprite then
			--	console:log("ID: " .. id .. " POS: " .. pos .. " TAB: " .. sprite.AnimationTable .. " AN: " .. sprite.Animation)
				createChars(tileset, sprite.AnimationTable, sprite.Animation)
			end
		end
	end
end	

function AddRenderPlayer(id, OtherGameID2, DrawX2, DrawY2, Animation2, Gender2, SpriteType2, Direction2, Visible2, AnimationFrame2, AnimationCycle2, SurfFrame2, AnimationData2)
	--console:log("ADD PLAYER " .. id .. " TO RENDER. DrawX: " .. DrawX2 .. " DRAWY: " .. DrawY2)
	local FinalX = DrawX2 + 112
	local FinalY = DrawY2 + 56
	local renderplayertableitem = {
		OtherGameID = OtherGameID2,
		FinalMapX = FinalX,
		FinalMapY = FinalY,
		SpriteType = SpriteType2,
		Direction = Direction2,
		Visible = Visible2,
		AnimationFrame = AnimationFrame2,
		AnimationCycle = AnimationCycle2,
		SurfFrame = SurfFrame2,
		AnimationData = AnimationData2,
	}
	renderplayertable[id] = renderplayertableitem
end

function HasAnimationInRange(animstart, animend)
	for id, items in pairs(drawplayertable) do
		for _, item in ipairs(items) do
		--	console:log("ANIM: " .. item.Animation)
			if item.Animation >= animstart and item.Animation <= animend then
				return true
			end
		end
	end
	return false
end

function GetAnimationSlot(id, pos)
	if drawspritetable[id] then
		if drawspritetable[id][pos] then
			return drawspritetable[id][pos].Animation
		end
	end
	if drawplayertable then
		for key, playerData in pairs(drawplayertable) do
			if playerData then
				if key == id then
					for _, item in ipairs(playerData) do
						if item.SpriteSlot == pos then
							return item.Animation
						end
					end
				end
			end
		end
	end
	return 0
end

function GetAnimationTableSlot(id, pos)
	if drawspritetable[id] then
		if drawspritetable[id][pos] then
			return drawspritetable[id][pos].AnimationTable
		end
	end
	if drawplayertable then
		for key, playerData in pairs(drawplayertable) do
			if playerData then
				if key == id then
					for _, item in ipairs(playerData) do
						if item.SpriteSlot == pos then
							return item.AnimationTable
						end
					end
				end
			end
		end
	end
	return 0
end

function GetAnimationSizeSlot(id, pos)
	if drawspritetable[id] then
		if drawspritetable[id][pos] then
			return drawspritetable[id][pos].SpriteSize
		end
	end
	if drawplayertable then
		for key, playerData in pairs(drawplayertable) do
			if playerData then
				if key == id then
					for _, item in ipairs(playerData) do
						if item.SpriteSlot == pos then
							return item.SpriteSize
						end
					end
				end
			end
		end
	end
	return "16x32"
end

function GetSlotUsed(id, pos)
	if drawspritetable[id] then
		if drawspritetable[id][pos] then
			return true
		end
	end
	if drawplayertable then
		for key, playerData in pairs(drawplayertable) do
			if playerData then
				if key == id then
					for _, item in ipairs(playerData) do
						if item.SpriteSlot == pos then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

function RefreshRenderPlayer()
	previousdrawplayertable = drawplayertable
	drawplayertable = {}
	renderplayertable = {}
end

function DynamicRender()
	if DebugMessages.Render then console:log("DYNAMIC RENDER START") end
	local MaxDraw = DrawPlayerCount
	if Experimental_Features then
		if ObjectInUse > 0 then
			for i=1, ObjectInUse do
				local npc = FindNPCByID(i)
				if npc then npc:Remove() end
			end
			ObjectInUse = 0
		end
	end
	for i, player in pairs(players) do
		local PlayerBarrier = {
			MinX = -48,
			MaxX = 256,
			MinY = -48,
			MaxY = 160,
		}
		id = player:GetID()
		if not drawplayertable[id] and previousdrawplayertable[id] then drawplayertable[id] = previousdrawplayertable[id] end
		if DebugMessages.Render then console:log("DYNAMIC RENDER PLAYER " .. id .. " START") end
		if drawplayertable[id] and renderplayertable[id] and PlayerID ~= id then
			local FinalMapX = renderplayertable[id].FinalMapX
			local FinalMapY = renderplayertable[id].FinalMapY
			local SlotSize = GetAnimationSizeSlot(id, 1)
		--	console:log("CAN SEE. VIS: " .. renderplayertable[i].Visible)
			if IDsToDraw < MaxDraw and renderplayertable[id].Visible == 1 and not (FinalMapX > PlayerBarrier.MaxX or FinalMapX < PlayerBarrier.MinX or FinalMapY > PlayerBarrier.MaxY or FinalMapY < PlayerBarrier.MinY) then
				if FinalMapX < 0 then FinalMapX = FinalMapX + 511 end
				if FinalMapY < 0 then FinalMapY = FinalMapY + 256 end
				if DebugMessages.Render then console:log("FOUND PLAYER " .. id .. " NEARBY. DRAWING AS ID " .. IDsToDraw) end
				CreatePlayer(id, IDsToDraw)
				CreateSprite(id, IDsToDraw)
				if DebugMessages.Render then console:log("ANIMATION DATA OF PLAYER " .. id .. ": " .. renderplayertable[id].AnimationData) end
				DrawPlayer(IDsToDraw, FinalMapX, FinalMapY, renderplayertable[id].SpriteType, renderplayertable[id].Direction, renderplayertable[id].AnimationFrame, renderplayertable[id].AnimationCycle, renderplayertable[id].SurfFrame, renderplayertable[id].AnimationData, id)
				IDsToDraw = IDsToDraw + 1
			end
		elseif drawplayertable[id] and renderplayertable[id] then
			if DebugMessages.Render then console:log("PLAYER " .. i .. " HAS DATA. PLAYERID: " .. PlayerID .. " PLAYER " .. i .. " ID: " .. player:GetID()) end
		end
	end
	local player = FindPlayerByID(PlayerID)
	if Experimental_Features then
		if NPCs and player then
			local PlayerBarrier = {
				MinX = -48,
				MaxX = 256,
				MinY = -48,
				MaxY = 160,
			}
			for i, npc in pairs(NPCs) do
				local X, Y, Map, direction = npc:GetInfo()
				local PlayerX, PlayerY, PlayerDirection, PlayerMapID, _, _, _, PlayerMapDirection, PlayerPrevMapID, PlayerMapEntrance, PlayerMapPrevX, PlayerMapPrevY, PlayerBorderX, PlayerBorderY, PlayerConnections, PlayerGameID, AnimationData = player:GetPosition()
				if PlayerMapID == Map then
					local DrawX, DrawY, Visible, _ = CalculateRelative(PlayerGameID, X, Y, X, Y, 0, 0, Map, Map, PlayerBorderX, PlayerBorderY, PlayerBorderX, PlayerBorderY, PlayerX, PlayerY, PlayerDirection, PlayerMapID, PlayerPrevMapID, PlayerMapDirection, PlayerMapDirection, 0, 0, PlayerMapEntrance, PlayerMapEntrance, PlayerMapPrevX, PlayerMapPrevY, PlayerBorderX, PlayerBorderY, 0, PlayerConnections, PlayerGameID, false)
					local FinalMapX = DrawX + 112
					local FinalMapY = DrawY + 56
					if IDsToDraw < MaxDraw and Visible == 1 and not (FinalMapX > PlayerBarrier.MaxX or FinalMapX < PlayerBarrier.MinX or FinalMapY > PlayerBarrier.MaxY or FinalMapY < PlayerBarrier.MinY) then
						ObjectInUse = ObjectInUse + 1
				--		console:log("FINAL MAPX: " .. FinalMapX)
						if FinalMapX < 0 then FinalMapX = FinalMapX + 511 end
						if FinalMapY < 0 then FinalMapY = FinalMapY + 256 end
						npc:Update(ObjectInUse)
						local size, palette = npc:SetupGraphics(IDsToDraw)
						DrawPlayer(IDsToDraw, FinalMapX, FinalMapY, 0, direction, 0, 0, 0, 0, 9999, "16x32", palette)
						IDsToDraw = IDsToDraw + 1
					end
				end
			--	console:log("FINAL MAP X: " .. FinalMapX .. " FINAL MAP Y: " .. FinalMapY .. " VIS: " .. Visible .. " MAP: " .. Map .. " PLAYERMAP: " .. PlayerMapID)
			end
		end
	end
	for i = 1, MaxDraw do
		if i > IDsToDraw then
			-- Too many messages
			--console:log("ERASING ID " .. i)
			ErasePlayer(i - 1)
		end
	end
	RefreshRenderPlayer()
end

function DrawPlayer(id, FinalMapX, FinalMapY, SpriteType, Direction, AnimationFrame, AnimationCycle, SurfFrame, MenuType, RealID, SizeOpt, PaletteOpt)
		
		local PlayerAddress = gAddress[GameID].gSprite - (id * 24)
		--UNUSED
		local PaletteAddress = 0x5000200
		--local PaletteFRLG = {1532973838, 979061535, 1025974543, 681783525, 2006654082, 709442350, 555232671, 32767}
		--local PaletteRSE = {569725424, 979061535, 1762140431, 1653488871, 2143098029, 633301718, 796859640, 7799}
		--local PaletteUse = {}
		--2608 = 190 = 0000101000110000
		--First 4 bits are palette, next 2 are priority, then the rest is the sprite bank. 560 is tile 190 in sprite bank.
		local Bank = 480 - (id * 48)
		--Palette is 4 bits. 0-F = 0-15 (16 palettes). DO NOT GO ABOVE 16!!! -1 means it will not use a custom palette
		local Palette = 0
		if PaletteOpt then Palette = PaletteOpt end
		--2 bits. Can be 0-2. 0 = drawn first, 1 = drawn same prio as player, 2 = drawn last
		local Priority = 2
		local Palette2 = 0
		local isHotSprings = 0
		if RealID then
			if RealID < 9999 then
				local drawplayer = FindPlayerByID(RealID)
				local tile = drawplayer:GetMetaTile()
				local height = drawplayer:GetElevation() & 0xF
				
				if gAddress[GameID].sGameType == "RSE" then
					--hot springs
					if GetAnimationSizeSlot(RealID, 1) ~= "32x32" then
						if tile == 0x28 and GetAnimationTableSlot(RealID, 2) == 1004 then
							Palette2 = 14
							isHotSprings = 8
							--apply palette to 14 while other player is on screen if a different palette is loaded
							ApplyPalette(ActualPalette["RSE"].Hot_Springs, 14)
						--tall grass
						elseif tile == 0x3 and GetAnimationTableSlot(RealID, 2) == 1005 then
							Palette2 = 14
							isHotSprings = 8
							--apply palette to 14 while other player is on screen
							ApplyPalette(ActualPalette["RSE"].Tall_Grass, 14)
						end
					end
					--cycling road
					if tile == 0x70 and height == 4 then
					--	console:log("PLAYER " .. RealID .. " IS ON CYCLING ROAD")
						Priority = 1
					--fortree city
					elseif tile == 0x78 and height == 4 then
						Priority = 1
					elseif tile ~= 0 and height == 4 then
						Priority = 1
					elseif tile ~= 0 then
					--	console:log("TILE: " .. tile .. " height: " .. height)
					end
				end
			end
		end
		--if weather is fog or dive and DisableRenderWeather is off, make players prio 1. still looks wierd, but at least it works
		if (PositionData.Weather == 6 or PositionData.Weather == 14) and DisableRenderWeather == false then
			Priority = 1
		end
		
		
		local Flip = 128
		if Direction == 2 then Flip = 144 end
		
		local IsInBattle = false
		
		local ConstructSprite = (Palette * 4096) + (Priority * 1024) + Bank
		local ConstructSprite2 = ConstructSprite + 16
		local ConstructSprite3 = (Palette * 4096) + (1 * 1024) + Bank + 32
		local ConstructSprite4 = (Palette * 4096) + (Priority * 1024) + Bank + 32
		local ConstructSprite5 = (Palette2 * 4096) + (Priority * 1024) + Bank + 16
		
		--NOT USED. Palettes are actually way more complex to simply swap.
		local PaletteSwap = PaletteAddress + (Palette * 32)
		local function WritePalette(addr, data)
			for i = 1, #data do
				emu:write32(addr, data[i])
				addr = addr + 4
			end
		end
		
		--Swap Palette first
		--if Palette > -1 then
		--	WritePalette(PaletteSwap, PaletteUse)
		--end
		
		if DebugMessages.Render then console:log("FinalMapX: " .. FinalMapX .. " FinalMapY: " .. FinalMapY) end
		
		ErasePlayer(id)
		
		--Bike
		if SpriteType == 1 or SpriteType == 5 then
			FinalMapX = FinalMapX - 8
			local SlotSize = GetAnimationSizeSlot(RealID, 1)
			WriteToSpriteList(PlayerAddress, FinalMapX, FinalMapY, Flip, SlotSize, ConstructSprite, 0, 0, isHotSprings)
			if gAddress[GameID].sGameType == "RSE" then	FinalMapX = FinalMapX + 8 end
				
		--Surf
		elseif SpriteType == 2 then
		--	console:log("CYCLE: " .. AnimationCycle .. " FRAME: " .. AnimationFrame)
			if AnimationCycle > 0 and HasAnimationInRange(28, 36) and gAddress[GameID].sGameType == "FRLG" then
				FinalMapY = FinalMapY + 1
			end
			local playersitx = FinalMapX
			if gAddress[GameID].sGameType == "RSE" then
				if HasAnimationInRange(34, 36) then playersitx = playersitx - 8 end
				if SurfFrame >= 9 and SurfFrame <= 16 then FinalMapY = FinalMapY - 1 end
				if SurfFrame >= 17 and SurfFrame <= 24 then FinalMapY = FinalMapY - 2 end
				if SurfFrame >= 25 and SurfFrame <= 32 then FinalMapY = FinalMapY - 1 end
			end
			local SlotSize = GetAnimationSizeSlot(RealID, 1)
			WriteToSpriteList(PlayerAddress, playersitx, FinalMapY, Flip, SlotSize, ConstructSprite, 0, 0, isHotSprings)
			if GetSlotUsed(RealID, 2) then
				local SlotSize = GetAnimationSizeSlot(RealID, 2)
				WriteToSpriteList(PlayerAddress + 8, FinalMapX-8, FinalMapY+8, Flip, SlotSize, ConstructSprite2, 0, 0, isHotSprings)
			end
		--Throwing pokemon
		elseif SpriteType == 3 then
			if gAddress[GameID].sGameType == "RSE" then FinalMapX = FinalMapX - 8 end
			local SlotSize = GetAnimationSizeSlot(RealID, 1)
			WriteToSpriteList(PlayerAddress, FinalMapX, FinalMapY, Flip, SlotSize, ConstructSprite, 0, 0, isHotSprings)
		--Fishing
		elseif SpriteType == 4 then
			if HasAnimationInRange(28, 33) then
				if gAddress[GameID].sGameType == "RSE" then
					if SurfFrame >= 9 and SurfFrame <= 16 then FinalMapY = FinalMapY - 1 end
					if SurfFrame >= 17 and SurfFrame <= 24 then FinalMapY = FinalMapY - 2 end
					if SurfFrame >= 25 and SurfFrame <= 32 then FinalMapY = FinalMapY - 1 end
				end
				local SlotSize = GetAnimationSizeSlot(RealID, 1)
				WriteToSpriteList(PlayerAddress + 8, FinalMapX-8, FinalMapY+8, Flip, SlotSize, ConstructSprite2, 0, 0, isHotSprings)
			end
			local SlotSize = GetAnimationSizeSlot(RealID, 1)
			local sitx = FinalMapX
			local sity = FinalMapY
			if Direction == 1 then sitx = sitx - 16
			elseif Direction == 4 then sitx = sitx - 8 sity = sity + 8
			elseif Direction == 3 then sitx = sitx - 8
			end
			WriteToSpriteList(PlayerAddress, sitx, sity, Flip, SlotSize, ConstructSprite, 0, 0, isHotSprings)
		--On Foot
		else
			local SlotSize = GetAnimationSizeSlot(RealID, 1)
			if not SlotSize and SizeOpt then SlotSize = SizeOpt end
			WriteToSpriteList(PlayerAddress, FinalMapX, FinalMapY, Flip, SlotSize, ConstructSprite, 0, 0, isHotSprings)
		end
		
		
		if GetSlotUsed(RealID, 3) then
			xoff, yoff = GetDrawSpriteOffsets(3)
			FinalMapX = FinalMapX + xoff
			FinalMapY = FinalMapY + yoff
			local SlotSize = GetAnimationSizeSlot(RealID, 3)
			if GetAnimationTableSlot(RealID, 3) == 1003 then
				FinalMapY = FinalMapY + 24
				WriteToSpriteList(PlayerAddress + 16, FinalMapX, FinalMapY, Flip, SlotSize, ConstructSprite4, 0, 0, 0)
			else
				if gAddress[GameID].sGameType == "FRLG" and SpriteType == 1 then FinalMapX = FinalMapX + 8 FinalMapY = FinalMapY - 8 end
				WriteToSpriteList(PlayerAddress + 16, FinalMapX, FinalMapY, Flip, SlotSize, ConstructSprite3, 0, 0, 0)
			end
		end
		if GetSlotUsed(RealID, 2) then
			xoff, yoff = GetDrawSpriteOffsets(3)
			FinalMapX = FinalMapX + xoff
			FinalMapY = FinalMapY + yoff
			local SlotSize = GetAnimationSizeSlot(RealID, 2)
			if GetAnimationSizeSlot(RealID, 1) ~= "32x32" and (GetAnimationTableSlot(RealID, 2) == 1004 or GetAnimationTableSlot(RealID, 2) == 1005) and gAddress[GameID].sGameType == "RSE" then
				FinalMapY = FinalMapY + 16
				WriteToSpriteList(PlayerAddress, FinalMapX, FinalMapY, 128, SlotSize, ConstructSprite5, 0, 0, 0)
			end
		end
		RefreshDrawSprite(RealID, 2)
		RefreshDrawSprite(RealID, 3)
end

function ErasePlayer(id)
	local PlayerAddress = gAddress[GameID].gSprite - (id * 24)
	
	--For Reference: WriteToSpriteList(PlayerAddress, X, Y, Facing, SpriteID, Extra1, Extra3, Extra4)
	WriteToSpriteList(PlayerAddress, 160, 48, 1, 0, 12, 0, 1)
	--Surfing char
	WriteToSpriteList(PlayerAddress + 8, 160, 48, 1, 0, 12, 0, 1)
	--Extra Char
	WriteToSpriteList(PlayerAddress + 16, 160, 48, 1, 0, 12, 0, 1)
end

-- Tate Addition 
function WriteToSpriteList(Player1Address, X, Y, Facing, SpriteSize, ConstructSprite, Extra3, Extra4, isHotSprings)
	local Player1Address = Player1Address
	if isHotSprings then
		Player1Address = Player1Address + isHotSprings
	end
	local PlayerXAddress = Player1Address + 2
	local PlayerFaceAddress = Player1Address + 3
	local PlayerSpriteAddress = Player1Address + 1
	local PlayerExtra1Address = Player1Address + 4
	local PlayerExtra2Address = Player1Address + 5
	local PlayerExtra3Address = Player1Address + 6
	local PlayerExtra4Address = Player1Address + 7
	
	if SpriteSize == "16x8" then
		Facing = Facing - 128
		SpriteSize = 64
	elseif SpriteSize == "16x16" then
		Facing = Facing - 64
		SpriteSize = 0
	elseif SpriteSize == "16x32" then
		SpriteSize = 128
	elseif SpriteSize == "32x32" then
		SpriteSize = 0
	end
	if X < 0 then X = X + 511 end
	if X > 255 then --Technically X is 9 bits, sooo...
		X = X - 255
		Facing = Facing + 1
	end
	emu:write8(PlayerXAddress, X)
	emu:write8(Player1Address, Y)
	emu:write8(PlayerFaceAddress, Facing)
	emu:write8(PlayerSpriteAddress, SpriteSize)
	emu:write16(PlayerExtra1Address, ConstructSprite)
	emu:write8(PlayerExtra3Address, Extra3)
	emu:write8(PlayerExtra4Address, Extra4)
end

function UpdatePlayerConsole()
	if #players > 1 and Hosting then
		ConsoleForText:moveCursor(0,4)
		ConsoleForText:print("Players found!												  ")
	elseif Hosting then
		ConsoleForText:moveCursor(0,4)
		ConsoleForText:print("Searching for players...												")
	end
	for i = 1, MaxPlayers do
		local player = FindPlayerByID(i)
		local ConsoleLine = i + 9
		if player then
			if i > 1 then
			--console:log("ADDING " .. player:GetID() .. " TO LINE " .. ConsoleLine)
			ConsoleForText:moveCursor(0, ConsoleLine)
			if player:GetID() == PlayerID then
				ConsoleForText:print("Player ID " .. player:GetID() .. ": " .. player:GetNickname()  .. " (You)							")
			else
				ConsoleForText:print("Player ID " .. player:GetID() .. ": " .. player:GetNickname()  .. "							")
			end
			else
			--	console:log("ADDING HOST " .. player:GetID() .. "TO LINE " .. ConsoleLine)
				ConsoleForText:moveCursor(0,ConsoleLine)
				ConsoleForText:print("Host: " .. player:GetNickname()  .. "										")
			end
		else
			ConsoleForText:moveCursor(0,ConsoleLine)
			ConsoleForText:print("																		")
		end
	end
	--Workaround
	if #players > 1 and Connected then
		local player = FindPlayerByID(1)
		if player then
			ConsoleForText:moveCursor(0,9)
			ConsoleForText:print("																		")
			ConsoleForText:moveCursor(0,10)
			ConsoleForText:print("Host: " .. player:GetNickname()  .. "										")
		end
	end
end



function StartScript()
	if RestartScript then return end
	EnableScript = false
	ResetVariables()
	if #players > 0 then
		for i, player in ipairs(players) do
			player:Clear()
		end
	end
		
	if ConsoleForText == nil then
		if ServerType == "h" or ServerType == "s" or ServerType == "H" or ServerType == "S" then
			ConsoleForText = console:createBuffer("GBA-PK SERVER")
		else
			ConsoleForText = console:createBuffer("GBA-PK CLIENT")
		end
		
		ConsoleForText:clear()
		ConsoleForText:moveCursor(0,0)
		ConsoleForText:print("A new game has started")
		ConsoleForText:moveCursor(0,1)
	end
	FFTimer2 = os.time()
	GetGameVersion()
	if EnableScript then
		ROMCARD = emu.memory.cart0
		if Experimental_Features then
			for NPCname, NPCdata in pairs(Objects) do
				if NPCdata then
					local graphics_id = Objects_Graphics[gAddress[GameID].sGameVersion][NPCname]
					if not graphics_id then graphics_id = 0 end
					local npc = NPC:New(NPCname, NPCdata.location, NPCdata.data.local_id, graphics_id, NPCdata.data.elevation, 8, NPCdata.data.movement_range_x, NPCdata.data.movement_range_y, NPCdata.data.trainer_type, NPCdata.data.script)
					table.insert(NPCs, npc)
				end
			end
		end
		if #players < 1 then
			if ServerType == "h" or ServerType == "s" or ServerType == "H" or ServerType == "S" then
				CreateNetwork()
			elseif ServerType == "c" then
				ConnectNetwork()
			else
				--If set to anything other than h or c make it client
				ConnectNetwork()
			end
		end
	end
end

function StopScript()
	RestartScript = false
	EnableScript = false
	ConsoleForText:clear()
	--console:log("The game was shutdown. Please restart the script when the game is open.")
	console:log("The game was shutdown. It is highly recommended to restart the script.")
	ResetVariables()
	players = {}
end

function ResetVariables()
	DebugMenus = {}
	DebugMenusPrev = {}
	LockFromScript = 0
	TextSpeedWait = 0
	PositionData = {
		Bike = 0,
		Direction = 0,
		PlayerMapIDPrev = 0,
		PlayerMapID = 0,
		PlayerMapEntranceType = 0,
		PlayerMapChange = 0,
		CurrentX = 0,
		CurrentY = 0,
		PreviousX = 0,
		PreviousY = 0,
		Animation = 0,
		Gender = 0,
		SpriteType = 0,
		BorderX = 9999,
		BorderY = 9999,
		Connections = {},
		AnimationData = 0,
		Animate2 = 0,
		AnimType = 0,
		AnimLength = 0,
		Elevation = 0,
		PrevSurf = false,
		CurrentCameraX = 0,
		CurrentCameraY = 0,
		AnimationByte = 0,
		AnimationDirection = 0,
		isAnimating = 0,
		isCrossingBorder = 0,
		CameraXPos = 0,
		CameraYPos = 0,
		UseMapPos = false,
		ActualX = 0,
		ActualY = 0,
	}
	RefreshRenderPlayer()
end

--Begin Networking

--Create Server

function CreateNetwork()
	if not Hosting then
		Hosting = true
		PlayerID = 1
		AddPlayer(PlayerID, SocketMain, Nickname, GameID, GetPosition())
		local success, errorMessage = SocketMain:bind(nil, Port)
		if not success then
			EnableScript = false
			ConsoleForText:print("Hosting could not be started. Please restart the script. Error: " .. errorMessage)
		else
			SocketMain:listen()
			ConsoleForText:moveCursor(0,3)
			ConsoleForText:print("Hosting game. Port forwarding may be required.")
		end
		ConsoleForText:moveCursor(0,3)
		ConsoleForText:print("Hosting game. Port forwarding may be required.")
		ConsoleForText:moveCursor(0,4)
		ConsoleForText:print("Searching for players...												")
	end
end

function ConnectNetwork()
	if not Connected then
		ConsoleForText:moveCursor(0,3)
		ConsoleForText:print("Searching for an open game on IP ".. IPAddress .. ". Please do not touch the emulator.")
		local success, errorMessage = SocketMain:connect(IPAddress, Port)
		if success then
			Connected = true
			ConsoleForText:moveCursor(0,3)
			ConsoleForText:print("Game found. Sending request to join as a player...										")
			SendData(SocketMain, "Request")
		else
			RestartScript = true
			EnableScript = false
			ConsoleForText:clear()
			console:log("Error connecting. Error type: " .. errorMessage)
			console:log("Please restart the script")
		end
	end
end

function Disconnect()
	SocketMain:close()
	PlayerID = 0
	players = {}
	UpdatePlayerConsole()
	ConsoleForText:moveCursor(0,3)
	console:log("You have timed out")
	ConsoleForText:print("You have been disconnected due to timeout.										   ")
	ConsoleForText:moveCursor(0,4)
	ConsoleForText:print("Connected to a server: No		 ")
	Connected = false
	ConnectNetwork()
end

function Connection()
	if updateTimers("network_send") then
		if Hosting then
			if #players > 1 then
				for i, player in ipairs(players) do
					local ActualPlayer = FindPlayerByID(PlayerID)
					if player:GetID() ~= PlayerID then
						SendData(player:GetSocket(), "SPOS", PlayerID)
						
						--Trade
						if LockFromScript == 9 and ActualPlayer:GetTalking() == player:GetID() then
							SendSpecialData(player:GetSocket(), "TRAD", player:GetID())
						end
						--Battle
						if LockFromScript == 21 and ActualPlayer:GetTalking() == player:GetID() then
							SendSpecialData(player:GetSocket(), "BATT", player:GetID())
							for i=1, 7 do --send bat2 4 times
								SendSpecialData(player:GetSocket(), "BAT2", player:GetID())
							end
						end
						if player:GetTimeout() <= 0 then
							SendData(player:GetSocket(), "DISC", player:GetID())
							for i, player2 in ipairs(players) do
								local SocketToUse = player2:GetSocket()
								if player2:GetID() ~= PlayerID and player2:GetID() ~= player:GetID() then
									CreatePacket("RPLA", player:GetID(), player:GetID())
									SocketToUse:send(Packet)
								end
							end 
							RemovePlayer(player:GetID())
						end
					end
				end
			end
		elseif Connected then
			if #players > 1 then
				for i, player in ipairs(players) do
					if player:GetID() == 1 and player:GetTimeout() <= 0 then
						Disconnect()
					end
				end
				
				SendData(SocketMain, "SPOS", PlayerID)
				--Trade
				if LockFromScript == 9 then
					local Player = FindPlayerByID(PlayerID)
					if Player then
						SendSpecialData(SocketMain, "TRAD", Player:GetTalking())
					end
				end
				--Battle
				if LockFromScript == 21 then
					local Player = FindPlayerByID(PlayerID)
					if Player then
						SendSpecialData(SocketMain, "BATT", Player:GetTalking())
						for i=1, 7 do --send bat2 7 times
							SendSpecialData(SocketMain, "BAT2", Player:GetTalking())
						end
					end
				end
			end
		end
	elseif updateTimers("network_receive") then
		if Hosting then
			local PlayerData = SocketMain:accept()
			if (PlayerData ~= nil) then
				AddTempPlayer(PlayerData)
			end
			if #temp_players > 0 then
				for i, player in ipairs(temp_players) do
					ReceiveData(player:GetSocket())
					if player:GetTimeout() <= 0 then
						RemoveTempPlayer(player)
					end
				end
			end
			if #players > 1 then
				for i, player in ipairs(players) do
					ReceiveData(player:GetSocket())
					local ActualPlayer = FindPlayerByID(PlayerID)
					--Trade
					if LockFromScript == 9 and ActualPlayer:GetTalking() == player:GetID() then
						ReceiveData(player:GetSocket())
					end
					--Battle
					if LockFromScript == 21 and ActualPlayer:GetTalking() == player:GetID() then
						ReceiveData(player:GetSocket())
						for i=1, 7 do
							ReceiveData(player:GetSocket())
						end
					end
				end
			end
		elseif Connected then
			if SocketMain then
				ReceiveData(SocketMain)
				--Trade
				if LockFromScript == 9 then
					ReceiveData(SocketMain)
				end
				--Battle
				if LockFromScript == 21 then
					ReceiveData(SocketMain)
					for i=1, 7 do
						ReceiveData(SocketMain)
					end
				end
			end
		end
	end
end

function ReceiveData(SocketMain)
	local function parseReceivedData(ReadData)
		local packet = {
			GameID = string.sub(ReadData, 1, 4),
			Nickname = "FFFF",
			PlayerID = tonumber(string.sub(ReadData, 9, 12)),
			SendToID = tonumber(string.sub(ReadData, 13, 16)),
			RequestType = string.sub(ReadData, 17, 20),
			ExtraData = string.sub(ReadData, 21, 63),
			Validate = string.sub(ReadData, 64, 64),
			IsSpecial = false,
		}
		if packet.Validate ~= "U" then
			console:log("got unverified packet: " .. ReadData)
		end
		if packet.Validate == "U" then
			if packet.RequestType == "POKE" then
				packet.PokeBytes = string.sub(ReadData,21,45)
				packet.IsSpecial = true
			elseif packet.RequestType == "POK2" then
				packet.slot = string.byte(string.sub(ReadData, 62, 62))
				packet.sect = string.byte(string.sub(ReadData, 63, 63))
				packet.pkmn = {}
				for i=1, 25 do
					packet.pkmn[i] = string.byte(string.sub(ReadData, 20+i, 20+i))
				end
			elseif packet.RequestType == "TRAD" then
				packet.TradeBytes = {
					Text_Stage = tonumber(string.sub(ReadData, 21, 24)) - 1000,
					Pokemon_Select = tonumber(string.sub(ReadData, 25, 28)) - 1000,
					Trade_Start = tonumber(string.sub(ReadData, 29, 32)) - 1000,
				}
				packet.IsSpecial = true
			elseif packet.RequestType == "BATT" then
				packet.BattleBytes = {
					Text_Stage = string.byte(string.sub(ReadData, 21, 21)),
					Waiting_Status = string.byte(string.sub(ReadData, 22, 22)),
					Battle_Start = string.byte(string.sub(ReadData, 23, 23)),
					Buffer_ID = string.byte(string.sub(ReadData, 24, 24)),
					Attacker = string.byte(string.sub(ReadData, 25, 25)),
					Target = string.byte(string.sub(ReadData, 26, 26)),
					Absent_Battler = string.byte(string.sub(ReadData, 27, 27)),
					Effect_Battler = string.byte(string.sub(ReadData, 28, 28)),
					Transfer_Stage = 0,
					Send_ID = string.byte(string.sub(ReadData, 63, 63)),
					Buffer_A = {},
					Buffer_B = {},
					Battleflags = {},
				}
				for i = 1, 30 do
					packet.BattleBytes.Buffer_A[i] = string.byte(string.sub(ReadData, i+28, i+28))
				end
				for i = 1, 4 do
					packet.BattleBytes.Battleflags[i] = string.byte(string.sub(ReadData, i+58, i+58))
				end
				packet.IsSpecial = true
			elseif packet.RequestType == "BAT2" then
				packet.Transfer_Stage = 1
				packet.Buffer_A = {}
				packet.Buffer_B = {}
				for i = 1, 20 do
					packet.Buffer_A[i] = string.byte(string.sub(ReadData, i+20, i+20))
				end
				for i = 1, 20 do
					packet.Buffer_B[i] = string.byte(string.sub(ReadData, i+40, i+40))
				end
			elseif packet.RequestType == "BAT3" then
				packet.BattleBytes = {
					Link_Battle_Header_versionLo = string.byte(string.sub(ReadData, 21, 21)),
					Link_Battle_Header_versionHi = string.byte(string.sub(ReadData, 22, 22)),
					Link_Battle_Header_vsLo = string.byte(string.sub(ReadData, 23, 23)),
					Link_Battle_Header_vsHi = string.byte(string.sub(ReadData, 24, 24)),
					Link_Battle_Header_Itemdata = {},
					Transfer_Stage = 1,
				}
				for i = 1, 27 do
					packet.BattleBytes.Link_Battle_Header_Itemdata[i] = string.byte(string.sub(ReadData, i+24, i+24))
				end
				packet.IsSpecial = true
			elseif packet.RequestType == "CARD" then
				packet.CardBytes = string.sub(ReadData,21,30) - 1000000000
				packet.CardBytes2 = string.sub(ReadData,31,40) - 1000000000
				packet.CardBytes3 = string.sub(ReadData,41,50) - 1000000000
				packet.CardBytes4 = string.sub(ReadData,51,60) - 1000000000
				packet.IsSpecial = true
			elseif packet.RequestType == "NICK" then
				packet.NicknameSpecial = string.sub(ReadData,21,63)
				packet.NicknameSpecial = packet.NicknameSpecial:gsub("~*$", "")
				if DebugMessages.Nickname then console:log("NICK: " .. packet.NicknameSpecial) end
			else
				packet.RequestBytes = tonumber(string.sub(packet.ExtraData, 1, 4))
				packet.Battle = string.byte(string.sub(packet.ExtraData, 5, 5)) | (string.byte(string.sub(packet.ExtraData, 6, 6)) << 8) | (string.byte(string.sub(packet.ExtraData, 7, 7)) << 16) | (string.byte(string.sub(packet.ExtraData, 8, 8)) << 24)
				packet.Direction = string.byte(string.sub(packet.ExtraData, 9, 9))
				packet.MapID = string.byte(string.sub(packet.ExtraData, 10, 10)) | (string.byte(string.sub(packet.ExtraData, 11, 11)) << 8)
				packet.PreviousMapID = string.byte(string.sub(packet.ExtraData, 12, 12)) | (string.byte(string.sub(packet.ExtraData, 13, 13)) << 8)
				packet.CurrentX = string.byte(string.sub(packet.ExtraData, 14, 14)) | (string.byte(string.sub(packet.ExtraData, 15, 15)) << 8)
				packet.CurrentY = string.byte(string.sub(packet.ExtraData, 16, 16)) | (string.byte(string.sub(packet.ExtraData, 17, 17)) << 8)
				--15-18 is previous x and y, not used
				packet.BorderX = string.byte(string.sub(packet.ExtraData, 22, 22)) | (string.byte(string.sub(packet.ExtraData, 23, 23)) << 8)
				packet.BorderY = string.byte(string.sub(packet.ExtraData, 24, 24)) | (string.byte(string.sub(packet.ExtraData, 25, 25)) << 8)
				packet.MapConnectionType = string.byte(string.sub(packet.ExtraData, 27, 27))
				--24 is entrance, not used
				packet.Animation = string.byte(string.sub(packet.ExtraData, 28, 28))
				packet.Gender = string.byte(string.sub(packet.ExtraData, 29, 29))
				packet.SpriteType = string.byte(string.sub(packet.ExtraData, 30, 30))
				packet.AnimationData = string.byte(string.sub(packet.ExtraData, 31, 31))
				packet.MetaTile = string.byte(string.sub(packet.ExtraData, 32, 32))
				packet.Elevation = string.byte(string.sub(packet.ExtraData, 33, 33))
				packet.LevelCap = string.byte(string.sub(packet.ExtraData, 34, 34))
				packet.PokemonCap = string.byte(string.sub(packet.ExtraData, 35, 35))
				--36-43 is filler
				packet.RequestBytes = packet.RequestBytes - 1000
				packet.MapData = {
					["x"] = packet.CurrentX,
					["y"] = packet.CurrentY,
					["dir"] = packet.Direction,
					["id"] = packet.MapID,
				--	["mapdir"] = packet.MapDirection,
					["prev_id"] = packet.PreviousMapID,
				--	["entrance"] = packet.Entrance,
				--	["prev_x"] = packet.PreviousMapX,
				--	["prev_y"] = packet.PreviousMapY,
					["border_x"] = packet.BorderX,
					["border_y"] = packet.BorderY,
					["connection"] = packet.MapConnectionType,
					["elevation"] = packet.Elevation,
				}
				packet.PlayerData = {
					["anim"] = packet.Animation,
					["gender"] = packet.Gender,
					["sprite"] = packet.SpriteType,
					["id"] = packet.GameID,
					["anim_data"] = packet.AnimationData,
				}
			end
			
			packet.PlayerID = packet.PlayerID - 1000
			packet.SendToID = packet.SendToID - 1000
		end
		return packet
	end
	
	if EnableScript == true then
		local Network_Count = 0
		while (SocketMain:hasdata()) do
			local ReadData = SocketMain:receive(64)
			if ReadData == nil then
				break
			else
				Network_Count = Network_Count + 1
				local packet = parseReceivedData(ReadData)
				--Host
				if Hosting then
					if packet.RequestType == "JOIN" then
						if DebugMessages.Unable_To_Connect then console:log("OBTAINED PACKET FROM NEW PLAYER: " .. ReadData) end
						if packet.Validate == "U" then
							if #players < MaxPlayers then
								if DebugMessages.Unable_To_Connect then console:log("ADDING TEMP PLAYER. SENDING DETAILS BACK.") end
								local id = FindFirstFreeID()
								AddPlayer(id, SocketMain, packet.Nickname, packet.GameID, packet.CurrentX, packet.CurrentY, packet.Direction, packet.MapID, packet.Animation, packet.Gender, packet.SpriteType, packet.MapConnectionType, packet.BorderX, packet.BorderY, nil, packet.AnimationData)
								SendData(SocketMain, "NewPlayer", id, PlayerID)
							else
								console:log("A player was unable to join due to capacity limit.")
								SendData(SocketMain, "Refuse", 2)
							end
						else
							if DebugMessages.Unable_To_Connect then console:log("DOES NOT HAVE U AT END. CLOSING CONNECTION...") end
						end
					elseif packet.RequestType == "NICK" then
						if packet.Validate == "U" then
							if DebugMessages.Unable_To_Connect then console:log("RECEIVED NICK FROM CLIENT") end
							local player = FindPlayerByID(packet.PlayerID)
							if player then
								if packet.SendToID ~= PlayerID then
									local target = FindPlayerByID(packet.SendToID)
									if target then
										if DebugMessages.Nickname then console:log("SENDING NICK OF " .. packet.PlayerID .. " TO " .. packet.SendToID) end
										CreateSpecialPacket(target:GetSocket(), "NICK", packet.SendToID, packet.PlayerID)
									end
								else
									player:UpdateNickname(packet.NicknameSpecial)
									--Update players to the nickname
									for i, player in ipairs(players) do
										if player:GetID() ~= PlayerID and player:GetSocket() ~= SocketMain then
											CreateSpecialPacket(player:GetSocket(), "NICK", player:GetID(), packet.PlayerID)
											if DebugMessages.Nickname then console:log("SENDING NICK OF " .. packet.PlayerID .. " TO " .. player:GetID()) end
										end
									end 
								end
							end
						end
					end
				--Client
				elseif Connected then
					if packet.RequestType == "STRT" then
						if DebugMessages.Unable_To_Connect then console:log("RECEIVED STRT") end
						--Add host
						AddPlayer(1, SocketMain, packet.Nickname, packet.GameID, packet.CurrentX, packet.CurrentY, packet.Direction, packet.MapID, packet.Animation, packet.Gender, packet.SpriteType, packet.MapConnectionType, packet.BorderX, packet.BorderY, nil, packet.AnimationData, packet.MetaTile)
						--Add yourself
						PlayerID = packet.RequestBytes
						AddPlayer(PlayerID, SocketMain, Nickname, GameID, GetPosition())
						ConsoleForText:moveCursor(0,3)
						ConsoleForText:print("You have successfully connected.																																														")
						ConsoleForText:moveCursor(0,4)
						ConsoleForText:print("Connected to a server: Yes				 ")
					end
					
					if packet.RequestType == "GNIC" then
						if DebugMessages.Unable_To_Connect then console:log("RECEIVED GNIC. SENDING NICK BACK") end
						SendSpecialData(SocketMain, "NICK", packet.PlayerID)
					end
					
					if packet.RequestType == "NICK" then
						if DebugMessages.Unable_To_Connect then console:log("RECEIVED NICK FROM HOST") end
						local player = FindPlayerByID(packet.PlayerID)
						if player then
							if DebugMessages.Nickname then console:log("UPDATE NAME OF " .. packet.PlayerID) end
							player:UpdateNickname(packet.NicknameSpecial)
						end
					end
					
					if packet.RequestType == "RFSE" then
						if packet.RequestBytes == 1 then
							ConsoleForText:moveCursor(0,3)
							ConsoleForText:print("You could not join this game due to someone else using your nickname.					")
							ConsoleForText:moveCursor(0,4)
							ConsoleForText:print("Connected to a server: No				 ")
						elseif packet.RequestBytes == 2 then
							ConsoleForText:moveCursor(0,3)
							ConsoleForText:print("You could not join this game due to the server player limit.							")
							ConsoleForText:moveCursor(0,4)
							ConsoleForText:print("Connected to a server: No				 ")
						end
					end
				--Both
				end
				
				if packet.RequestType == "DISC" then
					for i, player in ipairs(players) do
						if player:GetID() ~= PlayerID then
							RemovePlayer(packet.RequestBytes)
						end
					end
						
				--Add player
				elseif packet.RequestType == "APLA" then
					AddPlayer(packet.RequestBytes, SocketMain, packet.Nickname, packet.GameID, packet.CurrentX, packet.CurrentY, packet.Direction, packet.MapID, packet.Animation, packet.Gender, packet.SpriteType, packet.MapConnectionType, packet.BorderX, packet.BorderY, nil, packet.AnimationData, packet.MetaTile)
					
				--Remove player
				elseif packet.RequestType == "RPLA" then
					RemovePlayer(packet.RequestBytes)
					
				elseif packet.RequestType == "SPOS" then
					--Set player position
					local player = FindPlayerByID(packet.RequestBytes)
					if player then
						player:SetMapData(packet.MapData)
						player:SetPlayerData(packet.PlayerData)
						player:SetMetaTile(packet.MetaTile)
						player:SetBattle(packet.Battle)
						player:SetLevelCap(packet.LevelCap)
						player:SetPokemonCap(packet.PokemonCap)
						player:RefreshTimeout()
						--Send Position to all clients
						if Hosting then
							for i, player in ipairs(players) do
								if player:GetID() ~= PlayerID and player:GetID() ~= packet.RequestBytes then
									SendData(player:GetSocket(), "SPOS", packet.RequestBytes, packet.RequestBytes)
								end
							end
						end
					end
				else
					if packet.SendToID ~= PlayerID and Hosting then
						if packet.SendToID and packet.PlayerID and packet.RequestType then
							if DebugMessages.Network then console:log("HOST RECEIVED " .. packet.RequestType .. " FROM " .. packet.PlayerID .. " TO " .. packet.SendToID) end
							local player = FindPlayerByID(packet.PlayerID)
							local player2 = FindPlayerByID(packet.SendToID)
							if player then
								if player2 then
									if DebugMessages.Network then console:log("FORWARD TO PLAYER " .. packet.SendToID) end
									local sockettosend = player2:GetSocket()
									sockettosend:send(ReadData)
								else
									if DebugMessages.Network then console:log("COULD NOT FIND PLAYER. SEND TOO BUSY BACK") end
									SendData(player:GetSocket(), "TBUS", packet.PlayerID)
								end
							end
						end
					elseif packet.SendToID ~= PlayerID then
						if DebugMessages.Network then console:log("CLIENT RECEIVED WRONG REQUEST. SENDING TBUS BACK.") end
						SendData(SocketMain, "TBUS", packet.PlayerID)
					
					else
						local player = FindPlayerByID(PlayerID)
						local playertalking = FindPlayerByID(player:GetTalking())
						local IsCorrectPlayer = true
						if playertalking then
							if player:GetTalking() ~= packet.PlayerID then
								IsCorrectPlayer = false
							end
						end
						
						if IsCorrectPlayer then
							if packet.RequestType == "ROFF" then
								if DebugMessages.Network or DebugMessages.Battle or DebugMessages.Trade then console:log("Other player has refused the offer.") end
								if LockFromScript == 5 or LockFromScript == 9 or LockFromScript == 14 or LockFromScript == 20 or LockFromScript == 21 or LockFromScript == 22 then
									OtherPlayerHasCancelled = 3
								end
							end
							
							if packet.RequestType == "RTRA" then
								if DebugMessages.Network or DebugMessages.Trade then console:log("YOU RECEIVED RTRA FROM " .. packet.PlayerID .. " TO YOU") end
								local TooBusyByte = emu:read8(gAddress[GameID].gLockControls)
								local PartyCount = emu:read8(gAddress[GameID].gPartyCount)
								if (TooBusyByte ~= 0 or LockFromScript ~= 0) then
								if DebugMessages.Network or DebugMessages.Trade then console:log("SEND TOO BUSY") end
									SendData(SocketMain, "TBUS", packet.PlayerID)
								elseif PartyCount < 1 then
									SendData(SocketMain, "NTRA", packet.PlayerID)
								else
									local player = FindPlayerByID(PlayerID)
									player:SetTalking(packet.PlayerID)
									local target = FindPlayerByID(packet.PlayerID)
									--since you are client, set battlemain to other player
									BattleMain = target:GetBattle()
									BattleLevelCap = target:GetLevelCap()
									BattlePokemonCap = target:GetPokemonCap()
									OtherPlayerHasCancelled = 0
									LockFromScript = 14
									Loadscript(6)
								end
							end
							
							--If the other player cancels trade
							if packet.RequestType == "CTRA" then
								if DebugMessages.Network or DebugMessages.Trade then console:log("Other player has canceled trade.") end
								if LockFromScript == 5 or LockFromScript == 9 or LockFromScript == 14 then
									OtherPlayerHasCancelled = 2
								end
							end
							
							--If the other player denies trade
							if packet.RequestType == "DTRA" then
								if DebugMessages.Trade then console:log("DENIED TRADE") end
								if LockFromScript == 5 or LockFromScript == 9 or LockFromScript == 14 then
									if Var8000[2] ~= 0 then
										LockFromScript = 0
										Loadscript(7)
									else
										TextSpeedWait = 4
									end
								end
							end
							
							--If the other player cannot trade due to 0 pokemon
							if packet.RequestType == "NTRA" then
								if LockFromScript == 5 or LockFromScript == 9 or LockFromScript == 14 then
									if Var8000[2] ~= 0 then
										LockFromScript = 0
										Loadscript(31)
									else
										TextSpeedWait = 5
									end
								end
							end
							
							--If the other player accepts your trade request
								if packet.RequestType == "STRA" and LockFromScript == 5 then
									if DebugMessages.Network or DebugMessages.Trade then console:log("TRADE START NETWORK. SENDING POKEMON") end
									local Target = FindPlayerByID(packet.PlayerID)
									if Target then
										local player = FindPlayerByID(packet.PlayerID)
										GetPokemonTeam(player, 0)
										ClearTrade()
										if Var8000[2] ~= 0 then
											LockFromScript = 9
										else
											TextSpeedWait = 2
										end
									end
								end
							
							if packet.RequestType == "RBAT" then
								if DebugMessages.Network or DebugMessages.Battle then console:log("YOU RECEIVED RBAT FROM " .. packet.PlayerID .. " TO YOU") end
								local TooBusyByte = emu:read8(gAddress[GameID].gLockControls)
								local PartyCount = emu:read8(gAddress[GameID].gPartyCount)
								if (TooBusyByte ~= 0 or LockFromScript ~= 0) then
								if DebugMessages.Network or DebugMessages.Trade then console:log("SEND TOO BUSY") end
									SendData(SocketMain, "TBUS", packet.PlayerID)
								elseif PartyCount < 1 then
									SendData(SocketMain, "NBAT", packet.PlayerID)
								else
									local player = FindPlayerByID(PlayerID)
									player:SetTalking(packet.PlayerID)
									local target = FindPlayerByID(packet.PlayerID)
									--since you are client, set battlemain to other player
									BattleMain = target:GetBattle()
									BattleLevelCap = target:GetLevelCap()
									BattlePokemonCap = target:GetPokemonCap()
									OtherPlayerHasCancelled = 0
									--if forced battle, make this player battle, otherwise request
									if (BattleMain & BATTLE_FLAGS.FORCE_BATTLE) ~= 0 then
										if OtherPlayerHasCancelled == 0 then
											target:SetBattleID(1) --they are client,
											player:SetBattleID(0) --you are host
											if Hosting then
												if DebugMessages.Battle then console:log("SEND DATA FROM HOST") end
												SendData(target:GetSocket(), "SBAT", target:GetID())
											else
												if DebugMessages.Battle then console:log("SEND DATA FROM CLIENT") end
												--Special Data is structured differently
												SendData(SocketMain, "SBAT", target:GetID())
											end
											ClearBattle()
											LockFromScript = 21
										else
											if DebugMessages.Battle then console:log("Other player cancelled") end
											LockFromScript = 0
											OtherPlayerHasCancelled = 0
											LockFromScript = 0
											Loadscript(18)
										end
									else
										LockFromScript = 22
										Loadscript(10)
									end
								end
							end
							
							if packet.RequestType == "CBAT" then
								if DebugMessages.Network or DebugMessages.Battle then console:log("Other player has canceled battle.") end
								if LockFromScript == 20 or LockFromScript == 21 or LockFromScript == 22 then
									OtherPlayerHasCancelled = 1
								end
							end
								
							--If the other player denies your battle request
							if packet.RequestType == "DBAT" then
								if DebugMessages.Battle then console:log("DENIED HATTLE") end
								if LockFromScript == 20 or LockFromScript == 21 or LockFromScript == 22 then
									if Var8000[2] ~= 0 then
										LockFromScript = 0
										Loadscript(11)
									else
										TextSpeedWait = 4
									end
								end
							end
							
							--If the other player cannot battle due to 0 pokemon
							if packet.RequestType == "NBAT" then
								if LockFromScript == 20 or LockFromScript == 21 or LockFromScript == 22 then
									if Var8000[2] ~= 0 then
										LockFromScript = 0
										Loadscript(31)
									else
										TextSpeedWait = 5
									end
								end
							end
							
							--If the other player accepts your battle request
								if packet.RequestType == "SBAT" and LockFromScript == 20 then
									if DebugMessages.Network or DebugMessages.Battle then console:log("BATTLE START NETWORK. SENDING POKEMON") end
									local Target = FindPlayerByID(packet.PlayerID)
									local player = FindPlayerByID(PlayerID)
									if Target then
										player:SetBattleID(0) --you are host
										Target:SetBattleID(1) --they are client
										if (Battle & BATTLE_FLAGS.FORCE_BATTLE) ~= 0 then
											player:SetBattleID(1) --you are client
											Target:SetBattleID(0) --they are host
										end
										ClearBattle()
										if Var8000[2] ~= 0 then
											LockFromScript = 21
										else
											TextSpeedWait = 2
										end
									end
								end
							
							if packet.RequestType == "POKE" then
								local Target = FindPlayerByID(packet.PlayerID)
								SetPokemonData(Target, packet.PokeBytes)
							end
							if packet.RequestType == "POK2" then
								local player = FindPlayerByID(PlayerID)
								for i=1, 25 do
									emu:write8(gAddress[GameID].gEnemyParty+(i-1)+(packet.slot*100)+(packet.sect*25), packet.pkmn[i])
								end
								if packet.slot == 5 and packet.sect == 3 then
									player.BattleVars.Waiting_Status = player.BattleVars.Waiting_Status | 1
							--		console:log("SENT!!! STATUS: " .. player.BattleVars.Waiting_Status)
								end
							end
							
							if packet.RequestType == "TRAD" then
								local player = FindPlayerByID(packet.PlayerID)
								player:SetTradeVar2(packet.TradeBytes.Text_Stage, packet.TradeBytes.Pokemon_Select, packet.TradeBytes.Trade_Start)
							end
							
							if packet.RequestType == "BATT" then
								local player = FindPlayerByID(packet.PlayerID)
								player:SetBattleVar(packet.BattleBytes)
							end
							
							if packet.RequestType == "BAT2" then
								local player = FindPlayerByID(packet.PlayerID)
								player:SetBattleVarBuffer(packet.Transfer_Stage, packet.Buffer_A, packet.Buffer_B)
							end
							
							if packet.RequestType == "BAT3" then
								local player = FindPlayerByID(packet.PlayerID)
								player:SetBattleVar2(packet.BattleBytes)
							end
							
							if packet.RequestType == "RCRD" then
								local player = FindPlayerByID(PlayerID)
								if DebugMessages.Network or DebugMessages.Card then console:log("Other player has requested card.") end
								local TooBusyByte = emu:read8(gAddress[GameID].gLockControls)
								if TooBusyByte ~= 0 and (LockFromScript ~= 10 or (LockFromScript == 10 and Var8000[2] == 0)) then
									if DebugMessages.Network or DebugMessages.Card then console:log("SEND TOO BUSY. TBB: " .. TooBusyByte .. " PLAYER: " .. packet.PlayerID) end
									SendData(SocketMain, "TBUS", packet.PlayerID)
								else
									if DebugMessages.Network or DebugMessages.Card then console:log("WORKING ON IT") end
									local gSendBuffer = gAddress[GameID].gSendBuffer
									for i=0, 35 do --clear buffer first. 
										emu:write32(gSendBuffer + (4*i), 0)
									end
									--Set 1st pokemon to 62355. When loaded, will be erased with the correct one
									emu:write16(gSendBuffer + 84, 62355)
									if gAddress[GameID].sGameType == "RSE" then
										emu:write16(gSendBuffer, 62355)
									end
									if DebugMessages.Network or DebugMessages.Card then console:log("SETTING PLAYER TARGET") end
									player:SetLoadingCard(true, packet.PlayerID) --Card needs to load first
									if DebugMessages.Network or DebugMessages.Card then console:log("LOADING CARD STUFF INTO MEMORY") end
									Loadscript(24)
								end
							end
							
							--You are receiving the card data now
							if packet.RequestType == "CARD" then
								if DebugMessages.Network or DebugMessages.Card then console:log("CARD DATA COMING IN.") end
								Target = FindPlayerByID(packet.PlayerID)
								Target:SetCardData(packet.CardBytes)
								Target:SetCardData(packet.CardBytes2)
								Target:SetCardData(packet.CardBytes3)
								Target:SetCardData(packet.CardBytes4)
							end
							
							--You are done receiving the card
							if packet.RequestType == "DCRD" then
								if DebugMessages.Network or DebugMessages.Card then console:log("Card data is done being received.") end
								if LockFromScript == 10 or LockFromScript == 11 then LockFromScript = 12 end
							end
							
							--You are done receiving the card, but the other player needs the card as well
							if packet.RequestType == "DCD2" then
								local player = FindPlayerByID(PlayerID)
								if DebugMessages.Network or DebugMessages.Card then console:log("SENDING CARD DATA BACK") end
								local gSendBuffer = gAddress[GameID].gSendBuffer
								for i=0, 35 do --clear buffer first. 
									emu:write32(gSendBuffer + (4*i), 0)
								end
								--Set 1st pokemon to 62355. When loaded, will be erased with the correct one
								emu:write16(gSendBuffer + 84, 62355)
								if gAddress[GameID].sGameType == "RSE" then
									emu:write16(gSendBuffer, 62355)
								end
								if DebugMessages.Network or DebugMessages.Card then console:log("SETTING PLAYER TARGET") end
								player:SetLoadingCard(true, packet.PlayerID) --Card needs to load first
								if DebugMessages.Network or DebugMessages.Card then console:log("LOADING CARD STUFF INTO MEMORY") end
								Loadscript(24)
								LockFromScript = 11
							end
							
							if packet.RequestType == "TBUS" then
								if DebugMessages.Network or DebugMessages.Card then console:log("YOU RECEIVED TBUS FROM " .. packet.PlayerID .. " TO YOU") end
								if LockFromScript == 4 then
									--Cancel Battle
									if Var8000[2] ~= 0 then
										LockFromScript = 0
										Loadscript(20)
									else
										TextSpeedWait = 5
									end
								elseif LockFromScript == 5 then
									--Cancel Trade
									if Var8000[2] ~= 0 then
										LockFromScript = 0
										Loadscript(21)
									else
										TextSpeedWait = 6
									end
								elseif LockFromScript == 10 then
									local Target = FindPlayerByID(packet.PlayerID)
									--If got too busy message while in trainer card, resend request again
									if Hosting then
										SendData(Target:GetSocket(), "RCRD", Target:GetID())
									else
										SendData(SocketMain, "RCRD", Target:GetID())
									end
								elseif LockFromScript == 20 then
									--Cancel Trade
									if Var8000[2] ~= 0 then
										LockFromScript = 0
										Loadscript(20)
									else
										TextSpeedWait = 6
									end
								end
							end
						else
							if DebugMessages.Network then console:log("ANOTHER PLAYER IS TRYING TO ASK STUFF WHILE YOU ARE BUSY") end
							SendData(SocketMain, "TBUS", packet.PlayerID)
						end
					end
				end
			end
		end
		
		if DebugMessages.Network_Count then console:log("Network interactions this frame: " .. Network_Count) end
	end
end

--Send Data to clients
function CreatePacket(RequestTemp, PacketTemp, DataToUse, SendToID)
	local FillerStuff = "FFFFFFFF"
	local PacketMap = {}
	local PacketPlayer = {}
	local PacketPlayerID, PacketGameID = 0, 0
	player = FindPlayerByID(DataToUse)
	PacketSendToID = SendToID or PacketTemp
	if #players > 0 and player then
		local temp1, temp2, temp3, temp4, temp5
		PacketMap = player:GetMapData() or {}
		PacketPlayer = player:GetPlayerData() or {}
		PacketPlayerID = player:GetID()
		PacketGameID = player:GetGameID()
	else
		local CurrentX, CurrentY, Direction, MapID, Animation, Gender, SpriteType, EntranceType, BorderX, BorderY, Connections, AnimationData, Metatile = GetPosition()
		PacketMap = {
			["x"] = CurrentX,
			["y"] = CurrentY,
			["dir"] = Direction,
			["id"] = MapID,
			["mapdir"] = Direction,
			["prev_id"] = MapID,
			["entrance"] = EntranceType,
			["prev_x"] = CurrentX,
			["prev_y"] = CurrentY,
			["border_x"] = BorderX,
			["border_y"] = BorderY,
			["connection"] = Connections,
			["metatile"] = Metatile,
			["elevation"] = PositionData.Elevation,
		}
		PacketPlayer = {
			["anim"] = Animation,
			["gender"] = Gender,
			["sprite"] = SpriteType,
			["id"] = GameID,
			["anim_data"] = AnimationData,
		}
		PacketPlayerID = PlayerID
		PacketGameID = GameID
	end
	local function Cap(value, length)
		return string.sub(tostring(value), 1, math.max(1, length))
	end
	
	local Packets = {}
	--4 bytes
	Packets["battle"] = safeStringChar(Battle & 0xFF) .. safeStringChar((Battle >> 8) & 0xFF) .. safeStringChar((Battle >> 16) & 0xFF) .. safeStringChar((Battle >> 24) & 0xFF)
	--1 byte
	Packets["direction"] = safeStringChar(PacketMap.dir)
	--2 bytes
	Packets["mapid"] = safeStringChar(PacketMap.id & 0xFF) .. safeStringChar((PacketMap.id >> 8) & 0xFF)
	--2 bytes
	Packets["prev_mapid"] = safeStringChar(PacketMap.prev_id & 0xFF) .. safeStringChar((PacketMap.prev_id >> 8) & 0xFF)
	--4 bytes
	Packets["pos"] = safeStringChar(PacketMap.x & 0xFF) .. safeStringChar((PacketMap.x >> 8) & 0xFF) .. safeStringChar(PacketMap.y & 0xFF) .. safeStringChar((PacketMap.y >> 8) & 0xFF)
	--4 bytes
	Packets["prev_pos"] = safeStringChar(PacketMap.prev_x & 0xFF) .. safeStringChar((PacketMap.prev_x >> 8) & 0xFF) .. safeStringChar(PacketMap.prev_y & 0xFF) .. safeStringChar((PacketMap.prev_y >> 8) & 0xFF)
	--4 bytes
	Packets["border_pos"] = safeStringChar(PacketMap.border_x & 0xFF) .. safeStringChar((PacketMap.border_x >> 8) & 0xFF) .. safeStringChar(PacketMap.border_y & 0xFF) .. safeStringChar((PacketMap.border_y >> 8) & 0xFF)
	--1 byte
	Packets["connection"] = safeStringChar(PacketMap.connection)
	--1 byte
	Packets["entrance"] = safeStringChar(PacketMap.entrance)
	--1 byte
	Packets["animation"] = safeStringChar(PacketPlayer.anim)
	--1 byte
	Packets["gender"] = safeStringChar(PacketPlayer.gender)
	--1 byte
	Packets["sprite"] = safeStringChar(PacketPlayer.sprite)
	--1 byte
	Packets["animation_data"] = safeStringChar(PacketPlayer.anim_data)
	--1 byte
	Packets["metatile"] = safeStringChar(PacketMap.metatile)
	--1 byte
	Packets["elevation"] = safeStringChar(PacketMap.elevation)
	--1 byte
	Packets["level_cap"] = safeStringChar(Level_Cap)
	--1 byte
	Packets["pokemon_cap"] = safeStringChar(Pokemon_Cap)
	PacketNickname = "FFFF"
	PacketPlayerID = Cap(PacketPlayerID + 1000, 4)
	PacketSendToID = Cap(PacketSendToID + 1000, 4)
	PacketTemp = Cap(PacketTemp + 1000, 4)
	Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. PacketTemp
	Packet = Packet .. Packets["battle"] .. Packets["direction"] .. Packets["mapid"] .. Packets["prev_mapid"] .. Packets["pos"] .. Packets["prev_pos"] .. Packets["border_pos"] .. Packets["connection"] .. Packets["entrance"] .. Packets["animation"] .. Packets["gender"] .. Packets["sprite"] .. Packets["animation_data"] .. Packets["metatile"] .. Packets["elevation"] .. Packets["level_cap"] .. Packets["pokemon_cap"]
	Packet = Packet .. FillerStuff .. "U"
	if #Packet ~= 64 then
		console:log("PACKET NOT CORRECT SIZE! SIZE: " .. #Packet .. ". SETTING FILLER PACKET")
		Packet = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFU"
	end
	if DebugMessages.Network then console:log("SEND PACKET " .. Packet) end
end

function CreateSpecialPacket(Socket, RequestTemp, PacketTemp, DataToUse, Optional)
	local Target, player, PacketPlayerID, PacketNickname, PacketGameID, PacketSendToID
	local NicknameSpecial
	Target = FindPlayerByID(PacketTemp)
	player = FindPlayerByID(DataToUse)
	PacketSendToID = PacketTemp
	if player then
		PacketPlayerID = player:GetID()
		PacketGameID = player:GetGameID()
		NicknameSpecial = player:GetNickname()
	else
		PacketPlayerID = PlayerID
		PacketGameID = GameID
	end
	PacketNickname = "FFFF"
	PacketPlayerID = PacketPlayerID + 1000
	PacketSendToID = PacketSendToID + 1000
	PacketTemp = PacketTemp + 1000
	if RequestTemp == "POKE" then
		local PokeTemp
		local StartNum = 0
		local StartNum2 = 0
		local Filler = "FFFFFFFFFFFFFFFFFF"
		local Filler2 = "1000000000000000000000000"
		for j = 1, 6 do
			for i = 1, 10 do
				StartNum = ((i - 1) * 25) + 1
				StartNum2 = StartNum + 24
				PokeTemp = string.sub(player:GetPokemonRaw(j),StartNum,StartNum2)
				Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. PokeTemp .. Filler .. "U"
				if #Packet == 64 then
				Socket:send(Packet)
				else
					console:log("PACKET NOT CORRECT SIZE!!! SIZE: " .. #Packet .. ". SENDING FILLER PACKET. MAY CORRUPT POKEMON.")
					Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. Filler2 .. Filler .. "U"
					Socket:send(Packet)
				end
			end
		end
	elseif RequestTemp == "POK2" then
		local StartAdr = gAddress[GameID].gParty
		local Filler = "FFFFFFFFFFFFFFFF"
		local Filler2 = "FFFFFFFFFFFFFFFFFFFFFFFFFFF"
		local PacketPKMN = 0 --which pokemon. can be 0-5
		local PacketPKMNLOC = 0 --which section. can be 0-3
		for j = 1, 6 do
			for l = 1, 4 do
				Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp
				for i = 1, 25 do
					local pkmn = safeStringChar(emu:read8(StartAdr))
					Packet = Packet .. pkmn
					StartAdr = StartAdr + 1
				end
				PacketPKMN = safeStringChar(j - 1)
				PacketPKMNLOC = safeStringChar(l - 1)
				Packet = Packet .. Filler .. PacketPKMN .. PacketPKMNLOC .. "U"
				if #Packet == 64 then
				--	console:log("POK2 SENT!")
					Socket:send(Packet)
				else
				--	console:log("PACKET NOT CORRECT SIZE!!! SIZE: " .. #Packet .. ". SENDING FILLER PACKET. MAY CORRUPT POKEMON.")
					Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. Filler2 .. Filler .. "U"
					Socket:send(Packet)
				end
			end
		end
		
	elseif RequestTemp == "TRAD" then
		local playerTrade = player:GetTradeVar()
		local PacketTextStage = playerTrade.Text_Stage + 1000
		local PacketPokemonSelect = playerTrade.Pokemon_Select + 1000
		local PacketTradeStart = playerTrade.Trade_Start + 1000
		local Filler = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
		Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. PacketTextStage .. PacketPokemonSelect .. PacketTradeStart .. Filler .. "U"
		--4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 31 + 1
		Socket:send(Packet)
		
	elseif RequestTemp == "NICK" then
		local PacketSpecialNickname --40 bytes max
		if string.len(NicknameSpecial) > 40 or utf8_length(NicknameSpecial) > 10 then
			Nickname = utf8_cut(Nickname, 10)
		elseif string.len(NicknameSpecial) < 40 then
			PacketSpecialNickname = NicknameSpecial .. string.rep("~", 43 - string.len(NicknameSpecial))
		else
			PacketSpecialNickname = NicknameSpecial
		end
		
		Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. PacketSpecialNickname .. "U"
		if DebugMessages.Nickname then console:log("NICKNAME: " .. Packet) end
		Socket:send(Packet)
		
	elseif RequestTemp == "CARD" then
		local gSendBuffer = gAddress[GameID].gSendBuffer
		local Filler = "FFF"
		if DebugMessages.Network or DebugMessages.Card then console:log("SEND SPECIAL DATA CARD START") end
		for i = 0, 8 do
			local CardData = emu:read32(gSendBuffer + (i*16))
			CardData = CardData + 1000000000
			for j = 1, 3 do
				local CardDataTemp = emu:read32(gSendBuffer + (i*16) + (j*4))
				CardDataTemp = CardDataTemp + 1000000000
				CardData = CardData .. CardDataTemp
			end
			Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. CardData .. Filler .. "U"
			--4 + 4 + 4 + 4 + 4 + 40 + 3 + 1
			Socket:send(Packet)
			if DebugMessages.Network or DebugMessages.Card then console:log("SEND PACKET " .. Packet) end
		end
		if DebugMessages.Network or DebugMessages.Card then console:log("SENT SPECIAL DATA CARD DONE") end
	
	elseif RequestTemp == "BATT" then
		player:ReadBattleVar()
		local playerBattle = player:GetBattleVar()
		local PacketTextStage = safeStringChar(playerBattle.Text_Stage)
		local PacketWaitingStatus = safeStringChar(playerBattle.Waiting_Status)
		local PacketBattle_Start = safeStringChar(playerBattle.Battle_Start)
		local PacketBuffer_ID = safeStringChar(playerBattle.Buffer_ID)
		local PacketAttacker = safeStringChar(playerBattle.Attacker)
		local PacketTarget = safeStringChar(playerBattle.Target)
		local PacketAbsent_Battler = safeStringChar(playerBattle.Absent_Battler)
		local PacketEffect_Battler = safeStringChar(playerBattle.Effect_Battler)
		local PacketSend_ID = safeStringChar(playerBattle.Send_ID)
		local PacketBufferA = {}
		local PacketBattleFlags = {}
		player.BattleVars.Transfer_Stage = 0
		for i=1, 30 do
			PacketBufferA[i] = safeStringChar(playerBattle.Buffer_A[i])
		end
		for i=1, 4 do
			PacketBattleFlags[i] = safeStringChar(playerBattle.Battleflags[i])
		end
		local Filler = "FFFF"
		Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp
		Packet = Packet .. PacketTextStage .. PacketWaitingStatus .. PacketBattle_Start .. PacketBuffer_ID .. PacketAttacker .. PacketTarget .. PacketAbsent_Battler .. PacketEffect_Battler
		for i=1, 30 do
			Packet = Packet .. PacketBufferA[i]
		end
		for i=1, 4 do
			Packet = Packet .. PacketBattleFlags[i]
		end
		Packet = Packet .. PacketSend_ID .. "U"
		Socket:send(Packet)
	
	elseif RequestTemp == "BAT2" then
		local playerBattle = player:GetBattleVar()
		local PacketBufferA = {}
		local PacketBufferB = {}
		player.BattleVars.Transfer_Stage = player.BattleVars.Transfer_Stage + 1
		local bufferaloc = 30 + 20*(player.BattleVars.Transfer_Stage - 1)
		local bufferbloc = 20*(player.BattleVars.Transfer_Stage - 1)
		for i=1, 20 do
			PacketBufferA[i] = safeStringChar(playerBattle.Buffer_A[i+bufferaloc])
		end
		for i=1, 20 do
			PacketBufferB[i] = safeStringChar(playerBattle.Buffer_B[i+bufferbloc])
		end
		local Filler = "FFF"
	--	console:log("PACKET BAT2: " .. Packet)
		Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp
		for i = 1, 20 do
			Packet = Packet .. PacketBufferA[i]
		end
		for i = 1, 20 do
			Packet = Packet .. PacketBufferB[i]
		end
		Packet = Packet .. Filler .. "U"
		Socket:send(Packet)
		
	
	--Initial battle parameters
	elseif RequestTemp == "BAT3" then
		local playerBattle = player:GetBattleVar2()
		local packettable = {}
		packettable[1] = safeStringChar(playerBattle.Link_Battle_Header_versionLo)
		packettable[2] = safeStringChar(playerBattle.Link_Battle_Header_versionHi)
		packettable[3] = safeStringChar(playerBattle.Link_Battle_Header_vsLo)
		packettable[4] = safeStringChar(playerBattle.Link_Battle_Header_vsHi)
		packettable[5] = {}
		for i = 1, 27 do
			packettable[5][i] = safeStringChar(playerBattle.Link_Battle_Header_Itemdata[i])
		end
		local Filler = "FFFFFFFFFFFF"
		Packet = PacketGameID .. PacketNickname .. PacketPlayerID .. PacketSendToID .. RequestTemp .. packettable[1] .. packettable[2] .. packettable[3] .. packettable[4]
		for i = 1, 27 do
			Packet = Packet .. packettable[5][i]
		end
		Packet = Packet .. Filler .. "U"
		Socket:send(Packet)
		
		
	elseif RequestTemp == "SLNK" then
		PlayerReceiveID = PlayerTalkingID2
		OptionalData = OptionalData or 0
		local Filler = "100000000000000000000000000000000"
		local SizeAct = OptionalData + 1000000000
		Packet = GameID .. Nickname .. PlayerID2 .. PlayerReceiveID .. RequestTemp .. SizeAct .. Filler .. "U"
	end
end

function SendData(Socket, DataType, ExtraData, DataToUse)
	local ExtraData = ExtraData or 0
	local DataToUse = DataToUse or PlayerID
	--If you have made a server
	if (DataType == "NewPlayer") then
		CreatePacket("STRT", ExtraData, DataToUse)
		Socket:send(Packet)
		CreateSpecialPacket(Socket, "NICK", ExtraData, DataToUse)
		Socket:send(Packet)
		CreatePacket("GNIC", ExtraData, DataToUse)
		Socket:send(Packet)
		if DebugMessages.Unable_To_Connect then console:log("SENT TO PLAYER STRT, NICK, AND GNIC") end
		--Update new player on current players
		for i, player in ipairs(players) do
			if player:GetID() ~= PlayerID and player:GetSocket() ~= Socket then
				CreatePacket("APLA", player:GetID(), player:GetID())
			--	console:log("SENDING APLA OF " .. player:GetID() .. " TO " .. ExtraData)
				Socket:send(Packet)
				CreateSpecialPacket(Socket, "GNIC", ExtraData, player:GetID())
				CreateSpecialPacket(Socket, "NICK", ExtraData, player:GetID())
			end
		end 
		--Update current players on new player
		for i, player in ipairs(players) do
			local PlayerSocket = player:GetSocket()
			if player:GetID() ~= PlayerID and player:GetSocket() ~= Socket then
				CreatePacket("APLA", ExtraData, ExtraData)
			--	console:log("SENDING APLA OF " .. ExtraData .. " TO " .. player:GetID())
				PlayerSocket:send(Packet)
			end
		end
	elseif (DataType == "Request") then
		--console:log("REQUEST!!")
		CreatePacket("JOIN", ExtraData, DataToUse)
		if DebugMessages.Unable_To_Connect then console:log("SENDING TO HOST PACKET: " .. Packet) end
		Socket:send(Packet)
	elseif (DataType == "Refuse") then
		CreatePacket("RFSE", ExtraData, DataToUse)
		Socket:send(Packet)
	elseif (DataType == "GPOS") then
		CreatePacket("GPOS", ExtraData, DataToUse)
		Socket:send(Packet)
	else
		CreatePacket(DataType, ExtraData, DataToUse)
		Socket:send(Packet)
	end
end

function SendSpecialData(Socket, DataType, ExtraData, DataToUse, Optional)
	local ExtraData = ExtraData or 0
	local DataToUse = DataToUse or PlayerID
	if DebugMessages.Network then console:log("SENDING SPECIAL DATA. SEND ID: " .. ExtraData .. " SENT FROM: " .. DataToUse) end
	CreateSpecialPacket(Socket, DataType, ExtraData, DataToUse, Optional)
end

function RandomizeNickname()
	local res = ""
	for i = 1, 4 do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

function GetInGameName()
	local save_loc = 0
	local name = ""
	local letter = 0
	local length = 0
	for i=0, 7 do
		if gAddress[GameID].sGameVersion ~= "RS" then
			save_loc = emu:read32(gAddress[GameID].gSaveBlock2Ptr)
		else
			save_loc = gAddress[GameID].gSaveBlock2Ptr --save pointer, RS is already pointed
		end
		letter = findKeyByValue(LanguageTable[LanguageTableType], emu:read8(save_loc+i))
		if letter then
			name = name .. letter
			length = length + 1
		end
	end
	if length == 0 then
		name = RandomizeNickname()
		console:log("No name found. Generating one...")
	end
	return name
end

function DecryptPokemon(personality, otid, data)
	local datastruct = {
		[0] = {1, 2, 3, 4},
		[1] = {1, 2, 4, 3},
		[2] = {1, 3, 2, 4},
		[3] = {1, 3, 4, 2},
		[4] = {1, 4, 2, 3},
		[5] = {1, 4, 3, 2},
		[6] = {2, 1, 3, 4},
		[7] = {2, 1, 4, 3},
		[8] = {2, 3, 1, 4},
		[9] = {2, 3, 4, 1},
		[10] = {2, 4, 1, 3},
		[11] = {2, 4, 3, 1},
		[12] = {3, 1, 2, 4},
		[13] = {3, 1, 4, 2},
		[14] = {3, 2, 1, 4},
		[15] = {3, 2, 4, 1},
		[16] = {3, 4, 1, 2},
		[17] = {3, 4, 2, 1},
		[18] = {4, 1, 2, 3},
		[19] = {4, 1, 3, 2},
		[20] = {4, 2, 1, 3},
		[21] = {4, 2, 3, 1},
		[22] = {4, 3, 1, 2},
		[23] = {4, 3, 2, 1},
	}
	local structure = {[1] = {}, [2] = {}, [3] = {}, [4] = {}, ["C"] = 0}
	local substruct = datastruct[personality % 24]
	local decryptkey = otid ~ personality
	
	--console:log("DECRYPT KEY: " .. personality % 24)
	
	if #data == 4 then
		for j=1, 4 do
			for i=1, 3 do --each substructure is 12 bytes, aka 3x4 bytes
				structure[substruct[j]][i] = data[j][i] ~ decryptkey
		--		console:log("DECRYPT STRUCT[" .. substruct[j] .. "][" .. i .. "]: " .. structure[substruct[j]][i])
				check_word_1 = structure[substruct[j]][i] & 0xFFFF
				check_word_2 = (structure[substruct[j]][i] >> 16) & 0xFFFF
				structure["C"] = (structure["C"] + check_word_1) & 0xFFFF
				structure["C"] = (structure["C"] + check_word_2) & 0xFFFF
			end
		end
	end
	if structure["C"] ~= data["C"] then
	--	console:log("BAD POKEMON CHECKSUM")
	--this rarely happens, probably when the game is trying to write something into pokemon at the same time
	end
	return structure
end

function EncryptPokemon(personality, otid, data)
	local datastruct = {
		[0] = {1, 2, 3, 4},
		[1] = {1, 2, 4, 3},
		[2] = {1, 3, 2, 4},
		[3] = {1, 3, 4, 2},
		[4] = {1, 4, 2, 3},
		[5] = {1, 4, 3, 2},
		[6] = {2, 1, 3, 4},
		[7] = {2, 1, 4, 3},
		[8] = {2, 3, 1, 4},
		[9] = {2, 3, 4, 1},
		[10] = {2, 4, 1, 3},
		[11] = {2, 4, 3, 1},
		[12] = {3, 1, 2, 4},
		[13] = {3, 1, 4, 2},
		[14] = {3, 2, 1, 4},
		[15] = {3, 2, 4, 1},
		[16] = {3, 4, 1, 2},
		[17] = {3, 4, 2, 1},
		[18] = {4, 1, 2, 3},
		[19] = {4, 1, 3, 2},
		[20] = {4, 2, 1, 3},
		[21] = {4, 2, 3, 1},
		[22] = {4, 3, 1, 2},
		[23] = {4, 3, 2, 1},
	}
	local structure = {[1] = {}, [2] = {}, [3] = {}, [4] = {}, ["C"] = 0}
	local substruct = datastruct[personality % 24]
	local decryptkey = otid ~ personality
	
	--console:log("ORDER: " .. substruct[1] .. " " .. substruct[2] .. " " .. substruct[3] .. " " .. substruct[4])
	if data["C"] then
		for j=1, 4 do
			for i=1, 3 do
				local data2 = data[substruct[j]]
		--		console:log("ENCRYPT STRUCT[" .. j .. "][" .. i .. "]: " .. data2[i] .. " data[" .. substruct[j] .. "][" .. i .. "]")
				structure["C"] = (structure["C"] + (data2[i])) & 0xFFFF
				structure["C"] = (structure["C"] + (data2[i] >> 16)) & 0xFFFF
				structure[j][i] = data2[i] ~ decryptkey
			end
		end
	else
	--	console:log("POKEMON INVALID. DATA: " .. #data)
	end
	return structure
end

function GetPokemonTeam(Player, slot)
	local PokemonTeamAddress = gAddress[GameID].gParty
	local PokemonTeamADRTEMP = 0
	local ReadTemp = ""
	local Pokemon = {}
	local PokemonTable = {}
	local Player = Player or FindPlayerByID(PlayerID)
	local slot = slot or 0
	if slot == 1 then
		PokemonTeamAddress = gAddress[GameID].gEnemyParty
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
	if DebugMessages.Trade or DebugMessages.Battle then console:log("COPYING POKEMON FROM SLOT " .. slot .. " TO PLAYER " .. Player:GetID()) end
		
	PokemonTable = {
		pokemon_1 = {
			rawdata = Pokemon[1],
			nickname = "",
			species = 0
		},
		pokemon_2 = {
			rawdata = Pokemon[2],
			nickname = "",
			species = 0
		},
		pokemon_3 = {
			rawdata = Pokemon[3],
			nickname = "",
			species = 0
		},
		pokemon_4 = {
			rawdata = Pokemon[4],
			nickname = "",
			species = 0
		},
		pokemon_5 = {
			rawdata = Pokemon[5],
			nickname = "",
			species = 0
		},
		pokemon_6 = {
			rawdata = Pokemon[6],
			nickname = "",
			species = 0
		}
	}
	Player:SetPokemon(PokemonTable)
end

function SetPokemonTeam(rawdata, pos, slot)
	local PokemonTeamAddress = gAddress[GameID].gEnemyParty
	local ReadTemp = ""
	local String1 = 0
	local String2 = 0
	local slot = slot or 1
	if slot == 0 then
		PokemonTeamAddress = gAddress[GameID].gParty
	end
	local PokemonTeamADRTEMP = PokemonTeamAddress + ((pos - 1) * 100)
	for i = 0, 24 do  -- Loop from 0 to 24 (25 iterations)
		local startPos = 1 + i * 10
		local ReadTemp = tonumber(string.sub(rawdata, startPos, startPos + 9)) - 1000000000
		emu:write32(PokemonTeamADRTEMP + i * 4, ReadTemp)
	end
end

function CheckPokemonHealth(pos, slot)
	local PokemonTeamAddress = gAddress[GameID].gParty
	local slot = slot or 0
	if slot == 1 then
		PokemonTeamAddress = gAddress[GameID].gEnemyParty
	end
	local adr = PokemonTeamAddress + 100*(pos-1)
	return emu:read16(adr+0x56)
end

function SetPokemonStat(species, level, statid, iv, ev, nature)
	local iv = iv or 0
	local ev = ev or 0
	local nature = nature or 0
	local stat = 0
	local naturetable = {
		[0] = {}, --hardy
		[1] = {[0] = 1, [1] = -1}, --lonely
		[2] = {[0] = 1, [2] = -1}, --brave
		[3] = {[0] = 1, [3] = -1}, --adamant
		[4] = {[0] = 1, [4] = -1}, --naughty
		[5] = {[0] = -1, [1] = 1}, --bold
		[6] = {}, --docile
		[7] = {[1] = 1, [2] = -1}, --relaxed
		[8] = {[1] = 1, [3] = -1}, --impish
		[9] = {[1] = 1, [4] = -1}, --lax
		[10] = {[0] = -1, [2] = 1}, --timid
		[11] = {[1] = -1, [2] = 1}, --hasty
		[12] = {}, --serious
		[13] = {[2] = 1, [3] = -1}, --jolly
		[14] = {[2] = 1, [4] = -1}, --naive
		[15] = {[0] = -1, [3] = 1}, --modest
		[16] = {[1] = -1, [3] = 1}, --mild
		[17] = {[2] = -1, [3] = 1}, --quiet
		[18] = {}, --bashful
		[19] = {[3] = 1, [4] = -1}, --rash
		[20] = {[0] = -1, [4] = 1}, --calm
		[21] = {[1] = -1, [4] = 1}, --gentle
		[22] = {[2] = -1, [4] = 1}, --sassy
		[23] = {[3] = -1, [4] = 1}, --careful
		[24] = {}, --quirky
	}
	if statid then
		--if shedinja and statid is hp, set to 1
		if species == 303 and statid == 0 then
			stat = 1
		elseif statid > 0 then
			local basestat = emu:read8(gAddress[GameID].gSpeciesInfo+(0x1C*species)+statid)
			stat = math.floor(((2*basestat + iv + (ev / 4))*level) / 100 + 5)
			--apply nature
			if naturetable[nature] then
				if naturetable[nature][statid - 1] then
					if naturetable[nature][statid - 1] == 1 then
						stat = math.floor((stat * 110) / 100)
					elseif naturetable[nature][statid - 1] == -1 then
						stat = math.floor((stat * 90) / 100)
					end
				end
			end
		else
			local n = 2 * emu:read8(gAddress[GameID].gSpeciesInfo+(0x1C*species)+statid) + iv;
			stat = math.floor((((n + ev / 4) * level) / 100) + level + 10)
		end
	end
	return stat
end

function HealPokemon(pos, slot) --if pos is 0, heal all
	local PokemonTeamAddress = gAddress[GameID].gParty
	local slot = slot or 0
	if slot == 1 then
		PokemonTeamAddress = gAddress[GameID].gEnemyParty
	end
	local loop_through = 0
	local start_pos = 0
	if pos > 0 and pos < 7 then
		loop_through = pos+1
		start_pos = pos
	elseif pos == 0 then
		loop_through = 7
		start_pos = 1
	end
	while (start_pos < loop_through) do
		local adr = PokemonTeamAddress + 100*(start_pos-1)
		local pokemondata = {}
		for i=1, 100 do --extract pokemon data
			pokemondata[i] = emu:read8(adr+(i-1))
		end
		--get encrypted stuff
		local checksum = pokemondata[0x1D] | (pokemondata[0x1E] << 8)
		local otid = pokemondata[0x5] | (pokemondata[0x6] << 8) | (pokemondata[0x7] << 16) | (pokemondata[0x8] << 24)
		local personality = pokemondata[0x1] | (pokemondata[0x2] << 8) | (pokemondata[0x3] << 16) | (pokemondata[0x4] << 24)
		local data = {}
		for j=1, 4 do
			data[j] = {}
			for i=1, 3 do
				local dataloc = 0x21 + (i-1)*4 + (j-1)*12
				data[j][i] = pokemondata[dataloc] | (pokemondata[dataloc+1] << 8) | (pokemondata[dataloc+2] << 16) | (pokemondata[dataloc+3] << 24)
			end
		end
		data["C"] = checksum
		--decrypt pokemon data
		decrypted_pokemon = DecryptPokemon(personality, otid, data)
		if decrypted_pokemon["C"] == checksum then --ensure the correct checksum is obtained before writing
			--heal hp and status with unencrypted data
			for i=0, 3 do
				pokemondata[0x50+i] = 0
			end
			pokemondata[0x56] = pokemondata[0x58]
			pokemondata[0x57] = pokemondata[0x59]
			--get pp bonuses
			local pp_bonus = decrypted_pokemon[1][3] & 0xFF --only get byte 1, which is pp bonus
			local pp_bonus_mask = {0x03,0x0C,0x30,0xC0}
			
			local moves = {}
			local pp = {}
			local pp_max = {}
			--get moves
			moves[1] = decrypted_pokemon[2][1] & 0xFFFF
			moves[2] = (decrypted_pokemon[2][1] >> 16) & 0xFFFF
			moves[3] = decrypted_pokemon[2][2] & 0xFFFF
			moves[4] = (decrypted_pokemon[2][2] >> 16) & 0xFFFF
			--get max pps
			pp_max[1] = emu:read8(gAddress[GameID].gBattleMoves + (0xC*moves[1]) + 0x4)
			pp_max[2] = emu:read8(gAddress[GameID].gBattleMoves + (0xC*moves[2]) + 0x4)
			pp_max[3] = emu:read8(gAddress[GameID].gBattleMoves + (0xC*moves[3]) + 0x4)
			pp_max[4] = emu:read8(gAddress[GameID].gBattleMoves + (0xC*moves[4]) + 0x4)
			--heal pp
			for i=1, 4 do
				pp[i] = pp_max[i] + math.floor((pp_max[i] * 20 * ((pp_bonus_mask[i] & pp_bonus) >> (2 * (i-1)))) / 100)
			--	pp[i] = ((decrypted_pokemon[2][3] >> ((i-1)*4)) & 0xFF)
			end
			decrypted_pokemon[2][3] = pp[1] | (pp[2] << 8) | (pp[3] << 16) | (pp[4] << 24)
		--	console:log("PP 1: " .. pp[1] .. " PP 1 MAX: " .. pp_max[1] .. " MOVE: " .. moves[1])
		--	console:log("pp bonus: " .. pp_bonus)
		--	console:log("CHECKSUM DECRYPT: " .. decrypted_pokemon["C"] .. " CHECKSUM ALREADY: " .. checksum)
			
			--encrypt pokemon data
			encrypted_pokemon = EncryptPokemon(personality, otid, decrypted_pokemon)
		--	console:log("CHECKSUM ENCRYPT: " .. encrypted_pokemon["C"] .. " CHECKSUM ALREADY: " .. checksum)
			pokemondata[0x1D] = encrypted_pokemon["C"] & 0xFF
			pokemondata[0x1E] = (encrypted_pokemon["C"] >> 8) & 0xFF
			--write the pokemon back
			for i=1, 32 do
				emu:write8(adr+(i-1), pokemondata[i])
			end
			--write encryted stuff
			for j=1, 4 do
				for i=1, 3 do
					local dataloc = (i-1)*4 + (j-1)*12
					emu:write8(adr+32+dataloc, encrypted_pokemon[j][i] & 0xFF)
					emu:write8(adr+32+dataloc+1, (encrypted_pokemon[j][i] >> 8) & 0xFF)
					emu:write8(adr+32+dataloc+2, (encrypted_pokemon[j][i] >> 16) & 0xFF)
					emu:write8(adr+32+dataloc+3, (encrypted_pokemon[j][i] >> 24) & 0xFF)
				end
			end
			for i=81, 100 do
				emu:write8(adr+(i-1), pokemondata[i])
			end
			start_pos = start_pos + 1
		else
			start_pos = start_pos + 1
		end
	end
end

function GetEncryptedStat(pos, slot, struct, offset)
	local PokemonTeamAddress = gAddress[GameID].gParty
	local slot = slot or 0
	local pos = pos or 0
	if slot == 1 then
		PokemonTeamAddress = gAddress[GameID].gEnemyParty
	end
	if struct and offset and pos > 0 then
		local adr = PokemonTeamAddress + 100*(pos-1)
		local pokemondata = {}
		for i=1, 100 do --extract pokemon data
			pokemondata[i] = emu:read8(adr+(i-1))
		end
		--get encrypted stuff
		local checksum = pokemondata[0x1D] | (pokemondata[0x1E] << 8)
		local otid = pokemondata[0x5] | (pokemondata[0x6] << 8) | (pokemondata[0x7] << 16) | (pokemondata[0x8] << 24)
		local personality = pokemondata[0x1] | (pokemondata[0x2] << 8) | (pokemondata[0x3] << 16) | (pokemondata[0x4] << 24)
		local data = {}
		for j=1, 4 do
			data[j] = {}
			for i=1, 3 do
				local dataloc = 0x21 + (i-1)*4 + (j-1)*12
				data[j][i] = pokemondata[dataloc] | (pokemondata[dataloc+1] << 8) | (pokemondata[dataloc+2] << 16) | (pokemondata[dataloc+3] << 24)
			end
		end
		data["C"] = checksum
		--decrypt pokemon data
		decrypted_pokemon = DecryptPokemon(personality, otid, data)
		if decrypted_pokemon["C"] == checksum then --ensure the correct checksum is obtained
			if struct < 1 then struct = 1 end
			if struct > 4 then struct = 4 end
			if offset < 1 then offset = 1 end
			if offset > 3 then offset = 3 end
			return decrypted_pokemon[struct][offset]
		else
			return 0
		end
	else
		return 0
	end
end

function AllowMaxPokemon(slot, amount)
	local PokemonTeamAddress = gAddress[GameID].gParty
	local slot = slot or 0
	local amount = amount or 0
	if slot == 1 then
		PokemonTeamAddress = gAddress[GameID].gEnemyParty
	end
	local done = 0
	if amount > 0 then
		for i = 1, 6 do
			local adr = PokemonTeamAddress + 100*(i-1)
			local hp = emu:read8(adr+0x56) | (emu:read8(adr+0x57) << 8)
			local pokeflags = emu:read8(adr+0x13)
			local egg = (GetEncryptedStat(i, slot, 4, 2) >> 30) & 0x1
			if hp > 0 and (pokeflags & 1) == 0 and (pokeflags & 2) ~= 0 and egg == 0 then --not empty and alive and not bad egg/egg
				done = done + 1
				if done > amount then --if at cap
					emu:write16(adr+0x56, 0)
				end
			end
		end
	end
end

function SetMaxPokemonLevel(pos, slot, level, raiselvl)
	local PokemonTeamAddress = gAddress[GameID].gParty
	local slot = slot or 0
	if slot == 1 then
		PokemonTeamAddress = gAddress[GameID].gEnemyParty
	end
	local loop_through = 0
	local start_pos = 0
	if pos > 0 and pos < 7 then
		loop_through = pos+1
		start_pos = pos
	elseif pos == 0 then
		loop_through = 7
		start_pos = 1
	end
	while (start_pos < loop_through) do
		local adr = PokemonTeamAddress + 100*(start_pos-1)
		local pokemondata = {}
		for i=1, 100 do
			pokemondata[i] = emu:read8(adr+(i-1))
		end
		--get encrypted stuff
		local checksum = pokemondata[0x1D] | (pokemondata[0x1E] << 8)
		local otid = pokemondata[0x5] | (pokemondata[0x6] << 8) | (pokemondata[0x7] << 16) | (pokemondata[0x8] << 24)
		local personality = pokemondata[0x1] | (pokemondata[0x2] << 8) | (pokemondata[0x3] << 16) | (pokemondata[0x4] << 24)
		local data = {}
		for j=1, 4 do
			data[j] = {}
			for i=1, 3 do
				local dataloc = 0x21 + (i-1)*4 + (j-1)*12
				data[j][i] = pokemondata[dataloc] | (pokemondata[dataloc+1] << 8) | (pokemondata[dataloc+2] << 16) | (pokemondata[dataloc+3] << 24)
			end
		end
		data["C"] = checksum
		--decrypt pokemon data
		decrypted_pokemon = DecryptPokemon(personality, otid, data)
		if decrypted_pokemon["C"] == checksum then --ensure the correct checksum is obtained
			--set stats based on iv, ev, level and species
			local species = (decrypted_pokemon[1][1] & 0xFFFF)
			local oldlvl = pokemondata[0x55]
			local old_hp = pokemondata[0x57] | (pokemondata[0x58] << 8)
			local old_hp_max = pokemondata[0x59] | (pokemondata[0x5a] << 8)
			local hp_diff = old_hp_max - old_hp
			if level then
				if oldlvl > level or raiselvl then
					for i=0, 5 do
						local stat_ev = decrypted_pokemon[3][1] & 0xFF
						local stat_iv = (decrypted_pokemon[4][2] >> (i*5)) & 0x1F
						local nature = personality % 25
						local actual_stat = SetPokemonStat(species, level, i, stat_iv, stat_ev, nature)
						local oldstat = pokemondata[0x59 + (i*2)] | (pokemondata[0x5A + (i*2)] << 8)
						if i == 0 then
							--set hp to new hp unless fainted
							if old_hp > 0 then
								local new_hp = actual_stat - hp_diff
								emu:write8(adr+0x56, new_hp & 0xFF)
								emu:write8(adr+0x57, (new_hp >> 8) & 0xFF)
							end
						end
						emu:write8(adr+0x58+(i*2), actual_stat & 0xFF)
						emu:write8(adr+0x59+(i*2), (actual_stat >> 8) & 0xFF)
					end
					--also set new lvl
					emu:write8(adr+0x54, level)
					
					--need to set exp to the level it is on, otherwise issues will happen
					local growthrate = emu:read8(gAddress[GameID].gSpeciesInfo+(0x1C*species)+0x13)
					decrypted_pokemon[1][2] = emu:read32(gAddress[GameID].gExperienceTables+(growthrate*0x194)+(level*4))
					encrypted_pokemon = EncryptPokemon(personality, otid, decrypted_pokemon)
					--write new checksum
					emu:write16(adr+0x1C, encrypted_pokemon["C"])
					--write encryted stuff
					for j=1, 4 do
						for i=1, 3 do
							local dataloc = (i-1)*4 + (j-1)*12
							emu:write8(adr+32+dataloc, encrypted_pokemon[j][i] & 0xFF)
							emu:write8(adr+32+dataloc+1, (encrypted_pokemon[j][i] >> 8) & 0xFF)
							emu:write8(adr+32+dataloc+2, (encrypted_pokemon[j][i] >> 16) & 0xFF)
							emu:write8(adr+32+dataloc+3, (encrypted_pokemon[j][i] >> 24) & 0xFF)
						end
					end
				end
			end
			start_pos = start_pos + 1
		else
			start_pos = start_pos + 1
		end
	end
end

function MoveEggs(slot)
	local PokemonTeamAddress = gAddress[GameID].gParty
	local slot = slot or 0
	local lastSlot = 5
	if slot == 1 then
		PokemonTeamAddress = gAddress[GameID].gEnemyParty
	end
	for i=1, 5 do
		local isEgg = (GetEncryptedStat(i, slot, 4, 2) >> 30) & 0x1
		local eggSlot = i-1
		if isEgg == 1 then
			console:log("EGG AT POS " .. i)
			--if egg, move to last slot and move every other pokemon up
			local eggpoke = {}
			for j=1, 25 do
				local currentPosition = (j-1)*4
				local adr = PokemonTeamAddress+eggSlot*100+currentPosition
				eggpoke[j] = emu:read32(adr)
			end
			for j=i, 5 do --only start where egg was found
				local currentSlot = j-1
				local nextSlot = j
				console:log("MOVING POKEMON " .. nextSlot .. " TO POS " .. currentSlot)
				for l=1, 25 do
					local currentPosition = (l-1)*4
					local adr = PokemonTeamAddress+currentSlot*100+currentPosition
					local nextadr = PokemonTeamAddress+nextSlot*100+currentPosition
					emu:write32(adr, emu:read32(nextadr))
				end
			end
			console:log("WRITING EGG AT SLOT " .. lastSlot)
			for j=1, 25 do
				local currentPosition = (j-1)*4
				local adr = PokemonTeamAddress+lastSlot*100+currentPosition
				emu:write32(adr, eggpoke[j])
			end
		end
	end
end

function CheckPokemonValid(rawdata)
	local isEmpty = 25
	for i=0, 24 do
		local data = tonumber(string.sub(rawdata, 1+(i*10), 10+(i*10))) - 1000000000
		if data == 0 then
			isEmpty = isEmpty - 1
		end
	end
	if isEmpty > 8 then
		return true
	end
	return false
end

function SetPokemonBattle(player, slot) --set before battle actually starts
	local player = player or FindPlayerByID(PlayerID)
	local player_count = 0
	local slot = slot or 1
	local party = gAddress[GameID].gEnemyParty
	for i=1,6 do
		pokemon = player:GetPokemonRaw(i)
		SetPokemonTeam(pokemon, i, slot)
		if CheckPokemonValid(pokemon) then
			player_count = player_count + 1
		--	console:log("VALID POKEMON")
		else
		--	console:log("EMPTY POKEMON AT SLOT " .. i)
		end
	end
	if player_count > 0 then
	--	console:log("PKMN AMOUNT: " .. player_count)
		if slot == 0 then
			emu:write8(gAddress[GameID].gPartyCount, player_count)
		else
			emu:write8(gAddress[GameID].gEnemyPartyCount, player_count)
		end
	--if all pokemon are invalid, then none are
	else
	--	console:log("INVALID POKEMON AMOUNT. SETTING TO 6")
		if slot == 0 then
			emu:write8(gAddress[GameID].gPartyCount, 6)
		else
			emu:write8(gAddress[GameID].gEnemyPartyCount, 6)
		end
	end
end

function ReleasePokemonBattle() --use pokemon pre battle
	local PokemonTeamAddress = gAddress[GameID].gParty
	local EnemyTeamAddress = gAddress[GameID].gEnemyParty
	
	--Player side
	local PokemonTeamADRTEMP = PokemonTeamAddress + ((pos - 1) * 100)
	for i = 0, 24 do  -- Loop from 0 to 24 (25 iterations)
		local startPos = 1 + i * 10
		local ReadTemp = tonumber(string.sub(rawdata, startPos, startPos + 9)) - 1000000000
		emu:write32(PokemonTeamADRTEMP + i * 4, ReadTemp)
	end
end

function SetPokemonData(Player, PokeData)
	if string.len(Player:GetPokemonRaw(6)) == 250 then
	--	console:log("RECEIVING NEW TEAM. WIPING FOR NEW DATA")
		Player:ClearPokemonRaw()
	end

	if string.len(Player:GetPokemonRaw(1)) < 250 then Player:SetPokemonRaw(1, PokeData)
	elseif string.len(Player:GetPokemonRaw(2)) < 250 then Player:SetPokemonRaw(2, PokeData)
	elseif string.len(Player:GetPokemonRaw(3)) < 250 then Player:SetPokemonRaw(3, PokeData)
	elseif string.len(Player:GetPokemonRaw(4)) < 250 then Player:SetPokemonRaw(4, PokeData)
	elseif string.len(Player:GetPokemonRaw(5)) < 250 then Player:SetPokemonRaw(5, PokeData)
	elseif string.len(Player:GetPokemonRaw(6)) < 250 then Player:SetPokemonRaw(6, PokeData)
	end
	
	if string.len(Player:GetPokemonRaw(6)) == 250 then
		--finished copying.
	--	console:log("COPYING DONE")
		player.TradeVars.Waiting_Status = player.TradeVars.Waiting_Status | 1
		player.BattleVars.Waiting_Status = player.BattleVars.Waiting_Status | 1
	end
end

function ClearTrade()
	if DebugMessages.Trade then console:log("CLEAR ALL PREVIOUS VARIABLES") end
	local player = FindPlayerByID(PlayerID)
	local opponent = FindPlayerByID(player:GetTalking())
	local TradeVars = {
		Text_Stage = 0,
		Pokemon_Select = 0,
		Trade_Start = 0,
		Waiting_Status = 0,
	}
	player:SetTradeVar(TradeVars)
end

function Tradescript()
	--Buffer 1 is enemy pokemon, 2 is our pokemon
	local Buffer1 = gAddress[GameID].gBuffer1
	local Buffer2 = gAddress[GameID].gBuffer2
	local Buffer3 = gAddress[GameID].gBuffer3
	
	local player = FindPlayerByID(PlayerID)
	if not player then LockFromScript = 0 return end
	local otherplayer = FindPlayerByID(player:GetTalking())
	if not otherplayer then LockFromScript = 0 return end
	local playerTrade = player:GetTradeVar()
	local otherplayerTrade = otherplayer:GetTradeVar()
	local tradesocket = Connected and SocketMain or otherplayer:GetSocket()
	
	if playerTrade.Text_Stage == 0 then
		if DebugMessages.Trade then console:log("TRADE SCRIPT START. SEND PKMN") end
		GetPokemonTeam(player, 0)
		SendSpecialData(tradesocket, "POKE", player:GetTalking())
		playerTrade.Text_Stage = 1
		Loadscript(4)
		
	elseif playerTrade.Text_Stage == 1 and Var8000[2] ~= 0 then
		if DebugMessages.Trade then console:log("ONE PLAYER IS DONE WITH WAIT TEXT ") end
		playerTrade.Text_Stage = 2
	
	elseif playerTrade.Text_Stage == 2 and otherplayerTrade.Text_Stage > 1 then
		if DebugMessages.Trade then console:log("BOTH PLAYERS ARE ON WAITING DONE. CHECK IF POKEMON SENT THEN GOTO INITIATE TRADE") end
		if (playerTrade.Waiting_Status & 1) ~= 0 then
			playerTrade.Text_Stage = 3
			Loadscript(14)
		else
			if DebugMessages.Trade then console:log("POKEMON NOT RECEIVED FULLY YET") end
		end
		
	elseif playerTrade.Text_Stage == 3 and Var8000[2] ~= 0 then
		if DebugMessages.Trade then console:log("YOU ARE DONE WITH START MESSAGE. GO TO TRADE MENU") end
		playerTrade.Text_Stage = 4
		if gAddress[GameID].sGameVersion == "E" and GameID ~= "BPEJ" then
			Loadscript(27)
		elseif GameID == "BPEJ" then
			Loadscript(32)
		else
			Loadscript(12)
		end
	
	--You have canceled or have not selected a valid pokemon slot
	elseif playerTrade.Text_Stage == 4 and Var8000[2] == 1 then
		if DebugMessages.Trade then console:log("YOU HAVE CANCELLED") end
		Loadscript(16)
		LockFromScript = 0
		if Hosting then
			SendData(otherplayer:GetSocket(), "CTRA", otherplayer:GetID())
		else
			SendData(SocketMain, "CTRA", otherplayer:GetID())
		end
		playerTrade.Text_Stage = 0
		playerTrade.Pokemon_Select = 0
		playerTrade.Trade_Start = 0
		
	--The other player has canceled
	elseif Var8000[2] == 2 and playerTrade.Text_Stage == 4 and OtherPlayerHasCancelled ~= 0 then
		if DebugMessages.Trade then console:log("THEY HAVE CANCELLED") end
		OtherPlayerHasCancelled = 0
		Loadscript(19)
		LockFromScript = 0
		playerTrade.Text_Stage = 0
		playerTrade.Pokemon_Select = 0
		playerTrade.Trade_Start = 0
	
	--You have selected a pokemon
	elseif Var8000[2] == 2 and playerTrade.Text_Stage == 4 and OtherPlayerHasCancelled == 0 then
		if DebugMessages.Trade then console:log("SELECTED POKEMON " .. Var8000[5]) end
		playerTrade.Pokemon_Select = Var8000[5] + 1
		if otherplayerTrade.Text_Stage > 5 then
			if DebugMessages.Trade then console:log("FAST FORWARD") end
			playerTrade.Text_Stage = 6
		else
			playerTrade.Text_Stage = 5
			Loadscript(4)
		end
		
	--Load message
	elseif playerTrade.Text_Stage == 5 and Var8000[2] ~= 0 then
		if DebugMessages.Trade then console:log("DONE WAITING SCREEN") end
		playerTrade.Text_Stage = 6
	
	--The other player cancels
	elseif playerTrade.Text_Stage == 6 and OtherPlayerHasCancelled ~= 0 then
		if DebugMessages.Trade then console:log("THEY HAVE CANCELLED") end
		OtherPlayerHasCancelled = 0
		Loadscript(19)
		LockFromScript = 0
		playerTrade.Text_Stage = 0
		playerTrade.Pokemon_Select = 0
		playerTrade.Trade_Start = 0
	
	--The other player also is finished with wait
	elseif playerTrade.Text_Stage == 6 and OtherPlayerHasCancelled == 0 and otherplayerTrade.Text_Stage > 5 then
		if DebugMessages.Trade then console:log("BOTH PLAYERS HAVE SELECTED. ASK IF SURE.") end
		local Pokedata = otherplayer:GetPokemonDecrypt(otherplayerTrade.Pokemon_Select)
		WriteBuffers(Buffer1, Pokedata.nickname, Pokedata.language, 11)
		Loadscript(8)
		playerTrade.Text_Stage = 7
		
	--You decline the offer
	elseif playerTrade.Text_Stage == 7 and Var8000[2] == 1 then
		if Hosting then
			SendData(otherplayer:GetSocket(), "ROFF", otherplayer:GetID())
		else
			SendData(SocketMain, "ROFF", otherplayer:GetID())
		end
		Loadscript(16)
		LockFromScript = 0
		playerTrade.Text_Stage = 0
		playerTrade.Pokemon_Select = 0
		playerTrade.Trade_Start = 0
			
	--If you accept and they deny
	elseif playerTrade.Text_Stage == 7 and Var8000[2] == 2 and OtherPlayerHasCancelled ~= 0 then
		if DebugMessages.Trade then console:log("THEY HAVE CANCELLED") end
		OtherPlayerHasCancelled = 0
		Loadscript(19)
		LockFromScript = 0
		playerTrade.Text_Stage = 0
		playerTrade.Pokemon_Select = 0
		playerTrade.Trade_Start = 0
	
	--If you accept and there is no denial
	elseif playerTrade.Text_Stage == 7 and Var8000[2] == 2 and OtherPlayerHasCancelled == 0 then
		--If other player isn't finished selecting, wait. Otherwise, go straight into trade.
		if otherplayerTrade.Text_Stage > 8 then
			playerTrade.Text_Stage = 9
			playerTrade.Trade_Start = 1
			local Pokedata = otherplayer:GetPokemonDecrypt(otherplayerTrade.Pokemon_Select)
			local rawdata = otherplayer:GetPokemonRaw(otherplayerTrade.Pokemon_Select)
			SetPokemonTeam(rawdata, 1, 1)
			
			local Buffer = GetNicknameBuffer(player:GetTalking())
			WriteToRom(gAddress[GameID].sOTName, Buffer)
			WriteRom(gAddress[GameID].sNickname, Pokedata.nickname, Pokedata.language, 11)
			
			if gAddress[GameID].sGameVersion == "E" and GameID ~= "BPEJ" then
				Loadscript(28)
			else
				Loadscript(17)
			end
		else
			Loadscript(4)
			playerTrade.Text_Stage = 8
		end
		
	elseif playerTrade.Text_Stage == 8 and Var8000[2] ~= 0 then
		if DebugMessages.Trade then console:log("DONE WAITING SCREEN") end
		playerTrade.Text_Stage = 9
			
	--If they deny it
	elseif playerTrade.Text_Stage == 9 and OtherPlayerHasCancelled ~= 0 then
		if DebugMessages.Trade then console:log("THEY HAVE CANCELLED") end
		OtherPlayerHasCancelled = 0
		Loadscript(19)
		LockFromScript = 0
		playerTrade.Text_Stage = 0
		playerTrade.Pokemon_Select = 0
		playerTrade.Trade_Start = 0
		
	elseif playerTrade.Text_Stage == 9 and otherplayerTrade.Text_Stage == 9 and playerTrade.Trade_Start == 0 then
		if DebugMessages.Trade then console:log("START TRADE") end
		playerTrade.Trade_Start = 1
		local Pokedata = otherplayer:GetPokemonDecrypt(otherplayerTrade.Pokemon_Select)
		local rawdata = otherplayer:GetPokemonRaw(otherplayerTrade.Pokemon_Select)
		SetPokemonTeam(rawdata, 1, 1)
		
		local Buffer = GetNicknameBuffer(player:GetTalking())
		WriteToRom(gAddress[GameID].sOTName,Buffer)
		WriteRom(gAddress[GameID].sNickname, Pokedata.nickname, Pokedata.language, 11)
		
		if gAddress[GameID].sGameVersion == "E" and GameID ~= "BPEJ" then
			Loadscript(28)
		else
			Loadscript(17)
		end
		
	elseif playerTrade.Text_Stage == 9 and otherplayerTrade.Text_Stage == 9 and playerTrade.Trade_Start == 1 then
		--Text for trade
		if Var8000[2] == 0 then
		--	console:log("LOAD TO MEMORY")
		--	Loadscript(23)
		--After trade
		elseif Var8000[2] ~= 0 then
			playerTrade.Text_Stage = 0
			playerTrade.Pokemon_Select = 0
			playerTrade.Trade_Start = 0
			LockFromScript = 0
		end
	end
	player:SetTradeVar(playerTrade)
end

function ClearBattle()
	if DebugMessages.Battle then console:log("CLEAR ALL PREVIOUS VARIABLES") end
	local player = FindPlayerByID(PlayerID)
	local opponent = FindPlayerByID(player:GetTalking())
	local playerBattle = {
		Text_Stage = 0,
		Waiting_Status = 0,
		Battle_Start = 0,
		Buffer_ID = 0,
		Attacker = 0,
		Target = 0,
		Absent_Battler = 0,
		Effect_Battler = 0,
		Transfer_Stage = 0,
		Send_ID = 0,
		Buffer_A = {},
		Buffer_B = {},
		Battleflags = {},
	}
	local playerBattle2 = {
		Link_Battle_Header_versionLo = 0,
		Link_Battle_Header_versionHi = 0,
		Link_Battle_Header_vsLo = 0,
		Link_Battle_Header_vsHi = 0,
		Link_Battle_Header_Itemdata = {},
		Transfer_Stage = 0,
	}
	player:SetBattleVar(playerBattle)
	player:SetBattleVar2(playerBattle2)
	opponent:SetBattleVar(playerBattle)
	opponent:SetBattleVar2(playerBattle2)
end

function InitiateBattle()
	local OtherPlayerVersion = 0
	local FRLG_Games = {BPR1 = true, BPR2 = true, BPG1 = true, BPG2 = true, BPRJ = true, BPGJ = true, BPRF = true, BPGF = true, BPRS = true, BPGS = true, BPRD = true, BPGD = true, BPRI = true, BPGI = true}
	local RS_Games = {AXV1 = true, AXV2 = true, AXP1 = true, AXP2 = true, AXVJ = true, AXPJ = true, AXVF = true, AXPF = true, AXVS = true, AXPS = true, AXVD = true, AXPD = true, AXVI = true, AXPI = true}
	local E_Games = {BPEE = true, BPEJ = true, BPEF = true, BPES = true, BPED = true, BPEI = true}
	local player = FindPlayerByID(PlayerID)
	local opponent = FindPlayerByID(player:GetTalking())
	if FRLG_Games[opponent:GetGameID()] then OtherPlayerVersion = 4
	elseif RS_Games[opponent:GetGameID()] then OtherPlayerVersion = 1
	elseif E_Games[opponent:GetGameID()] then OtherPlayerVersion = 3
	end
	
	if gAddress[GameID].sGameVersion == "FRLG" then
		--if items allowed, write. otherwise, revert. 
		if (BattleMain & BATTLE_FLAGS.ITEMS_ALLOWED) ~= 0 then
			if emu:read32(gAddress[GameID].HandleTurnActionSelectionState+0x3D4) == 0x902 then
				ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3D4, 0x900)
				if DebugMessages.Battle then console:log("WRITE ITEMS SUCCESS") end
			end
		else
			if emu:read32(gAddress[GameID].HandleTurnActionSelectionState+0x3D4) == 0x900 then
				ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3D4, 0x902)
				if DebugMessages.Battle then console:log("UNWRITE ITEMS SUCCESS") end
			end
		end
		--if exp allowed, write. otherwise, revert. 
		if (BattleMain & BATTLE_FLAGS.EXP_ALLOWED) ~= 0 then
			if emu:read32(gAddress[GameID].Cmd_getexp+0xD4) == 0x80982 then
				ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xD4, 0x80980)
				if DebugMessages.Battle then console:log("WRITE EXP SUCCESS") end
			end
		else
			if emu:read32(gAddress[GameID].Cmd_getexp+0xD4) == 0x80980 then
				ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xD4, 0x80982)
				if DebugMessages.Battle then console:log("UNWRITE EXP SUCCESS") end
			end
		end
		
		--if disable vs screen, skip pokemon intro 
		--[[
		if (BattleMain & BATTLE_FLAGS.DISABLE_VS_SCREEN) ~= 0 then
			if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x30) == 0x2802 then
				ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x30, 0xE16C)
				if DebugMessages.Battle then console:log("WRITE VS REMOVAL SUCCESS") end
			end
		else
			if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x30) == 0xE16C then
				ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x30, 0x2802)
				if DebugMessages.Battle then console:log("UNWRITE VS REMOVAL SUCCESS") end
			end
		end
		]]--
		
		--set wireless type to cable
		emu:write8(gAddress[GameID].gWirelessCommType, 0)
		--overwrite multiplayer stuff in battles (remove multiplayer tasks, such as error when no connection)
		ROMCARD:write16(gAddress[GameID].SetUpBattleVars+0x42, 0)
		ROMCARD:write16(gAddress[GameID].SetUpBattleVars+0x44, 0)

		--starting up multiplayer battle
		ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0xDE, 0xE006) --overwrites case 1 blocking
		if GameID ~= "BPRJ" and GameID ~= "BPGJ" then
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x2E0, 0) --overwrites copying content case 12
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x2E2, 0) --overwrites copying content case 12 pt2
		else
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x2DE, 0) --overwrites copying content case 12
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x2E0, 0) --overwrites copying content case 12 pt2
		end
		
		--Set flag if finished running player exec
		ROMCARD:write16(gAddress[GameID].PlayerBufferExecCompleted+0x1C, 0xE01A)
		
		--Set flag if finished running opponent exec
		ROMCARD:write16(gAddress[GameID].LinkOpponentBufferExecCompleted+0x1C, 0xE01A)
		
		--remove having to transfer data when doing anything
		ROMCARD:write16(gAddress[GameID].PrepareBufferDataTransfer+0x16, 0xE009)
		
		--reset sendblock so case 2 can edit it
		for i=0, 9 do
			emu:write8(gAddress[GameID].sBlockSend+i, 0)
		end
		
		--set multiplayer ID (host/client) and nickname
		local player = FindPlayerByID(PlayerID)
		local opponent = FindPlayerByID(player:GetTalking())
		local Side_Player = {
			Version = 4, --4/5 is firered/leafgreen, 1/2 is ruby/sapphire, 3 is emerald
			Name = GetNicknameBuffer(PlayerID),
			Gender = player:GetGender(),
			Language = 0,
		}
		local Side_Opponent = {
			Version = OtherPlayerVersion,
			Name = GetNicknameBuffer(player:GetTalking()),
			Gender = opponent:GetGender(),
			Language = 0,
		}
		local LinkPlayer = gAddress[GameID].gLinkPlayers + (player:GetBattleID() * 0x1C)
		local LinkOpponent = gAddress[GameID].gLinkPlayers + (opponent:GetBattleID() * 0x1C)
		local LinkPlayerBattleText = gAddress[GameID].gLinkPlayers + (4 * 0x1C)
		local linkplayers = {
			version = 0x0,
			trainerid = 0x2, --for stuff like saving records
			name = 0x8,
			gender = 0x13,
			linktype = 0x14, --checked before battle, usually irrelevant
			id = 0x18, --also not really used
			language = 0x1A,
		}
		if player:GetBattleID() == 0 then --host
			--id
			ROMCARD:write16(gAddress[GameID].GetMultiplayerId+0x10, 0x2000)
		else --client
			ROMCARD:write16(gAddress[GameID].GetMultiplayerId+0x10, 0x2001)
		end
		--clear all linkplayers
		for j=0, 3 do
			for i=0, 27	do
				emu:write8(gAddress[GameID].gLinkPlayers + i + (j * 28), 0)
			end
		end
		--version
		emu:write16(LinkPlayer+linkplayers.version,Side_Player.Version)
		emu:write16(LinkOpponent+linkplayers.version,Side_Opponent.Version)
		--names
		writeToMemory(LinkPlayer+linkplayers.name,Side_Player.Name)
		writeToMemory(LinkOpponent+linkplayers.name,Side_Opponent.Name)
		writeToMemory(LinkPlayerBattleText+linkplayers.name,Side_Opponent.Name)
		--gender
		emu:write8(LinkPlayer+linkplayers.gender,Side_Player.Gender)
		emu:write8(LinkOpponent+linkplayers.gender,Side_Opponent.Gender)
		--language
		emu:write16(LinkPlayer+linkplayers.language,Side_Player.Language)
		emu:write16(LinkOpponent+linkplayers.language,Side_Opponent.Language)
		
	elseif gAddress[GameID].sGameVersion == "RS" then
		--if items allowed, write. otherwise, revert. 
		if (BattleMain & BATTLE_FLAGS.ITEMS_ALLOWED) ~= 0 then
			if emu:read16(gAddress[GameID].HandleTurnActionSelectionState+0x3B0) == 0x902 then
				ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3B0, 0x900)
				if DebugMessages.Battle then console:log("WRITE ITEMS SUCCESS") end
			end
		else
			if emu:read16(gAddress[GameID].HandleTurnActionSelectionState+0x3B0) == 0x900 then
				ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3B0, 0x902)
				if DebugMessages.Battle then console:log("UNWRITE ITEMS SUCCESS") end
			end
		end
		--if exp allowed, write. otherwise, revert. 
		if (BattleMain & BATTLE_FLAGS.EXP_ALLOWED) ~= 0 then
			if emu:read32(gAddress[GameID].Cmd_getexp+0xAC) == 0x982 then
				ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xAC, 0x980)
				if DebugMessages.Battle then console:log("WRITE EXP SUCCESS") end
			end
		else
			if emu:read32(gAddress[GameID].Cmd_getexp+0xAC) == 0x980 then
				ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xAC, 0x982)
				if DebugMessages.Battle then console:log("UNWRITE EXP SUCCESS") end
			end
		end
		
		--if disable vs screen, skip pokemon intro
		--[[
		if (BattleMain & BATTLE_FLAGS.DISABLE_VS_SCREEN) ~= 0 then
			if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x38) == 0x2802 then
				ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x38, 0xE174)
				if DebugMessages.Battle then console:log("WRITE VS REMOVAL SUCCESS") end
			end
		else
			if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x38) == 0xE174 then
				ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x38, 0x2802)
				if DebugMessages.Battle then console:log("UNWRITE VS REMOVAL SUCCESS") end
			end
		end
		]]--
		
		--set wireless type to cable, or I would if ruby/sapphire HAD one
		--emu:write8(gAddress[GameID].gWirelessCommType, 0)
		--overwrite multiplayer stuff in battles, which is very wierd in ruby/sapphire
		ROMCARD:write16(gAddress[GameID].SetUpBattleVars+0x40, 0)
		ROMCARD:write16(gAddress[GameID].SetUpBattleVars+0x42, 0)

		--starting up multiplayer battle
		ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x80, 0xE001) --overwrites case 0 blocking
		ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x8C, 0xE001) --overwrites case 0 blocking pt 2
		if GameID ~= "AXVJ" and GameID ~= "AXPJ" then
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x2C8, 0) --overwrites copying content case 7
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x2CA, 0) --overwrites copying content case 7 pt2
		else
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x246, 0) --overwrites copying content case 7
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x248, 0) --overwrites copying content case 7 pt2
		end
		
		--Set flag if finished running player exec
		ROMCARD:write16(gAddress[GameID].PlayerBufferExecCompleted+0x1C, 0xE01A)
		
		--Set flag if finished running opponent exec
		ROMCARD:write16(gAddress[GameID].LinkOpponentBufferExecCompleted+0x1C, 0xE01A)
		
		--remove having to transfer data when doing anything
		ROMCARD:write16(gAddress[GameID].PrepareBufferDataTransfer+0x16, 0xE009)
		
		--reset sendblock so case 2 can edit it
		for i=0, 9 do
			emu:write8(gAddress[GameID].sBlockSend+i, 0)
		end
		
		--set multiplayer ID (host/client) and nickname
		local player = FindPlayerByID(PlayerID)
		local opponent = FindPlayerByID(player:GetTalking())
		local Side_Player = {
			Version = 1, --4/5 is firered/leafgreen, 1/2 is ruby/sapphire, 3 is emerald
			Name = GetNicknameBuffer(PlayerID),
			Gender = player:GetGender(),
			Language = 0,
		}
		local Side_Opponent = {
			Version = OtherPlayerVersion,
			Name = GetNicknameBuffer(player:GetTalking()),
			Gender = opponent:GetGender(),
			Language = 0,
		}
		local LinkPlayer = gAddress[GameID].gLinkPlayers + (player:GetBattleID() * 0x1C)
		local LinkOpponent = gAddress[GameID].gLinkPlayers + (opponent:GetBattleID() * 0x1C)
		local LinkPlayerBattleText = gAddress[GameID].gLinkPlayers + (4 * 0x1C)
		local linkplayers = {
			version = 0x0,
			trainerid = 0x2, --for stuff like saving records
			name = 0x8,
			gender = 0x13,
			linktype = 0x14, --checked before battle, usually irrelevant
			id = 0x18, --also not really used
			language = 0x1A,
		}
		if player:GetBattleID() == 0 then --host
			--id
			ROMCARD:write16(gAddress[GameID].GetMultiplayerId+0x6, 0x2000) --ruby doesn't use wireless, so multiplayerid is smaller
		else --client
			ROMCARD:write16(gAddress[GameID].GetMultiplayerId+0x6, 0x2001)
		end
		--clear all linkplayers
		for j=0, 3 do
			for i=0, 27	do
				emu:write8(gAddress[GameID].gLinkPlayers + i + (j * 28), 0)
			end
		end
		--version
		emu:write16(LinkPlayer+linkplayers.version,Side_Player.Version)
		emu:write16(LinkOpponent+linkplayers.version,Side_Opponent.Version)
		--names
		writeToMemory(LinkPlayer+linkplayers.name,Side_Player.Name)
		writeToMemory(LinkOpponent+linkplayers.name,Side_Opponent.Name)
		writeToMemory(LinkPlayerBattleText+linkplayers.name,Side_Opponent.Name)
		--gender
		emu:write8(LinkPlayer+linkplayers.gender,Side_Player.Gender)
		emu:write8(LinkOpponent+linkplayers.gender,Side_Opponent.Gender)
		--language
		emu:write16(LinkPlayer+linkplayers.language,Side_Player.Language)
		emu:write16(LinkOpponent+linkplayers.language,Side_Opponent.Language)
	
	elseif gAddress[GameID].sGameVersion == "E" then
		--if items allowed, write. otherwise, revert. 
		if (BattleMain & BATTLE_FLAGS.ITEMS_ALLOWED) ~= 0 then
			if emu:read32(gAddress[GameID].HandleTurnActionSelectionState+0x3E4) == 0x21F0902 then
				ROMCARD:write32(gAddress[GameID].HandleTurnActionSelectionState+0x3E4, 0x21F0900)
				if DebugMessages.Battle then console:log("WRITE ITEMS SUCCESS") end
			end
		else
			if emu:read16(gAddress[GameID].HandleTurnActionSelectionState+0x3E4) == 0x21F0900 then
				ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3E4, 0x21F0902)
				if DebugMessages.Battle then console:log("UNWRITE ITEMS SUCCESS") end
			end
		end
		--if exp allowed, write. otherwise, revert. 
		if (BattleMain & BATTLE_FLAGS.EXP_ALLOWED) ~= 0 then
			if emu:read32(gAddress[GameID].Cmd_getexp+0xD4) == 0x63F0982 then
				ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xD4, 0x63F0980)
				if DebugMessages.Battle then console:log("WRITE EXP SUCCESS") end
			end
		else
			if emu:read32(gAddress[GameID].Cmd_getexp+0xD4) == 0x63F0980 then
				ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xD4, 0x63F0982)
				if DebugMessages.Battle then console:log("UNWRITE EXP SUCCESS") end
			end
		end
		
		--if disable vs screen, skip pokemon intro
		--[[
		if (BattleMain & BATTLE_FLAGS.DISABLE_VS_SCREEN) ~= 0 then
			if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x30) == 0x2802 then
				ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x30, 0xE16A)
				if DebugMessages.Battle then console:log("WRITE VS REMOVAL SUCCESS") end
			end
		else
			if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x30) == 0xE16A then
				ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x30, 0x2802)
				if DebugMessages.Battle then console:log("UNWRITE VS REMOVAL SUCCESS") end
			end
		end
		]]--
		
		--set wireless type to cable
		emu:write8(gAddress[GameID].gWirelessCommType, 0)
		--overwrite multiplayer stuff in battles (remove multiplayer tasks, such as error when no connection)
		ROMCARD:write16(gAddress[GameID].SetUpBattleVars+0x42, 0)
		ROMCARD:write16(gAddress[GameID].SetUpBattleVars+0x44, 0)

		--starting up multiplayer battle
		ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0xE6, 0xE006)
		if GameID ~= "BPEJ" then
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x322, 0) --overwrites copying content case 12
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x324, 0) --overwrites copying content case 12 pt2
		else
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x320, 0) --overwrites copying content case 12
			ROMCARD:write16(gAddress[GameID].CB2_HandleStartBattle+0x322, 0) --overwrites copying content case 12 pt2
		end
		
		--Set flag if finished running player exec
		ROMCARD:write16(gAddress[GameID].PlayerBufferExecCompleted+0x1C, 0xE01A)
		
		--Set flag if finished running opponent exec
		ROMCARD:write16(gAddress[GameID].LinkOpponentBufferExecCompleted+0x1C, 0xE01A)
		
		--remove having to transfer data when doing anything
		ROMCARD:write16(gAddress[GameID].PrepareBufferDataTransfer+0x16, 0xE009)
		
		--reset sendblock so case 2 can edit it
		for i=0, 9 do
			emu:write8(gAddress[GameID].sBlockSend+i, 0)
		end
		
		--set multiplayer ID (host/client) and nickname
		local player = FindPlayerByID(PlayerID)
		local opponent = FindPlayerByID(player:GetTalking())
		local Side_Player = {
			Version = 3, --4/5 is firered/leafgreen, 1/2 is ruby/sapphire, 3 is emerald
			Name = GetNicknameBuffer(PlayerID),
			Gender = player:GetGender(),
			Language = 0,
		}
		local Side_Opponent = {
			Version = OtherPlayerVersion,
			Name = GetNicknameBuffer(player:GetTalking()),
			Gender = opponent:GetGender(),
			Language = 0,
		}
		local LinkPlayer = gAddress[GameID].gLinkPlayers + (player:GetBattleID() * 0x1C)
		local LinkOpponent = gAddress[GameID].gLinkPlayers + (opponent:GetBattleID() * 0x1C)
		local LinkPlayerBattleText = gAddress[GameID].gLinkPlayers + (4 * 0x1C)
		local linkplayers = {
			version = 0x0,
			trainerid = 0x2, --for stuff like saving records
			name = 0x8,
			gender = 0x13,
			linktype = 0x14, --checked before battle, usually irrelevant
			id = 0x18, --also not really used
			language = 0x1A,
		}
		if player:GetBattleID() == 0 then --host
			--id
			ROMCARD:write16(gAddress[GameID].GetMultiplayerId+0x10, 0x2000)
		else --client
			ROMCARD:write16(gAddress[GameID].GetMultiplayerId+0x10, 0x2001)
		end
		--clear all linkplayers
		for j=0, 3 do
			for i=0, 27	do
				emu:write8(gAddress[GameID].gLinkPlayers + i + (j * 28), 0)
			end
		end
		--version
		emu:write16(LinkPlayer+linkplayers.version,Side_Player.Version)
		emu:write16(LinkOpponent+linkplayers.version,Side_Opponent.Version)
		--names
		writeToMemory(LinkPlayer+linkplayers.name,Side_Player.Name)
		writeToMemory(LinkOpponent+linkplayers.name,Side_Opponent.Name)
		writeToMemory(LinkPlayerBattleText+linkplayers.name,Side_Opponent.Name)
		--gender
		emu:write8(LinkPlayer+linkplayers.gender,Side_Player.Gender)
		emu:write8(LinkOpponent+linkplayers.gender,Side_Opponent.Gender)
		--language
		emu:write16(LinkPlayer+linkplayers.language,Side_Player.Language)
		emu:write16(LinkOpponent+linkplayers.language,Side_Opponent.Language)
	end
end

function Battlescript()
	local Buffer1 = gAddress[GameID].gBuffer1
	local Buffer2 = gAddress[GameID].gBuffer2
	local Buffer3 = gAddress[GameID].gBuffer3
	
	local Controller_1 = emu:read8(gAddress[GameID].gBattleBufferA)
	local MainFunc = emu:read32(gAddress[GameID].gBattleMainFunc)
	local MainFunc2 = emu:read32(gAddress[GameID].gMainCallback)
	
	local player = FindPlayerByID(PlayerID)
	if not player then LockFromScript = 0 return end
	if not player then LockFromScript = 0 return end
	local otherplayer = FindPlayerByID(player:GetTalking())
	if not otherplayer then LockFromScript = 0 return end
	local PlayerVersion = "FRLG"
	local OtherPlayerVersion = "FRLG"
	local FRLG_Games = {BPR1 = true, BPR2 = true, BPG1 = true, BPG2 = true, BPRJ = true, BPGJ = true, BPRF = true, BPGF = true, BPRS = true, BPGS = true, BPRD = true, BPGD = true, BPRI = true, BPGI = true}
	local RS_Games = {AXV1 = true, AXV2 = true, AXP1 = true, AXP2 = true, AXVJ = true, AXPJ = true, AXVF = true, AXPF = true, AXVS = true, AXPS = true, AXVD = true, AXPD = true, AXVI = true, AXPI = true}
	local E_Games = {BPEE = true, BPEJ = true, BPEF = true, BPES = true, BPED = true, BPEI = true}
	if FRLG_Games[otherplayer:GetGameID()] then OtherPlayerVersion = "FRLG"
	elseif RS_Games[otherplayer:GetGameID()] then OtherPlayerVersion = "RS"
	elseif E_Games[otherplayer:GetGameID()] then OtherPlayerVersion = "E"
	end
	if FRLG_Games[GameID] then PlayerVersion = "FRLG"
	elseif RS_Games[GameID] then PlayerVersion = "RS"
	elseif E_Games[GameID] then PlayerVersion = "E"
	end
	player:ReadBattleVar()
	local playerBattle = player:GetBattleVar()
	local playerBattle2 = player:GetBattleVar2()
	local otherplayerBattle = otherplayer:GetBattleVar()
	local otherplayerBattle2 = otherplayer:GetBattleVar2()
	local battlesocket = Connected and SocketMain or otherplayer:GetSocket()
	local battleflags = {}
	local battlefunc = {}
	local battlecomm = {}
	local playerBattleID = player:GetBattleID()
	local FLAGS = {
	  SENDING = 1,
	  WRITTEN = 2,
	  ACTIVATED = 4,
	  FINISHED = 8,
	  UPDATED_ITEM = 16,
	  UPDATED_LVL = 32,
	  UPDATE_PKMN = 64,
	  TO_UPDATE = 128,
	}
	local Pause_Func = {0}
	local PLAYERS = {1, 2, 4, 8}
	local PLAYERS2 = {16, 32, 64, 128}
	local BattleTypeFlag = emu:read32(gAddress[GameID].gBattleTypeFlags)
	for i=1, 4 do
		battleflags[i] = emu:read8(gAddress[GameID].gBattleControllerExecFlags+i-1)
		battlefunc[i] = emu:read8(gAddress[GameID].gBattleBufferA+((i-1)*0x200))
		battlecomm[i] = emu:read8(gAddress[GameID].gBattleCommunication+i-1)
	end
	battleflags[5] = emu:read32(gAddress[GameID].gBattleControllerExecFlags)
	
	--console:log("BATTLE SCRIPT TEXT STAGE: " .. playerBattle.Text_Stage .. " OTHERPLAYER: " .. otherplayerBattle.Text_Stage)
	if playerBattle.Text_Stage == 0 and otherplayerBattle.Text_Stage < 3 then
		if DebugMessages.Battle then console:log("BATTLE SCRIPT START") end
		playerBattle.Text_Stage = 1
		Loadscript(4)
		
	elseif playerBattle.Text_Stage == 1 and Var8000[2] ~= 0 then
		if DebugMessages.Battle then console:log("ONE PLAYER IS DONE WITH WAIT TEXT ") end
		playerBattle.Text_Stage = 2
	
	elseif playerBattle.Text_Stage == 2 and otherplayerBattle.Text_Stage > 1 then
		if DebugMessages.Battle then console:log("BOTH PLAYERS ARE ON WAITING DONE. NOW INITIATE START BATTLE MESSAGE") end
		playerBattle.Text_Stage = 3
		emu:write8(gAddress[GameID].gBlockReceivedStatus, 0x0) --prepare the game
		emu:write32(gAddress[GameID].gBattlerControllerFuncs, 0) --clear any battle flags
		--this is incase there was a previous battle, in which case comm is set to 0
		battlecomm[1] = 0
		InitiateBattle()
		Loadscript(37)
	elseif playerBattle.Text_Stage == 3 then
		local isBlockSent = emu:read8(gAddress[GameID].sBlockSend+8)
		if ((battlecomm[1] == 2 and gAddress[GameID].sGameVersion ~= "RS") or (battlecomm[1] == 1 and gAddress[GameID].sGameVersion == "RS")) and isBlockSent == 1 then
			if DebugMessages.Battle then console:log("COPY SENDBLOCK DATA, SEND, ADVANCE") end
			local sendblockdata = {
				Link_Battle_Header_versionLo = emu:read8(gAddress[GameID].gSendBuffer),
				Link_Battle_Header_versionHi = emu:read8(gAddress[GameID].gSendBuffer+1),
				Link_Battle_Header_vsLo = emu:read8(gAddress[GameID].gSendBuffer+2),
				Link_Battle_Header_vsHi = emu:read8(gAddress[GameID].gSendBuffer+3),
				Link_Battle_Header_Itemdata = {},
				Transfer_Stage = 0,
			}
			for i=1, 27 do
				sendblockdata.Link_Battle_Header_Itemdata[i] = emu:read8(gAddress[GameID].gSendBuffer+3+i)
			end
			player:SetBattleVar2(sendblockdata)
			SendSpecialData(battlesocket, "BAT3", otherplayer:GetID())
			playerBattle.Text_Stage = 4
		end
	elseif playerBattle.Text_Stage == 4 then
		if otherplayerBattle2.Transfer_Stage == 1 and ((battlecomm[1] == 2 and gAddress[GameID].sGameVersion ~= "RS") or (battlecomm[1] == 1 and gAddress[GameID].sGameVersion == "RS")) then
			if DebugMessages.Battle then console:log("RECEIVED BAT3 CONTENT AND BATTLECOMM IS 2") end
			otherplayer.BattleVars2.Transfer_Stage = 0
			for i=0, 1 do
				local receivebuffer = gAddress[GameID].gReceiveBuffer + (0x100*i)
				emu:write8(receivebuffer,otherplayerBattle2.Link_Battle_Header_versionLo)
				emu:write8(receivebuffer+1,otherplayerBattle2.Link_Battle_Header_versionHi)
				emu:write8(receivebuffer+2,otherplayerBattle2.Link_Battle_Header_vsLo)
				emu:write8(receivebuffer+3,otherplayerBattle2.Link_Battle_Header_vsHi)
				if DebugMessages.Battle then console:log("VSLO: " .. otherplayerBattle2.Link_Battle_Header_vsLo .. " VSHI: " .. otherplayerBattle2.Link_Battle_Header_vsHi) end
				writeToMemory(receivebuffer+4,otherplayerBattle2.Link_Battle_Header_Itemdata)
			end
			--assign main callback so the game doesn't crash after battle
			emu:write32(gAddress[GameID].gMainSavedCallback, gAddress[GameID].CB2_ReturnToField+1)
			--set case 2 to be active
			emu:write8(gAddress[GameID].gBlockReceivedStatus, 0x3)
			playerBattle.Waiting_Status = playerBattle.Waiting_Status | 2 --this is to ensure that pokemon data is waited for
			playerBattle.Text_Stage = 5
		end
	elseif playerBattle.Text_Stage == 5 and otherplayerBattle.Text_Stage > 4 and otherplayerBattle.Transfer_Stage > 6 then
		if ((battlecomm[1] > 2 and gAddress[GameID].sGameVersion ~= "RS") or (battlecomm[1] > 1 and gAddress[GameID].sGameVersion == "RS")) and (playerBattle.Waiting_Status & 2) ~= 0 then
			--send pkmn over, have to do it here due to deoxys stats
			playerBattle.Waiting_Status = playerBattle.Waiting_Status - 2
			--save pre team and send it, also stored for after battle
			GetPokemonTeam(player, 0)
			SendSpecialData(battlesocket, "POKE", otherplayer:GetID())
		elseif ((battlecomm[1] > 2 and battlecomm[1] < 12 and gAddress[GameID].sGameVersion ~= "RS") or (battlecomm[1] > 1 and battlecomm[1] < 7 and gAddress[GameID].sGameVersion == "RS")) and playerBattle.Waiting_Status == 1 and (otherplayerBattle.Waiting_Status == 1 or otherplayerBattle.Text_Stage > 5) then
			--if case is passed 2, skip all the other network stuff except for initializing battle controllers and stuff
			if gAddress[GameID].sGameVersion ~= "RS" then
				emu:write8(gAddress[GameID].gBattleCommunication, 12)
			else
				emu:write8(gAddress[GameID].gBattleCommunication, 7)
			end
			emu:write8(gAddress[GameID].gBlockReceivedStatus, 0x3)
			--also finally copy the pokemon contents to correct shedinja
			if DebugMessages.Battle then console:log("POKEMON SENT. SETTING CONTENTS") end
			SetPokemonBattle(otherplayer, 1) --0 = player, 1 = enemy
			--set remotelinkplayer
			emu:write8(gAddress[GameID].gReceivedRemoteLinkPlayers, 1)
			--extract battlemaster and set battleid to master
			--also due to how the battle system works I need to set the battlemaster be emerald, then RS, then FRLG
			if PlayerVersion == "E" and OtherPlayerVersion ~= "E" then
				player:SetBattleID(0)
				BattleTypeFlag = BattleTypeFlag | 4
			elseif PlayerVersion ~= "E" and OtherPlayerVersion == "E" then
				player:SetBattleID(1)
				BattleTypeFlag = BattleTypeFlag & ~4
			elseif PlayerVersion == "RS" and OtherPlayerVersion ~= "RS" then
				player:SetBattleID(0)
				BattleTypeFlag = BattleTypeFlag | 4
			elseif PlayerVersion ~= "RS" and OtherPlayerVersion == "RS" then
				player:SetBattleID(1)
				BattleTypeFlag = BattleTypeFlag & ~4
			elseif player:GetBattleID() == 0 then
				BattleTypeFlag = BattleTypeFlag | 4
			else
				BattleTypeFlag = BattleTypeFlag & ~4
			end
			--ensure you have eggs in last slots
			MoveEggs(0)
			MoveEggs(1)
			--if heal pre battle, apply
			if (BattleMain & BATTLE_FLAGS.HEAL_PRE_BATTLE) ~= 0 then
				HealPokemon(0,0) --heal party
				HealPokemon(0,1) --heal enemy party
			end
			--apply double battle here if flag is set
			if (BattleMain & BATTLE_FLAGS.DOUBLE_BATTLE) ~= 0 then
				BattleTypeFlag = BattleTypeFlag | 1 --1 is double battle flag
			end
			--apply max level to pokemon if flag set
			if (BattleMain & BATTLE_FLAGS.LEVEL_CAP) ~= 0 then
				local setminlevel = false
				if (BattleMain & BATTLE_FLAGS.RAISE_TO_MAX) ~= 0 then setminlevel = true end
				if BattleLevelCap > 0 then
					SetMaxPokemonLevel(0, 1, BattleLevelCap, setminlevel) --0 is pos (0 is all, 1-6 is exact), 1 is team (0 is player, 1 is enemy), 50 is level
					SetMaxPokemonLevel(0, 0, BattleLevelCap, setminlevel)
				else
					SetMaxPokemonLevel(0, 1, 50, setminlevel)
					SetMaxPokemonLevel(0, 0, 50, setminlevel)
				end
			end
			--apply pokemon cap if flag set
			if (BattleMain & BATTLE_FLAGS.POKEMON_CAP) ~= 0 then
				if BattlePokemonCap == 0 then BattlePokemonCap = 3 end
				AllowMaxPokemon(0, BattlePokemonCap)
				AllowMaxPokemon(1, BattlePokemonCap)
			end
			if DebugMessages.Battle then console:log("BATTLE FLAG: " .. BattleTypeFlag) end
			emu:write32(gAddress[GameID].gBattleTypeFlags, BattleTypeFlag)
			emu:write32(gAddress[GameID].gBattlerControllerFuncs, 0) --clear any battle flags
			emu:write8(gAddress[GameID].gReceivedRemoteLinkPlayers, 1) --ensure it considers a connection
			emu:write32(gAddress[GameID].gBattleBufferA, 0) --ensure no previous battle commands interfere with current battle
			emu:write32(gAddress[GameID].gBattleControllerExecFlags, 0) --ensure no previous active states interfere
			playerBattle.Text_Stage = 6
			if DebugMessages.Battle then console:log("BATTLE COMM 2 IS DONE RUNNING") end
			playerBattle.Waiting_Status = 0
		elseif playerBattle.Waiting_Status > 0 then
			if DebugMessages.Battle then console:log("WAITING STATUS: " .. playerBattle.Waiting_Status) end
		end
	elseif playerBattle.Text_Stage == 6 and otherplayerBattle.Transfer_Stage > 6 then
		--if game version is emerald, skip video rng stuff
		if gAddress[GameID].sGameVersion == "E" then
			if battlecomm[1] == 16 then
				emu:write8(gAddress[GameID].gBattleCommunication, 18) --18 is start for emerald
				playerBattle.Text_Stage = 7
			elseif battlecomm[1] > 16 then
				playerBattle.Text_Stage = 7
			end
		else
			playerBattle.Text_Stage = 7
		end
	elseif playerBattle.Text_Stage == 7 and otherplayerBattle.Text_Stage == 7 and Controller_1 ~= 0x37 and (playerBattle.Waiting_Status & FLAGS.UPDATE_PKMN) == 0 then
	--	console:log("BATTLE LOOP.")
		local p = playerBattle.Waiting_Status
		local e = otherplayerBattle.Waiting_Status
		if battleflags[4] ~= 0 and (battleflags[4] >> 4) == 0 then
			battleflags[4] = battleflags[4] << 4
		end
		local turntaken = false
		
		--if buffer a and buffer b is read
		if otherplayerBattle.Transfer_Stage > 6 then
			--host
			if playerBattleID == 0 then
				--sleep only if 1 cycle is done
				if (battleflags[1] ~= 0 or battleflags[2] ~= 0 or battleflags[3] ~= 0 or battleflags[4] ~= 0) then
					if (battleflags[4] & PLAYERS2[1]) ~= 0 then playerBattle.Buffer_ID = 1
					elseif (battleflags[4] & PLAYERS2[2]) ~= 0 then playerBattle.Buffer_ID = 2
					elseif (battleflags[4] & PLAYERS2[3]) ~= 0 then playerBattle.Buffer_ID = 3
					elseif (battleflags[4] & PLAYERS2[4]) ~= 0 then playerBattle.Buffer_ID = 4
					else playerBattle.Buffer_ID = 0
					end
					--lvl up is buffer a 25 buffer b 33 11, gBattleScripting.getexpState = 5
					--if item is used, update both teams
					local action = {}
					--+0 is host, +1 is client 0 = move, 1 = item
					action[1] = emu:read8(gAddress[GameID].gChosenActionByBattler)
					action[2] = emu:read8(gAddress[GameID].gChosenActionByBattler+1)
					action[3] = emu:read8(gAddress[GameID].gChosenActionByBattler+2)
					action[4] = emu:read8(gAddress[GameID].gChosenActionByBattler+3)
					local item = emu:read16(gAddress[GameID].gBattleBufferB)
					local pkmndone = true
					
					--in on handleactions
					if MainFunc == gAddress[GameID].HandleTurnActionSelectionState+1 then
						if battlecomm[1] == 1 and battlecomm[2] == 1 then
							p = p | FLAGS.UPDATED_ITEM
						end
					elseif (BattleMain & BATTLE_FLAGS.ITEMS_ALLOWED) ~= 0 and (p & FLAGS.UPDATED_ITEM) ~= 0 then
						--if items are allowed, update players pokemon each turn before execution
					--	emu:write16(gAddress[GameID].gNativeData, 0x4770) --basically set this to dead end
						MainBattleFunc_Saved = MainFunc
					--	emu:write32(gAddress[GameID].gBattleMainFunc, gAddress[GameID].gNativeData+1)
						if DebugMessages.Battle then console:log("ITEM UPDATE!!!") end
						p = p & ~FLAGS.UPDATED_ITEM
						p = p |FLAGS.TO_UPDATE
						turntaken = true
					end
					--if exp gain
					local getexpState = emu:read8(gAddress[GameID].gBattleEXP)
					local expgain = emu:read32(gAddress[GameID].gBattleMoveDamage)
					if turntaken == false then
						--if applying exp and exp state is case 5 aka applied finished 1 lv up and not applied
						if getexpState > 0 and getexpState < 6 and (BattleMain & BATTLE_FLAGS.EXP_ALLOWED) ~= 0 and (p & FLAGS.UPDATED_LVL) == 0 then
							if DebugMessages.Battle then console:log("EXP GAINED!!!") end
							p = p | FLAGS.UPDATED_LVL
						elseif getexpState == 6 and (p & FLAGS.UPDATED_LVL) ~= 0 then
							if DebugMessages.Battle then console:log("FINISHED EXP!!!") end
						--	emu:write16(gAddress[GameID].gNativeData, 0x4770) --basically set this to dead end
							MainBattleFunc_Saved = MainFunc
						--	emu:write32(gAddress[GameID].gBattleMainFunc, gAddress[GameID].gNativeData+1)
							p = p & ~FLAGS.UPDATED_LVL
							--update when free
							p = p | FLAGS.TO_UPDATE
							turntaken = true
						end
					end
					
					--basically if wanting to update and all other vars are cleared, update
					if (p & FLAGS.TO_UPDATE) ~= 0 and (p & FLAGS.WRITTEN) == 0 and (e & FLAGS.WRITTEN) == 0 and (e & FLAGS.UPDATE_PKMN) == 0 then
						turntaken = true
						p = p | FLAGS.UPDATE_PKMN
						p = p & ~FLAGS.TO_UPDATE
						SendSpecialData(battlesocket, "POK2", otherplayer:GetID()) --pok2 is direct read/write of your team to enemyteam
					end
					--if not updating pkmn
					if turntaken == false then
						--client has received contents
						if (e & FLAGS.WRITTEN) ~= 0 and (e & FLAGS.ACTIVATED) == 0 and otherplayerBattle.Buffer_ID > 0 then
							local bufferid = otherplayerBattle.Buffer_ID
							--if still in network, clear and set active + network active
							if (battleflags[4] & PLAYERS2[bufferid]) ~= 0 then
								if DebugMessages.Battle then console:log("[PLAYER " .. otherplayerBattle.Buffer_ID .. "]: RECEIVED A SUCCESS. ACTIVATING FLAGS") end
								battleflags[1] = battleflags[1] | PLAYERS[bufferid]
								battleflags[1] = battleflags[1] | PLAYERS2[bufferid]
								battleflags[4] = battleflags[4] & ~PLAYERS2[bufferid]
								--also 
								playerBattle.Send_ID = playerBattle.Send_ID | PLAYERS[otherplayerBattle.Buffer_ID]
							else
							--	console:log("[PLAYER " .. otherplayerBattle.Buffer_ID .. "]: INVALID! RECEIVED PLAYER THAT ISN'T IN NETWORK.")
							end
						--client wants to send contents back
						elseif (e & FLAGS.WRITTEN) ~= 0 and (e & FLAGS.ACTIVATED) ~= 0 and otherplayerBattle.Buffer_ID > 0 then
							local bufferid = otherplayerBattle.Buffer_ID
							--if network active, copy buffer b and clear network active
							if (battleflags[1] & PLAYERS2[bufferid]) ~= 0 then
								if DebugMessages.Battle then console:log("[PLAYER " .. bufferid .. "]: CLIENT IS SENDING CONTENTS. COPYING...") end
								--only copy contents of player 2/4 (client, double battles use 4 slots) to their buffer b
								if bufferid == 2 or bufferid == 4 then
									if #otherplayerBattle.Buffer_B > 139 then
										local buffer_place = 0x200*(bufferid - 1)
										for i=1, 140 do
											emu:write8(gAddress[GameID].gBattleBufferB+i-1+buffer_place, otherplayerBattle.Buffer_B[i])
										end
										--set set flags to finished so the client knows we got the content
										p = p | FLAGS.FINISHED
										if DebugMessages.Battle then console:log("[PLAYER " .. bufferid .. "]: COPYING SUCCESS! PLAYER IS DONE UNTIL NEXT CYCLE") end
										--remove network flag
										battleflags[1] = battleflags[1] & ~PLAYERS2[bufferid]
										playerBattle.Send_ID = playerBattle.Send_ID & ~PLAYERS[bufferid]
									end
								else
									p = p | FLAGS.FINISHED
									if DebugMessages.Battle then console:log("[PLAYER " .. bufferid .. "]: NO COPYING! PLAYER IS DONE UNTIL NEXT CYCLE") end
									--remove network flag
									battleflags[1] = battleflags[1] & ~PLAYERS2[bufferid]
									playerBattle.Send_ID = playerBattle.Send_ID & ~PLAYERS[bufferid]
								end
							else
								--console:log("[PLAYER " .. otherplayerBattle.Buffer_ID .. "]: INVALID! RECEIVED CONTENTS OF PLAYER THAT ISN't ACTIVE NETWORK.")
							end
						end
					end
				else
				--	console:log("ONE CYCLE IS DONE")
					--sleep
					--	for i=1, #Pause_Func do
					--		if (Pause_Func[i] == battlefunc[1]) or (Pause_Func[i] == battlefunc[2]) then
					--			if sleeper(60) then
					--				battleflags[3] = 0
					--			end
					--		end
					--	end
					--don't delay
					battleflags[3] = 0
				end
			--client
			else
				--if host is trying to send some pkmn
				if (e & FLAGS.UPDATE_PKMN) ~= 0 then
					p = p | FLAGS.UPDATE_PKMN
					SendSpecialData(battlesocket, "POK2", otherplayer:GetID()) --pok2 is direct read/write of your team to enemyteam
					turntaken = true
				end
					
				--if not updating pkmn
				if turntaken == false then
					--if not sending stuff already activated
					if (p & FLAGS.ACTIVATED) == 0 then
						--other player has new stuff
						if otherplayerBattle.Buffer_ID > 0 then
							--if not writing and contents is not already done and it is empty
							if (playerBattle.Send_ID & PLAYERS[otherplayerBattle.Buffer_ID]) == 0 and (p & FLAGS.WRITTEN) == 0 and (otherplayerBattle.Battleflags[4] & PLAYERS2[otherplayerBattle.Buffer_ID]) ~= 0 and (otherplayerBattle.Battleflags[1] & PLAYERS2[otherplayerBattle.Buffer_ID]) == 0 then
								if DebugMessages.Battle then console:log("[PLAYER " .. otherplayerBattle.Buffer_ID .. "]: NEW SENDING FROM HOST. COPYING...") end
								emu:write8(gAddress[GameID].gBattlerAttacker, otherplayerBattle.Attacker)
								emu:write8(gAddress[GameID].gBattlerTarget, otherplayerBattle.Target)
								emu:write8(gAddress[GameID].gAbsentBattlerFlags, otherplayerBattle.Absent_Battler)
								emu:write8(gAddress[GameID].gEffectBattler, otherplayerBattle.Effect_Battler)
								--write variables
								buffer_place = 0x200*(otherplayerBattle.Buffer_ID - 1)
								local buffer_a_string = ""
								local buffer_b_string = ""
								if #otherplayerBattle.Buffer_A > 169 and #otherplayerBattle.Buffer_B > 139 then
									for i=1, 170 do
										emu:write8(gAddress[GameID].gBattleBufferA+i-1+buffer_place, otherplayerBattle.Buffer_A[i])
										buffer_a_string = buffer_a_string .. otherplayerBattle.Buffer_A[i]
									end
									for i=1, 140 do
										emu:write8(gAddress[GameID].gBattleBufferB+i-1+buffer_place, otherplayerBattle.Buffer_B[i])
										buffer_b_string = buffer_b_string .. otherplayerBattle.Buffer_B[i]
									end
									playerBattle.Buffer_ID = otherplayerBattle.Buffer_ID
									p = p | FLAGS.WRITTEN
									playerBattle.Send_ID = playerBattle.Send_ID | PLAYERS[otherplayerBattle.Buffer_ID]
									if DebugMessages.Battle then console:log("[PLAYER " .. playerBattle.Buffer_ID .. "]: COPYING DONE. SENDING TO HOST A SUCCESS...") end
								else
									if DebugMessages.Battle then console:log("BUFFER A OR B IS TOO SMALL. A: " .. #otherplayerBattle.Buffer_A .. " B: " .. #otherplayerBattle.Buffer_B) end
								end
							end
						end
						if playerBattle.Buffer_ID > 0 then
							--host has activated their stuff
							if (p & FLAGS.WRITTEN) ~= 0 and (otherplayerBattle.Battleflags[4] & PLAYERS2[playerBattle.Buffer_ID]) == 0 then
								if DebugMessages.Battle then console:log("[PLAYER " .. playerBattle.Buffer_ID .. "]: HOST HAS SET FLAGS. PLAYER IS ACTIVATED") end
								p = p & ~FLAGS.WRITTEN
								battleflags[1] = battleflags[1] | PLAYERS[playerBattle.Buffer_ID]
								playerBattle.Buffer_ID = 0
							end
						end
						--client is done running something and wants to send back
						if (p & FLAGS.WRITTEN) == 0 then
							for i=1,4 do
								--if player in network active for host and running not active
								if playerBattle.Buffer_ID == 0 and (playerBattle.Send_ID & PLAYERS[i]) ~= 0 and (otherplayerBattle.Battleflags[1] & PLAYERS2[i]) ~= 0 and (battleflags[1] & PLAYERS[i]) == 0 and (p & FLAGS.ACTIVATED) == 0 then
									p = p | FLAGS.WRITTEN | FLAGS.ACTIVATED
									playerBattle.Buffer_ID = i
									if DebugMessages.Battle then console:log("[PLAYER " .. i .. "]: PLAYER IS SENDING FINISHED CONTENTS TO HOST...") end
									playerBattle.Send_ID = playerBattle.Send_ID & ~PLAYERS[i]
								end
							end
						end
					else
						--if you have contents to send
						if playerBattle.Buffer_ID > 0 then
							if DebugMessages.Battle then console:log("[PLAYER " .. playerBattle.Buffer_ID .. "]: TRYING TO RECEIVE BACK. FLAGS: " .. p) end
							if DebugMessages.Battle then console:log("[PLAYER " .. playerBattle.Buffer_ID .. "]: ENEMY FLAGS: " .. otherplayerBattle.Battleflags[1]) end
							--host has written contents and no longer has active network
							if (p & FLAGS.WRITTEN) ~= 0 and (otherplayerBattle.Battleflags[1] & PLAYERS2[playerBattle.Buffer_ID]) == 0 then
								if DebugMessages.Battle then console:log("[PLAYER " .. playerBattle.Buffer_ID .. "]: HOST HAS RECEIVED CONTENTS. PLAYER IS DONE UNTIL NEXT CYCLE") end
								p = p & ~FLAGS.WRITTEN
								p = p & ~FLAGS.ACTIVATED
								playerBattle.Buffer_ID = 0
							end
						end
					end
				end
			end
		end
		for i=1, 4 do
			emu:write8(gAddress[GameID].gBattleControllerExecFlags+i-1, battleflags[i])
		end
		playerBattle.Waiting_Status = p
		otherplayerBattle.Waiting_Status = e
		emu:write32(gAddress[GameID].gBattleTypeFlags, BattleTypeFlag)
		--if battle is finishing, advance
	--	console:log("LINKBATTLE CALLBACK: " .. Controller_1)
	--	console:log("MainBattleFunc: " .. emu:read32(gAddress[GameID].gBattleMainFunc) .. " CALLBACK2: " .. emu:read32(gAddress[GameID].gMainCallback))
	elseif (playerBattle.Waiting_Status & FLAGS.UPDATE_PKMN) ~= 0 then
		--host
		if playerBattleID == 0 then
			--if client is also waiting and you finished sending/receiving
			if DebugMessages.Battle then console:log("HOST WAITING. P1 STATUS: " .. playerBattle.Waiting_Status .. " P2 STATUS: " .. otherplayerBattle.Waiting_Status) end
			if (otherplayerBattle.Waiting_Status & FLAGS.UPDATE_PKMN) ~= 0 and (playerBattle.Waiting_Status & FLAGS.SENDING) ~= 0 and (otherplayerBattle.Waiting_Status & FLAGS.SENDING) ~= 0 then
				if DebugMessages.Battle then console:log("HOST HAS FINISHED RECEIVING CONTENT. FINISH UPDATE") end
				playerBattle.Waiting_Status = playerBattle.Waiting_Status & ~FLAGS.UPDATE_PKMN
				playerBattle.Waiting_Status = playerBattle.Waiting_Status & ~FLAGS.SENDING
			--	emu:write32(gAddress[GameID].gBattleMainFunc, MainBattleFunc_Saved)
			end
		--client
		else
			--if host is done and has confirmed the sending
			if (otherplayerBattle.Waiting_Status & FLAGS.UPDATE_PKMN) == 0 then
				if DebugMessages.Battle then console:log("CLIENT HAS FINISHED RECEIVING CONTENT. FINISH UPDATE") end
				playerBattle.Waiting_Status = playerBattle.Waiting_Status & ~FLAGS.UPDATE_PKMN
				playerBattle.Waiting_Status = playerBattle.Waiting_Status & ~FLAGS.SENDING
			--	emu:write32(gAddress[GameID].gBattleMainFunc, MainBattleFunc_Saved)
			end
		end
	
	elseif playerBattle.Text_Stage == 7 and Controller_1 == 0x37 and (otherplayerBattle.Text_Stage > 6 or otherplayerBattle.Text_Stage == 0) and (PlayerVersion ~= "E" or OtherPlayerVersion ~= "E") then
		--in case the game overwrites saved callback
		emu:write32(gAddress[GameID].gMainSavedCallback, gAddress[GameID].CB2_ReturnToField+1)
		if gAddress[GameID].sGameVersion == "FRLG" then
			if DebugMessages.Battle then console:log("FIRERED/LEAFGREEN END") end
			playerBattle.Text_Stage = 8
		elseif gAddress[GameID].sGameVersion == "E" then
			if DebugMessages.Battle then console:log("EMERALD END") end
			playerBattle.Text_Stage = 8
		else
			if DebugMessages.Battle then console:log("RUBY/SAPPHIRE END") end
			playerBattle.Text_Stage = 8
		end
		--in case player is stuck on getting away safely
		if (battleflags[1] & PLAYERS[1]) == 0 then
			battleflags[1] = battleflags[1] | PLAYERS[1]
			battleflags[1] = battleflags[1] & ~PLAYERS2[1]
			battleflags[1] = battleflags[1] & ~PLAYERS2[2]
		end
		for i=1, 4 do
			emu:write8(gAddress[GameID].gBattleControllerExecFlags+i-1, battleflags[i])
		end
	elseif playerBattle.Text_Stage == 7 and Controller_1 == 0x37 and (otherplayerBattle.Text_Stage > 6 or otherplayerBattle.Text_Stage == 0) and PlayerVersion == "E" and OtherPlayerVersion == "E" then
		if DebugMessages.Battle then console:log("EMERALD VS EMERALD END") end
		--in case the game overwrites saved callback
		emu:write32(gAddress[GameID].gMainSavedCallback, gAddress[GameID].CB2_ReturnToField+1)
		playerBattle.Text_Stage = 8
	elseif playerBattle.Text_Stage == 7 and (otherplayerBattle.Text_Stage > 7 or otherplayerBattle.Text_Stage == 0) then
		--in case player is stuck
		emu:write8(gAddress[GameID].gBattleBufferA, 0x37) --exit battle
		if (battleflags[1] & PLAYERS[1]) == 0 then --execute
			battleflags[1] = battleflags[1] | PLAYERS[1]
			battleflags[1] = battleflags[1] & ~PLAYERS2[1]
			battleflags[1] = battleflags[1] & ~PLAYERS2[2]
		end
		for i=1, 4 do
			emu:write8(gAddress[GameID].gBattleControllerExecFlags+i-1, battleflags[i])
		end
	elseif playerBattle.Text_Stage == 8 and (otherplayerBattle.Text_Stage > 7 or otherplayerBattle.Text_Stage == 0) then
		if DebugMessages.Battle then console:log("BATTLE IS OVER FOR BOTH! UNLOCKING END BATTLE") end
		emu:write8(gAddress[GameID].gReceivedRemoteLinkPlayers, 0)
		emu:write32(gAddress[GameID].gLinkCallback, 0)
		local flags = emu:read32(gAddress[GameID].gBattleTypeFlags)
		flags = flags & ~20
		emu:write32(gAddress[GameID].gBattleTypeFlags, flags)
		--if not heal and not overwrite, check if player is dead. if so, load the fleeing to pokecenter script
		if (BattleMain & BATTLE_FLAGS.OVERWRITE_POST_BATTLE) == 0 and (BattleMain & BATTLE_FLAGS.HEAL_POST_BATTLE) == 0 then
			--if all pokemon have 0 hp 
			local deadmon = 0
			for i=1, 6 do
				if CheckPokemonHealth(i,0) == 0 then deadmon = deadmon + 1 end
			end
			if deadmon == 6 then
			--	console:log("NEED POKECENTER!!! SCRIPT")
				emu:write32(gAddress[GameID].gMainSavedCallback, gAddress[GameID].CB2_WhiteOut+1)
			end
		end
		playerBattle.Text_Stage = 9
		
	elseif playerBattle.Text_Stage == 9 and MainFunc2 ~= gAddress[GameID].CB2_EndLinkBattle+1 and MainFunc2 ~= gAddress[GameID].CB2_InitEndLinkBattle+1 and MainFunc2 ~= gAddress[GameID].BattleMainCB2+1 then
		--clear script now
		ClearBattle()
		--if overwrite post battle, apply
		if (BattleMain & BATTLE_FLAGS.OVERWRITE_POST_BATTLE) ~= 0 then
			SetPokemonBattle(player, 0) --set player pokemon to pre-battle
		--if heal post battle, apply
		end
		if (BattleMain & BATTLE_FLAGS.HEAL_POST_BATTLE) ~= 0 then
			HealPokemon(0,0) --heal party
		end
		
		if gAddress[GameID].sGameVersion == "FRLG" then
			--if items allowed, revert. 
			if (BattleMain & BATTLE_FLAGS.ITEMS_ALLOWED) ~= 0 then
				if emu:read16(gAddress[GameID].HandleTurnActionSelectionState+0x3D4) == 0x900 then
					ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3D4, 0x902)
					if DebugMessages.Battle then console:log("UNWRITE ITEMS SUCCESS") end
				end
			end
			--if exp allowed, revert. 
			if (BattleMain & BATTLE_FLAGS.EXP_ALLOWED) ~= 0 then
				if emu:read32(gAddress[GameID].Cmd_getexp+0xD4) == 0x80980 then
					ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xD4, 0x80982)
					if DebugMessages.Battle then console:log("UNWRITE EXP SUCCESS") end
				end
			end
			--if disable vs screen
			--[[
			if (BattleMain & BATTLE_FLAGS.DISABLE_VS_SCREEN) ~= 0 then
				if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x30) == 0xE16C then
					ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x30, 0x2802)
					if DebugMessages.Battle then console:log("UNWRITE VS REMOVAL SUCCESS") end
				end
			end
			]]--
		elseif gAddress[GameID].sGameVersion == "RS" then
			--if items allowed, revert. 
			if (BattleMain & BATTLE_FLAGS.ITEMS_ALLOWED) ~= 0 then
				if emu:read16(gAddress[GameID].HandleTurnActionSelectionState+0x3B0) == 0x900 then
					ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3B0, 0x902)
					if DebugMessages.Battle then console:log("UNWRITE ITEMS SUCCESS") end
				end
			end
			--if exp allowed, revert. 
			if (BattleMain & BATTLE_FLAGS.EXP_ALLOWED) ~= 0 then
				if emu:read32(gAddress[GameID].Cmd_getexp+0xAC) == 0x980 then
					ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xAC, 0x982)
					if DebugMessages.Battle then console:log("UNWRITE EXP SUCCESS") end
				end
			end
			--if disable vs screen 
			--[[
			if (BattleMain & BATTLE_FLAGS.DISABLE_VS_SCREEN) ~= 0 then
				if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x38) == 0xE174 then
					ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x38, 0x2802)
					if DebugMessages.Battle then console:log("UNWRITE VS REMOVAL SUCCESS") end
				end
			end
			]]--
		elseif gAddress[GameID].sGameVersion == "E" then
			--if items allowed, revert. 
			if (BattleMain & BATTLE_FLAGS.ITEMS_ALLOWED) ~= 0 then
				if emu:read16(gAddress[GameID].HandleTurnActionSelectionState+0x3E4) == 0x21F0900 then
					ROMCARD:write16(gAddress[GameID].HandleTurnActionSelectionState+0x3E4, 0x21F0902)
					if DebugMessages.Battle then console:log("UNWRITE ITEMS SUCCESS") end
				end
			end
			--if exp allowed, revert. 
			if (BattleMain & BATTLE_FLAGS.EXP_ALLOWED) ~= 0 then
				if emu:read32(gAddress[GameID].Cmd_getexp+0xD4) == 0x63F0980 then
					ROMCARD:write32(gAddress[GameID].Cmd_getexp+0xD4, 0x63F0982)
					if DebugMessages.Battle then console:log("UNWRITE EXP SUCCESS") end
				end
			end
			--if disable vs screen
			--[[
			if (BattleMain & BATTLE_FLAGS.DISABLE_VS_SCREEN) ~= 0 then
				if emu:read16(gAddress[GameID].InitLinkBattleVsScreen+0x30) == 0xE16A then
					ROMCARD:write16(gAddress[GameID].InitLinkBattleVsScreen+0x30, 0x2802)
					if DebugMessages.Battle then console:log("UNWRITE VS REMOVAL SUCCESS") end
				end
			end
			]]--
		end
		
		if DebugMessages.Battle then console:log("SET LOCKFROMSCRIPT TO BE 0") end
		playerBattle.Text_Stage = 0
		LockFromScript = 0
		--ensure the other player gets that you are done with the battle
		SendSpecialData(battlesocket, "BATT", otherplayer:GetID())
		for i=1, 7 do --send bat2 4 times
			SendSpecialData(battlesocket, "BAT2", otherplayer:GetID())
		end
	elseif playerBattle.Text_Stage == 9 then
		--console:log("PLAYER STUCK ON END STUFF. MAINFUNC2: " .. MainFunc2)
		--in case player is stuck on getting away safely
		if (battleflags[1] & PLAYERS[1]) == 0 then
			battleflags[1] = battleflags[1] | PLAYERS[1]
			battleflags[1] = battleflags[1] & ~PLAYERS2[1]
			battleflags[1] = battleflags[1] & ~PLAYERS2[2]
		end
		for i=1, 4 do
			emu:write8(gAddress[GameID].gBattleControllerExecFlags+i-1, battleflags[i])
		end
	end
	player:SetBattleVar(playerBattle)
end

function Interaction()
	if EnableScript then
		local Keypress = emu:getKeys()
		local TalkingDirX = 0
		local TalkingDirY = 0
		local TooBusyByte = emu:read8(gAddress[GameID].gLockControls)
		local AddressGet = ""

		--Interaction Multi-choice
		if LockFromScript == 2 then
			--console:log("I VAR8000: " .. Var8000[1])
			--console:log("I VAR8014: " .. Var8000[14])
			if Var8000[1] ~= Var8000[14] then

				if Var8000[1] == 1 then
					if DebugMessages.Battle then console:log("Battle selected") end
					local player = FindPlayerByID(PlayerID)
					local Target = FindPlayerByID(player:GetTalking())
					OtherPlayerHasCancelled = 0
					local PartyCount = emu:read8(gAddress[GameID].gPartyCount)
					if PartyCount < 1 then
						LockFromScript = 0
						Loadscript(30)
						Keypressholding = 1
						Keypress = 1
					elseif Target then
						LockFromScript = 20
						Loadscript(4)
						Keypressholding = 1
						Keypress = 1
						if Hosting then
							SendData(Target:GetSocket(), "RBAT", Target:GetID())
						else
							SendData(SocketMain, "RBAT", Target:GetID())
						end
					else
						LockFromScript = 0
						Keypressholding = 1
						Keypress = 1
					end
					
					--Fix previous multi choice
					if PrevExtraAdr ~= 0 then
						ROMCARD:write32(gAddress[GameID].gMultiChoice, PrevExtraAdr)
						ROMCARD:write8(gAddress[GameID].gMultiChoiceAmount, PrevExtraAdrNum)
						PrevExtraAdr = 0
						PrevExtraAdrNum = 0
					end

				elseif Var8000[1] == 2 then
					if DebugMessages.Trade then console:log("Trade selected") end
					local player = FindPlayerByID(PlayerID)
					local Target = FindPlayerByID(player:GetTalking())
					OtherPlayerHasCancelled = 0
					local PartyCount = emu:read8(gAddress[GameID].gPartyCount)
					if PartyCount < 1 then
						LockFromScript = 0
						Loadscript(30)
						Keypressholding = 1
						Keypress = 1
					elseif Target then
						LockFromScript = 5
						Loadscript(4)
						Keypressholding = 1
						Keypress = 1
						if Hosting then
							SendData(Target:GetSocket(), "RTRA", Target:GetID())
						else
							SendData(SocketMain, "RTRA", Target:GetID())
						end
					else
						LockFromScript = 0
						Keypressholding = 1
						Keypress = 1
					end
					
					--Fix previous multi choice
					if PrevExtraAdr ~= 0 then
						ROMCARD:write32(gAddress[GameID].gMultiChoice, PrevExtraAdr)
						ROMCARD:write8(gAddress[GameID].gMultiChoiceAmount, PrevExtraAdrNum)
						PrevExtraAdr = 0
						PrevExtraAdrNum = 0
					end
						

				elseif Var8000[1] == 3 then
					if DebugMessages.Card then console:log("Card selected") end
					local player = FindPlayerByID(PlayerID)
					local Target = FindPlayerByID(player:GetTalking())
					Keypressholding = 1
					Keypress = 1
					Target:ClearCardData()
					LockFromScript = 10
					player:SetTask("CARD_SEND")
					Loadscript(4)
					--Fix previous multi choice
					if PrevExtraAdr ~= 0 then
						ROMCARD:write32(gAddress[GameID].gMultiChoice, PrevExtraAdr)
						ROMCARD:write8(gAddress[GameID].gMultiChoiceAmount, PrevExtraAdrNum)
						PrevExtraAdr = 0
						PrevExtraAdrNum = 0
					end

				elseif Var8000[1] ~= 0 then
					if DebugMessages.Battle or DebugMessages.Card or DebugMessages.Trade then console:log("Exit selected") end
					LockFromScript = 0
					Keypressholding = 1
					Keypress = 1
					--Fix previous multi choice
					if PrevExtraAdr ~= 0 then
						ROMCARD:write32(gAddress[GameID].gMultiChoice, PrevExtraAdr)
						ROMCARD:write8(gAddress[GameID].gMultiChoiceAmount, PrevExtraAdrNum)
						PrevExtraAdr = 0
						PrevExtraAdrNum = 0
					end
				end
			end
		end

		if Keypress == 1 or Keypress == 65 or Keypress == 129 or Keypress == 33 or Keypress == 17 then
				if LockFromScript == 0 and Keypressholding == 0 and TooBusyByte == 0 then
					--Interact with players
					local ActualPlayer = FindPlayerByID(PlayerID)
					if ActualPlayer then
						local PlayerX, PlayerY, PlayerDirection, PlayerMapID, PlayerVis, PlayerBanks = ActualPlayer:GetCoords()
						for i, player in ipairs(players) do
							if player:GetID() ~= PlayerID then
								local X, Y, Direction, MapID, Vis, MatchBanks = player:GetCoords()
								local TalkingDirX = PlayerX - X
								local TalkingDirY = PlayerY - Y
								if PlayerDirection == 1 and TalkingDirX == 1 and TalkingDirY == 0 then
								--	console:log("Player Left")
								elseif PlayerDirection == 2 and TalkingDirX == -1 and TalkingDirY == 0 then
								--	console:log("Player Right")
								elseif PlayerDirection == 3 and TalkingDirY == 1 and TalkingDirX == 0 then
								--	console:log("Player Up")
								elseif PlayerDirection == 4 and TalkingDirY == -1 and TalkingDirX == 0 then
								--	console:log("Player Down")
								end
								
								if (MapID == PlayerMapID or MatchBanks) and Vis == 1 and ((PlayerDirection == 1 and TalkingDirX == 1 and TalkingDirY == 0) or (PlayerDirection == 2 and TalkingDirX == -1 and TalkingDirY == 0) or (PlayerDirection == 3 and TalkingDirX == 0 and TalkingDirY == 1) or (PlayerDirection == 4 and TalkingDirX == 0 and TalkingDirY == -1)) then
								
							--		console:log("Player Any direction")
							--		PlayerTalkingID = i
							--		PlayerTalkingID2 = i + 1000
									LockFromScript = 2
									ActualPlayer:SetTalking(player:GetID())
									--since you are host, set battlemain to yours
									BattleMain = Battle
									BattleLevelCap = Level_Cap
									BattlePokemonCap = Pokemon_Cap
									Loadscript(2)
									Keypressholding = 1
									return
								end
							end
						end
						if Experimental_Features then
							local NPC_X, NPC_Y, NPC_Map, NPC_direction = 0, 0, 0, 0
							for _, npc in ipairs(NPCs) do
								if npc then
									NPC_X, NPC_Y, NPC_Map, NPC_direction = npc:GetInfo()
									local TalkingDirX = PlayerX - NPC_X
									local TalkingDirY = PlayerY - NPC_Y
									local direction_talk = 0
									if NPC_Map == PlayerMapID then
										if (PlayerDirection == 1 and TalkingDirX == 1 and TalkingDirY == 0) then --Right
											direction_talk = 2
										elseif (PlayerDirection == 2 and TalkingDirX == -1 and TalkingDirY == 0) then --Left
											direction_talk = 1
										elseif (PlayerDirection == 3 and TalkingDirX == 0 and TalkingDirY == 1) then --Down
											direction_talk = 4
										elseif (PlayerDirection == 4 and TalkingDirX == 0 and TalkingDirY == -1) then --Up
											direction_talk = 3
										end
									end
									if direction_talk > 0 then
										local nick = npc:GetName()
										ActualPlayer:SetTalking(9999, nick)
										BattleMain = Battle
										BattleLevelCap = Level_Cap
										BattlePokemonCap = Pokemon_Cap
										npc:Talking(direction_talk)
										Keypressholding = 1
										return
									end
								end
							end
						end
					end
				end
			Keypressholding = 1
		elseif Keypress == 2 then
				if LockFromScript == 4 and Keypressholding == 0 and Var8000[2] ~= 0 then
					--Cancel battle request
					local player = FindPlayerByID(PlayerID)
					local Target = FindPlayerByID(player:GetTalking())
					Loadscript(15)
					LockFromScript = 0
					if Hosting then
						SendData(Target:GetSocket(), "CBAT", Target:GetID())
					else
						SendData(SocketMain, "CBAT", Target:GetID())
					end
				elseif LockFromScript == 5 and Keypressholding == 0 and Var8000[2] ~= 0 then
					--Cancel trade request
					--console:log("NO TRADE")
					local player = FindPlayerByID(PlayerID)
					local Target = FindPlayerByID(player:GetTalking())
					Loadscript(16)
					LockFromScript = 0
					if Target then
						if Hosting then
							SendData(Target:GetSocket(), "CTRA", Target:GetID())
						else
							SendData(SocketMain, "CTRA", Target:GetID())
						end
					end
				elseif LockFromScript == 9 and Keypressholding == 0 and Var8000[2] ~= 0 then
					--Cancel trade request
					local player = FindPlayerByID(PlayerID)
					local Target = FindPlayerByID(player:GetTalking())
					local playerTrade = player:GetTradeVar()
					if playerTrade.Text_Stage ~= 0 and playerTrade.Text_Stage ~= 4 and playerTrade.Text_Stage ~= 7 and playerTrade.Text_Stage ~= 9 then
						Loadscript(16)
						LockFromScript = 0
					end
					if Hosting then
						SendData(Target:GetSocket(), "CTRA", Target:GetID())
					else
						SendData(SocketMain, "CTRA", Target:GetID())
					end
				elseif LockFromScript == 10 and Keypressholding == 0 and Var8000[2] ~= 0 then
					if DebugMessages.Card then console:log("Cancel Card") end
					Loadscript(26)
					LockFromScript = 0
					
				--elseif LockFromScript == 9 and (TradeVars[1] == 2 or TradeVars[1] == 4) and Keypressholding == 0 and Var8000[2] ~= 0 then
					--Cancel trade request
				--	player = FindPlayerByID(PlayerID)
				--	Target = FindPlayerByID(player:GetTalking())
				--	Loadscript(16)
				--	LockFromScript = 0
				--	TradeVars[1] = 0
				--	TradeVars[2] = 0
				--	TradeVars[3] = 0
				--	OtherPlayerHasCancelled = 0
				--	if Hosting then
				--		SendData(Target:GetSocket(), "CTRA", Target:GetID())
				--	else
				--		SendData(SocketMain, "CTRA", Target:GetID())
				--	end
				elseif LockFromScript == 20 and Keypressholding == 0 and Var8000[2] ~= 0 then
					--console:log("NO BATTLE")
					local player = FindPlayerByID(PlayerID)
					local Target = FindPlayerByID(player:GetTalking())
					Loadscript(15)
					LockFromScript = 0
					if Target then
						if Hosting then
							SendData(Target:GetSocket(), "CBAT", Target:GetID())
						else
							SendData(SocketMain, "CBAT", Target:GetID())
						end
					end
				end
			Keypressholding = 1
		
		elseif Keypress == 256 then -- Debug menus. R trigger to record the current menu.
			if DebugMessages.GetMenus then
				local Main = emu:read32(gAddress[GameID].gMainCallback)
				for i = 1, 5 do
					if i > 1 or not tableContains(DebugMenusPrev, Main) then
						if not DebugMenus[i] then
							if not tableContains(DebugMenus, Main) then
								DebugMenus[i] = Main
								if i == 1 then console:log("Now record the Pokemon menu.")
								elseif i == 2 then console:log("Now record the Pokemon summary.")
								elseif i == 3 then console:log("Now record the item bag.")
								elseif i == 4 then console:log("Now record the battle menu.")
								end
							end
						end
					else
						break
					end
				end
				
				if next(DebugMenus) ~= nil then
					if #DebugMenus > 4 then
						console:log("			Field = " .. DebugMenus[1] ..  ",")
						console:log("			Battle = " .. DebugMenus[5] ..  ",")
						console:log("			Pokemon = " .. DebugMenus[2] ..  ",")
						console:log("			Pokemon_Summary = " .. DebugMenus[3] ..  ",")
						console:log("			Item = " .. DebugMenus[4] ..  ",")
						console:log("RECORD RESET. Start with overworld.")
						DebugMenusPrev = DebugMenus
						DebugMenus = {}
						Keypressholding = 1
					end
				end
				
				Keypressholding = 1
			end
		else
			Keypressholding = 0
		end
	end
end

function GetNicknameBuffer(id, opt_nick)
	-- Convert 4-byte buffer to readable bytes
	local player
	if id ~= 9999 then player = FindPlayerByID(id) end
	local Buffer = {0, 0, 0, 0, 255}
	local LanguageTableTemp = 0
	local LanguageOffsets = {}
	local offset = 1
	local maxnickname = 10
	local Nickname
	if player then
		Nickname = player:GetNickname()
	else
		Nickname = opt_nick
	end
	
	if not Nickname then return Buffer end
	
	local i = 1
	for _, char in utf8.codes(Nickname) do
		table.insert(LanguageOffsets, i)
		i = i + 1
	end
	for i = 1, #LanguageOffsets do
		local NickNameNum = utf8sub(Nickname, LanguageOffsets[i], LanguageOffsets[i])
		if NickNameNum then
		--	console:log("NICK: " .. NickNameNum .. " TABLE: " .. LanguageTableType)
			if LanguageTableType == "Western" and is_japanese_char(NickNameNum) then
				LanguageTableTemp = LanguageTable["JapaneseWestern"][NickNameNum]
				if LanguageTableTemp then
					for j=1, string.len(LanguageTableTemp) do
						local LanguageTableTemp2 = LanguageTable["Western"][string.sub(LanguageTableTemp,j,j)]
						if not LanguageTableTemp2 then LanguageTableTemp2 = 0 end
						Buffer[offset] = LanguageTableTemp2
						offset = offset + 1
						if offset > maxnickname then Buffer[offset] = 255 return Buffer end
					end
				end
			else
				LanguageTableTemp = LanguageTable[LanguageTableType][NickNameNum]
				if not LanguageTableTemp then LanguageTableTemp = LanguageTable["Western"][NickNameNum] end
				if not LanguageTableTemp then LanguageTableTemp = 0 end
				Buffer[offset] = LanguageTableTemp
				offset = offset + 1
				if offset > maxnickname then Buffer[offset] = 255 return Buffer end
			end
		end
		Buffer[offset] = 255
	end
	return Buffer
end

function writeToMemory(addr, buffer)
	for i = 1, #buffer do
		emu:write8(addr, buffer[i])
		addr = addr + 1
	end
end

function WriteToRom(addr, data)
	for i = 1, #data do
		ROMCARD:write8(addr, data[i])
		addr = addr + 1
	end
end

--Escape sequence for string text
function EscapeSequences(str)
	str = str:gsub("\\l", "\a")
	str = str:gsub("\\p", "\b")
	str = str:gsub("\\c", "\f")
	str = str:gsub("\\v", "\r")
	str = str:gsub("\\n", "\n")
	str = str:gsub("\\h", "\t")
	return str
end

function Loadscript(ScriptNo)
	local MainScript = gAddress[GameID].gScriptData
	local ScriptAddress3 = gAddress[GameID].gTextData
	local ScriptASMAddress = gAddress[GameID].gNativeData
	local NickNameNum
	local Buffer = {0, 0, 0, 0, 255}
	local Buffer1 = gAddress[GameID].gBuffer1
	local Buffer2 = gAddress[GameID].gBuffer2
	local Buffer3 = gAddress[GameID].gBuffer3
	
	--Fill buffer var with nickname
	local player = FindPlayerByID(PlayerID)
	local playertargetid = player:GetTalking()
	if playertargetid == 9999 then
		Buffer = GetNicknameBuffer(playertargetid, player:GetTalkingNickname())
	else
		Buffer = GetNicknameBuffer(playertargetid)
	end
	local scripts = {
		[1] = {
			Name = "Host Script (Unused)",
			flags = {[2] = 0, [5] = 0},
			scriptData = {983146, 145227920, 220267785, 100663680, 2818579456, 2147554824, 40632322, 25166102, 4278348800},
			textData = {
				en = {
					[11010192] = "Would you like to enable\\nHide 'n Seek?",
				},
				jp = {
					[11010192] = "ウッド ユー ライク ター\\nエネーブル ハイド アンド シーク？"
				},
				fr = {
					[11010192] = "Souhaitez-vous activer\\nCache-cache?"
				},
				de = {
					[11010192] = "Möchtest du Hide 'n Seek\\naktivieren?"
				},
				es = {
					[11010192] = "¿Te gustaría habilitar\\nHide 'n Seek?"
				},
				it = {
					[11010192] = "Vuoi abilitare Nascondino?"
				},
			}
		},
		[2] = {
			Name = "Interaction Menu Script",
			flags = {[1] = 0, [2] = 0, [14] = 0},
			scriptData = {1728053353, 145227920, 68513638, 1638402, 394268032, 98304, 4294902379},
			buffer2Data = Buffer,
			textData = {
				en = {
					[11010192] = "What would you like to do\\nwith \\v\\h03?", --buffer2 = variable 03
				},
				jp = {
					[11010192] = "\\v\\h03 と なに を\\nしたい です か？",
				},
				fr = {
					[11010192] = "Que souhaitez-vous faire\\navec \\v\\h03?",
				},
				de = {
					[11010192] = "Was möchtest du mit \\v\\h03 machen?",
				},
				es = {
					[11010192] = "¿Qué te gustaría hacer con \\v\\h03?",
				},
				it = {
					[11010192] = "Cosa vorresti fare con \\v\\h03?",
				},
			},
			multichoiceData = {
				oldmultichoiceaddr = gAddress[GameID].gMultiChoice,
				newmultichoiceaddr = gAddress[GameID].gMultiChoiceData,
				multichoiceoptions = {gAddress[GameID].gTextData, 0, gAddress[GameID].gTextData + 15, 0, gAddress[GameID].gTextData + 30, 0, gAddress[GameID].gTextData + 45, 0},
				textData = {
					en = {
						[gAddress[GameID].gTextData] = "Battle",
						[gAddress[GameID].gTextData+15] = "Trade",
						[gAddress[GameID].gTextData+30] = "Card",
						[gAddress[GameID].gTextData+45] = "Exit",
					},
					jp = {
						[gAddress[GameID].gTextData] = "バトル",
						[gAddress[GameID].gTextData+15] = "トレード",
						[gAddress[GameID].gTextData+30] = "カード",
						[gAddress[GameID].gTextData+45] = "でぐち",
					},
					fr = {
						[gAddress[GameID].gTextData] = "Bataille",
						[gAddress[GameID].gTextData+15] = "Échange",
						[gAddress[GameID].gTextData+30] = "Carte",
						[gAddress[GameID].gTextData+45] = "Sortie",
					},
					de = {
						[gAddress[GameID].gTextData] = "Kampf",
						[gAddress[GameID].gTextData+15] = "Tauschen",
						[gAddress[GameID].gTextData+30] = "Karte",
						[gAddress[GameID].gTextData+45] = "Beenden",
					},
					es = {
						[gAddress[GameID].gTextData] = "Batalla",
						[gAddress[GameID].gTextData+15] = "Intercambio",
						[gAddress[GameID].gTextData+30] = "Tarjeta",
						[gAddress[GameID].gTextData+45] = "Salir",
					},
					it = {
						[gAddress[GameID].gTextData] = "Battaglia",
						[gAddress[GameID].gTextData+15] = "Scambiare",
						[gAddress[GameID].gTextData+30] = "Carta",
						[gAddress[GameID].gTextData+45] = "Uscita",
					},
				},
			},
		},
		[3] = {
			Name = "Placeholder",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "Nothing happened\\hB0",
				},
				jp = {
					[11010192] = "なにも おこらなかった\\hB0",
				},
				fr = {
					[11010192] = "Rien ne s'est passé\\hB0",
				},
				de = {
					[11010192] = "Es ist nichts passiert\\hB0",
				},
				es = {
					[11010192] = "No pasó nada\\hB0",
				},
				it = {
					[11010192] = "Non è successo niente\\hB0",
				},
			},
		},
		[4] = {
			Name = "Waiting Message",
			flags = {[2] = 0},
			scriptData = {1728053354, 145227920, 2147554918, 1814495311, 4294902274},
			textData = {
				en = {
					[11010192] = "Waiting for other player\\hB0",
				},
				jp = {
					[11010192] = "ほかの プレイヤー を\\nまって います\\hB0",
				},
				fr = {
					[11010192] = "En attente d'un autre joueur\\hB0",
				},
				de = {
					[11010192] = "Warte auf andere Spieler\\hB0",
				},
				es = {
					[11010192] = "Esperando al otro jugador\\hB0",
				},
				it = {
					[11010192] = "In attesa dell'altro\\ngiocatore\\hB0",
				},
			},
		},
		[5] = {
			Name = "The Other Player Canceled Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "The other player has canceled.",
				},
				jp = {
					[11010192] = "ほかの プレイヤー が キャンセル\\nしました。",
				},
				fr = {
					[11010192] = "L'autre joueur a annulé.",
				},
				de = {
					[11010192] = "Der andere Spieler hat abgesagt.",
				},
				es = {
					[11010192] = "El otro jugador ha cancelado.",
				},
				it = {
					[11010192] = "L'altro giocatore ha annullato.",
				},
			},
		},
		[6] = {
			Name = "Trade Request",
			flags = {[2] = 0},
			buffer2Data = Buffer,
			scriptData = {983146, 145227920, 220267785, 100663680, 2818579456, 2147554824, 40632322, 25166102, 4278348800},
			textData = {
				en = {
					[11010192] = "\\v\\h03 wishes to trade\\nwith you. Do you accept?",
				},
				jp = {
					[11010192] = "\\v\\h03 は あなた と\\nこうかん したい と いっています。\\pうけいれます か？"
				},
				fr = {
					[11010192] = "\\v\\h03 souhaite échanger\\navec vous. Acceptez-vous?",
				},
				de = {
					[11010192] = "\\v\\h03 möchte mit ihm\\nPokemon tauschen.\\pWillst du akzeptieren?",
				},
				es = {
					[11010192] = "\\v\\h03 desea intercambiar\\ncontigo ¿Aceptas?",
				},
				it = {
					[11010192] = "\\v\\h03 desidera fare\\naffari con te. Accetti?",
				},
			},
		},
		[7] = {
			Name = "Trade Request Denied",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "\\v\\h03 does not wish\\nto trade.",
				},
				jp = {
					[11010192] = "\\v\\h03 は こうかん\\nしたく ありません。",
				},
				fr = {
					[11010192] = "\\v\\h03 ne souhaite pas\\nfaire de échange.",
				},
				de = {
					[11010192] = "\\v\\h03 möchte nicht tauschen.",
				},
				es = {
					[11010192] = "\\v\\h03 no desea intercambiar.",
				},
				it = {
					[11010192] = "\\v\\h03 non desidera\\neffettuare lo scambio.",
				},
			},
		},
		[8] = {
			Name = "Trade Offer",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 220267785, 100663680, 2818579456, 2147554824, 40632322, 25166102, 4278348800},
			textData = {
				en = {
					[11010192] = "You have offered \\v\\h03.\\nThey have offered \\v\\h02.\\pWill you accept?",
				},
				jp = {
					[11010192] = "あなた は \\v\\h03 を\\nていじ しました。\\pかれら は \\v\\h02 を\\nていじ しました。\\pうけいれます か？",
				},
				fr = {
					[11010192] = "Vous avez proposé \\v\\h03.\\nIls ont proposé \\v\\h02.\\pAccepterez-vous?",
				},
				de = {
					[11010192] = "Du hast \\v\\h03 angeboten.\\pDer andere Spieler hat\\n\\v\\h02 angeboten.\\pWillst du annehmen?",
				},
				es = {
					[11010192] = "Has ofrecido \\v\\h03.\\nEllos han ofrecido \\v\\h02.\\p¿Aceptarás?",
				},
				it = {
					[11010192] = "Hai offerto \\v\\h03.\\nLoro hanno offerto \\v\\h02.\\pAccetterai?",
				},
			},
		},
		[9] = {
			Name = "Trade Offer Denied",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "The trade has been declined.",
				},
				jp = {
					[11010192] = "こうかん は きょひされました。"
				},
				fr = {
					[11010192] = "L'échange a été refusé.",
				},
				de = {
					[11010192] = "Tauschen wurde abgelehnt."
				},
				es = {
					[11010192] = "El intercambiar ha sido rechazado.",
				},
				it = {
					[11010192] = "Lo scambio è stato rifiutato.",
				},
			},
		},
		[10] = {
			Name = "Battle Request",
			flags = {[2] = 0},
			buffer2Data = Buffer,
			scriptData = {983146, 145227920, 220267785, 100663680, 2818579456, 2147554824, 40632322, 25166102, 4278348800},
			textData = {
				en = {
					[11010192] = "\\v\\h03 wishes to\\nbattle you. Do you accept?",
				},
				jp = {
					[11010192] = "\\v\\h03 は あなた と\\nたたかいたい と いっています。\\pうけいれます か？"
				},
				fr = {
					[11010192] = "\\v\\h03 souhaite vous\\ncombattre. Acceptez-vous?",
				},
				de = {
					[11010192] = "\\v\\h03 möchte gegen dich\\nkämpfen. Willst du annehmen?"
				},
				es = {
					[11010192] = "\\v\\h03 quiere pelear\\ncontigo. ¿Aceptas?",
				},
				it = {
					[11010192] = "\\v\\h03 desidera combattere\\ncon te. Accetti?",
				},
			},
		},
		[11] = {
			Name = "Battle Request Denied",
			flags = {[2] = 0},
			buffer2Data = Buffer,
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "\\v\\h03 does not wish\\nto battle.",
				},
				jp = {
					[11010192] = "\\v\\h03 は たたかいたく ありません。",
				},
				fr = {
					[11010192] = "\\v\\h03 ne souhaite pas\\nse battre.",
				},
				de = {
					[11010192] = "\\v\\h03 möchte nicht kämpfen."
				},
				es = {
					[11010192] = "\\v\\h03 no desea pelear.",
				},
				it = {
					[11010192] = "\\v\\h03 non desidera\\ncombattere.",
				},
			},
		},
		[12] = {
			Name = "Select Pokemon For Trade",
			flags = {[1] = 0, [2] = 0, [4] = 0, [5] = 0, [14] = 0},
			scriptData = {10429802, 2147754279, 67502086, 145227809, 1199571750, 50429185, 2147554944, 40632322, 2147555071, 40632321, 4294967295},
		},
		[13] = {
			Name = "Battle Will Start Message",
			flags = {[2] = 0},
			scriptData = {2600468586, 145227920, 9315686, 369114152, 163841, 4294967148},
			textData = {
				en = {
					[11010192] = "The battle will now begin.",
				},
				jp = {
					[11010192] = "たたかい は いま はじまります。",
				},
				fr = {
					[11010192] = "La bataille va commencer.",
				},
				de = {
					[11010192] = "Der Kampf wird jetzt beginnen."
				},
				es = {
					[11010192] = "La batalla comenzará ahora.",
				},
				it = {
					[11010192] = "Ora la battaglia avrà inizio.",
				},
			},
		},
		[14] = {
			Name = "Trade Will Start Message",
			flags = {[2] = 0},
			scriptData = {2600468586, 145227920, 9315686, 369114152, 163841, 4294967148},
			textData = {
				en = {
					[11010192] = "The trade will now begin.",
				},
				jp = {
					[11010192] = "こうかん は いま はじまります。",
				},
				fr = {
					[11010192] = "La échange va commencer.",
				},
				de = {
					[11010192] = "Das Tauschen wird jetzt beginnen."
				},
				es = {
					[11010192] = "El intercambiar ahora comenzará.",
				},
				it = {
					[11010192] = "Ora inizierà lo scambio.",
				},
			},
		},
		[15] = {
			Name = "You Canceled Battle Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "You have canceled the battle.",
				},
				jp = {
					[11010192] = "あなた は たたかい を\\nキャンセルしました。",
				},
				fr = {
					[11010192] = "Vous avez annulé la bataille.",
				},
				de = {
					[11010192] = "Du hast den Kampf abgebrochen."
				},
				es = {
					[11010192] = "Has cancelado la batalla.",
				},
				it = {
					[11010192] = "Hai annullato la battaglia.",
				},
			},
		},
		[16] = {
			Name = "You Canceled Trade Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "You have canceled the trade.",
				},
				jp = {
					[11010192] = "あなた は こうかん を\\nキャンセルしました。",
				},
				fr = {
					[11010192] = "Vous avez annulé l'échange.",
				},
				de = {
					[11010192] = "Du hast das Tauschen abgebrochen."
				},
				es = {
					[11010192] = "Has cancelado el intercambio.",
				},
				it = {
					[11010192] = "Hai annullato lo scambio.",
				},
			},
		},
		[17] = {--6 is the address, 8005 is 8000[5] which is 8004 and is the variable to copy, representing selected pokemon.
			Name = "Trade Start Firered/Leafgreen",
			flags = {[2] = 0, [6] = 8005, [5] = 1},
			scriptData = {16655722, 2147554855, 40632321, 4294967295},
		},
		[18] = {
			Name = "Battle Is Canceled Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "The other player has canceled\\nthe battle.",
				},
				jp = {
					[11010192] = "ほかの プレイヤー が たたかい を\\nキャンセルしました。",
				},
				fr = {
					[11010192] = "L'autre joueur a annulé la bataille.",
				},
				de = {
					[11010192] = "Du hast das Tauschen abgebrochen."
				},
				es = {
					[11010192] = "El otro jugador ha cancelado\\nla batalla.",
				},
				it = {
					[11010192] = "L'altro giocatore ha annullato\\nla battaglia.",
				},
			},
		},
		[19] = {
			Name = "Trade Is Canceled Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "The other player has canceled\\nthe trade.",
				},
				jp = {
					[11010192] = "ほかの プレイヤー が こうかん を\\nキャンセルしました。",
				},
				fr = {
					[11010192] = "L'autre joueur a annulé la échange.",
				},
				de = {
					[11010192] = "Du hast das Tauschen abgebrochen."
				},
				es = {
					[11010192] = "El otro jugador ha cancelado el\\nintercambio.",
				},
				it = {
					[11010192] = "L'altro giocatore ha annullato\\nlo scambio.",
				},
			},
		},
		[20] = {
			Name = "Other Player Too Busy To Battle Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "The other player is too busy\\nto battle\\hB0",
				},
				jp = {
					[11010192] = "ほかの プレイヤー は たたかう\\nひま が ありません\\hB0",
				},
				fr = {
					[11010192] = "L'autre joueur est trop\\noccupé pour se battre\\hB0",
				},
				de = {
					[11010192] = "Der andere Spieler ist zu\\nbeschäftigt, um zu kämpfen."
				},
				es = {
					[11010192] = "El otro jugador está demasiado\\nocupado para luchar.",
				},
				it = {
					[11010192] = "L'altro giocatore è troppo\\nimpegnato per combattere.",
				},
			},
		},
		[21] = {
			Name = "Other Player Too Busy To Trade Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "The other player is too busy\\nto trade\\hB0",
				},
				jp = {
					[11010192] = "ほかの プレイヤー は こうかん\\nする ひま が ありません\\hB0",
				},
				fr = {
					[11010192] = "L'autre joueur est trop\\noccupé pour se échanger\\hB0",
				},
				de = {
					[11010192] = "Der andere Spieler ist zu\\nbeschäftigt, um zu tauschen."
				},
				es = {
					[11010192] = "El otro jugador está demasiad\\nocupado para intercambiar.",
				},
				it = {
					[11010192] = "L'altro giocatore è troppo\\nimpegnato per effettuare lo scambio.",
				},
			},
		},
		[22] = {
			Name = "Battle Script (Unused)",
			flags = {[2] = 0},
			scriptData = {40656234},
		},
		[23] = {
			Name = "Trade Other Player Buffer (Unused)",
			flags = {},
			buffer1Data = Buffer,
		},
		[24] = {--load trainer card into 0x02022618 = gSendBuffer (usually reserved for native multiplayer send and receive)
			Name = "Generate Trainer Card to gSendBuffer",
			flags = {},
			scriptData = {2835349795, 4294902280},
			scriptASM = {
				ALL = {1208136976, 4026551042, 3172005893, gAddress[GameID].gSendBuffer, gAddress[GameID].GenerateTrainerCard, 1187006232, 1187006320, 4294967295},
			},
		},
		[25] = {
			Name = "Display Card",
			flags = {[7] = 0, [6] = 0, [2] = 0},
			buffer1Data = Buffer,
			scriptData = {2147554922, 251658241, 2818609152, 1711540488, 2762088, 2147554855, 40632324, 4294967295},
			textData = {
				en = {
					[11010192] = "Score! A look at \\n\\v\\h02's card!",
				},
				jp = {
					[11010192] = "スコア！ \\v\\h02\\nの カード を みて みよう！",
				},
				fr = {
					[11010192] = "Score! Un coup d'oeil à la\\ncarte de \\v\\h02!",
				},
				de = {
					[11010192] = "Jawohl! Ein Blick auf die Karte\\nvon \\v\\h02!"
				},
				es = {
					[11010192] = "¡Puntuación! ¡Un vistazo a la\\ntarjeta de \\v\\h02!",
				},
				it = {
					[11010192] = "Punto! Uno sguardo alla carta\\ndi \\v\\h02!",
				},
			},
		},
		[26] = {
			Name = "Cancel Seeing Card",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "You no longer wish to see\\nthe card.",
				},
				jp = {
					[11010192] = "カード を みたく なく なりました。",
				},
				fr = {
					[11010192] = "Vous ne souhaitez plus voir\\nla carte.",
				},
				de = {
					[11010192] = "Du möchtest die Karte nicht\\nmehr sehen."
				},
				es = {
					[11010192] = "Ya no deseas ver la tarjeta.",
				},
				it = {
					[11010192] = "Non vuoi più vedere la carta.",
				},
			},
		},
		[27] = {
			Name = "Select Pokemon For Trade Emerald",
			flags = {[1] = 0, [2] = 0, [4] = 0, [5] = 0, [14] = 0},
			scriptData = {10626410, 2147754279, 67502086, 145227809, 1233126182, 50429185, 2147554944, 40632322, 2147555071, 40632321, 4294967295},
		},
		[28] = {
			Name = "Trade Start Emerald",
			flags = {[2] = 0, [6] = 8005, [5] = 1},
			scriptData = {16852330, 2147554855, 40632321, 4294967295},
		},
		[29] = {
			Name = "Display Card Emerald",
			flags = {[7] = 0, [6] = 0, [2] = 0},
			buffer1Data = Buffer,
			scriptData = {2147554922, 983041, 145227920, 1751516169, 654322469, 75497750, 4278348800, 4294967295},
			textData = {
				en = {
					[11010192] = "Score! A look at \\n\\v\\h02's card!",
				},
				jp = {
					[11010192] = "スコア！ \\v\\h02\\nの カード を みて みよう！",
				},
				fr = {
					[11010192] = "Score! Un coup d'oeil à la\\ncarte de \\v\\h02!",
				},
				de = {
					[11010192] = "Jawohl! Ein Blick auf die Karte\\nvon \\v\\h02!"
				},
				es = {
					[11010192] = "¡Puntuación! ¡Un vistazo a la\\ntarjeta de \\v\\h02!",
				},
				it = {
					[11010192] = "Punto! Uno sguardo alla carta\\ndi \\v\\h02!",
				},
			},
		},
		[30] = {
			Name = "You Have No Pokemon Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "You have no pokemon.",
				},
				jp = {
					[11010192] = "ポケモン が いません。",
				},
				fr = {
					[11010192] = "Tu n'as pas de pokémon.",
				},
				de = {
					[11010192] = "Du hast keine pokémon."
				},
				es = {
					[11010192] = "No tienes ningún pokemon.",
				},
				it = {
					[11010192] = "Non hai nessun pokémon.",
				},
			},
		},
		[31] = {
			Name = "They Have No Pokemon Message",
			flags = {[2] = 0},
			scriptData = {983146, 145227920, 18220553, 1811940736, 4294967042},
			textData = {
				en = {
					[11010192] = "They have no pokemon.",
				},
				jp = {
					[11010192] = "かれら は ポケモン が いません。",
				},
				fr = {
					[11010192] = "Ils n'ont pas de pokémon.",
				},
				de = {
					[11010192] = "Der andere Spieler hat keine\\npokémon."
				},
				es = {
					[11010192] = "Ellos no tienen pokemon.",
				},
				it = {
					[11010192] = "Non hanno nessun pokémon.",
				},
			},
		},
		[32] = {
			Name = "Select Pokemon For Trade Emerald Japan",
			flags = {[1] = 0, [2] = 0, [4] = 0, [5] = 0, [14] = 0},
			scriptData = {10429802, 2147754279, 67502086, 145227809, 1182794534, 50429185, 2147554944, 40632322, 2147555071, 40632321, 4294967295},
		},
		[33] = {
			Name = "Link Battle Player 1",
			flags = {[6] = 0},
			scriptData = {654319653, 4294967042},
		},
		[34] = {
			Name = "Link Battle Player 2",
			flags = {[6] = 1},
			scriptData = {654319653, 4294967042},
		},
		[35] = {
			Name = "Link Battle Player 3",
			flags = {[6] = 2},
			scriptData = {654319653, 4294967042},
		},
		[36] = {
			Name = "Link Battle Player 4",
			flags = {[6] = 3},
			scriptData = {654319653, 4294967042},
		},
		[37] = {
			Name = "Initiate Link Player",
			flags = {},
			scriptData = {0x23000000, gAddress[GameID].InitLocalLinkPlayer+1, 0x23000000, gAddress[GameID].gNativeData+1, 0xFFFFFF02},
			scriptASM = {
				ALL = {0x2101B500, 0x80014806, 0x80194B06, 0x21804A02, 0x47104802, 0x4600BD00, gAddress[GameID].CreateTask+1, gAddress[GameID].Task_StartWiredCableClubBattle+1, gAddress[GameID].gSpecialVar_8000+4*2, gAddress[GameID].gSpecialVar_8000+5*2},
			},
		},
	}
	
	local currentScript = scripts[ScriptNo]

	local function writeScript(addr, data)
		for i = 1, #data do
			ROMCARD:write32(addr, data[i])
			addr = addr + 4
		end
	end
	
	local function writeString(stringtable)
		local localisation = stringtable[Language]
		if not localisation then localisation = stringtable["en"] end
		for addr, data in pairs(localisation) do
			local data = EscapeSequences(data) --to account for any extra escape sequences
			local count = 0
			local hex = 0
			local lastaddr = addr
			local LanguageOffsets = {}
			local i = 1
			for _, char in utf8.codes(data) do
				table.insert(LanguageOffsets, i)
				i = i + 1
			end
			for i = 1, #LanguageOffsets do
				if hex == 0 then --for \h
					count = count + 1
					local letter = utf8sub(data, LanguageOffsets[i], LanguageOffsets[i])
				--	console:log(letter)
					if letter == "\a" then
						ROMCARD:write8(addr, 250)
						addr = addr + 1
					elseif letter == "\b" then
						ROMCARD:write8(addr, 251)
						addr = addr + 1
					elseif letter == "\f" then
						ROMCARD:write8(addr, 252)
						addr = addr + 1
					elseif letter == "\r" then
						ROMCARD:write8(addr, 253)
						addr = addr + 1
					elseif letter == "\n" then
						ROMCARD:write8(addr, 254)
						addr = addr + 1
					elseif letter == "\t" then
				--		console:log("raw: " .. letter)
						local rawhex = utf8sub(data, i + 1, i + 2)
				--		console:log("raw 2: " .. rawhex)
						ROMCARD:write8(addr, tonumber(rawhex, 16))
						addr = addr + 1
						hex = 2
					else
						local languagetemp = LanguageTable[LanguageTableType][letter]
						if not languagetemp then languagetemp = LanguageTable["Western"][letter] end
						if not languagetemp then languagetemp = 0 end
					--	console:log("string: " .. letter .. " pos: " .. i .. " addr: " .. addr)
						ROMCARD:write8(addr, languagetemp)
						addr = addr + 1
					end
				else
				--	console:log("test")
					hex = hex - 1
				end
			end
			lastaddr = lastaddr + count
		--	console:log("lastaddr: " .. lastaddr)
			ROMCARD:write8(lastaddr, 255)
		end
	end

	local function writeBuffer2(addr, buffer, lang)
		WriteBuffers(addr, buffer, lang)
	end

	local function clearFlags(flags)
		if flags == nil or next(flags) == nil then
			return
		end
		
		for address, value in pairs(flags) do
			if DebugMessages.Scripts then console:log("FLAG: " .. address .. " VALUE: " .. value) end
			if value == 0 then
				emu:write16(Var8000Adr[address], 0)
			elseif value > 8000 and value < 8020 then
				local valued = value - 8000
				emu:write16(Var8000Adr[address], Var8000[valued])
			else
				emu:write16(Var8000Adr[address], value)
			end
		end
	end
	if currentScript then
		if DebugMessages.Scripts then console:log("SCRIPT FOUND") end
		clearFlags(currentScript.flags)
		if currentScript.buffer1Data then
			writeToMemory(Buffer1, currentScript.buffer1Data)
		end
		if currentScript.buffer2Data then
			writeToMemory(Buffer2, currentScript.buffer2Data)
		end
		if currentScript.buffer3Data then
			writeToMemory(Buffer3, currentScript.buffer3Data)
		end
		if currentScript.buffer1Data2 then
			writeBuffer2(Buffer1, currentScript.buffer1Data2.bufferData, currentScript.buffer1Data2.length)
		end
		if currentScript.buffer2Data2 then
			writeBuffer2(Buffer2, currentScript.buffer2Data2.bufferData, currentScript.buffer2Data2.length)
		end
		if currentScript.buffer3Data2 then
			writeBuffer2(Buffer3, currentScript.buffer3Data2.bufferData, currentScript.buffer3Data2.length)
		end
		if currentScript.multichoiceData then
		if DebugMessages.Scripts then console:log("Writing to address:" .. currentScript.multichoiceData.oldmultichoiceaddr) end
		if DebugMessages.Scripts then console:log("Data to write:" .. currentScript.multichoiceData.newmultichoiceaddr) end
			PrevExtraAdr = ROMCARD:read32(currentScript.multichoiceData.oldmultichoiceaddr)
			PrevExtraAdrNum = ROMCARD:read8(currentScript.multichoiceData.oldmultichoiceaddr + 4)

			ROMCARD:write32(currentScript.multichoiceData.oldmultichoiceaddr, currentScript.multichoiceData.newmultichoiceaddr)
			ROMCARD:write8(currentScript.multichoiceData.oldmultichoiceaddr + 4, 4) --Options number
			writeScript(currentScript.multichoiceData.newmultichoiceaddr, currentScript.multichoiceData.multichoiceoptions)
			if currentScript.multichoiceData.multichoicetext then writeScript(ScriptAddress3, currentScript.multichoiceData.multichoicetext) end
			if currentScript.multichoiceData.textData then writeString(currentScript.multichoiceData.textData) end
		end
		if currentScript.scriptASM then
			if DebugMessages.Scripts then console:log("HAS GAME ID: " .. GameID) end
			local scriptASMData = currentScript.scriptASM["ALL"]
			if not scriptASMData then scriptASMData = currentScript.scriptASM[GameID] end
			writeScript(ScriptASMAddress, scriptASMData)
			writeScript(MainScript, currentScript.scriptData)
			if currentScript.textData then writeString(currentScript.textData) end
			LoadScriptIntoMemory("ASM")
		elseif currentScript.scriptData then
			writeScript(MainScript, currentScript.scriptData)
			if currentScript.textData then writeString(currentScript.textData) end
			LoadScriptIntoMemory("Data")
		end
	end
end

function LoadScriptIntoMemory(LoadType)
--This puts the script at LoadScript into the memory, forcing it to load

	local u32 LoadScript = gAddress[GameID].gScriptLoad
	local u32 MainScript = gAddress[GameID].gScriptData
	local ScriptData
	
	if LoadType == "Data" then
		if DebugMessages.Scripts then console:log("LOAD DATA TO MEMORY") end
		ScriptData = {
			0, 0, 513, 0, MainScript + 1, 0, 0, 0, 0, 0, 0, 0
		}
	elseif LoadType == "ASM" then
		if DebugMessages.Scripts then console:log("LOAD ASM TO MEMORY") end
		ScriptData = {
			0, 0, 256, 0, MainScript, 0, 0, 0, 0, 0, 0, 0
		}
	end

	for i = 1, #ScriptData do
		emu:write32(LoadScript, ScriptData[i])
		LoadScript = LoadScript + 4
	end
end

function RemoveScriptFromMemory()
--This puts the script at LoadScript into the memory, forcing it to load

	local u32 LoadScript = gAddress[GameID].gScriptLoad
	local ScriptData = {
		0, 0, 513, 0, 0, 0, 0, 0, 0, 0, 0, 0
	}

	for i = 1, #ScriptData do
		emu:write32(LoadScript, ScriptData[i])
		LoadScript = LoadScript + 4
	end
end

function MainLogic()
	if updateTimers("logic") and (Connected or Hosting) then
				--VARS--
		local Startvaraddress = gAddress[GameID].gSpecialVar_8000
		
		--Variables 8000 (8000[1]) to 800F (8000[16])
		if Startvaraddress > 0 then
			for i = 1, 14 do
				Var8000Adr[i] = Startvaraddress + (i - 1) * 2
				Var8000[i] = tonumber(emu:read16(Var8000Adr[i]))
			end
		end
		
					
						--SCRIPT LOGIC--
			--Load player
			local player = FindPlayerByID(PlayerID)
			
			--If you cancel/stop
			if LockFromScript == 0 then
				if player then player:SetTalking(0) end
				--clear battlemain
				BattleMain = 0
				BattleLevelCap = 0
				BattlePokemonCap = 0
			end
				
			--Load card
			if player then
				if player:IsLoadingCard() then
					if DebugMessages.Card then console:log("CAN LOAD CARD NOW") end
					local gSendBuffer = gAddress[GameID].gSendBuffer
					--Check byte at 33695340, which is the first pokemon in the trainer card. If under 62355 then it is loaded,
					local CheckLoaded = emu:read16(gSendBuffer + 84)
					if gAddress[GameID].sGameType == "RSE" then
						CheckLoaded = emu:read16(gSendBuffer)
					end
					if CheckLoaded < 62355 then
						local player = FindPlayerByID(PlayerID)
						local Target = FindPlayerByID(player:LoadingCardTalking())
						if DebugMessages.Card then console:log("LOADED CARD. SENDING NOW. TARGET ID: " .. player:LoadingCardTalking()) end
						if Target then
							if Hosting then
								SendSpecialData(Target:GetSocket(), "CARD", Target:GetID())
								if DebugMessages.Card then console:log("Current LockFromScript: " .. LockFromScript) end
								if LockFromScript == 10 then
									SendData(Target:GetSocket(), "DCD2", Target:GetID())
								elseif LockFromScript == 11 then
									SendData(Target:GetSocket(), "DCRD", Target:GetID())
									if DebugMessages.Card then console:log("SENT CARD DATA BACK. SHOWING CARD NOW") end
									LockFromScript = 13
								else
									SendData(Target:GetSocket(), "DCRD", Target:GetID())
								end
								player:SetLoadingCard(false, 0)
							else
								SendSpecialData(SocketMain, "CARD", Target:GetID())
								if DebugMessages.Card then console:log("Current LockFromScript: " .. LockFromScript) end
								if LockFromScript == 10 then
									SendData(SocketMain, "DCD2", Target:GetID())
								elseif LockFromScript == 11 then
									SendData(SocketMain, "DCRD", Target:GetID())
									if DebugMessages.Card then console:log("SENT CARD DATA BACK. SHOWING CARD NOW") end
									LockFromScript = 12
								else
									SendData(SocketMain, "DCRD", Target:GetID())
								end
								player:SetLoadingCard(false, 0)
							end
						end
					end
				end
			
			--Tasks
				--Card task
				if player:GetTask() == "CARD_SEND" and Var8000[2] ~= 0 then
					local Target = FindPlayerByID(player:GetTalking())
					if Hosting then
						SendData(Target:GetSocket(), "RCRD", Target:GetID())
					else
						SendData(SocketMain, "RCRD", Target:GetID())
					end
					player:ClearTask()
				end
			
			end
			--LockScripts
			
			if DebugMessages.Scripts and LockFromScript ~= 0 then console:log("LOCKFROMSCRIPT: " .. LockFromScript) end
			--Wait until other player accepts battle
			if LockFromScript == 4 then
				if Var8000[2] ~= 0 then
					if TextSpeedWait == 1 then
						TextSpeedWait = 0
						LockFromScript = 8
						Loadscript(13)
					elseif TextSpeedWait == 3 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(11)
					elseif TextSpeedWait == 5 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(20)
					end
				end
--				if SendTimer == 0 then SendData("RBAT") end
				
			--Wait until other player accepts trade
			elseif LockFromScript == 5 then
				if Var8000[2] ~= 0 then
					if TextSpeedWait == 2 then
						TextSpeedWait = 0
						ClearTrade()
						LockFromScript = 9
					elseif TextSpeedWait == 4 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(7)
					elseif TextSpeedWait == 5 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(31)
					elseif TextSpeedWait == 6 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(21)
					end
				end
				
			--Exit message
			elseif LockFromScript == 7 then
				if Var8000[2] ~= 0 then
					LockFromScript = 0
					Keypressholding = 1
				end
			
			--Trade script
			elseif LockFromScript == 9 then
				Tradescript()
			
			elseif LockFromScript == 12 and Var8000[2] ~= 0 then
				if DebugMessages.Card then console:log("WAITING MESSAGE OVER") end
				LockFromScript = 13
			
			elseif LockFromScript == 13 then
				if DebugMessages.Card then console:log("SHOW SCRIPT") end
				if gAddress[GameID].sGameVersion == "E" and GameID ~= "BPEJ" then
					Loadscript(29)
				else
					Loadscript(25)
				end
				LockFromScript = 0
				
			--Player 2 has requested to trade
			elseif LockFromScript == 14 then
		--	if Var8000[2] ~= 0 then ConsoleForText:print("Var8001: " .. Var8000[2]) end
				--If accept, then send that you accept
				if Var8000[2] == 2 then
					if OtherPlayerHasCancelled == 0 then
					--	console:log("You have selected yes to trade")
					--	LockFromScript = 0
						player = FindPlayerByID(PlayerID)
						Target = FindPlayerByID(player:GetTalking())
						if Target then
							if Hosting then
								if DebugMessages.Trade then console:log("SEND DATA FROM HOST") end
								SendData(Target:GetSocket(), "STRA", Target:GetID())
							else
								if DebugMessages.Trade then console:log("SEND DATA FROM CLIENT") end
								--Special Data is structured differently
								SendData(SocketMain, "STRA", Target:GetID())
								GetPokemonTeam(player, 0)
							end
							ClearTrade()
							LockFromScript = 9
						end
					else
						if DebugMessages.Trade then console:log("Other player cancelled") end
						LockFromScript = 0
						OtherPlayerHasCancelled = 0
						LockFromScript = 0
						Loadscript(19)
					end
					
				elseif Var8000[2] == 1 then
					player = FindPlayerByID(PlayerID)
					Target = FindPlayerByID(player:GetTalking())
					LockFromScript = 0
					Keypressholding = 1
					if Hosting then
						SendData(Target:GetSocket(), "DTRA", Target:GetID())
					else
						SendData(SocketMain, "DTRA", Target:GetID())
					end
				end
			
				
			--Wait until other player accepts battle
			elseif LockFromScript == 20 then
				if Var8000[2] ~= 0 then
					if TextSpeedWait == 2 then
						TextSpeedWait = 0
						ClearBattle()
						LockFromScript = 21
					elseif TextSpeedWait == 4 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(11)
					elseif TextSpeedWait == 5 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(31)
					elseif TextSpeedWait == 6 then
						TextSpeedWait = 0
						LockFromScript = 0
						Loadscript(20)
					end
				end
				
			--Battle script
			elseif LockFromScript == 21 then
				Battlescript()
			
			--Player 2 has requested to battle
			elseif LockFromScript == 22 then
		--	if Var8000[2] ~= 0 then ConsoleForText:print("Var8001: " .. Var8000[2]) end
				--If accept, then send that you accept
				if Var8000[2] == 2 then
					if OtherPlayerHasCancelled == 0 then
					--	console:log("You have selected yes to battle")
					--	LockFromScript = 0
						player = FindPlayerByID(PlayerID)
						Target = FindPlayerByID(player:GetTalking())
						if Target then
							Target:SetBattleID(0) --they are host
							player:SetBattleID(1) --you are client
							if Hosting then
								if DebugMessages.Battle then console:log("SEND DATA FROM HOST") end
								SendData(Target:GetSocket(), "SBAT", Target:GetID())
							else
								if DebugMessages.Battle then console:log("SEND DATA FROM CLIENT") end
								--Special Data is structured differently
								SendData(SocketMain, "SBAT", Target:GetID())
							end
							ClearBattle()
							LockFromScript = 21
						end
					else
						if DebugMessages.Battle then console:log("Other player cancelled") end
						LockFromScript = 0
						OtherPlayerHasCancelled = 0
						LockFromScript = 0
						Loadscript(18)
					end
					
				elseif Var8000[2] == 1 then
					player = FindPlayerByID(PlayerID)
					Target = FindPlayerByID(player:GetTalking())
					LockFromScript = 0
					Keypressholding = 1
					if Hosting then
						SendData(Target:GetSocket(), "DBAT", Target:GetID())
					else
						SendData(SocketMain, "DBAT", Target:GetID())
					end
				end
			end
				
	end
end

function Render()
	if updateTimers("draw") then
		if PlayerID > 0 then
			player = FindPlayerByID(PlayerID)
			if player then
				player:SetPosition(GetPosition())
				for i, player in ipairs(players) do
					--Update Player Position
					if player:GetID() ~= PlayerID then
						--console:log("DRAW PLAYER STUFF. PLAYER ID: " .. PlayerID .. " PLAYER TO RENDER: " .. player:GetID())
						player:DrawPlayer()
					end
				end
				IDsToDraw = 0
				--Draw Extra Objects (NPCs)
				if Experimental_Features and not ObjectLoaded then
					LoadObjects()
				end
				if PositionData.AnimationData == 0 then
					DynamicRender()
				end
			end
		end
	end
end

function GetCurrentFPS()
	CurrentFrame = CurrentFrame + 1
	TotalFrame = TotalFrame + 1
	CurrentTime = os.time()
	
	if CurrentTime > PreviousTime then
		PreviousFrame = CurrentFrame
		CurrentFrame = 0
		PreviousTime = CurrentTime
		--Timeout
		if #players > 1 then
			for i, player in ipairs(players) do
				if player:GetID() ~= PlayerID then
					player:ReduceTimeout(1000)
				end
			end
		end
		--Timeout temp players
		if #temp_players > 0 then
			for i, player in ipairs(temp_players) do
				player:ReduceTimeout(1000)
			end
		end
	elseif CurrentTime < PreviousTime then
		PreviousTime = CurrentTime
	end
	Frame, FPS = CurrentFrame, PreviousFrame
end

function updateTimers(TaskType)
	--ReduceTimeout
	if TaskType == "network_send" and (FPS > 0 or FPS_Network_Send == 0) then
		if FPS_Network_Send == 0 then return true end
		local Interval = math.floor((FPS / FPS_Network_Send) + 0.5)
		if Interval == 0 then Interval = 1 end
		if math.floor(CurrentFrame + 0.5) % Interval == 0 then
			return true
		else
			return false
		end
	elseif TaskType == "network_receive" and (FPS > 0 or FPS_Network_Receive == 0) then
		if FPS_Network_Receive == 0 then return true end
		local Interval = math.floor((FPS / FPS_Network_Receive) + 0.5)
		if Interval == 0 then Interval = 1 end
		if math.floor(CurrentFrame + 0.5) % Interval == 0 then
			return true
		else
			return false
		end
	elseif TaskType == "draw" and (FPS > 0 or FPS_Draw == 0) then
		if FPS_Draw == 0 then return true end
		local Interval = math.floor(FPS / FPS_Draw)
		if Interval == 0 then Interval = 1 end
		if math.floor(TotalFrame) % Interval == 0 then
			return true
		else
			return false
		end
	elseif TaskType == "logic" and (FPS > 0 or FPS_MainLogic == 0) then
		if FPS_MainLogic == 0 then return true end
		if Interval == 0 then Interval = 1 end
		local Interval = math.floor(FPS / FPS_MainLogic)
		if math.floor(TotalFrame) % Interval == 0 then
			return true
		else
			return false
		end
	end
	return false
end


--Commands


function interact(id)
	Interact(id)
end

function Interact(id)
	local player = FindPlayerByID(id)
	local ActualPlayer = FindPlayerByID(PlayerID)
	if ActualPlayer then
		if id == PlayerID then
			console:log("You cannot interact with yourself!")
		else
			if player then
				LockFromScript = 2
				ActualPlayer:SetTalking(id)
				--set battlemain to yourself
				BattleMain = Battle
				BattleLevelCap = Level_Cap
				BattlePokemonCap = Pokemon_Cap
				Loadscript(2)
				Keypressholding = 1
				Var8000[1] = 0
			else
				console:log("Player not found!")
			end
		end
	else
		console:log("You must have a PlayerID!")
	end
end

function heal(pos, slot)
	Heal(pos, slot)
end

function Heal(pos, slot)
	local pos = pos or 0
	local slot = slot or 0
	if pos > 6 or slot > 1 then
		console:log("Invalid heal command. *p is 0-6, and *s is 0-1.")
	else
		HealPokemon(pos, slot)
		if pos == 0 and slot == 0 then
			console:log("Healed all party pokemon.")
		elseif pos == 0 and slot == 1 then
			console:log("Healed all enemy pokemon.")
		elseif slot == 0 then
			console:log("Healed party pokemon " .. pos .. ".")
		else
			console:log("Healed enemy pokemon " .. pos .. ".")
		end
	end
end

function bf(num)
	BatFlags(num)
end

function batflags(num)
	BatFlags(num)
end

function batFlags(num)
	BatFlags(num)
end

function Batflags(num)
	BatFlags(num)
end

function BatFlags(num)
	local BATTLE_FLAGS_TEXT = {
		"HEAL_PRE_BATTLE(1)",
		"HEAL_POST_BATTLE(2)",
		"OVERWRITE_POST_BATTLE(3)",
		"ITEMS_ALLOWED(4)",
		"EXP_ALLOWED(5)",
		"FORCE_BATTLE(6)",
		"DISABLE_VS_SCREEN(7)",
		"DOUBLE_BATTLE(8)",
		"LEVEL_CAP(9)",
		"RAISE_TO_MAX(10)",
		"POKEMON_CAP(11)"
	}
	if num then
		local number = tonumber(num) & 0xFFFFFFFF --4 bytes long
		--clear battle flags
		if number < 1 then
			Battle = 0
			console:log("Removed all battle flags.")
		--remove
		elseif number <= #BATTLE_FLAGS_TEXT then
			local number2 = 2 ^ (number - 1)
			if (Battle & number2) ~= 0 then
				Battle = Battle & ~number2
				console:log("Removed flag " .. BATTLE_FLAGS_TEXT[number])
			--add
			else
				Battle = Battle | number2
				console:log("Added flag " .. BATTLE_FLAGS_TEXT[number])
			end
		else
			console:log("Number too high.")
		end
		--ensure battle stays 4 bytes
		Battle = Battle & 0xFFFFFFFF
	else
		console:log("ALL FLAGS:")
		for i=1, #BATTLE_FLAGS_TEXT do
			console:log(BATTLE_FLAGS_TEXT[i])
		end
		local batflagtext = ""
		for i=1, #BATTLE_FLAGS_TEXT do
			local number2 = 2 ^ (i - 1)
			if (Battle & number2) ~= 0 then
				if i == #BATTLE_FLAGS_TEXT then
					batflagtext = batflagtext .. BATTLE_FLAGS_TEXT[i]
				else
					batflagtext = batflagtext .. BATTLE_FLAGS_TEXT[i] .. ", "
				end
			end
		end
		console:log("")
		console:log("Battle flag(s): " .. batflagtext)
		console:log("")
		console:log("-> batflags(n) --*n is number. If set, removes, otherwise adds. 0 sets it to empty")
	end
end

function lc(num)
	LevelCap(num)
end

function levelcap(num)
	LevelCap(num)
end

function levelCap(num)
	LevelCap(num)
end

function Levelcap(num)
	LevelCap(num)
end

function LevelCap(num)
	if num then
		if num > 0 and num < 101 then
			Level_Cap = num
		elseif num < 1 then
			Level_Cap = 50
		else
			Level_Cap = 100
		end
		console:log("Level cap is now set to " .. Level_Cap)
	else
		console:log("Level cap is currently " .. Level_Cap)
		console:log("->levelcap(*x) --Set the level cap for flag LEVEL_CAP to *x level. if 0, default to 50")
	end
end

function pc(num)
	PokemonCap(num)
end

function pokemoncap(num)
	PokemonCap(num)
end

function pokemonCap(num)
	PokemonCap(num)
end

function Pokemoncap(num)
	PokemonCap(num)
end

function PokemonCap(num)
	if num then
		if num > 0 and num < 7 then
			Pokemon_Cap = num
		elseif num < 1 then
			Pokemon_Cap = 3
		else
			Pokemon_Cap = 6
		end
		console:log("Pokemon cap is now set to " .. Pokemon_Cap)
	else
		console:log("Pokemon cap is currently " .. Pokemon_Cap)
		console:log("->pokemoncap(*x) --Set the pokemon cap for flag POKEMON_CAP to *x amount. if 0, default to 3")
	end
end

function help(page)
	Help(page)
end

function Help(page)
	local page = page or 1
	page = string.byte(safeStringChar(page))
	if page == 1 or page == 0 or page > 1 then
		console:log("Page 1/1. Type help(x) where x is page number to get more commands")
		console:log("->batflags(n) --Sets flags for battle. *n is number. If set, removes, otherwise adds. 0 sets it to empty")
		console:log("->heal(p, s) --Heal pokemon in position *p. If 0, heal all. *s is which team, 0 is player and 1 is enemy")
		console:log("->help(x) --Print help commands, with each page being *x. Defaults to page 1")
		console:log("->interact(x) --Interact with player *x")
		console:log("->levelcap(*x) --Set the level cap for flag LEVEL_CAP to *x level. if 0, default to 50")
		console:log("->pokemoncap(*x) --Set the pokemon cap for flag POKEMON_CAP to *x amount. if 0, default to 3")
	end
end

function shutdown()
	StopScript()
end

--For running outside of MGBA
if arg then
	NativeLua = true
end

if NativeLua then
	for i, v in ipairs(arg) do
		if v == "server" or v == "Server" then
			local isRunning = true
			local socket = require("lua\\socket")
			SocketMain = SimuSocket:new(socket)
			local mState = 0
			local nState = 0
			local console = ConsoleTest:new()
			while(isRunning) do
				if mState == 0 then
				end
				if nState == 0 then
					if SocketMain then
						SocketMain:bind(Port)
						--listening for client
						SocketMain:listen()
						print("BEGAN HOSTING!!!")
						Hosting = true
						PlayerID = 1
						EnableScript = true
						Nickname = "Server"
						GameID = "BPR1"
						Language = "en"
						LanguageTableType = "Western"
						AddPlayer(PlayerID, SocketMain, "Server", GameID, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0)
						nState = 1
					else
						print("THERE WAS A BINDING ISSUE ON PORT " .. Port .. ". RESTART SCRIPT TO TRY AGAIN.")
						nState = -1
					end
				elseif nState == 1 then
					--such a pain in the neck to get native lua working, I mean luasocket just isn't easy to work with
					isRunning = false
					--GetCurrentFPS() --checks time and timeout progress for clients
					--Connection()
				end
			end
		else
			print("use server parameter to host the server")
		end
	end
else
	SocketMain = socket:tcp()

	if ServerType == "h" then
		console:log("Started GBA-PK_Server.lua")
	else
		console:log("Started GBA-PK_Client.lua")
	end
	if not (emu == nil) then
		StartScript()
	end

	callbacks:add("frame", GetCurrentFPS)
	callbacks:add("reset", StartScript)
	callbacks:add("shutdown", StopScript)
	callbacks:add("frame", MainLogic)
	callbacks:add("frame", Connection)
	callbacks:add("frame", Render)


	callbacks:add("keysRead", Interaction)
end