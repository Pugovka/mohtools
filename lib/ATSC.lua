script_name("ATSC")
script_description("Данный скрипт создан для упрощения игры в SAMP в независимости от того, в какой вы организации. Однако, приоритет стоит на AF структурах, где будут иметься дополнительные функции. ")
script_version("0.4.8")
script_author("Alzaga")
require("lib.moonloader")
require("lib.sampfuncs")

local var_0_0 = require("ffi")

var_0_0.cdef("  void ExitProcess(unsigned int uExitCode);\n  struct std_string { union { char buf[16]; char* ptr; }; unsigned size; unsigned capacity; };\n  struct stCommandInfo { struct std_string name; int type; void* owner; };\n  struct std_vector_stCommandInfo{ struct stCommandInfo* first; struct stCommandInfo* last; struct stCommandInfo* end; };\n")

local var_0_1 = var_0_0.cast("struct std_vector_stCommandInfo(__thiscall*)()", getModuleProcAddress("SAMPFUNCS.asi", "?getChatCommands@SAMPFUNCS@@QAE?AV?$vector@UstCommandInfo@@V?$allocator@UstCommandInfo@@@std@@@std@@XZ"))

function getChatCommands()
	local var_1_0 = {}
	local var_1_1 = var_0_1()
	local var_1_2 = var_1_1.first

	while var_1_2 ~= var_1_1.last do
		table.insert(var_1_0, "/" .. var_0_0.string(var_1_2[0].name.size <= 15 and var_1_2[0].name.buf or var_1_2[0].name.ptr))

		var_1_2 = var_1_2 + 1
	end

	return var_1_0
end

SelectedFriend = -1

local var_0_2 = require("sampfuncs")
local var_0_3 = require("encoding")
local var_0_4 = require("inicfg")
local var_0_5 = require("lib.samp.events")
local var_0_6 = require("game.weapons")
local var_0_7 = require("moonloader").download_status
local var_0_8 = require("lib.windows.message")
local var_0_9 = require("memory")
local var_0_10 = require("vkeys")
local var_0_11 = require("bitex")
local key = require("vkeys")
local var_0_13 = getWorkingDirectory() .. "\\config\\ATSC.bind"
local var_0_14 = getWorkingDirectory() .. "\\config\\dialogue.json"
local var_0_15 = {}
local var_0_16 = {}
local var_0_17 = {}
local var_0_18 = {}
local var_0_19 = require("rkeys")
local var_0_20 = require("game.keys")
local var_0_21 = require("imgui_addons")
local var_0_22 = require("rkeys")
local var_0_23 = require("requests")
local var_0_24 = "alz.ini"

changelog = false
cfg = var_0_4.load(var_0_4.load({
	main = {
		ref = ""
	},
	statTimers = {
		weekOnline = true,
		clock = true,
		state = true,
		dayAfk = true,
		weekAfk = true,
		dayOnlineWork = true,
		dayFull = true,
		sesOnline = true,
		sesFull = true,
		weekFull = true,
		dayOnline = true,
		sesAfk = true
	},
	onDay = {
		onlineWork = 0,
		online = 0,
		afk = 0,
		full = 0,
		today = os.date("%a")
	},
	onWeek = {
		online = 0,
		onlineWork = 0,
		week = 1,
		afk = 0,
		full = 0
	},
	myWeekOnline = {
		[0] = 0,
		0,
		0,
		0,
		0,
		0,
		0
	},
	pos = {
		x = 0,
		y = 0
	},
	style = {
		colorW = 4279834905,
		colorT = 4286677377,
		round = 10
	}
}, var_0_24))
rabden = false
timedep = -1
timeffix = -1
timemask = -1
frak = -1
rang = -1
Actual = -1
checkinfo = false
timeryes = 0
resT = 0
ffshp = 0
smsid = -1
smstoid = -1
Anim = 0.05
Anim1 = 0.1
Zname = -1
Zid = -1
Str = 1
AF = false
pgt = -1
vv = false
focusId = -1
mor = "Нет связи с мониторингом"
popa = false
idMegaf = -1
Megaf = false
Uron = false
bp = false
bp1 = false
pogonya = false
maskN = false
sovpd = false
clps = 0
yeskey = false
weaponnameROZ = -1
nicknameROZ = -1
LeadersTable = {}
tSupports = {}

if cfg.config == nil then
	cfg.config = {
		author = "Diego Alzaga"
	}
end

local var_0_25 = {
	"А",
	"Б",
	"В",
	"Г",
	"Д",
	"Ж",
	"З",
	"И",
	"К",
	"Л",
	"М",
	"Н",
	"О",
	"П",
	"Р",
	"С",
	"Т",
	"У",
	"Ф",
	"Х",
	"Ц",
	"Ч",
	"Ш",
	"Я"
}

function PlayerPosition()
	xCoord, yCoord, zCoord = getCharCoordinates(PLAYER_PED)

	if yCoord < 3000 and yCoord > -3000 and xCoord < 3000 and xCoord > -3000 then
		Square = var_0_25[math.ceil((yCoord * -1 + 3000) / 250)] .. "-" .. math.ceil((xCoord + 3000) / 250)
	end

	City = calculateCity(xCoord, yCoord, zCoord)
	Zone = calculateZone(xCoord, yCoord, zCoord)

	return City, Zone, Square
end

function getAmmoInClip()
	local var_3_0 = getCharPointer(playerPed)
	local var_3_1 = getCurrentCharWeapon(playerPed)
	local var_3_2 = getWeapontypeSlot(var_3_1)
	local var_3_3 = var_3_0 + 1440 + var_3_2 * 28

	return var_0_9.getuint32(var_3_3 + 8)
end

local function var_0_26()
	return effil.thread(function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = require("requests")
		local var_5_1 = require("dkjson")
		local var_5_2, var_5_3 = pcall(var_5_0.request, arg_5_0, arg_5_1, var_5_1.decode(arg_5_2))

		if var_5_2 then
			var_5_3.json, var_5_3.xml = nil

			return true, var_5_3
		else
			return false, var_5_3
		end
	end)
end

local function var_0_27(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0
	local var_6_1

	repeat
		var_6_0, var_6_1 = arg_6_0:status()

		wait(0)
	until var_6_0 ~= "running"

	if not var_6_1 then
		if var_6_0 == "completed" then
			local var_6_2, var_6_3 = arg_6_0:get()

			if var_6_2 then
				arg_6_1(var_6_3)
			else
				arg_6_2(var_6_3)
			end

			return
		elseif var_6_0 == "canceled" then
			return arg_6_2(var_6_0)
		end
	else
		return arg_6_2(var_6_1)
	end
end

local function var_0_28(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = var_0_26()(arg_7_0, arg_7_1, encodeJson(arg_7_2, true))

	arg_7_3 = arg_7_3 or function()
		return
	end
	arg_7_4 = arg_7_4 or function()
		return
	end

	return {
		effilRequestThread = var_7_0,
		luaHttpHandleThread = lua_thread.create(var_0_27, var_7_0, arg_7_3, arg_7_4)
	}
end

function position()
	lua_thread.create(function()
		changetextpos = not changetextpos

		while true do
			wait(0)

			if changetextpos then
				sampSetCursorMode(4)

				local var_11_0, var_11_1 = getCursorPos()

				cfg.config.posX, cfg.config.posY = var_11_0, var_11_1
			end
		end
	end)
end

function jsonSave(arg_12_0, arg_12_1)
	file = io.open(arg_12_0, "w")

	file:write(encodeJson(arg_12_1))
	file:flush()
	file:close()
end

function jsonRead(arg_13_0)
	local var_13_0 = io.open(arg_13_0, "r+")
	local var_13_1 = var_13_0:read("*a")

	var_13_0:close()

	return (decodeJson(var_13_1))
end

function number_week()
	local var_14_0 = os.date("*t")
	local var_14_1 = os.time({
		month = 1,
		day = 1,
		year = var_14_0.year
	})
	local var_14_2 = (os.date("%w", var_14_1) - 1) % 7

	return math.ceil((var_14_0.yday + var_14_2) / 7)
end

function calculateCity(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = {
		{
			"Las Venturas",
			685,
			476.093,
			-500,
			3000,
			3000,
			500
		},
		{
			"Las Venturas",
			869.461,
			596.349,
			-242.99,
			2997.06,
			2993.87,
			900
		},
		{
			"San Fierro",
			-3000,
			-742.306,
			-500,
			-1270.53,
			1530.24,
			500
		},
		{
			"San Fierro",
			-1270.53,
			-402.481,
			-500,
			-1038.45,
			832.495,
			500
		},
		{
			"San Fierro",
			-1038.45,
			-145.539,
			-500,
			-897.546,
			376.632,
			500
		},
		{
			"San Fierro",
			-2997.47,
			-1115.58,
			-242.99,
			-1213.91,
			1659.68,
			900
		},
		{
			"Los Santos",
			480,
			-3000,
			-500,
			3000,
			-850,
			500
		},
		{
			"Los Santos",
			80,
			-2101.61,
			-500,
			1075,
			-1239.61,
			500
		},
		{
			"Los Santos",
			44.615,
			-2892.97,
			-242.99,
			2997.06,
			-768.027,
			900
		},
		{
			"Tierra Robada",
			-1213.91,
			596.349,
			-242.99,
			-480.539,
			1659.68,
			900
		},
		{
			"Tierra Robada",
			-2997.47,
			1659.68,
			-242.99,
			-480.539,
			2993.87,
			900
		},
		{
			"Red County",
			-1213.91,
			-768.027,
			-242.99,
			2997.06,
			596.349,
			900
		},
		{
			"Flint County",
			-1213.91,
			-2892.97,
			-242.99,
			44.6147,
			-768.027,
			900
		},
		{
			"Whetstone",
			-2997.47,
			-2892.97,
			-242.99,
			-1213.91,
			-1115.58,
			900
		},
		{
			"Bone County",
			-480.539,
			596.349,
			-242.99,
			869.461,
			2993.87,
			900
		}
	}

	for iter_15_0, iter_15_1 in ipairs(var_15_0) do
		if arg_15_0 >= iter_15_1[2] and arg_15_1 >= iter_15_1[3] and arg_15_2 >= iter_15_1[4] and arg_15_0 <= iter_15_1[5] and arg_15_1 <= iter_15_1[6] and arg_15_2 <= iter_15_1[7] then
			return iter_15_1[1]
		end
	end

	return "Неизвестно"
end

local var_0_29 = {
	"Landstalker",
	"Bravura",
	"Buffalo",
	"Linerunner",
	"Perrenial",
	"Sentinel",
	"Dumper",
	"Firetruck",
	"Trashmaster",
	"Stretch",
	"Manana",
	"Infernus",
	"Voodoo",
	"Pony",
	"Mule",
	"Cheetah",
	"Ambulance",
	"Leviathan",
	"Moonbeam",
	"Esperanto",
	"Taxi",
	"Washington",
	"Bobcat",
	"Whoopee",
	"BFInjection",
	"Hunter",
	"Premier",
	"Enforcer",
	"Securicar",
	"Banshee",
	"Predator",
	"Bus",
	"Rhino",
	"Barracks",
	"Hotknife",
	"Trailer",
	"Previon",
	"Coach",
	"Cabbie",
	"Stallion",
	"Rumpo",
	"RCBandit",
	"Romero",
	"Packer",
	"Monster",
	"Admiral",
	"Squalo",
	"Seasparrow",
	"Pizzaboy",
	"Tram",
	"Trailer",
	"Turismo",
	"Speeder",
	"Reefer",
	"Tropic",
	"Flatbed",
	"Yankee",
	"Caddy",
	"Solair",
	"Berkley'sRCVan",
	"Skimmer",
	"PCJ-600",
	"Faggio",
	"Freeway",
	"RCBaron",
	"RCRaider",
	"Glendale",
	"Oceanic",
	"Sanchez",
	"Sparrow",
	"Patriot",
	"Quad",
	"Coastguard",
	"Dinghy",
	"Hermes",
	"Sabre",
	"Rustler",
	"ZR-350",
	"Walton",
	"Regina",
	"Comet",
	"BMX",
	"Burrito",
	"Camper",
	"Marquis",
	"Baggage",
	"Dozer",
	"Maverick",
	"NewsChopper",
	"Rancher",
	"FBIRancher",
	"Virgo",
	"Greenwood",
	"Jetmax",
	"Hotring",
	"Sandking",
	"BlistaCompact",
	"PoliceMaverick",
	"Boxvillde",
	"Benson",
	"Mesa",
	"RCGoblin",
	"HotringRacerA",
	"HotringRacerB",
	"BloodringBanger",
	"Rancher",
	"SuperGT",
	"Elegant",
	"Journey",
	"Bike",
	"MountainBike",
	"Beagle",
	"Cropduster",
	"Stunt",
	"Tanker",
	"Roadtrain",
	"Nebula",
	"Majestic",
	"Buccaneer",
	"Shamal",
	"hydra",
	"FCR-900",
	"NRG-500",
	"HPV1000",
	"CementTruck",
	"TowTruck",
	"Fortune",
	"Cadrona",
	"FBITruck",
	"Willard",
	"Forklift",
	"Tractor",
	"Combine",
	"Feltzer",
	"Remington",
	"Slamvan",
	"Blade",
	"Freight",
	"Streak",
	"Vortex",
	"Vincent",
	"Bullet",
	"Clover",
	"Sadler",
	"Firetruck",
	"Hustler",
	"Intruder",
	"Primo",
	"Cargobob",
	"Tampa",
	"Sunrise",
	"Merit",
	"Utility",
	"Nevada",
	"Yosemite",
	"Windsor",
	"Monster",
	"Monster",
	"Uranus",
	"Jester",
	"Sultan",
	"Stratum",
	"Elegy",
	"Raindance",
	"RCTiger",
	"Flash",
	"Tahoma",
	"Savanna",
	"Bandito",
	"FreightFlat",
	"StreakCarriage",
	"Kart",
	"Mower",
	"Dune",
	"Sweeper",
	"Broadway",
	"Tornado",
	"AT-400",
	"DFT-30",
	"Huntley",
	"Stafford",
	"BF-400",
	"NewsVan",
	"Tug",
	"Trailer",
	"Emperor",
	"Wayfarer",
	"Euros",
	"Hotdog",
	"Club",
	"FreightBox",
	"Trailer",
	"Andromada",
	"Dodo",
	"RCCam",
	"Launch",
	"PoliceCar",
	"PoliceCar",
	"PoliceCar",
	"PoliceRanger",
	"Picador",
	"S.W.A.T",
	"Alpha",
	"Phoenix",
	"GlendaleShit",
	"SadlerShit",
	"Luggage A",
	"Luggage B",
	"Stairs",
	"Boxville",
	"Tiller",
	"UtilityTrailer"
}

function calculateZone(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {
		{
			"Avispa Country Club",
			-2667.81,
			-302.135,
			-28.831,
			-2646.4,
			-262.32,
			71.169
		},
		{
			"Easter Bay Airport",
			-1315.42,
			-405.388,
			15.406,
			-1264.4,
			-209.543,
			25.406
		},
		{
			"Avispa Country Club",
			-2550.04,
			-355.493,
			0,
			-2470.04,
			-318.493,
			39.7
		},
		{
			"Easter Bay Airport",
			-1490.33,
			-209.543,
			15.406,
			-1264.4,
			-148.388,
			25.406
		},
		{
			"Garcia",
			-2395.14,
			-222.589,
			-5.3,
			-2354.09,
			-204.792,
			200
		},
		{
			"Shady Cabin",
			-1632.83,
			-2263.44,
			-3,
			-1601.33,
			-2231.79,
			200
		},
		{
			"East Los Santos",
			2381.68,
			-1494.03,
			-89.084,
			2421.03,
			-1454.35,
			110.916
		},
		{
			"LVA Freight Depot",
			1236.63,
			1163.41,
			-89.084,
			1277.05,
			1203.28,
			110.916
		},
		{
			"Blackfield Intersection",
			1277.05,
			1044.69,
			-89.084,
			1315.35,
			1087.63,
			110.916
		},
		{
			"Avispa Country Club",
			-2470.04,
			-355.493,
			0,
			-2270.04,
			-318.493,
			46.1
		},
		{
			"Temple",
			1252.33,
			-926.999,
			-89.084,
			1357,
			-910.17,
			110.916
		},
		{
			"Unity Station",
			1692.62,
			-1971.8,
			-20.492,
			1812.62,
			-1932.8,
			79.508
		},
		{
			"LVA Freight Depot",
			1315.35,
			1044.69,
			-89.084,
			1375.6,
			1087.63,
			110.916
		},
		{
			"Los Flores",
			2581.73,
			-1454.35,
			-89.084,
			2632.83,
			-1393.42,
			110.916
		},
		{
			"Starfish Casino",
			2437.39,
			1858.1,
			-39.084,
			2495.09,
			1970.85,
			60.916
		},
		{
			"Easter Bay Chemicals",
			-1132.82,
			-787.391,
			0,
			-956.476,
			-768.027,
			200
		},
		{
			"Downtown Los Santos",
			1370.85,
			-1170.87,
			-89.084,
			1463.9,
			-1130.85,
			110.916
		},
		{
			"Esplanade East",
			-1620.3,
			1176.52,
			-4.5,
			-1580.01,
			1274.26,
			200
		},
		{
			"Market Station",
			787.461,
			-1410.93,
			-34.126,
			866.009,
			-1310.21,
			65.874
		},
		{
			"Linden Station",
			2811.25,
			1229.59,
			-39.594,
			2861.25,
			1407.59,
			60.406
		},
		{
			"Montgomery Intersection",
			1582.44,
			347.457,
			0,
			1664.62,
			401.75,
			200
		},
		{
			"Frederick Bridge",
			2759.25,
			296.501,
			0,
			2774.25,
			594.757,
			200
		},
		{
			"Yellow Bell Station",
			1377.48,
			2600.43,
			-21.926,
			1492.45,
			2687.36,
			78.074
		},
		{
			"Downtown Los Santos",
			1507.51,
			-1385.21,
			110.916,
			1582.55,
			-1325.31,
			335.916
		},
		{
			"Jefferson",
			2185.33,
			-1210.74,
			-89.084,
			2281.45,
			-1154.59,
			110.916
		},
		{
			"Mulholland",
			1318.13,
			-910.17,
			-89.084,
			1357,
			-768.027,
			110.916
		},
		{
			"Avispa Country Club",
			-2361.51,
			-417.199,
			0,
			-2270.04,
			-355.493,
			200
		},
		{
			"Jefferson",
			1996.91,
			-1449.67,
			-89.084,
			2056.86,
			-1350.72,
			110.916
		},
		{
			"Julius Thruway West",
			1236.63,
			2142.86,
			-89.084,
			1297.47,
			2243.23,
			110.916
		},
		{
			"Jefferson",
			2124.66,
			-1494.03,
			-89.084,
			2266.21,
			-1449.67,
			110.916
		},
		{
			"Julius Thruway North",
			1848.4,
			2478.49,
			-89.084,
			1938.8,
			2553.49,
			110.916
		},
		{
			"Rodeo",
			422.68,
			-1570.2,
			-89.084,
			466.223,
			-1406.05,
			110.916
		},
		{
			"Cranberry Station",
			-2007.83,
			56.306,
			0,
			-1922,
			224.782,
			100
		},
		{
			"Downtown Los Santos",
			1391.05,
			-1026.33,
			-89.084,
			1463.9,
			-926.999,
			110.916
		},
		{
			"Redsands West",
			1704.59,
			2243.23,
			-89.084,
			1777.39,
			2342.83,
			110.916
		},
		{
			"Little Mexico",
			1758.9,
			-1722.26,
			-89.084,
			1812.62,
			-1577.59,
			110.916
		},
		{
			"Blackfield Intersection",
			1375.6,
			823.228,
			-89.084,
			1457.39,
			919.447,
			110.916
		},
		{
			"Los Santos International",
			1974.63,
			-2394.33,
			-39.084,
			2089,
			-2256.59,
			60.916
		},
		{
			"Beacon Hill",
			-399.633,
			-1075.52,
			-1.489,
			-319.033,
			-977.516,
			198.511
		},
		{
			"Rodeo",
			334.503,
			-1501.95,
			-89.084,
			422.68,
			-1406.05,
			110.916
		},
		{
			"Richman",
			225.165,
			-1369.62,
			-89.084,
			334.503,
			-1292.07,
			110.916
		},
		{
			"Downtown Los Santos",
			1724.76,
			-1250.9,
			-89.084,
			1812.62,
			-1150.87,
			110.916
		},
		{
			"The Strip",
			2027.4,
			1703.23,
			-89.084,
			2137.4,
			1783.23,
			110.916
		},
		{
			"Downtown Los Santos",
			1378.33,
			-1130.85,
			-89.084,
			1463.9,
			-1026.33,
			110.916
		},
		{
			"Blackfield Intersection",
			1197.39,
			1044.69,
			-89.084,
			1277.05,
			1163.39,
			110.916
		},
		{
			"Conference Center",
			1073.22,
			-1842.27,
			-89.084,
			1323.9,
			-1804.21,
			110.916
		},
		{
			"Montgomery",
			1451.4,
			347.457,
			-6.1,
			1582.44,
			420.802,
			200
		},
		{
			"Foster Valley",
			-2270.04,
			-430.276,
			-1.2,
			-2178.69,
			-324.114,
			200
		},
		{
			"Blackfield Chapel",
			1325.6,
			596.349,
			-89.084,
			1375.6,
			795.01,
			110.916
		},
		{
			"Los Santos International",
			2051.63,
			-2597.26,
			-39.084,
			2152.45,
			-2394.33,
			60.916
		},
		{
			"Mulholland",
			1096.47,
			-910.17,
			-89.084,
			1169.13,
			-768.027,
			110.916
		},
		{
			"Yellow Bell Gol Course",
			1457.46,
			2723.23,
			-89.084,
			1534.56,
			2863.23,
			110.916
		},
		{
			"The Strip",
			2027.4,
			1783.23,
			-89.084,
			2162.39,
			1863.23,
			110.916
		},
		{
			"Jefferson",
			2056.86,
			-1210.74,
			-89.084,
			2185.33,
			-1126.32,
			110.916
		},
		{
			"Mulholland",
			952.604,
			-937.184,
			-89.084,
			1096.47,
			-860.619,
			110.916
		},
		{
			"Aldea Malvada",
			-1372.14,
			2498.52,
			0,
			-1277.59,
			2615.35,
			200
		},
		{
			"Las Colinas",
			2126.86,
			-1126.32,
			-89.084,
			2185.33,
			-934.489,
			110.916
		},
		{
			"Las Colinas",
			1994.33,
			-1100.82,
			-89.084,
			2056.86,
			-920.815,
			110.916
		},
		{
			"Richman",
			647.557,
			-954.662,
			-89.084,
			768.694,
			-860.619,
			110.916
		},
		{
			"LVA Freight Depot",
			1277.05,
			1087.63,
			-89.084,
			1375.6,
			1203.28,
			110.916
		},
		{
			"Julius Thruway North",
			1377.39,
			2433.23,
			-89.084,
			1534.56,
			2507.23,
			110.916
		},
		{
			"Willowfield",
			2201.82,
			-2095,
			-89.084,
			2324,
			-1989.9,
			110.916
		},
		{
			"Julius Thruway North",
			1704.59,
			2342.83,
			-89.084,
			1848.4,
			2433.23,
			110.916
		},
		{
			"Temple",
			1252.33,
			-1130.85,
			-89.084,
			1378.33,
			-1026.33,
			110.916
		},
		{
			"Little Mexico",
			1701.9,
			-1842.27,
			-89.084,
			1812.62,
			-1722.26,
			110.916
		},
		{
			"Queens",
			-2411.22,
			373.539,
			0,
			-2253.54,
			458.411,
			200
		},
		{
			"Las Venturas Airport",
			1515.81,
			1586.4,
			-12.5,
			1729.95,
			1714.56,
			87.5
		},
		{
			"Richman",
			225.165,
			-1292.07,
			-89.084,
			466.223,
			-1235.07,
			110.916
		},
		{
			"Temple",
			1252.33,
			-1026.33,
			-89.084,
			1391.05,
			-926.999,
			110.916
		},
		{
			"East Los Santos",
			2266.26,
			-1494.03,
			-89.084,
			2381.68,
			-1372.04,
			110.916
		},
		{
			"Julius Thruway East",
			2623.18,
			943.235,
			-89.084,
			2749.9,
			1055.96,
			110.916
		},
		{
			"Willowfield",
			2541.7,
			-1941.4,
			-89.084,
			2703.58,
			-1852.87,
			110.916
		},
		{
			"Las Colinas",
			2056.86,
			-1126.32,
			-89.084,
			2126.86,
			-920.815,
			110.916
		},
		{
			"Julius Thruway East",
			2625.16,
			2202.76,
			-89.084,
			2685.16,
			2442.55,
			110.916
		},
		{
			"Rodeo",
			225.165,
			-1501.95,
			-89.084,
			334.503,
			-1369.62,
			110.916
		},
		{
			"Las Brujas",
			-365.167,
			2123.01,
			-3,
			-208.57,
			2217.68,
			200
		},
		{
			"Julius Thruway East",
			2536.43,
			2442.55,
			-89.084,
			2685.16,
			2542.55,
			110.916
		},
		{
			"Rodeo",
			334.503,
			-1406.05,
			-89.084,
			466.223,
			-1292.07,
			110.916
		},
		{
			"Vinewood",
			647.557,
			-1227.28,
			-89.084,
			787.461,
			-1118.28,
			110.916
		},
		{
			"Rodeo",
			422.68,
			-1684.65,
			-89.084,
			558.099,
			-1570.2,
			110.916
		},
		{
			"Julius Thruway North",
			2498.21,
			2542.55,
			-89.084,
			2685.16,
			2626.55,
			110.916
		},
		{
			"Downtown Los Santos",
			1724.76,
			-1430.87,
			-89.084,
			1812.62,
			-1250.9,
			110.916
		},
		{
			"Rodeo",
			225.165,
			-1684.65,
			-89.084,
			312.803,
			-1501.95,
			110.916
		},
		{
			"Jefferson",
			2056.86,
			-1449.67,
			-89.084,
			2266.21,
			-1372.04,
			110.916
		},
		{
			"Hampton Barns",
			603.035,
			264.312,
			0,
			761.994,
			366.572,
			200
		},
		{
			"Temple",
			1096.47,
			-1130.84,
			-89.084,
			1252.33,
			-1026.33,
			110.916
		},
		{
			"Kincaid Bridge",
			-1087.93,
			855.37,
			-89.084,
			-961.95,
			986.281,
			110.916
		},
		{
			"Verona Beach",
			1046.15,
			-1722.26,
			-89.084,
			1161.52,
			-1577.59,
			110.916
		},
		{
			"Commerce",
			1323.9,
			-1722.26,
			-89.084,
			1440.9,
			-1577.59,
			110.916
		},
		{
			"Mulholland",
			1357,
			-926.999,
			-89.084,
			1463.9,
			-768.027,
			110.916
		},
		{
			"Rodeo",
			466.223,
			-1570.2,
			-89.084,
			558.099,
			-1385.07,
			110.916
		},
		{
			"Mulholland",
			911.802,
			-860.619,
			-89.084,
			1096.47,
			-768.027,
			110.916
		},
		{
			"Mulholland",
			768.694,
			-954.662,
			-89.084,
			952.604,
			-860.619,
			110.916
		},
		{
			"Julius Thruway South",
			2377.39,
			788.894,
			-89.084,
			2537.39,
			897.901,
			110.916
		},
		{
			"Idlewood",
			1812.62,
			-1852.87,
			-89.084,
			1971.66,
			-1742.31,
			110.916
		},
		{
			"Ocean Docks",
			2089,
			-2394.33,
			-89.084,
			2201.82,
			-2235.84,
			110.916
		},
		{
			"Commerce",
			1370.85,
			-1577.59,
			-89.084,
			1463.9,
			-1384.95,
			110.916
		},
		{
			"Julius Thruway North",
			2121.4,
			2508.23,
			-89.084,
			2237.4,
			2663.17,
			110.916
		},
		{
			"Temple",
			1096.47,
			-1026.33,
			-89.084,
			1252.33,
			-910.17,
			110.916
		},
		{
			"Glen Park",
			1812.62,
			-1449.67,
			-89.084,
			1996.91,
			-1350.72,
			110.916
		},
		{
			"Easter Bay Airport",
			-1242.98,
			-50.096,
			0,
			-1213.91,
			578.396,
			200
		},
		{
			"Martin Bridge",
			-222.179,
			293.324,
			0,
			-122.126,
			476.465,
			200
		},
		{
			"The Strip",
			2106.7,
			1863.23,
			-89.084,
			2162.39,
			2202.76,
			110.916
		},
		{
			"Willowfield",
			2541.7,
			-2059.23,
			-89.084,
			2703.58,
			-1941.4,
			110.916
		},
		{
			"Marina",
			807.922,
			-1577.59,
			-89.084,
			926.922,
			-1416.25,
			110.916
		},
		{
			"Las Venturas Airport",
			1457.37,
			1143.21,
			-89.084,
			1777.4,
			1203.28,
			110.916
		},
		{
			"Idlewood",
			1812.62,
			-1742.31,
			-89.084,
			1951.66,
			-1602.31,
			110.916
		},
		{
			"Esplanade East",
			-1580.01,
			1025.98,
			-6.1,
			-1499.89,
			1274.26,
			200
		},
		{
			"Downtown Los Santos",
			1370.85,
			-1384.95,
			-89.084,
			1463.9,
			-1170.87,
			110.916
		},
		{
			"The Mako Span",
			1664.62,
			401.75,
			0,
			1785.14,
			567.203,
			200
		},
		{
			"Rodeo",
			312.803,
			-1684.65,
			-89.084,
			422.68,
			-1501.95,
			110.916
		},
		{
			"Pershing Square",
			1440.9,
			-1722.26,
			-89.084,
			1583.5,
			-1577.59,
			110.916
		},
		{
			"Mulholland",
			687.802,
			-860.619,
			-89.084,
			911.802,
			-768.027,
			110.916
		},
		{
			"Gant Bridge",
			-2741.07,
			1490.47,
			-6.1,
			-2616.4,
			1659.68,
			200
		},
		{
			"Las Colinas",
			2185.33,
			-1154.59,
			-89.084,
			2281.45,
			-934.489,
			110.916
		},
		{
			"Mulholland",
			1169.13,
			-910.17,
			-89.084,
			1318.13,
			-768.027,
			110.916
		},
		{
			"Julius Thruway North",
			1938.8,
			2508.23,
			-89.084,
			2121.4,
			2624.23,
			110.916
		},
		{
			"Commerce",
			1667.96,
			-1577.59,
			-89.084,
			1812.62,
			-1430.87,
			110.916
		},
		{
			"Rodeo",
			72.648,
			-1544.17,
			-89.084,
			225.165,
			-1404.97,
			110.916
		},
		{
			"Roca Escalante",
			2536.43,
			2202.76,
			-89.084,
			2625.16,
			2442.55,
			110.916
		},
		{
			"Rodeo",
			72.648,
			-1684.65,
			-89.084,
			225.165,
			-1544.17,
			110.916
		},
		{
			"Market",
			952.663,
			-1310.21,
			-89.084,
			1072.66,
			-1130.85,
			110.916
		},
		{
			"Las Colinas",
			2632.74,
			-1135.04,
			-89.084,
			2747.74,
			-945.035,
			110.916
		},
		{
			"Mulholland",
			861.085,
			-674.885,
			-89.084,
			1156.55,
			-600.896,
			110.916
		},
		{
			"King's",
			-2253.54,
			373.539,
			-9.1,
			-1993.28,
			458.411,
			200
		},
		{
			"Redsands East",
			1848.4,
			2342.83,
			-89.084,
			2011.94,
			2478.49,
			110.916
		},
		{
			"Downtown",
			-1580.01,
			744.267,
			-6.1,
			-1499.89,
			1025.98,
			200
		},
		{
			"Conference Center",
			1046.15,
			-1804.21,
			-89.084,
			1323.9,
			-1722.26,
			110.916
		},
		{
			"Richman",
			647.557,
			-1118.28,
			-89.084,
			787.461,
			-954.662,
			110.916
		},
		{
			"Ocean Flats",
			-2994.49,
			277.411,
			-9.1,
			-2867.85,
			458.411,
			200
		},
		{
			"Greenglass College",
			964.391,
			930.89,
			-89.084,
			1166.53,
			1044.69,
			110.916
		},
		{
			"Glen Park",
			1812.62,
			-1100.82,
			-89.084,
			1994.33,
			-973.38,
			110.916
		},
		{
			"LVA Freight Depot",
			1375.6,
			919.447,
			-89.084,
			1457.37,
			1203.28,
			110.916
		},
		{
			"Regular Tom",
			-405.77,
			1712.86,
			-3,
			-276.719,
			1892.75,
			200
		},
		{
			"Verona Beach",
			1161.52,
			-1722.26,
			-89.084,
			1323.9,
			-1577.59,
			110.916
		},
		{
			"East Los Santos",
			2281.45,
			-1372.04,
			-89.084,
			2381.68,
			-1135.04,
			110.916
		},
		{
			"Caligula's Palace",
			2137.4,
			1703.23,
			-89.084,
			2437.39,
			1783.23,
			110.916
		},
		{
			"Idlewood",
			1951.66,
			-1742.31,
			-89.084,
			2124.66,
			-1602.31,
			110.916
		},
		{
			"Pilgrim",
			2624.4,
			1383.23,
			-89.084,
			2685.16,
			1783.23,
			110.916
		},
		{
			"Idlewood",
			2124.66,
			-1742.31,
			-89.084,
			2222.56,
			-1494.03,
			110.916
		},
		{
			"Queens",
			-2533.04,
			458.411,
			0,
			-2329.31,
			578.396,
			200
		},
		{
			"Downtown",
			-1871.72,
			1176.42,
			-4.5,
			-1620.3,
			1274.26,
			200
		},
		{
			"Commerce",
			1583.5,
			-1722.26,
			-89.084,
			1758.9,
			-1577.59,
			110.916
		},
		{
			"East Los Santos",
			2381.68,
			-1454.35,
			-89.084,
			2462.13,
			-1135.04,
			110.916
		},
		{
			"Marina",
			647.712,
			-1577.59,
			-89.084,
			807.922,
			-1416.25,
			110.916
		},
		{
			"Richman",
			72.648,
			-1404.97,
			-89.084,
			225.165,
			-1235.07,
			110.916
		},
		{
			"Vinewood",
			647.712,
			-1416.25,
			-89.084,
			787.461,
			-1227.28,
			110.916
		},
		{
			"East Los Santos",
			2222.56,
			-1628.53,
			-89.084,
			2421.03,
			-1494.03,
			110.916
		},
		{
			"Rodeo",
			558.099,
			-1684.65,
			-89.084,
			647.522,
			-1384.93,
			110.916
		},
		{
			"Easter Tunnel",
			-1709.71,
			-833.034,
			-1.5,
			-1446.01,
			-730.118,
			200
		},
		{
			"Rodeo",
			466.223,
			-1385.07,
			-89.084,
			647.522,
			-1235.07,
			110.916
		},
		{
			"Redsands East",
			1817.39,
			2202.76,
			-89.084,
			2011.94,
			2342.83,
			110.916
		},
		{
			"The Clown's Pocket",
			2162.39,
			1783.23,
			-89.084,
			2437.39,
			1883.23,
			110.916
		},
		{
			"Idlewood",
			1971.66,
			-1852.87,
			-89.084,
			2222.56,
			-1742.31,
			110.916
		},
		{
			"Montgomery Intersection",
			1546.65,
			208.164,
			0,
			1745.83,
			347.457,
			200
		},
		{
			"Willowfield",
			2089,
			-2235.84,
			-89.084,
			2201.82,
			-1989.9,
			110.916
		},
		{
			"Temple",
			952.663,
			-1130.84,
			-89.084,
			1096.47,
			-937.184,
			110.916
		},
		{
			"Prickle Pine",
			1848.4,
			2553.49,
			-89.084,
			1938.8,
			2863.23,
			110.916
		},
		{
			"Los Santos International",
			1400.97,
			-2669.26,
			-39.084,
			2189.82,
			-2597.26,
			60.916
		},
		{
			"Garver Bridge",
			-1213.91,
			950.022,
			-89.084,
			-1087.93,
			1178.93,
			110.916
		},
		{
			"Garver Bridge",
			-1339.89,
			828.129,
			-89.084,
			-1213.91,
			1057.04,
			110.916
		},
		{
			"Kincaid Bridge",
			-1339.89,
			599.218,
			-89.084,
			-1213.91,
			828.129,
			110.916
		},
		{
			"Kincaid Bridge",
			-1213.91,
			721.111,
			-89.084,
			-1087.93,
			950.022,
			110.916
		},
		{
			"Verona Beach",
			930.221,
			-2006.78,
			-89.084,
			1073.22,
			-1804.21,
			110.916
		},
		{
			"Verdant Bluffs",
			1073.22,
			-2006.78,
			-89.084,
			1249.62,
			-1842.27,
			110.916
		},
		{
			"Vinewood",
			787.461,
			-1130.84,
			-89.084,
			952.604,
			-954.662,
			110.916
		},
		{
			"Vinewood",
			787.461,
			-1310.21,
			-89.084,
			952.663,
			-1130.84,
			110.916
		},
		{
			"Commerce",
			1463.9,
			-1577.59,
			-89.084,
			1667.96,
			-1430.87,
			110.916
		},
		{
			"Market",
			787.461,
			-1416.25,
			-89.084,
			1072.66,
			-1310.21,
			110.916
		},
		{
			"Rockshore West",
			2377.39,
			596.349,
			-89.084,
			2537.39,
			788.894,
			110.916
		},
		{
			"Julius Thruway North",
			2237.4,
			2542.55,
			-89.084,
			2498.21,
			2663.17,
			110.916
		},
		{
			"East Beach",
			2632.83,
			-1668.13,
			-89.084,
			2747.74,
			-1393.42,
			110.916
		},
		{
			"Fallow Bridge",
			434.341,
			366.572,
			0,
			603.035,
			555.68,
			200
		},
		{
			"Willowfield",
			2089,
			-1989.9,
			-89.084,
			2324,
			-1852.87,
			110.916
		},
		{
			"Chinatown",
			-2274.17,
			578.396,
			-7.6,
			-2078.67,
			744.17,
			200
		},
		{
			"El Castillo del Diablo",
			-208.57,
			2337.18,
			0,
			8.43,
			2487.18,
			200
		},
		{
			"Ocean Docks",
			2324,
			-2145.1,
			-89.084,
			2703.58,
			-2059.23,
			110.916
		},
		{
			"Easter Bay Chemicals",
			-1132.82,
			-768.027,
			0,
			-956.476,
			-578.118,
			200
		},
		{
			"The Visage",
			1817.39,
			1703.23,
			-89.084,
			2027.4,
			1863.23,
			110.916
		},
		{
			"Ocean Flats",
			-2994.49,
			-430.276,
			-1.2,
			-2831.89,
			-222.589,
			200
		},
		{
			"Richman",
			321.356,
			-860.619,
			-89.084,
			687.802,
			-768.027,
			110.916
		},
		{
			"Green Palms",
			176.581,
			1305.45,
			-3,
			338.658,
			1520.72,
			200
		},
		{
			"Richman",
			321.356,
			-768.027,
			-89.084,
			700.794,
			-674.885,
			110.916
		},
		{
			"Starfish Casino",
			2162.39,
			1883.23,
			-89.084,
			2437.39,
			2012.18,
			110.916
		},
		{
			"East Beach",
			2747.74,
			-1668.13,
			-89.084,
			2959.35,
			-1498.62,
			110.916
		},
		{
			"Jefferson",
			2056.86,
			-1372.04,
			-89.084,
			2281.45,
			-1210.74,
			110.916
		},
		{
			"Downtown Los Santos",
			1463.9,
			-1290.87,
			-89.084,
			1724.76,
			-1150.87,
			110.916
		},
		{
			"Downtown Los Santos",
			1463.9,
			-1430.87,
			-89.084,
			1724.76,
			-1290.87,
			110.916
		},
		{
			"Garver Bridge",
			-1499.89,
			696.442,
			-179.615,
			-1339.89,
			925.353,
			20.385
		},
		{
			"Julius Thruway South",
			1457.39,
			823.228,
			-89.084,
			2377.39,
			863.229,
			110.916
		},
		{
			"East Los Santos",
			2421.03,
			-1628.53,
			-89.084,
			2632.83,
			-1454.35,
			110.916
		},
		{
			"Greenglass College",
			964.391,
			1044.69,
			-89.084,
			1197.39,
			1203.22,
			110.916
		},
		{
			"Las Colinas",
			2747.74,
			-1120.04,
			-89.084,
			2959.35,
			-945.035,
			110.916
		},
		{
			"Mulholland",
			737.573,
			-768.027,
			-89.084,
			1142.29,
			-674.885,
			110.916
		},
		{
			"Ocean Docks",
			2201.82,
			-2730.88,
			-89.084,
			2324,
			-2418.33,
			110.916
		},
		{
			"East Los Santos",
			2462.13,
			-1454.35,
			-89.084,
			2581.73,
			-1135.04,
			110.916
		},
		{
			"Ganton",
			2222.56,
			-1722.33,
			-89.084,
			2632.83,
			-1628.53,
			110.916
		},
		{
			"Avispa Country Club",
			-2831.89,
			-430.276,
			-6.1,
			-2646.4,
			-222.589,
			200
		},
		{
			"Willowfield",
			1970.62,
			-2179.25,
			-89.084,
			2089,
			-1852.87,
			110.916
		},
		{
			"Esplanade North",
			-1982.32,
			1274.26,
			-4.5,
			-1524.24,
			1358.9,
			200
		},
		{
			"The High Roller",
			1817.39,
			1283.23,
			-89.084,
			2027.39,
			1469.23,
			110.916
		},
		{
			"Ocean Docks",
			2201.82,
			-2418.33,
			-89.084,
			2324,
			-2095,
			110.916
		},
		{
			"Last Dime Motel",
			1823.08,
			596.349,
			-89.084,
			1997.22,
			823.228,
			110.916
		},
		{
			"Bayside Marina",
			-2353.17,
			2275.79,
			0,
			-2153.17,
			2475.79,
			200
		},
		{
			"King's",
			-2329.31,
			458.411,
			-7.6,
			-1993.28,
			578.396,
			200
		},
		{
			"El Corona",
			1692.62,
			-2179.25,
			-89.084,
			1812.62,
			-1842.27,
			110.916
		},
		{
			"Blackfield Chapel",
			1375.6,
			596.349,
			-89.084,
			1558.09,
			823.228,
			110.916
		},
		{
			"The Pink Swan",
			1817.39,
			1083.23,
			-89.084,
			2027.39,
			1283.23,
			110.916
		},
		{
			"Julius Thruway West",
			1197.39,
			1163.39,
			-89.084,
			1236.63,
			2243.23,
			110.916
		},
		{
			"Los Flores",
			2581.73,
			-1393.42,
			-89.084,
			2747.74,
			-1135.04,
			110.916
		},
		{
			"The Visage",
			1817.39,
			1863.23,
			-89.084,
			2106.7,
			2011.83,
			110.916
		},
		{
			"Prickle Pine",
			1938.8,
			2624.23,
			-89.084,
			2121.4,
			2861.55,
			110.916
		},
		{
			"Verona Beach",
			851.449,
			-1804.21,
			-89.084,
			1046.15,
			-1577.59,
			110.916
		},
		{
			"Robada Intersection",
			-1119.01,
			1178.93,
			-89.084,
			-862.025,
			1351.45,
			110.916
		},
		{
			"Linden Side",
			2749.9,
			943.235,
			-89.084,
			2923.39,
			1198.99,
			110.916
		},
		{
			"Ocean Docks",
			2703.58,
			-2302.33,
			-89.084,
			2959.35,
			-2126.9,
			110.916
		},
		{
			"Willowfield",
			2324,
			-2059.23,
			-89.084,
			2541.7,
			-1852.87,
			110.916
		},
		{
			"King's",
			-2411.22,
			265.243,
			-9.1,
			-1993.28,
			373.539,
			200
		},
		{
			"Commerce",
			1323.9,
			-1842.27,
			-89.084,
			1701.9,
			-1722.26,
			110.916
		},
		{
			"Mulholland",
			1269.13,
			-768.027,
			-89.084,
			1414.07,
			-452.425,
			110.916
		},
		{
			"Marina",
			647.712,
			-1804.21,
			-89.084,
			851.449,
			-1577.59,
			110.916
		},
		{
			"Battery Point",
			-2741.07,
			1268.41,
			-4.5,
			-2533.04,
			1490.47,
			200
		},
		{
			"The Four Dragons Casino",
			1817.39,
			863.232,
			-89.084,
			2027.39,
			1083.23,
			110.916
		},
		{
			"Blackfield",
			964.391,
			1203.22,
			-89.084,
			1197.39,
			1403.22,
			110.916
		},
		{
			"Julius Thruway North",
			1534.56,
			2433.23,
			-89.084,
			1848.4,
			2583.23,
			110.916
		},
		{
			"Yellow Bell Gol Course",
			1117.4,
			2723.23,
			-89.084,
			1457.46,
			2863.23,
			110.916
		},
		{
			"Idlewood",
			1812.62,
			-1602.31,
			-89.084,
			2124.66,
			-1449.67,
			110.916
		},
		{
			"Redsands West",
			1297.47,
			2142.86,
			-89.084,
			1777.39,
			2243.23,
			110.916
		},
		{
			"Doherty",
			-2270.04,
			-324.114,
			-1.2,
			-1794.92,
			-222.589,
			200
		},
		{
			"Hilltop Farm",
			967.383,
			-450.39,
			-3,
			1176.78,
			-217.9,
			200
		},
		{
			"Las Barrancas",
			-926.13,
			1398.73,
			-3,
			-719.234,
			1634.69,
			200
		},
		{
			"Pirates in Men's Pants",
			1817.39,
			1469.23,
			-89.084,
			2027.4,
			1703.23,
			110.916
		},
		{
			"City Hall",
			-2867.85,
			277.411,
			-9.1,
			-2593.44,
			458.411,
			200
		},
		{
			"Avispa Country Club",
			-2646.4,
			-355.493,
			0,
			-2270.04,
			-222.589,
			200
		},
		{
			"The Strip",
			2027.4,
			863.229,
			-89.084,
			2087.39,
			1703.23,
			110.916
		},
		{
			"Hashbury",
			-2593.44,
			-222.589,
			-1,
			-2411.22,
			54.722,
			200
		},
		{
			"Los Santos International",
			1852,
			-2394.33,
			-89.084,
			2089,
			-2179.25,
			110.916
		},
		{
			"Whitewood Estates",
			1098.31,
			1726.22,
			-89.084,
			1197.39,
			2243.23,
			110.916
		},
		{
			"Sherman Reservoir",
			-789.737,
			1659.68,
			-89.084,
			-599.505,
			1929.41,
			110.916
		},
		{
			"El Corona",
			1812.62,
			-2179.25,
			-89.084,
			1970.62,
			-1852.87,
			110.916
		},
		{
			"Downtown",
			-1700.01,
			744.267,
			-6.1,
			-1580.01,
			1176.52,
			200
		},
		{
			"Foster Valley",
			-2178.69,
			-1250.97,
			0,
			-1794.92,
			-1115.58,
			200
		},
		{
			"Las Payasadas",
			-354.332,
			2580.36,
			2,
			-133.625,
			2816.82,
			200
		},
		{
			"Valle Ocultado",
			-936.668,
			2611.44,
			2,
			-715.961,
			2847.9,
			200
		},
		{
			"Blackfield Intersection",
			1166.53,
			795.01,
			-89.084,
			1375.6,
			1044.69,
			110.916
		},
		{
			"Ganton",
			2222.56,
			-1852.87,
			-89.084,
			2632.83,
			-1722.33,
			110.916
		},
		{
			"Easter Bay Airport",
			-1213.91,
			-730.118,
			0,
			-1132.82,
			-50.096,
			200
		},
		{
			"Redsands East",
			1817.39,
			2011.83,
			-89.084,
			2106.7,
			2202.76,
			110.916
		},
		{
			"Esplanade East",
			-1499.89,
			578.396,
			-79.615,
			-1339.89,
			1274.26,
			20.385
		},
		{
			"Caligula's Palace",
			2087.39,
			1543.23,
			-89.084,
			2437.39,
			1703.23,
			110.916
		},
		{
			"Royal Casino",
			2087.39,
			1383.23,
			-89.084,
			2437.39,
			1543.23,
			110.916
		},
		{
			"Richman",
			72.648,
			-1235.07,
			-89.084,
			321.356,
			-1008.15,
			110.916
		},
		{
			"Starfish Casino",
			2437.39,
			1783.23,
			-89.084,
			2685.16,
			2012.18,
			110.916
		},
		{
			"Mulholland",
			1281.13,
			-452.425,
			-89.084,
			1641.13,
			-290.913,
			110.916
		},
		{
			"Downtown",
			-1982.32,
			744.17,
			-6.1,
			-1871.72,
			1274.26,
			200
		},
		{
			"Hankypanky Point",
			2576.92,
			62.158,
			0,
			2759.25,
			385.503,
			200
		},
		{
			"K.A.C.C. Military Fuels",
			2498.21,
			2626.55,
			-89.084,
			2749.9,
			2861.55,
			110.916
		},
		{
			"Harry Gold Parkway",
			1777.39,
			863.232,
			-89.084,
			1817.39,
			2342.83,
			110.916
		},
		{
			"Bayside Tunnel",
			-2290.19,
			2548.29,
			-89.084,
			-1950.19,
			2723.29,
			110.916
		},
		{
			"Ocean Docks",
			2324,
			-2302.33,
			-89.084,
			2703.58,
			-2145.1,
			110.916
		},
		{
			"Richman",
			321.356,
			-1044.07,
			-89.084,
			647.557,
			-860.619,
			110.916
		},
		{
			"Randolph Industrial Estate",
			1558.09,
			596.349,
			-89.084,
			1823.08,
			823.235,
			110.916
		},
		{
			"East Beach",
			2632.83,
			-1852.87,
			-89.084,
			2959.35,
			-1668.13,
			110.916
		},
		{
			"Flint Water",
			-314.426,
			-753.874,
			-89.084,
			-106.339,
			-463.073,
			110.916
		},
		{
			"Blueberry",
			19.607,
			-404.136,
			3.8,
			349.607,
			-220.137,
			200
		},
		{
			"Linden Station",
			2749.9,
			1198.99,
			-89.084,
			2923.39,
			1548.99,
			110.916
		},
		{
			"Glen Park",
			1812.62,
			-1350.72,
			-89.084,
			2056.86,
			-1100.82,
			110.916
		},
		{
			"Downtown",
			-1993.28,
			265.243,
			-9.1,
			-1794.92,
			578.396,
			200
		},
		{
			"Redsands West",
			1377.39,
			2243.23,
			-89.084,
			1704.59,
			2433.23,
			110.916
		},
		{
			"Richman",
			321.356,
			-1235.07,
			-89.084,
			647.522,
			-1044.07,
			110.916
		},
		{
			"Gant Bridge",
			-2741.45,
			1659.68,
			-6.1,
			-2616.4,
			2175.15,
			200
		},
		{
			"Lil' Probe Inn",
			-90.218,
			1286.85,
			-3,
			153.859,
			1554.12,
			200
		},
		{
			"Flint Intersection",
			-187.7,
			-1596.76,
			-89.084,
			17.063,
			-1276.6,
			110.916
		},
		{
			"Las Colinas",
			2281.45,
			-1135.04,
			-89.084,
			2632.74,
			-945.035,
			110.916
		},
		{
			"Sobell Rail Yards",
			2749.9,
			1548.99,
			-89.084,
			2923.39,
			1937.25,
			110.916
		},
		{
			"The Emerald Isle",
			2011.94,
			2202.76,
			-89.084,
			2237.4,
			2508.23,
			110.916
		},
		{
			"El Castillo del Diablo",
			-208.57,
			2123.01,
			-7.6,
			114.033,
			2337.18,
			200
		},
		{
			"Santa Flora",
			-2741.07,
			458.411,
			-7.6,
			-2533.04,
			793.411,
			200
		},
		{
			"Playa del Seville",
			2703.58,
			-2126.9,
			-89.084,
			2959.35,
			-1852.87,
			110.916
		},
		{
			"Market",
			926.922,
			-1577.59,
			-89.084,
			1370.85,
			-1416.25,
			110.916
		},
		{
			"Queens",
			-2593.44,
			54.722,
			0,
			-2411.22,
			458.411,
			200
		},
		{
			"Pilson Intersection",
			1098.39,
			2243.23,
			-89.084,
			1377.39,
			2507.23,
			110.916
		},
		{
			"Spinybed",
			2121.4,
			2663.17,
			-89.084,
			2498.21,
			2861.55,
			110.916
		},
		{
			"Pilgrim",
			2437.39,
			1383.23,
			-89.084,
			2624.4,
			1783.23,
			110.916
		},
		{
			"Blackfield",
			964.391,
			1403.22,
			-89.084,
			1197.39,
			1726.22,
			110.916
		},
		{
			"'The Big Ear'",
			-410.02,
			1403.34,
			-3,
			-137.969,
			1681.23,
			200
		},
		{
			"Dillimore",
			580.794,
			-674.885,
			-9.5,
			861.085,
			-404.79,
			200
		},
		{
			"El Quebrados",
			-1645.23,
			2498.52,
			0,
			-1372.14,
			2777.85,
			200
		},
		{
			"Esplanade North",
			-2533.04,
			1358.9,
			-4.5,
			-1996.66,
			1501.21,
			200
		},
		{
			"Easter Bay Airport",
			-1499.89,
			-50.096,
			-1,
			-1242.98,
			249.904,
			200
		},
		{
			"Fisher's Lagoon",
			1916.99,
			-233.323,
			-100,
			2131.72,
			13.8,
			200
		},
		{
			"Mulholland",
			1414.07,
			-768.027,
			-89.084,
			1667.61,
			-452.425,
			110.916
		},
		{
			"East Beach",
			2747.74,
			-1498.62,
			-89.084,
			2959.35,
			-1120.04,
			110.916
		},
		{
			"San Andreas Sound",
			2450.39,
			385.503,
			-100,
			2759.25,
			562.349,
			200
		},
		{
			"Shady Creeks",
			-2030.12,
			-2174.89,
			-6.1,
			-1820.64,
			-1771.66,
			200
		},
		{
			"Market",
			1072.66,
			-1416.25,
			-89.084,
			1370.85,
			-1130.85,
			110.916
		},
		{
			"Rockshore West",
			1997.22,
			596.349,
			-89.084,
			2377.39,
			823.228,
			110.916
		},
		{
			"Prickle Pine",
			1534.56,
			2583.23,
			-89.084,
			1848.4,
			2863.23,
			110.916
		},
		{
			"Easter Basin",
			-1794.92,
			-50.096,
			-1.04,
			-1499.89,
			249.904,
			200
		},
		{
			"Leafy Hollow",
			-1166.97,
			-1856.03,
			0,
			-815.624,
			-1602.07,
			200
		},
		{
			"LVA Freight Depot",
			1457.39,
			863.229,
			-89.084,
			1777.4,
			1143.21,
			110.916
		},
		{
			"Prickle Pine",
			1117.4,
			2507.23,
			-89.084,
			1534.56,
			2723.23,
			110.916
		},
		{
			"Blueberry",
			104.534,
			-220.137,
			2.3,
			349.607,
			152.236,
			200
		},
		{
			"El Castillo del Diablo",
			-464.515,
			2217.68,
			0,
			-208.57,
			2580.36,
			200
		},
		{
			"Downtown",
			-2078.67,
			578.396,
			-7.6,
			-1499.89,
			744.267,
			200
		},
		{
			"Rockshore East",
			2537.39,
			676.549,
			-89.084,
			2902.35,
			943.235,
			110.916
		},
		{
			"San Fierro Bay",
			-2616.4,
			1501.21,
			-3,
			-1996.66,
			1659.68,
			200
		},
		{
			"Paradiso",
			-2741.07,
			793.411,
			-6.1,
			-2533.04,
			1268.41,
			200
		},
		{
			"The Camel's Toe",
			2087.39,
			1203.23,
			-89.084,
			2640.4,
			1383.23,
			110.916
		},
		{
			"Old Venturas Strip",
			2162.39,
			2012.18,
			-89.084,
			2685.16,
			2202.76,
			110.916
		},
		{
			"Juniper Hill",
			-2533.04,
			578.396,
			-7.6,
			-2274.17,
			968.369,
			200
		},
		{
			"Juniper Hollow",
			-2533.04,
			968.369,
			-6.1,
			-2274.17,
			1358.9,
			200
		},
		{
			"Roca Escalante",
			2237.4,
			2202.76,
			-89.084,
			2536.43,
			2542.55,
			110.916
		},
		{
			"Julius Thruway East",
			2685.16,
			1055.96,
			-89.084,
			2749.9,
			2626.55,
			110.916
		},
		{
			"Verona Beach",
			647.712,
			-2173.29,
			-89.084,
			930.221,
			-1804.21,
			110.916
		},
		{
			"Foster Valley",
			-2178.69,
			-599.884,
			-1.2,
			-1794.92,
			-324.114,
			200
		},
		{
			"Arco del Oeste",
			-901.129,
			2221.86,
			0,
			-592.09,
			2571.97,
			200
		},
		{
			"Fallen Tree",
			-792.254,
			-698.555,
			-5.3,
			-452.404,
			-380.043,
			200
		},
		{
			"The Farm",
			-1209.67,
			-1317.1,
			114.981,
			-908.161,
			-787.391,
			251.981
		},
		{
			"The Sherman Dam",
			-968.772,
			1929.41,
			-3,
			-481.126,
			2155.26,
			200
		},
		{
			"Esplanade North",
			-1996.66,
			1358.9,
			-4.5,
			-1524.24,
			1592.51,
			200
		},
		{
			"Financial",
			-1871.72,
			744.17,
			-6.1,
			-1701.3,
			1176.42,
			300
		},
		{
			"Garcia",
			-2411.22,
			-222.589,
			-1.14,
			-2173.04,
			265.243,
			200
		},
		{
			"Montgomery",
			1119.51,
			119.526,
			-3,
			1451.4,
			493.323,
			200
		},
		{
			"Creek",
			2749.9,
			1937.25,
			-89.084,
			2921.62,
			2669.79,
			110.916
		},
		{
			"Los Santos International",
			1249.62,
			-2394.33,
			-89.084,
			1852,
			-2179.25,
			110.916
		},
		{
			"Santa Maria Beach",
			72.648,
			-2173.29,
			-89.084,
			342.648,
			-1684.65,
			110.916
		},
		{
			"Mulholland Intersection",
			1463.9,
			-1150.87,
			-89.084,
			1812.62,
			-768.027,
			110.916
		},
		{
			"Angel Pine",
			-2324.94,
			-2584.29,
			-6.1,
			-1964.22,
			-2212.11,
			200
		},
		{
			"Verdant Meadows",
			37.032,
			2337.18,
			-3,
			435.988,
			2677.9,
			200
		},
		{
			"Octane Springs",
			338.658,
			1228.51,
			0,
			664.308,
			1655.05,
			200
		},
		{
			"Come-A-Lot",
			2087.39,
			943.235,
			-89.084,
			2623.18,
			1203.23,
			110.916
		},
		{
			"Redsands West",
			1236.63,
			1883.11,
			-89.084,
			1777.39,
			2142.86,
			110.916
		},
		{
			"Santa Maria Beach",
			342.648,
			-2173.29,
			-89.084,
			647.712,
			-1684.65,
			110.916
		},
		{
			"Verdant Bluffs",
			1249.62,
			-2179.25,
			-89.084,
			1692.62,
			-1842.27,
			110.916
		},
		{
			"Las Venturas Airport",
			1236.63,
			1203.28,
			-89.084,
			1457.37,
			1883.11,
			110.916
		},
		{
			"Flint Range",
			-594.191,
			-1648.55,
			0,
			-187.7,
			-1276.6,
			200
		},
		{
			"Verdant Bluffs",
			930.221,
			-2488.42,
			-89.084,
			1249.62,
			-2006.78,
			110.916
		},
		{
			"Palomino Creek",
			2160.22,
			-149.004,
			0,
			2576.92,
			228.322,
			200
		},
		{
			"Ocean Docks",
			2373.77,
			-2697.09,
			-89.084,
			2809.22,
			-2330.46,
			110.916
		},
		{
			"Easter Bay Airport",
			-1213.91,
			-50.096,
			-4.5,
			-947.98,
			578.396,
			200
		},
		{
			"Whitewood Estates",
			883.308,
			1726.22,
			-89.084,
			1098.31,
			2507.23,
			110.916
		},
		{
			"Calton Heights",
			-2274.17,
			744.17,
			-6.1,
			-1982.32,
			1358.9,
			200
		},
		{
			"Easter Basin",
			-1794.92,
			249.904,
			-9.1,
			-1242.98,
			578.396,
			200
		},
		{
			"Los Santos Inlet",
			-321.744,
			-2224.43,
			-89.084,
			44.615,
			-1724.43,
			110.916
		},
		{
			"Doherty",
			-2173.04,
			-222.589,
			-1,
			-1794.92,
			265.243,
			200
		},
		{
			"Mount Chiliad",
			-2178.69,
			-2189.91,
			-47.917,
			-2030.12,
			-1771.66,
			576.083
		},
		{
			"Fort Carson",
			-376.233,
			826.326,
			-3,
			123.717,
			1220.44,
			200
		},
		{
			"Foster Valley",
			-2178.69,
			-1115.58,
			0,
			-1794.92,
			-599.884,
			200
		},
		{
			"Ocean Flats",
			-2994.49,
			-222.589,
			-1,
			-2593.44,
			277.411,
			200
		},
		{
			"Fern Ridge",
			508.189,
			-139.259,
			0,
			1306.66,
			119.526,
			200
		},
		{
			"Bayside",
			-2741.07,
			2175.15,
			0,
			-2353.17,
			2722.79,
			200
		},
		{
			"Las Venturas Airport",
			1457.37,
			1203.28,
			-89.084,
			1777.39,
			1883.11,
			110.916
		},
		{
			"Blueberry Acres",
			-319.676,
			-220.137,
			0,
			104.534,
			293.324,
			200
		},
		{
			"Palisades",
			-2994.49,
			458.411,
			-6.1,
			-2741.07,
			1339.61,
			200
		},
		{
			"North Rock",
			2285.37,
			-768.027,
			0,
			2770.59,
			-269.74,
			200
		},
		{
			"Hunter Quarry",
			337.244,
			710.84,
			-115.239,
			860.554,
			1031.71,
			203.761
		},
		{
			"Los Santos International",
			1382.73,
			-2730.88,
			-89.084,
			2201.82,
			-2394.33,
			110.916
		},
		{
			"Missionary Hill",
			-2994.49,
			-811.276,
			0,
			-2178.69,
			-430.276,
			200
		},
		{
			"San Fierro Bay",
			-2616.4,
			1659.68,
			-3,
			-1996.66,
			2175.15,
			200
		},
		{
			"Restricted Area",
			-91.586,
			1655.05,
			-50,
			421.234,
			2123.01,
			250
		},
		{
			"Mount Chiliad",
			-2997.47,
			-1115.58,
			-47.917,
			-2178.69,
			-971.913,
			576.083
		},
		{
			"Mount Chiliad",
			-2178.69,
			-1771.66,
			-47.917,
			-1936.12,
			-1250.97,
			576.083
		},
		{
			"Easter Bay Airport",
			-1794.92,
			-730.118,
			-3,
			-1213.91,
			-50.096,
			200
		},
		{
			"The Panopticon",
			-947.98,
			-304.32,
			-1.1,
			-319.676,
			327.071,
			200
		},
		{
			"Shady Creeks",
			-1820.64,
			-2643.68,
			-8,
			-1226.78,
			-1771.66,
			200
		},
		{
			"Back o Beyond",
			-1166.97,
			-2641.19,
			0,
			-321.744,
			-1856.03,
			200
		},
		{
			"Mount Chiliad",
			-2994.49,
			-2189.91,
			-47.917,
			-2178.69,
			-1115.58,
			576.083
		}
	}

	for iter_16_0, iter_16_1 in ipairs(var_16_0) do
		if arg_16_0 >= iter_16_1[2] and arg_16_1 >= iter_16_1[3] and arg_16_2 >= iter_16_1[4] and arg_16_0 <= iter_16_1[5] and arg_16_1 <= iter_16_1[6] and arg_16_2 <= iter_16_1[7] then
			return iter_16_1[1]
		end
	end

	return "Неизвестно"
end

local var_0_30 = {
	[0] = "Краш/Вылет",
	"Выход",
	"Кик/Бан"
}

main_x6 = select(1, getScreenResolution()) - 140
main_y6 = select(2, getScreenResolution()) - 95

if cfg.config.id1 == nil then
	cfg.config.id1 = false
end

if cfg.config.cordXH == nil then
	cfg.config.cordXH = main_x6
end

if cfg.config.cordYH == nil then
	cfg.config.cordYH = main_y6
end

if cfg.config.hud == nil then
	cfg.config.hud = 2
end

if cfg.config.radmod == nil then
	cfg.config.radmod = false
end

if cfg.config.megaf2 == nil then
	cfg.config.megaf2 = false
end

if cfg.config.quitm == nil then
	cfg.config.quitm = false
end

if cfg.config.colorVec4Title1 == nil then
	cfg.config.colorVec4Title1 = 0.19
end

if cfg.config.colorVec4Title2 == nil then
	cfg.config.colorVec4Title2 = 0.22
end

if cfg.config.colorVec4Title3 == nil then
	cfg.config.colorVec4Title3 = 0.26
end

if cfg.config.colorVec4Fon1 == nil then
	cfg.config.colorVec4Fon1 = 0.15
end

if cfg.config.colorVec4Fon2 == nil then
	cfg.config.colorVec4Fon2 = 0.18
end

if cfg.config.colorVec4Fon3 == nil then
	cfg.config.colorVec4Fon3 = 0.22
end

if cfg.config.FonP == nil then
	cfg.config.FonP = 1
end

if cfg.config.colorVec4Pole1 == nil then
	cfg.config.colorVec4Pole1 = 0.19
end

if cfg.config.colorVec4Pole2 == nil then
	cfg.config.colorVec4Pole2 = 0.22
end

if cfg.config.colorVec4Pole3 == nil then
	cfg.config.colorVec4Pole3 = 0.26
end

if cfg.config.colorVec4Button1 == nil then
	cfg.config.colorVec4Button1 = 0.41
end

if cfg.config.colorVec4Button2 == nil then
	cfg.config.colorVec4Button2 = 0.55
end

if cfg.config.colorVec4Button3 == nil then
	cfg.config.colorVec4Button3 = 0.78
end

if cfg.config.colorVec4Text1 == nil then
	cfg.config.colorVec4Text1 = 1
end

if cfg.config.colorVec4Text2 == nil then
	cfg.config.colorVec4Text2 = 1
end

if cfg.config.colorVec4Text3 == nil then
	cfg.config.colorVec4Text3 = 1
end

if cfg.config.bindM == nil then
	cfg.config.bindM = false
end

if cfg.config.autologin == nil then
	cfg.config.autologin = false
end

if cfg.config.women == nil then
	cfg.config.women = false
end

if cfg.config.KDy == nil then
	cfg.config.KDy = select(2, getScreenResolution()) / 3
end

if cfg.config.KDx == nil then
	cfg.config.KDx = select(1, getScreenResolution()) / 15
end

if cfg.config.kraska == nil then
	cfg.config.kraska = false
end

if cfg.config.MSGsound == nil then
	cfg.config.MSGsound = false
end

if cfg.config.MSGchs == nil then
	cfg.config.MSGchs = false
end

if cfg.config.MSGclear == nil then
	cfg.config.MSGclear = false
end

if cfg.config.oblaka == nil then
	cfg.config.oblaka = true
end

if cfg.config.afish == nil then
	cfg.config.afish = false
end

if cfg.config.maskRP == nil then
	cfg.config.maskRP = false
end

if cfg.config.streamcheck == nil then
	cfg.config.streamcheck = false
end

if cfg.config.rpay == nil then
	cfg.config.rpay = false
end

if cfg.config.autobp == nil then
	cfg.config.autobp = false
end

if cfg.config.buttV == nil then
	cfg.config.buttV = true
end

if cfg.config.password == nil then
	cfg.config.password = ""
end

if cfg.config.car2 == nil then
	cfg.config.car2 = false
end

if cfg.config.pricel == nil then
	cfg.config.pricel = false
end

if cfg.config.membmod == nil then
	cfg.config.membmod = false
end

if cfg.config.infobar == nil then
	cfg.config.infobar = 1
end

if cfg.config.infb == nil then
	cfg.config.infb = false
end

if cfg.config.chatT == nil then
	cfg.config.chatT = false
end

if cfg.config.fastsu == nil then
	cfg.config.fastsu = false
end

if cfg.config.infY == nil then
	cfg.config.infY = 320
end

if cfg.config.infX == nil then
	cfg.config.infX = 200
end

if cfg.config.infP == nil then
	cfg.config.infP = 0.7
end

if cfg.config.zero == nil then
	cfg.config.zero = true
end

if cfg.config.deagle == nil then
	cfg.config.deagle = true
end

if cfg.config.shotgun == nil then
	cfg.config.shotgun = true
end

if cfg.config.mp5 == nil then
	cfg.config.mp5 = true
end

if cfg.config.m4 == nil then
	cfg.config.m4 = true
end

if cfg.config.rifle == nil then
	cfg.config.rifle = true
end

if cfg.config.one == nil then
	cfg.config.one = true
end

if cfg.config.two == nil then
	cfg.config.two = true
end

if cfg.config.three == nil then
	cfg.config.three = true
end

if cfg.config.four == nil then
	cfg.config.four = true
end

if cfg.config.five == nil then
	cfg.config.five = true
end

if cfg.config.six == nil then
	cfg.config.six = true
end

if cfg.config.seven == nil then
	cfg.config.seven = true
end

if cfg.config.eight == nil then
	cfg.config.eight = true
end

if cfg.config.nine == nil then
	cfg.config.nine = true
end

if cfg.config.ten == nil then
	cfg.config.ten = true
end

if cfg.config.eleven == nil then
	cfg.config.eleven = true
end

if cfg.config.twelve == nil then
	cfg.config.twelve = true
end

if cfg.config.thirteen == nil then
	cfg.config.thirteen = true
end

if cfg.config.fourteen == nil then
	cfg.config.fourteen = true
end

if cfg.config.fifteen == nil then
	cfg.config.fifteen = true
end

if cfg.config.shpora == nil then
	cfg.config.shpora = 0
end

if cfg.config.shpname0 == nil then
	cfg.config.shpname0 = "Новая шпора"
end

if cfg.config.shpk == nil then
	cfg.config.shpk = 0
end

if cfg.config.shpname2 == nil then
	cfg.config.shpname2 = "Новая шпора"
end

if cfg.config.shpname1 == nil then
	cfg.config.shpname1 = "Новая шпора"
end

if cfg.config.CL2 == nil then
	cfg.config.CL2 = false
end

if cfg.config.tableON == nil then
	cfg.config.tableON = false
end

if cfg.config.TAG5 == nil then
	cfg.config.TAG5 = false
end

if cfg.config.tag4 == nil then
	cfg.config.tag4 = ""
end

if cfg.config.rtagkv == nil then
	cfg.config.rtagkv = false
end

if cfg.config.cl == nil then
	cfg.config.cl = 24
end

if cfg.config.shpname3 == nil then
	cfg.config.shpname3 = "Новая шпора"
end

if cfg.config.shpname4 == nil then
	cfg.config.shpname4 = "Новая шпора"
end

if cfg.config.shpname5 == nil then
	cfg.config.shpname5 = "Новая шпора"
end

if cfg.config.shpname6 == nil then
	cfg.config.shpname6 = "Новая шпора"
end

if cfg.config.posX1 == nil then
	cfg.config.posX1 = 1000
end

if cfg.config.posY1 == nil then
	cfg.config.posY1 = 200
end

if cfg.config.posX == nil then
	cfg.config.posX = 1061
end

if cfg.config.posY == nil then
	cfg.config.posY = 238
end

if cfg.hotkey == nil then
	cfg.hotkey = {
		bindMegaf = "[18, 77]",
		bindRATSC = "[18, 82]",
		bindSCM = "[122]",
		bindMask = "[]",
		bindMSG = "[]",
		bindTazer = "[]",
		bindZkey = "[90]",
		net = "[78]",
		da = "[89]",
		bindLock = "[]"
	}
end

if cfg.hotkey.bindSCM == nil then
	cfg.hotkey.bindSCM = "[122]"
end

if cfg.hotkey.bindMSG == nil then
	cfg.hotkey.bindMSG = "[]"
end

if cfg.hotkey.bindRATSC == nil then
	cfg.hotkey.bindRATSC = "[18, 82]"
end

if cfg.hotkey.bindMask == nil then
	cfg.hotkey.bindMask = "[]"
end

if cfg.hotkey.bindLock == nil then
	cfg.hotkey.bindLock = "[]"
end

if cfg.hotkey.bindTazer == nil then
	cfg.hotkey.bindTazer = "[]"
end

if cfg.hotkey.bindMegaf == nil then
	cfg.hotkey.bindMegaf = "[]"
end

if cfg.hotkey.bindZkey == nil then
	cfg.hotkey.bindZkey = "[]"
end

var_0_4.save(cfg, var_0_24)

local var_0_31, var_0_32 = pcall(require, "imgui_addons")
local imgui = require("imgui")
local var_0_34 = require("fAwesome5")
local var_0_35 = imgui.ImFloat3(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3)
local var_0_36 = imgui.ImFloat3(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3)
local var_0_37 = imgui.ImFloat3(cfg.config.colorVec4Button1, cfg.config.colorVec4Button2, cfg.config.colorVec4Button3)
local var_0_38 = imgui.ImFloat3(cfg.config.colorVec4Pole1, cfg.config.colorVec4Pole2, cfg.config.colorVec4Pole3)
local var_0_39 = imgui.ImFloat3(cfg.config.colorVec4Text1, cfg.config.colorVec4Text2, cfg.config.colorVec4Text3)

ATSC = {
	settings = imgui.ImBool(false),
	bp = imgui.ImBool(false),
	imegaf = imgui.ImBool(false),
	ipogonya = imgui.ImBool(Megaf)
}

function regbinds()
	da1 = {
		v = decodeJson(cfg.hotkey.da)
	}
	Lock = {
		v = decodeJson(cfg.hotkey.bindLock)
	}
	Mask = {
		v = decodeJson(cfg.hotkey.bindMask)
	}
	RATSC = {
		v = decodeJson(cfg.hotkey.bindRATSC)
	}
	Zkey2 = {
		v = decodeJson(cfg.hotkey.bindZkey)
	}
	scm2 = {
		v = decodeJson(cfg.hotkey.bindSCM)
	}
	msg2 = {
		v = decodeJson(cfg.hotkey.bindMSG)
	}
	tazer2 = {
		v = decodeJson(cfg.hotkey.bindTazer)
	}
	megaf22 = {
		v = decodeJson(cfg.hotkey.bindMegaf)
	}
end

function registerbool()
	menu = imgui.ImBool(false)
	commandsa = imgui.ImBool(false)
	log = imgui.ImBool(false)
	tt = imgui.ImBool(false)
	messeng = imgui.ImBool(false)
	tt2 = imgui.ImBool(false)
	memba = imgui.ImBool(false)
	canRender = imgui.ImBool(false)
	pkmM = imgui.ImBool(false)
	note_wshp0 = imgui.ImBool(false)
	note_wshp1 = imgui.ImBool(false)
	note_wshp2 = imgui.ImBool(false)
	note_wshp3 = imgui.ImBool(false)
	note_wshp4 = imgui.ImBool(false)
	note_wshp5 = imgui.ImBool(false)
	shpwindow = imgui.ImBool(false)
	window = imgui.ImBool(false)
	settings_window = imgui.ImBool(false)
	bMainWindow = imgui.ImBool(false)
end

local var_0_40 = imgui.ImInt(cfg.config.infobar)
local var_0_41 = imgui.ImInt(cfg.config.hud)
local var_0_42 = imgui.ImBool(cfg.config.kraska)
local var_0_43 = imgui.ImFloat(cfg.config.infY)
local var_0_44 = imgui.ImFloat(cfg.config.infX)
local var_0_45 = imgui.ImFloat(cfg.config.infP)

var_0_3.default = "CP1251"
u8 = var_0_3.UTF8
tag = "{FF0000}ATSC {ffffff}| "
tagimgui = "ATSC | "

local var_0_46 = imgui.ImBuffer(u8(cfg.config.password), 512)
local var_0_47 = imgui.ImBuffer(u8(cfg.config.tag4), 256)
local var_0_48 = imgui.ImBuffer(256)
local var_0_49 = imgui.ImBuffer(256)
local var_0_50 = imgui.ImBuffer(256)

function registerbuffsh()
	shpname0 = imgui.ImBuffer(u8(cfg.config.shpname0), 256)
	shpname1 = imgui.ImBuffer(u8(cfg.config.shpname1), 256)
	shpname2 = imgui.ImBuffer(u8(cfg.config.shpname2), 256)
	shpname3 = imgui.ImBuffer(u8(cfg.config.shpname3), 256)
	shpname4 = imgui.ImBuffer(u8(cfg.config.shpname4), 256)
	shpname5 = imgui.ImBuffer(u8(cfg.config.shpname5), 256)
	note_tshp0 = imgui.ImBuffer(note_tshp0 or "", 300000)
	note_tshp1 = imgui.ImBuffer(note_tshp1 or "", 300000)
	note_tshp2 = imgui.ImBuffer(note_tshp2 or "", 300000)
	note_tshp3 = imgui.ImBuffer(note_tshp3 or "", 300000)
	note_tshp4 = imgui.ImBuffer(note_tshp4 or "", 300000)
	note_tshp5 = imgui.ImBuffer(note_tshp5 or "", 300000)
	find = imgui.ImBuffer(u8(""), 256)
end

local var_0_51 = false
local var_0_52 = imgui.ImBuffer(256)
local var_0_53 = imgui.ImBuffer(10240)
local var_0_54 = imgui.ImBuffer(256)
local var_0_55 = 0
local var_0_56 = imgui.ImBool(false)
local var_0_57 = imgui.ImBuffer(256)
local var_0_58 = imgui.ImInt(0)
local var_0_59 = imgui.ImBuffer(20480)
local var_0_60 = 0
local var_0_61 = u8("Выбери тип скриптов")
local var_0_62 = 0
local var_0_63, var_0_64 = getScreenResolution()
local var_0_65 = os.date("%H:%M:%S", os.time())
local var_0_66 = imgui.ImBool(false)
local var_0_67 = imgui.ImBool(false)
local var_0_68 = false
local var_0_69 = false
local var_0_70 = false
local var_0_71 = imgui.ImInt(0)
local var_0_72 = imgui.ImInt(0)
local var_0_73 = imgui.ImInt(0)
local var_0_74 = imgui.ImInt(cfg.onDay.full)
local var_0_75 = imgui.ImInt(cfg.onWeek.full)
local var_0_76 = imgui.ImFloat(cfg.style.round)
local var_0_77 = cfg.style.colorW
local var_0_78 = cfg.style.colorT
local var_0_79 = imgui.ImFloat4(imgui.ImColor(var_0_77):GetFloat4())
local var_0_80 = imgui.ImFloat4(imgui.ImColor(var_0_78):GetFloat4())
local var_0_81 = cfg.pos.x
local var_0_82 = cfg.pos.y
local var_0_83 = {
	[0] = "Воскресенье",
	"Понедельник",
	"Вторник",
	"Среда",
	"Четверг",
	"Пятница",
	"Суббота"
}
local var_0_84 = -1
local var_0_85 = -1

local function var_0_86(arg_20_0)
	unloadscript = script.get(arg_20_0)
end

function closeDialog()
	sampSetDialogClientside(false)
	sampCloseCurrentDialogWithButton(0)
end

local var_0_87 = {}
local var_0_88 = {}

function getSprintLocalPlayer()
	return var_0_9.getfloat(12045748) / 31.47000244
end

function getWaterLocalPlayer()
	return var_0_9.getfloat(12045792) / 39.97000244
end

function string.split(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_2 == nil then
		arg_24_2 = 0
	end

	if arg_24_1 == nil then
		arg_24_1 = "%s"
	end

	local var_24_0 = {}

	i = 1

	for iter_24_0 in string.gmatch(arg_24_0, "([^" .. arg_24_1 .. "]+)") do
		if arg_24_2 <= i and arg_24_2 > 0 then
			if var_24_0[i] == nil then
				var_24_0[i] = "" .. iter_24_0
			else
				var_24_0[i] = var_24_0[i] .. arg_24_1 .. iter_24_0
			end
		else
			var_24_0[i] = iter_24_0
			i = i + 1
		end
	end

	return var_24_0
end

local function var_0_89(arg_25_0)
	reloadscript = script.get(arg_25_0)
end

local function var_0_90(arg_26_0)
	unloadedinfo = script.get(arg_26_0)
end

function getColor(arg_27_0)
	PlayerColor = sampGetPlayerColor(arg_27_0)
	a, r, g, b = explode_argb(PlayerColor)

	return r / 255, g / 255, b / 255, 1
end

function explode_argb(arg_28_0)
	local var_28_0 = bit.band(bit.rshift(arg_28_0, 24), 255)
	local var_28_1 = bit.band(bit.rshift(arg_28_0, 16), 255)
	local var_28_2 = bit.band(bit.rshift(arg_28_0, 8), 255)
	local var_28_3 = bit.band(arg_28_0, 255)

	return var_28_0, var_28_1, var_28_2, var_28_3
end

function join_argb(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = arg_29_3
	local var_29_1 = bit.bor(var_29_0, bit.lshift(arg_29_2, 8))
	local var_29_2 = bit.bor(var_29_1, bit.lshift(arg_29_1, 16))

	return (bit.bor(var_29_2, bit.lshift(arg_29_0, 24)))
end

function argb_to_rgba(arg_30_0)
	local var_30_0, var_30_1, var_30_2, var_30_3 = explode_argb(arg_30_0)

	return join_argb(var_30_1, var_30_2, var_30_3, var_30_0)
end

function updatefps()
	lua_thread.create(function()
		while true do
			wait(200)

			myfps = ("%.0f"):format(var_0_9.getfloat(12045136, true))
		end
	end)
end

local var_0_91 = {}
local var_0_92 = {}
local var_0_93 = "-"
local var_0_94 = "-"
local var_0_95 = "-"
local var_0_96 = "-"
local var_0_97 = "-"
local var_0_98 = "-"
local var_0_99 = "-"
local var_0_100 = "name:id"
local var_0_101 = "-"
local var_0_102 = "-"
local var_0_103 = "-"
local var_0_104 = "-"

function imgui.BetterInput(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	local function var_33_0(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
		local var_34_0 = os.clock() - arg_34_2

		if var_34_0 >= 0 and var_34_0 <= arg_34_3 then
			local var_34_1 = var_34_0 / (arg_34_3 / 100)

			return imgui.ImVec4(arg_34_0.x + var_34_1 * (arg_34_1.x - arg_34_0.x) / 100, arg_34_0.y + var_34_1 * (arg_34_1.y - arg_34_0.y) / 100, arg_34_0.z + var_34_1 * (arg_34_1.z - arg_34_0.z) / 100, arg_34_0.w + var_34_1 * (arg_34_1.w - arg_34_0.w) / 100), true
		end

		return arg_34_3 < var_34_0 and arg_34_1 or arg_34_0, false
	end

	local function var_33_1(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
		local var_35_0 = os.clock() - arg_35_2

		if var_35_0 >= 0 and var_35_0 <= arg_35_3 then
			return arg_35_0 + var_35_0 / (arg_35_3 / 100) * (arg_35_1 - arg_35_0) / 100, true
		end

		return arg_35_3 < var_35_0 and arg_35_1 or arg_35_0, false
	end

	imgui.SetCursorPosY(imgui.GetCursorPos().y + imgui.CalcTextSize(arg_33_1).y * 0.7)

	if UI_BETTERINPUT == nil then
		UI_BETTERINPUT = {}
	end

	if not UI_BETTERINPUT[arg_33_0] then
		UI_BETTERINPUT[arg_33_0] = {
			buffer = arg_33_2 or imgui.ImBuffer(256),
			hint = {},
			color = imgui.GetStyle().Colors[imgui.Col.TextDisabled],
			old_color = imgui.GetStyle().Colors[imgui.Col.TextDisabled],
			active = {
				false
			},
			inactive = {
				true
			}
		}
	end

	local var_33_2 = UI_BETTERINPUT[arg_33_0]

	if arg_33_3 == nil then
		arg_33_3 = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
	end

	if arg_33_5 == nil then
		var_33_2.width = imgui.CalcTextSize(arg_33_1).x + 50

		if var_33_2.width < 150 then
			var_33_2.width = 150
		end
	else
		var_33_2.width = arg_33_5
	end

	if var_33_2.hint.scale == nil then
		var_33_2.hint.scale = 1
	end

	if var_33_2.hint.pos == nil then
		var_33_2.hint.pos = imgui.ImVec2(imgui.GetCursorPos().x, imgui.GetCursorPos().y)
	end

	if var_33_2.hint.old_pos == nil then
		var_33_2.hint.old_pos = imgui.GetCursorPos().y
	end

	imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(1, 1, 1, 0))
	imgui.PushStyleColor(imgui.Col.Text, arg_33_4 or imgui.ImVec4(1, 1, 1, 1))
	imgui.PushStyleColor(imgui.Col.TextSelectedBg, arg_33_3)
	imgui.PushStyleVar(imgui.StyleVar.FramePadding, imgui.ImVec2(0, imgui.GetStyle().FramePadding.y))
	imgui.PushItemWidth(var_33_2.width)

	local var_33_3 = imgui.GetWindowDrawList()

	var_33_3:AddLine(imgui.ImVec2(imgui.GetCursorPos().x + imgui.GetWindowPos().x, imgui.GetCursorPos().y + imgui.GetWindowPos().y + 2 * imgui.GetStyle().FramePadding.y + imgui.CalcTextSize(arg_33_1).y), imgui.ImVec2(imgui.GetCursorPos().x + imgui.GetWindowPos().x + var_33_2.width, imgui.GetCursorPos().y + imgui.GetWindowPos().y + 2 * imgui.GetStyle().FramePadding.y + imgui.CalcTextSize(arg_33_1).y), imgui.GetColorU32(var_33_2.color), 2)
	imgui.InputText("##" .. arg_33_0, var_33_2.buffer)

	if not imgui.IsItemActive() then
		if var_33_2.inactive[2] == nil then
			var_33_2.inactive[2] = os.clock()
		end

		var_33_2.inactive[1] = true
		var_33_2.active[1] = false
		var_33_2.active[2] = nil
	elseif imgui.IsItemActive() or imgui.IsItemClicked() then
		var_33_2.inactive[1] = false
		var_33_2.inactive[2] = nil

		if var_33_2.active[2] == nil then
			var_33_2.active[2] = os.clock()
		end

		var_33_2.active[1] = true
	end

	if var_33_2.inactive[1] and #var_33_2.buffer.v == 0 then
		var_33_2.color = var_33_0(var_33_2.color, var_33_2.old_color, var_33_2.inactive[2], 0.75)
		var_33_2.hint.scale = var_33_1(var_33_2.hint.scale, 1, var_33_2.inactive[2], 0.25)
		var_33_2.hint.pos.y = var_33_1(var_33_2.hint.pos.y, var_33_2.hint.old_pos, var_33_2.inactive[2], 0.25)
	elseif var_33_2.inactive[1] and #var_33_2.buffer.v > 0 then
		var_33_2.color = var_33_0(var_33_2.color, var_33_2.old_color, var_33_2.inactive[2], 0.75)
		var_33_2.hint.scale = var_33_1(var_33_2.hint.scale, 0.7, var_33_2.inactive[2], 0.25)
		var_33_2.hint.pos.y = var_33_1(var_33_2.hint.pos.y, var_33_2.hint.old_pos - imgui.GetFontSize() * 0.7 - 2, var_33_2.inactive[2], 0.25)
	elseif var_33_2.active[1] and #var_33_2.buffer.v == 0 then
		var_33_2.color = var_33_0(var_33_2.color, arg_33_3, var_33_2.active[2], 0.75)
		var_33_2.hint.scale = var_33_1(var_33_2.hint.scale, 0.7, var_33_2.active[2], 0.25)
		var_33_2.hint.pos.y = var_33_1(var_33_2.hint.pos.y, var_33_2.hint.old_pos - imgui.GetFontSize() * 0.7 - 2, var_33_2.active[2], 0.25)
	elseif var_33_2.active[1] and #var_33_2.buffer.v > 0 then
		var_33_2.color = var_33_0(var_33_2.color, arg_33_3, var_33_2.active[2], 0.75)
		var_33_2.hint.scale = var_33_1(var_33_2.hint.scale, 0.7, var_33_2.active[2], 0.25)
		var_33_2.hint.pos.y = var_33_1(var_33_2.hint.pos.y, var_33_2.hint.old_pos - imgui.GetFontSize() * 0.7 - 2, var_33_2.active[2], 0.25)
	end

	imgui.SetWindowFontScale(var_33_2.hint.scale)
	var_33_3:AddText(imgui.ImVec2(var_33_2.hint.pos.x + imgui.GetWindowPos().x + imgui.GetStyle().FramePadding.x, var_33_2.hint.pos.y + imgui.GetWindowPos().y + imgui.GetStyle().FramePadding.y), imgui.GetColorU32(var_33_2.color), arg_33_1)
	imgui.SetWindowFontScale(1)
	imgui.PopItemWidth()
	imgui.PopStyleColor(3)
	imgui.PopStyleVar()
end

local var_0_105 = {
	[var_0_10.VK_RETURN] = true,
	[var_0_10.VK_T] = true,
	[var_0_10.VK_F6] = true,
	[var_0_10.VK_F8] = true
}
local var_0_106 = {
	[116] = true,
	[84] = true
}
local var_0_107 = {}
local var_0_108 = {}
local var_0_109 = {}

var_0_108._VERSION = "1.1.5"
var_0_108._SETTINGS = {
	noKeysMessage = u8("Нет")
}

local var_0_110 = 10
local var_0_111 = 80
local var_0_112 = false
local var_0_113 = {
	save = {}
}

function imgui.CentrTextDisabled(arg_36_0)
	local var_36_0 = imgui.GetWindowWidth()
	local var_36_1 = imgui.CalcTextSize(arg_36_0)

	imgui.SetCursorPosX(var_36_0 / 2 - var_36_1.x / 2)
	imgui.TextDisabled(arg_36_0)
end

function var_0_22.onHotKey(arg_37_0, arg_37_1)
	if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
		return false
	end
end

function var_0_108.HotKey(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_3 or 90
	local var_38_1 = tostring(arg_38_0)
	local var_38_2 = arg_38_2 or {}
	local var_38_3 = arg_38_1 or {}
	local var_38_4 = false

	var_38_2.v = var_38_3.v

	local var_38_5 = table.concat(var_0_22.getKeysName(var_38_3.v), " + ")

	if #var_0_113.save > 0 and tostring(var_0_113.save[1]) == var_38_1 then
		var_38_3.v = var_0_113.save[2]
		var_38_5 = table.concat(var_0_22.getKeysName(var_38_3.v), " + ")
		var_0_113.save = {}
		var_38_4 = true
	elseif var_0_113.edit ~= nil and tostring(var_0_113.edit) == var_38_1 then
		if #var_0_109 == 0 then
			var_38_5 = os.time() % 2 == 0 and var_0_108._SETTINGS.noKeysMessage or " "
		else
			var_38_5 = table.concat(var_0_22.getKeysName(var_0_109), " + ")
		end
	end

	imgui.PushStyleColor(imgui.Col.Button, imgui.GetStyle().Colors[imgui.Col.FrameBg])
	imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.GetStyle().Colors[imgui.Col.FrameBgHovered])
	imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.GetStyle().Colors[imgui.Col.FrameBgActive])

	if imgui.Button((tostring(var_38_5):len() == 0 and var_0_108._SETTINGS.noKeysMessage or var_38_5) .. var_38_1, imgui.ImVec2(var_38_0, 0)) then
		var_0_113.edit = var_38_1
	end

	imgui.PopStyleColor(3)

	return var_38_4
end

imgui.HotKey = require("imgui_addons").HotKey

function imgui.TextColoredRGB(arg_39_0)
	local var_39_0 = imgui.GetStyle().Colors
	local var_39_1 = imgui.ImVec4

	local function var_39_2(arg_40_0)
		local var_40_0 = bit.band(bit.rshift(arg_40_0, 24), 255)
		local var_40_1 = bit.band(bit.rshift(arg_40_0, 16), 255)
		local var_40_2 = bit.band(bit.rshift(arg_40_0, 8), 255)
		local var_40_3 = bit.band(arg_40_0, 255)

		return var_40_0, var_40_1, var_40_2, var_40_3
	end

	local function var_39_3(arg_41_0)
		if arg_41_0:sub(1, 6):upper() == "SSSSSS" then
			local var_41_0 = var_39_0[1].x
			local var_41_1 = var_39_0[1].y
			local var_41_2 = var_39_0[1].z
			local var_41_3 = tonumber(arg_41_0:sub(7, 8), 16) or var_39_0[1].w * 255

			return var_39_1(var_41_0, var_41_1, var_41_2, var_41_3 / 255)
		end

		local var_41_4 = type(arg_41_0) == "string" and tonumber(arg_41_0, 16) or arg_41_0

		if type(var_41_4) ~= "number" then
			return
		end

		local var_41_5, var_41_6, var_41_7, var_41_8 = var_39_2(var_41_4)

		return imgui.ImColor(var_41_5, var_41_6, var_41_7, var_41_8):GetVec4()
	end

	;(function(arg_42_0)
		for iter_42_0 in arg_42_0:gmatch("[^\r\n]+") do
			local var_42_0 = {}
			local var_42_1 = {}
			local var_42_2 = 1

			iter_42_0 = iter_42_0:gsub("{(......)}", "{%1FF}")

			while iter_42_0:find("{........}") do
				local var_42_3, var_42_4 = iter_42_0:find("{........}")
				local var_42_5 = var_39_3(iter_42_0:sub(var_42_3 + 1, var_42_4 - 1))

				if var_42_5 then
					var_42_0[#var_42_0], var_42_0[#var_42_0 + 1] = iter_42_0:sub(var_42_2, var_42_3 - 1), iter_42_0:sub(var_42_4 + 1, #iter_42_0)
					var_42_1[#var_42_1 + 1] = var_42_5
					var_42_2 = var_42_3
				end

				iter_42_0 = iter_42_0:sub(1, var_42_3 - 1) .. iter_42_0:sub(var_42_4 + 1, #iter_42_0)
			end

			if var_42_0[0] then
				for iter_42_1 = 0, #var_42_0 do
					imgui.TextColored(var_42_1[iter_42_1] or var_39_0[1], u8(var_42_0[iter_42_1]))
					imgui.SameLine(nil, 0)
				end

				imgui.NewLine()
			else
				imgui.Text(u8(iter_42_0))
			end
		end
	end)(arg_39_0)
end

function getColorForSeconds(arg_43_0)
	if arg_43_0 > 0 and arg_43_0 <= 50 then
		return imgui.ImVec4(1, 1, 0, 1)
	elseif arg_43_0 > 50 and arg_43_0 <= 100 then
		return imgui.ImVec4(1, 0.6235294117647059, 0.12549019607843137, 1)
	elseif arg_43_0 > 100 and arg_43_0 <= 200 then
		return imgui.ImVec4(1, 0.36470588235294116, 0.09411764705882353, 1)
	elseif arg_43_0 > 200 and arg_43_0 <= 300 then
		return imgui.ImVec4(1, 0.16862745098039217, 0.16862745098039217, 1)
	elseif arg_43_0 > 300 then
		return imgui.ImVec4(1, 0, 0, 1)
	end
end

function imgui.CenterTextColoredRGB(arg_44_0)
	local var_44_0 = imgui.GetWindowWidth()
	local var_44_1 = imgui.GetStyle().Colors
	local var_44_2 = imgui.ImVec4

	local function var_44_3(arg_45_0)
		local var_45_0 = bit.band(bit.rshift(arg_45_0, 24), 255)
		local var_45_1 = bit.band(bit.rshift(arg_45_0, 16), 255)
		local var_45_2 = bit.band(bit.rshift(arg_45_0, 8), 255)
		local var_45_3 = bit.band(arg_45_0, 255)

		return var_45_0, var_45_1, var_45_2, var_45_3
	end

	local function var_44_4(arg_46_0)
		if arg_46_0:sub(1, 6):upper() == "SSSSSS" then
			local var_46_0 = var_44_1[1].x
			local var_46_1 = var_44_1[1].y
			local var_46_2 = var_44_1[1].z
			local var_46_3 = tonumber(arg_46_0:sub(7, 8), 16) or var_44_1[1].w * 255

			return var_44_2(var_46_0, var_46_1, var_46_2, var_46_3 / 255)
		end

		local var_46_4 = type(arg_46_0) == "string" and tonumber(arg_46_0, 16) or arg_46_0

		if type(var_46_4) ~= "number" then
			return
		end

		local var_46_5, var_46_6, var_46_7, var_46_8 = var_44_3(var_46_4)

		return imgui.ImColor(var_46_5, var_46_6, var_46_7, var_46_8):GetVec4()
	end

	;(function(arg_47_0)
		for iter_47_0 in arg_47_0:gmatch("[^\r\n]+") do
			local var_47_0 = iter_47_0:gsub("{.-}", "")
			local var_47_1 = imgui.CalcTextSize(u8(var_47_0))

			imgui.SetCursorPosX(var_44_0 / 2 - var_47_1.x / 2)

			local var_47_2 = {}
			local var_47_3 = {}
			local var_47_4 = 1

			iter_47_0 = iter_47_0:gsub("{(......)}", "{%1FF}")

			while iter_47_0:find("{........}") do
				local var_47_5, var_47_6 = iter_47_0:find("{........}")
				local var_47_7 = var_44_4(iter_47_0:sub(var_47_5 + 1, var_47_6 - 1))

				if var_47_7 then
					var_47_2[#var_47_2], var_47_2[#var_47_2 + 1] = iter_47_0:sub(var_47_4, var_47_5 - 1), iter_47_0:sub(var_47_6 + 1, #iter_47_0)
					var_47_3[#var_47_3 + 1] = var_47_7
					var_47_4 = var_47_5
				end

				iter_47_0 = iter_47_0:sub(1, var_47_5 - 1) .. iter_47_0:sub(var_47_6 + 1, #iter_47_0)
			end

			if var_47_2[0] then
				for iter_47_1 = 0, #var_47_2 do
					imgui.TextColored(var_47_3[iter_47_1] or var_44_1[1], u8(var_47_2[iter_47_1]))
					imgui.SameLine(nil, 0)
				end

				imgui.NewLine()
			else
				imgui.Text(u8(iter_47_0))
			end
		end
	end)(arg_44_0)
end

function registerCommandsBinder()
	for iter_48_0, iter_48_1 in pairs(var_0_16) do
		if sampIsChatCommandDefined(iter_48_1.cmd) then
			sampUnregisterChatCommand(iter_48_1.cmd)
		end

		sampRegisterChatCommand(iter_48_1.cmd, function(arg_49_0)
			thread = lua_thread.create(function()
				local var_50_0 = string.split(arg_49_0, " ", iter_48_1.params)
				local var_50_1 = iter_48_1.text

				if #var_50_0 < iter_48_1.params then
					local var_50_2 = ""

					for iter_50_0 = 1, iter_48_1.params do
						var_50_2 = var_50_2 .. "[параметр" .. iter_50_0 .. "] "
					end

					sampAddChatMessage("Введите: /" .. iter_48_1.cmd .. " " .. var_50_2, -1)
				else
					for iter_50_1 in var_50_1:gmatch("[^\r\n]+") do
						if iter_50_1:match("^{wait%:%d+}$") then
							wait(iter_50_1:match("^%{wait%:(%d+)}$"))
						elseif iter_50_1:match("^{screen}$") then
							screen()
						else
							local var_50_3 = string.match(iter_50_1, "^{noe}(.+)") ~= nil
							local var_50_4 = string.match(iter_50_1, "^{f6}(.+)") ~= nil
							local var_50_5 = {
								["{noe}"] = "",
								["{f6}"] = "",
								["{myid}"] = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)),
								["{kv}"] = kvadrat(),
								["{targetid}"] = var_0_85,
								["{targetrpnick}"] = sampGetPlayerNicknameForBinder(var_0_85):gsub("_", " "),
								["{naparnik}"] = naparnik(),
								["{myrpnick}"] = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "),
								["{smsid}"] = smsid,
								["{smstoid}"] = smstoid,
								["{mytag}"] = cfg.config.tag4,
								["{rang}"] = rang,
								["{frak}"] = frak,
								["{dl}"] = var_0_84
							}

							for iter_50_2 = 1, iter_48_1.params do
								var_50_5["{param:" .. iter_50_2 .. "}"] = var_50_0[iter_50_2]
							end

							for iter_50_3, iter_50_4 in pairs(var_50_5) do
								iter_50_1 = iter_50_1:gsub(iter_50_3, iter_50_4)
							end

							if not var_50_3 then
								if var_50_4 then
									sampProcessChatInput(iter_50_1)
								else
									sampSendChat(iter_50_1)
								end
							else
								sampSetChatInputText(iter_50_1)
								sampSetChatInputEnabled(true)
							end
						end
					end
				end
			end)
		end)
	end
end

function imgui.CentrText(arg_51_0)
	local var_51_0 = imgui.GetWindowWidth()
	local var_51_1 = imgui.CalcTextSize(arg_51_0)

	imgui.SetCursorPosX(var_51_0 / 2 - var_51_1.x / 2)
	imgui.Text(arg_51_0)
end

function imgui.CenterTextColored(arg_52_0, arg_52_1)
	local var_52_0 = imgui.GetWindowWidth()
	local var_52_1 = imgui.CalcTextSize(arg_52_1)

	imgui.SetCursorPosX(var_52_0 / 2 - var_52_1.x / 2)
	imgui.TextColored(arg_52_0, arg_52_1)
end

function var_0_108.getCurrentEdit()
	return var_0_113.edit ~= nil
end

function var_0_108.getKeysList(arg_54_0)
	local var_54_0 = arg_54_0 or false
	local var_54_1 = {}

	if var_54_0 then
		for iter_54_0, iter_54_1 in ipairs(var_0_109) do
			var_54_1[iter_54_0] = var_0_10.id_to_name(iter_54_1)
		end
	else
		var_54_1 = var_0_109
	end

	return var_54_1
end

function var_0_108.getKeyNumber(arg_55_0)
	for iter_55_0, iter_55_1 in ipairs(var_0_109) do
		if iter_55_1 == arg_55_0 then
			return iter_55_0
		end
	end

	return -1
end

local function var_0_114()
	local var_56_0 = {}

	for iter_56_0, iter_56_1 in pairs(var_0_109) do
		var_56_0[#var_56_0 + 1] = iter_56_1
	end

	var_0_109 = var_56_0

	return true
end

addEventHandler("onWindowMessage", function(arg_57_0, arg_57_1, arg_57_2)
	if var_0_113.edit ~= nil and arg_57_0 == var_0_8.WM_CHAR and var_0_106[arg_57_1] then
		consumeWindowMessage(true, true)
	end

	if arg_57_0 == var_0_8.WM_KEYDOWN or arg_57_0 == var_0_8.WM_SYSKEYDOWN then
		if var_0_113.edit ~= nil and arg_57_1 == var_0_10.VK_ESCAPE then
			var_0_109 = {}
			var_0_113.edit = nil

			consumeWindowMessage(true, true)
		end

		if var_0_113.edit ~= nil and arg_57_1 == var_0_10.VK_BACK then
			var_0_113.save = {
				var_0_113.edit,
				{}
			}
			var_0_113.edit = nil

			consumeWindowMessage(true, true)
		end

		if var_0_108.getKeyNumber(arg_57_1) == -1 then
			var_0_109[#var_0_109 + 1] = arg_57_1

			if var_0_113.edit ~= nil and not var_0_22.isKeyModified(arg_57_1) then
				var_0_113.save = {
					var_0_113.edit,
					var_0_109
				}
				var_0_113.edit = nil
				var_0_109 = {}

				consumeWindowMessage(true, true)
			end
		end

		var_0_114()

		if var_0_113.edit ~= nil then
			consumeWindowMessage(true, true)
		end
	elseif arg_57_0 == var_0_8.WM_KEYUP or arg_57_0 == var_0_8.WM_SYSKEYUP then
		local var_57_0 = var_0_108.getKeyNumber(arg_57_1)

		if var_57_0 > -1 then
			var_0_109[var_57_0] = nil
		end

		var_0_114()

		if var_0_113.edit ~= nil then
			consumeWindowMessage(true, true)
		end
	end
end)

local function var_0_115(arg_58_0)
	var_0_51 = true

	local var_58_0 = script.find(arg_58_0)

	scriptname = var_58_0.name
	scriptdescription = var_58_0.description
	scriptversion_num = var_58_0.version_num
	scriptversion = var_58_0.version
	scriptauthors = var_58_0.authors
	scriptdependencies = var_58_0.dependencies
	scriptpath = var_58_0.path
end

function saveData(arg_59_0, arg_59_1)
	if doesFileExist(arg_59_1) then
		os.remove(arg_59_1)
	end

	local var_59_0 = io.open(arg_59_1, "w")

	if var_59_0 then
		var_59_0:write(encodeJson(arg_59_0))
		var_59_0:close()
	end
end

function imgui.CenterTextColoredRGB(arg_60_0)
	local var_60_0 = imgui.GetWindowWidth()
	local var_60_1 = imgui.GetStyle().Colors
	local var_60_2 = imgui.ImVec4

	local function var_60_3(arg_61_0)
		local var_61_0 = bit.band(bit.rshift(arg_61_0, 24), 255)
		local var_61_1 = bit.band(bit.rshift(arg_61_0, 16), 255)
		local var_61_2 = bit.band(bit.rshift(arg_61_0, 8), 255)
		local var_61_3 = bit.band(arg_61_0, 255)

		return var_61_0, var_61_1, var_61_2, var_61_3
	end

	local function var_60_4(arg_62_0)
		if arg_62_0:sub(1, 6):upper() == "SSSSSS" then
			local var_62_0 = var_60_1[1].x
			local var_62_1 = var_60_1[1].y
			local var_62_2 = var_60_1[1].z
			local var_62_3 = tonumber(arg_62_0:sub(7, 8), 16) or var_60_1[1].w * 255

			return var_60_2(var_62_0, var_62_1, var_62_2, var_62_3 / 255)
		end

		local var_62_4 = type(arg_62_0) == "string" and tonumber(arg_62_0, 16) or arg_62_0

		if type(var_62_4) ~= "number" then
			return
		end

		local var_62_5, var_62_6, var_62_7, var_62_8 = var_60_3(var_62_4)

		return imgui.ImColor(var_62_5, var_62_6, var_62_7, var_62_8):GetVec4()
	end

	;(function(arg_63_0)
		for iter_63_0 in arg_63_0:gmatch("[^\r\n]+") do
			local var_63_0 = iter_63_0:gsub("{.-}", "")
			local var_63_1 = imgui.CalcTextSize(u8(var_63_0))

			imgui.SetCursorPosX(var_60_0 / 2 - var_63_1.x / 2)

			local var_63_2 = {}
			local var_63_3 = {}
			local var_63_4 = 1

			iter_63_0 = iter_63_0:gsub("{(......)}", "{%1FF}")

			while iter_63_0:find("{........}") do
				local var_63_5, var_63_6 = iter_63_0:find("{........}")
				local var_63_7 = var_60_4(iter_63_0:sub(var_63_5 + 1, var_63_6 - 1))

				if var_63_7 then
					var_63_2[#var_63_2], var_63_2[#var_63_2 + 1] = iter_63_0:sub(var_63_4, var_63_5 - 1), iter_63_0:sub(var_63_6 + 1, #iter_63_0)
					var_63_3[#var_63_3 + 1] = var_63_7
					var_63_4 = var_63_5
				end

				iter_63_0 = iter_63_0:sub(1, var_63_5 - 1) .. iter_63_0:sub(var_63_6 + 1, #iter_63_0)
			end

			if var_63_2[0] then
				for iter_63_1 = 0, #var_63_2 do
					imgui.TextColored(var_63_3[iter_63_1] or var_60_1[1], u8(var_63_2[iter_63_1]))
					imgui.SameLine(nil, 0)
				end

				imgui.NewLine()
			else
				imgui.Text(u8(iter_63_0))
			end
		end
	end)(arg_60_0)
end

function imgui.Ques(arg_64_0)
	imgui.SameLine()
	imgui.TextDisabled("(?)")

	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.TextUnformatted(u8(arg_64_0))
		imgui.EndTooltip()
	end
end

local var_0_116 = {
	id = -1,
	inputActive = false
}
local var_0_117 = imgui.ImBool(false)

if doesFileExist(var_0_13) then
	local var_0_118 = io.open(var_0_13, "r")

	if var_0_118 then
		tBindList = decodeJson(var_0_118:read("a*"))

		var_0_118:close()
	end
else
	tBindList = {}
end

function imgui.Link(arg_65_0, arg_65_1)
	arg_65_1 = arg_65_1 or arg_65_0

	local var_65_0 = imgui.CalcTextSize(arg_65_1)
	local var_65_1 = imgui.GetCursorScreenPos()
	local var_65_2 = imgui.GetWindowDrawList()
	local var_65_3 = {
		4294932224,
		4294940928
	}

	if imgui.InvisibleButton("##" .. arg_65_0, var_65_0) then
		os.execute("explorer " .. arg_65_0)
	end

	local var_65_4 = imgui.IsItemHovered() and var_65_3[1] or var_65_3[2]

	var_65_2:AddText(var_65_1, var_65_4, arg_65_1)
	var_65_2:AddLine(imgui.ImVec2(var_65_1.x, var_65_1.y + var_65_0.y), imgui.ImVec2(var_65_1.x + var_65_0.x, var_65_1.y + var_65_0.y), var_65_4)
end

local var_0_119
local key0 = imgui.ImGlyphRanges({
	var_0_34.min_range,
	var_0_34.max_range
})

function imgui.BeforeDrawFrame()
	if var_0_119 == nil then
		local var_66_0 = imgui.ImFontConfig()

		var_66_0.MergeMode = true
		var_0_119 = imgui.GetIO().Fonts:AddFontFromFileTTF("moonloader/resource/fonts/fa-solid-900.ttf", 13, var_66_0, key0)
	end
end

local key1 = {}
local key2 = {}
local key3 = {}
local key4 = {}
local key5 = {}
local key6 = 0

navigation = {
	current = 1,
	list = {
		u8("Лог рации"),
		u8("Лог волны департамента"),
		u8("Лог СМС"),
		u8("Список ООП"),
		u8("Chatlog")
	}
}
navigation2 = {
	current2 = 1,
	list2 = {
		u8("Общие настройки"),
		u8("Фракционные"),
		u8("Бинды"),
		u8("Тема")
	}
}
navigation3 = {
	current3 = 1,
	list3 = {
		u8("Все игроки"),
		u8("Фракция"),
		u8("Лидеры"),
		u8("Саппорты")
	}
}

function imgui.Opis(arg_67_0)
	imgui.Text(var_0_34.ICON_FA_CARET_RIGHT .. u8(" Описание"))

	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextColoredRGB(arg_67_0)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function imgui.OnDrawFrame()
	if cfg.config.oblaka then
		var_0_9.setint8(12046052, 1)
	else
		var_0_9.setint8(12046052, 0)
	end

	if cfg.config.chatT and isKeyJustPressed(84) and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
		sampSetChatInputEnabled(true)
	end

	if sampIsChatVisible() then
		infb.v = cfg.config.infb
	else
		infb.v = false
	end

	if imgui.IsMouseClicked(0) and MP then
		MP = false
		ATSC.settings.v = true

		sampToggleCursor(false)
		sampAddChatMessage(tag .. "Выбранная позиция сохранена.", -1)
		var_0_4.save(cfg, var_0_24)
	end

	messenger()

	if getCharHeading(playerPed) >= 337.5 or getCharHeading(playerPed) <= 22.5 then
		naprav = "Северное"
	end

	if getCharHeading(playerPed) > 22.5 and getCharHeading(playerPed) <= 67.5 then
		naprav = "Северо-западное"
	end

	if getCharHeading(playerPed) > 67.5 and getCharHeading(playerPed) <= 112.5 then
		naprav = "Западное"
	end

	if getCharHeading(playerPed) > 112.5 and getCharHeading(playerPed) <= 157.5 then
		naprav = "Юго-западное"
	end

	if getCharHeading(playerPed) > 157.5 and getCharHeading(playerPed) <= 202.5 then
		naprav = "Южное"
	end

	if getCharHeading(playerPed) > 202.5 and getCharHeading(playerPed) <= 247.5 then
		naprav = "Юго-восточное"
	end

	if getCharHeading(playerPed) > 247.5 and getCharHeading(playerPed) <= 292.5 then
		naprav = "Восточное"
	end

	if getCharHeading(playerPed) > 292.5 and getCharHeading(playerPed) <= 337.5 then
		naprav = "Северо-восточное"
	end

	if note_wshp0.v then
		imgui.ShowCursor = true

		local var_68_0, var_68_1 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_0 / 2, var_68_1 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(var_68_0 / 2, var_68_1 / 2), imgui.Cond.FirstUseEver)
		imgui.Begin("Note", note_wshp0, imgui.WindowFlags.NoResize)
		imgui.InputTextMultiline(u8("##"), note_tshp0, imgui.ImVec2(-1, 390))

		if imgui.Button(u8("Сохранить"), imgui.ImVec2(-1, 25)) then
			io.open("moonloader\\config\\" .. cfg.config.shpname0 .. ".json", "w+"):write(note_tshp0.v):close()
			sampAddChatMessage(tag .. "Вы успешно сохранили текст", -1)

			note_wshp0.v = false
		end

		imgui.End()
	end

	if note_wshp1.v then
		imgui.ShowCursor = true

		local var_68_2, var_68_3 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_2 / 2, var_68_3 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(var_68_2 / 2, var_68_3 / 2), imgui.Cond.FirstUseEver)
		imgui.Begin("Note", note_wshp1, imgui.WindowFlags.NoResize)
		imgui.InputTextMultiline(u8("##"), note_tshp1, imgui.ImVec2(-1, 390))

		if imgui.Button(u8("Сохранить"), imgui.ImVec2(-1, 25)) then
			io.open("moonloader\\config\\" .. cfg.config.shpname1 .. ".json", "w+"):write(note_tshp1.v):close()
			sampAddChatMessage(tag .. "Вы успешно сохранили текст", -1)

			note_wshp1.v = false
		end

		imgui.End()
	end

	if note_wshp2.v then
		imgui.ShowCursor = true

		local var_68_4, var_68_5 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_4 / 2, var_68_5 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(var_68_4 / 2, var_68_5 / 2), imgui.Cond.FirstUseEver)
		imgui.Begin("Note", note_wshp2, imgui.WindowFlags.NoResize)
		imgui.InputTextMultiline(u8("##"), note_tshp2, imgui.ImVec2(-1, 390))

		if imgui.Button(u8("Сохранить"), imgui.ImVec2(-1, 25)) then
			io.open("moonloader\\config\\" .. cfg.config.shpname2 .. ".json", "w+"):write(note_tshp2.v):close()
			sampAddChatMessage(tag .. "Вы успешно сохранили текст", -1)

			note_wshp2.v = false
		end

		imgui.End()
	end

	if note_wshp3.v then
		imgui.ShowCursor = true

		local var_68_6, var_68_7 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_6 / 2, var_68_7 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(var_68_6 / 2, var_68_7 / 2), imgui.Cond.FirstUseEver)
		imgui.Begin("Note", note_wshp0, imgui.WindowFlags.NoResize)
		imgui.InputTextMultiline(u8("##"), note_tshp3, imgui.ImVec2(-1, 390))

		if imgui.Button(u8("Сохранить"), imgui.ImVec2(-1, 25)) then
			io.open("moonloader\\config\\" .. cfg.config.shpname3 .. ".json", "w+"):write(note_tshp3.v):close()
			sampAddChatMessage(tag .. "Вы успешно сохранили текст", -1)

			note_wshp3.v = false
		end

		imgui.End()
	end

	if note_wshp4.v then
		imgui.ShowCursor = true

		local var_68_8, var_68_9 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_8 / 2, var_68_9 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(var_68_8 / 2, var_68_9 / 2), imgui.Cond.FirstUseEver)
		imgui.Begin("Note", note_wshp4, imgui.WindowFlags.NoResize)
		imgui.InputTextMultiline(u8("##"), note_tshp4, imgui.ImVec2(-1, 390))

		if imgui.Button(u8("Сохранить"), imgui.ImVec2(-1, 25)) then
			io.open("moonloader\\config\\" .. cfg.config.shpname4 .. ".json", "w+"):write(note_tshp4.v):close()
			sampAddChatMessage(tag .. "Вы успешно сохранили текст", -1)

			note_wshp4.v = false
		end

		imgui.End()
	end

	if note_wshp5.v then
		imgui.ShowCursor = true

		local var_68_10, var_68_11 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_10 / 2, var_68_11 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(var_68_10 / 2, var_68_11 / 2), imgui.Cond.FirstUseEver)
		imgui.Begin("Note", note_wshp5, imgui.WindowFlags.NoResize)
		imgui.InputTextMultiline(u8("##"), note_tshp5, imgui.ImVec2(-1, 390))

		if imgui.Button(u8("Сохранить"), imgui.ImVec2(-1, 25)) then
			io.open("moonloader\\config\\" .. cfg.config.shpname5 .. ".json", "w+"):write(note_tshp5.v):close()
			sampAddChatMessage(tag .. "Вы успешно сохранили текст", -1)

			note_wshp5.v = false
		end

		imgui.End()
	end

	if memba.v then
		_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

		local var_68_12 = sampGetPlayerNickname(myid)
		local var_68_13 = u8(" Настройки")
		local var_68_14 = u8(" Поиск игроков")
		local var_68_15 = u8(" В зоне стрима")
		local var_68_16 = imgui.CalcTextSize(var_68_13)
		local var_68_17 = imgui.CalcTextSize(var_68_14)
		local var_68_18 = imgui.CalcTextSize(var_68_15)
		local var_68_19 = 4
		local var_68_20 = convertGameScreenCoordsToWindowScreenCoords
		local var_68_21 = imgui.GetItemRectSize()
		local var_68_22 = u8(sampGetCurrentServerName())
		local var_68_23, var_68_24 = getScreenResolution()

		x, y = var_68_20(160, 90)
		w, h = var_68_20(480, 300)

		imgui.SetNextWindowSize(imgui.ImVec2(w - x, h - y))
		imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(var_68_22, memba, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar)
		imgui.AlignTextToFramePadding()
		imgui.Indent(4)
		imgui.Text(u8("Всего: %s | Рядом: " .. #var_0_18):format(#var_0_92))
		imgui.SameLine()
		imgui.SameLine(w - x - 155)
		imgui.PushItemWidth(150)
		imgui.PushAllowKeyboardFocus(false)
		imgui.InputText("##search", var_0_48, imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.CharsNoBlank)
		imgui.PopAllowKeyboardFocus()
		imgui.PopItemWidth()

		if not imgui.IsItemActive() and #var_0_48.v == 0 then
			imgui.SameLine(w - x - 153)
			imgui.Text(var_68_14)
		end

		imgui.Columns(7, _)
		imgui.SetColumnWidth(-1, 32)
		imgui.Text("ID")
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 165)
		imgui.Text(u8("Никнейм"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 130)
		imgui.Text(u8("Должность"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 80)
		imgui.Text(u8("Статус"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 120)
		imgui.Text(u8("Дата приема"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 70)
		imgui.Text(u8("AFK"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 75)
		imgui.Text(var_0_34.ICON_FA_EYE)
		imgui.NextColumn()
		imgui.Separator()

		for iter_68_0, iter_68_1 in ipairs(var_0_92) do
			if #var_0_48.v > 0 then
				if string.find(sampGetPlayerNickname(iter_68_1.id):lower(), var_0_48.v:lower(), 1, true) or iter_68_1.id == tonumber(var_0_48.v) then
					imgui.Text(iter_68_1.id)
					imgui.NextColumn()
					imgui.TextColored(imgui.ImVec4(getColor(iter_68_1.id)), u8("%s"):format(iter_68_1.nickname))

					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(450)
						imgui.TextColored(imgui.ImVec4(getColor(iter_68_1.id)), u8("%s\nУровень: %s"):format(iter_68_1.nickname, sampGetPlayerScore(iter_68_1.id)))
						imgui.TextWrapped(u8("Нажмите ПКМ для доп.информации"))
						imgui.PopTextWrapPos()
						imgui.EndTooltip()

						if imgui.IsMouseClicked(1) then
							imgui.OpenPopup(iter_68_1.id)

							popa = true
						end
					end

					if imgui.BeginPopup(iter_68_1.id) then
						if imgui.Selectable(u8("Написать SMS")) then
							sampSetChatInputText("/t " .. iter_68_1.id .. " ")
							sampSetChatInputEnabled(true)

							popa = false
						end

						if imgui.Selectable(u8("Узнать номер телефона")) then
							sampSendChat("/number " .. iter_68_1.id)

							popa = false
						end

						imgui.EndPopup()
					end

					imgui.NextColumn()
					imgui.Text(("%s [%s]"):format(iter_68_1.sRang, iter_68_1.iRang))
					imgui.NextColumn()

					if iter_68_1.status ~= u8("На работе") then
						imgui.TextColored(imgui.ImVec4(0.8, 0, 0, 1), iter_68_1.status)
					else
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), iter_68_1.status)
					end

					imgui.NextColumn()
					imgui.Text(iter_68_1.invite)
					imgui.NextColumn()

					if iter_68_1.sec ~= 0 then
						if iter_68_1.sec < 360 then
							imgui.TextColored(getColorForSeconds(iter_68_1.sec), tostring(iter_68_1.sec .. u8(" сек.")))
						else
							imgui.TextColored(getColorForSeconds(iter_68_1.sec), tostring("360+" .. u8(" сек.")))
						end
					else
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Нет"))
					end

					imgui.NextColumn()

					local var_68_25, var_68_26 = sampGetCharHandleBySampPlayerId(iter_68_1.id)

					if var_68_12 == iter_68_1.nickname then
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Вы"))
						imgui.SameLine(34)
					elseif var_68_25 then
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Да"))
						imgui.SameLine(34)
					else
						imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8("Нет"))
						imgui.SameLine()
					end

					imgui.NextColumn()
				end
			else
				imgui.Text(iter_68_1.id)
				imgui.NextColumn()
				imgui.TextColored(imgui.ImVec4(getColor(iter_68_1.id)), u8("%s"):format(iter_68_1.nickname))

				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(450)
					imgui.TextColored(imgui.ImVec4(getColor(iter_68_1.id)), u8("%s\nУровень: %s"):format(iter_68_1.nickname, sampGetPlayerScore(iter_68_1.id)))
					imgui.TextWrapped(u8("Нажмите ПКМ для доп.информации"))
					imgui.PopTextWrapPos()
					imgui.EndTooltip()

					if imgui.IsMouseClicked(1) then
						imgui.OpenPopup(iter_68_1.id)

						popa = true
					end
				end

				if imgui.BeginPopup(iter_68_1.id) then
					if imgui.Selectable(u8("Написать SMS")) then
						sampSetChatInputText("/t " .. iter_68_1.id .. " ")
						sampSetChatInputEnabled(true)

						popa = false
					end

					if imgui.Selectable(u8("Узнать номер телефона")) then
						sampSendChat("/number " .. iter_68_1.id)

						popa = false
					end

					imgui.EndPopup()
				end

				if false then
					-- block empty
				end

				imgui.NextColumn()
				imgui.Text(("%s [%s]"):format(iter_68_1.sRang, iter_68_1.iRang))
				imgui.NextColumn()

				if iter_68_1.status ~= u8("На работе") then
					imgui.TextColored(imgui.ImVec4(0.8, 0, 0, 1), iter_68_1.status)
				else
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), iter_68_1.status)
				end

				imgui.NextColumn()
				imgui.Text(iter_68_1.invite)
				imgui.NextColumn()

				if iter_68_1.sec ~= 0 then
					if iter_68_1.sec < 360 then
						imgui.TextColored(getColorForSeconds(iter_68_1.sec), tostring(iter_68_1.sec .. u8(" сек.")))
					else
						imgui.TextColored(getColorForSeconds(iter_68_1.sec), tostring("360+" .. u8(" сек.")))
					end
				else
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Нет"))
				end

				imgui.NextColumn()

				local var_68_27, var_68_28 = sampGetCharHandleBySampPlayerId(iter_68_1.id)

				if var_68_12 == iter_68_1.nickname then
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Вы"))
					imgui.SameLine(34)
				elseif var_68_27 then
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Да"))
					imgui.SameLine(34)
				else
					imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8("Нет"))
					imgui.SameLine()
				end

				imgui.NextColumn()
			end
		end

		imgui.End()
	end

	allOnline = get_clock(cfg.onDay.online)

	if sampIsDialogActive() == false then
		bp1 = false
		bp = false
	end

	if menu.v or ATSC.imegaf.v or messeng.v or ATSC.settings.v or commandsa.v or log.v or window.v or bMainWindow.v or var_0_56.v or var_0_66.v or var_0_67.v or shpwindow.v or note_wshp0.v or note_wshp1.v or note_wshp2.v or note_wshp3.v or note_wshp4.v or note_wshp5.v or memba.v then
		imgui.ShowCursor = true
	else
		imgui.ShowCursor = false
	end

	if window.v then
		imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(609, 328), imgui.Cond.FirstUseEver)
		imgui.Begin(tagimgui .. u8("Библиотека скриптов"), window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.CentrText(u8("Ниже представлен список скриптов от автора данного скрипта."))
		imgui.Columns(6, _)
		imgui.SetColumnWidth(-1, 100)
		imgui.Text(u8("Название"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 80)
		imgui.Text(u8("Версия"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 120)
		imgui.Text(u8("Описание"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 100)
		imgui.Text(u8("Статус"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 120)
		imgui.Text(u8("Дата обновления"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 80)
		imgui.Text(u8("Установка"))
		imgui.NextColumn()
		imgui.Separator()
		imgui.TextColoredRGB("{FF0000}ATSC{FFFFFF}")
		imgui.TextColoredRGB("{6934fa}ERP-L{FFFFFF}")
		imgui.TextColoredRGB("{FF0000}AlzChecker{FFFFFF}")
		imgui.NextColumn()
		imgui.Text(updateversion)
		imgui.NextColumn()
		imgui.Opis("{FF0000}ATSC{FFFFFF} — Сборник большинства скриптов предоставленных ниже. \nТак же является неким аналогом тулсов для гос.структур.")
		imgui.Opis("{6934fa}ERP-L{FFFFFF} — Автоматический вход на сервер, \nс заранее сохраненными данными. [Локально]")
		imgui.Opis("{FF0000}AlzChecker{FFFFFF} — Чекер игроков. Показывает, в игре человек или нет. \nТак же, расстояние до него если он в зоне прорисовки.")
		imgui.NextColumn()
		imgui.TextColoredRGB("Поддержка")
		imgui.TextColoredRGB("Завершен")
		imgui.TextColoredRGB("Завершен")
		imgui.NextColumn()
		imgui.Text("06/06/23")
		imgui.Text("?")
		imgui.Text("?")
		imgui.NextColumn()
		imgui.Link("", u8("Скачать"))
		imgui.Link("", u8("Скачать"))
		imgui.Link("", u8("Скачать"))
		imgui.Separator()
		imgui.End()
	end

	if menu.v then
		local var_68_29, var_68_30 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_29 / 2, var_68_30 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(200, 255), imgui.Cond.FirstUseEver)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3, Anim))
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cfg.config.colorVec4Button1, cfg.config.colorVec4Button2, cfg.config.colorVec4Button3, Anim + 0.1))
		imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3, Anim + 0.1))
		imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3, Anim + 0.1))
		imgui.Begin(tagimgui .. u8("Main"), menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
		imgui.Spacing()

		if imgui.Button(var_0_34.ICON_FA_COGS .. u8(" Настройки скрипта"), imgui.ImVec2(-1, 22)) then
			settings2()
		end

		if imgui.Button(var_0_34.ICON_FA_LIST .. u8(" Команды скрипта"), imgui.ImVec2(-1, 22)) then
			commands2()
		end

		if imgui.Button(var_0_34.ICON_FA_BUG .. u8(" Мессенджер [TEST]"), imgui.ImVec2(-1, 22)) then
			msg()
		end

		if imgui.Button(var_0_34.ICON_FA_BOOKMARK .. u8(" Биндер "), imgui.ImVec2(-1, 22)) then
			bindmenu2()
		end

		if imgui.Button(var_0_34.ICON_FA_BOOK .. u8(" Командный биндер "), imgui.ImVec2(-1, 22)) then
			bindmenu3()
		end

		if imgui.Button(var_0_34.ICON_FA_BOOK .. u8(" Шпора"), imgui.ImVec2(-1, 22)) then
			fshp()
		end

		if imgui.Button(var_0_34.ICON_FA_EYE_SLASH .. u8(" Онлайн"), imgui.ImVec2(-1, 22)) then
			myonline2()
		end

		imgui.CentrTextDisabled("Version " .. script.this.version)
		imgui.End()
		imgui.PopStyleColor(4)
	end

	if ATSC.settings.v then
		local var_68_31, var_68_32 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_31 / 2, var_68_32 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(400, 225), imgui.Cond.FirstUseEver + imgui.WindowFlags.AlwaysAutoResize)
		imgui.Begin(tagimgui .. u8("settings"), ATSC.settings, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)

		for iter_68_2, iter_68_3 in ipairs(navigation2.list2) do
			if HeaderButton(navigation2.current2 == iter_68_2, iter_68_3) then
				navigation2.current2 = iter_68_2
			end

			if iter_68_2 ~= #navigation2.list2 then
				imgui.SameLine(nil, 30)
			end
		end

		if navigation2.current2 == 3 then
			imgui.SameLine(370)

			if imgui.Checkbox("", bindM) then
				cfg.config.bindM = bindM.v

				var_0_4.save(cfg, var_0_24)
			end

			if imgui.IsItemHovered() then
				imgui.BeginTooltip()
				imgui.PushTextWrapPos(450)
				imgui.TextColoredRGB("Отобразить бинды из меню '{ff0000}Биндер{ffffff}'")
				imgui.PopTextWrapPos()
				imgui.EndTooltip()
			end
		end

		imgui.Spacing()

		if navigation2.current2 == 1 then
			imgui.Text(u8("Автологин"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##autologin"), autologin) then
				cfg.config.autologin = autologin.v

				var_0_4.save(cfg, var_0_24)
			end

			if cfg.config.autologin then
				imgui.Text(u8("Пароль:"))
				imgui.SameLine()

				if imgui.InputText(u8("##34"), var_0_46, imgui.InputTextFlags.Password) then
					cfg.config.password = u8:decode(var_0_46.v)

					var_0_4.save(cfg, var_0_24)
				end

				imgui.SameLine()
				imgui.TextDisabled("(?)")

				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(450)
					imgui.Text(u8("Пароль сохраняется на вашем компьютере\nАвтор скрипта его не узнает."))
					imgui.TextColoredRGB("{ff0000}Нажмите чтобы узнать пароль")
					imgui.PopTextWrapPos()
					imgui.EndTooltip()

					if imgui.IsMouseClicked(0) then
						sampAddChatMessage(tag .. "Ваш пароль: {ff0000}" .. cfg.config.password, -1)
					end
				end
			end

			imgui.Text(u8("Оповещение о выходе игрока"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##quitm"), quitm) then
				cfg.config.quitm = quitm.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Модифицированный /id"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##id1"), id1) then
				cfg.config.id1 = id1.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Женские отыгровки"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##women"), women) then
				cfg.config.women = women.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Бесконечный бег"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##oblaka"), oblaka) then
				cfg.config.oblaka = oblaka.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Авто-питание рыбой"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##afish"), afish) then
				cfg.config.afish = afish.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Голос из под маски"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##maskRP"), maskRP) then
				cfg.config.maskRP = maskRP.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Расширенный /pay"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##rpay"), rpay) then
				cfg.config.rpay = rpay.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Отображение HP/Armor цели"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##pricel"), pricel) then
				cfg.config.pricel = pricel.v

				var_0_4.save(cfg, var_0_24)
			end

			if pricel.v then
				imgui.Text(u8("Полный"))
				imgui.SameLine(360)

				if imgui.RadioButton(u8("##max"), var_0_41, 1) then
					cfg.config.hud = 1

					var_0_4.save(cfg, var_0_24)
				end

				imgui.Text(u8("Минимализм"))

				if cfg.config.hud == 2 then
					imgui.SameLine()

					if imgui.Button(u8("Изменить местоположение")) then
						positionH()
					end
				end

				imgui.SameLine(360)

				if imgui.RadioButton(u8("##min"), var_0_41, 2) then
					cfg.config.hud = 2

					var_0_4.save(cfg, var_0_24)
				end
			end

			imgui.Text(u8("Автоматически заводить автомобиль"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##car2"), car2) then
				cfg.config.car2 = car2.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Инфобар"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##infb"), infb) then
				cfg.config.infb = infb.v

				var_0_4.save(cfg, var_0_24)
			end

			if cfg.config.infb then
				imgui.Text(u8("Вертикальный инфобар"))
				imgui.SameLine(360)

				if imgui.RadioButton(u8("##vertical"), var_0_40, 2) then
					cfg.config.infobar = 2

					var_0_4.save(cfg, var_0_24)
				end

				if infb.v then
					if cfg.config.infobar == 2 then
						imgui.SameLine(150)

						if imgui.Button(u8("Изменить местоположение")) then
							ATSC.settings.v = false

							position()
							sampAddChatMessage(tag .. "По завешению нажмите левую кнопку мыши", -1)
						end

						imgui.SameLine()
						imgui.Button(var_0_34.ICON_FA_COG)

						if imgui.IsItemHovered() and imgui.IsMouseClicked(0) then
							imgui.OpenPopup("1")
						end
					end

					if imgui.BeginPopup("1") then
						checkinfo = true

						if checkinfo then
							if imgui.Checkbox("##0", zero) then
								cfg.config.zero = zero.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Шапка"))
							imgui.Spacing()

							if imgui.Checkbox("##1", one) then
								cfg.config.one = one.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Никнейм"))
							imgui.Spacing()

							if imgui.Checkbox("##2", two) then
								cfg.config.two = two.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Пинг/FPS"))
							imgui.Spacing()

							if imgui.Checkbox("##3", three) then
								cfg.config.three = three.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Здоровье"))
							imgui.Spacing()

							if imgui.Checkbox("##4", four) then
								cfg.config.four = four.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Броня"))
							imgui.Spacing()

							if imgui.Checkbox("##5", five) then
								cfg.config.five = five.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Выносливость"))
							imgui.Spacing()

							if imgui.Checkbox("##6", six) then
								cfg.config.six = six.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Оружие"))
							imgui.Spacing()

							if imgui.Checkbox("##7", seven) then
								cfg.config.seven = seven.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Скорость"))
							imgui.Spacing()

							if imgui.Checkbox("##8", eight) then
								cfg.config.eight = eight.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Цель"))
							imgui.Spacing()

							if imgui.Checkbox("##9", nine) then
								cfg.config.nine = nine.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Район | Квадрат"))
							imgui.Spacing()

							if imgui.Checkbox("##10", ten) then
								cfg.config.ten = ten.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Направление"))
							imgui.Spacing()

							if imgui.Checkbox("##11", eleven) then
								cfg.config.eleven = eleven.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Дата"))
							imgui.Spacing()

							if imgui.Checkbox("##12", twelve) then
								cfg.config.twelve = twelve.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("КД Департамент"))
							imgui.Spacing()

							if imgui.Checkbox("##13", thirteen) then
								cfg.config.thirteen = thirteen.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("КД Ффикскар"))
							imgui.Spacing()

							if imgui.Checkbox("##14", fourteen) then
								cfg.config.fourteen = fourteen.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("КД Маска"))
							imgui.Spacing()

							if imgui.Checkbox(u8("##kraska"), var_0_42) then
								cfg.config.kraska = var_0_42.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()
							imgui.Text(u8("Основные цвета"))
							imgui.Spacing()
						end

						if checkinfo then
							if imgui.SliderFloat("##x ", var_0_43, 50, 500, u8("Высота %1.f")) then
								cfg.config.infY = var_0_43.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()

							if imgui.Button("##f") then
								var_0_43.v = 335
								cfg.config.infY = 335

								var_0_4.save(cfg, var_0_24)
							end
						end

						if checkinfo then
							if imgui.SliderFloat("##a ", var_0_44, 50, 500, u8("Ширина %1.f")) then
								cfg.config.infX = var_0_44.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()

							if imgui.Button("##j") then
								var_0_44.v = 200
								cfg.config.infX = 200

								var_0_4.save(cfg, var_0_24)
							end
						end

						if checkinfo then
							if imgui.SliderFloat("##b ", var_0_45, 0, 1, u8("Прозрачность %0.3")) then
								cfg.config.infP = var_0_45.v

								var_0_4.save(cfg, var_0_24)
							end

							imgui.SameLine()

							if imgui.Button("##k") then
								var_0_45.v = 0.7
								cfg.config.infP = 0.7

								var_0_4.save(cfg, var_0_24)
							end
						end

						if imgui.Selectable(u8("Закрыть настройки")) then
							checkinfo = false

							var_0_4.save(cfg, var_0_24)
						end

						if imgui.EndPopup() then
							checkinfo = false

							var_0_4.save(cfg, var_0_24)
						end
					end
				end

				imgui.Text(u8("Горизонтальный инфобар"))

				if cfg.config.infobar == 1 then
					imgui.SameLine()

					if imgui.Button(u8("Положение КД")) then
						positionKD()
						lua_thread.create(function()
							local var_69_0 = os.clock()

							while os.clock() - var_69_0 < 20 do
								wait(0)

								timedep = 20 - (os.clock() - var_69_0)
								timemask = 20 - (os.clock() - var_69_0)
								timeffix = 20 - (os.clock() - var_69_0)
								timedsup = 20 - (os.clock() - var_69_0)
							end
						end)
					end

					imgui.SameLine(340)

					if imgui.Checkbox(u8("##kraska"), var_0_42) then
						cfg.config.kraska = var_0_42.v

						var_0_4.save(cfg, var_0_24)
					end
				end

				imgui.SameLine(360)

				if imgui.RadioButton(u8("##horizontal"), var_0_40, 1) then
					cfg.config.infobar = 1

					var_0_4.save(cfg, var_0_24)
				end
			end

			imgui.Text(u8("Открывать чат на Т"))
			imgui.SameLine(350)
			imgui.PushItemWidth(170)

			if var_0_32.ToggleButton(u8("Чат на Т"), chatT) then
				cfg.config.chatT = chatT.v

				var_0_4.save(cfg, var_0_24)
			end
		elseif navigation2.current2 == 2 then
			imgui.Text(u8("Тег в рации"))
			imgui.SameLine(110)
			imgui.PushItemWidth(170)

			if cfg.config.TAG5 then
				if imgui.InputText("##tag4", var_0_47) then
					cfg.config.tag4 = u8:decode(var_0_47.v)

					var_0_4.save(cfg, var_0_24)
				end

				imgui.SameLine()

				if imgui.Checkbox("", rtagkv) then
					cfg.config.rtagkv = rtagkv.v

					var_0_4.save(cfg, var_0_24)
				end

				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.TextUnformatted(u8("Квадратные скобки в рации\nПример: [" .. cfg.config.tag4 .. "]"))
					imgui.EndTooltip()
				end
			end

			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##TAG5"), TAG5) then
				cfg.config.TAG5 = TAG5.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Авто-клист:"))
			imgui.SameLine(110)
			imgui.PushItemWidth(170)

			if cfg.config.CL2 and imgui.SliderFloat(" ", cl, 1, 33, u8("Клист %1.f")) then
				cfg.config.cl = cl.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##CL2"), CL2) then
				cfg.config.CL2 = CL2.v

				var_0_4.save(cfg, var_0_24)
			end

			if AF then
				imgui.Text(u8("Быстрая выдача розыска"))
				imgui.SameLine(350)
				imgui.PushItemWidth(170)

				if var_0_32.ToggleButton(u8("Выдача розыска"), fastsu) then
					cfg.config.fastsu = fastsu.v

					var_0_4.save(cfg, var_0_24)
				end

				imgui.Text(u8("Расширенный мегафон"))
				imgui.SameLine(350)
				imgui.PushItemWidth(170)

				if var_0_32.ToggleButton(u8("мегафон"), megaf2) then
					cfg.config.megaf2 = megaf2.v

					var_0_4.save(cfg, var_0_24)
				end

				imgui.Text(u8("Авто БП"))

				if cfg.config.autobp then
					imgui.SameLine(320)
					imgui.Button(var_0_34.ICON_FA_COG)

					if imgui.IsItemHovered() and imgui.IsMouseClicked(0) then
						imgui.OpenPopup("2")
					end

					if imgui.BeginPopup("2") then
						if imgui.Checkbox("##deagle", deagle) then
							cfg.config.deagle = deagle.v

							var_0_4.save(cfg, var_0_24)
						end

						imgui.SameLine(50)
						imgui.Text(u8("Deagle"))

						if imgui.Checkbox("##shotgun", shotgun) then
							cfg.config.shotgun = shotgun.v

							var_0_4.save(cfg, var_0_24)
						end

						imgui.SameLine(50)
						imgui.Text(u8("Shotgun"))

						if imgui.Checkbox("##mp5", mp5) then
							cfg.config.mp5 = mp5.v

							var_0_4.save(cfg, var_0_24)
						end

						imgui.SameLine(50)
						imgui.Text(u8("Mp5"))

						if imgui.Checkbox("##m4", m4) then
							cfg.config.m4 = m4.v

							var_0_4.save(cfg, var_0_24)
						end

						imgui.SameLine(50)
						imgui.Text(u8("M4"))

						if imgui.Checkbox("##rifle", rifle) then
							cfg.config.rifle = rifle.v

							var_0_4.save(cfg, var_0_24)
						end

						imgui.SameLine(50)
						imgui.Text(u8("Rifle"))
						imgui.Spacing()

						if imgui.Selectable(u8("Закрыть настройки")) then
							var_0_4.save(cfg, var_0_24)
							imgui.CloseCurrentPopup()
						end

						imgui.EndPopup()
					end
				end

				imgui.SameLine(350)

				if var_0_32.ToggleButton(u8("##autobp"), autobp) then
					cfg.config.autobp = autobp.v

					var_0_4.save(cfg, var_0_24)
				end

				imgui.Text(u8("Кнопка 'Взять всё вооружение'"))
				imgui.SameLine(350)

				if var_0_32.ToggleButton(u8("##buttV"), buttV) then
					cfg.config.buttV = buttV.v

					var_0_4.save(cfg, var_0_24)
				end
			end

			imgui.Text(u8("Модифицированная рация"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##radmod"), radmod) then
				cfg.config.radmod = radmod.v

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Модифицированный мемберс"))
			imgui.SameLine(350)

			if var_0_32.ToggleButton(u8("##membmod"), membmod) then
				cfg.config.membmod = membmod.v

				var_0_4.save(cfg, var_0_24)
			end
		elseif navigation2.current2 == 3 then
			imgui.Text(u8("Кнопка вызова меню"))
			imgui.SameLine(300)

			if imgui.HotKey("##scm2", scm2, var_0_15, 80) then
				var_0_22.changeHotKey(bindSCM, scm2.v)

				cfg.hotkey.bindSCM = encodeJson(scm2.v)

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Кнопка вызова ATSC Messenger"))
			imgui.SameLine(300)

			if imgui.HotKey("##msg2", msg2, var_0_15, 80) then
				var_0_22.changeHotKey(bindMSG, msg2.v)

				cfg.hotkey.bindMSG = encodeJson(msg2.v)

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Открыть машину"))
			imgui.SameLine(300)

			if imgui.HotKey("##lock", Lock, var_0_15, 80) then
				var_0_22.changeHotKey(bindLock, Lock.v)

				cfg.hotkey.bindLock = encodeJson(Lock.v)

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Надеть маску"))
			imgui.SameLine(300)

			if imgui.HotKey("##mask", Mask, var_0_15, 80) then
				var_0_22.changeHotKey(bindMask, Mask.v)

				cfg.hotkey.bindMask = encodeJson(Mask.v)

				var_0_4.save(cfg, var_0_24)
			end

			imgui.Text(u8("Перезагрузить скрипт ATSC"))
			imgui.SameLine(300)

			if imgui.HotKey("##RATSC", RATSC, var_0_15, 80) then
				var_0_22.changeHotKey(bindRATSC, RATSC.v)

				cfg.hotkey.bindRATSC = encodeJson(RATSC.v)

				var_0_4.save(cfg, var_0_24)
			end

			if AF then
				imgui.Text(u8("Расширенное управление преступником"))
				imgui.SameLine(260)
				imgui.Text(u8("ПКМ +"))
				imgui.SameLine(300)

				if imgui.HotKey("##Zkey2", Zkey2, var_0_15, 80) then
					var_0_22.changeHotKey(bindZkey, Zkey2.v)

					cfg.hotkey.bindZkey = encodeJson(Zkey2.v)

					var_0_4.save(cfg, var_0_24)
				end

				imgui.Text(u8("Мегафон"))
				imgui.SameLine(300)

				if imgui.HotKey("##megaf22", megaf22, var_0_15, 80) then
					var_0_22.changeHotKey(bindMegaf, megaf22.v)

					cfg.hotkey.bindMegaf = encodeJson(megaf22.v)

					var_0_4.save(cfg, var_0_24)
				end

				imgui.Text(u8("Тазер"))
				imgui.SameLine(300)

				if imgui.HotKey("##tazer2", tazer2, var_0_15, 80) then
					var_0_22.changeHotKey(bindTazer, tazer2.v)

					cfg.hotkey.bindTazer = encodeJson(tazer2.v)

					var_0_4.save(cfg, var_0_24)
				end
			end

			if cfg.config.bindM then
				for iter_68_4, iter_68_5 in ipairs(tBindList) do
					imgui.Text(u8(iter_68_5.name))
					imgui.SameLine(300)

					if var_0_32.HotKey("##HK" .. iter_68_4, iter_68_5, var_0_15, 80) then
						if not var_0_22.isHotKeyDefined(iter_68_5.v) then
							if var_0_22.isHotKeyDefined(var_0_15.v) then
								var_0_22.unRegisterHotKey(var_0_15.v)
							end

							var_0_22.registerHotKey(iter_68_5.v, true, onHotKey)
						end

						saveData(tBindList, var_0_13)
					end
				end
			end
		elseif navigation2.current2 == 4 then
			imgui.Spacing()

			if imgui.ColorEdit3(u8("Титул"), var_0_35) then
				local var_68_33 = join_argb(0, var_0_35.v[1] * 255, var_0_35.v[2] * 255, var_0_35.v[3] * 255)

				print(("%06X"):format(var_68_33))

				cfg.config.colorVec4Title1 = var_0_35.v[1]
				cfg.config.colorVec4Title2 = var_0_35.v[2]
				cfg.config.colorVec4Title3 = var_0_35.v[3]

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			imgui.SameLine(280)

			if imgui.Button(u8("По умолчанию##2")) then
				cfg.config.colorVec4Title1 = 0.19
				cfg.config.colorVec4Title2 = 0.22
				cfg.config.colorVec4Title3 = 0.26
				var_0_35 = imgui.ImFloat3(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3)

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			if imgui.ColorEdit3(u8("Фон"), var_0_36) then
				local var_68_34 = join_argb(0, var_0_36.v[1] * 255, var_0_36.v[2] * 255, var_0_36.v[3] * 255)

				print(("%06X"):format(var_68_34))

				cfg.config.colorVec4Fon1 = var_0_36.v[1]
				cfg.config.colorVec4Fon2 = var_0_36.v[2]
				cfg.config.colorVec4Fon3 = var_0_36.v[3]

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			imgui.SameLine(280)

			if imgui.Button(u8("По умолчанию##1")) then
				cfg.config.colorVec4Fon1 = 0.16
				cfg.config.colorVec4Fon2 = 0.18
				cfg.config.colorVec4Fon3 = 0.22
				var_0_36 = imgui.ImFloat3(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3)

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			if imgui.SliderFloat("##22", FonP, 0, 1, u8("Прозрачность Фона %0.3")) then
				cfg.config.FonP = FonP.v

				GreyTheme()
				var_0_4.save(cfg, var_0_24)
			end

			imgui.SameLine(280)

			if imgui.Button(u8("По умолчанию##8")) then
				cfg.config.FonP = 1
				FonP.v = cfg.config.FonP

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			if imgui.ColorEdit3(u8("Кнопки"), var_0_37) then
				local var_68_35 = join_argb(0, var_0_37.v[1] * 255, var_0_37.v[2] * 255, var_0_37.v[3] * 255)

				print(("%06X"):format(var_68_35))

				cfg.config.colorVec4Button1 = var_0_37.v[1]
				cfg.config.colorVec4Button2 = var_0_37.v[2]
				cfg.config.colorVec4Button3 = var_0_37.v[3]

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			imgui.SameLine(280)

			if imgui.Button(u8("По умолчанию##3")) then
				cfg.config.colorVec4Button1 = 0.41
				cfg.config.colorVec4Button2 = 0.55
				cfg.config.colorVec4Button3 = 0.89
				var_0_37 = imgui.ImFloat3(cfg.config.colorVec4Button1, cfg.config.colorVec4Button2, cfg.config.colorVec4Button3)

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			if imgui.ColorEdit3(u8("Поля"), var_0_38) then
				local var_68_36 = join_argb(0, var_0_38.v[1] * 255, var_0_38.v[2] * 255, var_0_38.v[3] * 255)

				print(("%06X"):format(var_68_36))

				cfg.config.colorVec4Pole1 = var_0_38.v[1]
				cfg.config.colorVec4Pole2 = var_0_38.v[2]
				cfg.config.colorVec4Pole3 = var_0_38.v[3]

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			imgui.SameLine(280)

			if imgui.Button(u8("По умолчанию##4")) then
				cfg.config.colorVec4Pole1 = 0.19
				cfg.config.colorVec4Pole2 = 0.22
				cfg.config.colorVec4Pole3 = 0.26
				var_0_38 = imgui.ImFloat3(cfg.config.colorVec4Pole1, cfg.config.colorVec4Pole2, cfg.config.colorVec4Pole3)

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			if imgui.ColorEdit3(u8("Текст"), var_0_39) then
				local var_68_37 = join_argb(0, var_0_39.v[1] * 255, var_0_39.v[2] * 255, var_0_39.v[3] * 255)

				print(("%06X"):format(var_68_37))

				cfg.config.colorVec4Text1 = var_0_39.v[1]
				cfg.config.colorVec4Text2 = var_0_39.v[2]
				cfg.config.colorVec4Text3 = var_0_39.v[3]

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end

			imgui.SameLine(280)

			if imgui.Button(u8("По умолчанию##5")) then
				cfg.config.colorVec4Text1 = 1
				cfg.config.colorVec4Text2 = 1
				cfg.config.colorVec4Text3 = 1
				var_0_39 = imgui.ImFloat3(cfg.config.colorVec4Text1, cfg.config.colorVec4Text2, cfg.config.colorVec4Text3)

				var_0_4.save(cfg, var_0_24)
				GreyTheme()
			end
		end

		if navigation2.current2 == 4 then
			imgui.CentrTextDisabled(u8("Нажмите на цветной квадрат"))
			imgui.CentrTextDisabled(u8("Для того чтобы открыть палитру"))
			imgui.Spacing()
		end

		imgui.Spacing()
		imgui.SameLine(175)

		if imgui.Button(u8("Меню")) then
			scm()
		end

		imgui.SameLine(250)
		imgui.TextDisabled("Version " .. script.this.version)
		imgui.End()
	end

	if shpwindow.v then
		if changelog then
			local var_68_38, var_68_39 = getScreenResolution()

			imgui.SetNextWindowPos(imgui.ImVec2(var_68_38 / 2, var_68_39 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(var_68_38 / 2, var_68_39 / 2), imgui.Cond.FirstUseEver)
			imgui.Begin(tagimgui .. u8("UPDATES"), shpwindow)
			imgui.TextWrapped(RESP_TEXT)
		else
			local var_68_40, var_68_41 = getScreenResolution()

			imgui.SetNextWindowPos(imgui.ImVec2(var_68_40 / 2, var_68_41 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(var_68_40 / 2, var_68_41 / 2), imgui.Cond.FirstUseEver)
			imgui.Begin(tagimgui .. u8("Шпора"), shpwindow)
			imgui.PushItemWidth(250)

			if imgui.Combo(u8(""), combo_select, {
				u8(cfg.config.shpname0),
				u8(cfg.config.shpname1),
				u8(cfg.config.shpname2),
				u8(cfg.config.shpname3),
				u8(cfg.config.shpname4),
				u8(cfg.config.shpname5)
			}, 6) then
				if combo_select.v == 0 then
					cfg.config.shpora = 0

					var_0_4.save(cfg, var_0_24)
				end

				if combo_select.v == 1 then
					cfg.config.shpora = 1

					var_0_4.save(cfg, var_0_24)
				end

				if combo_select.v == 2 then
					cfg.config.shpora = 2

					var_0_4.save(cfg, var_0_24)
				end

				if combo_select.v == 3 then
					cfg.config.shpora = 3

					var_0_4.save(cfg, var_0_24)
				end

				if combo_select.v == 4 then
					cfg.config.shpora = 4

					var_0_4.save(cfg, var_0_24)
				end

				if combo_select.v == 5 then
					cfg.config.shpora = 5

					var_0_4.save(cfg, var_0_24)
				end
			end

			imgui.SameLine()

			if cfg.config.shpora == 0 then
				if imgui.Button(u8("Редактировать шпору"), imgui.ImVec2(160, 20)) then
					note_wshp0.v = not note_wshp0.v
				end

				imgui.SameLine()

				if imgui.Button(u8("Редактировать название"), imgui.ImVec2(160, 20)) then
					nameset = true
				end

				if nameset then
					imgui.Spacing()
					imgui.SameLine(273)
					imgui.BetterInput("##0000", u8("Название шпоры"), shpname0, nil, nil, 150)
					imgui.SameLine()

					if imgui.Button(u8("Сохранить"), imgui.ImVec2(160, 20)) then
						cfg.config.shpname0 = u8:decode(shpname0.v)

						var_0_4.save(cfg, var_0_24)

						nameset = false
					end
				end

				imgui.BetterInput("##000", u8("Поиск по " .. cfg.config.shpname0), find, nil, nil, 300)
				imgui.Spacing()

				if doesFileExist("moonloader\\config\\" .. cfg.config.shpname0 .. ".json") then
					for iter_68_6 in io.lines("moonloader\\config\\" .. cfg.config.shpname0 .. ".json") do
						if find.v ~= "" then
							if string.rlower(u8:decode(iter_68_6)):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
								imgui.TextWrapped(iter_68_6)

								if imgui.IsItemClicked(iter_68_6) then
									sampSetChatInputText(u8:decode(iter_68_6))
									sampSetChatInputEnabled(true)
								end
							end
						else
							imgui.TextWrapped(iter_68_6)

							if imgui.IsItemClicked(iter_68_6) then
								sampSetChatInputText(u8:decode(iter_68_6))
								sampSetChatInputEnabled(true)
							end
						end
					end
				else
					imgui.Text(shpHelp)
				end
			elseif cfg.config.shpora == 1 then
				if imgui.Button(u8("Редактировать шпору"), imgui.ImVec2(160, 20)) then
					note_wshp1.v = not note_wshp1.v
				end

				imgui.SameLine()

				if imgui.Button(u8("Редактировать название"), imgui.ImVec2(160, 20)) then
					nameset = true
				end

				if nameset then
					imgui.Spacing()
					imgui.SameLine(273)
					imgui.BetterInput("##111111", u8("Название шпоры"), shpname1, nil, nil, 150)
					imgui.SameLine()

					if imgui.Button(u8("Сохранить"), imgui.ImVec2(160, 20)) then
						cfg.config.shpname1 = u8:decode(shpname1.v)

						var_0_4.save(cfg, var_0_24)

						nameset = false
					end
				end

				imgui.BetterInput("##111", u8("Поиск по " .. cfg.config.shpname1), find, nil, nil, 300)
				imgui.Spacing()

				if doesFileExist("moonloader\\config\\" .. cfg.config.shpname1 .. ".json") then
					for iter_68_7 in io.lines("moonloader\\config\\" .. cfg.config.shpname1 .. ".json") do
						if find.v ~= "" then
							if string.rlower(u8:decode(iter_68_7)):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
								imgui.TextWrapped(iter_68_7)

								if imgui.IsItemClicked(iter_68_7) then
									sampSetChatInputText(u8:decode(iter_68_7))
									sampSetChatInputEnabled(true)
								end
							end
						else
							imgui.TextWrapped(iter_68_7)

							if imgui.IsItemClicked(iter_68_7) then
								sampSetChatInputText(u8:decode(iter_68_7))
								sampSetChatInputEnabled(true)
							end
						end
					end
				else
					imgui.Text(shpHelp)
				end
			elseif cfg.config.shpora == 2 then
				if imgui.Button(u8("Редактировать шпору"), imgui.ImVec2(160, 20)) then
					note_wshp2.v = not note_wshp2.v
				end

				imgui.SameLine()

				if imgui.Button(u8("Редактировать название"), imgui.ImVec2(160, 20)) then
					nameset = true
				end

				if nameset then
					imgui.Spacing()
					imgui.SameLine(273)
					imgui.BetterInput("##2222222", u8("Название шпоры"), shpname2, nil, nil, 150)
					imgui.SameLine()

					if imgui.Button(u8("Сохранить"), imgui.ImVec2(160, 20)) then
						cfg.config.shpname2 = u8:decode(shpname2.v)

						var_0_4.save(cfg, var_0_24)

						nameset = false
					end
				end

				imgui.BetterInput("##222", u8("Поиск по " .. cfg.config.shpname2), find, nil, nil, 300)
				imgui.Spacing()

				if doesFileExist("moonloader\\config\\" .. cfg.config.shpname2 .. ".json") then
					for iter_68_8 in io.lines("moonloader\\config\\" .. cfg.config.shpname2 .. ".json") do
						if find.v ~= "" then
							if string.rlower(u8:decode(iter_68_8)):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
								imgui.TextWrapped(iter_68_8)

								if imgui.IsItemClicked(iter_68_8) then
									sampSetChatInputText(u8:decode(iter_68_8))
									sampSetChatInputEnabled(true)
								end
							end
						else
							imgui.TextWrapped(iter_68_8)

							if imgui.IsItemClicked(iter_68_8) then
								sampSetChatInputText(u8:decode(iter_68_8))
								sampSetChatInputEnabled(true)
							end
						end
					end
				else
					imgui.Text(shpHelp)
				end
			elseif cfg.config.shpora == 3 then
				if imgui.Button(u8("Редактировать шпору"), imgui.ImVec2(160, 20)) then
					note_wshp3.v = not note_wshp3.v
				end

				imgui.SameLine()

				if imgui.Button(u8("Редактировать название"), imgui.ImVec2(160, 20)) then
					nameset = true
				end

				if nameset then
					imgui.Spacing()
					imgui.SameLine(273)
					imgui.BetterInput("##33333333", u8("Название шпоры"), shpname3, nil, nil, 150)
					imgui.SameLine()

					if imgui.Button(u8("Сохранить"), imgui.ImVec2(160, 20)) then
						cfg.config.shpname3 = u8:decode(shpname3.v)

						var_0_4.save(cfg, var_0_24)

						nameset = false
					end
				end

				imgui.BetterInput("##3333", u8("Поиск по " .. cfg.config.shpname3), find, nil, nil, 300)
				imgui.Spacing()

				if doesFileExist("moonloader\\config\\" .. cfg.config.shpname3 .. ".json") then
					for iter_68_9 in io.lines("moonloader\\config\\" .. cfg.config.shpname3 .. ".json") do
						if find.v ~= "" then
							if string.rlower(u8:decode(iter_68_9)):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
								imgui.TextWrapped(iter_68_9)

								if imgui.IsItemClicked(iter_68_9) then
									sampSetChatInputText(u8:decode(iter_68_9))
									sampSetChatInputEnabled(true)
								end
							end
						else
							imgui.TextWrapped(iter_68_9)

							if imgui.IsItemClicked(iter_68_9) then
								sampSetChatInputText(u8:decode(iter_68_9))
								sampSetChatInputEnabled(true)
							end
						end
					end
				else
					imgui.Text(shpHelp)
				end
			elseif cfg.config.shpora == 4 then
				if imgui.Button(u8("Редактировать шпору"), imgui.ImVec2(160, 20)) then
					note_wshp4.v = not note_wshp4.v
				end

				imgui.SameLine()

				if imgui.Button(u8("Редактировать название"), imgui.ImVec2(160, 20)) then
					nameset = true
				end

				if nameset then
					imgui.Spacing()
					imgui.SameLine(273)
					imgui.BetterInput("##44444444", u8("Название шпоры"), shpname4, nil, nil, 150)
					imgui.SameLine()

					if imgui.Button(u8("Сохранить"), imgui.ImVec2(160, 20)) then
						cfg.config.shpname4 = u8:decode(shpname4.v)

						var_0_4.save(cfg, var_0_24)

						nameset = false
					end
				end

				imgui.BetterInput("##444", u8("Поиск по " .. cfg.config.shpname4), find, nil, nil, 300)
				imgui.Spacing()

				if doesFileExist("moonloader\\config\\" .. cfg.config.shpname4 .. ".json") then
					for iter_68_10 in io.lines("moonloader\\config\\" .. cfg.config.shpname4 .. ".json") do
						if find.v ~= "" then
							if string.rlower(u8:decode(iter_68_10)):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
								imgui.TextWrapped(iter_68_10)

								if imgui.IsItemClicked(iter_68_10) then
									sampSetChatInputText(u8:decode(iter_68_10))
									sampSetChatInputEnabled(true)
								end
							end
						else
							imgui.TextWrapped(iter_68_10)

							if imgui.IsItemClicked(iter_68_10) then
								sampSetChatInputText(u8:decode(iter_68_10))
								sampSetChatInputEnabled(true)
							end
						end
					end
				else
					imgui.Text(shpHelp)
				end
			elseif cfg.config.shpora == 5 then
				if imgui.Button(u8("Редактировать шпору"), imgui.ImVec2(160, 20)) then
					note_wshp5.v = not note_wshp5.v
				end

				imgui.SameLine()

				if imgui.Button(u8("Редактировать название"), imgui.ImVec2(160, 20)) then
					nameset = true
				end

				if nameset then
					imgui.Spacing()
					imgui.SameLine(273)
					imgui.BetterInput("##555555", u8("Название шпоры"), shpname5, nil, nil, 150)
					imgui.SameLine()

					if imgui.Button(u8("Сохранить"), imgui.ImVec2(160, 20)) then
						cfg.config.shpname5 = u8:decode(shpname5.v)

						var_0_4.save(cfg, var_0_24)

						nameset = false
					end
				end

				imgui.BetterInput("##555", u8("Поиск по " .. cfg.config.shpname5), find, nil, nil, 300)
				imgui.Spacing()

				if doesFileExist("moonloader\\config\\" .. cfg.config.shpname5 .. ".json") then
					for iter_68_11 in io.lines("moonloader\\config\\" .. cfg.config.shpname5 .. ".json") do
						if find.v ~= "" then
							if string.rlower(u8:decode(iter_68_11)):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
								imgui.TextWrapped(iter_68_11)

								if imgui.IsItemClicked(iter_68_11) then
									sampSetChatInputText(u8:decode(iter_68_11))
									sampSetChatInputEnabled(true)
								end
							end
						else
							imgui.TextWrapped(iter_68_11)

							if imgui.IsItemClicked(iter_68_11) then
								sampSetChatInputText(u8:decode(iter_68_11))
								sampSetChatInputEnabled(true)
							end
						end
					end
				else
					imgui.Text(shpHelp)
				end
			end
		end

		imgui.End()
	else
		changelog = false
	end

	if log.v then
		local var_68_42 = u8("Поиск по логам")

		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.9))

		local var_68_43, var_68_44 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_43 / 2, var_68_44 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.WindowFlags.AlwaysAutoResize)
		imgui.Begin(tagimgui .. u8("Логи"), log, imgui.WindowFlags.NoCollapse)

		for iter_68_12, iter_68_13 in ipairs(navigation.list) do
			if HeaderButton(navigation.current == iter_68_12, iter_68_13) then
				navigation.current = iter_68_12
			end

			if iter_68_12 ~= #navigation.list then
				imgui.SameLine(nil, 30)
			end
		end

		if navigation.current == 1 then
			imgui.BetterInput("##051", var_68_42, find, nil, nil, 150)
			imgui.Spacing()

			for iter_68_14 in table.concat(key5, "\n"):gmatch("[^\n\r]+") do
				if find.v ~= "" then
					if string.rlower(iter_68_14):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
						imgui.TextColoredRGB(iter_68_14)

						if imgui.IsItemClicked() then
							sampSetChatInputText(iter_68_14:gsub("{.+}", ""))
							sampSetChatInputEnabled(true)
						end
					end
				else
					imgui.TextColoredRGB(iter_68_14)

					if imgui.IsItemClicked() then
						sampSetChatInputText(iter_68_14:gsub("{.+}", ""))
						sampSetChatInputEnabled(true)
					end
				end
			end
		end

		if navigation.current == 2 then
			imgui.BetterInput("##052", var_68_42, find, nil, nil, 150)
			imgui.Spacing()

			for iter_68_15 in table.concat(key2, "\n"):gmatch("[^\n\r]+") do
				if find.v ~= "" then
					if string.rlower(iter_68_15):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
						imgui.TextColoredRGB(iter_68_15)

						if imgui.IsItemClicked() then
							sampSetChatInputText(iter_68_15:gsub("{.+}", ""))
							sampSetChatInputEnabled(true)
						end
					end
				else
					imgui.TextColoredRGB(iter_68_15)

					if imgui.IsItemClicked() then
						sampSetChatInputText(iter_68_15:gsub("{.+}", ""))
						sampSetChatInputEnabled(true)
					end
				end
			end
		end

		if navigation.current == 3 then
			imgui.BetterInput("##053", var_68_42, find, nil, nil, 150)
			imgui.Spacing()

			for iter_68_16 in table.concat(key1, "\n"):gmatch("[^\n\r]+") do
				if find.v ~= "" then
					if string.rlower(iter_68_16):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
						imgui.TextColoredRGB(iter_68_16)

						if imgui.IsItemClicked() then
							sampSetChatInputText(iter_68_16:gsub("{.+}", ""))
							sampSetChatInputEnabled(true)
						end
					end
				else
					imgui.TextColoredRGB(iter_68_16)

					if imgui.IsItemClicked() then
						sampSetChatInputText(iter_68_16:gsub("{.+}", ""))
						sampSetChatInputEnabled(true)
					end
				end
			end
		end

		if navigation.current == 4 then
			imgui.BetterInput("##054", var_68_42, find, nil, nil, 150)
			imgui.Spacing()

			for iter_68_17 in table.concat(key4, "\n"):gmatch("[^\n\r]+") do
				if find.v ~= "" then
					if string.rlower(iter_68_17):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
						imgui.TextColoredRGB(iter_68_17)

						if imgui.IsItemClicked() then
							sampSetChatInputText(iter_68_17:gsub("{.+}", ""))
							sampSetChatInputEnabled(true)
						end
					end
				else
					imgui.TextColoredRGB(iter_68_17)

					if imgui.IsItemClicked() then
						sampSetChatInputText(iter_68_17:gsub("{.+}", ""))
						sampSetChatInputEnabled(true)
					end
				end
			end
		end

		if navigation.current == 5 then
			imgui.BetterInput("##055", var_68_42, find, nil, nil, 150)
			imgui.SameLine()

			textL = table.concat(key3, "\n")

			imgui.Spacing()

			for iter_68_18 in textL:gmatch("[^\n\r]+") do
				if find.v ~= "" then
					if string.rlower(iter_68_18):find(string.rlower(u8:decode(find.v)):gsub("%p", "%%%1")) then
						imgui.TextColoredRGB(iter_68_18)

						if imgui.IsItemClicked() then
							sampSetChatInputText(iter_68_18:gsub("{.+}", ""))
							sampSetChatInputEnabled(true)
						end
					end
				else
					imgui.TextColoredRGB(iter_68_18)

					if imgui.IsItemClicked() then
						sampSetChatInputText(iter_68_18:gsub("{.+}", ""))
						sampSetChatInputEnabled(true)
					end
				end
			end
		end

		imgui.Spacing()
		imgui.End()
		imgui.PopStyleColor()
	end

	if var_0_66.v then
		local var_68_45, var_68_46 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_45 / 2, var_68_46 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(305, 251), imgui.Cond.FirstUseEver)
		imgui.Begin(tagimgui .. u8("Онлайн"), var_0_66, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

		_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

		local var_68_47 = sampGetPlayerNickname(myid)

		imgui.Text(u8("Имя: "))
		imgui.SameLine(180)
		imgui.TextColored(imgui.ImVec4(getColor(myid)), u8("%s [%s]"):format(var_68_47, myid))
		imgui.Text(u8("Статус:"))
		imgui.SameLine(220)

		if rabden then
			imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("На работе"))
		else
			imgui.TextColored(imgui.ImVec4(0.8, 0, 0, 1), u8("Выходной"))
		end

		imgui.Spacing()
		imgui.Separator()
		imgui.Text(u8("Отыграно за сегодня: "))
		imgui.SameLine(220)
		imgui.Text(get_clock(cfg.onDay.online))
		imgui.Text(u8("Отыграно на работе: "))
		imgui.SameLine(220)
		imgui.Text(get_clock(cfg.onDay.onlineWork))
		imgui.Text(u8("АФК за день: "))
		imgui.SameLine(220)
		imgui.Text(get_clock(cfg.onDay.afk))
		imgui.Separator()
		imgui.Text(u8("Отыграно за неделю: "))
		imgui.SameLine(220)
		imgui.Text(get_clock(cfg.onWeek.online))
		imgui.Text(u8("Отыграно на работе: "))
		imgui.SameLine(220)
		imgui.Text(get_clock(cfg.onWeek.onlineWork))
		imgui.Text(u8("АФК за неделю: "))
		imgui.SameLine(220)
		imgui.Text(get_clock(cfg.onWeek.afk))
		imgui.Separator()
		imgui.Spacing()

		if imgui.Button(u8("Статистика по дням"), imgui.ImVec2(143, 22)) then
			var_0_67.v = not var_0_67.v
		end

		imgui.SameLine()

		if imgui.Button(u8("Вернуться"), imgui.ImVec2(143, 22)) then
			var_0_66.v = false
			menu.v = true
		end

		imgui.CentrTextDisabled("design by fbi tools")
		imgui.End()
	end

	if var_0_67.v then
		local var_68_48, var_68_49 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_48 / 2, var_68_49 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(-1, -1), imgui.Cond.FirstUseEver)
		imgui.Begin(tagimgui .. u8("Статистика по дням"), var_0_67, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

		for iter_68_19 = 1, 6 do
			imgui.Text(u8(var_0_83[iter_68_19]))
			imgui.SameLine(180)
			imgui.Text(get_clock(cfg.myWeekOnline[iter_68_19]))
		end

		imgui.Text(u8(var_0_83[0]))
		imgui.SameLine(180)
		imgui.Text(get_clock(cfg.myWeekOnline[0]))
		imgui.CentrTextDisabled("design by fbi tools")
		imgui.Spacing()
		imgui.SameLine(100)
		imgui.End()
	end

	if commandsa.v then
		local var_68_50, var_68_51 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_50 / 2, var_68_51 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
		imgui.Begin(tagimgui .. u8("commands"), commandsa, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

		for iter_68_20, iter_68_21 in ipairs(getChatCommands()) do
			if iter_68_21 == "/scm" then
				if imgui.CollapsingHeader(u8("Открыть меню скрипта"), 0) then
					imgui.TextWrapped(u8("Описание: Открывает меню скрипта командой"))
					imgui.TextWrapped(u8("Использование: /scm"))
				end
			elseif iter_68_21 == "/fm" then
				if imgui.CollapsingHeader(u8("Быстро надеть маску"), 0) then
					imgui.TextWrapped(u8("Описание: Крайне быстро надевает маску"))
					imgui.TextWrapped(u8("Использование: /fm"))
				end
			elseif iter_68_21 == "/msg" then
				if imgui.CollapsingHeader(u8("Открыть ATSC Мессенджер"), 0) then
					imgui.TextWrapped(u8("Описание: Мессенджер на основе SMS"))
					imgui.TextWrapped(u8("Использование: /msg"))
				end
			elseif iter_68_21 == "/wb" then
				if imgui.CollapsingHeader(u8("Авто-Снятие названной суммы с банкомата"), 0) then
					imgui.TextWrapped(u8("Описание: Автоматически снимает сумму с банкомата"))
					imgui.TextWrapped(u8("Использование: /wb [сумма]"))
				end
			elseif iter_68_21 == "/db" then
				if imgui.CollapsingHeader(u8("Авто-Пополнение названной суммы на банкомат"), 0) then
					imgui.TextWrapped(u8("Описание: Автоматически пополняет сумму на банкомат"))
					imgui.TextWrapped(u8("Использование: /db [сумма]"))
				end
			elseif iter_68_21 == "/pay" then
				if imgui.CollapsingHeader(u8("Расширенный /pay"), 0) then
					imgui.TextWrapped(string.format("Описание: При включенной настройке, выдает нужное кол-во денег. \nПараметр: %s", cfg.config.rpay and "{63c600}ON" or "{ff0000}OFF"))
					imgui.TextWrapped(u8("Использование: /pay [сумма]"))
				end
			elseif iter_68_21 == "/shpm" then
				if imgui.CollapsingHeader(u8("Открыть меню шпоры"), 0) then
					imgui.TextWrapped(u8("Описание: Открывает меню шпоры"))
					imgui.TextWrapped(u8("Использование: /shpm"))
				end
			elseif iter_68_21 == "/fshp" then
				if imgui.CollapsingHeader(u8("Поиск по шпоре"), 0) then
					imgui.TextWrapped(u8("Описание: Позволяет искать информацию в шпоре по команде"))
					imgui.TextWrapped(u8("Использование: /fshp"))
				end
			elseif iter_68_21 == "/tq" then
				if imgui.CollapsingHeader(u8("Закрыть GTA в указанное время"), 0) then
					imgui.TextWrapped(u8("Описание: Закрывает GTA в указанное время"))
					imgui.TextWrapped(u8("Использование: /tq 12:30"))
				end
			elseif iter_68_21 == "/stime" then
				if imgui.CollapsingHeader(u8("Поставить определенное время"), 0) then
					imgui.TextWrapped(u8("Описание: Ставит игровое время на указанные вами часы"))
					imgui.TextWrapped(u8("Использование: /stime"))
				end
			elseif iter_68_21 == "/sweather" then
				if imgui.CollapsingHeader(u8("Поставить определенную погоду"), 0) then
					imgui.TextWrapped(u8("Описание: Ставит игровую погоду на указанную вами"))
					imgui.TextWrapped(u8("Использование: /sweather"))
				end
			elseif iter_68_21 == "/myon" then
				if imgui.CollapsingHeader(u8("Отобразить в чате сколько вы отработали"), 0) then
					imgui.TextWrapped(u8("Описание: Выводит в чат время которое вы отработали без учёта AFK"))
					imgui.TextWrapped(u8("Использование: /myon"))
				end
			elseif iter_68_21 == "/kv" then
				if imgui.CollapsingHeader(u8("Узнать ваш квадрат/поставить метку на квадрат"), 0) then
					imgui.TextWrapped(u8("Описание: Показывает в чате в каком квадрате вы находитесь и ставит метку на указанный квадрат"))
					imgui.TextWrapped(u8("Использование: /kv | /kv А-2"))
				end
			elseif iter_68_21 == "/kv" and imgui.CollapsingHeader(u8("Узнать ваш квадрат/поставить метку на квадрат"), 0) then
				imgui.TextWrapped(u8("Описание: Показывает в чате в каком квадрате вы находитесь и ставит метку на указанный квадрат"))
				imgui.TextWrapped(u8("Использование: /kv | /kv А-2"))
			end

			if group == "Полиция" or group == "ФБР" then
				if iter_68_21 == "/su" then
					if imgui.CollapsingHeader(u8("Выдать розыск через меню"), 0) then
						imgui.TextWrapped(u8("Описание: Открывает меню с статьями УК, где можно выдать розыск"))
						imgui.TextWrapped(u8("Использование: /su id"))
					end
				elseif iter_68_21 == "/mg" then
					if imgui.CollapsingHeader(u8("Мегафон"), 0) then
						imgui.TextWrapped(u8("Описание: Требует остановиться транспорту"))
						imgui.TextWrapped(u8("Использование: /mg"))
					end
				elseif iter_68_21 == "/ssu" then
					if imgui.CollapsingHeader(u8("Выдать розыск вручную"), 0) then
						imgui.TextWrapped(u8("Описание: Выдать розыск вручную в обход скрипта"))
						imgui.TextWrapped(u8("Использование: /ssu [id] [кол-во звезд] [причина]"))
					end
				elseif iter_68_21 == "/ooplist" then
					if imgui.CollapsingHeader(u8("Открыть лог ООП"), 0) then
						imgui.TextWrapped(u8("Описание: Открывает лог сообщений особо опасных преступников"))
						imgui.TextWrapped(u8("Использование: /ooplist"))
					end
				elseif iter_68_21 == "/oop" and imgui.CollapsingHeader(u8("Указать о ООП"), 0) then
					imgui.TextWrapped(u8("Описание: Указывает по волне департамента о том что человек ООП"))
					imgui.TextWrapped(u8("Использование: /oop id"))
				end
			end

			if iter_68_21 == "/smsl" then
				if imgui.CollapsingHeader(u8("Открыть лог сообщений (SMS)"), 0) then
					imgui.TextWrapped(u8("Описание: Открывает лог сообщений SMS за сессию"))
					imgui.TextWrapped(u8("Использование: /smsl"))
				end
			elseif iter_68_21 == "/radl" then
				if imgui.CollapsingHeader(u8("Открыть лог сообщений рации (/r)"), 0) then
					imgui.TextWrapped(u8("Описание: Открывает лог сообщений рации за сессию"))
					imgui.TextWrapped(u8("Использование: /radl"))
				end
			elseif iter_68_21 == "/depl" then
				if imgui.CollapsingHeader(u8("Открыть лог волны департамента (/d)"), 0) then
					imgui.TextWrapped(u8("Описание: Открывает лог сообщений волны департамента за сессию"))
					imgui.TextWrapped(u8("Использование: /depl"))
				end
			elseif iter_68_21 == "/chatlog" and imgui.CollapsingHeader(u8("Открыть полный чатлог"), 0) then
				imgui.TextWrapped(u8("Описание: Открывает полный чатлог"))
				imgui.TextWrapped(u8("Использование: /chatlog"))
			end

			if group == "Армия" and iter_68_21 == "/mon" and imgui.CollapsingHeader(u8("Отправить мониторинг в рацию"), 0) then
				imgui.TextWrapped(u8("Описание: Отправляет мониторинг складов фракций в рацию"))
				imgui.TextWrapped(u8("Использование: /mon"))
			end
		end

		imgui.TextDisabled(u8("Команды скрипта ATSC"))
		imgui.Separator()
		imgui.TextDisabled(u8("Сторонние команды"))

		for iter_68_22, iter_68_23 in ipairs(getChatCommands()) do
			if iter_68_23 == "/scm" then
				-- block empty
			elseif iter_68_23 == "/fm" then
				-- block empty
			elseif iter_68_23 == "/msg" then
				-- block empty
			elseif iter_68_23 == "/pay" then
				-- block empty
			elseif iter_68_23 == "/tq" then
				-- block empty
			elseif iter_68_23 == "/stime" then
				-- block empty
			elseif iter_68_23 == "/sweather" then
				-- block empty
			elseif iter_68_23 == "/myon" then
				-- block empty
			elseif iter_68_23 == "/kv" then
				-- block empty
			elseif iter_68_23 == "/su" then
				-- block empty
			elseif iter_68_23 == "/mg" then
				-- block empty
			elseif iter_68_23 == "/ssu" then
				-- block empty
			elseif iter_68_23 == "/ooplist" then
				-- block empty
			elseif iter_68_23 == "/oop" then
				-- block empty
			elseif iter_68_23 == "/smsl" then
				-- block empty
			elseif iter_68_23 == "/radl" then
				-- block empty
			elseif iter_68_23 == "/depl" then
				-- block empty
			elseif iter_68_23 == "/chatlog" then
				-- block empty
			elseif iter_68_23 == "/mon" then
				-- block empty
			elseif iter_68_23 == "/fshp" then
				-- block empty
			elseif iter_68_23 == "/test" then
				-- block empty
			elseif imgui.CollapsingHeader(iter_68_23, 0) then
				imgui.TextWrapped(u8("Команда стороннего скрипта"))
			end
		end

		imgui.Spacing()
		imgui.SameLine(125)

		if imgui.Button(u8("Меню")) then
			scm()
		end

		imgui.SameLine(250)
		imgui.TextDisabled("Version " .. script.this.version)
		imgui.End()
	end

	if var_0_56.v then
		local var_68_52, var_68_53 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_52 / 2, var_68_53 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(891, 380), imgui.Cond.FirstUseEver)
		imgui.Begin(u8(tagimgui .. "Список команд"), var_0_56, imgui.WindowFlags.NoResize)
		imgui.BeginChild("##commandlist", imgui.ImVec2(170, 320), true)

		for iter_68_24, iter_68_25 in pairs(var_0_16) do
			if imgui.Selectable(u8(("%s. /%s##%s"):format(iter_68_24, iter_68_25.cmd, iter_68_24)), var_0_55 == iter_68_24) then
				var_0_55 = iter_68_24
				var_0_57.v = u8(iter_68_25.cmd)
				var_0_58.v = iter_68_25.params
				var_0_59.v = u8(iter_68_25.text)
			end
		end

		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("##commandsetting", imgui.ImVec2(700, 320), true)

		for iter_68_26, iter_68_27 in pairs(var_0_16) do
			if var_0_55 == iter_68_26 then
				imgui.InputText(u8("Введите команду"), var_0_57)
				imgui.InputInt(u8("Введите кол-во параметров команды"), var_0_58, 0)
				imgui.InputTextMultiline(u8("##cmdtext"), var_0_59, imgui.ImVec2(678, 200))
				imgui.TextWrapped(u8("Ключи параметров: {param:1}, {param:2} и т.д (Использовать в тексте на месте параметра)\nКлюч задержки: {wait:кол-во миллисекунд} (Использовать на новой строке)"))

				if imgui.Button(u8("Сохранить команду")) then
					sampAddChatMessage(tag .. "Команда сохранена", -1)
					sampUnregisterChatCommand(iter_68_27.cmd)

					iter_68_27.cmd = u8:decode(var_0_57.v)
					iter_68_27.params = var_0_58.v
					iter_68_27.text = u8:decode(var_0_59.v)

					saveData(var_0_16, "moonloader/config/alzcmdbinder.json")
					registerCommandsBinder()
				end

				imgui.SameLine()

				if imgui.Button(u8("Удалить команду")) then
					imgui.OpenPopup(u8("Удаление команды##") .. iter_68_26)
				end

				if imgui.BeginPopupModal(u8("Удаление команды##") .. iter_68_26, _, imgui.WindowFlags.AlwaysAutoResize) then
					imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - imgui.CalcTextSize(u8("Вы действительно хотите удалить команду?")).x / 2)
					imgui.Text(u8("Вы действительно хотите удалить команду?"))

					if imgui.Button(u8("Удалить##") .. iter_68_26, imgui.ImVec2(170, 20)) then
						sampUnregisterChatCommand(iter_68_27.cmd)

						var_0_55 = 0
						var_0_57.v = ""
						var_0_58.v = 0
						var_0_59.v = ""

						table.remove(var_0_16, iter_68_26)
						saveData(var_0_16, "moonloader/config/alzcmdbinder.json")
						registerCommandsBinder()
						imgui.CloseCurrentPopup()
					end

					imgui.SameLine()

					if imgui.Button(u8("Отмена##") .. iter_68_26, imgui.ImVec2(170, 20)) then
						imgui.CloseCurrentPopup()
					end

					imgui.EndPopup()
				end

				imgui.SameLine()

				if imgui.Button(u8("Ключи"), imgui.ImVec2(170, 20)) then
					imgui.OpenPopup("##bindkey")
				end

				if imgui.BeginPopup("##bindkey") then
					imgui.Text(u8("Используйте ключи биндера для более удобного использования биндера"))
					imgui.Text(u8("Пример: /su {targetid} 6 Вооруженное нападение на ПО"))
					imgui.Separator()
					imgui.Text(u8("{myid} - ID вашего персонажа | ") .. select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
					imgui.Text(u8("{myrpnick} - РП ник вашего персонажа | ") .. sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "))
					imgui.Text(u8("{naparnik} - Ваши напарники | " .. naparnik()))
					imgui.Text(u8("{kv} - Ваш текущий квадрат | " .. kvadrat()))
					imgui.Text(u8("{naprav} - Ваше направление |") .. u8(naprav))
					imgui.Text(u8("{targetid} - ID игрока на которого вы целитесь | ") .. var_0_85)
					imgui.Text(u8("{targetrpnick} - РП ник игрока на которого вы целитесь | ") .. sampGetPlayerNicknameForBinder(var_0_85):gsub("_", " "))
					imgui.Text(u8("{smsid} - Последний ID того, кто вам написал в SMS | ") .. smsid)
					imgui.Text(u8("{smstoid} - Последний ID того, кому вы написали в SMS | ") .. smstoid)
					imgui.Text(u8("{rang} - Ваше звание | ") .. u8(rang))
					imgui.Text(u8("{mytag} - Ваш тег | ") .. u8(cfg.config.tag4))
					imgui.Text(u8("{frak} - Ваша фракция | ") .. frak)
					imgui.Text(u8("{wait:sek} - Задержка между строками, где sek - кол-во миллисекунд. Пример: {wait:2000} - задержка 2 секунды. (использовать отдельно на новой строчке)"))
					imgui.Text(u8("{screen} - Сделать скриншот экрана (использовать отдельно на новой строчке)"))
					imgui.EndPopup()
				end
			end
		end

		imgui.EndChild()

		if imgui.Button(u8("Добавить команду"), imgui.ImVec2(170, 20)) then
			table.insert(var_0_16, {
				text = "",
				cmd = "",
				params = 0
			})
			saveData(var_0_16, "moonloader/config/alzcmdbinder.json")
		end

		imgui.End()
	end

	if Megaf then
		local var_68_54, var_68_55 = sampGetCharHandleBySampPlayerId(idMegaf)

		if doesCharExist(var_68_55) then
			thread = lua_thread.create(function()
				main_x2 = select(1, getScreenResolution()) / 2 + 400
				main_y2 = select(2, getScreenResolution()) / 2 + 250

				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3, Anim1))
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(cfg.config.colorVec4Button1, cfg.config.colorVec4Button2, cfg.config.colorVec4Button3, Anim1))
				imgui.PushStyleColor(imgui.Col.TitleBg, imgui.ImVec4(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3, Anim1))
				imgui.PushStyleColor(imgui.Col.TitleBgActive, imgui.ImVec4(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3, Anim1))
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(cfg.config.colorVec4Text1, cfg.config.colorVec4Text2, cfg.config.colorVec4Text3, Anim1))
				imgui.SetNextWindowPos(imgui.ImVec2(main_x2, main_y2))
				imgui.SetNextWindowSize(imgui.ImVec2(200, 80), imgui.WindowFlags.AlwaysAutoResize)
				imgui.Begin("pogonya", ATSC.ipogonya, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
				imgui.CentrText(u8("Информация о преследуемом"))
				imgui.Separator()
				imgui.Spacing()
				imgui.TextColoredRGB("Ник: {ff0000}" .. sampGetPlayerNickname(idMegaf) .. " [" .. idMegaf .. "]")
				imgui.TextColoredRGB("Уровень: {ff0000}" .. sampGetPlayerScore(idMegaf))
				imgui.TextColoredRGB("Фракция: {ff0000}" .. sampGetFraktionBySkin(idMegaf))

				if isCharInAnyCar(var_68_55) then
					local var_70_0 = storeCarCharIsInNoSave(var_68_55)
					local var_70_1 = getCarModel(var_70_0)

					imgui.TextColoredRGB("Транспорт: {ff0000}" .. var_0_29[var_70_1 - 399])
				else
					imgui.TextColoredRGB("Транспорт: {ff0000}Неизвестно")
				end

				imgui.Spacing()
				imgui.End()
				imgui.PopStyleColor(5)
			end)
		end
	end

	if cfg.config.fastsu and tt.v then
		sizeX = 175
		sizeY = 10
		resX, resY = getScreenResolution()
		main_x = select(1, getScreenResolution()) / 2 - 87.5
		main_y = select(2, getScreenResolution()) - 970

		imgui.SetNextWindowPos(imgui.ImVec2(main_x, sizeY))
		imgui.SetNextWindowSize(imgui.ImVec2(175, 65), imgui.WindowFlags.AlwaysAutoResize)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
		imgui.Begin("tt", tt, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)

		local var_68_56 = string.format("%.2f", timeryes)

		imgui.CentrText(var_0_34.ICON_FA_CLOCK .. u8(" Время на ответ: ") .. var_68_56)
		imgui.Separator()
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0, 0, 0, 0))
		imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.25, 0, 0, 1))
		imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(1, 0, 0, 1))
		imgui.PushItemWidth(110)
		imgui.ProgressBar(timeryes / 15, imgui.ImVec2(185, 12))
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.TextColoredRGB("Нажмите {63c600}Y{ffffff} для выдачи розыска")
		imgui.CentrTextDisabled(u8("ESC чтобы закрыть"))
		imgui.End()
		imgui.PopStyleColor()

		sizeX2 = 120
		sizeY2 = 90
		resX, resY = getScreenResolution()
		main_x2 = select(1, getScreenResolution()) / 2 - 60
		main_y2 = select(2, getScreenResolution()) - 970

		imgui.SetNextWindowPos(imgui.ImVec2(main_x2, sizeY2))
		imgui.SetNextWindowSize(imgui.ImVec2(120, 90), imgui.WindowFlags.AlwaysAutoResize)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0))
		imgui.Begin("tt2", tt2, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)

		if Uron then
			imgui.CenterTextColoredRGB("{ffffff}Вы получили урон от")
			imgui.CenterTextColoredRGB("{ff0000}" .. nicknameROZ .. "{ffffff}")
			imgui.CenterTextColored(imgui.ImVec4(1, 0, 0, 1), var_0_34.ICON_FA_CROSSHAIRS)
		end

		if Megaf then
			imgui.CenterTextColoredRGB("{ffffff}Вы начали погоню за")
			imgui.CenterTextColoredRGB("{ff0000}" .. nicknameMegaf .. "{ffffff}")
			imgui.CenterTextColored(imgui.ImVec4(1, 0, 0, 1), var_0_34.ICON_FA_CAR)
		end

		imgui.End()
		imgui.PopStyleColor()
	end

	if pkm then
		main_x1 = select(1, getScreenResolution()) / 4.4 - 220
		main_y1 = select(2, getScreenResolution()) - 450

		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.3))
		imgui.SetNextWindowPos(imgui.ImVec2(main_x1, main_y1))
		imgui.SetNextWindowSize(imgui.ImVec2(295, 1), imgui.WindowFlags.AlwaysAutoResize)
		imgui.Begin("pkmM", pkmM, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
		imgui.Text(u8("Расширенные действия с игроком:"))
		imgui.TextColored(imgui.ImVec4(getColor(Zid)), u8("%s"):format(Zname))
		imgui.SameLine()
		imgui.Text(("[%s]"):format(Zid))
		imgui.Separator()

		if AF then
			if Str == 1 then
				imgui.Text(u8("[1] - Надеть наручники"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_1) then
					lua_thread.create(function()
						pkm = false

						sampSendChat(string.format("/me %s руки преступника, снимает наручники с тактического пояса", cfg.config.women and "заломала" or "заломал"))
						wait(1000)
						sampSendChat("/cuff " .. Zid)
					end)
				end

				imgui.Text(u8("[2] - Вести за собой"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_2) then
					lua_thread.create(function()
						pkm = false

						sampSendChat(string.format("/me крепко %s преступника, ведет его рядом с собой", cfg.config.women and "схватила" or "схватил"))
						wait(1000)
						sampSendChat("/follow " .. Zid)
					end)
				end

				imgui.Text(u8("[3] - Произвести обыск [/take]"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_3) then
					lua_thread.create(function()
						pkm = false

						sampSendChat(string.format("/me %s перчатки из подсумка, проводит обыск преступника", cfg.config.women and "надела" or "надел"))
						wait(1000)
						sampSendChat("/take " .. Zid)
					end)
				end

				imgui.Text(u8("[4] - Произвести обыск [/frisk]"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_4) then
					lua_thread.create(function()
						pkm = false

						sampSendChat(string.format("/me %s перчатки из подсумка, проводит обыск преступника", cfg.config.women and "надела" or "надел"))
						wait(1000)
						sampSendChat("/frisk " .. Zid)
					end)
				end

				imgui.Text(u8("[5] - Произвести арест"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_5) then
					lua_thread.create(function()
						pkm = false

						sampSendChat(string.format("/me %s камеру ключами, %s туда %s, затем %s ее обратно", cfg.config.women and "открыла" or "открыл", cfg.config.women and "провела" or "провел", Zname:gsub("_", " "), cfg.config.women and "закрыла" or "закрыл"))
						wait(1000)
						sampSendChat("/arrest " .. Zid)
					end)
				end

				imgui.Text(u8("[6] - Снять наручники"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_6) then
					lua_thread.create(function()
						pkm = false

						sampSendChat(string.format("/me %s наручники с преступника", cfg.config.women and "сняла" or "снял"))
						wait(1000)
						sampSendChat("/uncuff " .. Zid)
					end)
				end

				imgui.Text(u8("[7] - Снять маску"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_7) then
					sampSendChat("/offmask " .. Zid)

					pkm = false
				end

				imgui.Text(u8("[8] - Выдать розыск"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_8) then
					Str = 2
				end
			elseif Str == 2 then
				imgui.Text(u8("[1] - Проникновение на охр.территорию"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_1) then
					sampSendChat("/su " .. Zid .. " 2 Проникновение на охр. территорию")

					pkm = false
				end

				imgui.Text(u8("[2] - Хранение наркотиков"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_2) then
					sampSendChat("/su " .. Zid .. " 3 Хранение наркотиков")

					pkm = false
				end

				imgui.Text(u8("[3] - Хранение материалов"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_3) then
					sampSendChat("/su " .. Zid .. " 3 Хранение материалов")

					pkm = false
				end

				imgui.Text(u8("[4] - Продажа наркотиков"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_4) then
					sampSendChat("/su " .. Zid .. " 2 Продажа наркотиков")
					lua_thread.create(function()
						wait(1100)
						sampSendChat(string.format("/me %s руки преступника, снимает наручники с тактического пояса", cfg.config.women and "заломала" or "заломал"))
						wait(1000)
						sampSendChat("/cuff " .. Zid)

						pkm = false
					end)
				end

				imgui.Text(u8("[5] - Продажа ключей от камеры"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_5) then
					sampSendChat("/su " .. Zid .. " 6 Продажа ключей от камеры")
					lua_thread.create(function()
						wait(1100)
						sampSendChat(string.format("/me %s руки преступника, снимает наручники с тактического пояса", cfg.config.women and "заломала" or "заломал"))
						wait(1000)
						sampSendChat("/cuff " .. Zid)

						pkm = false
					end)
				end

				imgui.Text(u8("[6] - Меню розыска"))

				if not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(VK_6) then
					if sampIsPlayerConnected(Zid) then
						submenus_show(sumenu(Zid), "{ff0000}" .. script.this.name .. " {ffffff}| Выдать розыск игроку " .. sampGetPlayerNickname(Zid) .. "[" .. Zid .. "] ")
					end

					pkm = false
				end

				imgui.Text(u8("[7] - Вернуться"))

				if isKeyJustPressed(VK_7) then
					Str = 1
				end
			end
		else
			pkmM.v = false

			imgui.Text(u8("В разработке"))
		end

		imgui.End()
		imgui.PopStyleColor()
	end

	if cfg.config.buttV and bp then
		local var_68_57, var_68_58, var_68_59 = getCharWeaponInSlot(PLAYER_PED, 3)
		local var_68_60, var_68_61, var_68_62 = getCharWeaponInSlot(PLAYER_PED, 4)
		local var_68_63, var_68_64, var_68_65 = getCharWeaponInSlot(PLAYER_PED, 5)
		local var_68_66, var_68_67, var_68_68 = getCharWeaponInSlot(PLAYER_PED, 6)
		local var_68_69, var_68_70, var_68_71 = getCharWeaponInSlot(PLAYER_PED, 7)
		local var_68_72 = getCharHealth(PLAYER_PED)
		local var_68_73 = getCharArmour(PLAYER_PED)

		sizeX = 175
		sizeY = 670
		resX, resY = getScreenResolution()
		XX = select(1, getScreenResolution()) / 2 - 87.5
		YY = select(2, getScreenResolution()) / 2 + 150

		imgui.SetNextWindowPos(imgui.ImVec2(XX, YY))
		imgui.SetNextWindowSize(imgui.ImVec2(175, 65), imgui.WindowFlags.AlwaysAutoResize)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
		imgui.Begin("bp", ATSC.bp, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)

		if bp1 and imgui.Button(u8("Взять всё вооружение")) then
			lua_thread.create(function()
				if var_68_57 == 0 and var_68_58 < 21 then
					wait(250)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 0, "")
				end

				if var_68_60 == 0 and var_68_61 < 30 then
					wait(250)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 1, "")
				end

				if var_68_63 == 0 and var_68_64 < 90 then
					wait(250)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2, "")
				end

				if var_68_66 == 0 and var_68_67 < 150 then
					wait(250)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 3, "")
				end

				if var_68_69 == 0 and var_68_70 < 30 then
					wait(250)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 4, "")
				end

				if var_68_72 < 90 or var_68_73 < 100 then
					wait(250)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 5, "")
					wait(250)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2, "")

					if group == "ФБР" or group == "Полиция" then
						wait(250)
						sampSendDialogResponse(sampGetCurrentDialogId(), 1, 3, "")
						wait(250)
						sampSendDialogResponse(sampGetCurrentDialogId(), 1, 4, "")
					end
				end

				sampCloseCurrentDialogWithButton(0)
			end)

			bp1 = false
			bp = false
		end

		imgui.End()
		imgui.PopStyleColor()
	end

	if ATSC.imegaf.v then
		local var_68_74, var_68_75 = getScreenResolution()
		local var_68_76 = imgui.ImVec2(-0.1, 0)

		imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(var_68_74 / 2 + 300, var_68_75 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8(script.this.name .. " | Мегафон"), ATSC.imegaf, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

		for iter_68_28, iter_68_29 in ipairs(var_0_17) do
			local var_68_77, var_68_78, var_68_79 = getCharCoordinates(PLAYER_PED)

			if sampIsPlayerConnected(iter_68_29) then
				local var_68_80, var_68_81 = sampGetCharHandleBySampPlayerId(iter_68_29)

				if var_68_80 then
					local var_68_82, var_68_83, var_68_84 = getCharCoordinates(var_68_81)
					local var_68_85 = math.floor(getDistanceBetweenCoords3d(var_68_77, var_68_78, var_68_79, var_68_82, var_68_83, var_68_84))

					if var_68_85 >= 24 and var_68_85 <= 49 then
						dist2 = "24+"
					end

					if var_68_85 >= 12 and var_68_85 <= 23 then
						dist2 = "12+"
					end

					if var_68_85 <= 11 then
						dist2 = "11~"
					end

					if var_68_85 >= 50 and var_68_85 <= 74 then
						dist2 = "50+"
					end

					if var_68_85 >= 75 and var_68_85 <= 99 then
						dist2 = "75+"
					end

					if var_68_85 >= 100 then
						dist2 = "100+"
					end

					if isCharInAnyCar(var_68_81) then
						local var_68_86 = storeCarCharIsInNoSave(var_68_81)
						local var_68_87 = getCarModel(var_68_86)

						if imgui.Button(("%s [EVL%sX] | Distance: %s m.##%s"):format(var_0_29[var_68_87 - 399], iter_68_29, dist2, iter_68_28), var_68_76) then
							lua_thread.create(function()
								ATSC.imegaf.v = false
								vv = true
								gmegafid = iter_68_29
								gmegaflvl = sampGetPlayerScore(iter_68_29)
								gmegaffrak = sampGetFraktionBySkin(iter_68_29)
								gmegafcar = var_0_29[var_68_87 - 399]

								sampSendChat(("/m Водитель а/м %s [EVL%sX] Прижмитесь к обочине или мы будем вынуждены открыть огонь"):format(var_0_29[var_68_87 - 399], iter_68_29))
								wait(300)
							end)
						end
					end
				end
			end
		end

		imgui.End()
	end

	if pricel.v then
		if cfg.config.hud == 1 then
			HPbarArmy()
		else
			HPbarMin()
		end
	end

	if infb.v then
		if cfg.config.infobar == 1 then
			PlayerPosition()

			sizeX = 455
			sizeY = 1
			resX, resY = getScreenResolution()
			main_x = select(1, getScreenResolution()) / 2 - 227.5
			main_y = select(2, getScreenResolution()) - 20

			imgui.SetNextWindowPos(imgui.ImVec2(main_x, main_y))
			imgui.SetNextWindowSize(imgui.ImVec2(455, 1))

			if cfg.config.kraska then
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3, cfg.config.FonP))
			else
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
			end

			imgui.Begin("horizontal", infb, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)

			local var_68_88, var_68_89 = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local var_68_90 = sampGetPlayerNickname(var_68_89)
			local var_68_91 = sampGetPlayerScore(var_68_89)
			local var_68_92 = sampGetPlayerPing(var_68_89)
			local var_68_93 = sampGetPlayerArmor(var_68_89)
			local var_68_94 = getCharHealth(PLAYER_PED)
			local var_68_95 = getCharArmour(PLAYER_PED)
			local var_68_96 = getCharSpeed(PLAYER_PED)
			local var_68_97 = getSprintLocalPlayer(PLAYER_PED)
			local var_68_98 = math.ceil(var_68_97)
			local var_68_99 = getWaterLocalPlayer(PLAYER_PED)
			local var_68_100 = math.ceil(var_68_99)
			local var_68_101 = math.ceil(var_68_96)
			local var_68_102 = getCurrentCharWeapon(PLAYER_PED)

			if getCharHeading(playerPed) >= 337.5 or getCharHeading(playerPed) <= 22.5 then
				naprav = "Северное"
			end

			if getCharHeading(playerPed) > 22.5 and getCharHeading(playerPed) <= 67.5 then
				naprav = "Северо-западное"
			end

			if getCharHeading(playerPed) > 67.5 and getCharHeading(playerPed) <= 112.5 then
				naprav = "Западное"
			end

			if getCharHeading(playerPed) > 112.5 and getCharHeading(playerPed) <= 157.5 then
				naprav = "Юго-западное"
			end

			if getCharHeading(playerPed) > 157.5 and getCharHeading(playerPed) <= 202.5 then
				naprav = "Южное"
			end

			if getCharHeading(playerPed) > 202.5 and getCharHeading(playerPed) <= 247.5 then
				naprav = "Юго-восточное"
			end

			if getCharHeading(playerPed) > 247.5 and getCharHeading(playerPed) <= 292.5 then
				naprav = "Восточное"
			end

			if getCharHeading(playerPed) > 292.5 and getCharHeading(playerPed) <= 337.5 then
				naprav = "Северо-восточное"
			end

			imgui.Text(var_0_34.ICON_FA_ID_CARD .. " ID: " .. var_68_89)
			imgui.SameLine()
			imgui.Text(var_0_34.ICON_FA_USER)
			imgui.SameLine()
			imgui.TextColored(imgui.ImVec4(getColor(var_68_89)), u8("%s"):format(var_68_90))
			imgui.SameLine()
			imgui.Text(var_0_34.ICON_FA_PODCAST .. " LVL: " .. var_68_91)
			imgui.SameLine()
			imgui.Text(var_0_34.ICON_FA_WIFI .. u8(" ") .. var_68_92)
			imgui.SameLine()
			imgui.Text(" " .. var_0_34.ICON_FA_HEART .. " " .. var_68_94)
			imgui.SameLine()
			imgui.Text(var_0_34.ICON_FA_SHIELD_ALT .. " " .. var_68_93)
			imgui.SameLine()

			if var_68_98 > 100 then
				var_68_98 = 100
			end

			if var_68_100 <= 99 then
				imgui.Text(var_0_34.ICON_FA_BATTERY_THREE_QUARTERS .. u8(" ") .. var_68_100)
			else
				imgui.Text(var_0_34.ICON_FA_BATTERY_THREE_QUARTERS .. u8(" ") .. var_68_98)
			end

			imgui.SameLine()
			imgui.Text(var_0_34.ICON_FA_FILM .. " " .. myfps)

			var_0_68 = imgui.GetWindowPos()
			main_x1 = var_0_68.x
			main_y1 = var_0_68.y

			imgui.End()
			imgui.PopStyleColor()

			main_x1 = select(1, getScreenResolution()) / 8 - 160
			main_y1 = select(2, getScreenResolution()) - 20

			if cfg.config.kraska then
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3, cfg.config.FonP))
			else
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
			end

			imgui.SetNextWindowPos(imgui.ImVec2(main_x1, main_y1))
			imgui.SetNextWindowSize(imgui.ImVec2(295, 1), imgui.WindowFlags.AlwaysAutoResize)
			imgui.Begin("horizontal2", infb, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
			imgui.Text(var_0_34.ICON_FA_COMPASS)
			imgui.SameLine()
			imgui.Text(u8(naprav))
			imgui.SameLine()
			imgui.Text("" .. var_0_34.ICON_FA_LOCATION_ARROW)
			imgui.SameLine()
			imgui.Text(("%s | %s |"):format(u8(Zone), u8(kvadrat())))
			imgui.SameLine()
			imgui.Text(u8("%s"):format(os.date("%X")))
			imgui.End()
			imgui.PopStyleColor()

			if cfg.config.kraska then
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3, cfg.config.FonP))
			else
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
			end

			main_x2 = select(1, getScreenResolution()) - 200

			if isCharInAnyCar(playerPed) then
				main_y2 = select(2, getScreenResolution()) - 60
			else
				main_y2 = select(2, getScreenResolution()) - 40
			end

			local var_68_103 = getAmmoInClip(myweapon)
			local var_68_104 = getCurrentCharWeapon(PLAYER_PED)
			local var_68_105 = getAmmoInCharWeapon(PLAYER_PED, var_68_104) - var_68_103
			local var_68_106 = var_0_6.get_name(var_68_104)

			imgui.SetNextWindowPos(imgui.ImVec2(main_x2, main_y2))
			imgui.SetNextWindowSize(imgui.ImVec2(200, 80))
			imgui.Begin("horizontal3", infb, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)
			imgui.Text(var_0_34.ICON_FA_BOMB)
			imgui.SameLine()

			if var_68_103 == 0 then
				imgui.Text(u8("Оружие: %s"):format(var_68_106))
			else
				imgui.Text(u8("Оружие: %s [%s/%s]"):format(var_68_106, var_68_103, var_68_105))
			end

			if isCharInAnyCar(playerPed) then
				local var_68_107 = storeCarCharIsInNoSave(playerPed)
				local var_68_108, var_68_109 = sampGetVehicleIdByCarHandle(var_68_107)
				local var_68_110 = getCarHealth(var_68_107)
				local var_68_111 = getCarSpeed(var_68_107)
				local var_68_112 = math.floor(var_68_111)
				local var_68_113 = var_0_29[getCarModel(storeCarCharIsInNoSave(playerPed)) - 399]
				local var_68_114 = math.floor(var_68_111 * 2)

				imgui.Text(var_0_34.ICON_FA_CAR)
				imgui.SameLine()
				imgui.Text(u8("%s [%s]"):format(var_68_113, var_68_109))
				imgui.Text(var_0_34.ICON_FA_CAR)
				imgui.SameLine()
				imgui.Text(u8("HP: %s | Скорость: %s"):format(var_68_110, var_68_114))
			else
				if var_68_101 < 0 then
					var_68_101 = 0
				end

				imgui.Text(var_0_34.ICON_FA_RUNNING)
				imgui.SameLine()
				imgui.Text(u8("Скорость: ") .. var_68_101)
			end

			imgui.End()
			imgui.PopStyleColor()

			if timedep > 0 or timemask > 0 or timeffix > 0 or timedsup > 0 then
				X2 = cfg.config.KDx
				Y2 = cfg.config.KDy

				imgui.SetNextWindowPos(imgui.ImVec2(X2, Y2))
				imgui.SetNextWindowSize(imgui.ImVec2(400, 1))

				local var_68_115 = math.floor(timemask / 60)
				local var_68_116 = timemask % 60
				local var_68_117 = math.floor(timeffix / 60)
				local var_68_118 = timeffix % 60
				local var_68_119 = math.floor(timedsup / 60)
				local var_68_120 = timedsup % 60

				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0))
				imgui.Begin("horizontal4", infb, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar)

				if timedep > 0 then
					local var_68_121 = string.format("%.2f", timedep)

					imgui.Text(var_0_34.ICON_FA_BRIEFCASE .. u8(": ") .. var_68_121)
				end

				imgui.SameLine()

				if timeffix > 0 and timeffix < 60 then
					local var_68_122 = string.format("%.2f", var_68_118)

					imgui.Text(var_0_34.ICON_FA_CAR .. u8(": ") .. var_68_122)
				end

				imgui.SameLine()

				if timedsup > 0 and timedsup < 60 then
					local var_68_123 = string.format("%.2f", var_68_120)

					imgui.Text(var_0_34.ICON_FA_JOINT .. u8(": ") .. var_68_123)
				end

				imgui.SameLine()

				if timemask > 0 and timemask < 60 then
					local var_68_124 = string.format("%.2f", var_68_116)

					imgui.Text(var_0_34.ICON_FA_MASK .. u8(": ") .. var_68_124)
				end

				if timeffix > 60 then
					local var_68_125 = string.format("%.2f", var_68_118)

					imgui.Text(var_0_34.ICON_FA_CAR .. u8(": ") .. var_68_117 .. ":" .. var_68_125)
				end

				imgui.SameLine()

				if timemask > 60 then
					local var_68_126 = string.format("%.2f", var_68_116)

					imgui.Text(var_0_34.ICON_FA_MASK .. u8(": ") .. var_68_115 .. ":" .. var_68_126)
				end

				imgui.SameLine()

				if timedsup > 60 then
					local var_68_127 = string.format("%.2f", var_68_120)

					imgui.Text(var_0_34.ICON_FA_JOINT .. ": " .. var_68_119 .. ":" .. var_68_127)
				end

				imgui.End()
				imgui.PopStyleColor()
			end
		elseif cfg.config.infobar == 2 then
			PlayerPosition()

			if cfg.config.kraska then
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3, cfg.config.infP))
			else
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, cfg.config.infP))
			end

			_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

			local var_68_128 = sampGetPlayerNickname(myid)
			local var_68_129 = sampGetPlayerPing(myid)
			local var_68_130 = sampGetPlayerArmor(myid)
			local var_68_131 = sampGetPlayerHealth(myid)
			local var_68_132 = math.floor(timemask / 60)
			local var_68_133 = timemask % 60
			local var_68_134 = math.floor(timeffix / 60)
			local var_68_135 = timeffix % 60
			local var_68_136 = getAmmoInClip(myweapon)
			local var_68_137 = getCharSpeed(PLAYER_PED)
			local var_68_138 = getSprintLocalPlayer(PLAYER_PED)
			local var_68_139 = math.ceil(var_68_138)
			local var_68_140 = getWaterLocalPlayer(PLAYER_PED)
			local var_68_141 = math.ceil(var_68_140)
			local var_68_142 = math.ceil(var_68_137)
			local var_68_143 = getCurrentCharWeapon(PLAYER_PED)
			local var_68_144 = getAmmoInCharWeapon(PLAYER_PED, var_68_143) - var_68_136
			local var_68_145, var_68_146 = getCharPlayerIsTargeting(PLAYER_HANDLE)
			local var_68_147 = ""

			if getCharHeading(playerPed) >= 337.5 or getCharHeading(playerPed) <= 22.5 then
				var_68_147 = "Северное"
			end

			if getCharHeading(playerPed) > 22.5 and getCharHeading(playerPed) <= 67.5 then
				var_68_147 = "Северо-западное"
			end

			if getCharHeading(playerPed) > 67.5 and getCharHeading(playerPed) <= 112.5 then
				var_68_147 = "Западное"
			end

			if getCharHeading(playerPed) > 112.5 and getCharHeading(playerPed) <= 157.5 then
				var_68_147 = "Юго-западное"
			end

			if getCharHeading(playerPed) > 157.5 and getCharHeading(playerPed) <= 202.5 then
				var_68_147 = "Южное"
			end

			if getCharHeading(playerPed) > 202.5 and getCharHeading(playerPed) <= 247.5 then
				var_68_147 = "Юго-восточное"
			end

			if getCharHeading(playerPed) > 247.5 and getCharHeading(playerPed) <= 292.5 then
				var_68_147 = "Восточное"
			end

			if getCharHeading(playerPed) > 292.5 and getCharHeading(playerPed) <= 337.5 then
				var_68_147 = "Северо-восточное"
			end

			local var_68_148 = var_0_6.get_name(var_68_143)
			local var_68_149, var_68_150 = getScreenResolution()

			imgui.SetNextWindowPos(imgui.ImVec2(cfg.config.posX, cfg.config.posY), imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(cfg.config.infX, cfg.config.infY))
			imgui.Begin("ATSC", infb, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)

			if cfg.config.zero then
				imgui.CentrText("ATSC")
				imgui.Separator()
			end

			if cfg.config.one then
				imgui.Text(var_0_34.ICON_FA_ID_CARD)
				imgui.SameLine()
				imgui.TextColored(imgui.ImVec4(getColor(myid)), u8("%s"):format(var_68_128))
				imgui.SameLine()
				imgui.Text("[" .. myid .. "]")
			end

			if cfg.config.two then
				imgui.Text(var_0_34.ICON_FA_WIFI)
				imgui.SameLine()
				imgui.Text(u8("Пинг: ") .. var_68_129 .. "| FPS: " .. myfps)
			end

			if cfg.config.three then
				imgui.Text(var_0_34.ICON_FA_HEARTBEAT)
				imgui.SameLine()
				imgui.Text(u8("Здоровье: ") .. var_68_131)
			end

			if cfg.config.four then
				imgui.Text(var_0_34.ICON_FA_SHIELD_ALT)
				imgui.SameLine()
				imgui.Text(u8("Броня: ") .. var_68_130)
			end

			if cfg.config.five then
				imgui.Text(var_0_34.ICON_FA_BATTERY_THREE_QUARTERS)
				imgui.SameLine()

				if var_68_139 > 100 then
					var_68_139 = 100
				end

				if var_68_141 <= 99 then
					imgui.Text(u8("Кислород: ") .. var_68_141)
				else
					imgui.Text(u8("Выносливость: ") .. var_68_139)
				end
			end

			if cfg.config.six then
				imgui.Text(var_0_34.ICON_FA_BOMB)
				imgui.SameLine()

				if var_68_136 == 0 then
					imgui.Text(u8("Оружие: %s"):format(var_68_148))
				else
					imgui.Text(u8("Оружие: %s [%s/%s]"):format(var_68_148, var_68_136, var_68_144))
				end
			end

			if cfg.config.seven then
				if isCharInAnyCar(playerPed) then
					local var_68_151 = storeCarCharIsInNoSave(playerPed)
					local var_68_152, var_68_153 = sampGetVehicleIdByCarHandle(var_68_151)
					local var_68_154 = getCarHealth(var_68_151)
					local var_68_155 = getCarSpeed(var_68_151)
					local var_68_156 = math.floor(var_68_155)
					local var_68_157 = var_0_29[getCarModel(storeCarCharIsInNoSave(playerPed)) - 399]
					local var_68_158 = math.floor(var_68_155 * 2)

					imgui.Text(var_0_34.ICON_FA_CAR)
					imgui.SameLine()
					imgui.Text(u8("%s [%s]"):format(var_68_157, var_68_153))
					imgui.Text(var_0_34.ICON_FA_CAR)
					imgui.SameLine()
					imgui.Text(u8("HP: %s | Скорость: %s"):format(var_68_154, var_68_158))
				else
					if var_68_142 < 0 then
						var_68_142 = 0
					end

					imgui.Text(var_0_34.ICON_FA_RUNNING)
					imgui.SameLine()
					imgui.Text(u8("Скорость: ") .. var_68_142)
				end
			end

			if cfg.config.eight then
				if var_68_145 and doesCharExist(var_68_146) then
					local var_68_159, var_68_160 = sampGetPlayerIdByCharHandle(var_68_146)

					if var_68_159 then
						local var_68_161 = sampGetPlayerNickname(var_68_160)
						local var_68_162 = sampGetPlayerScore(var_68_160)
						local var_68_163 = sampGetPlayerArmor(var_68_160)
						local var_68_164 = sampGetPlayerHealth(var_68_160)

						imgui.Text(var_0_34.ICON_FA_USER_ALT)
						imgui.SameLine()
						imgui.TextWrapped(u8("Цель: %s [%s]"):format(var_68_161, var_68_160))
						imgui.Text(var_0_34.ICON_FA_HEARTBEAT)
						imgui.SameLine()
						imgui.Text((u8("HP: %s  ") .. var_0_34.ICON_FA_SHIELD_ALT .. " Armor: %s"):format(var_68_164, var_68_163))
					else
						imgui.Text(var_0_34.ICON_FA_USER_ALT_SLASH)
						imgui.SameLine()
						imgui.Text(u8("Цель: Нет"))
					end
				else
					imgui.Text(var_0_34.ICON_FA_USER_ALT_SLASH)
					imgui.SameLine()
					imgui.Text(u8("Цель: Нет"))
				end
			end

			if cfg.config.nine then
				imgui.Text(var_0_34.ICON_FA_LOCATION_ARROW)
				imgui.SameLine()
				imgui.Text(u8("%s | %s"):format(u8(Zone), u8(kvadrat())))
			end

			if cfg.config.ten then
				imgui.Text(var_0_34.ICON_FA_COMPASS)
				imgui.SameLine()
				imgui.Text(u8(var_68_147))
			end

			if cfg.config.eleven then
				imgui.Text(var_0_34.ICON_FA_CALENDAR_ALT)
				imgui.SameLine()
				imgui.Text(u8("%s | %s"):format(os.date("%X"), os.date("%d.%m.%y")))
			end

			if imgui.IsMouseClicked(0) and changetextpos then
				changetextpos = false

				sampToggleCursor(false)

				ATSC.settings.v = true

				sampAddChatMessage(tag .. "Выбранная позиция сохранена.", -1)
				var_0_4.save(cfg, var_0_24)
			end

			if cfg.config.twelve or cfg.config.thirteen or cfg.config.fourteen then
				imgui.Separator()
			end

			if cfg.config.twelve then
				if timedep <= 0 then
					imgui.Text(var_0_34.ICON_FA_BRIEFCASE .. u8(" Департамент: Доступен"))
				else
					local var_68_165 = string.format("%.2f", timedep)

					imgui.Text(var_0_34.ICON_FA_BRIEFCASE .. u8(" Департамент: ") .. var_68_165)
				end
			end

			if cfg.config.thirteen then
				if timeffix <= 0 then
					imgui.Text(var_0_34.ICON_FA_CAR .. u8(" Ффикскар: Доступен"))
				else
					local var_68_166 = string.format("%.2f", var_68_135)

					imgui.Text(var_0_34.ICON_FA_CAR .. u8(" Ффикскар: ") .. var_68_134 .. ":" .. var_68_166)
				end
			end

			if cfg.config.fourteen then
				if timemask <= 0 then
					imgui.Text(var_0_34.ICON_FA_MASK .. u8(" Маска: Доступна"))
				else
					local var_68_167 = string.format("%.2f", var_68_133)

					imgui.Text(var_0_34.ICON_FA_MASK .. u8(" Маска: ") .. var_68_132 .. ":" .. var_68_167)
				end
			end

			if group == "Армия" then
				if mor == "Нет связи с мониторингом" then
					imgui.Text(var_0_34.ICON_FA_EYE_SLASH .. u8(" Связь с мониторингом"))
				elseif Actual <= 0 then
					mor = "Нет связи с мониторингом"

					imgui.Text(var_0_34.ICON_FA_EYE_SLASH .. u8(" Связь с мониторингом"))
				else
					imgui.Text(var_0_34.ICON_FA_EYE .. u8(" Связь с мониторингом"))
				end
			end

			imgui.End()
			imgui.PopStyleColor()
		end
	end

	if bMainWindow.v then
		local var_68_168, var_68_169 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_68_168 / 2, var_68_169 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(1000, 510), imgui.Cond.FirstUseEver)
		imgui.Begin(u8("Биндер##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.BeginChild("##bindlist", imgui.ImVec2(995, 442))

		for iter_68_30, iter_68_31 in ipairs(tBindList) do
			if var_0_32.HotKey("##HK" .. iter_68_30, iter_68_31, var_0_15, 100) then
				if not var_0_22.isHotKeyDefined(iter_68_31.v) then
					if var_0_22.isHotKeyDefined(var_0_15.v) then
						var_0_22.unRegisterHotKey(var_0_15.v)
					end

					var_0_22.registerHotKey(iter_68_31.v, true, onHotKey)
				end

				saveData(tBindList, var_0_13)
			end

			imgui.SameLine()
			imgui.CentrText(u8(iter_68_31.name))
			imgui.SameLine(850)

			if imgui.Button(u8("Редактировать бинд##") .. iter_68_30) then
				imgui.OpenPopup(u8("Редактирование биндера##editbind") .. iter_68_30)

				var_0_52.v = u8(iter_68_31.name)
				var_0_53.v = u8(iter_68_31.text)
			end

			if imgui.BeginPopupModal(u8("Редактирование биндера##editbind") .. iter_68_30, _, imgui.WindowFlags.NoResize) then
				imgui.Text(u8("Введите название биндера:"))
				imgui.InputText("##Введите название биндера", var_0_52)
				imgui.Text(u8("Введите текст биндера:"))
				imgui.InputTextMultiline("##Введите текст биндера", var_0_53, imgui.ImVec2(500, 200))
				imgui.Separator()

				if imgui.Button(u8("Ключи"), imgui.ImVec2(90, 20)) then
					imgui.OpenPopup("##bindkey")
				end

				if imgui.BeginPopup("##bindkey") then
					imgui.Text(u8("Используйте ключи биндера для более удобного использования биндера"))
					imgui.Separator()
					imgui.Text(u8("{myid} - ID вашего персонажа | ") .. select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
					imgui.Text(u8("{myrpnick} - РП ник вашего персонажа | ") .. sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "))
					imgui.Text(u8("{naparnik} - Ваши напарники | " .. naparnik()))
					imgui.Text(u8("{kv} - Ваш текущий квадрат | " .. kvadrat()))
					imgui.Text(u8("{naprav} - Ваше направление |") .. u8(naprav))
					imgui.Text(u8("{targetid} - ID игрока на которого вы целитесь | ") .. var_0_85)
					imgui.Text(u8("{targetrpnick} - РП ник игрока на которого вы целитесь | ") .. sampGetPlayerNicknameForBinder(var_0_85):gsub("_", " "))
					imgui.Text(u8("{smsid} - Последний ID того, кто вам написал в SMS | ") .. smsid)
					imgui.Text(u8("{smstoid} - Последний ID того, кому вы написали в SMS | ") .. smstoid)
					imgui.Text(u8("{rang} - Ваше звание | ") .. u8(rang))
					imgui.Text(u8("{frak} - Ваша фракция | ") .. frak)
					imgui.Text(u8("{mytag} - Ваш тег | ") .. u8(cfg.config.tag4))
					imgui.Text(u8("{dl} - ID авто, в котором вы сидите | ") .. var_0_84)
					imgui.Text(u8("{f6} - Отправить сообщение в чат через эмуляцию чата (использовать в самом начале)"))
					imgui.Text(u8("{noe} - Оставить сообщение в полле ввода а не отправлять его в чат (использовать в самом начале)"))
					imgui.Text(u8("{wait:sek} - Задержка между строками, где sek - кол-во миллисекунд. Пример: {wait:2000} - задержка 2 секунды. (использовать отдельно на новой строчке)"))
					imgui.Text(u8("{screen} - Сделать скриншот экрана (использовать отдельно на новой строчке)"))
					imgui.EndPopup()
				end

				imgui.SameLine()
				imgui.SetCursorPosX(imgui.GetWindowWidth() - 90 - imgui.GetStyle().ItemSpacing.x)

				if imgui.Button(u8("Удалить бинд##") .. iter_68_30, imgui.ImVec2(90, 20)) then
					table.remove(tBindList, iter_68_30)
					saveData(tBindList, var_0_13)
					imgui.CloseCurrentPopup()
				end

				imgui.SameLine()
				imgui.SetCursorPosX((imgui.GetWindowWidth() - 180 + imgui.GetStyle().ItemSpacing.x) / 2)

				if imgui.Button(u8("Сохранить##") .. iter_68_30, imgui.ImVec2(90, 20)) then
					sampAddChatMessage(tag .. "Бинд сохранен", -1)

					iter_68_31.name = u8:decode(var_0_52.v)
					iter_68_31.text = u8:decode(var_0_53.v)
					var_0_52.v = ""
					var_0_53.v = ""

					saveData(tBindList, var_0_13)
					imgui.CloseCurrentPopup()
				end

				imgui.SameLine()

				if imgui.Button(u8("Закрыть##") .. iter_68_30, imgui.ImVec2(90, 20)) then
					imgui.CloseCurrentPopup()
				end

				imgui.EndPopup()
			end
		end

		imgui.EndChild()
		imgui.Separator()

		if imgui.Button(u8("Добавить клавишу")) then
			tBindList[#tBindList + 1] = {
				text = "",
				time = 0,
				v = {},
				name = "Бинд" .. #tBindList + 1
			}

			saveData(tBindList, var_0_13)
		end

		imgui.SameLine()

		if imgui.Button(u8("Командный биндер")) then
			bMainWindow.v = not bMainWindow.v
			var_0_56.v = not var_0_56.v
		end

		imgui.End()
	end
end

function sampGetFraktionBySkin(arg_81_0)
	local var_81_0 = 0
	local var_81_1 = "Гражданский"
	local var_81_2, var_81_3 = sampGetCharHandleBySampPlayerId(arg_81_0)

	if var_81_2 then
		var_81_0 = getCharModel(var_81_3)
	else
		var_81_0 = getCharModel(PLAYER_PED)
	end

	if var_81_0 == 102 or var_81_0 == 103 or var_81_0 == 104 or var_81_0 == 195 or var_81_0 == 21 then
		var_81_1 = "Ballas Gang"
	end

	if var_81_0 == 105 or var_81_0 == 106 or var_81_0 == 107 or var_81_0 == 269 or var_81_0 == 270 or var_81_0 == 271 or var_81_0 == 86 or var_81_0 == 149 or var_81_0 == 297 then
		var_81_1 = "Grove Gang"
	end

	if var_81_0 == 108 or var_81_0 == 109 or var_81_0 == 110 or var_81_0 == 190 or var_81_0 == 47 then
		var_81_1 = "Vagos Gang"
	end

	if var_81_0 == 114 or var_81_0 == 115 or var_81_0 == 116 or var_81_0 == 48 or var_81_0 == 44 or var_81_0 == 41 or var_81_0 == 292 then
		var_81_1 = "Aztec Gang"
	end

	if var_81_0 == 173 or var_81_0 == 174 or var_81_0 == 175 or var_81_0 == 193 or var_81_0 == 226 or var_81_0 == 30 or var_81_0 == 119 then
		var_81_1 = "Rifa Gang"
	end

	if var_81_0 == 191 or var_81_0 == 252 or var_81_0 == 287 or var_81_0 == 61 or var_81_0 == 179 or var_81_0 == 255 then
		var_81_1 = "Army"
	end

	if var_81_0 == 57 or var_81_0 == 98 or var_81_0 == 147 or var_81_0 == 150 or var_81_0 == 187 or var_81_0 == 216 then
		var_81_1 = "Мэрия"
	end

	if var_81_0 == 59 or var_81_0 == 172 or var_81_0 == 189 or var_81_0 == 240 then
		var_81_1 = "Автошкола"
	end

	if var_81_0 == 201 or var_81_0 == 247 or var_81_0 == 248 or var_81_0 == 254 or var_81_0 == 248 or var_81_0 == 298 then
		var_81_1 = "Байкеры"
	end

	if var_81_0 == 272 or var_81_0 == 112 or var_81_0 == 125 or var_81_0 == 214 or var_81_0 == 111 or var_81_0 == 126 then
		var_81_1 = "Русская мафия"
	end

	if var_81_0 == 113 or var_81_0 == 124 or var_81_0 == 214 or var_81_0 == 223 then
		var_81_1 = "La Cosa Nostra"
	end

	if var_81_0 == 120 or var_81_0 == 123 or var_81_0 == 169 or var_81_0 == 186 then
		var_81_1 = "Yakuza"
	end

	if var_81_0 == 211 or var_81_0 == 217 or var_81_0 == 250 or var_81_0 == 261 then
		var_81_1 = "News"
	end

	if var_81_0 == 70 or var_81_0 == 219 or var_81_0 == 274 or var_81_0 == 275 or var_81_0 == 276 or var_81_0 == 70 then
		var_81_1 = "Медики"
	end

	if var_81_0 == 286 or var_81_0 == 141 or var_81_0 == 163 or var_81_0 == 164 or var_81_0 == 165 or var_81_0 == 166 then
		var_81_1 = "FBI"
	end

	if var_81_0 == 280 or var_81_0 == 265 or var_81_0 == 266 or var_81_0 == 267 or var_81_0 == 281 or var_81_0 == 282 or var_81_0 == 288 or var_81_0 == 284 or var_81_0 == 285 or var_81_0 == 304 or var_81_0 == 305 or var_81_0 == 306 or var_81_0 == 307 or var_81_0 == 309 or var_81_0 == 283 or var_81_0 == 303 then
		var_81_1 = "Полиция"
	end

	return var_81_1
end

function naparnik()
	local var_82_0 = {}

	if isCharInAnyCar(PLAYER_PED) then
		local var_82_1 = storeCarCharIsInNoSave(PLAYER_PED)

		for iter_82_0 = 0, 999 do
			if sampIsPlayerConnected(iter_82_0) then
				local var_82_2 = select(2, sampGetCharHandleBySampPlayerId(iter_82_0))

				if doesCharExist(var_82_2) and isCharInAnyCar(var_82_2) and var_82_1 == storeCarCharIsInNoSave(var_82_2) and (sampGetFraktionBySkin(iter_82_0) == "Полиция" or sampGetFraktionBySkin(iter_82_0) == "FBI" or sampGetFraktionBySkin(iter_82_0) == "Army") then
					local var_82_3, var_82_4 = sampGetPlayerNickname(iter_82_0):match("(.+)_(.+)")

					if var_82_3 and var_82_4 then
						table.insert(var_82_0, string.format("%s.%s", var_82_3:sub(1, 1), var_82_4))
					end
				end
			end
		end
	else
		local var_82_5, var_82_6, var_82_7 = getCharCoordinates(PLAYER_PED)

		for iter_82_1 = 0, 999 do
			if sampIsPlayerConnected(iter_82_1) then
				local var_82_8 = select(2, sampGetCharHandleBySampPlayerId(iter_82_1))

				if doesCharExist(var_82_8) then
					local var_82_9, var_82_10, var_82_11 = getCharCoordinates(var_82_8)

					if getDistanceBetweenCoords3d(var_82_5, var_82_6, var_82_7, var_82_9, var_82_10, var_82_11) <= 30 and (sampGetFraktionBySkin(iter_82_1) == "Полиция" or sampGetFraktionBySkin(iter_82_1) == "FBI") then
						local var_82_12, var_82_13 = sampGetPlayerNickname(iter_82_1):match("(.+)_(.+)")

						if var_82_12 and var_82_13 then
							table.insert(var_82_0, string.format("%s.%s", var_82_12:sub(1, 1), var_82_13))
						end
					end
				end
			end
		end
	end

	if #var_82_0 == 0 then
		return "Напарников нет."
	elseif #var_82_0 == 1 then
		return "Напарник: " .. table.concat(var_82_0, ", ") .. "."
	elseif #var_82_0 >= 2 then
		return "Напарники: " .. table.concat(var_82_0, ", ") .. "."
	end
end

function checkStats()
	while not sampIsLocalPlayerSpawned() do
		wait(0)
	end

	checkstat = true

	sampSendChat("/stats")
	setVirtualKeyDown(key.VK_TAB, false)
	wait(3)
	setVirtualKeyDown(key.VK_TAB, false)

	local var_83_0 = os.clock() + 1

	while var_83_0 > os.clock() do
		wait(0)
	end

	local var_83_1

	checkstat = false

	if rang == -1 and frak == -1 then
		sampAddChatMessage(tag .. "Не удалось определить статистику персонажа. Нажмите {63c600}Y{ffffff} чтобы повторить попытку.", -1)

		opyatstat = true
	end
end

function sampGetPlayerNicknameForBinder(arg_84_0)
	local var_84_0 = "-1"
	local var_84_1 = tonumber(arg_84_0)

	if var_84_1 ~= nil and sampIsPlayerConnected(var_84_1) then
		var_84_0 = sampGetPlayerNickname(var_84_1)
	end

	return var_84_0
end

function onHotKey(arg_85_0, arg_85_1)
	if not sampIsChatInputActive() and not sampIsDialogActive() then
		thread = lua_thread.create(function()
			local var_86_0 = tostring(table.concat(arg_85_1, " "))

			for iter_86_0, iter_86_1 in pairs(tBindList) do
				if var_86_0 == tostring(table.concat(iter_86_1.v, " ")) then
					local var_86_1 = tostring(iter_86_1.text)

					if var_86_1:len() > 0 then
						for iter_86_2 in var_86_1:gmatch("[^\r\n]+") do
							if iter_86_2:match("^{wait%:%d+}$") then
								wait(iter_86_2:match("^%{wait%:(%d+)}$"))
							elseif iter_86_2:match("^{screen}$") then
								screen()
							else
								local var_86_2 = string.match(iter_86_2, "^{noe}(.+)") ~= nil
								local var_86_3 = string.match(iter_86_2, "^{f6}(.+)") ~= nil
								local var_86_4 = {
									["{noe}"] = "",
									["{f6}"] = "",
									["{myid}"] = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)),
									["{kv}"] = kvadrat(),
									["{targetid}"] = var_0_85,
									["{targetrpnick}"] = sampGetPlayerNicknameForBinder(var_0_85):gsub("_", " "),
									["{naparnik}"] = naparnik(),
									["{myrpnick}"] = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub("_", " "),
									["{naprav}"] = naprav,
									["{mytag}"] = cfg.config.tag4,
									["{rang}"] = rang,
									["{frak}"] = frak,
									["{dl}"] = var_0_84
								}

								for iter_86_3, iter_86_4 in pairs(var_86_4) do
									iter_86_2 = iter_86_2:gsub(iter_86_3, iter_86_4)
								end

								if not var_86_2 then
									if var_86_3 then
										sampProcessChatInput(iter_86_2)
									else
										sampSendChat(iter_86_2)
									end
								else
									sampSetChatInputText(iter_86_2)
									sampSetChatInputEnabled(true)
								end
							end
						end
					end
				end
			end
		end)
	end
end

local key7 = false

myfps = 0

function HeaderButton(arg_87_0, arg_87_1)
	local var_87_0 = imgui.GetWindowDrawList()
	local var_87_1 = imgui.ColorConvertFloat4ToU32
	local var_87_2 = false
	local var_87_3 = string.gsub(arg_87_1, "##.*$", "")
	local var_87_4 = {
		0.5,
		0.3
	}
	local var_87_5 = {
		idle = imgui.GetStyle().Colors[imgui.Col.TextDisabled],
		hovr = imgui.GetStyle().Colors[imgui.Col.Text],
		slct = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
	}

	if not AI_HEADERBUT then
		AI_HEADERBUT = {}
	end

	if not AI_HEADERBUT[arg_87_1] then
		AI_HEADERBUT[arg_87_1] = {
			color = arg_87_0 and var_87_5.slct or var_87_5.idle,
			clock = os.clock() + var_87_4[1],
			h = {
				state = arg_87_0,
				alpha = arg_87_0 and 1 or 0,
				clock = os.clock() + var_87_4[2]
			}
		}
	end

	local var_87_6 = AI_HEADERBUT[arg_87_1]

	local function var_87_7(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
		local var_88_0 = arg_88_0
		local var_88_1 = os.clock() - arg_88_2

		if var_88_1 >= 0 then
			local var_88_2 = {
				x = arg_88_1.x - arg_88_0.x,
				y = arg_88_1.y - arg_88_0.y,
				z = arg_88_1.z - arg_88_0.z,
				w = arg_88_1.w - arg_88_0.w
			}

			var_88_0.x = var_88_0.x + var_88_2.x / arg_88_3 * var_88_1
			var_88_0.y = var_88_0.y + var_88_2.y / arg_88_3 * var_88_1
			var_88_0.z = var_88_0.z + var_88_2.z / arg_88_3 * var_88_1
			var_88_0.w = var_88_0.w + var_88_2.w / arg_88_3 * var_88_1
		end

		return var_88_0
	end

	local function var_87_8(arg_89_0, arg_89_1, arg_89_2, arg_89_3)
		local var_89_0 = arg_89_0
		local var_89_1 = os.clock() - arg_89_2

		if var_89_1 >= 0 then
			var_89_0 = var_89_0 + (arg_89_1 - arg_89_0) / arg_89_3 * var_89_1
		end

		return var_89_0
	end

	local function var_87_9(arg_90_0, arg_90_1)
		return imgui.ImVec4(arg_90_0.x, arg_90_0.y, arg_90_0.z, arg_90_1 or 1)
	end

	imgui.BeginGroup()

	local var_87_10 = imgui.GetCursorPos()
	local var_87_11 = imgui.GetCursorScreenPos()

	imgui.TextColored(var_87_6.color, var_87_3)

	local var_87_12 = imgui.GetItemRectSize()
	local var_87_13 = imgui.IsItemHovered()
	local var_87_14 = imgui.IsItemClicked()

	if var_87_6.h.state ~= var_87_13 and not arg_87_0 then
		var_87_6.h.state = var_87_13
		var_87_6.h.clock = os.clock()
	end

	if var_87_14 then
		var_87_6.clock = os.clock()
		var_87_2 = true
	end

	if os.clock() - var_87_6.clock <= var_87_4[1] then
		var_87_6.color = var_87_7(imgui.ImVec4(var_87_6.color), arg_87_0 and var_87_5.slct or var_87_13 and var_87_5.hovr or var_87_5.idle, var_87_6.clock, var_87_4[1])
	else
		var_87_6.color = arg_87_0 and var_87_5.slct or var_87_13 and var_87_5.hovr or var_87_5.idle
	end

	if var_87_6.h.clock ~= nil then
		if os.clock() - var_87_6.h.clock <= var_87_4[2] then
			var_87_6.h.alpha = var_87_8(var_87_6.h.alpha, var_87_6.h.state and 1 or 0, var_87_6.h.clock, var_87_4[2])
		else
			var_87_6.h.alpha = var_87_6.h.state and 1 or 0

			if not var_87_6.h.state then
				var_87_6.h.clock = nil
			end
		end

		local var_87_15 = var_87_12.x / 2
		local var_87_16 = var_87_11.y + var_87_12.y + 3
		local var_87_17 = var_87_11.x + var_87_15

		var_87_0:AddLine(imgui.ImVec2(var_87_17, var_87_16), imgui.ImVec2(var_87_17 + var_87_15 * var_87_6.h.alpha, var_87_16), var_87_1(var_87_9(var_87_6.color, var_87_6.h.alpha)), 3)
		var_87_0:AddLine(imgui.ImVec2(var_87_17, var_87_16), imgui.ImVec2(var_87_17 - var_87_15 * var_87_6.h.alpha, var_87_16), var_87_1(var_87_9(var_87_6.color, var_87_6.h.alpha)), 3)
	end

	imgui.EndGroup()

	return var_87_2
end

function registerinf()
	chatT = imgui.ImBool(cfg.config.chatT)
	fastsu = imgui.ImBool(cfg.config.fastsu)
	id1 = imgui.ImBool(cfg.config.id1)
	radmod = imgui.ImBool(cfg.config.radmod)
	megaf2 = imgui.ImBool(cfg.config.megaf2)
	women = imgui.ImBool(cfg.config.women)
	MSGsound = imgui.ImBool(cfg.config.MSGsound)
	MSGchs = imgui.ImBool(cfg.config.MSGchs)
	MSGclear = imgui.ImBool(cfg.config.MSGclear)
	oblaka = imgui.ImBool(cfg.config.oblaka)
	afish = imgui.ImBool(cfg.config.afish)
	maskRP = imgui.ImBool(cfg.config.maskRP)
	streamCheck = imgui.ImBool(cfg.config.streamcheck)
	rpay = imgui.ImBool(cfg.config.rpay)
	quitm = imgui.ImBool(cfg.config.quitm)
	autobp = imgui.ImBool(cfg.config.autobp)
	buttV = imgui.ImBool(cfg.config.buttV)
	TAG5 = imgui.ImBool(cfg.config.TAG5)
	autologin = imgui.ImBool(cfg.config.autologin)
	rtagkv = imgui.ImBool(cfg.config.rtagkv)
	bindM = imgui.ImBool(cfg.config.bindM)
	car2 = imgui.ImBool(cfg.config.car2)
	tableON = imgui.ImBool(cfg.config.tableON)
	pricel = imgui.ImBool(cfg.config.pricel)
	membmod = imgui.ImBool(cfg.config.membmod)
	infb = imgui.ImBool(cfg.config.infb)
	CL2 = imgui.ImBool(cfg.config.CL2)
	cl = imgui.ImFloat(cfg.config.cl)
	FonP = imgui.ImFloat(cfg.config.FonP)
	combo_select = imgui.ImInt(cfg.config.shpora)
	zero = imgui.ImBool(cfg.config.zero)
	one = imgui.ImBool(cfg.config.one)
	two = imgui.ImBool(cfg.config.two)
	three = imgui.ImBool(cfg.config.three)
	four = imgui.ImBool(cfg.config.four)
	five = imgui.ImBool(cfg.config.five)
	six = imgui.ImBool(cfg.config.six)
	seven = imgui.ImBool(cfg.config.seven)
	eight = imgui.ImBool(cfg.config.eight)
	nine = imgui.ImBool(cfg.config.nine)
	ten = imgui.ImBool(cfg.config.ten)
	eleven = imgui.ImBool(cfg.config.eleven)
	twelve = imgui.ImBool(cfg.config.twelve)
	thirteen = imgui.ImBool(cfg.config.thirteen)
	fourteen = imgui.ImBool(cfg.config.fourteen)
	deagle = imgui.ImBool(cfg.config.deagle)
	shotgun = imgui.ImBool(cfg.config.shotgun)
	mp5 = imgui.ImBool(cfg.config.mp5)
	m4 = imgui.ImBool(cfg.config.m4)
	rifle = imgui.ImBool(cfg.config.rifle)
end

htk = cfg.hotkey.bindSCM:match("%d+")

local key8 = {
	["100"] = "Numpad 4",
	["85"] = "U",
	["89"] = "Y",
	["84"] = "T",
	["78"] = "N",
	["68"] = "D",
	["83"] = "S",
	["82"] = "R",
	["120"] = "F9",
	["74"] = "J",
	["71"] = "G",
	["34"] = "Page Down",
	["35"] = "End",
	["113"] = "F2",
	["45"] = "Insert",
	["221"] = "]",
	["107"] = "Numpad +",
	["111"] = "Numpad /",
	["51"] = "3",
	["102"] = "Numpad 6",
	["116"] = "F5",
	["117"] = "F6",
	["118"] = "F7",
	["119"] = "F8",
	["76"] = "L",
	["229"] = "|",
	["121"] = "F10",
	["112"] = "F1",
	["122"] = "F11",
	["123"] = "F12",
	["103"] = "Numpad 7",
	["186"] = ";",
	["115"] = "F4",
	["114"] = "F3",
	["104"] = "Numpad 8",
	["105"] = "Numpad 9",
	["187"] = "=",
	["191"] = "/",
	["188"] = ",",
	["190"] = ".",
	["69"] = "E",
	["79"] = "O",
	["49"] = "1",
	["106"] = "Numpad *",
	["189"] = "-",
	["48"] = "0",
	["99"] = "Numpad 3",
	["87"] = "W",
	["57"] = "9",
	["86"] = "V",
	["98"] = "Numpad 2",
	["97"] = "Numpad 1",
	["56"] = "8",
	["55"] = "7",
	["88"] = "X",
	["96"] = "Numpad 0",
	["77"] = "M",
	["36"] = "Home",
	["54"] = "6",
	["67"] = "C",
	["46"] = "Delete",
	["222"] = "\"",
	["66"] = "B",
	["65"] = "A",
	["75"] = "K",
	["53"] = "5",
	["219"] = "[",
	["73"] = "I",
	["192"] = "`",
	["52"] = "4",
	["33"] = "Page Up",
	["72"] = "H",
	["90"] = "Z",
	["81"] = "Q",
	["110"] = "Numpad .",
	["50"] = "2",
	["80"] = "P",
	["109"] = "Numpad -",
	["101"] = "Numpad 5",
	["70"] = "F"
}

function submenus_show(arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
	arg_92_2, arg_92_3, arg_92_4 = arg_92_2 or "»", arg_92_3 or "x", arg_92_4 or "«"
	prev_menus = {}

	function display(arg_93_0, arg_93_1, arg_93_2)
		local var_93_0 = {}

		for iter_93_0, iter_93_1 in ipairs(arg_93_0) do
			table.insert(var_93_0, type(iter_93_1.submenu) == "table" and iter_93_1.title .. " »" or iter_93_1.title)
		end

		sampShowDialog(arg_93_1, arg_93_2, table.concat(var_93_0, "\n"), arg_92_2, #prev_menus > 0 and arg_92_4 or arg_92_3, var_0_2.DIALOG_STYLE_LIST)

		repeat
			wait(0)

			local var_93_1, var_93_2, var_93_3 = sampHasDialogRespond(arg_93_1)

			if var_93_1 then
				if var_93_2 == 1 and var_93_3 ~= -1 then
					local var_93_4 = arg_93_0[var_93_3 + 1]

					if type(var_93_4.submenu) == "table" then
						table.insert(prev_menus, {
							menu = arg_93_0,
							caption = arg_93_2
						})

						if type(var_93_4.onclick) == "function" then
							var_93_4.onclick(arg_93_0, var_93_3 + 1, var_93_4.submenu)
						end

						return display(var_93_4.submenu, arg_93_1 + 1, var_93_4.submenu.title and var_93_4.submenu.title or var_93_4.title)
					elseif type(var_93_4.onclick) == "function" then
						local var_93_5 = var_93_4.onclick(arg_93_0, var_93_3 + 1)

						if not var_93_5 then
							return var_93_5
						end

						return display(arg_93_0, arg_93_1, arg_93_2)
					end
				else
					if #prev_menus > 0 then
						local var_93_6 = prev_menus[#prev_menus]

						prev_menus[#prev_menus] = nil

						return display(var_93_6.menu, arg_93_1 - 1, var_93_6.caption)
					end

					return false
				end
			end
		until var_93_1
	end

	return display(arg_92_0, 31337, arg_92_1 or arg_92_0.title)
end

pkm = false
Zactive = false
shpHelp = u8("Чтобы создать шпору, нажмите кнопку 'Редактировать шпору'.\nШпора привязана к названию. Меняя название, вы меняете файл где хранится шпора.")

local key9 = {
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	"Ё",
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	"ё",
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	"А",
	"Б",
	"В",
	"Г",
	"Д",
	"Е",
	"Ж",
	"З",
	"И",
	"Й",
	"К",
	"Л",
	"М",
	"Н",
	"О",
	"П",
	"Р",
	"С",
	"Т",
	"У",
	"Ф",
	"Х",
	"Ц",
	"Ч",
	"Ш",
	"Щ",
	"Ъ",
	"Ы",
	"Ь",
	"Э",
	"Ю",
	"Я",
	"а",
	"б",
	"в",
	"г",
	"д",
	"е",
	"ж",
	"з",
	"и",
	"й",
	"к",
	"л",
	"м",
	"н",
	"о",
	"п",
	"р",
	"с",
	"т",
	"у",
	"ф",
	"х",
	"ц",
	"ч",
	"ш",
	"щ",
	"ъ",
	"ы",
	"ь",
	"э",
	"ю",
	"я"
}

function string.rlower(arg_94_0)
	arg_94_0 = arg_94_0:lower()

	local var_94_0 = arg_94_0:len()

	if var_94_0 == 0 then
		return arg_94_0
	end

	arg_94_0 = arg_94_0:lower()

	local var_94_1 = ""

	for iter_94_0 = 1, var_94_0 do
		local var_94_2 = arg_94_0:byte(iter_94_0)

		if var_94_2 >= 192 and var_94_2 <= 223 then
			var_94_1 = var_94_1 .. key9[var_94_2 + 32]
		elseif var_94_2 == 168 then
			var_94_1 = var_94_1 .. key9[184]
		else
			var_94_1 = var_94_1 .. string.char(var_94_2)
		end
	end

	return var_94_1
end

function string.rupper(arg_95_0)
	arg_95_0 = arg_95_0:upper()

	local var_95_0 = arg_95_0:len()

	if var_95_0 == 0 then
		return arg_95_0
	end

	arg_95_0 = arg_95_0:upper()

	local var_95_1 = ""

	for iter_95_0 = 1, var_95_0 do
		local var_95_2 = arg_95_0:byte(iter_95_0)

		if var_95_2 >= 224 and var_95_2 <= 255 then
			var_95_1 = var_95_1 .. key9[var_95_2 - 32]
		elseif var_95_2 == 184 then
			var_95_1 = var_95_1 .. key9[168]
		else
			var_95_1 = var_95_1 .. string.char(var_95_2)
		end
	end

	return var_95_1
end

carmove = false

function main()
	if doesFileExist("moonloader\\config\\friendsatsc.json") then
		local var_96_0 = io.open("moonloader\\config\\friendsatsc.json", "r")

		if var_96_0 then
			friends = decodeJson(var_96_0:read("a*"))

			var_96_0:close()
		end
	else
		friends = {}
	end

	if doesFileExist("moonloader\\config\\blacklistatsc.json") then
		local var_96_1 = io.open("moonloader\\config\\blacklistatsc.json", "r")

		if var_96_1 then
			blacklist = decodeJson(var_96_1:read("a*"))

			var_96_1:close()
		end
	else
		blacklist = {}
	end

	if doesFileExist("moonloader/config/alzcmdbinder.json") then
		local var_96_2 = io.open("moonloader/config/alzcmdbinder.json", "r")

		if var_96_2 then
			var_0_16 = decodeJson(var_96_2:read("*a"))
		end
	end

	saveData(var_0_16, "moonloader/config/alzcmdbinder.json")

	if not isSampfuncsLoaded() or not isSampLoaded() then
		return
	end

	while not isSampAvailable() do
		wait(0)
	end

	sampAddChatMessage(tag .. "script has started | press " .. key8[htk], -1)

	while not sampIsLocalPlayerSpawned() do
		wait(0)
	end

	if not doesFileExist(var_0_14) then
		jsonSave(var_0_14, {})
	end

	smsfriends = jsonRead(var_0_14)

	TestersCheck()
	updatefps()
	registerinf()
	regbinds()
	autocl()
	registerbuffsh()
	registerbool()
	registerCommandsBinder()

	imgui.Process = sampIsChatVisible()
	da = var_0_22.registerHotKey(da1.v, true, da)
	bindLock = var_0_22.registerHotKey(Lock.v, true, lockFunc)
	bindMask = var_0_22.registerHotKey(Mask.v, true, fastMask)
	bindRATSC = var_0_22.registerHotKey(RATSC.v, true, RRATSC)
	bindZkey = var_0_22.registerHotKey(Zkey2.v, true, Zkey)
	bindSCM = var_0_22.registerHotKey(scm2.v, true, scm)
	bindMSG = var_0_22.registerHotKey(msg2.v, true, msg)
	bindTazer = var_0_22.registerHotKey(tazer2.v, true, tazer)
	bindMegaf = var_0_22.registerHotKey(megaf22.v, true, megaf)
	bindTazer = var_0_22.registerHotKey(tazer2.v, true, tazer)

	for iter_96_0, iter_96_1 in pairs(tBindList) do
		var_0_22.registerHotKey(iter_96_1.v, true, onHotKey)

		if iter_96_1.time ~= nil then
			iter_96_1.time = nil
		end

		if iter_96_1.name == nil then
			iter_96_1.name = "Бинд" .. iter_96_0
		end

		iter_96_1.text = iter_96_1.text:gsub("%[enter%]", ""):gsub("{noenter}", "{noe}")
	end

	saveData(tBindList, var_0_13)

	for iter_96_2, iter_96_3 in pairs(tBindList) do
		var_0_22.registerHotKey(iter_96_3.v, true, onHotKey)
	end

	addEventHandler("onWindowMessage", function(arg_97_0, arg_97_1, arg_97_2)
		if arg_97_0 == var_0_8.WM_KEYDOWN and arg_97_1 == key.VK_ESCAPE then
			if menu.v then
				consumeWindowMessage(true, true)
				lua_thread.create(function()
					Anim = 0.9

					wait(1)

					Anim = 0.8

					wait(1)

					Anim = 0.7

					wait(1)

					Anim = 0.6

					wait(1)

					Anim = 0.5

					wait(1)

					Anim = 0.4

					wait(1)

					Anim = 0.3

					wait(1)

					Anim = 0.2

					wait(1)

					Anim = 0.1
					menu.v = false
				end)
			end

			if ATSC.settings.v then
				ATSC.settings.v = false

				consumeWindowMessage(true, true)
			end

			if commandsa.v then
				commandsa.v = false

				consumeWindowMessage(true, true)
			end

			if window.v then
				window.v = false

				consumeWindowMessage(true, true)
			end

			if bMainWindow.v then
				bMainWindow.v = false

				consumeWindowMessage(true, true)
			end

			if var_0_56.v then
				var_0_56.v = false

				consumeWindowMessage(true, true)
			end

			if var_0_66.v then
				var_0_66.v = false

				consumeWindowMessage(true, true)
			end

			if memba.v then
				memba.v = false

				consumeWindowMessage(true, true)
			end

			if messeng.v then
				messeng.v = false

				consumeWindowMessage(true, true)
			end

			if var_0_67.v then
				var_0_67.v = false

				consumeWindowMessage(true, true)
			end

			if shpwindow.v then
				shpwindow.v = false

				consumeWindowMessage(true, true)
			end

			if log.v then
				log.v = false

				consumeWindowMessage(true, true)
			end

			if ATSC.imegaf.v then
				ATSC.imegaf.v = false

				consumeWindowMessage(true, true)
			end

			if pogonya then
				pogonya = false

				consumeWindowMessage(true, true)
			end

			if tt.v then
				tt.v = false
				yeskey = false
				Uron = false
				Megaf = false

				consumeWindowMessage(true, true)
			end
		end
	end)
	autoupdate("https://raw.githubusercontent.com/alzaga/autoupdATSC/main/upd.json", tag, "https://raw.githubusercontent.com/alzaga/autoupdATSC/main/upd.json")

	if cfg.onDay.today ~= os.date("%a") then
		cfg.onDay.today = os.date("%a")
		cfg.config.unch = 0
		cfg.config.invch = 0
		cfg.config.povch = 0
		cfg.onDay.onlineWork = 0
		cfg.onDay.online = 0
		cfg.onDay.full = 0
		cfg.onDay.afk = 0
		var_0_74.v = 0

		var_0_4.save(cfg, var_0_24)
	end

	if cfg.onWeek.week ~= number_week() then
		cfg.onWeek.week = number_week()
		cfg.onWeek.online = 0
		cfg.onWeek.onlineWork = 0
		cfg.config.unchv = 0
		cfg.config.invchv = 0
		cfg.config.povchv = 0
		cfg.onWeek.full = 0
		cfg.onWeek.afk = 0
		cfg.myWeekOnline = {
			[0] = 0,
			0,
			0,
			0,
			0,
			0,
			0
		}
		var_0_75.v = 0

		var_0_4.save(cfg, var_0_24)
	end

	lua_thread.create(time)
	lua_thread.create(autoSave)
	sampRegisterChatCommand("tq", tq)
	sampRegisterChatCommand("cc", cc)
	sampRegisterChatCommand("pay", pay)
	sampRegisterChatCommand("fm", fastMask)
	sampRegisterChatCommand("msg", msg)
	sampRegisterChatCommand("cadd", cadd)
	sampRegisterChatCommand("scm", scm)
	sampRegisterChatCommand("stime", fst)
	sampRegisterChatCommand("sweather", fsw)
	sampRegisterChatCommand("myon", myon)
	sampRegisterChatCommand("smsl", smslog)
	sampRegisterChatCommand("ooplist", ooplist1)
	sampRegisterChatCommand("depl", deplog)
	sampRegisterChatCommand("radl", radlog)
	sampRegisterChatCommand("chatlog", chatlog2)
	sampRegisterChatCommand("r", rtag)
	sampRegisterChatCommand("f", ftag)
	sampRegisterChatCommand("wb", bankwithdraw)
	sampRegisterChatCommand("db", bankdeposit)
	sampRegisterChatCommand("mb", mb2)
	sampRegisterChatCommand("shpm", fshp)
	sampRegisterChatCommand("fshp", findShp)
	sampRegisterChatCommand("kv", kv)

	imgui.ShowCursor = menu.v

	if key7 then
		sampToggleCursor(true)

		local var_96_3, var_96_4 = getCursorPos()

		cfg.config.posX = var_96_3
		cfg.config.posY = var_96_4
	end

	checkStats()
	setgroup()

	if AF then
		sampRegisterChatCommand("su", su)
		sampRegisterChatCommand("ssu", ssu)
	end

	while true do
		wait(0)

		if cfg.config.oblaka then
			var_0_9.setint8(12046052, 1)
		else
			var_0_9.setint8(12046052, 0)
		end

		if cfg.config.chatT and isKeyJustPressed(84) and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
			sampSetChatInputEnabled(true)
		end

		CheckRB()

		local var_96_5 = getCharHealth(PLAYER_PED)
		local var_96_6, var_96_7 = getCharPlayerIsTargeting(PLAYER_HANDLE)

		if var_96_6 and doesCharExist(var_96_7) then
			local var_96_8, var_96_9 = sampGetPlayerIdByCharHandle(var_96_7)

			var_0_85 = var_96_9
		end

		if Megaf then
			Anim1 = 0.1

			wait(50)

			Anim1 = 0.2

			wait(50)

			Anim1 = 0.3

			wait(50)

			Anim1 = 0.4

			wait(50)

			Anim1 = 0.5

			wait(50)

			Anim1 = 0.6

			wait(50)

			Anim1 = 0.7

			wait(50)

			Anim1 = 0.8

			wait(50)

			Anim1 = 0.9
			clock5 = os.clock()

			while os.clock() - clock5 < 15 do
				wait(0)

				pgt = 15 - (os.clock() - clock5)
			end

			repeat
				wait(0)
			until pgt == 2 or pgt <= 1

			Anim1 = 0.9

			wait(50)

			Anim1 = 0.8

			wait(50)

			Anim1 = 0.7

			wait(50)

			Anim1 = 0.6

			wait(50)

			Anim1 = 0.5

			wait(50)

			Anim1 = 0.4

			wait(50)

			Anim1 = 0.3

			wait(50)

			Anim1 = 0.2

			wait(50)

			Anim1 = 0.1

			wait(50)

			Anim1 = 0
		end

		if sampIsDialogActive() == false and not isPauseMenuActive() and isPlayerPlaying(playerHandle) and sampIsChatInputActive() == false and coordX ~= nil and coordY ~= nil then
			cX, cY, cZ = getCharCoordinates(playerPed)
			cX = math.ceil(cX)
			cY = math.ceil(cY)
			cZ = math.ceil(cZ)

			sampAddChatMessage(tag .. "Метка установлена на " .. kvadY .. "-" .. kvadX, -1)
			placeWaypoint(coordX, coordY, 0)

			coordX = nil
			coordY = nil
		end

		if isCharInAnyCar(PLAYER_PED) then
			var_0_84 = select(2, sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(PLAYER_PED)))
		end
	end
end

function ptext(arg_99_0)
	sampAddChatMessage(("%s | {ffffff}%s"):format(script.this.name, arg_99_0), 10824234)
end

function tq(arg_100_0)
	var1 = string.match(arg_100_0, "(%d+:%d+)")

	if var1 == nil or var1 == "" then
		sampAddChatMessage(tag .. "Введите нужное время. Например: /tq 23:00 ", -1)
	else
		lua_thread.create(function()
			sampAddChatMessage(tag .. "Запущен таймер закрытия GTA в {FF0000}" .. var1, -1)

			repeat
				wait(0)
			until os.date("%H:%M") == var1

			var_0_0.C.ExitProcess(0)
		end)
	end

	return false
end

function getPlayerIdByNickname(arg_102_0)
	for iter_102_0 = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(iter_102_0) and sampGetPlayerNickname(iter_102_0):lower() == tostring(arg_102_0):lower() then
			return iter_102_0
		end
	end
end

function cc()
	var_0_9.fill(sampGetChatInfoPtr() + 306, 0, 25200)
	var_0_9.write(sampGetChatInfoPtr() + 306, 25562, 4, 0)
	var_0_9.write(sampGetChatInfoPtr() + 25562, 1, 1)
end

function oop(arg_104_0)
	var1 = string.match(arg_104_0, "(%d+)")

	if var1 == nil or var1 == "" then
		sampAddChatMessage(tag .. "Введите ID!", -1)
	elseif sampIsPlayerConnected(var1) then
		local var_104_0 = sampGetPlayerNickname(var1):gsub("_", " ")

		sampSendChat("/d Mayor, дело на имя " .. var_104_0 .. " рассмотрению не подлежит, ООП.")
	else
		sampAddChatMessage(tag .. "Вы указали неверный ID!", -1)
	end
end

function var_0_5.onSendSpawn()
	maskN = false

	autocl()
end

function sampGetPlayerIdByNickname(arg_106_0)
	local var_106_0, var_106_1 = sampGetPlayerIdByCharHandle(playerPed)

	if tostring(arg_106_0) == sampGetPlayerNickname(var_106_1) then
		return var_106_1
	end

	for iter_106_0 = 0, 1000 do
		if sampIsPlayerConnected(iter_106_0) and sampGetPlayerNickname(iter_106_0) == tostring(arg_106_0) then
			return iter_106_0
		end
	end
end

function sampGetStreamedPlayers()
	local var_107_0 = {}

	for iter_107_0 = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(iter_107_0) then
			local var_107_1, var_107_2 = sampGetCharHandleBySampPlayerId(iter_107_0)

			if var_107_1 and doesCharExist(var_107_2) then
				table.insert(var_107_0, iter_107_0)
			end
		end
	end

	return var_107_0
end

timedsup = -1

function autoSave()
	while true do
		wait(60000)
		var_0_4.save(cfg, var_0_24)
	end
end

dsup1 = false

function var_0_5.onShowDialog(arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4, arg_109_5)
	if arg_109_0 == 24700 and fmask then
		if arg_109_5:find("Надеть") then
			sampSendDialogResponse(arg_109_0, 1, 1, _)
		else
			sampSendDialogResponse(arg_109_0, 0, 0, _)
		end

		sampSendClickTextdraw(90)

		fmask = false

		lua_thread.create(function()
			wait(888)
			sampSendChat("/mask")
		end)

		return false
	end

	if cfg.config.autologin and arg_109_0 == 1111 then
		sampSendDialogResponse(arg_109_0, 1, _, cfg.config.password)

		return false
	end

	lua_thread.create(function()
		if arg_109_2:find("Оружейная комната") then
			bp = true
			bp1 = true
		end

		if arg_109_2:find("Дополнительно") then
			bp1 = false
			bp = false
		end
	end)

	if cfg.config.autobp and arg_109_0 == 20054 then
		lua_thread.create(function()
			wait(1300)

			local var_112_0, var_112_1, var_112_2 = getCharWeaponInSlot(PLAYER_PED, 3)
			local var_112_3, var_112_4, var_112_5 = getCharWeaponInSlot(PLAYER_PED, 4)
			local var_112_6, var_112_7, var_112_8 = getCharWeaponInSlot(PLAYER_PED, 5)
			local var_112_9, var_112_10, var_112_11 = getCharWeaponInSlot(PLAYER_PED, 6)
			local var_112_12, var_112_13, var_112_14 = getCharWeaponInSlot(PLAYER_PED, 7)
			local var_112_15 = getCharHealth(PLAYER_PED)
			local var_112_16 = getCharArmour(PLAYER_PED)

			if cfg.config.deagle and var_112_0 == 0 and var_112_1 < 21 then
				wait(250)
				sampSendDialogResponse(sampGetCurrentDialogId(), 1, 0, "")
			end

			if cfg.config.shotgun and var_112_3 == 0 and var_112_4 < 30 then
				wait(250)
				sampSendDialogResponse(sampGetCurrentDialogId(), 1, 1, "")
			end

			if cfg.config.mp5 and var_112_6 == 0 and var_112_7 < 90 then
				wait(250)
				sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2, "")
			end

			if cfg.config.m4 and var_112_9 == 0 and var_112_10 < 150 then
				wait(250)
				sampSendDialogResponse(sampGetCurrentDialogId(), 1, 3, "")
			end

			if cfg.config.rifle and var_112_12 == 0 and var_112_13 < 30 then
				wait(250)
				sampSendDialogResponse(sampGetCurrentDialogId(), 1, 4, "")
			end

			if var_112_15 < 90 or var_112_16 < 100 then
				wait(250)
				sampSendDialogResponse(sampGetCurrentDialogId(), 1, 5, "")
				wait(250)
				sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2, "")
			end

			sampCloseCurrentDialogWithButton(0)

			bp1 = false
			bp = false
		end)
	end

	if arg_109_0 == 9901 and checkstat then
		frak, rangLVL, rang = arg_109_5:match(".*Организация%s+(%a+%s*%a*)%s+\nДолжность%s+(%d+)%s+%((.*)%).*\nРабота.*")

		if frak == nil or rang == nil then
			frak = "Нет"
			rang = "Нет"
		end

		if frak:match("LSPD") or frak:match("SFPD") or frak:match("LVPD") then
			group = "Полиция"
			AF = true

			sampRegisterChatCommand("mg", megaf)
			sampRegisterChatCommand("oop", oop)
		elseif frak:match("FBI") then
			group = "ФБР"
			AF = true

			sampRegisterChatCommand("mg", megaf)
			sampRegisterChatCommand("oop", oop)
		elseif frak:match("SFA") or frak:match("LVA") then
			group = "Армия"

			if cfg.config.CL2 and rabden == false and group == "Армия" then
				lua_thread.create(function()
					wait(1000)
					sampSendChat("/clist 7")
				end)
			end

			sampRegisterChatCommand("mon", monitoring)
		else
			group = "Криминал"

			sampRegisterChatCommand("us", us)
			sampRegisterChatCommand("dsup", function()
				lua_thread.create(function()
					sampSendChat("/dsupply")
					wait(100)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, _, _)
					wait(100)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, _, "5")
					wait(100)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 1, _)
					wait(100)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, _, "55")
					wait(100)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, 2, _)
					wait(100)
					sampSendDialogResponse(sampGetCurrentDialogId(), 1, _, _)
					wait(100)
					sampCloseCurrentDialogWithButton()
					wait(300)
					sampCloseCurrentDialogWithButton()

					local var_115_0 = os.clock()

					while os.clock() - var_115_0 < 300 do
						wait(0)

						timedsup = 300 - (os.clock() - var_115_0)
					end
				end)
			end)
		end

		print(frak)
		print(rang)
		print("Группа: " .. group)

		checkstat = false

		sampSendDialogResponse(arg_109_0, 1, _, _)

		return false
	end
end

function mb2(arg_116_0)
	memba.v = true

	lua_thread.create(function()
		if sampIsDialogActive() then
			if sampIsDialogClientside() then
				var_0_18 = {}
				var_0_92 = {}
				status = true

				sampSendChat("/members")

				while not gotovo do
					wait(0)
				end

				gosmb = false
				krimemb = false
				gotovo = false
				status = false
				gcount = nil
			end
		else
			var_0_18 = {}
			var_0_92 = {}
			status = true

			sampSendChat("/members")

			while not gotovo do
				wait(0)
			end

			memba.v = true
			gosmb = false
			krimemb = false
			gotovo = false
			status = false
			gcount = nil
		end
	end)
end

function mbpassive(arg_118_0)
	lua_thread.create(function()
		if sampIsDialogActive() then
			if sampIsDialogClientside() then
				var_0_18 = {}
				var_0_92 = {}
				status = true

				sampSendChat("/members")

				while not gotovo do
					wait(0)
				end

				gosmb = false
				krimemb = false
				gotovo = false
				status = false
				gcount = nil
			end
		else
			var_0_18 = {}
			var_0_92 = {}
			status = true

			sampSendChat("/members")

			while not gotovo do
				wait(0)
			end

			gosmb = false
			krimemb = false
			gotovo = false
			status = false
			gcount = nil
		end
	end)
end

function sendGoogleMessage(arg_120_0, arg_120_1)
	local var_120_0 = ""
	local var_120_1 = os.date("*t", os.time())
	local var_120_2 = ("%d.%d.%d"):format(var_120_1.day, var_120_1.month, var_120_1.year)
	local var_120_3, var_120_4 = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local var_120_5 = sampGetPlayerNickname(var_120_4)

	if arg_120_0 then
		var_120_0 = var_120_0 .. ("?method=%s&data=%s&date=%s&nick=%s"):format(arg_120_0, encodeURI(u8:encode(encodeJson(arg_120_1))), os.date("%d.%m.%Y"), var_120_5)
	else
		return
	end

	local var_120_6 = false

	lua_thread.create(function()
		local var_121_0 = require("moonloader").download_status
		local var_121_1 = getWorkingDirectory() .. "\\urlRequests.json"

		wait(50)
		downloadUrlToFile("https://script.google.com/macros/s/AKfycbyNpGMJwXRNOtMKH_h-jwOJ6FVLh3rScCxn_jRO94njTpL5KFhRqHow0NfBB0Z89DPa3w/exec" .. var_120_0, var_121_1, function(arg_122_0, arg_122_1, arg_122_2, arg_122_3)
			if arg_122_1 == var_121_0.STATUS_ENDDOWNLOADDATA then
				var_120_6 = true
			end
		end)

		while var_120_6 ~= true do
			wait(50)
		end

		local var_121_2 = io.open("moonloader/urlRequests.json", "r+")

		if var_121_2 then
			if var_121_2:read("*a") ~= nil then
				-- block empty
			else
				print("Входящий запрос от Google Script. Содержимое: Неверный формат объекта")
			end

			var_121_2:close()
		end

		wait(50)
		os.remove(var_121_1)
	end)
end

newmessage = false

function encodeURI(arg_123_0)
	if arg_123_0 then
		arg_123_0 = string.gsub(arg_123_0, "\n", "\r\n")
		arg_123_0 = string.gsub(arg_123_0, "([^%w ])", function(arg_124_0)
			return string.format("%%%02X", string.byte(arg_124_0))
		end)
		arg_123_0 = string.gsub(arg_123_0, " ", "+")
		arg_123_0 = string.gsub(arg_123_0, "%{......%}", "")
	end

	return arg_123_0
end

function var_0_5.onServerMessage(arg_125_0, arg_125_1)
	blacklistt = table.concat(blacklist, "\n")

	if arg_125_0 == -65366 and arg_125_1:match("SMS%: .+. Отправитель%: .+_.+") or arg_125_0 == -65366 and arg_125_1:match("SMS%: .+. Получатель%: .+_.+") then
		lua_thread.create(function()
			wait(100)

			namesms1 = arg_125_1:match(": (%w+_%w+)")
		end)
	end

	lua_thread.create(function()
		if arg_125_1:match("Установить закладку можно через") and arg_125_0 == -858993409 then
			wait(100)

			if arg_125_1:match("%:") then
				local var_127_0, var_127_1 = arg_125_1:match("Установить закладку можно через (%d+):(%d+)")
				local var_127_2 = var_127_0 * 60 + var_127_1
				local var_127_3 = os.clock()

				while os.clock() - var_127_3 < 300 do
					wait(0)

					timedsup = var_127_2 - (os.clock() - var_127_3)
				end
			else
				local var_127_4 = arg_125_1:match("Установить закладку можно через (%d+)")
				local var_127_5 = os.clock()

				while os.clock() - var_127_5 < 300 do
					wait(0)

					timedsup = var_127_4 - (os.clock() - var_127_5)
				end
			end
		end
	end)

	if arg_125_0 == -65366 and arg_125_1:match("Отправитель%: .+_.+") and blacklistt:match(arg_125_1:match("(%w+_%w+)")) and arg_125_1:match("SMS%: .+. Отправитель%: .+") then
		return false
	end

	if cfg.config.afish and arg_125_1:find("Вы проголодались!") and arg_125_0 ~= -421075226 then
		sampSendChat("/eatfish")
	end

	if arg_125_1:find("Вы надели") and arg_125_0 == -1263159297 then
		maskN = true
	end

	if navigation3.current3 == 3 then
		if arg_125_1 and arg_125_0 == 233509034 then
			return false
		end

		if arg_125_1 and arg_125_0 == -1713456726 then
			table.insert(LeadersTable, u8(arg_125_1))

			return false
		end
	end

	if navigation3.current3 == 4 then
		if arg_125_1 and arg_125_0 == -65366 then
			return false
		end

		if arg_125_1 and arg_125_0 == -169954390 then
			table.insert(tSupports, u8(arg_125_1))

			return false
		end
	end

	if arg_125_1:find("Вы передали") and arg_125_0 ~= -421075226 then
		text = arg_125_1:match("%d+ вирт")
		money1 = text:gsub(" вирт", "")
		money = money + money1
	end

	if arg_125_1:find("Рабочий день начат") and arg_125_0 ~= -1 and cfg.config.CL2 then
		lua_thread.create(function()
			wait(100)
			sampSendChat("/clist " .. tonumber(cfg.config.cl))

			rabden = true
		end)
	end

	if arg_125_1:find("Рабочий день окончен") and arg_125_0 ~= -1 then
		rabden = false

		lua_thread.create(function()
			if group == "Армия" then
				wait(500)
				sampSendChat("/clist 7")
			end
		end)
	end

	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

	local var_125_0 = sampGetPlayerNickname(myid)

	if arg_125_1:find("EVL(%d+)X") and arg_125_1:find(var_125_0) and arg_125_0 == -65366 then
		idMegaf = arg_125_1:match("EVL(%d+)X")
		nicknameMegaf = sampGetPlayerNickname(idMegaf)
		Megaf = true

		lua_thread.create(function()
			tt.v = true
			tt2.v = true

			local var_130_0 = os.clock()

			yeskey = true

			while os.clock() - var_130_0 < 15 do
				wait(0)

				timeryes = 15 - (os.clock() - var_130_0)
			end

			repeat
				wait(0)
			until timeryes == 0 or timeryes <= 0

			tt2.v = false
			tt.v = false
			yeskey = false
			Megaf = false
		end)
	end

	if status then
		if group == "Криминал" and arg_125_1:find("ID: %d+ | .+ | .+: .+[%d+]") then
			if not arg_125_1:find("AFK") then
				local var_125_1, var_125_2, var_125_3, var_125_4, var_125_5 = arg_125_1:match("ID: (%d+) | (.+) | (%g+).+: (.+)%[(%d+)%]")
				local var_125_6, var_125_7 = sampGetCharHandleBySampPlayerId(var_125_1)

				if var_125_6 then
					table.insert(var_0_18, var_125_1)
				end

				table.insert(var_0_92, var_0_91:new(var_125_1, var_125_4, var_125_5, "Недоступно", var_125_2, false, 0, var_125_3))
			else
				local var_125_8, var_125_9, var_125_10, var_125_11, var_125_12, var_125_13 = arg_125_1:match("ID: (%d+) | (.+) | (%g+).+: (.+)%[(%d+)%] | %{.+%}%[AFK%]: (%d+).+")
				local var_125_14, var_125_15 = sampGetCharHandleBySampPlayerId(var_125_8)

				if var_125_14 then
					table.insert(var_0_18, var_125_8)
				end

				table.insert(var_0_92, var_0_91:new(var_125_8, var_125_11, var_125_12, "Недоступно", var_125_9, true, var_125_13, var_125_10))
			end

			return false
		end

		if arg_125_1:find("ID: (%d+) | (.+) | (%g+) (.+): (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%}") then
			if not arg_125_1:find("AFK") then
				local var_125_16, var_125_17, var_125_18, var_125_19, var_125_20, var_125_21, var_125_22 = arg_125_1:match("ID: (%d+) | (.+) | (%g+) (.+): (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%}")
				local var_125_23, var_125_24 = sampGetCharHandleBySampPlayerId(var_125_16)

				if var_125_23 then
					table.insert(var_0_18, var_125_16)
				end

				table.insert(var_0_92, var_0_91:new(var_125_16, var_125_20, var_125_21, var_125_22, var_125_17, false, 0, var_125_18, var_125_19))
			else
				local var_125_25, var_125_26, var_125_27, var_125_28, var_125_29, var_125_30, var_125_31, var_125_32 = arg_125_1:match("ID: (%d+) | (.+) | (%g+) (.+): (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%} | %{.+%}%[AFK%]: (%d+).+")
				local var_125_33, var_125_34 = sampGetCharHandleBySampPlayerId(var_125_25)

				if var_125_33 then
					table.insert(var_0_18, var_125_25)
				end

				table.insert(var_0_92, var_0_91:new(var_125_25, var_125_29, var_125_30, var_125_31, var_125_26, true, var_125_32, var_125_27, var_125_28))
			end

			return false
		end

		if arg_125_1:find("ID: (%d+) | (.+) | (%g+) : (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%}") then
			if not arg_125_1:find("AFK") then
				local var_125_35, var_125_36, var_125_37, var_125_38, var_125_39, var_125_40 = arg_125_1:match("ID: (%d+) | (.+) | (%g+) : (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%}")
				local var_125_41, var_125_42 = sampGetCharHandleBySampPlayerId(var_125_35)

				if var_125_41 then
					table.insert(var_0_18, var_125_35)
				end

				table.insert(var_0_92, var_0_91:new(var_125_35, var_125_38, var_125_39, var_125_40, var_125_36, false, 0, var_125_37))
			else
				local var_125_43, var_125_44, var_125_45, var_125_46, var_125_47, var_125_48, var_125_49 = arg_125_1:match("ID: (%d+) | (.+) | (%g+) : (.+)%[(%d+)%] %- %{.+%}(.+)%{.+%} | %{.+%}%[AFK%]: (%d+).+")
				local var_125_50, var_125_51 = sampGetCharHandleBySampPlayerId(var_125_43)

				if var_125_50 then
					table.insert(var_0_18, var_125_43)
				end

				table.insert(var_0_92, var_0_91:new(var_125_43, var_125_46, var_125_47, var_125_48, var_125_44, true, var_125_49, var_125_45))
			end

			return false
		end

		if arg_125_1:find("ID: %d+ | .+ | %g+: .+%[%d+%]") then
			if not arg_125_1:find("AFK") then
				local var_125_52, var_125_53, var_125_54, var_125_55, var_125_56 = arg_125_1:match("ID: (%d+) | (.+) | (%g+) : (.+)%[(%d+)%]")
				local var_125_57, var_125_58 = sampGetCharHandleBySampPlayerId(var_125_52)

				if var_125_57 then
					table.insert(var_0_18, var_125_52)
				end

				table.insert(var_0_92, var_0_91:new(var_125_52, var_125_55, var_125_56, "Недоступно", var_125_53, false, 0, var_125_54))
			else
				local var_125_59, var_125_60, var_125_61, var_125_62, var_125_63, var_125_64 = arg_125_1:match("ID: (%d+) | (.+) | (%g+) : (.+)%[(%d+)%] | %{.+%}%[AFK%]: (%d+).+")
				local var_125_65, var_125_66 = sampGetCharHandleBySampPlayerId(var_125_59)

				if var_125_65 then
					table.insert(var_0_18, var_125_59)
				end

				table.insert(var_0_92, var_0_91:new(var_125_59, var_125_62, var_125_63, "Недоступно", var_125_60, true, var_125_64, var_125_61))
			end

			return false
		end

		if arg_125_1:match("Всего: %d+ человек") then
			gotovo = true

			return false
		end

		if arg_125_0 == -1 then
			return false
		end

		if arg_125_0 == 647175338 then
			return false
		end
	end

	lua_thread.create(function()
		if arg_125_1:find("{00AB06}Чтобы завести двигатель, нажмите клавишу {FFFFFF}\"2\"{00AB06} или введите команду {FFFFFF}\"/en\"") and cfg.config.car2 then
			while not isCharInAnyCar(PLAYER_PED) do
				wait(0)
			end

			if not isCarEngineOn(storeCarCharIsInNoSave(PLAYER_PED)) then
				while sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() do
					wait(0)
				end

				setVirtualKeyDown(key.VK_2, true)
				wait(150)
				setVirtualKeyDown(key.VK_2, false)
			end
		end

		if arg_125_1:find("Рабочий день начат") and arg_125_0 == 1687547391 then
			rabden = true
		end

		if arg_125_1:find("Следующее использование маски возможно через 15 минут") and arg_125_0 == -1263159297 then
			maskN = false

			local var_131_0 = os.clock()

			while os.clock() - var_131_0 < 900 do
				wait(0)

				timemask = 900 - (os.clock() - var_131_0)
			end
		end

		if arg_125_1:find("заспавнил свободные транспортные средства организации") and arg_125_0 == 866792447 then
			local var_131_1 = os.clock()

			while os.clock() - var_131_1 < 600 do
				wait(0)

				timeffix = 600 - (os.clock() - var_131_1)
			end
		end

		if arg_125_1:find("рассмотрению не подлежит") and arg_125_0 == -8224086 then
			kek = arg_125_1:match("(.+)Mayor")

			local var_131_2 = ("{%06X}"):format(bit.rshift(arg_125_0, 8))

			table.insert(key4, os.date(var_131_2 .. "[%H:%M:%S] ") .. arg_125_1)
		end

		if arg_125_1:find("") then
			local var_131_3 = ("{%06X}"):format(bit.rshift(arg_125_0, 8))

			table.insert(key3, os.date("[%H:%M:%S] ") .. arg_125_1)
		end

		if arg_125_1:find("") and arg_125_0 == -8224086 then
			local var_131_4 = ("{%06X}"):format(bit.rshift(arg_125_0, 8))

			table.insert(key2, os.date(var_131_4 .. "[%H:%M:%S] ") .. arg_125_1)

			local var_131_5 = os.clock()

			while os.clock() - var_131_5 < 10 do
				wait(0)

				timedep = 10 - (os.clock() - var_131_5)
			end
		end

		if arg_125_0 == -1920073984 and arg_125_1:find("") then
			local var_131_6 = ("{%06X}"):format(bit.rshift(arg_125_0, 8))

			table.insert(key5, os.date(var_131_6 .. "[%H:%M:%S] ") .. arg_125_1)
		end

		if arg_125_0 == -65366 and (arg_125_1:match("SMS%: .+. Отправитель%: .+") or arg_125_0 == -65366 and arg_125_1:match("SMS%: .+. Получатель%: .+")) then
			friendlist = table.concat(friends, "\n")

			if arg_125_1:match("SMS%: .+. Отправитель%: .+%[%d+%]") then
				smsid = arg_125_1:match("SMS%: .+. Отправитель%: .+%[(%d+)%]")

				local var_131_7 = arg_125_1:match("Отправитель: (%w+_%w+)")

				if friendlist:match(var_131_7) then
					table.insert(smsfriends, os.date("[%d.%m.%y %X] Вам: ") .. arg_125_1:match("SMS%: (.+)"))

					newmessage = true

					wait(100)

					newmessage = false

					jsonSave(var_0_14, smsfriends)
				end
			end

			if arg_125_1:match("SMS%: .+. Получатель%: .+%[%d+%]") then
				smstoid = arg_125_1:match("SMS%: .+. Получатель%: .+%[(%d+)%]")

				local var_131_8 = arg_125_1:match("Получатель: (%w+_%w+)")

				if friendlist:match(var_131_8) then
					table.insert(smsfriends, os.date("[%d.%m.%y %X] Вы: ") .. arg_125_1:match("SMS%: (.+)"))

					newmessage = true

					wait(100)

					newmessage = false

					jsonSave(var_0_14, smsfriends)
				end
			end

			local var_131_9 = ("{%06X}"):format(bit.rshift(arg_125_0, 8))

			table.insert(key1, os.date(var_131_9 .. "[%H:%M:%S] ") .. arg_125_1)
		end
	end)

	if cfg.config.id1 and arg_125_0 == -1 and arg_125_1:find("(%w+_%w+) | LVL.+") then
		_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

		local var_125_67 = sampGetPlayerNickname(myid)
		local var_125_68 = ("{%06X}"):format(bit.rshift(arg_125_0, 8))

		nickname = arg_125_1:match(" (%w+_%w+).+")
		idp = getPlayerIdByNickname(nickname)

		local var_125_69 = ("%06X"):format(bit.band(sampGetPlayerColor(idp), 16777215))
		local var_125_70 = ("%06X"):format(bit.band(sampGetPlayerColor(myid), 16777215))

		if nickname == nil then
			-- block empty
		elseif nickname == var_125_67 then
			arg_125_1 = arg_125_1:gsub("(%w+_%w+)", "{" .. var_125_70 .. "}" .. nickname .. "" .. var_125_68)
		else
			arg_125_1 = arg_125_1:gsub("(%w+_%w+)", "{" .. var_125_69 .. "}" .. nickname .. "" .. var_125_68)
		end

		return {
			arg_125_0,
			arg_125_1
		}
	end

	if cfg.config.membmod and arg_125_1:match("^ ID: %d+.+") then
		local var_125_71 = ("{%06X}"):format(bit.rshift(arg_125_0, 8))

		nickname = arg_125_1:match(" (%w+_%w+).+")

		local var_125_72 = arg_125_1:match("^ ID: (%d+).+")
		local var_125_73 = ("%06X"):format(bit.band(sampGetPlayerColor(var_125_72), 16777215))

		arg_125_1 = arg_125_1:gsub("(%w+_%w+)", "{" .. var_125_73 .. "}" .. nickname .. "" .. var_125_71)

		return {
			arg_125_0,
			arg_125_1
		}
	end

	if cfg.config.radmod and (arg_125_0 == 33357768 or arg_125_0 == -1920073984) and arg_125_1:match("%S+%: .+") then
		local var_125_74 = arg_125_1:match("(%S+)%: .+"):gsub("%[%d+%]", ""):gsub(" ", "")
		local var_125_75 = sampGetPlayerIdByNickname(var_125_74)

		if var_125_75 then
			arg_125_1 = arg_125_1:gsub(var_125_74, ("{%s}%s{%s}"):format(("%06X"):format(bit.band(sampGetPlayerColor(var_125_75), 16777215)), var_125_74, ("%06X"):format(bit.rshift(arg_125_0, 8))))
		end

		return {
			arg_125_0,
			arg_125_1
		}
	end
end

function onScriptTerminate(arg_132_0)
	if arg_132_0 == thisScript() and var_0_4.save(cfg, var_0_24) then
		sampfuncsLog(tag .. "Ваш онлайн сохранён!")
	end

	if arg_132_0 == script.this then
		showCursor(false)
		sampAddChatMessage(tag .. "Скрипт отключен. Подробнее в консоли. (~)", -1)
		print("{ff0000}Неизвестная ошибка. {ffffff}Напишите автору скрипта. {4169E1}VK{ffffff}: nestroqq")
	end
end

function var_0_5.onPlayerQuit(arg_133_0, arg_133_1)
	if cfg.config.quitm then
		local var_133_0, var_133_1 = sampGetCharHandleBySampPlayerId(arg_133_0)
		local var_133_2 = sampGetPlayerNickname(arg_133_0)

		if var_133_0 then
			sampAddChatMessage(tag .. "Отключился игрок {698cc7}" .. var_133_2 .. "[" .. arg_133_0 .. "]{ffffff}. Причина: {698cc7}" .. var_0_30[arg_133_1], -1)
		end
	end
end

local var_0_130 = {
	19036,
	19037,
	19038,
	18911,
	18912,
	18913,
	18914,
	18915,
	18916,
	18917,
	18918,
	18919,
	18920,
	11704
}

function var_0_5.onShowTextDraw(arg_134_0, arg_134_1)
	if fmask then
		for iter_134_0, iter_134_1 in ipairs(var_0_130) do
			if arg_134_1.modelId == iter_134_1 then
				sampSendClickTextdraw(arg_134_0)

				find2 = true

				return true
			end
		end

		if arg_134_0 == 2183 and not find then
			if arg_134_1.text == "1" then
				sampSendClickTextdraw(2184)
			elseif arg_134_1.text == "2" then
				sampAddChatMessage(tag .. "Ошибка, у вас нет маски", -1)
				sampSendClickTextdraw(90)

				fmask = false
			end
		end
	end
end

function fastMask()
	fmask = true
	find2 = false

	sampSendChat("/items")
end

function RRATSC()
	thisScript():reload()
end

function us()
	local var_137_0 = (160 - getCharHealth(PLAYER_PED)) / 10

	if var_137_0 > 15 then
		var_137_0 = 15
	end

	sampSendChat("/usedrugs " .. math.ceil(var_137_0))
end

function var_0_5.onCreate3DText(arg_138_0, arg_138_1, arg_138_2, arg_138_3, arg_138_4, arg_138_5, arg_138_6, arg_138_7)
	for iter_138_0 = 0, 2048 do
		if sampIs3dTextDefined(iter_138_0) then
			local var_138_0, var_138_1, var_138_2, var_138_3, var_138_4, var_138_5, var_138_6, var_138_7, var_138_8 = sampGet3dTextInfoById(iter_138_0)

			if var_138_0:match("Склад полиции") then
				mor = var_138_0
				temp = split(var_138_0, "\n")
				morlspd = var_138_0:match("Склад полиции LS: ..........."):gsub("{.+}", ""):gsub("Склад полиции LS:", "LSPD -")
				morsfpd = var_138_0:match("Склад полиции SF: ..........."):gsub("{.+}", ""):gsub("Склад полиции SF:", "SFPD -")
				morlvpd = var_138_0:match("Склад полиции LV: ..........."):gsub("{.+}", ""):gsub("Склад полиции LV:", "LVPD -")
				morsfa = var_138_0:match("Склад армии SF: ..........."):gsub("{.+}", ""):gsub("Склад армии SF:", "SFa -")
				morport = var_138_0:match("Склад Порта LS: ..........."):gsub("{.+}", ""):gsub("Склад Порта LS:", "LSa -")
				morfbi = var_138_0:match("Склад FBI: ..........."):gsub("{.+}", ""):gsub("Склад FBI:", "FBI -")

				lua_thread.create(function()
					local var_139_0 = os.clock()

					while os.clock() - var_139_0 < 120 do
						wait(0)

						Actual = 30 - math.floor(os.clock() - var_139_0)
					end
				end)
			end
		end
	end
end

function monitoring()
	if Actual <= 0 then
		mor = "Нет связи с мониторингом"
	end

	if mor == "Нет связи с мониторингом" then
		sampAddChatMessage(tag .. "Нет связи с мониторингом", -1)
	else
		for iter_140_0, iter_140_1 in pairs(temp) do
			var_0_87[iter_140_0] = iter_140_1
		end

		if var_0_87[6] ~= nil then
			for iter_140_2 = 1, table.getn(var_0_87) do
				number1, number2, var_0_88[iter_140_2] = string.match(var_0_87[iter_140_2], "(%d+)[^%d]+(%d+)[^%d]+(%d+)")
				var_0_88[iter_140_2] = var_0_88[iter_140_2] / 1000
			end

			if cfg.config.TAG5 then
				if cfg.config.rtagkv then
					sampSendChat("/r [" .. cfg.config.tag4 .. "]: Мониторинг: LSPD - " .. var_0_88[1] .. " | SFPD - " .. var_0_88[2] .. " | LVPD - " .. var_0_88[3] .. " | FBI - " .. var_0_88[6] .. " | SFa - " .. var_0_88[4])
				else
					sampSendChat("/r " .. cfg.config.tag4 .. ": Мониторинг: LSPD - " .. var_0_88[1] .. " | SFPD - " .. var_0_88[2] .. " | LVPD - " .. var_0_88[3] .. " | FBI - " .. var_0_88[6] .. " | SFa - " .. var_0_88[4])
				end
			else
				sampSendChat("/r Мониторинг: LSPD - " .. var_0_88[1] .. " | SFPD - " .. var_0_88[2] .. " | LVPD - " .. var_0_88[3] .. " | FBI - " .. var_0_88[6] .. " | SFa - " .. var_0_88[4])
			end
		end
	end
end

function bindmenu2()
	window.v = false
	ATSC.settings.v = false
	commandsa.v = false
	menu.v = false
	var_0_56.v = false
	bMainWindow.v = not bMainWindow.v
end

function bindmenu3()
	shpwindow.v = false
	window.v = false
	ATSC.settings.v = false
	commandsa.v = false
	menu.v = false
	bMainWindow.v = false
	var_0_56.v = not var_0_56.v
end

function myonline2()
	menu.v = not menu.v
	var_0_66.v = true
end

function fshp()
	menu.v = false
	shpwindow.v = not shpwindow.v
end

function scm()
	shpwindow.v = false
	var_0_56.v = false
	bMainWindow.v = false
	window.v = false
	var_0_66.v = false
	var_0_67.v = false
	memba.v = false
	ATSC.settings.v = false
	commandsa.v = false
	menu.v = true

	lua_thread.create(function()
		Anim = 0.1

		wait(12)

		Anim = 0.2

		wait(12)

		Anim = 0.3

		wait(12)

		Anim = 0.4

		wait(12)

		Anim = 0.5

		wait(12)

		Anim = 0.6

		wait(12)

		Anim = 0.7

		wait(12)

		Anim = 0.8

		wait(12)

		Anim = 0.9
	end)
end

function settings2()
	var_0_56.v = false
	bMainWindow.v = false
	window.v = false
	menu.v = false
	commandsa.v = false
	ATSC.settings.v = true
end

function commands2()
	var_0_56.v = false
	bMainWindow.v = false
	window.v = false
	menu.v = false
	ATSC.settings.v = false
	commandsa.v = true
end

function SC2()
	var_0_56.v = false
	bMainWindow.v = false
	menu.v = false
	ATSC.settings.v = false
	commandsa.v = false
	window.v = true
end

function get_clock(arg_150_0)
	local var_150_0 = 86400 - os.date("%H", 0) * 3600

	return os.date(math.floor(arg_150_0 / 3600) .. ":%M:%S", arg_150_0 + var_150_0)
end

function myon()
	sampAddChatMessage(tag .. "Отыграно на работе: {ff0000}" .. get_clock(cfg.onDay.onlineWork), -1)
end

function var_0_91.new(arg_152_0, arg_152_1, arg_152_2, arg_152_3, arg_152_4, arg_152_5, arg_152_6, arg_152_7, arg_152_8)
	local var_152_0 = {
		id = arg_152_1,
		nickname = arg_152_8,
		iRang = tonumber(arg_152_3),
		sRang = u8(arg_152_2),
		status = u8(arg_152_4),
		invite = arg_152_5,
		afk = arg_152_6,
		sec = tonumber(arg_152_7)
	}

	setmetatable(var_152_0, arg_152_0)

	arg_152_0.__index = arg_152_0

	return var_152_0
end

function time()
	startTime = os.time()
	connectingTime = 0

	while true do
		wait(1000)

		var_0_65 = os.date("%H:%M:%S", os.time())

		if sampGetGamestate() == 3 then
			var_0_71.v = var_0_71.v + 1
			var_0_73.v = os.time() - startTime
			var_0_72.v = var_0_73.v - var_0_71.v

			if rabden then
				cfg.onDay.onlineWork = cfg.onDay.onlineWork + 1
			end

			cfg.onDay.online = cfg.onDay.online + 1
			cfg.onDay.full = var_0_74.v + var_0_73.v
			cfg.onDay.afk = cfg.onDay.full - cfg.onDay.online

			if rabden then
				cfg.onWeek.onlineWork = cfg.onWeek.onlineWork + 1
			end

			cfg.onWeek.online = cfg.onWeek.online + 1
			cfg.onWeek.full = var_0_75.v + var_0_73.v
			cfg.onWeek.afk = cfg.onWeek.full - cfg.onWeek.online

			local var_153_0 = tonumber(os.date("%w", os.time()))

			cfg.myWeekOnline[var_153_0] = cfg.onDay.onlineWork
			connectingTime = 0
		else
			connectingTime = connectingTime + 1
			startTime = startTime + 1
		end
	end
end

function GreyTheme()
	imgui.SwitchContext()

	local var_154_0 = imgui.GetStyle()
	local var_154_1 = var_154_0.Colors
	local var_154_2 = imgui.Col
	local var_154_3 = imgui.ImVec4
	local var_154_4 = imgui.ImVec2

	var_154_0.WindowPadding = var_154_4(6, 4)
	var_154_0.WindowRounding = 5
	var_154_0.ChildWindowRounding = 5
	var_154_0.FramePadding = var_154_4(5, 2)
	var_154_0.FrameRounding = 5
	var_154_0.ItemSpacing = var_154_4(7, 5)
	var_154_0.ItemInnerSpacing = var_154_4(1, 1)
	var_154_0.TouchExtraPadding = var_154_4(0, 0)
	var_154_0.IndentSpacing = 6
	var_154_0.ScrollbarSize = 12
	var_154_0.ScrollbarRounding = 5
	var_154_0.GrabMinSize = 20
	var_154_0.GrabRounding = 2
	var_154_0.WindowTitleAlign = var_154_4(0.5, 0.5)
	var_154_1[var_154_2.Text] = var_154_3(cfg.config.colorVec4Text1, cfg.config.colorVec4Text2, cfg.config.colorVec4Text3, 1)
	var_154_1[var_154_2.TextDisabled] = var_154_3(0.28, 0.3, 0.35, 1)
	var_154_1[var_154_2.WindowBg] = var_154_3(cfg.config.colorVec4Fon1, cfg.config.colorVec4Fon2, cfg.config.colorVec4Fon3, cfg.config.FonP)
	var_154_1[var_154_2.ChildWindowBg] = var_154_3(0.19, 0.22, 0.26, 0)
	var_154_1[var_154_2.PopupBg] = var_154_3(0.05, 0.05, 0.1, 0.9)
	var_154_1[var_154_2.Border] = var_154_3(0.19, 0.22, 0.26, 1)
	var_154_1[var_154_2.BorderShadow] = var_154_3(0, 0, 0, 0)
	var_154_1[var_154_2.FrameBg] = var_154_3(cfg.config.colorVec4Pole1, cfg.config.colorVec4Pole2, cfg.config.colorVec4Pole3, 1)
	var_154_1[var_154_2.FrameBgHovered] = var_154_3(cfg.config.colorVec4Pole1 + 0.03, cfg.config.colorVec4Pole2 + 0.03, cfg.config.colorVec4Pole3 + 0.04, 1)
	var_154_1[var_154_2.FrameBgActive] = var_154_3(cfg.config.colorVec4Pole1 + 0.03, cfg.config.colorVec4Pole2 + 0.03, cfg.config.colorVec4Pole3 + 0.03, 1)
	var_154_1[var_154_2.TitleBg] = var_154_3(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3, 1)
	var_154_1[var_154_2.TitleBgActive] = var_154_3(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3, 1)
	var_154_1[var_154_2.TitleBgCollapsed] = var_154_3(cfg.config.colorVec4Title1, cfg.config.colorVec4Title2, cfg.config.colorVec4Title3, 0.59)
	var_154_1[var_154_2.MenuBarBg] = var_154_3(0.19, 0.22, 0.26, 1)
	var_154_1[var_154_2.ScrollbarBg] = var_154_3(0.2, 0.25, 0.3, 0.6)
	var_154_1[var_154_2.ScrollbarGrab] = var_154_3(0.41, 0.55, 0.78, 1)
	var_154_1[var_154_2.ScrollbarGrabHovered] = var_154_3(0.49, 0.63, 0.86, 1)
	var_154_1[var_154_2.ScrollbarGrabActive] = var_154_3(0.49, 0.63, 0.86, 1)
	var_154_1[var_154_2.ComboBg] = var_154_3(0.2, 0.2, 0.2, 0.99)
	var_154_1[var_154_2.CheckMark] = var_154_3(0.9, 0.9, 0.9, 0.5)
	var_154_1[var_154_2.SliderGrab] = var_154_3(1, 1, 1, 0.3)
	var_154_1[var_154_2.SliderGrabActive] = var_154_3(0.8, 0.5, 0.5, 1)
	var_154_1[var_154_2.Button] = var_154_3(cfg.config.colorVec4Button1, cfg.config.colorVec4Button2, cfg.config.colorVec4Button3, 1)
	var_154_1[var_154_2.ButtonHovered] = var_154_3(cfg.config.colorVec4Button1 + 0.07, cfg.config.colorVec4Button2 + 0.07, cfg.config.colorVec4Button3 + 0.07, 1)
	var_154_1[var_154_2.ButtonActive] = var_154_3(cfg.config.colorVec4Button1 + 0.07, cfg.config.colorVec4Button2 + 0.07, cfg.config.colorVec4Button3 + 0.07, 1)
	var_154_1[var_154_2.Header] = var_154_3(cfg.config.colorVec4Title1 + 0.03, cfg.config.colorVec4Title2 + 0.02, cfg.config.colorVec4Title3 + 0.02, 1)
	var_154_1[var_154_2.HeaderHovered] = var_154_3(cfg.config.colorVec4Title1 + 0.03, cfg.config.colorVec4Title2 + 0.02, cfg.config.colorVec4Title3 + 0.02, 1)
	var_154_1[var_154_2.HeaderActive] = var_154_3(cfg.config.colorVec4Title1 + 0.03, cfg.config.colorVec4Title2 + 0.02, cfg.config.colorVec4Title3 + 0.02, 1)
	var_154_1[var_154_2.Separator] = var_154_3(0.41, 0.55, 0.78, 1)
	var_154_1[var_154_2.SeparatorHovered] = var_154_3(0.41, 0.55, 0.78, 1)
	var_154_1[var_154_2.SeparatorActive] = var_154_3(0.41, 0.55, 0.78, 1)
	var_154_1[var_154_2.ResizeGrip] = var_154_3(0.41, 0.55, 0.78, 1)
	var_154_1[var_154_2.ResizeGripHovered] = var_154_3(0.49, 0.61, 0.83, 1)
	var_154_1[var_154_2.ResizeGripActive] = var_154_3(0.49, 0.62, 0.83, 1)
	var_154_1[var_154_2.CloseButton] = var_154_3(cfg.config.colorVec4Button1, cfg.config.colorVec4Button2, cfg.config.colorVec4Button3, 1)
	var_154_1[var_154_2.CloseButtonHovered] = var_154_3(cfg.config.colorVec4Button1 + 0.09, cfg.config.colorVec4Button2 + 0.08, cfg.config.colorVec4Button2 - 0.05, 1)
	var_154_1[var_154_2.CloseButtonActive] = var_154_3(cfg.config.colorVec4Button1, cfg.config.colorVec4Button2, cfg.config.colorVec4Button3 - 0.11, 1)
	var_154_1[var_154_2.PlotLines] = var_154_3(1, 1, 1, 1)
	var_154_1[var_154_2.PlotLinesHovered] = var_154_3(0.9, 0.7, 0, 1)
	var_154_1[var_154_2.PlotHistogram] = var_154_3(0.9, 0.7, 0, 1)
	var_154_1[var_154_2.PlotHistogramHovered] = var_154_3(1, 0.6, 0, 1)
	var_154_1[var_154_2.TextSelectedBg] = var_154_3(0.41, 0.95, 0.78, 1)
	var_154_1[var_154_2.ModalWindowDarkening] = var_154_3(0.16, 0.18, 0.22, 0.76)
end

GreyTheme()

function kvadrat()
	local var_155_0 = {
		"А",
		"Б",
		"В",
		"Г",
		"Д",
		"Ж",
		"З",
		"И",
		"К",
		"Л",
		"М",
		"Н",
		"О",
		"П",
		"Р",
		"С",
		"Т",
		"У",
		"Ф",
		"Х",
		"Ц",
		"Ч",
		"Ш",
		"Я"
	}
	local var_155_1, var_155_2, var_155_3 = getCharCoordinates(playerPed)
	local var_155_4 = math.ceil((var_155_1 + 3000) / 250)
	local var_155_5 = math.ceil((var_155_2 * -1 + 3000) / 250)

	if var_155_0[var_155_5] ~= nil then
		return var_155_0[var_155_5] .. "-" .. var_155_4
	else
		return "Не определено"
	end
end

function kvadrat1(arg_156_0)
	return ({
		ж = 6,
		Х = 20,
		и = 8,
		г = 4,
		в = 3,
		А = 1,
		Ш = 23,
		Ц = 21,
		п = 14,
		Ф = 19,
		И = 8,
		х = 20,
		о = 13,
		С = 16,
		М = 11,
		у = 18,
		П = 14,
		Д = 5,
		к = 9,
		д = 5,
		О = 13,
		м = 11,
		Т = 17,
		У = 18,
		Б = 2,
		р = 15,
		т = 17,
		Г = 4,
		с = 16,
		З = 7,
		ф = 19,
		В = 3,
		б = 2,
		Ж = 6,
		ц = 21,
		ш = 23,
		а = 1,
		я = 24,
		Р = 15,
		Я = 24,
		н = 12,
		л = 10,
		Н = 12,
		ч = 22,
		Л = 10,
		з = 7,
		К = 9,
		Ч = 22
	})[arg_156_0]
end

function rtag(arg_157_0)
	if #arg_157_0 ~= 0 then
		if cfg.config.TAG5 == true then
			if cfg.config.rtagkv then
				sampSendChat(string.format("/r [%s]: %s", cfg.config.tag4, arg_157_0))
			else
				sampSendChat(string.format("/r %s: %s", cfg.config.tag4, arg_157_0))
			end
		else
			sampSendChat(string.format("/r %s", arg_157_0))
		end
	else
		sampAddChatMessage(tag .. "Введите /r [текст]", -1)
	end
end

function ftag(arg_158_0)
	if #arg_158_0 ~= 0 then
		if cfg.config.TAG5 == true then
			if cfg.config.rtagkv then
				sampSendChat(string.format("/r [%s]: %s", cfg.config.tag4, arg_158_0))
			else
				sampSendChat(string.format("/r %s: %s", cfg.config.tag4, arg_158_0))
			end
		else
			sampSendChat(string.format("/r %s", arg_158_0))
		end
	else
		sampAddChatMessage(tag .. "Введите /r [текст]", -1)
	end
end

function getFreeSeat()
	seat = 3

	if isCharInAnyCar(PLAYER_PED) then
		local var_159_0 = storeCarCharIsInNoSave(PLAYER_PED)

		for iter_159_0 = 1, 3 do
			if isCarPassengerSeatFree(var_159_0, iter_159_0) then
				seat = iter_159_0
			end
		end
	end

	return seat
end

function setgroup()
	repeat
		wait(0)
	until group == "Полиция" or group == "ФБР" or group == "Армия" or group == frak

	sampAddChatMessage(tag .. "Загружены функции группы: {ff0000}" .. group, -1)
end

local function var_0_131(arg_161_0)
	return (arg_161_0:gsub("#(%d+)", function(arg_162_0)
		arg_162_0 = tonumber(arg_162_0)

		if sampIsPlayerConnected(arg_162_0) then
			return sampGetPlayerNickname(arg_162_0):gsub("_", " ")
		end
	end))
end

function var_0_5.onSendChat(arg_163_0)
	if cfg.config.maskRP and maskN then
		if arg_163_0 == ")" or arg_163_0 == "(" or arg_163_0 == "))" or arg_163_0 == "((" or arg_163_0 == "xD" or arg_163_0 == ":D" or arg_163_0 == ":d" or arg_163_0 == "XD" or arg_163_0 == "xd" then
			return {
				arg_163_0
			}
		end

		return {
			"[Голос из под маски]: " .. arg_163_0
		}
	end

	return {
		var_0_131(arg_163_0)
	}
end

function var_0_5.onSendCommand(arg_164_0)
	return {
		var_0_131(arg_164_0)
	}
end

function smslog()
	navigation.current = 3
	log.v = true
end

function deplog()
	navigation.current = 2
	log.v = true
end

function radlog()
	navigation.current = 1
	log.v = true
end

function chatlog2()
	navigation.current = 5
	log.v = true
end

function ooplist1(arg_169_0)
	lua_thread.create(function()
		var1 = string.match(arg_169_0, "(%d+)")

		if var1 == nil or var1 == "" then
			navigation.current = 4
			log.v = true
		else
			for iter_170_0 in table.concat(key4, "\n"):gmatch("[^\n\r]+") do
				sampSendChat("/t " .. var1 .. " " .. iter_170_0:gsub(kek, ""))
				wait(1000)
			end
		end
	end)
end

function autoupdate(arg_171_0, arg_171_1, arg_171_2)
	local var_171_0 = require("moonloader").download_status
	local var_171_1 = getWorkingDirectory() .. "\\" .. thisScript().name .. "-version.json"

	if doesFileExist(var_171_1) then
		os.remove(var_171_1)
	end

	downloadUrlToFile(arg_171_0, var_171_1, function(arg_172_0, arg_172_1, arg_172_2, arg_172_3)
		if arg_172_1 == var_171_0.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(var_171_1) then
				local var_172_0 = io.open(var_171_1, "r")

				if var_172_0 then
					local var_172_1 = decodeJson(var_172_0:read("*a"))

					updatelink = var_172_1.updateurl
					updateversion = var_172_1.latest

					var_172_0:close()
					os.remove(var_171_1)

					if updateversion ~= thisScript().version then
						lua_thread.create(function(arg_173_0)
							local var_173_0 = require("moonloader").download_status
							local var_173_1 = -1

							sampAddChatMessage(arg_173_0 .. "Обнаружено обновление. Пытаюсь обновиться c " .. thisScript().version .. " на " .. updateversion, var_173_1)
							wait(250)
							downloadUrlToFile(updatelink, thisScript().path, function(arg_174_0, arg_174_1, arg_174_2, arg_174_3)
								if arg_174_1 == var_173_0.STATUS_DOWNLOADINGDATA then
									print(string.format("Загружено %d из %d.", arg_174_2, arg_174_3))
								elseif arg_174_1 == var_173_0.STATUS_ENDDOWNLOADDATA then
									print("Загрузка обновления завершена.")
									sampAddChatMessage(arg_173_0 .. "Обновление завершено!", var_173_1)

									goupdatestatus = true

									lua_thread.create(function()
										wait(500)
										thisScript():reload()
									end)
								end

								if arg_174_1 == var_173_0.STATUSEX_ENDDOWNLOAD and goupdatestatus == nil then
									sampAddChatMessage(arg_173_0 .. "Обновление прошло неудачно. Запускаю устаревшую версию..", var_173_1)

									update = false
								end
							end)
						end, arg_171_1)
					else
						update = false

						print("v" .. thisScript().version .. ": Обновление не требуется.")
					end
				end
			else
				print("v" .. thisScript().version .. ": Не могу проверить обновление. Смиритесь или проверьте самостоятельно на " .. arg_171_2)

				update = false
			end
		end
	end)

	while update ~= false do
		wait(100)
	end
end

function var_0_5.onSendTakeDamage(arg_176_0, arg_176_1, arg_176_2)
	if (group == "Полиция" or group == "ФБР") and cfg.config.fastsu and sampIsPlayerConnected(arg_176_0) then
		skinT = sampGetFraktionBySkin(arg_176_0)

		if skinT == "FBI" or skinT == "Полиция" then
			-- block empty
		else
			Uron = true
			weaponROZ = var_0_6.get_name(arg_176_2)
			playerIdROZ = arg_176_0
			nicknameROZ = sampGetPlayerNickname(arg_176_0)

			lua_thread.create(function()
				tt.v = true
				tt2.v = true

				local var_177_0 = os.clock()

				yeskey = true

				while os.clock() - var_177_0 < 15 do
					wait(0)

					timeryes = 15 - (os.clock() - var_177_0)
				end

				repeat
					wait(0)
				until timeryes == 0 or timeryes <= 0

				tt2.v = false
				tt.v = false
				yeskey = false
				Uron = false
			end)
		end
	end
end

function da()
	if not sampIsChatInputActive() and not sampIsDialogActive() then
		if opyatstat then
			lua_thread.create(checkStats)

			opyatstat = false
		end

		if cfg.config.fastsu and yeskey then
			yeskey = false
			tt2.v = false
			tt.v = false

			if Uron then
				UronF()
			end

			if Megaf then
				MegafF()
			end
		end
	end
end

function UronF()
	if playerIdROZ == -1 then
		sampAddChatMessage(tag .. "ID не найден", -1)
	elseif weaponROZ == "Fist" then
		sampSendChat("/su " .. playerIdROZ .. " 2 Избиение")
	else
		sampSendChat("/su " .. playerIdROZ .. " 4 Вооружённое нападение на гос.сотрудника")
	end

	Uron = false
end

function sumenu(arg_180_0)
	return {
		{
			title = "{5b83c2}« Раздел №1 »",
			onclick = function()
				return
			end
		},
		{
			title = "{ffffff}» Избиение - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Избиение")
			end
		},
		{
			title = "{ffffff}» Вооруженное нападение на гражданского - {ff0000}3 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 3 Вооруженное нападение на гражданского")
			end
		},
		{
			title = "{ffffff}» Вооруженное нападение на гос.сотрудника - {ff0000}4 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 4 Вооруженное нападение на гос.сотрудника")
			end
		},
		{
			title = "{ffffff}» Убийство гражданского - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Убийство гражданского")
			end
		},
		{
			title = "{ffffff}» Убийство военнослужащего - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Убийство военнослужащего")
			end
		},
		{
			title = "{ffffff}» Убийство полицейского - {ff0000}4 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 4 Убийство полицейского")
			end
		},
		{
			title = "{ffffff}» Убийство агента ФБР - {ff0000}6 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 6 Убийство агента ФБР")
			end
		},
		{
			title = "{ffffff}» Угон транспортного средства - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Угон транспортного средства")
			end
		},
		{
			title = "{ffffff}» Неподчинение - {ff0000}1 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Неподчинение")
			end
		},
		{
			title = "{ffffff}» Оскорбление - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Оскорбление")
			end
		},
		{
			title = "{ffffff}» Уход от сотрудника ПО - {ff0000}2 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Уход от сотрудника ПО")
			end
		},
		{
			title = "{ffffff}» Уход с места ДТП - {ff0000}3 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 3 Уход с места ДТП")
			end
		},
		{
			title = "{ffffff}» Наезд на пешехода - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Наезд на пешехода")
			end
		},
		{
			title = "{ffffff}» Вождение в нетрезвом виде - {ff0000}1 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Вождение в нетрезвом виде")
			end
		},
		{
			title = "{ffffff}» Побег - {ff0000}6 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 6 Побег")
			end
		},
		{
			title = "{ffffff}» Оружие без лицензии - {ff0000}1 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Оружие без лицензии")
			end
		},
		{
			title = "{ffffff}» Попрошайничество - {ff0000}1 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Попрошайничество")
			end
		},
		{
			title = "{ffffff}» Игнорирование спец.сигнала - {ff0000}1 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Игнорирование спец.сигнала")
			end
		},
		{
			title = "{ffffff}» Проникновение на охраняемую территорию - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Проникновение на охр. территорию")
			end
		},
		{
			title = "{ffffff}» Проникновение на частную территорию - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Проникновение на частную территорию")
			end
		},
		{
			title = "{ffffff}» Провокация - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Провокация")
			end
		},
		{
			title = "{ffffff}» Угрозы - {ff0000}1 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Угрозы")
			end
		},
		{
			title = "{ffffff}» Предложение интим. услуг - {ff0000}1 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 1 Предложение интимных услуг")
			end
		},
		{
			title = "{ffffff}» Изнасилование - {ff0000}3 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 3 Изнасилование")
			end
		},
		{
			title = "{ffffff}» Чистосердечное признание - {ff0000}1 уровень розыска.",
			onclick = function()
				if isCharInAnyCar(PLAYER_PED) then
					sampSendChat("/clear " .. arg_180_0)
					wait(1400)
					sampSendChat("/su " .. arg_180_0 .. " 1 Чистосердечное признание")
				else
					sampAddChatMessage(tag .. "Вы должны находиться в машине", -1)
				end
			end
		},
		{
			title = "{ffbc54}« Раздел №2 »",
			onclick = function()
				return
			end
		},
		{
			title = "{ffffff}» Хранение материалов - {ff0000}3 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 3 Хранение материалов")
			end
		},
		{
			title = "{ffffff}» Хранение наркотиков - {ff0000}3 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 3 Хранение наркотиков")
			end
		},
		{
			title = "{ffffff}» Продажа наркотиков - {ff0000}4 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 4 Продажа наркотиков")
			end
		},
		{
			title = "{ffffff}» Употребление наркотиков - {ff0000}3 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 3 Употребление наркотиков")
			end
		},
		{
			title = "{ffffff}» Продажа ключей от камеры - {ff0000}6 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 6 Продажа ключей от камеры")
			end
		},
		{
			title = "{ffffff}» Покупка ключей от камеры - {ff0000}6 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 6 Покупка ключей от камеры")
			end
		},
		{
			title = "{ffffff}» Покупка военной формы - {ff0000}2 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Покупка военной формы")
			end
		},
		{
			title = "{ffffff}» Хранение военной формы - {ff0000}2 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Хранение военной формы")
			end
		},
		{
			title = "{ffffff}» Предложение дачи взятки - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Предложение дачи взятки")
			end
		},
		{
			title = "{ae0620}« Раздел №3 »",
			onclick = function()
				return
			end
		},
		{
			title = "{ffffff}» Уход в AFK от ареста - {ff0000}6 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 6 Уход")
			end
		},
		{
			title = "{ffffff}» Совершение терракта - {ff0000}6 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 6 Совершение теракта")
			end
		},
		{
			title = "{ffffff}» Неуплата штрафа - {ff0000}2 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 2 Неуплата штрафа")
			end
		},
		{
			title = "{ffffff}» Превышение полномочий адвоката - {ff0000}3 уровень розыска.",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 3 Превышение полномочий адвоката")
			end
		},
		{
			title = "{ffffff}» Статус ООП - {ff0000}6 уровень розыска",
			onclick = function()
				sampSendChat("/su " .. arg_180_0 .. " 6 ООП")
			end
		}
	}
end

function MegafF()
	if idMegafe == -1 then
		sampAddChatMessage(tag .. "ID не найден", -1)
	else
		sampSendChat("/su " .. idMegaf .. " 2 Уход от сотрудника ПО")
	end

	Megaf = false
end

function su(arg_224_0)
	pID = tonumber(arg_224_0)

	if pID ~= nil then
		if sampIsPlayerConnected(pID) then
			lua_thread.create(function()
				submenus_show(sumenu(pID), "{ff0000}" .. script.this.name .. " {ffffff}| Выдать розыск игроку " .. sampGetPlayerNickname(pID) .. "[" .. pID .. "] ")
			end)
		else
			sampAddChatMessage(tag .. "Игрок с ID: " .. pID .. " не подключен к серверу", -1)
		end
	else
		sampAddChatMessage(tag .. "Введите: /su [id]", -1)
	end
end

function kv(arg_226_0)
	if #arg_226_0 ~= 0 then
		kvadY, kvadX = string.match(arg_226_0, "(%A)-(%d+)")

		if kvadrat(kvadY) ~= nil and kvadX ~= nil and kvadY ~= nil and tonumber(kvadX) < 25 and tonumber(kvadX) > 0 then
			last = lcs
			coordX = kvadX * 250 - 3125
			coordY = (kvadrat1(kvadY) * 250 - 3125) * -1
		end
	else
		sampAddChatMessage(tag .. "Вы находитесь на квадрате: " .. kvadrat(), -1)
	end
end

function ssu(arg_227_0)
	local var_227_0, var_227_1, var_227_2 = arg_227_0:match("(%d+) (%d+) (.+)")

	if var_227_0 and var_227_1 and var_227_2 then
		sampSendChat(string.format("/su %s %s %s", var_227_0, var_227_1, var_227_2))
	else
		sampAddChatMessage(tag .. "Введите: /ssu [id] [кол-во звезд] [причина]", -1)
	end
end

function lockFunc()
	if not sampIsChatInputActive() and not sampIsDialogActive() then
		sampSendChat("/lock")
	end
end

function Zkey()
	lua_thread.create(function()
		local var_230_0, var_230_1 = getCharPlayerIsTargeting(PLAYER_HANDLE)

		if var_230_0 and doesCharExist(var_230_1) then
			local var_230_2, var_230_3 = sampGetPlayerIdByCharHandle(var_230_1)

			if var_230_2 then
				Zid = var_230_3
				Zname = sampGetPlayerNickname(var_230_3)

				local var_230_4, var_230_5, var_230_6 = getCharCoordinates(PLAYER_PED)
				local var_230_7, var_230_8, var_230_9 = getCharCoordinates(var_230_1)

				if getDistanceBetweenCoords3d(var_230_4, var_230_5, var_230_6, var_230_7, var_230_8, var_230_9) > 2.5 then
					pkm = false
				else
					pkm = true

					local var_230_10 = os.clock()

					while os.clock() - var_230_10 < 7 do
						wait(0)

						Ztime = 7 - (os.clock() - var_230_10)
					end

					repeat
						wait(0)
					until Ztime <= 0

					pkm = false
					Str = 1
				end
			end
		end
	end)
end

function split(arg_231_0, arg_231_1)
	if arg_231_1 == nil then
		arg_231_1 = "%s"
	end

	local var_231_0 = {}

	i = 1

	for iter_231_0 in string.gmatch(arg_231_0, "([^" .. arg_231_1 .. "]+)") do
		var_231_0[i] = iter_231_0
		i = i + 1
	end

	return var_231_0
end

function TestersCheck()
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

	local var_232_0 = sampGetPlayerNickname(myid)

	if var_232_0 == "Diego_Alzaga" or var_232_0 == "Fizzy_Falconea" or var_232_0 == "Emma_Cooper" or var_232_0 == "Andreas_Bratiques" or var_232_0 == "Vahotc_Kaiser" or var_232_0 == "Mark_Coin" or var_232_0 == "Jake_Gurinifero" or var_232_0 == "Fernando_Haizenberg" or var_232_0 == "Kira_Yukimura" or var_232_0 == "Joe_Thomson" then
		sampAddChatMessage(tag .. "Спасибо за тестирование " .. var_232_0:gsub("_", " ") .. "!", -1)
	end
end

function megaf()
	if not sampIsDialogActive() and AF then
		thread = lua_thread.create(function()
			if isCharInAnyCar(PLAYER_PED) then
				var_0_17 = {}

				local var_234_0 = sampGetStreamedPlayers()
				local var_234_1, var_234_2 = sampGetPlayerIdByCharHandle(getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)))

				for iter_234_0, iter_234_1 in pairs(var_234_0) do
					local var_234_3, var_234_4 = sampGetCharHandleBySampPlayerId(iter_234_1)

					if var_234_3 and isCharInAnyCar(var_234_4) then
						local var_234_5 = storeCarCharIsInNoSave(var_234_4)
						local var_234_6, var_234_7, var_234_8 = getCharCoordinates(PLAYER_PED)
						local var_234_9, var_234_10, var_234_11 = getCharCoordinates(var_234_4)

						if getDistanceBetweenCoords3d(var_234_6, var_234_7, var_234_8, var_234_9, var_234_10, var_234_11) <= 65 and getDriverOfCar(var_234_5) == var_234_4 and storeCarCharIsInNoSave(var_234_4) ~= storeCarCharIsInNoSave(PLAYER_PED) and iter_234_1 ~= var_234_2 then
							table.insert(var_0_17, iter_234_1)
						end
					end
				end

				if #var_0_17 ~= 0 then
					if #var_0_17 == 1 then
						local var_234_12, var_234_13 = sampGetCharHandleBySampPlayerId(var_0_17[1])

						if doesCharExist(var_234_13) and isCharInAnyCar(var_234_13) then
							local var_234_14 = storeCarCharIsInNoSave(var_234_13)
							local var_234_15 = getCarModel(var_234_14)

							sampSendChat(("/m Водитель а/м %s [EVL%sX] Прижмитесь к обочине или мы будем вынуждены открыть огонь"):format(var_0_29[var_234_15 - 399], var_0_17[1]))

							gmegafid = var_0_17[1]
							gmegaflvl = sampGetPlayerScore(var_0_17[1])
							gmegaffrak = sampGetFraktionBySkin(var_0_17[1])
							gmegafcar = var_0_29[var_234_15 - 399]
						end
					elseif cfg.config.megaf2 then
						ATSC.imegaf.v = not ATSC.imegaf.v
					else
						for iter_234_2, iter_234_3 in pairs(var_0_17) do
							local var_234_16, var_234_17 = sampGetCharHandleBySampPlayerId(iter_234_3)

							if doesCharExist(var_234_17) then
								local var_234_18 = storeCarCharIsInNoSave(var_234_17)
								local var_234_19 = getCarModel(var_234_18)

								sampSendChat(("/m Водитель а/м %s [EVL%sX] Прижмитесь к обочине или мы будем вынуждены открыть огонь"):format(var_0_29[var_234_19 - 399], iter_234_3))

								gmegafid = iter_234_3
								gmegaflvl = sampGetPlayerScore(iter_234_3)
								gmegaffrak = sampGetFraktionBySkin(iter_234_3)
								gmegafcar = var_0_29[var_234_19 - 399]

								break
							end
						end
					end
				end
			else
				sampAddChatMessage(tag .. "Вам необходимо сидеть в транспорте", -1)
			end
		end)
	end
end

function tazer()
	if not sampIsChatInputActive() and not sampIsDialogActive() then
		sampSendChat("/tazer")
	end
end

function pay(arg_236_0)
	if cfg.config.rpay then
		kolvo = -1
		var1, var2 = string.match(arg_236_0, "(%d+) (%d+)")

		if var1 == nil or var1 == "" or var2 == nil or var2 == "" then
			sampAddChatMessage(tag .. "Введите ID и число", -1)
		elseif #var2 == 0 and var2:match("%d+") then
			sampAddChatMessage(tag .. "Введите ID и число", -1)
		else
			lua_thread.create(function()
				wait(10)

				kolvo = var2 / 50000
				kolvo = math.floor(kolvo)
				kolvo2 = kolvo * 50000
				kolvo3 = var2 - kolvo2
				kolvo4 = kolvo3 + kolvo2

				if kolvo >= 1 then
					for iter_237_0 = 1, kolvo do
						sampSendChat("/pay " .. var1 .. " 50000")
						wait(1000)
					end

					if kolvo3 > 0 then
						sampSendChat("/pay " .. var1 .. " " .. kolvo3)
					end
				else
					sampSendChat("/pay " .. var1 .. " " .. var2)
				end

				wait(100)

				if money > 50000 then
					sampAddChatMessage("Выдано " .. money .. " вирт", 11125988)
				end
			end)
		end

		money = 0
	else
		sampSendChat("/pay " .. arg_236_0)
	end
end

function getLocalPlayerId()
	local var_238_0, var_238_1 = sampGetPlayerIdByCharHandle(playerPed)

	return var_238_1
end

function getDistanceToPlayer(arg_239_0)
	if sampIsPlayerConnected(arg_239_0) then
		local var_239_0, var_239_1 = sampGetCharHandleBySampPlayerId(arg_239_0)

		if var_239_0 and doesCharExist(var_239_1) then
			local var_239_2, var_239_3, var_239_4 = getCharCoordinates(playerPed)
			local var_239_5, var_239_6, var_239_7 = getCharCoordinates(var_239_1)

			return getDistanceBetweenCoords3d(var_239_2, var_239_3, var_239_4, var_239_5, var_239_6, var_239_7)
		end
	end

	return nil
end

function autocl()
	if cfg.config.CL2 and rabden then
		lua_thread.create(function()
			wait(1400)
			sampSendChat("/clist " .. cfg.config.cl)
		end)
	elseif cfg.config.CL2 and rabden == false and group == "Армия" then
		lua_thread.create(function()
			wait(500)
			sampSendChat("/clist 7")
		end)
	end
end

function screen()
	local var_243_0 = require("memory")

	wait(750)
	var_243_0.setuint8(sampGetBase() + 1154236, 1)
	wait(1000)
end

function findShp(arg_244_0)
	if arg_244_0 == nil or arg_244_0 == "" then
		sampAddChatMessage(tag .. "Выберите шпору для поиска или введите текст для поиска. (/fshp 1-6 или /fshp text)", -1)
	else
		lua_thread.create(function()
			if arg_244_0 == "1" then
				sampAddChatMessage(tag .. "Выбрана шпора для поиска: {FF0000}" .. cfg.config.shpname0, -1)

				ffshp = 0

				wait(100)

				ffshp = 1
			elseif arg_244_0 == "2" then
				sampAddChatMessage(tag .. "Выбрана шпора для поиска: {FF0000}" .. cfg.config.shpname1, -1)

				ffshp = 0

				wait(100)

				ffshp = 2
			elseif arg_244_0 == "3" then
				sampAddChatMessage(tag .. "Выбрана шпора для поиска: {FF0000}" .. cfg.config.shpname2, -1)

				ffshp = 0

				wait(100)

				ffshp = 3
			elseif arg_244_0 == "4" then
				sampAddChatMessage(tag .. "Выбрана шпора для поиска: {FF0000}" .. cfg.config.shpname3, -1)

				ffshp = 0

				wait(100)

				ffshp = 4
			elseif arg_244_0 == "5" then
				sampAddChatMessage(tag .. "Выбрана шпора для поиска: {FF0000}" .. cfg.config.shpname4, -1)

				ffshp = 0

				wait(100)

				ffshp = 5
			elseif arg_244_0 == "6" then
				sampAddChatMessage(tag .. "Выбрана шпора для поиска: {FF0000}" .. cfg.config.shpname5, -1)

				ffshp = 0

				wait(100)

				ffshp = 6
			elseif ffshp == 0 then
				sampAddChatMessage(tag .. "Выберите шпору для поиска или введите текст для поиска. (/fshp 1-6 или /fshp text)", -1)
			end
		end)

		textu8 = u8(arg_244_0)

		if ffshp == 1 then
			local var_244_0 = io.open("moonloader\\config\\" .. cfg.config.shpname0 .. ".json")

			for iter_244_0 in var_244_0:lines() do
				if string.find(iter_244_0, textu8) or string.rlower(iter_244_0):find(textu8) or string.rupper(iter_244_0):find(textu8) then
					sampAddChatMessage(" " .. u8:decode(iter_244_0), -1)
				end
			end

			var_244_0:close()
		elseif ffshp == 2 then
			local var_244_1 = io.open("moonloader\\config\\" .. cfg.config.shpname1 .. ".json")

			for iter_244_1 in var_244_1:lines() do
				if string.find(iter_244_1, textu8) or string.rlower(iter_244_1):find(textu8) or string.rupper(iter_244_1):find(textu8) then
					sampAddChatMessage(" " .. u8:decode(iter_244_1), -1)
				end
			end

			var_244_1:close()
		elseif ffshp == 3 then
			local var_244_2 = io.open("moonloader\\config\\" .. cfg.config.shpname2 .. ".json")

			for iter_244_2 in var_244_2:lines() do
				if string.find(iter_244_2, textu8) or string.rlower(iter_244_2):find(textu8) or string.rupper(iter_244_2):find(textu8) then
					sampAddChatMessage(" " .. u8:decode(iter_244_2), -1)
				end
			end

			var_244_2:close()
		elseif ffshp == 4 then
			local var_244_3 = io.open("moonloader\\config\\" .. cfg.config.shpname3 .. ".json")

			for iter_244_3 in var_244_3:lines() do
				if string.find(iter_244_3, textu8) or string.rlower(iter_244_3):find(textu8) or string.rupper(iter_244_3):find(textu8) then
					sampAddChatMessage(" " .. u8:decode(iter_244_3), -1)
				end
			end

			var_244_3:close()
		elseif ffshp == 5 then
			local var_244_4 = io.open("moonloader\\config\\" .. cfg.config.shpname4 .. ".json")

			for iter_244_4 in var_244_4:lines() do
				if string.find(iter_244_4, textu8) or string.rlower(iter_244_4):find(textu8) or string.rupper(iter_244_4):find(textu8) then
					sampAddChatMessage(" " .. u8:decode(iter_244_4), -1)
				end
			end

			var_244_4:close()
		elseif ffshp == 6 then
			local var_244_5 = io.open("moonloader\\config\\" .. cfg.config.shpname5 .. ".json")

			for iter_244_5 in var_244_5:lines() do
				if string.find(iter_244_5, textu8) or string.rlower(iter_244_5):find(textu8) or string.rupper(iter_244_5):find(textu8) then
					sampAddChatMessage(" " .. u8:decode(iter_244_5), -1)
				end
			end

			var_244_5:close()
		end
	end
end

function CheckRB()
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

	if group == "Полиция" and sampGetFraktionBySkin(myid) == "Полиция" then
		rabden = true
	elseif group == "Армия" and sampGetFraktionBySkin(myid) == "Army" then
		rabden = true
	elseif group == "ФБР" and sampGetFraktionBySkin(myid) == "FBI" then
		rabden = true
	end
end

local var_0_132 = os.date("%H", os.time())

function fst(arg_247_0)
	if arg_247_0 == "default" then
		local var_247_0 = os.date("%H", os.time())

		patch_samp_time_set(true)
		lua_thread.create(function()
			while var_0_132 ~= tonumber(var_247_0) do
				wait(75)

				var_0_132 = var_0_132 + 1

				setTimeOfDay(var_0_132, 0)

				if var_0_132 == 24 then
					var_0_132 = 0
				end
			end
		end)
		sampAddChatMessage(tag .. "Время изменено на: {ff0000}" .. var_247_0, -1)
	else
		local var_247_1 = tonumber(arg_247_0)

		if var_247_1 ~= nil and var_247_1 >= 0 and var_247_1 <= 23 then
			patch_samp_time_set(true)
			lua_thread.create(function()
				while var_0_132 ~= var_247_1 do
					wait(75)

					var_0_132 = var_0_132 + 1

					setTimeOfDay(var_0_132, 0)

					if var_0_132 == 24 then
						var_0_132 = 0
					end
				end
			end)
			sampAddChatMessage(tag .. "Время изменено на: {ff0000}" .. var_247_1, -1)
		else
			sampAddChatMessage(tag .. "Значение времени должно быть в диапазоне от 0 до 23.", -1)
			patch_samp_time_set(false)
		end
	end
end

function patch_samp_time_set(arg_250_0)
	if arg_250_0 and default == nil then
		default = readMemory(sampGetBase() + 639136, 4, true)

		writeMemory(sampGetBase() + 639136, 4, 2242, true)
	elseif arg_250_0 == false and default ~= nil then
		writeMemory(sampGetBase() + 639136, 4, default, true)

		default = nil
	end
end

function fsw(arg_251_0)
	local var_251_0 = tonumber(arg_251_0)

	if var_251_0 ~= nil and var_251_0 >= 0 and var_251_0 <= 45 then
		forceWeatherNow(var_251_0)
		sampAddChatMessage(tag .. "Погода изменена на: {ff0000}" .. var_251_0, -1)
	else
		sampAddChatMessage(tag .. "Значение погоды должно быть в диапазоне от 0 до 45.", -1)
	end
end

function HPbarArmy()
	local var_252_0, var_252_1 = getCharPlayerIsTargeting(PLAYER_HANDLE)

	if var_252_0 and doesCharExist(var_252_1) then
		local var_252_2, var_252_3 = sampGetPlayerIdByCharHandle(var_252_1)

		if var_252_2 then
			local var_252_4 = sampGetPlayerNickname(var_252_3)

			if group == "Армия" then
				if #var_0_92 == 0 then
					mbpassive()
				end

				for iter_252_0, iter_252_1 in pairs(var_0_92) do
					if iter_252_1.nickname == var_252_4 then
						sRang = iter_252_1.sRang
						sovpd = true

						break
					else
						sovpd = false
						sRang = -1
					end
				end
			end

			sizeX = 175
			sizeY = 10
			resX, resY = getScreenResolution()
			main_x = select(1, getScreenResolution()) / 2 - 87.5
			main_y = select(2, getScreenResolution()) - 970

			imgui.SetNextWindowPos(imgui.ImVec2(main_x, sizeY))
			imgui.SetNextWindowSize(imgui.ImVec2(175, 65), imgui.WindowFlags.AlwaysAutoResize)
			imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
			imgui.Begin("Pricel", pricel, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)

			local var_252_5 = sampGetPlayerScore(var_252_3)
			local var_252_6 = sampGetPlayerArmor(var_252_3)
			local var_252_7 = sampGetPlayerHealth(var_252_3)
			local var_252_8 = sampGetPlayerNickname(var_252_3)
			local var_252_9, var_252_10, var_252_11 = getCharCoordinates(PLAYER_PED)
			local var_252_12, var_252_13, var_252_14 = getCharCoordinates(var_252_1)
			local var_252_15 = getDistanceBetweenCoords3d(var_252_9, var_252_10, var_252_11, var_252_12, var_252_13, var_252_14)

			imgui.CentrText((var_0_34.ICON_FA_USER_ALT .. u8(" %s [%s]")):format(var_252_8, var_252_3))
			imgui.SameLine()

			if var_252_15 > 2.5 then
				imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), var_0_34.ICON_FA_CIRCLE)
			else
				imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), var_0_34.ICON_FA_CIRCLE)
			end

			imgui.Separator()
			imgui.Text(var_0_34.ICON_FA_HEARTBEAT .. " HP:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1))
			imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.25, 0, 0, 1))
			imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(1, 0, 0, 1))
			imgui.PushItemWidth(110)
			imgui.ProgressBar(var_252_7 / 100, imgui.ImVec2(120, 12))
			imgui.PopStyleColor(3)
			imgui.Text(var_0_34.ICON_FA_SHIELD_ALT .. " AR:")
			imgui.SameLine()
			imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(1, 1, 1, 1))
			imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.25, 0, 0, 1))
			imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(0.61, 0.61, 0.61, 1))
			imgui.ProgressBar(var_252_6 / 100, imgui.ImVec2(120, 12))
			imgui.PopStyleColor(3)
			imgui.PopItemWidth()

			if group == "Армия" and sovpd and sRang ~= -1 then
				imgui.CentrText(sRang)
			end

			imgui.End()
			imgui.PopStyleColor()
		end
	end
end

function menumembers()
	if memba.v then
		_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)

		local var_253_0 = sampGetPlayerNickname(myid)
		local var_253_1 = u8(" Настройки")
		local var_253_2 = u8(" Поиск игроков")
		local var_253_3 = u8(" В зоне стрима")
		local var_253_4 = imgui.CalcTextSize(var_253_1)
		local var_253_5 = imgui.CalcTextSize(var_253_2)
		local var_253_6 = imgui.CalcTextSize(var_253_3)
		local var_253_7 = 4
		local var_253_8 = convertGameScreenCoordsToWindowScreenCoords
		local var_253_9 = imgui.GetItemRectSize()
		local var_253_10 = u8(sampGetCurrentServerName())
		local var_253_11, var_253_12 = getScreenResolution()

		x, y = var_253_8(160, 90)
		w, h = var_253_8(480, 300)

		imgui.SetNextWindowSize(imgui.ImVec2(w - x, h - y))
		imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(var_253_10, memba, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar)
		imgui.AlignTextToFramePadding()
		imgui.Indent(4)
		imgui.Text(u8("Всего: %s | Рядом: " .. #var_0_18):format(#var_0_92))
		imgui.SameLine()
		imgui.SameLine(w - x - 155)
		imgui.PushItemWidth(150)
		imgui.PushAllowKeyboardFocus(false)
		imgui.InputText("##search", var_0_48, imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.CharsNoBlank)
		imgui.PopAllowKeyboardFocus()
		imgui.PopItemWidth()

		if not imgui.IsItemActive() and #var_0_48.v == 0 then
			imgui.SameLine(w - x - 153)
			imgui.Text(var_253_2)
		end

		imgui.Columns(7, _)
		imgui.SetColumnWidth(-1, 40)
		imgui.Text("ID")
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 145)
		imgui.Text(u8("Никнейм"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 120)
		imgui.Text(u8("Должность"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 85)
		imgui.Text(u8("Статус"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 120)
		imgui.Text(u8("Дата приема"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 70)
		imgui.Text(u8("AFK"))
		imgui.NextColumn()
		imgui.SetColumnWidth(-1, 75)
		imgui.Text(var_0_34.ICON_FA_EYE)
		imgui.NextColumn()
		imgui.Separator()

		for iter_253_0, iter_253_1 in ipairs(var_0_92) do
			if #var_0_48.v > 0 then
				if string.find(sampGetPlayerNickname(iter_253_1.id):lower(), var_0_48.v:lower(), 1, true) or iter_253_1.id == tonumber(var_0_48.v) then
					imgui.Text(iter_253_1.id)
					imgui.NextColumn()
					imgui.TextColored(imgui.ImVec4(getColor(iter_253_1.id)), u8("%s"):format(iter_253_1.nickname))

					if imgui.IsItemHovered() then
						imgui.BeginTooltip()
						imgui.PushTextWrapPos(450)
						imgui.TextColored(imgui.ImVec4(getColor(iter_253_1.id)), u8("%s\nУровень: %s"):format(iter_253_1.nickname, sampGetPlayerScore(iter_253_1.id)))
						imgui.TextWrapped(u8("Нажмите ПКМ для доп.информации"))
						imgui.PopTextWrapPos()
						imgui.EndTooltip()

						if imgui.IsMouseClicked(1) then
							imgui.OpenPopup(iter_253_1.id)

							popa = true
						end
					end

					if imgui.BeginPopup(iter_253_1.id) then
						if imgui.Selectable(u8("Написать SMS")) then
							sampSetChatInputText("/t " .. iter_253_1.id .. " ")
							sampSetChatInputEnabled(true)

							popa = false
						end

						if imgui.Selectable(u8("Узнать номер телефона")) then
							sampSendChat("/number " .. iter_253_1.id)

							popa = false
						end

						imgui.EndPopup()
					end

					imgui.NextColumn()
					imgui.Text(("%s [%s]"):format(iter_253_1.sRang, iter_253_1.iRang))
					imgui.NextColumn()

					if iter_253_1.status ~= u8("На работе") then
						imgui.TextColored(imgui.ImVec4(0.8, 0, 0, 1), iter_253_1.status)
					else
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), iter_253_1.status)
					end

					imgui.NextColumn()
					imgui.Text(iter_253_1.invite)
					imgui.NextColumn()

					if iter_253_1.sec ~= 0 then
						if iter_253_1.sec < 360 then
							imgui.TextColored(getColorForSeconds(iter_253_1.sec), tostring(iter_253_1.sec .. u8(" сек.")))
						else
							imgui.TextColored(getColorForSeconds(iter_253_1.sec), tostring("360+" .. u8(" сек.")))
						end
					else
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Нет"))
					end

					imgui.NextColumn()

					local var_253_13, var_253_14 = sampGetCharHandleBySampPlayerId(iter_253_1.id)

					if var_253_0 == iter_253_1.nickname then
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Вы"))
						imgui.SameLine(34)
					elseif var_253_13 then
						imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Да"))
						imgui.SameLine(34)
					else
						imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8("Нет"))
						imgui.SameLine()
					end

					imgui.NextColumn()
				end
			else
				imgui.Text(iter_253_1.id)
				imgui.NextColumn()
				imgui.TextColored(imgui.ImVec4(getColor(iter_253_1.id)), u8("%s"):format(iter_253_1.nickname))

				if imgui.IsItemHovered() then
					imgui.BeginTooltip()
					imgui.PushTextWrapPos(450)
					imgui.TextColored(imgui.ImVec4(getColor(iter_253_1.id)), u8("%s\nУровень: %s"):format(iter_253_1.nickname, sampGetPlayerScore(iter_253_1.id)))
					imgui.TextWrapped(u8("Нажмите ПКМ для доп.информации"))
					imgui.PopTextWrapPos()
					imgui.EndTooltip()

					if imgui.IsMouseClicked(1) then
						imgui.OpenPopup(iter_253_1.id)

						popa = true
					end
				end

				if imgui.BeginPopup(iter_253_1.id) then
					if imgui.Selectable(u8("Написать SMS")) then
						sampSetChatInputText("/t " .. iter_253_1.id .. " ")
						sampSetChatInputEnabled(true)

						popa = false
					end

					if imgui.Selectable(u8("Узнать номер телефона")) then
						sampSendChat("/number " .. iter_253_1.id)

						popa = false
					end

					imgui.EndPopup()
				end

				if false then
					-- block empty
				end

				imgui.NextColumn()
				imgui.Text(("%s [%s]"):format(iter_253_1.sRang, iter_253_1.iRang))
				imgui.NextColumn()

				if iter_253_1.status ~= u8("На работе") then
					imgui.TextColored(imgui.ImVec4(0.8, 0, 0, 1), iter_253_1.status)
				else
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), iter_253_1.status)
				end

				imgui.NextColumn()
				imgui.Text(iter_253_1.invite)
				imgui.NextColumn()

				if iter_253_1.sec ~= 0 then
					if iter_253_1.sec < 360 then
						imgui.TextColored(getColorForSeconds(iter_253_1.sec), tostring(iter_253_1.sec .. u8(" сек.")))
					else
						imgui.TextColored(getColorForSeconds(iter_253_1.sec), tostring("360+" .. u8(" сек.")))
					end
				else
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Нет"))
				end

				imgui.NextColumn()

				local var_253_15, var_253_16 = sampGetCharHandleBySampPlayerId(iter_253_1.id)

				if var_253_0 == iter_253_1.nickname then
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Вы"))
					imgui.SameLine(34)
				elseif var_253_15 then
					imgui.TextColored(imgui.ImVec4(0, 0.8, 0, 1), u8("Да"))
					imgui.SameLine(34)
				else
					imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), u8("Нет"))
					imgui.SameLine()
				end

				imgui.NextColumn()
			end
		end

		imgui.End()
	end
end

function HPbarMin()
	if MP then
		sizeX = 175
		sizeY = 10
		resX, resY = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(cfg.config.cordXH, cfg.config.cordYH))
		imgui.SetNextWindowSize(imgui.ImVec2(175, 65), imgui.WindowFlags.AlwaysAutoResize)
		imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
		imgui.Begin("Pricel", pricel, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)
		imgui.CentrText((u8(" Nick Name [228]")))
		imgui.Separator()
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0, 0, 0, 0))
		imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.25, 0, 0, 1))
		imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(1, 0, 0, 1))
		imgui.PushItemWidth(110)
		imgui.ProgressBar(1, imgui.ImVec2(120, 5))
		imgui.PopStyleColor(3)
		imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0, 0, 0, 0))
		imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.25, 0, 0, 1))
		imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(0.61, 0.61, 0.61, 1))
		imgui.ProgressBar(1, imgui.ImVec2(120, 5))
		imgui.PopStyleColor(3)
		imgui.PopItemWidth()
		imgui.End()
		imgui.PopStyleColor()
	else
		local var_254_0, var_254_1 = getCharPlayerIsTargeting(PLAYER_HANDLE)

		if var_254_0 and doesCharExist(var_254_1) then
			local var_254_2, var_254_3 = sampGetPlayerIdByCharHandle(var_254_1)

			if var_254_2 then
				local var_254_4 = sampGetPlayerNickname(var_254_3)

				sizeX = 175
				sizeY = 10
				resX, resY = getScreenResolution()

				imgui.SetNextWindowPos(imgui.ImVec2(cfg.config.cordXH, cfg.config.cordYH))
				imgui.SetNextWindowSize(imgui.ImVec2(175, 65), imgui.WindowFlags.AlwaysAutoResize)
				imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.16, 0.18, 0.22, 0.5))
				imgui.Begin("Pricel", pricel, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoScrollbar)

				local var_254_5 = sampGetPlayerScore(var_254_3)
				local var_254_6 = sampGetPlayerArmor(var_254_3)
				local var_254_7 = sampGetPlayerHealth(var_254_3)
				local var_254_8 = sampGetPlayerNickname(var_254_3)
				local var_254_9, var_254_10, var_254_11 = getCharCoordinates(PLAYER_PED)
				local var_254_12, var_254_13, var_254_14 = getCharCoordinates(var_254_1)
				local var_254_15 = getDistanceBetweenCoords3d(var_254_9, var_254_10, var_254_11, var_254_12, var_254_13, var_254_14)

				imgui.CentrText(u8(" %s [%s]"):format(var_254_8, var_254_3))
				imgui.Separator()
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0, 0, 0, 0))
				imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.25, 0, 0, 1))
				imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(1, 0, 0, 1))
				imgui.PushItemWidth(110)
				imgui.ProgressBar(var_254_7 / 100, imgui.ImVec2(120, 5))
				imgui.PopStyleColor(3)
				imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0, 0, 0, 0))
				imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.25, 0, 0, 1))
				imgui.PushStyleColor(imgui.Col.PlotHistogram, imgui.ImVec4(0.61, 0.61, 0.61, 1))
				imgui.ProgressBar(var_254_6 / 100, imgui.ImVec2(120, 5))
				imgui.PopStyleColor(3)
				imgui.PopItemWidth()
				imgui.End()
				imgui.PopStyleColor()
			end
		end
	end
end

if doesFileExist("moonloader\\config\\friendsatsc.json") then
	local var_0_133 = io.open("moonloader\\config\\friendsatsc.json", "r")

	if var_0_133 then
		friends = decodeJson(var_0_133:read("a*"))

		var_0_133:close()
	end
else
	friends = {}
end

function cadd(arg_255_0)
	if arg_255_0 == string.match(arg_255_0, "(%d+)") then
		if sampIsPlayerConnected(arg_255_0) then
			local var_255_0 = sampGetPlayerNickname(arg_255_0)

			table.insert(friends, var_255_0)

			local var_255_1 = io.open("moonloader\\config\\friendsatsc.json", "w")

			if var_255_1 then
				var_255_1:write(encodeJson(friends))
				var_255_1:close()
			end
		else
			sampAddChatMessage(tag .. "Введён неверный ID", -1)
		end
	else
		table.insert(friends, arg_255_0)

		local var_255_2 = io.open("moonloader\\config\\friendsatsc.json", "w")

		if var_255_2 then
			var_255_2:write(encodeJson(friends))
			var_255_2:close()
		end
	end
end

function caddbl(arg_256_0)
	if arg_256_0 == string.match(arg_256_0, "(%d+)") then
		if sampIsPlayerConnected(arg_256_0) then
			local var_256_0 = sampGetPlayerNickname(arg_256_0)

			table.insert(blacklist, var_256_0)

			local var_256_1 = io.open("moonloader\\config\\blacklistatsc.json", "w")

			if var_256_1 then
				var_256_1:write(encodeJson(blacklist))
				var_256_1:close()
			end
		else
			sampAddChatMessage(tag .. "Введён неверный ID", -1)
		end
	else
		table.insert(blacklist, arg_256_0)

		local var_256_2 = io.open("moonloader\\config\\blacklistatsc.json", "w")

		if var_256_2 then
			var_256_2:write(encodeJson(blacklist))
			var_256_2:close()
		end
	end
end

function positionH()
	lua_thread.create(function()
		MP = not MP
		ATSC.settings.v = false

		while true do
			wait(0)

			if MP then
				sampSetCursorMode(4)

				local var_258_0, var_258_1 = getCursorPos()

				cfg.config.cordXH, cfg.config.cordYH = var_258_0, var_258_1
			end
		end
	end)
end

posKD = false

function positionKD()
	lua_thread.create(function()
		posKD = true

		while posKD do
			wait(0)

			ATSC.settings.v = false

			sampSetCursorMode(4)

			local var_260_0, var_260_1 = getCursorPos()

			cfg.config.KDx, cfg.config.KDy = var_260_0, var_260_1

			if imgui.IsMouseClicked(0) then
				var_0_4.save(cfg, var_0_24)
				sampSetCursorMode(0)

				posKD = false
			end
		end
	end)
end

friendsonline = {}

function msg()
	messeng.v = not messeng.v
end

spisok = false
pop = false
blacklistk = 0
friendsk = 0
nickonline = -1
SelectedFriendOnline = false

function messenger()
	if messeng.v then
		local var_262_0, var_262_1 = getScreenResolution()

		imgui.SetNextWindowPos(imgui.ImVec2(var_262_0 / 2, var_262_1 / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(760, 400), imgui.WindowFlags.AlwaysAutoResize)
		imgui.Begin(tagimgui .. u8("Messenger"), messeng, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.BeginChild("Друзья", imgui.ImVec2(190, 340), true)

		if spisok then
			imgui.Text(u8("Черный список: ") .. #blacklist)

			for iter_262_0, iter_262_1 in ipairs(blacklist) do
				local var_262_2 = getPlayerIdByNickname(iter_262_1)
				local var_262_3 = sampGetPlayerColor(var_262_2)
				local var_262_4 = ("%06X"):format(bit.band(sampGetPlayerColor(var_262_2), 16777215))
				local var_262_5 = sampIsPlayerPaused(var_262_2)
				local var_262_6, var_262_7 = sampGetCharHandleBySampPlayerId(var_262_2)
				local var_262_8 = iter_262_1

				if var_262_2 == nil then
					textfriend = iter_262_0 .. ". " .. var_262_8 .. ""

					local var_262_9 = imgui.CalcTextSize(textfriend)

					imgui.InvisibleButton("##1", var_262_9)
					imgui.SameLine(6)

					if imgui.IsItemHovered() then
						imgui.TextDisabled(textfriend .. " [-]")

						if imgui.IsMouseClicked(1) then
							imgui.OpenPopup(iter_262_1)
						end

						if imgui.IsMouseClicked(0) then
							SelectedFriend = iter_262_1
							SelectedFriendOnline = false
							SelectedIdFriend = sampGetPlayerIdByNickname(SelectedFriend)
						end
					else
						imgui.TextColoredRGB("{808080}" .. textfriend .. " [-]")
					end
				elseif sampIsPlayerConnected(var_262_2) then
					textfriend = iter_262_0 .. ". {" .. var_262_4 .. "}" .. var_262_8 .. "{ffffff} [" .. var_262_2 .. "]"

					local var_262_10 = imgui.CalcTextSize(textfriend)

					imgui.InvisibleButton("##2", var_262_10)
					imgui.SameLine(6)

					if imgui.IsItemHovered() then
						imgui.TextDisabled(textfriend:gsub("{......}", ""))

						if imgui.IsMouseClicked(1) then
							imgui.OpenPopup(iter_262_1)
						end

						if imgui.IsMouseClicked(0) then
							SelectedFriend = iter_262_1
							SelectedFriendOnline = true
							SelectedIdFriend = sampGetPlayerIdByNickname(SelectedFriend)
						end
					else
						imgui.TextColoredRGB(textfriend)
					end
				end

				if imgui.BeginPopup(iter_262_1) then
					if imgui.Selectable(u8("Удалить из ЧС")) then
						table.remove(blacklist, iter_262_0)

						local var_262_11 = io.open("moonloader\\config\\blacklistatsc.json", "w")

						if var_262_11 then
							var_262_11:write(encodeJson(blacklist))
							var_262_11:close()
						end
					end

					imgui.EndPopup()
				end
			end
		else
			imgui.Text(u8("Друзей всего: ") .. #friends .. u8(" | В сети: ") .. #friendsonline)

			for iter_262_2, iter_262_3 in ipairs(friends) do
				friendsk = iter_262_2

				if iter_262_3 == nil then
					imgui.CentrText(u8("Список пуст"))
				else
					local var_262_12 = getPlayerIdByNickname(iter_262_3)
					local var_262_13 = sampGetPlayerColor(var_262_12)
					local var_262_14 = ("%06X"):format(bit.band(sampGetPlayerColor(var_262_12), 16777215))
					local var_262_15 = sampIsPlayerPaused(var_262_12)
					local var_262_16, var_262_17 = sampGetCharHandleBySampPlayerId(var_262_12)
					local var_262_18 = iter_262_3

					if var_262_12 == nil then
						textfriend = iter_262_2 .. ". " .. var_262_18 .. ""

						local var_262_19 = imgui.CalcTextSize(textfriend)

						imgui.InvisibleButton("##1", var_262_19)
						imgui.SameLine(6)

						if imgui.IsItemHovered() then
							imgui.TextDisabled(textfriend .. " [-]")

							if imgui.IsMouseClicked(1) then
								imgui.OpenPopup(iter_262_3)
							end

							if imgui.IsMouseClicked(0) then
								SelectedFriend = iter_262_3
								SelectedFriendOnline = false
								SelectedIdFriend = sampGetPlayerIdByNickname(SelectedFriend)
							end
						else
							imgui.TextColoredRGB("{808080}" .. textfriend .. " [-]")
						end

						friendsonlineT = table.concat(friendsonline)
						nickonline = iter_262_3

						if friendsonlineT:match(nickonline) then
							local var_262_20 = sampGetPlayerIdByNickname(nickonline)

							for iter_262_4, iter_262_5 in ipairs(friendsonline) do
								if iter_262_5 == nickonline then
									table.remove(friendsonline, iter_262_4)
								end
							end
						end
					elseif sampIsPlayerConnected(var_262_12) then
						friendsonlineT = table.concat(friendsonline)

						if not friendsonlineT:match(var_262_18) then
							table.insert(friendsonline, var_262_18)
						end

						textfriend = iter_262_2 .. ". {" .. var_262_14 .. "}" .. var_262_18 .. "{ffffff} [" .. var_262_12 .. "]"

						local var_262_21 = imgui.CalcTextSize(textfriend)

						imgui.InvisibleButton("##2", var_262_21)
						imgui.SameLine(6)

						if imgui.IsItemHovered() then
							imgui.TextDisabled(textfriend:gsub("{......}", ""))

							if imgui.IsMouseClicked(1) then
								imgui.OpenPopup(iter_262_3)
							end

							if imgui.IsMouseClicked(0) then
								SelectedFriend = iter_262_3
								SelectedFriendOnline = true
								SelectedIdFriend = sampGetPlayerIdByNickname(SelectedFriend)
							end
						else
							imgui.TextColoredRGB(textfriend)
						end
					end

					if imgui.BeginPopup(iter_262_3) then
						if imgui.Selectable(u8("Удалить друга")) then
							table.remove(friends, iter_262_2)

							nickonline = iter_262_3

							for iter_262_6, iter_262_7 in ipairs(friendsonline) do
								if iter_262_7 == nickonline then
									table.remove(friendsonline, iter_262_6)
								end
							end

							local var_262_22 = io.open("moonloader\\config\\friendsatsc.json", "w")

							if var_262_22 then
								var_262_22:write(encodeJson(friends))
								var_262_22:close()
							end
						end

						imgui.EndPopup()
					end
				end
			end
		end

		if spisok then
			if blacklistk < 9 then
				imgui.SetCursorPos(imgui.ImVec2(95, 175))
				imgui.CentrTextDisabled(u8("Черный список"))
			end
		elseif friendsk < 9 then
			imgui.SetCursorPos(imgui.ImVec2(95, 175))
			imgui.CentrTextDisabled(u8("Список друзей"))
		end

		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("Сообщения", imgui.ImVec2(545, 340), true, imgui.WindowFlags.NoScrollbar)

		textL1 = table.concat(smsfriends, "\n")

		if not textL1:match(SelectedFriend) or textL1 == "" then
			imgui.SetCursorPos(imgui.ImVec2(272.5, 175))
			imgui.CentrTextDisabled(u8("История сообщений"))
		else
			for iter_262_8 in textL1:gmatch("[^\n\r]+") do
				if SelectedFriend == iter_262_8:match("%: (%w+_%w+)%[(%d+)%]") then
					local var_262_23, var_262_24 = SelectedFriend:match("(.+)_(.+)")
					local var_262_25, var_262_26 = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):match("(.+)_(.+)")
					local var_262_27 = var_262_25:match("%u") .. "." .. var_262_26
					local var_262_28 = var_262_23:match("%u") .. "." .. var_262_24

					if iter_262_8:match("Вы: ") then
						strtime = iter_262_8:match(".%d+.%d+.%d+%s(%d+:%d+):%d+. Вы: .+. Получатель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")
						strfulltime = iter_262_8:match(".%d+.%d+.%d+%s(%d+:%d+:%d+). Вы: .+. Получатель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")
						strdate = iter_262_8:match(".(%d+.%d+.%d+)%s%d+:%d+:%d+. Вы: .+. Получатель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")
						strtext = iter_262_8:match("Вы: (.+). Получатель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")

						if strtext:match("(https://%w+%p*%w*/%w*)") then
							strlink = strtext:match("(https://%w+%p*%w*/%w*)")
							strlinktext = strtext:match("https://%w+%p*%w+/%w+ (.*)")

							imgui.TextWrapped(var_262_27 .. ":")
							imgui.SameLine()
							imgui.Link(strlink)
							imgui.SameLine()
							imgui.TextWrapped(u8(strlinktext))
						else
							imgui.TextWrapped(var_262_27 .. ": " .. u8(strtext))
						end

						imgui.SameLine(500)
						imgui.TextDisabled(strtime)

						if imgui.IsItemHovered() then
							imgui.BeginTooltip()
							imgui.TextUnformatted(u8("Точное время: ") .. strfulltime .. u8("\nДата: ") .. strdate)
							imgui.EndTooltip()
						end

						if imgui.IsItemClicked() then
							sampSetChatInputText(iter_262_8:gsub("{.+}", ""):gsub("Вы: ", "SMS: "))
							sampSetChatInputEnabled(true)
						end
					elseif iter_262_8:match("Вам: ") then
						strtime = iter_262_8:match(".%d+.%d+.%d+%s(%d+:%d+):%d+. Вам: .+. Отправитель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")
						strfulltime = iter_262_8:match(".%d+.%d+.%d+%s(%d+:%d+:%d+). Вам: .+. Отправитель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")
						strdate = iter_262_8:match(".(%d+.%d+.%d+)%s%d+:%d+:%d+. Вам: .+. Отправитель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")
						strtext = iter_262_8:match("Вам: (.+). Отправитель: " .. var_262_23 .. "_" .. var_262_24 .. ".+")

						imgui.TextWrapped(var_262_28 .. ": " .. u8(strtext))
						imgui.SameLine(500)
						imgui.TextDisabled(strtime)

						if imgui.IsItemHovered() then
							imgui.BeginTooltip()
							imgui.TextUnformatted(u8("Точное время: ") .. strfulltime .. u8("\nДата: ") .. strdate)
							imgui.EndTooltip()
						end

						if imgui.IsItemClicked() then
							sampSetChatInputText(iter_262_8:gsub("{.+}", ""):gsub("Вам: ", "SMS: "))
							sampSetChatInputEnabled(true)
						end
					end

					if newmessage and messeng.v then
						imgui.SetScrollY(imgui.GetScrollMaxY())
					end
				end
			end
		end

		imgui.EndChild()

		if SelectedFriend ~= -1 then
			imgui.SetCursorPos(imgui.ImVec2(730, 370))

			local var_262_29 = imgui.CalcTextSize(var_0_34.ICON_FA_COG)

			imgui.InvisibleButton("#12", var_262_29)
			imgui.SameLine(732)

			if imgui.IsItemHovered() then
				if imgui.IsMouseClicked(0) then
					imgui.OpenPopup("Sett")
				end

				imgui.TextDisabled(var_0_34.ICON_FA_COG)
			else
				imgui.Text(var_0_34.ICON_FA_COG)
			end

			if imgui.BeginPopup("Sett") then
				imgui.CentrTextDisabled(SelectedFriend)

				if imgui.Selectable(u8("Очистить историю сообщений")) then
					for iter_262_9, iter_262_10 in ipairs(smsfriends) do
						if iter_262_10:match(SelectedFriend) then
							table.remove(smsfriends, iter_262_9)
						end
					end
				end

				imgui.EndPopup()
			end

			if SelectedFriendOnline then
				local var_262_30 = imgui.CalcTextSize(var_0_34.ICON_FA_PAPERCLIP)

				imgui.SetCursorPos(imgui.ImVec2(207, 371))

				if imgui.InvisibleButton("##1", var_262_30) then
					imgui.OpenPopup(SelectedFriend)
				end

				imgui.SameLine(207)

				if imgui.IsItemHovered() then
					imgui.TextDisabled(var_0_34.ICON_FA_PAPERCLIP)
				else
					imgui.Text(var_0_34.ICON_FA_PAPERCLIP)
				end

				if imgui.BeginPopup(SelectedFriend) then
					if imgui.Selectable(u8("Не придумал")) then
						pop = true
					end

					imgui.EndPopup()
				end

				imgui.SameLine()
				imgui.SetCursorPos(imgui.ImVec2(225, 370))
				imgui.PushItemWidth(500)
				imgui.InputText("##Chat", var_0_49, imgui.InputTextFlags.EnterReturnsTrue)

				if #var_0_49.v == 0 then
					imgui.SameLine()
					imgui.SetCursorPos(imgui.ImVec2(229, 370))
					imgui.Text(u8("Напишите сообщение..."))
				elseif isKeyJustPressed(VK_RETURN) then
					sampSendChat("/t " .. SelectedIdFriend .. " " .. u8:decode(var_0_49.v))
					imgui.SetScrollY(imgui.GetScrollMaxY())

					var_0_49.v = ""
				end
			end
		end

		imgui.PushItemWidth(145)
		imgui.SetCursorPos(imgui.ImVec2(12, 370))

		local var_262_31 = imgui.CalcTextSize(var_0_34.ICON_FA_BOLD)

		imgui.InvisibleButton("##39", var_262_31)
		imgui.SameLine(12)

		if imgui.IsItemHovered() then
			imgui.TextDisabled(var_0_34.ICON_FA_BOLD)

			if imgui.IsMouseClicked(0) then
				spisok = not spisok
			end
		else
			imgui.Text(var_0_34.ICON_FA_BOLD)
		end

		imgui.SameLine(32)
		imgui.InputText("##FriendBuf", var_0_50, imgui.InputTextFlags.EnterReturnsTrue)
		imgui.SameLine()

		if #var_0_50.v == 0 then
			imgui.SetCursorPos(imgui.ImVec2(55, 370.5))

			if spisok then
				imgui.Text(u8("Добавить в ЧС"))
			else
				imgui.Text(u8("Добавить друга"))
			end
		elseif spisok then
			if isKeyJustPressed(VK_RETURN) then
				caddbl(var_0_50.v)

				var_0_50.v = ""
			end
		elseif isKeyJustPressed(VK_RETURN) then
			cadd(var_0_50.v)

			var_0_50.v = ""
		end

		imgui.SameLine()

		if pop then
			imgui.OpenPopup("##s1")
		end

		if imgui.BeginPopupModal("##s1", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
			imgui.SetWindowSize(imgui.ImVec2(250, 100))
			imgui.TextWrapped(u8("Не придумал"))

			if isKeyJustPressed(VK_RETURN) then
				imgui.CloseCurrentPopup()

				pop = false
			end

			imgui.EndPopup()
		end

		imgui.End()
	end
end

function sampGetPlayers()
	local var_263_0 = {}

	for iter_263_0 = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(iter_263_0) then
			table.insert(var_263_0, iter_263_0)
		end
	end

	return var_263_0
end

banks = false
actualsumma = 0

function bankwithdraw(arg_264_0)
	local var_264_0 = arg_264_0:match("(%d+)")

	if arg_264_0 ~= var_264_0 then
		sampAddChatMessage(tag .. "Введите сумму снятия", -1)
	elseif arg_264_0 ~= var_264_0 and banks then
		banks = not banks

		sampAddChatMessage(tag .. "Снятие суммы деактивировано", -1)
	else
		actualsumma = var_264_0 / 100000
		actualsumma = tonumber(actualsumma)
		banks = not banks

		if banks then
			sampAddChatMessage(tag .. "Снятие суммы активировано", -1)
			lua_thread.create(function()
				for iter_265_0 = 1, actualsumma do
					wait(500)
					sampSendDialogResponse(9100, 1, 1, "")
					sampSendDialogResponse(9101, 1, _, "100000")

					if iter_265_0 == actualsumma then
						sampAddChatMessage(tag .. "Снятие суммы завершено.", -1)
					end
				end
			end)
		else
			sampAddChatMessage(tag .. "Снятие суммы деактивировано", -1)
		end
	end
end

function bankdeposit(arg_266_0)
	local var_266_0 = arg_266_0:match("(%d+)")

	if arg_266_0 ~= var_266_0 then
		sampAddChatMessage(tag .. "Введите сумму пополнения", -1)
	elseif arg_266_0 ~= var_266_0 and banks then
		banks = not banks

		sampAddChatMessage(tag .. "Пополнение суммы деактивировано", -1)
	else
		actualsumma = var_266_0 / 100000
		actualsumma = tonumber(actualsumma)
		banks = not banks

		if banks then
			sampAddChatMessage(tag .. "Пополнение суммы активировано", -1)
			lua_thread.create(function()
				for iter_267_0 = 1, actualsumma do
					wait(500)
					sampSendDialogResponse(9100, 1, 2, "")
					sampSendDialogResponse(9102, 1, _, "100000")

					if iter_267_0 == actualsumma then
						sampAddChatMessage(tag .. "Пополнение суммы завершено.", -1)
					end
				end
			end)
		else
			sampAddChatMessage(tag .. "Пополнение суммы деактивировано", -1)
		end
	end
end
