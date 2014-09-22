/*   

 /$$$$$$$$                                 /$$                     /$$$$$$$$ /$$$$$$$  /$$      /$$
|_____ $$                                 | $$                    |__  $$__/| $$__  $$| $$$    /$$$
     /$$/   /$$$$$$  /$$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$          | $$   | $$  \ $$| $$$$  /$$$$
    /$$/   |____  $$| $$__  $$ |____  $$|_  $$_/   /$$__  $$         | $$   | $$  | $$| $$ $$/$$ $$
   /$$/     /$$$$$$$| $$  \ $$  /$$$$$$$  | $$    | $$$$$$$$         | $$   | $$  | $$| $$  $$$| $$
  /$$/     /$$__  $$| $$  | $$ /$$__  $$  | $$ /$$| $$_____/         | $$   | $$  | $$| $$\  $ | $$
 /$$$$$$$$|  $$$$$$$| $$  | $$|  $$$$$$$  |  $$$$/|  $$$$$$$         | $$   | $$$$$$$/| $$ \/  | $$
|________/ \_______/|__/  |__/ \_______/   \___/   \_______/         |__/   |_______/ |__/     |__/


================= Drulutz: based on


*/

#include <a_samp>
#include <streamer>
#include <zcmd>
#include <sscanf2>
#include <a_mysql>
#include <time>
#include <lookup>
#include <OPFK>
#include <OPA>
#include <mSelection>
#include <vending>

#define version     "Zanate TDM v0.1"
#define function%1(%2) 		forward%1(%2); public%1(%2)


/* File paths */

#define PATH "ZTDM/Users/%s.ini"
#define CLAN_PATH "ZTDM/Clans/%d.ini"

/*Color Defines*/
#define COL_WHITE "{FFFFFF}"
#define COL_RED "{F81414}"
#define COL_GREEN "{00FF22}"
#define COLOR_LIGHTBLUE 0x006FDD96
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_FADE 0xC8C8C8C8
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5	0x6E6E6E6E
#define yellow 0xFFFF00AA
#define COLOR_RED 0xFF0000FF
#define	RADIO "{DC9508}"
#define COLOR_BLUE 0x0000BBAA
#define COLOR_GREEN 0x33AA33AA
#define FACTION_CHAT "{13B600}"
#define COLOR_GREEN 0x33AA33AA
#define COLOR_LIGHTRED 0xFF6347AA
#define orange 0xFF9900AA
#define	COLOR_LIGHTGREEN 0x9ACD32AA
#define	COLOR_PINK 0xFF66FFAA
#define COLOR_WHITE 0xFFFFFFAA
#define greenyellow 0xADFF2FAA
#define COLOR_GOLD 0xB8860BAA


#define ADMINRANK1                      "Junior Administrator"
#define ADMINRANK2                      "General Administrator"
#define ADMINRANK3                      "Senior Administrator"
#define ADMINRANK4                      "Head Administrator"
#define ADMINRANK5                      "Administrador Ejecutivo"
#define ADMINRANK6                      "Director"


/* Dialogs */

#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2
#define DIALOG_HELP 3
#define DIALOG_CREDITS 4
#define DIALOG_RULES 5
#define DIALOG_RANKS 6
#define DIALOG_CMDS 7
#define DIALOG_STATS 8
#define DIALOG_UPDATES 9
#define DIALOG_SHOP 10
#define DIALOG_ACMDS 11
#define DIALOG_ACMDS2 12
#define DIALOG_RADIO 13
#define DIALOG_VIP 14
#define DIALOG_CLAN 15
#define DIALOG_CLNAME 16
#define DIALOG_CLMOTD 17
#define DIALOG_CLRANK1 18
#define DIALOG_CLRANK2 19
#define DIALOG_CLRANK3 20
#define DIALOG_CLRANK4 21
#define DIALOG_CLRANK5 22
#define DIALOG_CLRANK6 23
#define DIALOG_CLSKIN 24
#define DIALOG_CCMDS 25
#define DIALOG_CLWEP1 26
#define DIALOG_CLWEP2 27
#define DIALOG_CLWEP3 28
#define DIALOG_CLWEP4 29


/* Teams */

#define TEAM_GROVE 1
#define TEAM_BALLAS 2
#define TEAM_VAGOS 3
#define TEAM_AZTECAS 4
#define TEAM_POLICE 5

#define MAX_CLANS 6
#define MAX_ZONES 14


/* Host */

/*#define host "localhost"
#define user "root"
#define db "samp"
#define pass ""*/

#define host "96.126.114.6"
#define user "SAMP"
#define db "samp"
#define pass "sanandreas"


static
    mysql,
    IP[MAX_PLAYERS][16],
    Name[MAX_PLAYERS][24]
    ;
    
native WP_Hash(buffer[], len, const str[]);

enum pInfo
{
	pID,
	pPass,
	pMoney,
	pAdmin,
	pVip,
	pKills,
	pDeaths,
	pScore,
	pRank,
	pBanned,
	pWarns,
	pVW,
	pInt,
	pMin,
	pHour,
	pPM,
	pColor,
	pTurfs,
	pClan,
	pClRank,
	pClLeader,
	pInvited,
	pInviting
}
new PlayerInfo[MAX_PLAYERS][pInfo];

enum cInfo
{
	cID,
	cName[128],
	cLeader[24],
	cMembers,
    cSkin,
    cMOTD[128],
	cRank1[64],
	cRank2[64],
	cRank3[64],
	cRank4[64],
	cRank5[64],
	cRank6[64],
	Float:cx,
	Float:cy,
	Float:cz,
	cWep1,
	cWep2,
	cWep3,
	cWep4
	
}
new ClanInfo[MAX_CLANS][cInfo];

enum zInfo
{
	zID,
	zName[128],
	Float:zMinX,
    Float:zMinY,
    Float:zMaxX,
    Float:zMaxY,
	Float:zCPX,
	Float:zCPY,
	Float:zCPZ,
	zTeam,
	zMoney,
	zEXP
}
new ZoneInfo[MAX_ZONES][zInfo];

new Logged[MAX_PLAYERS];
new Spawned[MAX_PLAYERS];
new MOTD[MAX_PLAYERS];
new gTeam[MAX_PLAYERS];
new OwnedZones[5];
new KillStreak[MAX_PLAYERS];
new ABCheck[MAX_PLAYERS];

new skinlist = mS_INVALID_LISTID;

/* Textdraws */

/* Login Textdraws */
new Text:Login1[MAX_PLAYERS];
new Text:Login2[MAX_PLAYERS];
new Text:Login3[MAX_PLAYERS];
new Text:Login4[MAX_PLAYERS];
new Text:Login5[MAX_PLAYERS];
new Text:Login6[MAX_PLAYERS];
new Text:Login7[MAX_PLAYERS];

/* Stats Textdraws */

new Text:Rank[MAX_PLAYERS];
new Text:Kills[MAX_PLAYERS];
new Text:Deaths[MAX_PLAYERS];
new Text:EXP[MAX_PLAYERS];

/* Damage Textdraws */

new Text:DMGP[MAX_PLAYERS];
new Text:DMGM[MAX_PLAYERS];

/* Server TextDraw */

new Text:CSWTD[MAX_PLAYERS];
new Text:CSWV[MAX_PLAYERS];

new Text:Zones[MAX_PLAYERS];

new CP[30];
new Zone[30];
new MoneyJob = 0;

new tCheck[MAX_PLAYERS];
new UnderAttack[30];

new timer[MAX_PLAYERS];
new PlayTimer[MAX_PLAYERS];

/* Timer Defines */

new Timers[4];


/* Arrays */

new randomMessages[][] =
{
	"{D37400}SERVER:{FFFFFF} ¡Dona para ayudarnos a mantener el servidor!",
  	"{D37400}SERVER:{FFFFFF} Visita nuestro website para mantenerte al tanto del servidor: zanate.net.",
   	"{D37400}SERVER:{FFFFFF} ¿Un hacker? Usa /report para enviar un reporte a los administradores, o haz una publicación en los foros.",
    "{D37400}SERVER:{FFFFFF} Usa /updates para saber qué ha cambiado en el servidor.",
    "{D37400}SERVER:{FFFFFF} /credits para mirar quiénes contribuyeron al desarrollo de este servidor.",
	"{D37400}SERVER:{FFFFFF} Romper las reglas te dará mala reputación y recibirás una penalización.",
    "{D37400}SERVER:{FFFFFF} ¿Tienes una sugerencia o encontraste un bug? Repórtalo/sugiérelo en zanate.net/foro",
    "{D37400}SERVER:{FFFFFF} Revisa zanate.net para ver qué otros juegos están disponibles en nuestro servidor.",
    "{D37400}SERVER:{FFFFFF} Rule 2: Drive by with Deagle and Combat shotgun is NOT allowed! Type /rules for full rule dialog.",
    "{D37400}SERVER:{FFFFFF} Rule 6: Car Parking/Ramming and Heliblading is NOT allowed! Type /rules for full rule dialog.",
    "{D37400}SERVER:{FFFFFF} ¿Sientes un poco calmado el juego? ¡Usa /radio para escuchar las estaciones de radio!"
};

new Float: moneyjobs[4][4] =
{
	{584.2956, -1271.2352, 17.0874, 190.0000},
	{-99.0431, -1172.5435, 2.6288, -25.0000},
	{1820.1152, -2446.2351, 13.4439, -45.0000},
	{1245.8828, -2037.2617, 59.9534, 270.0000}
};
	

/* Forwards */

forward LoadTextdraws();
forward LoadVehicles();
forward LoadObjects();
forward TextDrawUpdate(playerid);
forward ShowZones();
forward RankBonus(playerid);
forward MessageToAdmins(color, str[]);
forward MessageToGrove(color, str[]);
forward MessageToBallas(color, str[]);
forward MessageToVagos(color, str[]);
forward MessageToAztecas(color, str[]);
forward MessageToVip(color, str[]);
forward HideDMG(playerid);
forward HideDMGM(playerid);
forward RandomMessages();
forward PlayingTime(playerid);
forward AntiSpawnKill(playerid);
forward AntiCheat();
forward SendClanMessage(playerid, color, str[]);
forward SaveClans();

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Zanate Team Deathmatch");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
    mysql_log(LOG_ERROR | LOG_WARNING | LOG_DEBUG);
    mysql = mysql_connect(host, user, db, pass); 
    if(mysql_errno(mysql) != 0) print("Oh snap! Something went wrong, MySql connection failed!");

	SetGameModeText(version);
	AddPlayerClass(105, 2532.2742, -1667.6622, 15.1689, 93.1338, 0, 0, 0, 0, 0, 0); // Grove St
	AddPlayerClass(106, 2532.2742, -1667.6622, 15.1689, 93.1338, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(107, 2532.2742, -1667.6622, 15.1689, 93.1338, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(102, 2233.0496, -1159.8591, 25.8906, 89.1458, 0, 0, 0, 0, 0, 0); // Ballas
	AddPlayerClass(103, 2233.0496, -1159.8591, 25.8906, 89.1458, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(104, 2233.0496, -1159.8591, 25.8906, 89.1458, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(108, 2808.1206, -1176.0626, 25.3780, 182.4675, 0, 0, 0, 0, 0, 0); // Vagos
    AddPlayerClass(109, 2808.1206, -1176.0626, 25.3780, 182.4675, 0, 0, 0, 0, 0, 0); 
    AddPlayerClass(110, 2808.1206, -1176.0626, 25.3780, 182.4675, 0, 0, 0, 0, 0, 0); 
    AddPlayerClass(114, 1888.5951, -2000.9761, 13.5469, 91.0311, 0, 0, 0, 0, 0, 0); // Aztecas
    AddPlayerClass(115, 1888.5951, -2000.9761, 13.5469, 91.0311, 0, 0, 0, 0, 0, 0); 
    AddPlayerClass(116, 1888.5951, -2000.9761, 13.5469, 91.0311, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(280, 1555.1371, -1675.5571, 16.1953, 85.3241, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(281, 1555.1371, -1675.5571, 16.1953, 85.3241, 0, 0, 0, 0, 0, 0);
    AddPlayerClass(282, 1555.1371, -1675.5571, 16.1953, 85.3241, 0, 0, 0, 0, 0, 0);

	LoadTextdraws();
	LoadVehicles();
	LoadObjects();
	LoadClans();
	LoadZones();
	AntiDeAMX();
	
	skinlist = LoadModelSelectionMenu("skins.txt");
	
	DisableInteriorEnterExits();
	UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	
	Timers[0] = SetTimer("TextDrawUpdate", 1000, true);
	Timers[1] = SetTimer("RandomMessages", 240000, true);
	Timers[2] = SetTimer("SaveAccounts", 60000, true);
	Timers[3] = SetTimer("AntiCheat", 3000, true);
	

	CreatePickup(1274, 1, 2527.0146, -1663.9749, 14.8662, -1);
	Create3DTextLabel("[Grove Street Shop]\n Type /shop to shop", COLOR_RED, 2527.0146, -1663.9749, 15.4662, 40.0, 0, 1);
    CreatePickup(1274, 1, 1872.0562, -2011.1937, 13.2469, -1);
  	Create3DTextLabel("[Aztecas Shop]\n Type /shop to shop", COLOR_RED, 1872.0562, -2011.1937, 13.8469, 40.0, 0, 1);
	CreatePickup(1274, 1, 2233.0354, -1180.0729, 25.5972, -1);
	Create3DTextLabel("[Ballas Shop]\n Type /shop to shop", COLOR_RED, 2233.0354, -1180.0729, 26.1972, 40.0, 0, 1);
	CreatePickup(1274, 1, 2808.0178, -1190.5220, 25.0437, -1);
    Create3DTextLabel("[Vagos Shop]\n Type /shop to shop", COLOR_RED, 2808.0178, -1190.5220, 25.6437, 40.0, 0, 1);
    CreatePickup(1274, 1, 1550.8929, -1669.9216, 13.3615, -1);
    Create3DTextLabel("[Police Shop]\n Type /shop to shop", COLOR_RED, 1550.8929, -1669.9216, 13.9615, 40.0, 0, 1);
	return 1;
}

public OnGameModeExit()
{
    for(new i=0;i<MAX_PLAYERS;i++)
	{
		TextDrawDestroy(Login1[i]);
	    TextDrawDestroy(Login2[i]);
	    TextDrawDestroy(Login3[i]);
	    TextDrawDestroy(Login4[i]);
	    TextDrawDestroy(Login5[i]);
		TextDrawDestroy(Login6[i]);
		TextDrawDestroy(Login7[i]);
		TextDrawDestroy(Rank[i]);
		TextDrawDestroy(Kills[i]);
		TextDrawDestroy(Deaths[i]);
		TextDrawDestroy(EXP[i]);
		TextDrawDestroy(CSWTD[i]);
		TextDrawDestroy(CSWV[i]);
		SaveAccountStats(i);
	}
	SaveClans();
	KillTimer(Timers[0]);
	KillTimer(Timers[1]);
	KillTimer(Timers[2]);
	KillTimer(Timers[3]);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	ResetPlayerWeapons(playerid);
	Spawned[playerid] = 0;
	switch (classid)
	{
		case 0:
		{
			gTeam[playerid] = TEAM_GROVE;
			SetPlayerTeam(playerid, TEAM_GROVE);
            GameTextForPlayer(playerid, "~g~Grove Street", 3000, 6);
			SetPlayerPos(playerid, 2532.2742, -1667.6622, 15.1689);
			SetPlayerFacingAngle(playerid, 93.1338);
			SetPlayerCameraPos(playerid, 2528.7200, -1667.9076, 15.1691);
			SetPlayerCameraLookAt(playerid, 2532.2742, -1667.6622, 15.1689);
		}
		case 1:
		{
			gTeam[playerid] = TEAM_GROVE;
 			SetPlayerTeam(playerid, TEAM_GROVE);
            GameTextForPlayer(playerid, "~g~Grove Street", 3000, 6);
			SetPlayerPos(playerid, 2532.2742, -1667.6622, 15.1689);
			SetPlayerFacingAngle(playerid, 93.1338);
			SetPlayerCameraPos(playerid, 2528.7200, -1667.9076, 15.1691);
			SetPlayerCameraLookAt(playerid, 2532.2742, -1667.6622, 15.1689);
		}
		case 2:
		{
			gTeam[playerid] = TEAM_GROVE;
 			SetPlayerTeam(playerid, TEAM_GROVE);
            GameTextForPlayer(playerid, "~g~Grove Street", 3000, 6);
			SetPlayerPos(playerid, 2532.2742, -1667.6622, 15.1689);
			SetPlayerFacingAngle(playerid, 93.1338);
			SetPlayerCameraPos(playerid, 2528.7200, -1667.9076, 15.1691);
			SetPlayerCameraLookAt(playerid, 2532.2742, -1667.6622, 15.1689);
		}
		case 3:
		{
			gTeam[playerid] = TEAM_BALLAS;
 			SetPlayerTeam(playerid, TEAM_BALLAS);
            GameTextForPlayer(playerid, "~p~Ballas", 3000, 6);
			SetPlayerPos(playerid, 2233.0496, -1159.8591, 25.8906);
			SetPlayerFacingAngle(playerid, 89.1458);
			SetPlayerCameraPos(playerid, 2229.8494,-1159.9083,25.8243);
			SetPlayerCameraLookAt(playerid, 2233.0496, -1159.8591, 25.8906);
		}
		case 4:
		{
			gTeam[playerid] = TEAM_BALLAS;
 			SetPlayerTeam(playerid, TEAM_BALLAS);
            GameTextForPlayer(playerid, "~p~Ballas", 3000, 6);
			SetPlayerPos(playerid, 2233.0496, -1159.8591, 25.8906);
			SetPlayerFacingAngle(playerid, 89.1458);
			SetPlayerCameraPos(playerid, 2229.8494,-1159.9083,25.8243);
			SetPlayerCameraLookAt(playerid, 2233.0496, -1159.8591, 25.8906);
		}
		case 5:
		{
			gTeam[playerid] = TEAM_BALLAS;
 			SetPlayerTeam(playerid, TEAM_BALLAS);
            GameTextForPlayer(playerid, "~p~Ballas", 3000, 6);
			SetPlayerPos(playerid, 2233.0496, -1159.8591, 25.8906);
			SetPlayerFacingAngle(playerid, 89.1458);
			SetPlayerCameraPos(playerid, 2229.8494,-1159.9083,25.8243);
			SetPlayerCameraLookAt(playerid, 2233.0496, -1159.8591, 25.8906);
		}
		case 6:
		{
		    gTeam[playerid] = TEAM_VAGOS;
		    SetPlayerTeam(playerid, TEAM_VAGOS);
		    GameTextForPlayer(playerid, "~y~Vagos", 3000, 6);
		    SetPlayerPos(playerid, 2808.1206, -1176.0626, 25.3780);
			SetPlayerFacingAngle(playerid, 182.4675);
			SetPlayerCameraPos(playerid, 2808.1184, -1179.0657, 25.3711);
			SetPlayerCameraLookAt(playerid, 2808.1206, -1176.0626, 25.3780);
		}
		case 7:
		{
		    gTeam[playerid] = TEAM_VAGOS;
		    SetPlayerTeam(playerid, TEAM_VAGOS);
		    GameTextForPlayer(playerid, "~y~Vagos", 3000, 6);
		    SetPlayerPos(playerid, 2808.1206, -1176.0626, 25.3780);
			SetPlayerFacingAngle(playerid, 182.4675);
			SetPlayerCameraPos(playerid, 2808.1184, -1179.0657, 25.3711);
			SetPlayerCameraLookAt(playerid, 2808.1206, -1176.0626, 25.3780);
		}
		case 8:
		{
		    gTeam[playerid] = TEAM_VAGOS;
		    SetPlayerTeam(playerid, TEAM_VAGOS);
		    GameTextForPlayer(playerid, "~y~Vagos", 3000, 6);
		    SetPlayerPos(playerid, 2808.1206, -1176.0626, 25.3780);
			SetPlayerFacingAngle(playerid, 182.4675);
			SetPlayerCameraPos(playerid, 2808.1184, -1179.0657, 25.3711);
			SetPlayerCameraLookAt(playerid, 2808.1206, -1176.0626, 25.3780);
		}
		case 9:
		{
		    gTeam[playerid] = TEAM_AZTECAS;
		    SetPlayerTeam(playerid, TEAM_AZTECAS);
		    GameTextForPlayer(playerid, "~b~~h~~h~~h~Aztecas", 3000, 6);
		    SetPlayerPos(playerid, 1888.5951, -2000.9761, 13.5469);
			SetPlayerFacingAngle(playerid, 91.0311);
			SetPlayerCameraPos(playerid, 1885.6624, -2000.9890, 13.5469);
			SetPlayerCameraLookAt(playerid, 1888.5951, -2000.9761, 13.5469);
		}
		case 10:
		{
		    gTeam[playerid] = TEAM_AZTECAS;
		    SetPlayerTeam(playerid, TEAM_AZTECAS);
		    GameTextForPlayer(playerid, "~b~~h~~h~~h~Aztecas", 3000, 6);
		    SetPlayerPos(playerid, 1888.5951, -2000.9761, 13.5469);
			SetPlayerFacingAngle(playerid, 91.0311);
			SetPlayerCameraPos(playerid, 1885.6624, -2000.9890, 13.5469);
			SetPlayerCameraLookAt(playerid, 1888.5951, -2000.9761, 13.5469);
		}
		case 11:
		{
		    gTeam[playerid] = TEAM_AZTECAS;
		    SetPlayerTeam(playerid, TEAM_AZTECAS);
		    GameTextForPlayer(playerid, "~b~~h~~h~~h~Aztecas", 3000, 6);
		    SetPlayerPos(playerid, 1888.5951, -2000.9761, 13.5469);
			SetPlayerFacingAngle(playerid, 91.0311);
			SetPlayerCameraPos(playerid, 1885.6624, -2000.9890, 13.5469);
			SetPlayerCameraLookAt(playerid, 1888.5951, -2000.9761, 13.5469);
		}
		case 12:
		{
		    gTeam[playerid] = TEAM_POLICE;
		    SetPlayerTeam(playerid, TEAM_POLICE);
		    GameTextForPlayer(playerid, "~b~Police", 3000, 6);
		    SetPlayerPos(playerid, 1555.1371, -1675.5571, 16.1953);
			SetPlayerFacingAngle(playerid, 85.3241);
			SetPlayerCameraPos(playerid, 1552.2231,-1675.6582,16.1953);
			SetPlayerCameraLookAt(playerid, 1555.1371, -1675.5571, 16.1953);
		}
		case 13:
		{
		    gTeam[playerid] = TEAM_POLICE;
		    SetPlayerTeam(playerid, TEAM_POLICE);
		    GameTextForPlayer(playerid, "~b~Police", 3000, 6);
		    SetPlayerPos(playerid, 1555.1371, -1675.5571, 16.1953);
			SetPlayerFacingAngle(playerid, 85.3241);
			SetPlayerCameraPos(playerid, 1552.2231,-1675.6582,16.1953);
			SetPlayerCameraLookAt(playerid, 1555.1371, -1675.5571, 16.1953);
		}
		case 14:
		{
		    gTeam[playerid] = TEAM_POLICE;
		    SetPlayerTeam(playerid, TEAM_POLICE);
		    GameTextForPlayer(playerid, "~b~Police", 3000, 6);
		    SetPlayerPos(playerid, 1555.1371, -1675.5571, 16.1953);
			SetPlayerFacingAngle(playerid, 85.3241);
			SetPlayerCameraPos(playerid, 1552.2231,-1675.6582,16.1953);
			SetPlayerCameraLookAt(playerid, 1555.1371, -1675.5571, 16.1953);
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{

    ResetPlayerWeapons(playerid);
	Logged[playerid] = 0;
	Spawned[playerid] = 0;
	MOTD[playerid] = 0;
	gTeam[playerid] = 0;
	KillStreak[playerid] = 0;
	ABCheck[playerid] = 0;
	PlayerInfo[playerid][pMoney] = 0;
	PlayerInfo[playerid][pAdmin] = 0;
	PlayerInfo[playerid][pVip] = 0;
	PlayerInfo[playerid][pKills] = 0;
	PlayerInfo[playerid][pDeaths] = 0;
	PlayerInfo[playerid][pScore] = 0;
	PlayerInfo[playerid][pRank] = 0;
	PlayerInfo[playerid][pBanned] = 0;
	PlayerInfo[playerid][pWarns] = 0;
	PlayerInfo[playerid][pVW] = 0;
	PlayerInfo[playerid][pInt] = 0;
	PlayerInfo[playerid][pMin] = 0;
	PlayerInfo[playerid][pHour] = 0;
	PlayerInfo[playerid][pPM] = 0;
	PlayerInfo[playerid][pColor] = 0;
	PlayerInfo[playerid][pTurfs] = 0;
	PlayerInfo[playerid][pClan] = 0;
	PlayerInfo[playerid][pClRank] = 0;
	PlayerInfo[playerid][pClLeader] = 0;
	PlayerInfo[playerid][pInvited] = 0;
	PlayerInfo[playerid][pInviting] = 0;
	SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);

	/* Login screen */
	
    
	SetPlayerColor(playerid, 0xAFAFAFAA);
 	GameTextForPlayer(playerid, "~w~Loading... Please wait.", 3000, 3);
    SetTimerEx("LoggingTimer", 3000, false, "i", playerid);
	SetPlayerPos(playerid, -2914.0830,499.6014,13.3667);
	SetPlayerVirtualWorld(playerid, 1);
    TogglePlayerSpectating(playerid, true);
    PlayAudioStreamForPlayer(playerid, "http://k007.kiwi6.com/hotlink/16qa6qewam/Gangster_s_Paradise_-_Coolio.mp3");

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SendDeathMessage(INVALID_PLAYER_ID, playerid, 201);
	SaveAccountStats(playerid);
    Logged[playerid] = 0;
    Spawned[playerid] = 0;
	MOTD[playerid] = 0;
	gTeam[playerid] = 0;
    KillStreak[playerid] = 0;
    ABCheck[playerid] = 0;
	KillTimer(timer[playerid]);
	KillTimer(PlayTimer[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	new string[128];
	ResetPlayerWeapons(playerid);
	Spawned[playerid] = 1;
	SetPlayerHealth(playerid, 10000.0);
	SendClientMessage(playerid, orange, "ANTI SPAWN KILL:{FFFFFF} You have 5 seconds of Anti Spawn Kill protection.");
    SetPlayerChatBubble(playerid, "Anti Spawn Kill Protected", COLOR_RED, 100.0, 5000);
    SetTimerEx("AntiSpawnKill", 5000, false, "i", playerid);
	if(PlayerInfo[playerid][pClan] != 0)
	{
	    SetPlayerPos(playerid, ClanInfo[PlayerInfo[playerid][pClan]-1][cx], ClanInfo[PlayerInfo[playerid][pClan]][cy], ClanInfo[PlayerInfo[playerid][pClan]][cz]);
        SetPlayerSkin(playerid, ClanInfo[PlayerInfo[playerid][pClan]-1][cSkin]);
		GivePlayerWeapon(playerid, ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1], 1);
		GivePlayerWeapon(playerid, ClanInfo[PlayerInfo[playerid][pClan]-1][cWep2], 150);
		GivePlayerWeapon(playerid, ClanInfo[PlayerInfo[playerid][pClan]-1][cWep3], 300);
		GivePlayerWeapon(playerid, ClanInfo[PlayerInfo[playerid][pClan]-1][cWep4], 350);
		if(MOTD[playerid] == 0)
	    {
			format(string, sizeof(string), "CL-MOTD:{FFFFFF} %s", ClanInfo[PlayerInfo[playerid][pClan]-1][cMOTD]);
			SendClientMessage(playerid, greenyellow, string);
			MOTD[playerid] = 1;
		}
		switch(gTeam[playerid])
		{
		    case TEAM_GROVE:
		    {
		        SetPlayerColor(playerid, 0x33AA33AA);
			}
			case TEAM_BALLAS:
			{
			    SetPlayerColor(playerid, 0xC2A2DAAA);
			}
			case TEAM_VAGOS:
			{
			    SetPlayerColor(playerid, 0xFFFF00AA);
			}
			case TEAM_AZTECAS:
			{
			    SetPlayerColor(playerid, 0x33CCFFAA);
			}
			case TEAM_POLICE:
			{
			    SetPlayerColor(playerid, 0x0000BBAA);
			}
		}
	}
	else if(gTeam[playerid] == TEAM_GROVE)
	{
	    SetPlayerColor(playerid, 0x33AA33AA);
	    GivePlayerWeapon(playerid, 5, 1);
	    GivePlayerWeapon(playerid, 24, 150);
	    GivePlayerWeapon(playerid, 25, 100);
	    GivePlayerWeapon(playerid, 31, 250);
	}
	else if(gTeam[playerid] == TEAM_BALLAS)
	{
	    SetPlayerColor(playerid, 0xC2A2DAAA);
	    GivePlayerWeapon(playerid, 5, 1);
	    GivePlayerWeapon(playerid, 24, 150);
	    GivePlayerWeapon(playerid, 25, 100);
	    GivePlayerWeapon(playerid, 29, 250);
	}
	else if(gTeam[playerid] == TEAM_VAGOS)
	{
	    SetPlayerColor(playerid, 0xFFFF00AA);
	    GivePlayerWeapon(playerid, 4, 1);
	    GivePlayerWeapon(playerid, 24, 150);
	    GivePlayerWeapon(playerid, 25, 100);
	    GivePlayerWeapon(playerid, 31, 250);
	}
	else if(gTeam[playerid] == TEAM_AZTECAS)
	{
	    SetPlayerColor(playerid, 0x33CCFFAA);
	    GivePlayerWeapon(playerid, 5, 1);
	    GivePlayerWeapon(playerid, 24, 150);
	    GivePlayerWeapon(playerid, 25, 100);
	    GivePlayerWeapon(playerid, 30, 250);
	}
	else if(gTeam[playerid] == TEAM_POLICE)
	{
	    SetPlayerColor(playerid, 0x0000BBAA);
	    GivePlayerWeapon(playerid, 3, 1);
	    GivePlayerWeapon(playerid, 24, 150);
	    GivePlayerWeapon(playerid, 25, 100);
	    GivePlayerWeapon(playerid, 31, 250);
	}
	else if(PlayerInfo[playerid][pColor] == 1)
	{
	    SetPlayerColor(playerid, 0xB8860BAA);
	}
	RankBonus(playerid);
	ShowZones();
	TextDrawShowForPlayer(playerid,CSWTD[playerid]);
	TextDrawShowForPlayer(playerid,CSWV[playerid]);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new string[128];
	SendDeathMessage(killerid, playerid, reason);
	SendClientMessage(killerid, COLOR_RED, "{00FF22}KILL:{FFFFFF} ¡Has matado a un enemigo! +1 exp y $500");
	format(string, sizeof(string), "DEATH:{FFFFFF} Has sido asesinado por %s, - 300$.", GetName(killerid));
	SendClientMessage(playerid, COLOR_RED, string);
	PlayerPlaySound(killerid, 1057, 0, 0, 0);
	PlayerInfo[playerid][pDeaths]++;
	PlayerInfo[killerid][pKills]++;
    PlayerInfo[killerid][pScore]++;
    SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
	GivePlayerMoney(killerid, 500);
    PlayerInfo[killerid][pMoney] += 500;
	GivePlayerMoney(playerid, -300);
	PlayerInfo[playerid][pMoney] -= 300;
    GivePlayerMoney(playerid, 100);
	KillStreak[killerid]++;
	KillStreak[playerid] = 0;
	KillTimer(timer[playerid]);
	Spawned[playerid] = 0;
	switch(KillStreak[killerid])
	{
	    case 3:
	    {
	        format(string, sizeof(string), "{DD8C00}KILL STREAK:{FFFFFF} ¡%s ha hecho una Multi Kill!", GetName(killerid));
	        SendClientMessageToAll(orange, string);
	        GameTextForPlayer(killerid, "~y~Multi Kill!", 2000, 6);
			SendClientMessage(killerid, COLOR_RED, "{DD8C00}KILL STREAK:{FFFFFF} Multi Kill! +3 EXP + $2500");
			GivePlayerMoney(killerid, 2500);
			PlayerInfo[killerid][pMoney] += 2500;
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 3);
			PlayerInfo[killerid][pScore] += 3;
		}
		case 5:
		{
		    format(string, sizeof(string), "{DD8C00}KILL STREAK:{FFFFFF} ¡%s ha logrado una Mega Kill!", GetName(killerid));
	        SendClientMessageToAll(orange, string);
	        GameTextForPlayer(killerid, "~y~Mega Kill!", 2000, 6);
			SendClientMessage(killerid, COLOR_RED, "{DD8C00}KILL STREAK:{FFFFFF} Mega Kill! +5 EXP + $3000");
			GivePlayerMoney(killerid, 3000);
            PlayerInfo[killerid][pMoney] += 3000;
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 5);
			PlayerInfo[killerid][pScore] += 5;
		}
		case 7:
		{
		    format(string, sizeof(string), "{DD8C00}KILL STREAK:{FFFFFF} ¡%s ha alcanzado una Monster Killing Spree!", GetName(killerid));
	        SendClientMessageToAll(orange, string);
	        GameTextForPlayer(killerid, "~r~Monster Killing Spree!", 2000, 6);
			SendClientMessage(killerid, COLOR_RED, "{DD8C00}KILL STREAK:{FFFFFF} Monster Killing Spree! +8 EXP + $4000");
			GivePlayerMoney(killerid, 4000);
            PlayerInfo[killerid][pMoney] += 4000;
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 8);
			PlayerInfo[killerid][pScore] += 8;
		}
		case 10:
		{
		    format(string, sizeof(string), "{DD8C00}KILL STREAK:{FFFFFF} ¡¡%s está dominando!!", GetName(killerid));
	        SendClientMessageToAll(orange, string);
	        GameTextForPlayer(killerid, "~r~Dominating!!", 2000, 6);
			SendClientMessage(killerid, COLOR_RED, "{DD8C00}KILL STREAK:{FFFFFF} ¡¡Dominando!! +12 EXP + $5500");
			GivePlayerMoney(killerid, 5500);
            PlayerInfo[killerid][pMoney] += 5500;
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 12);
			PlayerInfo[killerid][pScore] += 12;
		}
		case 15:
		{
		    format(string, sizeof(string), "{DD8C00}KILL STREAK:{FFFFFF} ¡%s es imparable!!", GetName(killerid));
	        SendClientMessageToAll(orange, string);
	        GameTextForPlayer(killerid, "~r~Unstoppable!!", 2000, 6);
			SendClientMessage(killerid, COLOR_RED, "{DD8C00}KILL STREAK:{FFFFFF} ¡¡Imparable!! +20 EXP + $8500");
			GivePlayerMoney(killerid, 8500);
            PlayerInfo[killerid][pMoney] += 8500;
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 20);
			PlayerInfo[killerid][pScore] += 20;
		}
		case 25:
		{
		    format(string, sizeof(string), "{DD8C00}KILL STREAK:{FFFFFF} ¡¡¡%s ha conseguido una Madness Spree!!!", GetName(killerid));
	        SendClientMessageToAll(orange, string);
	        GameTextForPlayer(killerid, "~r~Madness Spree!!!", 2000, 6);
			SendClientMessage(killerid, COLOR_RED, "{DD8C00}KILL STREAK:{FFFFFF} Madness Spree!!! +35 EXP + 15500$");
			GivePlayerMoney(killerid, 15500);
            PlayerInfo[killerid][pMoney] += 15500;
			SetPlayerArmour(killerid, 100.0);
	        SetPlayerHealth(killerid, 100.0);
			SetPlayerScore(killerid, GetPlayerScore(killerid) + 35);
			PlayerInfo[killerid][pScore] += 35;
		}
	}
	if(gettime() - GetPVarInt(playerid,"PlayerLastDeath") < 1)
    {
		PlayerInfo[playerid][pBanned] = 1;
		GetPlayerIp(playerid, IP[playerid], 16);
		format(string, sizeof(string), "banip %s", IP[playerid]);
		SendRconCommand(string);
		format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por "fake killing".", GetName(playerid));
		SendClientMessageToAll(COLOR_RED, string);
		SendClientMessage(playerid, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por "fake killing", si creés que el ban es equivocado, repórtalo en zanate.net/foro.");
		KickPlayer(playerid);
	}
	SetPVarInt(playerid,"PlayerLastDeath",gettime());
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new string[128];
	if(Logged[playerid] == 0) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Necesitas estar dentro del juego para chatear.");
	else
	{
		format(string, sizeof(string), "%s(%d):{FFFFFF} %s", GetName(playerid), playerid, text);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
	}
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER)
    {
        SetPlayerArmedWeapon(playerid, 0);
    }
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new string[128], query[1024];
	if (strfind(inputtext, "%", false) != -1)
	{
		SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Nombre de personaje inválido.");
	    return 0;
	}
	if(dialogid == DIALOG_REGISTER)
	{
		if(!response) Kick(playerid);
     	else if(response)
      	{
			if(response)
			{
   				if(strlen(inputtext) < 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "CSW", "{F81414}ERROR:{FFFFFF} Your password must have at least 5 characters!\nType in your desired password below to register.", "Register", "Quit");
	     		WP_Hash(PlayerInfo[playerid][pPass], 129, inputtext);
	     		mysql_format(mysql, query, sizeof(query), "INSERT INTO `users` (`Username`, `Password`, `IP`, `Money`, `Admin`, `Vip`, `Kills` ,`Deaths`, `Score`, `Rank`, `Banned`, `Warns`, `VW`, `Interior`, `Min`, `Hours`, `PM`, `Color`, `Turfs`, `Clan`, `ClRank`, `ClLeader`, `Invited`, `Inviting`  ) VALUES ('%e', '%s', '%s', 500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)", Name[playerid], PlayerInfo[playerid][pPass], IP[playerid]);
	     		mysql_tquery(mysql, query, "OnAccountRegister", "i", playerid);
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Success!", "{FFFFFF}Successfully registered!\nType in your password below to login.", "Login", "Quit");
			}
		}
    }
    else if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);
        else
  		{
   			new hpass[129];
     		WP_Hash(hpass, 129, inputtext);
      		if(!strcmp(hpass, PlayerInfo[playerid][pPass]))
       		{
         		mysql_format(mysql, query, sizeof(query), "SELECT * FROM `users` WHERE `Username` = '%e' LIMIT 1", Name[playerid]);
          		mysql_tquery(mysql, query, "OnAccountLoad", "i", playerid);
                TextDrawHideForPlayer(playerid,Login1[playerid]);
			    TextDrawHideForPlayer(playerid,Login2[playerid]);
			    TextDrawHideForPlayer(playerid,Login3[playerid]);
			    TextDrawHideForPlayer(playerid,Login4[playerid]);
			    TextDrawHideForPlayer(playerid,Login5[playerid]);
			    TextDrawHideForPlayer(playerid,Login6[playerid]);
			    TextDrawHideForPlayer(playerid,Login7[playerid]);
				TogglePlayerSpectating(playerid, false);
				PlayTimer[playerid] = SetTimerEx("PlayingTime", 60000, 1, "i", playerid);
				StopAudioStreamForPlayer(playerid);
			}
			else
   			{
      			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_MSGBOX,""COL_RED"KICKED",""COL_RED"Has sido desconectado por introducir una contraseña incorrecta.","QUIT","");
				KickPlayer(playerid);
			}
   			return 1;
   		}
   	}
   	else if(dialogid == DIALOG_RULES)
   	{
   	    if(!response)
   	    {
   	        KickPlayer(playerid);
			SendClientMessage(playerid, COLOR_RED, "KICK:{FFFFFF} Has sido desconectado del servidor.");
			SendClientMessage(playerid, COLOR_RED, "REASON:{FFFFFF} Falta de acatamiento a las reglas.");
		}
	}
	else if(dialogid == DIALOG_SHOP)
	{
	    if(!response) return 1;
	    else if(response)
	    {
			switch(listitem)
			{
			    case 0:
			    {
			        if(PlayerInfo[playerid][pMoney] < 500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -500);
					PlayerInfo[playerid][pMoney] -= 500;
					GivePlayerWeapon(playerid, 9, 1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una sierra (chainsaw) por $500.");
				}
				case 1:
				{
				    if(PlayerInfo[playerid][pMoney] < 1500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -1500);
					PlayerInfo[playerid][pMoney] -= 1500;
					GivePlayerWeapon(playerid, 22, 300);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una Colt 45 por $1500.");
				}
				case 2:
				{
				    if(PlayerInfo[playerid][pMoney] < 2000) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -2000);
					PlayerInfo[playerid][pMoney] -= 2000;
					GivePlayerWeapon(playerid, 23, 300);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una pistola con silenciador (Silenced Pistol) for $2000.");
				}
				case 3:
				{
				    if(PlayerInfo[playerid][pMoney] < 3000) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -3000);
					PlayerInfo[playerid][pMoney] -= 3000;
					GivePlayerWeapon(playerid, 24, 300);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una Desert Eagle por $3000.");
				}
				case 4:
				{
				    if(PlayerInfo[playerid][pMoney] < 3500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, - 3500);
					PlayerInfo[playerid][pMoney] -= 3500;
					GivePlayerWeapon(playerid, 25, 300);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una pistola (Shotgun) for $3500.");
                }
                case 5:
                {
                    if(PlayerInfo[playerid][pMoney] < 4500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -4500);
					PlayerInfo[playerid][pMoney] -= 4500;
					GivePlayerWeapon(playerid, 26, 300);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una Sawn Off Shotgun por $4500.");
                }
                case 6:
                {
                    if(PlayerInfo[playerid][pMoney] < 8500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -8500);
					PlayerInfo[playerid][pMoney] -= 8500;
					GivePlayerWeapon(playerid, 27, 300);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una Combat Shotgun por $8500.");
                }
                case 7:
                {
                    if(PlayerInfo[playerid][pMoney] < 3500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -3500);
					PlayerInfo[playerid][pMoney] -= 3500;
					GivePlayerWeapon(playerid, 28, 500);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una UZI por $3500.");
                }
                case 8:
                {
                    if(PlayerInfo[playerid][pMoney] < 3500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -3500);
					PlayerInfo[playerid][pMoney] -= 3500;
					GivePlayerWeapon(playerid, 32, 500);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una Tec-9 por $3500.");
                }
                case 9:
                {
                    if(PlayerInfo[playerid][pMoney] < 5500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -5500);
					PlayerInfo[playerid][pMoney] -= 5500;
					GivePlayerWeapon(playerid, 29, 500);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una MP5 por $5500.");
                }
                case 10:
                {
                    if(PlayerInfo[playerid][pMoney] < 7500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -7500);
					PlayerInfo[playerid][pMoney] -= 7500;
					GivePlayerWeapon(playerid, 30, 500);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una AK-47 por $7500.");
                }
                case 11:
                {
                    if(PlayerInfo[playerid][pMoney] < 8000) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -8000);
					PlayerInfo[playerid][pMoney] -= 8000;
					GivePlayerWeapon(playerid, 31, 500);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una M4 por $8000.");
                }
                case 12:
                {
                    if(PlayerInfo[playerid][pMoney] < 10000) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -10000);
					PlayerInfo[playerid][pMoney] -= 10000;
					GivePlayerWeapon(playerid, 34, 150);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado un rifle con mira (Sniper) por $10000.");
                }
                case 13:
                {
                    if(PlayerInfo[playerid][pMoney] < 2500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -2500);
					PlayerInfo[playerid][pMoney] -= 2500;
					GivePlayerWeapon(playerid, 16, 1);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una granada (Grenade) por $2500.");
                }
                case 14:
                {
                    if(PlayerInfo[playerid][pMoney] < 1500) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No tienes suficiente dinero para comprar esto.");
					GivePlayerMoney(playerid, -1500);
					PlayerInfo[playerid][pMoney] -= 1500;
					SetPlayerArmour(playerid, 100.0);
                    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has comprado una armadura (Armour) por $1500.");
                }
			}
		}
	}
	else if(dialogid == DIALOG_ACMDS)
	{
		new acmds[1024];
		if(!response) return 1;
	    else if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
					strcat(acmds, "{00FF22}/spec{FFFFFF} - Spectates a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/endspec{FFFFFF} - Stops spectating a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/kick{FFFFFF} - Kicks a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/goto{FFFFFF} - Teleports you to a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/a{FFFFFF} - Sends a message to other Administrators.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/check{FFFFFF} - Shows player's stats.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/forcerules{FFFFFF} - Opens the rules dialog for a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/setint{FFFFFF} - Sets player's interior.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/setvw{FFFFFF} - Sets player's virtual world.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/freeze{FFFFFF} - Freezes a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/unfreeze{FFFFFF} - Unfreezes a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/clearcheck{FFFFFF} - Clears player's anti airbreak check.\n", sizeof(acmds));
					ShowPlayerDialog(playerid, DIALOG_ACMDS2, DIALOG_STYLE_MSGBOX, "Level 1", acmds, "Okay", "");
				}
				case 1:
				{
					strcat(acmds, "{00FF22}/slap{FFFFFF} - Slaps a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/ban{FFFFFF} - Bans a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/banip{FFFFFF} - Bans a IP.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/gethere{FFFFFF} - Teleports a player to you.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/giveexp{FFFFFF} - Gives EXP points to a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/warn{FFFFFF} - Gives a warning to a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/ann{FFFFFF} - Sends announce message.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/fixveh{FFFFFF} - Fixes your vehicle.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/cc{FFFFFF} - Clears the chat.\n", sizeof(acmds));
					ShowPlayerDialog(playerid, DIALOG_ACMDS2, DIALOG_STYLE_MSGBOX, "Level 2", acmds, "Okay", "");
				}
				case 2:
				{
					strcat(acmds, "{00FF22}/setexp{FFFFFF} - Sets player's EXP.\n", sizeof(acmds));
                    strcat(acmds, "{00FF22}/unwarn{FFFFFF} - Removes a warning from a player.\n", sizeof(acmds));
                    strcat(acmds, "{00FF22}/sethealth{FFFFFF} - Sets player's health.\n", sizeof(acmds));
                    strcat(acmds, "{00FF22}/setarmour{FFFFFF} - Sets player's armour.\n", sizeof(acmds));
                    strcat(acmds, "{00FF22}/setkills{FFFFFF} - Sets player's kills.\n", sizeof(acmds));
                    strcat(acmds, "{00FF22}/setdeaths{FFFFFF} - Sets player's deaths.\n", sizeof(acmds));
					ShowPlayerDialog(playerid, DIALOG_ACMDS2, DIALOG_STYLE_MSGBOX, "Level 3", acmds, "Okay", "");
				}
				case 3:
				{
				    
				    strcat(acmds, "{00FF22}/unban{FFFFFF} - Unbans a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/unbanip{FFFFFF} - Unbans a IP.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/blowup{FFFFFF} - Blows up a player.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/changename{FFFFFF} - Changes player's name.\n", sizeof(acmds));
				    ShowPlayerDialog(playerid, DIALOG_ACMDS2, DIALOG_STYLE_MSGBOX, "Level 4", acmds, "Okay", "");
				}
				case 4:
				{
				    strcat(acmds, "{00FF22}/makeadmin{FFFFFF} - Sets player's admin level.\n", sizeof(acmds));
				    strcat(acmds, "{00FF22}/makeleader{FFFFFF} - Sets player as a leader of a clan.\n", sizeof(acmds));
				    ShowPlayerDialog(playerid, DIALOG_ACMDS2, DIALOG_STYLE_MSGBOX, "Level 5", acmds, "Okay", "");
				}
				case 5:
				{
				    strcat(acmds, "{00FF22}/makevip{FFFFFF} - Sets player's VIP level.\n", sizeof(acmds));
				    ShowPlayerDialog(playerid, DIALOG_ACMDS2, DIALOG_STYLE_MSGBOX, "Level 1337", acmds, "Okay", "");
				}
				case 6:
				{
				    strcat(acmds, "{00FF22}/tod{FFFFFF} - Sets the time of day.\n", sizeof(acmds));
				    ShowPlayerDialog(playerid, DIALOG_ACMDS2, DIALOG_STYLE_MSGBOX, "Level 1338", acmds, "Okay", "");
				}
			}
		}
	}
	else if(dialogid == DIALOG_RADIO)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                PlayAudioStreamForPlayer(playerid, "http://www.181.fm/stream/pls/181-power.pls");
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Estás escuchando 181.FM - Power 181. Usa /radiooff para dejar de escucharlo.");
				}
				case 1:
				{
				    PlayAudioStreamForPlayer(playerid, "http://tuner.defjay.com:80/listen.pls");
				    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Estás escuchando DEFJAY.COM - R&B. Usa /radiooff para dejar de escucharlo.");
				}
				case 2:
				{
				    PlayAudioStreamForPlayer(playerid, "http://www.181.fm/stream/pls/181-rock.pls");
				    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Estás escuchando Rock 181.FM. Usa /radiooff para dejar de escucharlo.");
				}
				case 3:
				{
				    PlayAudioStreamForPlayer(playerid, "http://www.181.fm/stream/pls/181-kickincountry.pls");
				    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Estás escuchando 181.FM - Kickin' Country. Usa /radiooff para dejar de escucharlo.");
				}
				case 4:
				{
				    PlayAudioStreamForPlayer(playerid, "http://www.181.fm/stream/pls/181-awesome80s.pls");
				    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Estás escuchando 181.FM - Awesome 80s. Usa /radiooff para dejar de escucharlo.");
				}
				case 5:
				{
                    PlayAudioStreamForPlayer(playerid, "http://www.hot108.com/hot108.pls");
				    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Estás escuchando Hot 108 Jamz. Usa /radiooff para dejar de escucharlo.");
				}
			}
		}
	}
	else if(dialogid == DIALOG_VIP)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                if(PlayerInfo[playerid][pColor] == 0)
	                {
						SetPlayerColor(playerid, 0xB8860BAA);
						SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Se ha puesto el color VIP con éxito.");
						PlayerInfo[playerid][pColor] = 1;
					}
					else if(PlayerInfo[playerid][pColor] == 1)
					{
					    switch(gTeam[playerid])
					    {
					        case TEAM_GROVE:
					        {
					            SetPlayerColor(playerid, 0x33AA33AA);
							}
							case TEAM_BALLAS:
							{
							    SetPlayerColor(playerid, 0xC2A2DAAA);
							}
							case TEAM_VAGOS:
							{
							    SetPlayerColor(playerid, 0xFFFF00AA);
							}
							case TEAM_AZTECAS:
							{
							    SetPlayerColor(playerid, 0x33CCFFAA);
							}
						}
						SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Se ha puesto el color normal con éxito.");
						PlayerInfo[playerid][pColor] = 0;
					}
				}
				case 1:
				{
				    if(PlayerInfo[playerid][pPM] == 1)
					{
						PlayerInfo[playerid][pPM] = 0;
						SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has activado mensajes privados (MPS).");
					}
					else
					{
					    PlayerInfo[playerid][pPM] = 1;
						SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Has desactivado tus mensajes privados (MPS).");
					}
				}
				case 2:
				{
				    PlayerInfo[playerid][pKills] = 0;
				    PlayerInfo[playerid][pDeaths] = 0;
				    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Se han reseteado tus stats con éxito.");
				}
			}
		}
	}
	else if(dialogid == DIALOG_CLAN)
	{
	    if(!response) return 1;
	    else if(response)
	    {
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_CLNAME, DIALOG_STYLE_INPUT, "Clan Name", "{FFFFFF}Por favor inserta el nombre del clan deseado.", "Enter", "Cancel");
				}
				case 1:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLMOTD, DIALOG_STYLE_INPUT, "Clan MOTD", "{FFFFFF}Por favor inserta el mensaje del clan que deseas.", "Enter", "Cancel");
				}
				case 2:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLRANK1, DIALOG_STYLE_INPUT, "Clan Rank 1", "{FFFFFF}Por favor inserta el nombre del rango 1 deseado.", "Enter", "Cancel");
				}
				case 3:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLRANK2, DIALOG_STYLE_INPUT, "Clan Rank 2", "{FFFFFF}Por favor inserta el nombre del rango 2 deseado.", "Enter", "Cancel");
				}
				case 4:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLRANK3, DIALOG_STYLE_INPUT, "Clan Rank 3", "{FFFFFF}Por favor inserta el nombre del rango 3 deseado.", "Enter", "Cancel");
				}
				case 5:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLRANK4, DIALOG_STYLE_INPUT, "Clan Rank 4", "{FFFFFF}Por favor inserta el nombre del rango 4 deseado.", "Enter", "Cancel");
				}
				case 6:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLRANK5, DIALOG_STYLE_INPUT, "Clan Rank 5", "{FFFFFF}Por favor inserta el nombre del rango 5 deseado.", "Enter", "Cancel");
				}
				case 7:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLRANK6, DIALOG_STYLE_INPUT, "Clan Rank 6", "{FFFFFF}Por favor inserta el nombre del rango 6 deseado.", "Enter", "Cancel");
				}
				case 8:
				{
				    ShowModelSelectionMenu(playerid, skinlist, "Clan Skin");
				}
				case 9:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLWEP1, DIALOG_STYLE_LIST, "Melee Weapon", "Brass Knuckles\nGolf Club\nNightstick\nKnife\nBaseball Bat\nShovel\nPool Cue\nKatana\nFlowers\nCane", "Select", "Cancel");
				}
				case 10:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLWEP2, DIALOG_STYLE_LIST, "Pistol", "Colt 45\nSilenced 9mm\nDesert Eagle", "Select", "Cancel");
				}
				case 11:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLWEP3, DIALOG_STYLE_LIST, "Weapon 3", "Shotgun\nSawnoff Shotgun\nCombat Shotgun\nUzi\nMP5\nTec-9", "Select", "Cancel");
				}
				case 12:
				{
				    ShowPlayerDialog(playerid, DIALOG_CLWEP4, DIALOG_STYLE_LIST, "Weapon 4", "AK-47\nM4\nCountry Rifle\nSniper Rifle", "Select", "Cancel");
				}
			}
		}
	}
	else if(dialogid == DIALOG_CLNAME)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Por favor inserta el nombre del clan deseado si quieres cambiarlo.");
				ShowPlayerDialog(playerid, DIALOG_CLNAME, DIALOG_STYLE_INPUT, "Clan Name", "{FFFFFF}Por favor inserta el nombre del clan deseado.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 2)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} El nombre de tu clan debe ser mínimo de dos caracteres.");
                ShowPlayerDialog(playerid, DIALOG_CLNAME, DIALOG_STYLE_INPUT, "Clan Name", "{FFFFFF}Por favor inserta el nombre del clan deseado.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cName], 129, "%s", inputtext);
				SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} Has cambiado el nombre de tu clan con éxito a %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
	else if(dialogid == DIALOG_CLMOTD)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Por favor inserta el mensaje del clan si quieres cambiarlo.");
				ShowPlayerDialog(playerid, DIALOG_CLMOTD, DIALOG_STYLE_INPUT, "Clan MOTD", "{FFFFFF}Por favor inserta el mensaje del clan que deseas.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 5)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} El mensaje del clan no puede ser menor a cinco caracteres.");
                ShowPlayerDialog(playerid, DIALOG_CLMOTD, DIALOG_STYLE_INPUT, "Clan MOTD", "{FFFFFF}Por favor inserta el mensaje del clan que deseas.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cMOTD], 128, "%s", inputtext);
                SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} Has cambiado con éxito el mensaje del clan a %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
    else if(dialogid == DIALOG_CLRANK1)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Please type in your desired Rank 1 name if you want to change it.");
				ShowPlayerDialog(playerid, DIALOG_CLRANK1, DIALOG_STYLE_INPUT, "Clan Rank 1", "{FFFFFF}Please insert your desired clan rank 1 name below.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Rank name can't be below 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_CLRANK1, DIALOG_STYLE_INPUT, "Clan Rank 1", "{FFFFFF}Please insert your desired clan rank 1 name below.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cRank1], 128, "%s", inputtext);
                SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} You have successfully changed your clan's rank 1 name to %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
	else if(dialogid == DIALOG_CLRANK2)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Please type in your desired Rank 2 name if you want to change it.");
				ShowPlayerDialog(playerid, DIALOG_CLRANK2, DIALOG_STYLE_INPUT, "Clan Rank 2", "{FFFFFF}Please insert your desired clan rank 2 name below.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Rank name can't be below 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_CLRANK2, DIALOG_STYLE_INPUT, "Clan Rank 2", "{FFFFFF}Please insert your desired clan rank 2 name below.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cRank2], 128, "%s", inputtext);
                SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} You have successfully changed your clan's rank 2 name to %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
	else if(dialogid == DIALOG_CLRANK3)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Please type in your desired Rank 3 name if you want to change it.");
				ShowPlayerDialog(playerid, DIALOG_CLRANK3, DIALOG_STYLE_INPUT, "Clan Rank 3", "{FFFFFF}Please insert your desired clan rank 3 name below.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Rank name can't be below 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_CLRANK3, DIALOG_STYLE_INPUT, "Clan Rank 3", "{FFFFFF}Please insert your desired clan rank 3 name below.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cRank3], 128, "%s", inputtext);
                SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} You have successfully changed your clan's rank 3 name to %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
	else if(dialogid == DIALOG_CLRANK4)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Please type in your desired Rank 4 name if you want to change it.");
				ShowPlayerDialog(playerid, DIALOG_CLRANK4, DIALOG_STYLE_INPUT, "Clan Rank 4", "{FFFFFF}Please insert your desired clan rank 4 name below.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Rank name can't be below 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_CLRANK4, DIALOG_STYLE_INPUT, "Clan Rank 4", "{FFFFFF}Please insert your desired clan rank 4 name below.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cRank4], 128, "%s", inputtext);
                SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} You have successfully changed your clan's rank 4 name to %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
	else if(dialogid == DIALOG_CLRANK5)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Please type in your desired Rank 5 name if you want to change it.");
				ShowPlayerDialog(playerid, DIALOG_CLRANK5, DIALOG_STYLE_INPUT, "Clan Rank 5", "{FFFFFF}Please insert your desired clan rank 5 name below.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Rank name can't be below 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_CLRANK5, DIALOG_STYLE_INPUT, "Clan Rank 5", "{FFFFFF}Please insert your desired clan rank 5 name below.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cRank5], 128, "%s", inputtext);
                SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} You have successfully changed your clan's rank 5 name to %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
	else if(dialogid == DIALOG_CLRANK6)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        if(!strlen(inputtext))
            {
				SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Please type in your desired Rank 6 name if you want to change it.");
				ShowPlayerDialog(playerid, DIALOG_CLRANK6, DIALOG_STYLE_INPUT, "Clan Rank 6", "{FFFFFF}Please insert your desired clan rank 6 name below.", "Enter", "Cancel");
			}
			else if(strlen(inputtext) < 3)
			{
                SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Rank name can't be below 3 characters.");
                ShowPlayerDialog(playerid, DIALOG_CLRANK6, DIALOG_STYLE_INPUT, "Clan Rank 6", "{FFFFFF}Please insert your desired clan rank 6 name below.", "Enter", "Cancel");
			}
			else
			{
			    format(ClanInfo[PlayerInfo[playerid][pClan]-1][cRank6], 128, "%s", inputtext);
                SaveClan(PlayerInfo[playerid][pClan]-1);
				format(string, sizeof(string), "INFO:{FFFFFF} You have successfully changed your clan's rank 6 name to %s.", inputtext);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
	}
	else if(dialogid == DIALOG_CLWEP1)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 1;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Brass Knuckles.");
				}
				case 1:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 2;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Golf Club.");
				}
				case 2:
				{
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 3;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Nightstick.");
				}
				case 3:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 4;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Knife.");
				}
				case 4:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 5;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Baseball Bat.");
				}
				case 5:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 6;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Shovel.");
				}
				case 6:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 7;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Pool Cue.");
				}
				case 7:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 8;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Katana.");
				}
				case 8:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 14;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Flowers.");
				}
				case 9:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep1] = 15;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's melee weapon to Cane.");
				}
			}
		}
	}
	else if(dialogid == DIALOG_CLWEP2)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep2] = 22;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's pistol weapon to Colt 45.");
				}
				case 1:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep2] = 23;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's pistol weapon to Silenced 9mm.");
				}
				case 2:
				{
				    ClanInfo[PlayerInfo[playerid][pClan]-1][cWep2] = 24;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's pistol weapon to Desert Eagle.");
				}
			}
		}
	}
	else if(dialogid == DIALOG_CLWEP3)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep3] = 25;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 3 to Shotgun.");
				}
				case 1:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep3] = 26;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 3 to Sawnoff Shotgun.");
				}
				case 2:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep3] = 27;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 3 to Combat Shotgun.");
				}
				case 3:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep3] = 28;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 3 to Uzi.");
				}
				case 4:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep3] = 29;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 3 to MP5.");
				}
				case 5:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep3] = 32;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 3 to Tec-9.");
				}
			}
		}
	}
	else if(dialogid == DIALOG_CLWEP4)
	{
	    if(!response) return 1;
	    else if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep4] = 30;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 4 to AK-47.");
				}
				case 1:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep4] = 31;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 4 to M4.");
				}
				case 2:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep4] = 33;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 4 to Country Rifle.");
				}
				case 3:
	            {
					ClanInfo[PlayerInfo[playerid][pClan]-1][cWep4] = 34;
					SaveClan(PlayerInfo[playerid][pClan]-1);
					SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully set your clan's weapon 4 to Sniper Rifle.");
				}
			}
		}
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if(listid == skinlist)
    {
        if(response)
        {
           	SetPlayerSkin(playerid, modelid);
			ClanInfo[PlayerInfo[playerid][pClan]-1][cSkin] = modelid;
			SaveClan(PlayerInfo[playerid][pClan]-1);
        }
        else SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Skin selection canceled.");
        return 1;
    }
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    ShowStatsForPlayer(clickedplayerid, playerid);
	return 1;
}

/* New Publics */

public LoadTextdraws()
{

    print("Loading Textdraws...");

	for(new i=0;i<MAX_PLAYERS;i++)
	{

		Login1[i] = TextDrawCreate(641.619079, 1.500000, "usebox");
		TextDrawLetterSize(Login1[i], 0.000000, 18.267036);
		TextDrawTextSize(Login1[i], -2.000000, 0.000000);
		TextDrawAlignment(Login1[i], 1);
		TextDrawColor(Login1[i], 155);
		TextDrawUseBox(Login1[i], true);
		TextDrawBoxColor(Login1[i], 120);
		TextDrawSetShadow(Login1[i], 0);
		TextDrawSetOutline(Login1[i], 0);
		TextDrawFont(Login1[i], 0);

		Login2[i] = TextDrawCreate(190.857238, 16.639999, "Zanate TDM");
		TextDrawLetterSize(Login2[i], 0.617238, 1.821866);
		TextDrawAlignment(Login2[i], 1);
		TextDrawColor(Login2[i], -16776961);
		TextDrawSetShadow(Login2[i], 0);
		TextDrawSetOutline(Login2[i], 1);
		TextDrawBackgroundColor(Login2[i], 51);
		TextDrawFont(Login2[i], 3);
		TextDrawSetProportional(Login2[i], 1);

		Login3[i] = TextDrawCreate(462.095275, 145.066665, "Zanate Gaming");
		TextDrawLetterSize(Login3[i], 0.581047, 1.770666);
		TextDrawAlignment(Login3[i], 1);
		TextDrawColor(Login3[i], -16776961);
		TextDrawSetShadow(Login3[i], 0);
		TextDrawSetOutline(Login3[i], 1);
		TextDrawBackgroundColor(Login3[i], 51);
		TextDrawFont(Login3[i], 3);
		TextDrawSetProportional(Login3[i], 1);

		Login4[i] = TextDrawCreate(641.619079, 301.873352, "usebox");
		TextDrawLetterSize(Login4[i], 0.000000, 16.038887);
		TextDrawTextSize(Login4[i], -2.000000, 0.000000);
		TextDrawAlignment(Login4[i], 1);
		TextDrawColor(Login4[i], 0);
		TextDrawUseBox(Login4[i], true);
		TextDrawBoxColor(Login4[i], 102);
		TextDrawSetShadow(Login4[i], 0);
		TextDrawSetOutline(Login4[i], 0);
		TextDrawFont(Login4[i], 0);

		Login5[i] = TextDrawCreate(254.857131, 336.213256, "-");
		TextDrawLetterSize(Login5[i], 12.134951, 1.868802);
		TextDrawAlignment(Login5[i], 1);
		TextDrawColor(Login5[i], -1);
		TextDrawSetShadow(Login5[i], 0);
		TextDrawSetOutline(Login5[i], 1);
		TextDrawBackgroundColor(Login5[i], 51);
		TextDrawFont(Login5[i], 0);
		TextDrawSetProportional(Login5[i], 1);

		Login6[i] = TextDrawCreate(235.428680, 352.853271, "zanate.net");
		TextDrawLetterSize(Login6[i], 0.370380, 1.689600);
		TextDrawAlignment(Login6[i], 1);
		TextDrawColor(Login6[i], -1);
		TextDrawSetShadow(Login6[i], 0);
		TextDrawSetOutline(Login6[i], 1);
		TextDrawBackgroundColor(Login6[i], 51);
		TextDrawFont(Login6[i], 2);
		TextDrawSetProportional(Login6[i], 1);

		Login7[i] = TextDrawCreate(255.999954, 373.760009, "-");
		TextDrawLetterSize(Login7[i], 12.134950, 1.868801);
		TextDrawAlignment(Login7[i], 1);
		TextDrawColor(Login7[i], -1);
		TextDrawSetShadow(Login7[i], 0);
		TextDrawSetOutline(Login7[i], 1);
		TextDrawBackgroundColor(Login7[i], 51);
		TextDrawFont(Login7[i], 0);
		TextDrawSetProportional(Login7[i], 1);
		
		Rank[i] = TextDrawCreate(1.523578, 260.266448, "Rank:~w~ Outsider");
		TextDrawLetterSize(Rank[i], 0.449999, 1.600000);
		TextDrawAlignment(Rank[i], 1);
		TextDrawColor(Rank[i], -5963521);
		TextDrawSetShadow(Rank[i], 0);
		TextDrawSetOutline(Rank[i], 1);
		TextDrawBackgroundColor(Rank[i], 51);
		TextDrawFont(Rank[i], 2);
		TextDrawSetProportional(Rank[i], 1);

		Kills[i] = TextDrawCreate(2.666610, 289.706634, "Kills:~w~ 1");
		TextDrawLetterSize(Kills[i], 0.449999, 1.600000);
		TextDrawAlignment(Kills[i], 1);
		TextDrawColor(Kills[i], -5963521);
		TextDrawSetShadow(Kills[i], 0);
		TextDrawSetOutline(Kills[i], 1);
		TextDrawBackgroundColor(Kills[i], 51);
		TextDrawFont(Kills[i], 2);
		TextDrawSetProportional(Kills[i], 1);

		Deaths[i] = TextDrawCreate(2.666661, 303.359985, "Deaths:~w~ 1");
		TextDrawLetterSize(Deaths[i], 0.449999, 1.600000);
		TextDrawAlignment(Deaths[i], 1);
		TextDrawColor(Deaths[i], -5963521);
		TextDrawSetShadow(Deaths[i], 0);
		TextDrawSetOutline(Deaths[i], 1);
		TextDrawBackgroundColor(Deaths[i], 51);
		TextDrawFont(Deaths[i], 2);
		TextDrawSetProportional(Deaths[i], 1);

		EXP[i] = TextDrawCreate(2.285721, 274.773315, "EXP:~w~ 1");
		TextDrawLetterSize(EXP[i], 0.449999, 1.600000);
		TextDrawAlignment(EXP[i], 1);
		TextDrawColor(EXP[i], -5963521);
		TextDrawSetShadow(EXP[i], 0);
		TextDrawSetOutline(EXP[i], 1);
		TextDrawBackgroundColor(EXP[i], 51);
		TextDrawFont(EXP[i], 2);
		TextDrawSetProportional(EXP[i], 1);
		
		DMGP[i] = TextDrawCreate(389.333343, 165.546676, "+25");
		TextDrawLetterSize(DMGP[i], 0.406571, 1.429332);
		TextDrawAlignment(DMGP[i], 1);
		TextDrawColor(DMGP[i], 16711935);
		TextDrawSetShadow(DMGP[i], 0);
		TextDrawSetOutline(DMGP[i], 1);
		TextDrawBackgroundColor(DMGP[i], 51);
		TextDrawFont(DMGP[i], 2);
		TextDrawSetProportional(DMGP[i], 1);

		DMGM[i] = TextDrawCreate(144.000076, 162.560012, "-25");
		TextDrawLetterSize(DMGM[i], 0.505238, 1.331198);
		TextDrawAlignment(DMGM[i], 1);
		TextDrawColor(DMGM[i], -16776961);
		TextDrawSetShadow(DMGM[i], 0);
		TextDrawSetOutline(DMGM[i], 1);
		TextDrawBackgroundColor(DMGM[i], 51);
		TextDrawFont(DMGM[i], 2);
		TextDrawSetProportional(DMGM[i], 1);
		
		CSWTD[i] = TextDrawCreate(460.571319, 398.079956, "Zanate TDM");
		TextDrawLetterSize(CSWTD[i], 0.354761, 1.621333);
		TextDrawAlignment(CSWTD[i], 1);
		TextDrawColor(CSWTD[i], -16776961);
		TextDrawSetShadow(CSWTD[i], 0);
		TextDrawSetOutline(CSWTD[i], 1);
		TextDrawBackgroundColor(CSWTD[i], 51);
		TextDrawFont(CSWTD[i], 3);
		TextDrawSetProportional(CSWTD[i], 1);

		CSWV[i] = TextDrawCreate(579.809020, 411.733245, "v0.1 Beta");
		TextDrawLetterSize(CSWV[i], 0.269809, 1.049600);
		TextDrawAlignment(CSWV[i], 1);
		TextDrawColor(CSWV[i], -16776961);
		TextDrawSetShadow(CSWV[i], 0);
		TextDrawSetOutline(CSWV[i], 1);
		TextDrawBackgroundColor(CSWV[i], 51);
		TextDrawFont(CSWV[i], 3);
		TextDrawSetProportional(CSWV[i], 1);
		
		Zones[i] = TextDrawCreate(497.904846, 97.280029, "Zones:~w~ 0/11");
		TextDrawLetterSize(Zones[i], 0.449999, 1.600000);
		TextDrawAlignment(Zones[i], 1);
		TextDrawColor(Zones[i], -5963521);
		TextDrawSetShadow(Zones[i], 0);
		TextDrawSetOutline(Zones[i], 1);
		TextDrawBackgroundColor(Zones[i], 51);
		TextDrawFont(Zones[i], 2);
		TextDrawSetProportional(Zones[i], 1);

	}
	return 1;
}

public LoadVehicles()
{
    print("Loading Vehicles...");

	//Grove St Vehicles
	AddStaticVehicleEx(492, 2509.4221, -1672.2858, 13.0799, -12.0000, 86, 1, 300);
	AddStaticVehicleEx(412, 2482.7417, -1653.8513, 13.1160, 90.0000, 86, 86, 300);
	AddStaticVehicleEx(560, 2485.1008, -1684.2717, 13.0604, 270.0000, 86, 86, 300);
	AddStaticVehicleEx(567, 2473.5413, -1693.8671, 13.2878, 0.0000, 86, 86, 300);
	AddStaticVehicleEx(536, 2509.8167, -1687.2152, 13.1495, 45.0000, 86, 86, 300);
	AddStaticVehicleEx(475, 2492.1523, -1684.2494, 13.3346, 270.0000, 86, 86, 300);
	AddStaticVehicleEx(412, 2470.2920, -1653.5994, 13.1160, 90.0000, 86, 86, 300);
	AddStaticVehicleEx(554, 2468.6145, -1671.7438, 13.5158, 190.0000, 0, 86, 300);
	AddStaticVehicleEx(405, 2436.9148, -1677.9384, 13.4892, 0.0000, 86, 86, 300);
	AddStaticVehicleEx(405, 2433.3926, -1677.7705, 13.4892, 0.0000, 86, 86, 300);
	AddStaticVehicleEx(405, 2429.9343, -1677.6456, 13.4892, 0.0000, 86, 86, 300);

	//Ballas Vehicles
	AddStaticVehicleEx(560, 2228.4514, -1177.2949, 25.4534, 90.0000, 85, 85, 300);
	AddStaticVehicleEx(566, 2217.2019, -1157.2843, 25.4759, 270.0000, 85, 85, 300);
	AddStaticVehicleEx(517, 2205.7957, -1176.8954, 25.4607, 270.0000, 85, 85, 300);
	AddStaticVehicleEx(412, 2217.3708, -1170.4976, 25.4457, 270.0000, 85, 85, 300);
	AddStaticVehicleEx(475, 2205.7129, -1152.8622, 25.2389, 270.0000, 85, 85, 300);
	AddStaticVehicleEx(561, 2228.5391, -1166.2864, 25.5057, 90.0000, 85, 85, 300);
	AddStaticVehicleEx(567, 2205.8835, -1164.8662, 25.4684, 270.0000, 85, 85, 300);
	AddStaticVehicleEx(560, 2228.3826, -1173.3043, 25.4404, 90.0000, 85, 85, 300);
	
	//Vagos Vehicles
	AddStaticVehicleEx(560, 2827.4153, -1164.7153, 24.9158, 270.0000, 6, 6, 300);
	AddStaticVehicleEx(579, 2827.7502, -1170.1062, 25.0003, 270.0000, 6, 6, 300);
	AddStaticVehicleEx(576, 2815.4268, -1188.0431, 24.7805, 270.0000, 6, 6, 300);
	AddStaticVehicleEx(467, 2822.0571, -1188.1871, 24.8357, 270.0000, 6, 1, 300);
	AddStaticVehicleEx(474, 2815.1917, -1178.4578, 24.8796, 270.0000, 6, 6, 300);
	AddStaticVehicleEx(475, 2822.2029, -1178.3521, 24.8636, 270.0000, 6, 6, 300);
	AddStaticVehicleEx(518, 2830.3357, -1196.9120, 24.4784, 7.0000, 6, 6, 300);
	AddStaticVehicleEx(535, 2846.4688, -1175.2900, 24.5173, 6.0000, 6, 6, 300);
	AddStaticVehicleEx(560, 2845.8711, -1169.2817, 24.3994, 3.0000, 6, 6, 300);
	AddStaticVehicleEx(560, 2847.0620, -1181.6932, 24.3994, 6.0000, 6, 6, 300);
	
	//Aztecas Vehicles
	AddStaticVehicleEx(560, 1886.7222, -2020.9185, 13.1513, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(475, 1879.1893, -2020.9340, 13.2592, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(439, 1879.2144, -2027.8776, 13.2385, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(518, 1886.7434, -2028.0323, 13.1850, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(535, 1879.4028, -2034.8940, 13.1168, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(536, 1886.7533, -2035.4691, 13.1012, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(567, 1886.6975, -2042.0859, 13.0989, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(579, 1879.3475, -2042.4271, 13.1464, 180.0000, 135, 135, 300);
    AddStaticVehicleEx(560, 1826.7452, -2020.8734, 12.8636, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(535, 1819.2488, -2020.8918, 13.1742, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(536, 1819.2283, -2028.4006, 13.2005, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(405, 1826.6984, -2028.3925, 13.3103, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(567, 1819.3280, -2035.2816, 13.1642, 180.0000, 135, 135, 300);
	AddStaticVehicleEx(475, 1826.6057, -2035.3422, 13.0702, 180.0000, 135, 135, 300);
	
	//Police Vehicles
	AddStaticVehicleEx(596, 1535.9032, -1677.9037, 13.0457, 0.0000, 0, 1, 300);
	AddStaticVehicleEx(596, 1535.7362, -1667.8004, 13.0457, 180.0000, 0, 1, 300);
	AddStaticVehicleEx(596, 1602.1595, -1684.1194, 5.6002, 90.0000, 0, 1, 300);
	AddStaticVehicleEx(596, 1602.1095, -1688.0098, 5.6002, 90.0000, 0, 1, 300);
	AddStaticVehicleEx(596, 1602.0750, -1692.0289, 5.6002, 90.0000, 0, 1, 300);
	AddStaticVehicleEx(596, 1602.0396, -1696.1392, 5.6002, 90.0000, 0, 1, 300);
	AddStaticVehicleEx(596, 1602.0562, -1700.2911, 5.6002, 90.0000, 0, 1, 300);
	AddStaticVehicleEx(596, 1602.0416, -1704.0338, 5.6002, 90.0000, 0, 1, 300);
	AddStaticVehicleEx(599, 1585.6140, -1667.5994, 5.9509, 270.0000, 0, 1, 300);
	AddStaticVehicleEx(599, 1585.4155, -1671.3943, 5.9151, 270.0000, 0, 1, 300);

	//Seville Turf Vehicles
	AddStaticVehicleEx(492, 2749.6699, -1946.5166, 13.1421, 270.0000, 32, 58, 300);
	AddStaticVehicleEx(405, 2775.2095, -1964.9454, 13.1784, 0.0000, 72, 72, 300);

	//East Beach Warehouse Turft Vehicles
	AddStaticVehicleEx(456, 2770.5515, -1622.5754, 10.9444, 0.0000, 1, 1, 300);
	AddStaticVehicleEx(482, 2768.6382, -1605.9595, 10.8987, 270.0000, 76, 76, 300);
	AddStaticVehicleEx(600, 2796.1658, -1576.1968, 10.6940, 270.0000, 13, 13, 300);
	AddStaticVehicleEx(562, 2796.0881, -1554.2195, 10.5037, 90.0000, 0, 0, 300);

	//Glen Park Turft Vehicles
	AddStaticVehicleEx(603, 2003.3016, -1120.3925, 26.6097, 180.0000, 134, 1, 300);
	AddStaticVehicleEx(551, 1887.9407, -1266.3328, 13.2213, 270.0000, 1, 1, 300);
	AddStaticVehicleEx(551, 1879.7382, -1266.4642, 13.2213, 270.0000, 1, 1, 300);

	//Skate Park Turft Vehicles
	AddStaticVehicleEx(481, 1925.5376, -1436.6449, 13.0987, 180.0000, 1, 1, 300);
	AddStaticVehicleEx(481, 1924.3469, -1436.6959, 13.0987, 180.0000, 0, 0, 300);
	AddStaticVehicleEx(481, 1923.1259, -1436.6846, 13.0987, 180.0000, 2, 2, 300);
	AddStaticVehicleEx(481, 1922.0236, -1436.7571, 13.0987, 180.0000, 3, 3, 300);
	AddStaticVehicleEx(481, 1920.9746, -1436.7878, 13.0987, 180.0000, 4, 4, 300);
	AddStaticVehicleEx(481, 1919.8739, -1436.8026, 13.0987, 180.0000, 5, 5, 300);
	AddStaticVehicleEx(481, 1910.2402, -1437.0168, 13.0987, 180.0000, 6, 6, 300);
	AddStaticVehicleEx(481, 1909.2800, -1437.0394, 13.0987, 180.0000, 7, 7, 300);
	AddStaticVehicleEx(481, 1908.2192, -1437.0464, 13.0987, 180.0000, 8, 8, 300);
	AddStaticVehicleEx(481, 1907.2411, -1437.1100, 13.0987, 180.0000, 9, 9, 300);
	AddStaticVehicleEx(481, 1906.2013, -1437.1364, 13.0987, 180.0000, 10, 10, 300);
	AddStaticVehicleEx(481, 1905.2023, -1437.1810, 13.0987, 180.0000, 11, 11, 300);

	//Idlewood Turf Vehicles
	AddStaticVehicleEx(461, 2046.0100, -1692.9496, 13.0541, 0.0000, 89, 89, 300);
	AddStaticVehicleEx(496, 2059.7996, -1694.5750, 13.1553, 270.0000, 111, 111, 300);
	AddStaticVehicleEx(445, 2105.3613, -1782.7384, 13.1159, 0.0000, 19, 19, 300);
	AddStaticVehicleEx(426, 2117.0759, -1782.8230, 13.1011, 180.0000, 3, 3, 300);

	//South Jefferson Turf Vehicles
	AddStaticVehicleEx(402, 2096.0483, -1365.0935, 23.6162, 0.0000, 86, 86, 300);
	AddStaticVehicleEx(466, 2105.5332, -1365.1498, 23.5777, 180.0000, 111, 111, 300);

	//Market Station Vehicles
	AddStaticVehicleEx(426, 803.0594, -1350.8600, 13.0556, 0.0000, 0, 0, 300);
	AddStaticVehicleEx(420, 810.1729, -1333.0427, 12.9679, 270.0000, 6, 6, 300);
	AddStaticVehicleEx(420, 817.4739, -1333.0706, 13.0019, 270.0000, 6, 6, 300);


	//Random Vehicles
	AddStaticVehicleEx(542, 1429.6495, -1324.4091, 13.4369, 270.0000, 32, 32, 300);
	AddStaticVehicleEx(550, 1363.0088, -1300.9281, 13.1546, 0.0000, 143, 143, 300);
	AddStaticVehicleEx(560, 1361.6523, -1659.0081, 12.8973, 270.0000, 0, 0, 300);
	AddStaticVehicleEx(560, 1361.8623, -1651.0046, 12.8973, 270.0000, 0, 0, 300);
	AddStaticVehicleEx(560, 1361.6741, -1643.0867, 12.8973, 270.0000, 0, 0, 300);
	AddStaticVehicleEx(560, 1361.4725, -1635.3655, 12.8973, 270.0000, 0, 0, 300);
	AddStaticVehicleEx(505, 1358.1322, -1748.9312, 13.4685, 90.0000, 13, 13, 300);
    AddStaticVehicleEx(411, 1254.8656, -804.3207, 83.8930, 180.0000, 1, 1, 300);
	AddStaticVehicleEx(499, 2392.4565, -1487.1726, 24.3252, 270.0000, 72, 72, 300);
	AddStaticVehicleEx(400, 2391.0452, -1503.7389, 23.8245, 90.0000, 88, 88, 300);
	AddStaticVehicleEx(552, 2398.0862, -1545.5610, 23.5176, 90.0000, 121, 121, 300);
	AddStaticVehicleEx(462, 2406.3455, -1392.4435, 23.8035, 0.0000, 53, 53, 300);
	AddStaticVehicleEx(462, 2407.7695, -1392.5504, 23.8035, 0.0000, 33, 33, 300);
	AddStaticVehicleEx(462, 2409.1863, -1392.6205, 23.8035, 0.0000, 23, 23, 300);
	AddStaticVehicleEx(500, 2433.1257, -1243.1063, 24.2418, 180.0000, 71, 71, 300);
	AddStaticVehicleEx(507, 2425.2048, -1242.6047, 23.8631, 0.0000, 118, 118, 300);
	AddStaticVehicleEx(545, 2380.1858, -1928.2369, 13.0885, 0.0000, 132, 132, 300);
	AddStaticVehicleEx(566, 2396.4465, -1927.4788, 12.9299, 0.0000, 0, 0, 300);
    AddStaticVehicleEx(405, 2337.1921, -1518.9199, 23.7586, 180.0000, 62, 62, 300);
	AddStaticVehicleEx(410, 2336.8579, -1527.2715, 23.3259, 0.0000, 15, 15, 300);
	AddStaticVehicleEx(468, 2147.5273, -1132.3185, 25.1432, 90.0000, 95, 95, 300);
	AddStaticVehicleEx(479, 2148.2546, -1157.0255, 23.4891, 90.0000, 127, 127, 300);
	AddStaticVehicleEx(483, 2161.9001, -1168.3862, 23.6966, 270.0000, 3, 3, 300);
	AddStaticVehicleEx(540, 2147.8452, -1189.4277, 23.5859, 90.0000, 5, 5, 300);
    AddStaticVehicleEx(458, 1928.7239, -1795.7761, 13.1874, 90.0000, 73, 73, 300);
	AddStaticVehicleEx(420, 1778.0695, -1904.0873, 13.0477, 270.0000, 6, 6, 300);
	AddStaticVehicleEx(420, 1777.7614, -1890.4365, 13.0477, 270.0000, 6, 6, 300);


}
public LoadObjects()
{
    print("Loading Objects...");

	//Idlewood Turf Mapping
	CreateDynamicObject(970, 2038.88, -1662.27, 13.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 2044.35, -1662.27, 13.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 2038.89, -1622.72, 13.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(970, 2044.33, -1622.72, 13.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(853, 2045.18, -1657.79, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1349, 2043.34, -1652.23, 12.89,   90.00, 0.00, 180.00);
	CreateDynamicObject(3594, 2041.31, -1627.91, 13.02,   0.00, 0.00, 45.00);
	CreateDynamicObject(851, 2043.73, -1628.60, 12.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(854, 2039.00, -1627.57, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1344, 2037.31, -1638.27, 13.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(1344, 2037.31, -1640.24, 13.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(1264, 2037.17, -1641.67, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1264, 2037.08, -1642.57, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1264, 2037.67, -1642.06, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1264, 2037.24, -1636.80, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1264, 2037.22, -1635.97, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1264, 2037.89, -1636.44, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1264, 2038.14, -1637.20, 12.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(852, 2037.47, -1656.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(2673, 2037.68, -1639.75, 12.63,   0.00, 0.00, 0.00);
	
	//Seville Turf
	CreateDynamicObject(852, 2787.59, -1947.60, 12.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(853, 2798.06, -1942.00, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(1344, 2795.85, -1947.63, 13.30,   0.00, 0.00, 180.00);
	CreateDynamicObject(1344, 2793.86, -1947.63, 13.30,   0.00, 0.00, 180.00);
	CreateDynamicObject(1265, 2792.37, -1947.70, 12.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1265, 2791.61, -1947.64, 12.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1265, 2792.01, -1946.99, 12.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1265, 2797.23, -1947.81, 12.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1265, 2798.00, -1947.77, 12.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1265, 2797.82, -1947.06, 12.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(1265, 2797.10, -1947.07, 12.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(854, 2790.62, -1941.70, 12.74,   0.00, 0.00, 180.00);
	
	//Owl Street Turf
	CreateDynamicObject(1710, 2653.85, -2030.17, 12.55,   0.00, 0.00, 0.00);
	CreateDynamicObject(2672, 2654.30, -2030.76, 12.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(2672, 2656.70, -2030.10, 12.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(854, 2652.41, -2029.88, 12.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(1372, 2649.43, -2039.99, 12.66,   0.00, 0.00, 90.00);
	CreateDynamicObject(1265, 2649.33, -2041.23, 12.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(849, 2652.67, -2046.07, 12.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(3594, 2657.64, -2048.50, 13.13,   0.00, 0.00, 230.00);

	//Pizza Hut Turf
	CreateDynamicObject(854, 2129.71, -1787.95, 12.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(1328, 2128.58, -1787.59, 12.54,   0.00, 60.00, 0.00);
	CreateDynamicObject(1464, 2134.50, -1798.11, 13.46,   0.00, 0.00, 270.00);
	CreateDynamicObject(1465, 2134.52, -1801.18, 13.75,   0.00, 0.00, 270.00);
	CreateDynamicObject(1467, 2132.08, -1797.09, 14.40,   0.00, 40.00, 0.00);
	CreateDynamicObject(926, 2124.15, -1798.49, 12.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(2968, 2124.33, -1799.33, 12.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(2971, 2132.10, -1809.33, 12.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(2890, 2126.01, -1820.26, 12.55,   0.00, 0.00, 0.00);
	CreateDynamicObject(2905, 2124.92, -1818.11, 13.81,   0.00, 0.00, 347.85);
	CreateDynamicObject(2672, 2125.76, -1791.14, 12.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(2677, 2128.65, -1797.11, 12.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(2675, 2124.81, -1799.19, 12.65,   0.00, 0.00, 359.80);
	CreateDynamicObject(1264, 2133.41, -1796.98, 15.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1264, 2134.73, -1801.87, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1335, 2134.63, -1828.34, 13.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(1334, 2134.69, -1826.15, 13.46,   0.00, 0.00, 90.00);
	CreateDynamicObject(1349, 2131.24, -1819.24, 12.95,   90.00, 0.00, 45.00);
	CreateDynamicObject(1349, 2131.32, -1818.27, 12.95,   45.00, 0.00, 0.00);
	CreateDynamicObject(910, 2125.52, -1808.56, 13.58,   0.00, 0.00, 40.00);
	CreateDynamicObject(2770, 2125.30, -1808.78, 13.75,   0.00, 20.00, 20.00);
	CreateDynamicObject(3594, 2132.28, -1806.26, 13.66,   -20.00, 0.00, 0.00);
	
	//Idlewood Gas
	CreateDynamicObject(3594, 1943.15, -1775.88, 13.29,   0.00, 45.00, 2.00);
	CreateDynamicObject(3594, 1946.27, -1781.20, 12.89,   0.00, 0.00, 230.00);
	CreateDynamicObject(854, 1945.37, -1778.85, 12.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1240, 1929.16, -1772.46, 14.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(970, 1951.84, -1775.29, 12.96,   25.00, 0.00, 90.00);
	CreateDynamicObject(970, 1951.17, -1769.78, 12.59,   270.00, 0.00, 90.00);
	CreateDynamicObject(970, 1951.64, -1764.44, 13.06,   0.00, 0.00, 90.00);
	
	//East Beach Turf
	CreateDynamicObject(3594, 2740.38, -2104.69, 11.55,   0.00, 0.00, 0.00);
	CreateDynamicObject(3594, 2754.22, -2097.19, 11.55,   0.00, 0.00, 60.00);
	CreateDynamicObject(3594, 2753.94, -2112.99, 11.55,   0.00, 0.00, 1205.00);
	CreateDynamicObject(854, 2755.38, -2111.15, 11.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(851, 2741.12, -2106.60, 11.21,   0.00, 0.00, 0.00);
	CreateDynamicObject(854, 2741.42, -2102.92, 11.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(854, 2752.02, -2096.99, 11.29,   0.00, 0.00, 0.00);
	
	//Market Station
	CreateDynamicObject(19377, 831.70, -1337.46, 11.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(19377, 822.09, -1337.45, 11.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(19377, 807.77, -1345.40, 11.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(19391, 807.77, -1338.99, 14.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(3858, 829.54, -1337.38, 16.75,   0.00, 0.00, 45.00);
	CreateDynamicObject(3858, 814.98, -1337.38, 16.75,   0.00, 0.00, 45.00);
	CreateDynamicObject(19377, 812.49, -1337.45, 11.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(3858, 807.68, -1344.67, 18.72,   0.00, 0.00, -45.00);
	CreateDynamicObject(19435, 807.77, -1339.11, 16.03,   90.00, 0.00, 0.00);
	CreateDynamicObject(19377, 807.77, -1354.98, 11.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3858, 807.68, -1359.25, 18.72,   0.00, 0.00, -45.00);
	CreateDynamicObject(16151, 818.99, -1355.82, 12.85,   0.00, 0.00, 270.00);
	CreateDynamicObject(1825, 811.65, -1354.25, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1825, 813.51, -1350.81, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1825, 817.25, -1349.78, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1825, 821.47, -1349.51, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1825, 810.31, -1348.11, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1825, 814.23, -1347.42, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 825.84, -1344.55, 13.00,   0.00, 0.00, 90.00);
	CreateDynamicObject(3850, 822.42, -1344.55, 13.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(3850, 820.70, -1344.55, 13.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(3850, 815.49, -1344.55, 13.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(3850, 812.07, -1344.55, 13.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(3850, 809.56, -1344.55, 13.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(1825, 824.76, -1347.51, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1825, 825.39, -1351.29, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(1825, 809.79, -1351.41, 12.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(638, 809.24, -1345.05, 13.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 815.85, -1345.05, 13.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 820.34, -1345.05, 13.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 826.18, -1345.05, 13.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, 807.77, -1339.74, 12.40,   0.00, 0.00, 90.00);


}


forward BanResults(playerid, account);
public BanResults(playerid, account)
{
    new rows, fields;
	new query[128], string[128], usName[24], strName[24];
    cache_get_data(rows, fields, mysql);
	if(cache_num_rows(mysql) == 1)
    {

        cache_get_field_content(0, "Username", usName);
		format(strName, 24, "%s", usName);
		mysql_format(mysql, query, sizeof(query), "UPDATE `users` SET `Banned`= 0 WHERE `Username` = '%e' LIMIT 1", strName);
        mysql_tquery(mysql, query, "", "");
        format(string, sizeof(string), "UNBAN:{FFFFFF} Has desbaneado con éxito a %s.", strName);
        SendClientMessage(playerid, COLOR_RED, string);
    }
    else 
    {
        SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} No se ha podido encontrar el jugador en la base de datos.");
    }
    return 1;
}

forward LoggingTimer(playerid);
public LoggingTimer(playerid)
{
    new query[512];
    GetPlayerIp(playerid, IP[playerid], 16);
	GetPlayerName(playerid, Name[playerid], 24);
	mysql_format(mysql, query, sizeof(query),"SELECT `Password`, `ID` FROM `users` WHERE `Username` = '%e' LIMIT 1", Name[playerid]);
    mysql_tquery(mysql, query, "OnAccountCheck", "i", playerid);
	TextDrawShowForPlayer(playerid,Login1[playerid]);
    TextDrawShowForPlayer(playerid,Login2[playerid]);
    TextDrawShowForPlayer(playerid,Login3[playerid]);
    TextDrawShowForPlayer(playerid,Login4[playerid]);
    TextDrawShowForPlayer(playerid,Login5[playerid]);
    TextDrawShowForPlayer(playerid,Login6[playerid]);
    TextDrawShowForPlayer(playerid,Login7[playerid]);
    InterpolateCameraPos(playerid, -1781.663330, 428.006164, 77.410369, -1162.017089, 1080.103393, 77.418640, 40000);
	InterpolateCameraLookAt(playerid, -1778.375610, 431.433624, 75.847175, -1158.807495, 1083.449462, 75.547363, 40000);
	SendClientMessage(playerid, yellow, "SERVER:{FFFFFF} Zanate.");
	SendClientMessage(playerid, yellow, "VERSION:{FFFFFF} 0.1 Beta");
	SendClientMessage(playerid, yellow, "COMMUNITY:{FFFFFF} Zanate Gaming");
	SendClientMessage(playerid, yellow, "WEBSITE:{FFFFFF} zanate.net/foro");
    return 1;
}


forward LoadClans();
public LoadClans()
{
	new query[128];
	format(query, sizeof(query), "SELECT * FROM `clans` ORDER BY `cID` ASC LIMIT 6");
	mysql_tquery(mysql, query, "OnClanLoad", "");
	return 1;
}

forward LoadZones();
public LoadZones()
{
	new query[128];
	format(query, sizeof(query), "SELECT * FROM `zones` ORDER BY `zID` ASC LIMIT 14");
	mysql_tquery(mysql, query, "OnZoneLoad", "");
	return 1;
}

stock CreateClan(clanid)
{
	new query[1024];
	mysql_format(mysql, query, sizeof(query), "INSERT INTO `clans` (`Name`, `Leader`, `Members`, `Skin`, `MOTD`, `Rank1`, `Rank2` ,`Rank3`, `Rank4`, `Rank5`, `Rank6`, `x`, `y`, `z`  ) VALUES ('None', 'Nobody', '0', 1, 'Changeme', 'None', 'None', 'None', 'None', 'None', 'None', 0.0, 0.0, 0.0)");
	mysql_tquery(mysql, query, "OnClanCreate", "i", clanid);
	return 1;
}

forward OnClanCreate(clanid);
public OnClanCreate(clanid)
{
    ClanInfo[clanid][cID] = cache_insert_id();
    printf("Clan Created. ID: %d", ClanInfo[clanid][cID]);
    return 1;
}

forward OnClanLoad();
public OnClanLoad()
{
	new rows, fields;
	new clName[128], Leader[24], clMOTD[128], Ranks[6][64];
	cache_get_data(rows, fields, mysql);
	if(rows)
	{
		for(new i = 0; i < rows; i++)
    	{
			ClanInfo[i][cID] = cache_get_field_content_int(i, "cID");
            cache_get_field_content(i, "Name", clName);
			format(ClanInfo[i][cName], 128, "%s", clName);
   			cache_get_field_content(i, "Leader", Leader);
			format(ClanInfo[i][cLeader], 24, "%s", Leader);
			ClanInfo[i][cMembers] = cache_get_field_content_int(i, "Members");
			ClanInfo[i][cSkin] = cache_get_field_content_int(i, "Skin");
            cache_get_field_content(i, "MOTD", clMOTD);
			format(ClanInfo[i][cMOTD], 128, "%s", clMOTD);
            cache_get_field_content(i, "Rank1", Ranks[0]);
			format(ClanInfo[i][cRank1], 64, "%s", Ranks[0]);
            cache_get_field_content(i, "Rank2", Ranks[1]);
			format(ClanInfo[i][cRank2], 64, "%s", Ranks[1]);
            cache_get_field_content(i, "Rank3", Ranks[2]);
			format(ClanInfo[i][cRank3], 64, "%s", Ranks[2]);
            cache_get_field_content(i, "Rank4", Ranks[3]);
			format(ClanInfo[i][cRank4], 64, "%s", Ranks[3]);
            cache_get_field_content(i, "Rank5", Ranks[4]);
			format(ClanInfo[i][cRank5], 64, "%s", Ranks[4]);
            cache_get_field_content(i, "Rank6", Ranks[5]);
			format(ClanInfo[i][cRank6], 64, "%s", Ranks[5]);
		    ClanInfo[i][cx] = cache_get_field_content_float(i, "x");
		    ClanInfo[i][cy] = cache_get_field_content_float(i, "y");
		    ClanInfo[i][cz] = cache_get_field_content_float(i, "z");
		    ClanInfo[i][cWep1] = cache_get_field_content_int(i, "cWep1");
		    ClanInfo[i][cWep2] = cache_get_field_content_int(i, "cWep2");
		    ClanInfo[i][cWep3] = cache_get_field_content_int(i, "cWep3");
		    ClanInfo[i][cWep4] = cache_get_field_content_int(i, "cWep4");
		    printf("Clan Loaded. ID: %d", ClanInfo[i][cID]);
		}
	}
	return 1;
}

forward OnZoneLoad();
public OnZoneLoad()
{
    new rows, fields;
	new znName[128];
	cache_get_data(rows, fields, mysql);
	if(rows)
	{
		for(new i = 0; i < rows; i++)
    	{
            ZoneInfo[i][zID] = cache_get_field_content_int(i, "zID");
           	cache_get_field_content(i, "zName", znName);
			format(ZoneInfo[i][zName], 128, "%s", znName);
			ZoneInfo[i][zMinX] = cache_get_field_content_float(i, "zMinX");
			ZoneInfo[i][zMinY] = cache_get_field_content_float(i, "zMinY");
			ZoneInfo[i][zMaxX] = cache_get_field_content_float(i, "zMaxX");
			ZoneInfo[i][zMaxY] = cache_get_field_content_float(i, "zMaxY");
			ZoneInfo[i][zCPX] = cache_get_field_content_float(i, "zCPX");
			ZoneInfo[i][zCPY] = cache_get_field_content_float(i, "zCPY");
			ZoneInfo[i][zCPZ] = cache_get_field_content_float(i, "zCPZ");
			ZoneInfo[i][zTeam] = cache_get_field_content_int(i, "zTeam");
			ZoneInfo[i][zMoney] = cache_get_field_content_int(i, "zMoney");
			ZoneInfo[i][zEXP] = cache_get_field_content_int(i, "zEXP");
			printf("Zone Loaded. ID: %d", ZoneInfo[i][zID]);
			
			CP[i] = CreateDynamicCP(ZoneInfo[i][zCPX], ZoneInfo[i][zCPY], ZoneInfo[i][zCPZ], 2, -1, -1, -1, 100.0);
			Zone[i] = GangZoneCreate(ZoneInfo[i][zMinX], ZoneInfo[i][zMinY], ZoneInfo[i][zMaxX], ZoneInfo[i][zMaxY]);
		}
	}
	return 1;
}
			
			
forward OnAccountCheck(playerid);
public OnAccountCheck(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);
    if(rows)
    {
        cache_get_field_content(0, "Password", PlayerInfo[playerid][pPass], mysql, 129);
        PlayerInfo[playerid][pID] = cache_get_field_content_int(0, "ID");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Zanate TDM", "{FFFFFF}Bienvenido de vuelta a{F81414}Zanate TDM.{FFFFFF}\nEscribe tu contraseña para entrar..", "Login", "Quit");
    }
    else
    {
    	ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Zanate TDM", "{FFFFFF} Bienvenido a{F81414}Zanate TDM!{FFFFFF}\nEscribe la contraseña deseada para registrarte. ", "Register", "Quit");
    }
    return 1;
}


forward OnAccountLoad(playerid);
public OnAccountLoad(playerid)
{
	PlayerInfo[playerid][pMoney] = cache_get_field_content_int(0, "Money");
	PlayerInfo[playerid][pAdmin] = cache_get_field_content_int(0, "Admin");
    PlayerInfo[playerid][pVip] = cache_get_field_content_int(0, "Vip");
    PlayerInfo[playerid][pKills] = cache_get_field_content_int(0, "Kills");
    PlayerInfo[playerid][pDeaths] = cache_get_field_content_int(0, "Deaths");
	PlayerInfo[playerid][pScore] = cache_get_field_content_int(0, "Score");
	PlayerInfo[playerid][pRank] = cache_get_field_content_int(0, "Rank");
	PlayerInfo[playerid][pBanned] = cache_get_field_content_int(0, "Banned");
	PlayerInfo[playerid][pWarns] = cache_get_field_content_int(0, "Warns");
	PlayerInfo[playerid][pVW] = cache_get_field_content_int(0, "VW");
	PlayerInfo[playerid][pInt] = cache_get_field_content_int(0, "Interior");
	PlayerInfo[playerid][pMin] = cache_get_field_content_int(0, "Min");
	PlayerInfo[playerid][pHour] = cache_get_field_content_int(0, "Hours");
	PlayerInfo[playerid][pPM] = cache_get_field_content_int(0, "PM");
	PlayerInfo[playerid][pColor] = cache_get_field_content_int(0, "Color");
	PlayerInfo[playerid][pTurfs] = cache_get_field_content_int(0, "Turfs");
	PlayerInfo[playerid][pClan] = cache_get_field_content_int(0, "Clan");
    PlayerInfo[playerid][pClRank] = cache_get_field_content_int(0, "ClRank");
    PlayerInfo[playerid][pClLeader] = cache_get_field_content_int(0, "ClLeader");
    PlayerInfo[playerid][pInvited] = cache_get_field_content_int(0, "Invited");
    PlayerInfo[playerid][pInviting] = cache_get_field_content_int(0, "Inviting");


	if(PlayerInfo[playerid][pBanned] == 1)
	{
	    SendClientMessage(playerid, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado de este servidor.");
	    SendClientMessage(playerid, COLOR_RED, "BANNED:{FFFFFF} Si crees que la razón es inválida, publica una apelación en zanate.net/foro.");
		KickPlayer(playerid);
	}
	else
	{
		GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
		SetPlayerScore(playerid, PlayerInfo[playerid][pScore]);
		Logged[playerid] = 1;
		SetPlayerVirtualWorld(playerid, 0);
	}
    return 1;
}

forward OnAccountRegister(playerid);
public OnAccountRegister(playerid)
{
    PlayerInfo[playerid][pID] = cache_insert_id();
    printf("New account registered. ID: %d", PlayerInfo[playerid][pID]);
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success) SendClientMessage(playerid, yellow, "SERVER{FFFFFF}: Comando desconocido, usa /cmds para ver la lista de comandos.");
    return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	new string[128];
	for(new i = 0; i < MAX_ZONES; i++)
	{
		if(checkpointid == CP[i])
		{
			if(ZoneInfo[i][zTeam] == gTeam[playerid]) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} Tu equipo actualmente controla esta zona.");
			if(UnderAttack[i] == 1) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} Alguien más ya está atacando la zona.");
			if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} No puedes capturar la zona si estás en un vehículo.");
			UnderAttack[i] = 1;
			timer[playerid] = SetTimerEx("SetZone", 30000, false, "i", playerid);
			GangZoneFlashForAll(Zone[i],COLOR_RED);
			format(string, sizeof(string), "INFO:{FFFFFF} Estás atacando la base %s, mantente en el marcador por 30 segundos para apoderarte de ella.", ZoneInfo[i][zName]);
			SendClientMessage(playerid, COLOR_GREY, string);
			format(string, sizeof(string), "GANGZONE:{FFFFFF} ¡La base %s está bajo ataque!", ZoneInfo[i][zName]);
			SendClientMessageToAll(orange, string);
			tCheck[playerid] = i;
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
    for(new i = 0; i < MAX_ZONES; i++)
	{
		if(checkpointid == CP[i])
		{
		    UnderAttack[i] = 0;
	        GangZoneStopFlashForAll(Zone[i]);
	        KillTimer(timer[playerid]);
	        tCheck[playerid] = 0;
	    }
	}
	return 1;
}

forward SetZone(playerid);
public SetZone(playerid)
{
	new string[128];
	SetPlayerScore(playerid, GetPlayerScore(playerid) + ZoneInfo[tCheck[playerid]][zEXP]);
	PlayerInfo[playerid][pScore] += ZoneInfo[tCheck[playerid]][zEXP];
	GivePlayerMoney(playerid, ZoneInfo[tCheck[playerid]][zMoney]);
 	PlayerInfo[playerid][pMoney] += ZoneInfo[tCheck[playerid]][zMoney];
	PlayerInfo[playerid][pTurfs]++;
	format(string, sizeof(string), "INFO:{FFFFFF} Zona capturada, +%d EXP + %d$.", ZoneInfo[tCheck[playerid]][zEXP], ZoneInfo[tCheck[playerid]][zMoney]);
	SendClientMessage(playerid, COLOR_GREY, string);
	UnderAttack[tCheck[playerid]] = 0;
	KillTimer(timer[playerid]);
	SetGangZone(playerid);
	return 1;
}



forward SetGangZone(playerid);
public SetGangZone(playerid)
{
	new string[128];
	GangZoneShowForAll(Zone[tCheck[playerid]],GetTeamZoneColor(playerid));
	format(string, sizeof string, "GANGZONE:{FFFFFF} %s ha capturado la base %s por %s.", GetName(playerid), ZoneInfo[tCheck[playerid]][zName], GetTeamName(playerid));
    SendClientMessageToAll(orange, string);
	GangZoneStopFlashForAll(Zone[tCheck[playerid]]);
	ZoneInfo[tCheck[playerid]][zTeam] = gTeam[playerid];
	SaveZone(tCheck[playerid]);
	return 1;
}

public ShowZones()
{
	for(new i = 0; i < MAX_ZONES; i++)
	{
		if(ZoneInfo[i][zTeam] == 0)
		{
		    GangZoneShowForAll(Zone[i], 0xC0C0C096);
		}
		else if(ZoneInfo[i][zTeam] == TEAM_GROVE)
	    {
	        GangZoneShowForAll(Zone[i], 0x00800096);
	    }
	    else if(ZoneInfo[i][zTeam] == TEAM_BALLAS)
	    {
	        GangZoneShowForAll(Zone[i], 0x80008096);
		}
		else if(ZoneInfo[i][zTeam] == TEAM_VAGOS)
	    {
	        GangZoneShowForAll(Zone[i], 0xFFFF0096);
		}
		else if(ZoneInfo[i][zTeam] == TEAM_AZTECAS)
		{
		    GangZoneShowForAll(Zone[i], 0x00FFFF96);
		}
		else if(ZoneInfo[i][zTeam] == TEAM_POLICE)
		{
		    GangZoneShowForAll(Zone[i], 0x0000FF96);
		}
	}
}

forward TotalZones();
public TotalZones()
{
	OwnedZones[0] = 0;
    OwnedZones[1] = 0;
    OwnedZones[2] = 0;
    OwnedZones[3] = 0;
    OwnedZones[4] = 0;
	for(new i = 0; i < MAX_ZONES; i++)
	{
	    switch(ZoneInfo[i][zTeam])
	    {
			case 1:
			{
			    OwnedZones[0]++;
			}
			case 2:
			{
			    OwnedZones[1]++;
			}
			case 3:
			{
			    OwnedZones[2]++;
			}
			case 4:
			{
			    OwnedZones[3]++;
			}
			case 5:
			{
			    OwnedZones[4]++;
			}
		}
	}
}

public RankBonus(playerid)
{
    if(PlayerInfo[playerid][pRank] == 1)
	{
	    SetPlayerArmour(playerid, 5);
	}
	else if(PlayerInfo[playerid][pRank] == 2)
	{
	    SetPlayerArmour(playerid, 10);
	}
	else if(PlayerInfo[playerid][pRank] == 3)
	{
	    SetPlayerArmour(playerid, 15);
	}
	else if(PlayerInfo[playerid][pRank] == 4)
	{
	    SetPlayerArmour(playerid, 25);
	}
	else if(PlayerInfo[playerid][pRank] == 5)
	{
	    SetPlayerArmour(playerid, 35);
	}
	else if(PlayerInfo[playerid][pRank] == 6)
	{
	    SetPlayerArmour(playerid, 45);
	}
	else if(PlayerInfo[playerid][pRank] == 7)
	{
	    SetPlayerArmour(playerid, 60);
	}
	else if(PlayerInfo[playerid][pRank] == 8)
	{
	    SetPlayerArmour(playerid, 75);
	}
	else if(PlayerInfo[playerid][pRank] == 9)
	{
	    SetPlayerArmour(playerid, 90);
	    GivePlayerWeapon(playerid, 27, 150);
	}
	else if(PlayerInfo[playerid][pRank] == 10)
	{
	    SetPlayerArmour(playerid, 100);
        GivePlayerWeapon(playerid, 27, 150);
	}
	else if(PlayerInfo[playerid][pRank] == 11)
	{
	    SetPlayerArmour(playerid, 100);
        GivePlayerWeapon(playerid, 27, 200);
        GivePlayerWeapon(playerid, 31, 300);
	}
}

public TextDrawUpdate()
{
	new string[126];
	for(new i = 0; i<MAX_PLAYERS; i++)
	{
		if(Logged[i] == 1)
		{
            if(PlayerInfo[i][pScore] >= 0 && PlayerInfo[i][pScore] < 100)
			{
				PlayerInfo[i][pRank] = 0;
			}
			if(PlayerInfo[i][pScore] >= 100 && PlayerInfo[i][pScore] < 300)
			{
				PlayerInfo[i][pRank] = 1;
			}
			else if(PlayerInfo[i][pScore] >= 250 && PlayerInfo[i][pScore] < 600)
			{
			    PlayerInfo[i][pRank] = 2;
			}
			else if(PlayerInfo[i][pScore] >= 500 && PlayerInfo[i][pScore] < 900)
			{
			    PlayerInfo[i][pRank] = 3;
			}
			else if(PlayerInfo[i][pScore] >= 750 && PlayerInfo[i][pScore] < 1300)
			{
			    PlayerInfo[i][pRank] = 4;
			}
			else if(PlayerInfo[i][pScore] >= 1000 && PlayerInfo[i][pScore] < 2000)
			{
			    PlayerInfo[i][pRank] = 5;
			}
			else if(PlayerInfo[i][pScore] >= 1500 && PlayerInfo[i][pScore] < 3000)
			{
			    PlayerInfo[i][pRank] = 6;
			}
			else if(PlayerInfo[i][pScore] >= 2000 && PlayerInfo[i][pScore] < 4300)
			{
			    PlayerInfo[i][pRank] = 7;
			}
			else if(PlayerInfo[i][pScore] >= 2800 && PlayerInfo[i][pScore] < 6000)
			{
			    PlayerInfo[i][pRank] = 8;
			}
			else if(PlayerInfo[i][pScore] >= 3800 && PlayerInfo[i][pScore] < 8500)
			{
			    PlayerInfo[i][pRank] = 9;
			}
			else if(PlayerInfo[i][pScore] >= 5000 && PlayerInfo[i][pScore] < 12000)
			{
			    PlayerInfo[i][pRank] = 10;
			}
			else if(PlayerInfo[i][pScore] >= 1200)
			{
			    PlayerInfo[i][pRank] = 11;
			}
			format(string, sizeof(string), "Rank:~w~ %s", GetRankName(i));
			TextDrawSetString(Rank[i], string);
			TextDrawShowForPlayer(i, Rank[i]);
			format(string, sizeof(string), "EXP:~w~ %d", PlayerInfo[i][pScore]);
			TextDrawSetString(EXP[i], string);
			TextDrawShowForPlayer(i, EXP[i]);
			format(string, sizeof(string), "Kills:~w~ %d", PlayerInfo[i][pKills]);
			TextDrawSetString(Kills[i], string);
            TextDrawShowForPlayer(i, Kills[i]);
			format(string, sizeof(string), "Deaths:~w~ %d", PlayerInfo[i][pDeaths]);
			TextDrawSetString(Deaths[i], string);
			TextDrawShowForPlayer(i, Deaths[i]);
            TotalZones();
			format(string, sizeof(string), "Zones:~w~ %d/%d", OwnedZones[gTeam[i]-1], MAX_ZONES);
			TextDrawSetString(Zones[i], string);
			TextDrawShowForPlayer(i, Zones[i]);
			
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
    new string[16];
	if(GetPlayerTeam(issuerid) != GetPlayerTeam(playerid))
	{
		format(string, sizeof(string), "+%.0f", amount);
	    TextDrawSetString(DMGP[issuerid], string);
	    TextDrawShowForPlayer(issuerid, DMGP[issuerid]);
	    PlayerPlaySound(issuerid, 1057, 0, 0, 0);
		format(string, sizeof(string), "-%.0f", amount);
		TextDrawSetString(DMGM[playerid], string);
		TextDrawShowForPlayer(playerid, DMGM[playerid]);
		SetTimerEx("HideDMG", 1000, false, "i", issuerid);
		SetTimerEx("HideDMGM", 1000, false, "i", playerid);
	}
	return 1;
}

public HideDMG(playerid)
{
	TextDrawHideForPlayer(playerid, DMGP[playerid]);
}

public HideDMGM(playerid)
{
	TextDrawHideForPlayer(playerid, DMGM[playerid]);
}

public MessageToAdmins(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] >= 1)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public MessageToGrove(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && gTeam[i] == TEAM_GROVE)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public MessageToBallas(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && gTeam[i] == TEAM_BALLAS)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public MessageToVagos(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && gTeam[i] == TEAM_VAGOS)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public MessageToAztecas(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && gTeam[i] == TEAM_AZTECAS)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public MessageToVip(color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
        if(IsPlayerConnected(i) && PlayerInfo[i][pVip] >= 1)
        {
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public SendClanMessage(playerid, color, str[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerInfo[playerid][pClan] == PlayerInfo[i][pClan])
		{
            SendClientMessage(i, color, str);
        }
    }
	return 1;
}

public OnPlayerUseVending(playerid)
{
	PlayerInfo[playerid][pMoney] -= 1;
	return 1;
}

forward SaveClan(clanid);
public SaveClan(clanid)
{
    new query[1024];
	mysql_format(mysql, query, sizeof(query), "UPDATE `clans` SET `Name`='%e', `Leader`='%s', `Members`=%d, `Skin`=%d, `MOTD`='%s', `Rank1`='%s', `Rank2`='%s', `Rank3`='%s', `Rank4`='%s', ",\
    ClanInfo[clanid][cName], ClanInfo[clanid][cLeader], ClanInfo[clanid][cMembers] , ClanInfo[clanid][cSkin], ClanInfo[clanid][cMOTD], ClanInfo[clanid][cRank1], ClanInfo[clanid][cRank2], ClanInfo[clanid][cRank3],\
	ClanInfo[clanid][cRank4]);
    mysql_format(mysql, query, sizeof(query), "%s`Rank5`='%s', `Rank6`='%s', `x`=%f, `y`=%f, `z`=%f, `cWep1`=%d, `cWep2`=%d, `cWep3`=%d, `cWep4`=%d   WHERE `cID`=%d  ",\
 	query, ClanInfo[clanid][cRank5], ClanInfo[clanid][cRank6], ClanInfo[clanid][cx], ClanInfo[clanid][cy], ClanInfo[clanid][cz], ClanInfo[clanid][cWep1], ClanInfo[clanid][cWep2], ClanInfo[clanid][cWep3], ClanInfo[clanid][cWep4],  ClanInfo[clanid][cID]);
	mysql_tquery(mysql, query, "", "");
	printf("Saving clan ID: %d.", ClanInfo[clanid][cID]);
    return 1;
}

public SaveClans()
{
    for(new i = 0; i < MAX_CLANS; i++)
	{
		SaveClan(i);
	}
	return 1;
}

forward SaveZone(zoneid);
public SaveZone(zoneid)
{
    new query[1024];
	mysql_format(mysql, query, sizeof(query), "UPDATE `zones` SET `zName`='%e', `zMinX`=%f, `zMinY`=%f, `zMaxX`=%f, `zMaxY`=%f, `zCPX`=%f, `zCPY`=%f, `zCPZ`=%f, `zTeam`=%d, ",\
    ZoneInfo[zoneid][zName], ZoneInfo[zoneid][zMinX], ZoneInfo[zoneid][zMinY] , ZoneInfo[zoneid][zMaxX], ZoneInfo[zoneid][zMaxY], ZoneInfo[zoneid][zCPX], ZoneInfo[zoneid][zCPY], ZoneInfo[zoneid][zCPZ],\
	ZoneInfo[zoneid][zTeam]);
    mysql_format(mysql, query, sizeof(query), "%s`zMoney`=%d, `zEXP`=%d WHERE `zID`=%d  ",\
 	query, ZoneInfo[zoneid][zMoney], ZoneInfo[zoneid][zEXP], ZoneInfo[zoneid][zID]);
	mysql_tquery(mysql, query, "", "");
	printf("Saving zone ID: %d.", ZoneInfo[zoneid][zID]);
    return 1;
}

public RandomMessages()
{
    new randomMsg = random(sizeof(randomMessages));
    SendClientMessageToAll(yellow, randomMessages[randomMsg]);
}

public AntiSpawnKill(playerid)
{
	SetPlayerHealth(playerid, 100.0);
	SendClientMessage(playerid, orange, "ANTI SPAWN KILL:{FFFFFF} Anti Spawn Kill protection over!");
}

public OnLookupComplete(playerid)
{
	if(IsProxyUser(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "ANTI PROXY:{FFFFFF} ¡Proxy detectado! No puedes entrar con un proxy.");
		KickPlayer(playerid);
	}
}


public AntiCheat()
{
    for(new i = 0; i<MAX_PLAYERS; i++)
	{
		if(Logged[i] == 1)
		{
		    if(Spawned[i] == 1)
		    {
				new string[128];
				if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK)
			 	{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por usar Jetpack.", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por usar Jetpack, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
			 	}
			    else if(GetPlayerWeapon(i) == 35)
			  	{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Weapon Hacking (RPG)", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Weapon Hacking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
				}
				else if(GetPlayerWeapon(i) == 36)
				{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
                    SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Weapon Hacking (RPG)", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Weapon Hacking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
				}
				else if(GetPlayerWeapon(i) == 37)
				{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Weapon Hacking (Flame Thrower)", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Weapon Hacking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
				}
				else if(GetPlayerWeapon(i) == 38)
				{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Weapon Hacking (Minigun)", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Weapon Hacking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
				}
				else if(GetPlayerWeapon(i) == 39)
				{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Weapon Hacking (Satchel Charger)", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Weapon Hacking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
				}
				else if(GetPlayerWeapon(i) == 40)
				{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Weapon Hacking (Detonator)", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Weapon Hacking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
				}
				else if(GetPlayerWeapon(i) == 46)
				{
					PlayerInfo[i][pBanned] = 1;
					GetPlayerIp(i, IP[i], 16);
					format(string, sizeof(string), "banip %s", IP[i]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Weapon Hacking (Parachute)", GetName(i));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(i, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Weapon Hacking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(i);
				}
				else if(GetPlayerMoney(i) != PlayerInfo[i][pMoney])
				{
				    format(string, sizeof(string), "AdmWarn:{FFFFFF} Jugador %s (ID: %d) appears to have mismatch in money, he might be hacking, check him!", GetName(i), i);
					MessageToAdmins(COLOR_RED, string);
					format(string, sizeof(string), "AdmWarn:{FFFFFF} %s's game money: %d, stat money: %d.", GetName(i), GetPlayerMoney(i), PlayerInfo[i][pMoney]);
					MessageToAdmins(COLOR_RED, string);
					SetPlayerMoney(i, PlayerInfo[i][pMoney]);
					format(string, sizeof(string), "AdmWarn:{FFFFFF} Set %s's money to %d.", GetName(i), GetPlayerMoney(i));
					MessageToAdmins(COLOR_RED, string);
				}
			}
		}
	}
	return 1;
}

function SaveAccounts()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(Logged[i] == 1)
		{
			SaveAccountStats(i);
  		}
	}
}

public PlayingTime(playerid)
{
	PlayerInfo[playerid][pMin]++;
	if(PlayerInfo[playerid][pMin] >= 60)
    {
        PlayerInfo[playerid][pHour]++;
        PlayerInfo[playerid][pMin] = 0;
    }
}

public OnPlayerFakeKill(playerid)
{
	new string[128];
	PlayerInfo[playerid][pBanned] = 1;
	GetPlayerIp(playerid, IP[playerid], 16);
	format(string, sizeof(string), "banip %s", IP[playerid]);
	SendRconCommand(string);
	format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por fake killing.", GetName(playerid));
	SendClientMessageToAll(COLOR_RED, string);
	SendClientMessage(playerid, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por fake killing, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
	KickPlayer(playerid);
	return 1;
}

public OnPlayerAirbreak(playerid)
{
	if(PlayerInfo[playerid][pAdmin] == 0)
	{
		if(Logged[playerid] == 1)
		{
			if(Spawned[playerid] == 1)
			{
                new string[128];
				if(ABCheck[playerid] == 0)
				{
				    ABCheck[playerid] = 1;
				    format(string, sizeof(string), "AdmWarn:{FFFFFF} %s is possibly airbreak hacking (Check 1/2) - use /clearcheck in case this is false.", GetName(playerid));
				    MessageToAdmins(COLOR_RED, string);
				}
				else if(ABCheck[playerid] == 1)
				{
					PlayerInfo[playerid][pBanned] = 1;
					GetPlayerIp(playerid, IP[playerid], 16);
					format(string, sizeof(string), "banip %s", IP[playerid]);
					SendRconCommand(string);
					format(string, sizeof(string), "ANTI-CHEAT:{FFFFFF} %s ha sido baneado por Airbraking.", GetName(playerid));
					SendClientMessageToAll(COLOR_RED, string);
					SendClientMessage(playerid, COLOR_RED, "BANNED:{FFFFFF} Has sido baneado por Airbraking, en caso de que esto no sea correcto, apela el ban en zanate.net/foro.");
					KickPlayer(playerid);
				}
			}
		}
	}
	return 1;
}

forward SaveAccountStats(playerid);
public SaveAccountStats(playerid)
{
	if(Logged[playerid] == 1)
	{
		new query[1024];
		mysql_format(mysql, query, sizeof(query), "UPDATE `users` SET `Money`=%d, `Admin`=%d, `Vip`=%d, `Kills`=%d, `Deaths`=%d, `Score`=%d, `Rank`=%d, `Banned`=%d, `Warns`=%d, ",\
	    PlayerInfo[playerid][pMoney], PlayerInfo[playerid][pAdmin], PlayerInfo[playerid][pVip] , PlayerInfo[playerid][pKills], PlayerInfo[playerid][pDeaths], PlayerInfo[playerid][pScore], PlayerInfo[playerid][pRank], PlayerInfo[playerid][pBanned],\
		PlayerInfo[playerid][pWarns]);
	    mysql_format(mysql, query, sizeof(query), "%s`VW`=%d, `Interior`=%d, `Min`=%d, `Hours`=%d, `PM`=%d, `Color`=%d, `Turfs`=%d, `Clan`=%d, ",\
	 	query, PlayerInfo[playerid][pVW], PlayerInfo[playerid][pInt], PlayerInfo[playerid][pMin], PlayerInfo[playerid][pHour], PlayerInfo[playerid][pPM], PlayerInfo[playerid][pColor], PlayerInfo[playerid][pTurfs], PlayerInfo[playerid][pClan]);
		mysql_format(mysql, query, sizeof(query), "%s`ClRank`=%d, `ClLeader`=%d, `Invited`=%d, `Inviting`=%d  WHERE `ID`=%d",\
		query, PlayerInfo[playerid][pClRank], PlayerInfo[playerid][pClLeader], PlayerInfo[playerid][pInvited], PlayerInfo[playerid][pInviting],  PlayerInfo[playerid][pID]);
		mysql_tquery(mysql, query, "", "");
		return 1;
	}
    return 0;
}

/* Stocks */

stock UserPath(playerid)
{
    new string[128], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid,playername,sizeof(playername));
    format(string,sizeof(string),PATH,playername);
    return string;
}


stock Log(FileName[], Input[]) {

    new string[128];
	new date[2][3], File: fileHandle = fopen(FileName, io_append);
	gettime(date[0][0], date[0][1], date[0][2]);
	getdate(date[1][0], date[1][1], date[1][2]);
	format(string, sizeof(string), "[%i/%i/%i - %i:%i:%i] %s\r\n", date[1][2], date[1][1], date[1][0], date[0][0], date[0][1], date[0][2], Input);
	fwrite(fileHandle, string);
	return fclose(fileHandle);
}

stock GetTeamZoneColor(playerid)
{
    switch(gTeam[playerid])
    {
        case TEAM_GROVE: return 0x00800096;
        case TEAM_BALLAS: return 0x80008096;
        case TEAM_VAGOS: return 0xFFFF0096;
        case TEAM_AZTECAS: return 0x00FFFF96;
        case TEAM_POLICE: return 0x0000FF96;
    }
    return -1;
}

stock GetTeamName(playerid)
{
	new string[64];
	switch(gTeam[playerid])
    {
        case TEAM_GROVE:
        {
            string = "Grove Street";
        }
        case TEAM_BALLAS:
        {
            string = "Ballas";
        }
        case TEAM_VAGOS:
        {
            string = "Vagos";
        }
        case TEAM_AZTECAS:
		{
		    string = "Aztecas";
		}
		case TEAM_POLICE:
		{
		    string = "Police";
		}
    }
    return string;
}

stock GetName(playerid)
{
    new string[128];
	GetPlayerName(playerid,string,24);
    new str[24];
    strmid(str,string,0,strlen(string),24);
    return str;
}

stock GetRankName(playerid)
{
	new str[64];
	if (PlayerInfo[playerid][pRank] == 0) str = ("Newbie");
	if (PlayerInfo[playerid][pRank] == 1) str = ("Outsider");
	if (PlayerInfo[playerid][pRank] == 2) str = ("Small Time");
	if (PlayerInfo[playerid][pRank] == 3) str = ("Crook");
	if (PlayerInfo[playerid][pRank] == 4) str = ("Side Man");
	if (PlayerInfo[playerid][pRank] == 5) str = ("Gangster");
	if (PlayerInfo[playerid][pRank] == 6) str = ("OG");
	if (PlayerInfo[playerid][pRank] == 7) str = ("Big Time");
	if (PlayerInfo[playerid][pRank] == 8) str = ("Badass");
	if (PlayerInfo[playerid][pRank] == 9) str = ("Master");
	if (PlayerInfo[playerid][pRank] == 10) str = ("Godfather");
	if (PlayerInfo[playerid][pRank] == 11) str = ("Kingpin");
	return str;
}

stock GetClRankName(playerid)
{
	new string[128], name[128];
	if(PlayerInfo[playerid][pClRank] == 1)
	{
		format(string, sizeof(string), "%s", ClanInfo[PlayerInfo[playerid][pClan]-1][cRank1]);
		name = string;
	}
	else if(PlayerInfo[playerid][pClRank] == 2)
	{
		format(string, sizeof(string), "%s", ClanInfo[PlayerInfo[playerid][pClan]-1][cRank2]);
		name = string;
	}
	else if(PlayerInfo[playerid][pClRank] == 3)
	{
		format(string, sizeof(string), "%s", ClanInfo[PlayerInfo[playerid][pClan]-1][cRank3]);
		name = string;
	}
	else if(PlayerInfo[playerid][pClRank] == 4)
	{
		format(string, sizeof(string), "%s", ClanInfo[PlayerInfo[playerid][pClan]-1][cRank4]);
		name = string;
	}
	else if(PlayerInfo[playerid][pClRank] == 5)
	{
		format(string, sizeof(string), "%s", ClanInfo[PlayerInfo[playerid][pClan]-1][cRank5]);
		name = string;
	}
	else if(PlayerInfo[playerid][pClRank] == 6)
	{
		format(string, sizeof(string), "%s", ClanInfo[PlayerInfo[playerid][pClan]-1][cRank6]);
		name = string;
	}
	return name;
}
	    


stock ShowStatsForPlayer(playerid, targetid)
{
	new string[450],
	Kill = PlayerInfo[playerid][pKills],
 	Death = PlayerInfo[playerid][pDeaths],
 	XP = PlayerInfo[playerid][pScore],
 	Admin = PlayerInfo[playerid][pAdmin],
 	Vip = PlayerInfo[playerid][pVip],
 	Warns = PlayerInfo[playerid][pWarns],
 	Hour = PlayerInfo[playerid][pHour],
 	Minute = PlayerInfo[playerid][pMin],
 	Money = PlayerInfo[playerid][pMoney],
	Turfs = PlayerInfo[playerid][pTurfs],
	Float: KD = floatdiv(PlayerInfo[playerid][pKills], PlayerInfo[playerid][pDeaths]);
	format(string, sizeof(string), "{00FF22}Name:{FFFFFF} %s\n{00FF22}Kills:{FFFFFF} %d\n{00FF22}Deaths:{FFFFFF} %d\n{00FF22}EXP:{FFFFFF} %d\n{00FF22}Rank:{FFFFFF} %s\n{00FF22}Admin:{FFFFFF} %d\n{00FF22}Vip:{FFFFFF} %d\n{00FF22}Warns:{FFFFFF} %d\n{00FF22}Playing Time:{FFFFFF} %d Hours %d Minutes\n{00FF22}Money:{FFFFFF} %d$\n{00FF22}K/D:{FFFFFF} %.2f\n{00FF22}Turfs:{FFFFFF} %d", GetName(playerid), Kill, Death, XP, GetRankName(playerid), Admin, Vip, Warns, Hour, Minute, Money, KD, Turfs);
    ShowPlayerDialog(targetid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "Stats", string, "Okay", "");
}

stock GMX()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		SaveAccountStats(i);
	}
	SaveClans();
	return 1;
}

stock AdminLevelName(playerid)
{
        new str[32];
        if		(PlayerInfo[playerid][pAdmin] == 1) str = (ADMINRANK1);
        else if (PlayerInfo[playerid][pAdmin] == 2) str = (ADMINRANK2);
        else if (PlayerInfo[playerid][pAdmin] == 3) str = (ADMINRANK3);
        else if (PlayerInfo[playerid][pAdmin] == 4) str = (ADMINRANK4);
        else if (PlayerInfo[playerid][pAdmin] == 5) str = (ADMINRANK5);
        else if (PlayerInfo[playerid][pAdmin] == 1338) str = (ADMINRANK6);
		return str;
}

stock ClearChat()
{
    for (new c = 0; c < 150; c++)
    {
        SendClientMessageToAll(-1, " ");
    }
}

/*stock LoadClans()
{
    for(new i = 1; i < MAX_CLANS; i++)
    {
		LoadClan(i);
	}
}*/

stock CreateClans()
{
    for(new i = 0; i < MAX_CLANS; i++)
    {
		CreateClan(i);
	}
}

stock SetPlayerMoney(playerid, amount)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, amount);
	PlayerInfo[playerid][pMoney] = amount;
}
		    
/* SAMP 0.3x Kick sys */

forward KickPublic(targetid);
public KickPublic(targetid) { Kick(targetid); }


// To kick a player with a delay so he can get a message.
KickPlayer(playerid)
{
    SetTimerEx("KickPublic", 100, 0, "d", playerid);
    return 1;
}

//This one also sends the reason inserted
KickWithMessage(targetid, reason[])
{
	new string[128];
	format(string, sizeof(string), "REASON:{FFFFFF} %s", reason);
	SendClientMessageToAll(COLOR_RED, string);
    SetTimerEx("KickPublic", 100, 0, "d", targetid);
    return 1;
}
//==============================================================================
//                       Trainee Administrator Commands
//==============================================================================

CMD:a(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128], text[128];
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params,"s[128]", text)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /a [message]");
		format(string, sizeof(string), "{FFD700}ADMIN CHAT:{9C9C8A} %s: %s", GetName(playerid), text);
		MessageToAdmins(yellow, string);
	}
	return 1;
}

CMD:check(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid;
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /check [playerid]");
        if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
        ShowStatsForPlayer(targetid, playerid);
    }
    return 1;
}
CMD:spec(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128], targetid;
	    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params,"u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /spec [playerid]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		TogglePlayerSpectating(playerid, 1);
		if(IsPlayerInAnyVehicle(targetid))
  		{
    		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid), SPECTATE_MODE_NORMAL);
		}
		else
		{
		    PlayerSpectatePlayer(playerid, targetid, SPECTATE_MODE_NORMAL);
      	}
		format(string, sizeof(string), "INFO:{FFFFFF} You're currently spectating %s, use /endspec to stop spectating.", GetName(targetid));
		SendClientMessage(playerid, COLOR_GREY, string);
		format(string, sizeof(string), "AdmWarn:{FFFFFF} %s is spectating %s", GetName(playerid), GetName(targetid));
		MessageToAdmins(COLOR_RED, string);
	}
	return 1;
}

CMD:endspec(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		TogglePlayerSpectating(playerid, 0);
	}
	return 1;
}

CMD:kick(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128], targetid, reason[128];
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params,"us[128]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /kick [playerid] [reason]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You can't kick higher ranked Administrators.");
		format(string, sizeof(string), "KICK:{FFFFFF} %s has been kicked by %s.", GetName(targetid), GetName(playerid));
		SendClientMessageToAll(COLOR_RED, string);
		KickWithMessage(targetid, reason);
	}
	return 1;
}

CMD:goto(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, string[128];
	    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /goto [playerid]");
	    else if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
	    else
	    {
		    new Float:x, Float:y, Float:z;
		    GetPlayerPos(targetid, x, y, z);
		    SetPlayerPos(playerid, x+1, y+1, z);
		    format(string, sizeof(string), "AdmCmd:{FFFFFF} You have sucesfully teleported to %s.", GetName(targetid));
			SendClientMessage(playerid, COLOR_RED, string);
			format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has teleported to you.", GetName(playerid));
			SendClientMessage(targetid, COLOR_GREY, string);
	    }
	}
    return 1;
}

CMD:forcerules(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new targetid, string[128], rules[1024];
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /forcerules [playerid]");
  		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		strcat(rules, "{00FF22}Rule 1:{FFFFFF} Hacking or using any kind of mods which give you advantage is NOT allowed.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 2:{FFFFFF} Drive By with weapons such as Combat Shotgun and Deagle is NOT allowed.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 3:{FFFFFF} Insulting other players as well as racism will not be tolerated.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 4:{FFFFFF} Do NOT bug abuse, in case you find a bug, report it on the forums please.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 5:{FFFFFF} Server Advertising will not be tolerated, it will lead you to a instant permanent ban.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 6:{FFFFFF} Do NOT Car Park and Heli Blade other players.\n", sizeof(rules));
		strcat(rules, "{00FF22}Rule 7:{FFFFFF} Using IRL money to sell in game stuff such as accounts, in game money etc will NOT be tolerated. \n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 8:{FFFFFF} Respect Admin's decision, his word is final. In case you don't agree with the administrators action, report it on forum.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 9:{FFFFFF} No Driver Drive By! Due to a lot of players seeming to annoy others with Drive By, we decided to put a rule against it!\n", sizeof(rules));
		ShowPlayerDialog(targetid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, "Rules", rules, "Agree", "Disagree");
		format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully forced rules dialog to %s", GetName(targetid));
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has forced the rules dialog onto you.", GetName(playerid));
		SendClientMessage(targetid, COLOR_GREY, string);
	}
	return 1;
}

CMD:setint(playerid, params[])
{
	new targetid, int, string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
    if(sscanf(params, "ud", targetid, int)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /setint [playerid] [interiorid]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} That player isn't online.");
    else
    {
        PlayerInfo[targetid][pInt] = int;
        SetPlayerInterior(targetid, int);
        format(string, sizeof(string), "AdmCmd:{FFFFFF} You have set %s's interior to %d.", GetName(targetid), int);
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set your interior to %d.", GetName(playerid), int);
		SendClientMessage(playerid, COLOR_GREY, string);
	}
	return 1;
}

CMD:setvw(playerid, params[])
{
	new targetid, vw, string[128];
	if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
    if(sscanf(params, "ud", targetid, vw)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /setvw [playerid] [world id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} That player isn't online.");
    else
    {
        PlayerInfo[targetid][pVW] = vw;
        SetPlayerVirtualWorld(targetid, vw);
        format(string, sizeof(string), "AdmCmd:{FFFFFF} You have set %s's Virtual World to %d.", GetName(targetid), vw);
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set your Virtual World to %d.", GetName(playerid), vw);
		SendClientMessage(playerid, COLOR_GREY, string);
	}
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, string[128];
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /freeze [playerid]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} That player isn't online.");
		format(string, sizeof(string), "FREEZE:{FFFFFF} Administrator %s has froze %s.", GetName(playerid), GetName(targetid));
		SendClientMessageToAll(COLOR_RED, string);
		format(string, sizeof(string), "FREEZE:{FFFFFF} You have been frozen by %s.", GetName(playerid));
		SendClientMessage(targetid, COLOR_RED, string);
		TogglePlayerControllable(targetid, 0);
	}
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, string[128];
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /unfreeze [playerid]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} That player isn't online.");
		format(string, sizeof(string), "FREEZE:{FFFFFF} Administrator %s has unfroze %s.", GetName(playerid), GetName(targetid));
		SendClientMessageToAll(COLOR_RED, string);
		format(string, sizeof(string), "FREEZE:{FFFFFF} You have been unfrozen by %s.", GetName(playerid));
		SendClientMessage(targetid, COLOR_RED, string);
		TogglePlayerControllable(targetid, 1);
	}
	return 1;
}

CMD:clearcheck(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, string[128];
		if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /clearcheck [playerid]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} That player isn't online.");
        format(string, sizeof(string), "AdmWarn:{FFFFFF} Administrator %s has cleared %s's Anti Airbrake check.", GetName(playerid), GetName(targetid));
		MessageToAdmins(COLOR_RED, string);
		format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully cleared %s's Anti Airbrake check.", GetName(targetid));
		SendClientMessage(playerid, COLOR_RED, string);
		ABCheck[targetid] = 0;
	}
	return 1;
}

//==============================================================================
//                          Administrator Commands
//==============================================================================

CMD:gethere(playerid,params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, string[128];
	    new Float:x, Float:y, Float:z;
	    if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /gethere [playerid]");
	    else if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		else
		{
			GetPlayerPos(playerid, x, y, z);
		    SetPlayerPos(targetid, x+1, y+1, z);
		    format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully teleported %s to yourself.", GetName(targetid));
			SendClientMessage(playerid, COLOR_RED, string);
			format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has teleported you to himself.", GetName(playerid));
			SendClientMessage(targetid, COLOR_GREY, string);
		}
	}
	return 1;
}

CMD:slap(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
		new targetid, Float:x, Float:y, Float:z, str[126];
		if(PlayerInfo[playerid][pAdmin] < 2 ) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command." );
	   	if(sscanf(params,"d", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /slap [playerid]");
	   	if(IsPlayerConnected(targetid))
	   	{
			GetPlayerPos(targetid, x, y, z);
	    	SetPlayerPos(targetid, x, y, z+6);
	    	format(str, sizeof(str),"AdmCmd:{FFFFFF} You have successfully slapped %s!", GetName(targetid));
	    	SendClientMessage(playerid, COLOR_RED, str);
	    	PlayerPlaySound(targetid, 1190, 0.0, 0.0, 0.0);
	    	PlayerPlaySound(playerid, 1190, 0.0, 0.0, 0.0);
	   	}
	   	else return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} That player isn't online.");
	}
   	return 1;
}

CMD:ban(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128], targetid, reason[60];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params,"us[60]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /ban [playerid] [reason]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is a higher ranked Administrator.");
		PlayerInfo[targetid][pBanned] = 1;
		new Day, Month, Year;
		getdate(Year, Month, Day);
	    format(string, sizeof(string), "BAN:{FFFFFF} %s has been banned by %s", GetName(targetid), GetName(playerid));
		SendClientMessageToAll(COLOR_RED, string);
		format(string, sizeof(string), "%s Banned - %04d/%02d/%02d", GetName(targetid), Year, Month, Day);
		Log("/ZTDM/Logs/ban.txt", string);
	    GetPlayerIp(targetid, IP[playerid], 16);
		format(string, sizeof(string), "Player's IP:{FFFFFF} %s (/banip to ban it)", IP[playerid]);
		SendClientMessage(playerid, COLOR_RED, string);
		KickWithMessage(targetid, reason);
	}
    return 1;
}

CMD:banip(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "s[16]", IP[playerid])) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /banip [IP]");
        format(string, sizeof(string), "banip %s", IP[playerid]);
		SendRconCommand(string);
	    format(string, sizeof(string), "INFO:{FFFFFF} You have successfully banned the IP '%s'", IP[playerid]);
	    SendClientMessage(playerid, COLOR_GREY, string);
	    format(string, sizeof(string), "AdmWarn:{FFFFFF} %s has banned the IP %s.", GetName(playerid), IP[playerid]);
	    MessageToAdmins(COLOR_RED, string);
	    format(string, sizeof(string), "IP Ban: %s", IP[playerid]);
	    Log("/ZTDM/Logs/IPBan.txt", string);
	}
	return 1;
}

CMD:giveexp(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, amount, string[128];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /giveexp [playerid] [amount]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		PlayerInfo[targetid][pScore] += amount;
		SetPlayerScore(targetid, GetPlayerScore(targetid) + amount);
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has gave you %d EXP points", GetName(playerid), amount);
		SendClientMessage(targetid, COLOR_GREY, string);
	}
	return 1;
}

CMD:warn(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128], targetid, reason[128];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params, "us[128]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /warn [playerid] [reason]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is higher ranked Administrator than you.");
		PlayerInfo[targetid][pWarns]++;
		format(string, sizeof(string), "WARN:{FFFFFF} Administrator %s has warned %s (%d/3)", GetName(playerid), GetName(targetid), PlayerInfo[targetid][pWarns]);
		SendClientMessageToAll(COLOR_RED, string);
		format(string, sizeof(string), "REASON:{FFFFFF} %s", reason);
		SendClientMessageToAll(COLOR_RED, string);
		if(PlayerInfo[targetid][pWarns] >= 3)
		{
			format(string, sizeof(string), "BAN:{FFFFFF} %s has been banned for reaching 3 warnings.", GetName(targetid));
			SendClientMessageToAll(COLOR_RED, string);
			PlayerInfo[targetid][pBanned] = 1;
			SendClientMessage(targetid, COLOR_RED, "BAN:{FFFFFF} You have been banned for reaching 3 warnings.");
			SendClientMessage(targetid, COLOR_RED, "BAN:{FFFFFF} If you got banned for a wrong reason, please make an appeal on zanate.net/foro.");
			KickPlayer(targetid);
			GetPlayerIp(targetid, IP[playerid], 16);
			format(string, sizeof(string), "Player's IP:{FFFFFF} %s (/banip to ban it)", IP[playerid]);
			SendClientMessage(playerid, COLOR_RED, string);
		}
	}
	return 1;
}

CMD:ann(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new text[60];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
		if(sscanf(params, "s[60]", text)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /ann [message]");
		GameTextForAll(text, 3000, 3);
	}
	return 1;
}

CMD:fixveh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	if(IsPlayerInAnyVehicle(playerid))
	{
 		RepairVehicle(GetPlayerVehicleID(playerid));
 		SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Your vehicle has been successfully repaired.");
	}
	else SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You need to be in a vehicle to use that command");
    return 1;
}

CMD:cc(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		ClearChat();
		SendClientMessageToAll(yellow, "SERVER:{FFFFFF} Chat has been cleared by an Administrator");
		format(string, sizeof(string), "AdmWarn:{FFFFFF} %s has cleared the chat.", GetName(playerid));
		MessageToAdmins(COLOR_RED, string);
	}
	return 1;
}


//==============================================================================
//                          Senior Administrator Commands
//==============================================================================

CMD:setexp(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, amount, string[128];
		if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /setexp [playerid] [amount]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		PlayerInfo[targetid][pScore] = amount;
		SetPlayerScore(targetid, amount);
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set your EXP points to %d.", GetName(playerid), amount);
		SendClientMessage(targetid, COLOR_GREY, string);
		format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully set %s's EXP to %d.", GetName(targetid), amount);
		SendClientMessage(playerid, COLOR_RED, string);
	}
	return 1;
}

CMD:unwarn(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128], targetid, reason[128];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params, "us[128]", targetid, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /unwarn [playerid] [reason]");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		if(PlayerInfo[targetid][pAdmin] > PlayerInfo[playerid][pAdmin]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is higher ranked Administrator than you.");
        PlayerInfo[targetid][pWarns]--;
		format(string, sizeof(string), "WARN:{FFFFFF} Administrator %s has unwarned %s (%d/3)", GetName(playerid), GetName(targetid), PlayerInfo[targetid][pWarns]);
		SendClientMessageToAll(COLOR_RED, string);
		format(string, sizeof(string), "REASON:{FFFFFF} %s", reason);
		SendClientMessageToAll(COLOR_RED, string);
	}
	return 1;
}

CMD:sethealth(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128], targetid, amount;
	    if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
	    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /sethealth [playerid] [amount]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
	    SetPlayerHealth(targetid, amount);
	    format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully set %s's health to %d.", GetName(targetid), amount);
	    SendClientMessage(playerid, COLOR_RED, string);
	    format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set your health to %d.", GetName(playerid), amount);
	    SendClientMessage(targetid, COLOR_GREY, string);
	}
	return 1;
}

CMD:setarmour(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128], targetid, amount;
	    if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
	    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /setarmour [playerid] [amount]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
	    SetPlayerArmour(targetid, amount);
	    format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully set %s's armour to %d.", GetName(targetid), amount);
	    SendClientMessage(playerid, COLOR_RED, string);
	    format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set your armour to %d.", GetName(playerid), amount);
	    SendClientMessage(targetid, COLOR_GREY, string);
	}
	return 1;
}

CMD:setkills(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, amount, string[128];
		if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /setkills [playerid] [amount]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		PlayerInfo[targetid][pKills] = amount;
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set your kills to %d.", GetName(playerid), amount);
		SendClientMessage(targetid, COLOR_GREY, string);
		format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully set %s's kills to %d.", GetName(targetid), amount);
		SendClientMessage(playerid, COLOR_RED, string);
	}
	return 1;
}

CMD:setdeaths(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, amount, string[128];
		if(PlayerInfo[playerid][pAdmin] < 3) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /setdeaths [playerid] [amount]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		PlayerInfo[targetid][pDeaths] = amount;
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set your deaths to %d.", GetName(playerid), amount);
		SendClientMessage(targetid, COLOR_GREY, string);
		format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully set %s's deaths to %d.", GetName(targetid), amount);
		SendClientMessage(playerid, COLOR_RED, string);
	}
	return 1;
}


//==============================================================================
//                          Lead Administrator Commands
//==============================================================================

CMD:unban(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new query[128], account[30];
	    if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "s[30]", account)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /unban [AccountName]");
        format(query, sizeof(query), "SELECT * FROM `users` WHERE `Username` = '%s' AND `Banned` = 1", account);
		mysql_tquery(mysql, query, "BanResults", "ii", playerid, account);
    }
    return 1;
}

CMD:unbanip(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128];
		if(PlayerInfo[playerid][pAdmin] < 2) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "s[16]", IP[playerid])) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /unbanip [IP]");
        format(string, sizeof(string), "unbanip %s", IP[playerid]);
		SendRconCommand(string);
	    format(string, sizeof(string), "INFO:{FFFFFF} You have successfully unbanned the ip '%s'", IP[playerid]);
	    SendClientMessage(playerid, COLOR_GREY, string);
	    format(string, sizeof(string), "AdmWarn:{FFFFFF} %s has unbanned the IP %s.", GetName(playerid), IP[playerid]);
	    MessageToAdmins(COLOR_RED, string);
	    format(string, sizeof(string), "IP unban: %s", IP[playerid]);
	    Log("/ZTDM/Logs/IPUnban.txt", string);
	}
	return 1;
}

CMD:blowup(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
        new targetid, Float:x, Float:y, Float:z, str[126];
		if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
	 	if(sscanf(params,"d", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /blowup [playerid]");
	  	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		else
		{
	    	GetPlayerPos(targetid, x, y, z);
	    	CreateExplosion(x, y, z, 7, 10.0);
	    	format(str, sizeof(str),"AdmCmd:{FFFFFF} You have succesfully blown up %s!", GetName(targetid));
	     	SendClientMessage(playerid, COLOR_RED, str);
		}
	}
   	return 1;
}

//This command has been removed and needs to be changed to MySql format for it to work! - Blast3r.
/*CMD:changename(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, string[128], name[28], exists[64];
		if(PlayerInfo[playerid][pAdmin] < 4) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
		if(sscanf(params,"us[128]", targetid, name)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /changename [playerid] [name]");
  		format(exists, sizeof(exists), "/CSW/Users/%s.ini", name);
		if(fexist(exists)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That name is already taken.");
		format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully changed %s's name to %s.", GetName(targetid), name);
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has changed your name to %s.", GetName(playerid), name);
		SendClientMessage(targetid, COLOR_GREY, string);
		SetPlayerName(targetid, name);
		new INI:File = INI_Open(UserPath(targetid));
 		INI_SetTag(File,"data");
		INI_WriteInt(File,"Password",PlayerInfo[targetid][pPass]);
		INI_Close(File);
		
	}
	return 1;
}*/




//==============================================================================
//                          Head Administrator Commands
//==============================================================================

CMD:makeadmin(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
		new targetid, amount, string[128];
		if(PlayerInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /makeadmin [playerid] [adminrank]");
	    if(targetid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		if(amount > 5) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} You can only choose from 0-5.");
		if(amount < 0) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Invalid Administrator Level.");
	    else
		{
			format(string, sizeof(string), "AdmWarn:{FFFFFF} %s has set %s's administrator level to %d.", GetName(playerid), GetName(targetid), amount);
			MessageToAdmins(COLOR_RED, string);
			PlayerInfo[targetid][pAdmin] = amount;
		    format(string, sizeof(string), "INFO:{FFFFFF} %s has made you level %d Administrator.", GetName(playerid), amount);
			SendClientMessage(targetid, COLOR_GREY, string);
			format(string, sizeof(string), "MAKE-ADMIN: %s has made %s a level %i adminstrator.", GetName(playerid), GetName(targetid), amount);
			Log("/ZTDM/Logs/administration.txt", string);
		}
	}
    return 1;
}

CMD:makeleader(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new targetid, amount, string[128];
	    if(PlayerInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /makeleader [playerid] [clanid]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
        if(PlayerInfo[targetid][pClan] != 0) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is already a member of a clan.");
		if(PlayerInfo[targetid][pClLeader] != 0) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is already a leader of a clan.");
		if(amount > 6) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} You can only choose from 1-6.");
		if(amount < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You can only choose from 1-6.");
		else
		{
		    format(string, sizeof(string), "AdmWarn:{FFFFFF} %s has set %s as a leader of clan ID %d.", GetName(playerid), GetName(targetid), amount);
		    MessageToAdmins(COLOR_RED, string);
			format(ClanInfo[amount-1][cLeader], 128, "%s", GetName(targetid));
			ClanInfo[amount-1][cMembers]++;
			PlayerInfo[targetid][pClan] = amount;
   			PlayerInfo[targetid][pClRank] = 6;
			SaveClan(PlayerInfo[targetid][pClan]-1);
   			format(string, sizeof(string), "AdmCmd:{FFFFFF} You have successfully set %s as leader of clan ID %d.", GetName(targetid), amount);
   			SendClientMessage(playerid, COLOR_RED, string);
   			format(string, sizeof(string), "INFO:{FFFFFF} Administrator %s has set you as leader of clan ID %d.", GetName(playerid), amount);
   			SendClientMessage(targetid, COLOR_GREY, string);
			format(string, sizeof(string), "CL-LEADER: %s has made %s as leader of ID %d.", GetName(playerid), GetName(targetid), amount);
			Log("/ZTDM/Logs/ClanLeadership.txt", string);
		}
	}
	return 1;
}

//==============================================================================
//                          Server Co Owner Commands
//==============================================================================

CMD:makevip(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
		new targetid, amount, string[128];
		if(PlayerInfo[playerid][pAdmin] < 1337) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command!");
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /makevip [playerid] [viprank]");
	    if(targetid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		if(amount > 4) return SendClientMessage(playerid, COLOR_RED,"ERROR:{FFFFFF} You can only choose from 1-4.");
		if(amount < 0) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Invalid VIP Level.");
	    else
		{
			format(string, sizeof(string), "AdmWarn:{FFFFFF} %s has set %s's VIP level to %d.", GetName(playerid), GetName(targetid), amount);
			MessageToAdmins(COLOR_RED, string);
			PlayerInfo[targetid][pVip] = amount;
		    format(string, sizeof(string), "INFO:{FFFFFF} %s has set your VIP to level %d.", GetName(playerid), amount);
			SendClientMessage(targetid, COLOR_GREY, string);
			format(string, sizeof(string), "MAKE-VIP: %s has made %s a level %i VIP.", GetName(playerid), GetName(targetid), amount);
			Log("/ZTDM/Logs/vip.txt", string);
		}
	}
    return 1;
}

//==============================================================================
//                               Owner Commands
//==============================================================================

//Temporary Command
CMD:veh(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 1338)
 	{
  		new veh,color1,color2;
    	if (!sscanf(params, "iii", veh, color1,color2))
     	{
      		new Float:x, Float:y, Float:z;
        	GetPlayerPos(playerid, x,y,z);
         	AddStaticVehicleEx(veh, x,y,z,0,color1, color2, -1);
       	}
        else SendClientMessage(playerid, -1, "USAGE: /veh [carid] [color 1] [color 2]");
   	}
    else SendClientMessage(playerid, -1, "Only Administrators are allowed to use this command!");
   	return 1;
}

CMD:tod(playerid, params[])
{
	new amount;
	if(PlayerInfo[playerid][pAdmin] < 5) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
    else if(sscanf(params, "i", amount)) return SendClientMessage(playerid, COLOR_GREY,"USAGE:{FFFFFF} /tod [Hour]");
    else
    {
    	SetWorldTime(amount);
		SendClientMessage(playerid,COLOR_GREY,"INFO:{FFFFFF} Time has been sucesfully changed");
	}
	return 1;
}

//==============================================================================
//                      End of Administrator Commands
//==============================================================================

CMD:help(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new help[2048];
		strcat(help, "{FFFFFF}Here at {F81414}Crazy Street Wars{FFFFFF} your main objective is to kill enemy gang members and take over their turfs.\n\n", sizeof(help));
        strcat(help, "{FFCC00}Turfs:{FFFFFF}\n\n\nTaking over turfs will help you get more EXP points and more money.\nMore EXP points means faster rank up and more money means more buyable stuff!\n\n\n", sizeof(help));
        strcat(help, "To take over a turf simply get into the turf zone and find the red marker. It usually gets shown on the minimap once you're near it.\nOnce you enter the marker you'll have to stand in it for 30 seconds to take over the turf.\n", sizeof(help));
        strcat(help, "Once you take over the turf you'll be given money and EXP bonus and that turf will belong to your gang.\nEach turf gives different amount of EXP and money, depending of its size and its location.\n\n\n", sizeof(help));
        strcat(help, "{00FF22}EXP and Ranks:{FFFFFF}\n\n\nRanks are essential if you're interested in getting a bonus such as armor or better weapons.\nTo rank up, you need to reach a special amount of EXP points which you can get by killing enemies or taking over turfs.\n", sizeof(help));
        strcat(help, "You can also earn EXP points by reaching {F81414}Kill Streaks!{FFFFFF}\n\nIn case you're interested about the ranks and the amount of EXP you need for it, type /ranks.\n\n\n", sizeof(help));
		strcat(help, "{00F6FF}Useful Commands:{FFFFFF}\n\n\nIn case you want some help or more information about a special part, check out these commands:\n\n", sizeof(help));
        strcat(help, "/cmds\n/rules\n/ranks\n/credits\n\n\n{F81414}Good luck and have fun!", sizeof(help));
		ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Help", help, "Okay", "");
	}
	return 1;
}

CMD:credits(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    ShowPlayerDialog(playerid, DIALOG_CREDITS, DIALOG_STYLE_MSGBOX, "Credits", "{00FF22}Blast3r{FFFFFF} - Scripting & Mapping - original gamemode creator.\n{00FF22}TinyTina{FFFFFF} - Mapping.\n{00FF22}rbN{FFFFFF} - Assistance with the Anti Cheat.\n{00FF22}Tosfera{FFFFFF} - Assistance with MySql.", "Okay", " Drulutz: Modificador de Script");
	}
	return 1;
}

CMD:rules(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
		new rules[1024];
		strcat(rules, "{00FF22}Rule 1:{FFFFFF} Hacking or using any kind of mods which give you advantage is NOT allowed.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 2:{FFFFFF} Drive By with weapons such as Combat Shotgun and Deagle is NOT allowed.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 3:{FFFFFF} Insulting other players as well as racism will not be tolerated.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 4:{FFFFFF} Do NOT bug abuse, in case you find a bug, report it on the forums please.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 5:{FFFFFF} Server Advertising will not be tolerated, it will lead you to a instant permanent ban.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 6:{FFFFFF} Do NOT Car Park and Heli Blade other players.\n", sizeof(rules));
		strcat(rules, "{00FF22}Rule 7:{FFFFFF} Using IRL money to sell in game stuff such as accounts, in game money etc will NOT be tolerated. \n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 8:{FFFFFF} Respect Admin's decision, his word is final. In case you don't agree with the administrators action, report it on forum.\n", sizeof(rules));
        strcat(rules, "{00FF22}Rule 9:{FFFFFF} No Driver Drive By! Due to a lot of players seeming to annoy others with Drive By, we decided to put a rule against it!\n", sizeof(rules));
		ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, "Rules", rules, "Agree", "Disagree");
	}
	return 1;
}

CMD:ranks(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new ranks[1024];
	    strcat(ranks, "{00FF22}Newbie(1):{FFFFFF} 0-100 EXP - no bonus. \n", sizeof(ranks));
        strcat(ranks, "{00FF22}Outsider(2):{FFFFFF} 100-300 EXP - 5 Armour on Spawn\n", sizeof(ranks));
        strcat(ranks, "{00FF22}Small Time(3):{FFFFFF} 300 - 600 EXP - 10 Armour on Spawn\n", sizeof(ranks));
        strcat(ranks, "{00FF22}Crook(4):{FFFFFF} 600 - 900 EXP - 15 Armour on Spawn\n", sizeof(ranks));
        strcat(ranks, "{00FF22}Side Man(5):{FFFFFF} 900 - 1300 EXP - 25 Armour on Spawn\n", sizeof(ranks));
        strcat(ranks, "{00FF22}Gangster(6):{FFFFFF} 1300 - 2000 EXP - 35 Armour on Spawn\n", sizeof(ranks));
		strcat(ranks, "{00FF22}OG(7):{FFFFFF} 2000 - 3000 EXP - 45 Armour on Spawn \n", sizeof(ranks));
        strcat(ranks, "{00FF22}Big Time(8):{FFFFFF} 3000 - 4300 EXP - 60 Armour on Spawn\n", sizeof(ranks));
        strcat(ranks, "{00FF22}BadAss(9):{FFFFFF} 4300 - 6000 EXP - 75 Armour on Spawn\n", sizeof(ranks));
        strcat(ranks, "{00FF22}Master(10):{FFFFFF} 6000 - 8500 EXP - 90 Armour on Spawn\n", sizeof(ranks));
        strcat(ranks, "{00FF22}GodFather(11):{FFFFFF} 8500 - 12000 EXP - 100 Armour on Spawn - Combat Shotgun\n", sizeof(ranks));
        strcat(ranks, "{00FF22}KingPin(12):{FFFFFF} 12000+ EXP - 100 Armour on Spawn - M4 - Combat Shotgun\n", sizeof(ranks));
		ShowPlayerDialog(playerid, DIALOG_RANKS, DIALOG_STYLE_MSGBOX, "Ranks", ranks, "Okay", "");
	}
	return 1;
}

CMD:cmds(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new cmds[1024];
	    strcat(cmds, "{00FF22}/help{FFFFFF} - Opens the help dialog.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/rules{FFFFFF} - Opens the rules dialog.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/ranks{FFFFFF} - Opens the ranks dialog.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/credits{FFFFFF} - Opens the credits dialog.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/shop{FFFFFF} - Opens the shop menu.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/stats{FFFFFF} - Opens the stats dialog.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/updates{FFFFFF} - Opens the updates dialog.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/pm{FFFFFF} - Sends a private message to a player.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/report{FFFFFF} - Sends a report to online Administrators.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/radio{FFFFFF} - Opens the radio dialog.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/radiooff{FFFFFF} - Stops your current radio stream.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/admins{FFFFFF} - Shows online admins.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/tc{FFFFFF} - Sends a message to your team.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/clans{FFFFFF} - Shows a list of the official clans.\n", sizeof(cmds));
		ShowPlayerDialog(playerid, DIALOG_CMDS, DIALOG_STYLE_MSGBOX, "Commands", cmds, "Okay", "");
    }
    return 1;
}

CMD:ccmds(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new cmds[1024];
		if(PlayerInfo[playerid][pClan] == 0) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		strcat(cmds, "{00FF22}/cmembers{FFFFFF} - Shows all online Clan members.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/c{FFFFFF} - Sends a message to other online clan members.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/cquit{FFFFFF} - Quits your current clan.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/crank{FFFFFF} - Sets player's clan rank.\n", sizeof(cmds));
	    strcat(cmds, "{00FF22}/cedit{FFFFFF} - Opens the Clan Edit dialog.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/cinvite{FFFFFF} - Invites a member to the clan.\n", sizeof(cmds));
		strcat(cmds, "{00FF22}/ckick{FFFFFF} - Kicks a player out of the clan.\n", sizeof(cmds));
		ShowPlayerDialog(playerid, DIALOG_CCMDS, DIALOG_STYLE_MSGBOX, "Clan Commands", cmds, "Okay", "");
    }
    return 1;
}

CMD:stats(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    ShowStatsForPlayer(playerid, playerid);
	}
	return 1;
}


CMD:updates(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
		new updates[1024];
        strcat(updates, "{FFFFFF}v1.0.15:\n\n", sizeof(updates));
        strcat(updates, "- Fixed anti cheat getting called when player uses vending.\n", sizeof(updates));
        strcat(updates, "- Added new map at Market Station.\n", sizeof(updates));
        strcat(updates, "- Added /vnos for gold VIP.\n", sizeof(updates));
        strcat(updates, "- Fixed Aztecas color being gray if in clan.\n\n", sizeof(updates));
		strcat(updates, "{FFFFFF}v1.0.14:\n\n", sizeof(updates));
        strcat(updates, "- Added /shop for Police.\n", sizeof(updates));
        strcat(updates, "- Added $ icon for Money at /stats.\n", sizeof(updates));
        strcat(updates, "- Added ability for clan leaders to change their clan weapons.\n", sizeof(updates));
        strcat(updates, "- Updated Anti Cheat now checking money.\n", sizeof(updates));
        strcat(updates, "- Added /givemoney command.\n\n", sizeof(updates));
		strcat(updates, "{FFFFFF}v1.0.13:\n\n", sizeof(updates));
        strcat(updates, "- Re wrote the script from Y_Ini to MySql.\n", sizeof(updates));
        strcat(updates, "- Added losing money when you die.\n", sizeof(updates));
        strcat(updates, "- Changed spawn weapons.\n", sizeof(updates));
        strcat(updates, "- Updated radio links and added Hot 108 Jamz.\n", sizeof(updates));
        strcat(updates, "- Updated Clan System a bit (bug fixing).\n", sizeof(updates));
        strcat(updates, "- Fully re wrote gang zone system.\n", sizeof(updates));
        strcat(updates, "- Added Police team.\n\n", sizeof(updates));
		ShowPlayerDialog(playerid, DIALOG_UPDATES, DIALOG_STYLE_MSGBOX, "Updates", updates, "Okay", "");
	}
	return 1;
}

CMD:shop(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2, 2527.0146, -1663.9749, 15.1662))
		{
		    if(gTeam[playerid] == TEAM_GROVE)
		    {
		        ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, "Shop", "Chainsaw - 500$\nColt 45 - 1500$\nSilenced Pistol - 2000$\nDeagle - 3000$\nShotgun - 3500$\nSawn Off Shotgun - 4500$\nCombat Shotgun 8500$\nUzi - 3500$\nTec-9 - 3500$\nMP5 - 5500$\nAK-47 - 7500$\nM4 - 8000$\nSniper Rifle - 10000$\nGrenade - 2500$\nArmour - 1500$", "Buy", "Cancel");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} This shop belongs to Grove Street and can only be used by them.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2, 1872.0562, -2011.1937, 13.5469))
		{
		    if(gTeam[playerid] == TEAM_AZTECAS)
		    {
		        ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, "Shop", "Chainsaw - 500$\nColt 45 - 1500$\nSilenced Pistol - 2000$\nDeagle - 3000$\nShotgun - 3500$\nSawn Off Shotgun - 4500$\nCombat Shotgun 8500$\nUzi - 3500$\nTec-9 - 3500$\nMP5 - 5500$\nAK-47 - 7500$\nM4 - 8000$\nSniper Rifle - 10000$\nGrenade - 2500$\nArmour - 1500$", "Buy", "Cancel");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} This shop belongs to Aztecas and can only be used by them.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2, 2233.0354, -1180.0729, 25.8972))
		{
		    if(gTeam[playerid] == TEAM_BALLAS)
		    {
		        ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, "Shop", "Chainsaw - 500$\nColt 45 - 1500$\nSilenced Pistol - 2000$\nDeagle - 3000$\nShotgun - 3500$\nSawn Off Shotgun - 4500$\nCombat Shotgun 8500$\nUzi - 3500$\nTec-9 - 3500$\nMP5 - 5500$\nAK-47 - 7500$\nM4 - 8000$\nSniper Rifle - 10000$\nGrenade - 2500$\nArmour - 1500$", "Buy", "Cancel");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} This shop belongs to Ballas and can only be used by them.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2, 2808.0178, -1190.5220, 25.3437))
		{
		    if(gTeam[playerid] == TEAM_VAGOS)
		    {
		        ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, "Shop", "Chainsaw - 500$\nColt 45 - 1500$\nSilenced Pistol - 2000$\nDeagle - 3000$\nShotgun - 3500$\nSawn Off Shotgun - 4500$\nCombat Shotgun 8500$\nUzi - 3500$\nTec-9 - 3500$\nMP5 - 5500$\nAK-47 - 7500$\nM4 - 8000$\nSniper Rifle - 10000$\nGrenade - 2500$\nArmour - 1500$", "Buy", "Cancel");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} This shop belongs to Vagos and can only be used by them.");
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2, 1550.8929, -1669.9216, 13.5615))
		{
		    if(gTeam[playerid] == TEAM_POLICE)
		    {
		        ShowPlayerDialog(playerid, DIALOG_SHOP, DIALOG_STYLE_LIST, "Shop", "Chainsaw - 500$\nColt 45 - 1500$\nSilenced Pistol - 2000$\nDeagle - 3000$\nShotgun - 3500$\nSawn Off Shotgun - 4500$\nCombat Shotgun 8500$\nUzi - 3500$\nTec-9 - 3500$\nMP5 - 5500$\nAK-47 - 7500$\nM4 - 8000$\nSniper Rifle - 10000$\nGrenade - 2500$\nArmour - 1500$", "Buy", "Cancel");
			}
			else
			{
			    SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} This shop belongs to Police and can only be used by them.");
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You can't use that command here.");
		}
	}
	return 1;
}

CMD:acmds(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    if(PlayerInfo[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
			ShowPlayerDialog(playerid, DIALOG_ACMDS, DIALOG_STYLE_LIST, "Admin Commands", "Level 1", "Select", "Cancel");
		}
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
		    ShowPlayerDialog(playerid, DIALOG_ACMDS, DIALOG_STYLE_LIST, "Admin Commands", "Level 1\nLevel 2", "Select", "Cancel");
		}
		if(PlayerInfo[playerid][pAdmin] >= 3)
		{
		    ShowPlayerDialog(playerid, DIALOG_ACMDS, DIALOG_STYLE_LIST, "Admin Commands", "Level 1\nLevel 2\nLevel 3", "Select", "Cancel");
		}
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
		    ShowPlayerDialog(playerid, DIALOG_ACMDS, DIALOG_STYLE_LIST, "Admin Commands", "Level 1\nLevel 2\nLevel 3\nLevel 4", "Select", "Cancel");
		}
		if(PlayerInfo[playerid][pAdmin] >= 5)
		{
		    ShowPlayerDialog(playerid, DIALOG_ACMDS, DIALOG_STYLE_LIST, "Admin Commands", "Level 1\nLevel 2\nLevel 3\nLevel 4\nLevel 5", "Select", "Cancel");
		}
		if(PlayerInfo[playerid][pAdmin] >= 1337)
		{
		    ShowPlayerDialog(playerid, DIALOG_ACMDS, DIALOG_STYLE_LIST, "Admin Commands", "Level 1\nLevel 2\nLevel 3\nLevel 4\nLevel 5\nLevel 1337", "Select", "Cancel");
		}
		if(PlayerInfo[playerid][pAdmin] >= 1338)
		{
		    ShowPlayerDialog(playerid, DIALOG_ACMDS, DIALOG_STYLE_LIST, "Admin Commands", "Level 1\nLevel 2\nLevel 3\nLevel 4\nLevel 5\nLevel 1337\nLevel 1338", "Select", "Cancel");
		}
	}
	return 1;
}

CMD:tc(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128], text[128];
		if(sscanf(params,"s[128]", text)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /tc [message]");
		switch(gTeam[playerid])
		{
			case TEAM_GROVE:
			{
				format(string, sizeof(string), "{9C9C8A}TEAM:{FFFFFF} %s: %s", GetName(playerid), text);
				MessageToGrove(yellow, string);
			}
			case TEAM_BALLAS:
			{
			    format(string, sizeof(string), "{9C9C8A}TEAM:{FFFFFF} %s: %s", GetName(playerid), text);
				MessageToBallas(yellow, string);
			}
			case TEAM_VAGOS:
			{
			    format(string, sizeof(string), "{9C9C8A}TEAM:{FFFFFF} %s: %s", GetName(playerid), text);
				MessageToVagos(yellow, string);
			}
			case TEAM_AZTECAS:
			{
			    format(string, sizeof(string), "{9C9C8A}TEAM:{FFFFFF} %s: %s", GetName(playerid), text);
				MessageToAztecas(yellow, string);
			}
		}
	}
	return 1;
}

CMD:pm(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new targetid, message[128], string[128];
	    if(sscanf(params,"us[128]", targetid, message)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /pm [playerid] [message]");
	    if(targetid == playerid) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} PMing yourself is rather idiotic so you can't do that here.");
	    if(PlayerInfo[playerid][pPM] == 1) return SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have disabled PMs (/togpm to enable them).");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is not online.");
	    if(PlayerInfo[targetid][pPM] == 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player has disabled their PMs.");
	    if(strlen(message) < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Message is too short.");
	    if(strlen(message) > 100) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Message is too long.");
		format(string, sizeof(string), "PM from %s (ID: %d) to %s: %s", GetName(playerid), playerid, GetName(targetid), message);
	    SendClientMessage(targetid, yellow, string);
	    SendClientMessage(playerid, yellow, string);
	    Log("/ZTDM/Logs/pm.txt", string);
	}
    return 1;
}

CMD:togpm(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
		else if(PlayerInfo[playerid][pPM] == 1)
		{
			PlayerInfo[playerid][pPM] = 0;
			SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have enabled your PMs.");
		}
		else
		{
		    PlayerInfo[playerid][pPM] = 1;
			SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have disabled your PMs.");
		}
	}
	return 1;
}

CMD:vnos(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    if(PlayerInfo[playerid][pVip] < 3) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
	    else if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You need to be in an vehicle to use that command.");
	    else
	    {
	        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
	        SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully added NOS to your vehicle.");
	    }
	}
	return 1;
}

CMD:report(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128], targetid, report[100];
		if(sscanf(params,"us[128]", targetid, report)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /report [playerid] [report]");
		if(strlen(report) < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Report is too short.");
		if(strlen(report) > 100) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Report is too long.");
        if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		format(string, sizeof(string), "REPORT:{FFFFFF} %s reported %s (%d)", GetName(playerid), GetName(targetid), targetid);
        MessageToAdmins(yellow, string);
		format(string, sizeof(string), "REASON:{FFFFFF} %s", report);
		MessageToAdmins(yellow, string);
		SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} Your report has been successfully sent to online Administrators.");
	}
	return 1;
}

CMD:radio(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST, "Radio Stream", "181.FM - Power 181\nDEFJAY.COM - R&B\nRock 181.FM\n181.FM - Kickin' Country\n181.FM - Awesome 80s\nHot 108 Jamz", "Select", "Cancel");
	}
	return 1;
}

CMD:radiooff(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    StopAudioStreamForPlayer(playerid);
	}
	return 1;
}

CMD:radioff(playerid, params[]) return cmd_radiooff(playerid, params);

CMD:gmx(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    if(PlayerInfo[playerid][pAdmin] < 1338) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
	    GMX();
	    SendRconCommand("gmx");
	}
	return 1;
}

CMD:admins(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new str[128];
		SendClientMessage(playerid, yellow, "-------------------------");
		SendClientMessage(playerid, -1, "Online Admins:");
		for(new i = 0; i < MAX_PLAYERS; i++)
	    {
			if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] >= 1)
			{
	            format(str, sizeof(str), "%s %s", AdminLevelName(i), GetName(i));
	            SendClientMessage(playerid, -1, str);
	        }
	    }
	    SendClientMessage(playerid, yellow, "-------------------------");
	}
    return 1;
}

CMD:vip(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You are not authorized to use that command.");
		if(PlayerInfo[playerid][pVip] >= 1)
		{
		    ShowPlayerDialog(playerid, DIALOG_VIP, DIALOG_STYLE_LIST, "VIP Menu", "VIP Color\nToggle PMs", "Select", "Cancel");
		}
		if(PlayerInfo[playerid][pVip] >= 2)
		{
	 		ShowPlayerDialog(playerid, DIALOG_VIP, DIALOG_STYLE_LIST, "VIP Menu", "VIP Color\nToggle PMs\nReset Stats", "Select", "Cancel");
	 	}
	 	if(PlayerInfo[playerid][pVip] >= 3)
		{
	 		ShowPlayerDialog(playerid, DIALOG_VIP, DIALOG_STYLE_LIST, "VIP Menu", "VIP Color\nToggle PMs\nReset Stats", "Select", "Cancel");
	 	}
	 	if(PlayerInfo[playerid][pVip] >= 4)
		{
	 		ShowPlayerDialog(playerid, DIALOG_VIP, DIALOG_STYLE_LIST, "VIP Menu", "VIP Color\nToggle PMs\nReset Stats", "Select", "Cancel");
	 	}
	}
	return 1;
}

CMD:vc(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128], text[128];
		if(PlayerInfo[playerid][pVip] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params,"s[128]", text)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /vc [message]");
		format(string, sizeof(string), "{FFD700}VIP CHAT:{9C9C8A} %s: %s", GetName(playerid), text);
		MessageToVip(yellow, string);
	}
	return 1;
}

CMD:cedit(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    if(PlayerInfo[playerid][pClan] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(PlayerInfo[playerid][pClRank] < 5) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    ShowPlayerDialog(playerid, DIALOG_CLAN, DIALOG_STYLE_LIST, "Clan Editing", "Clan Name\nClan MOTD\nRank 1 Name\nRank 2 Name\nRank 3 Name\nRank 4 Name\nRank 5 Name\nRank 6 Name\nClan Skin\nMelee Weapon\nPistol Weapon\nWeapon 3\nWeapon 4", "Select", "Cancel");
	}
	return 1;
}

CMD:crank(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new targetid, rank, string[128];
	    if(PlayerInfo[playerid][pClan] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(PlayerInfo[playerid][pClRank] < 5) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "ud", targetid, rank)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /crank [playerid] [rank]");
	    if(playerid == targetid) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Want to change your own rank? How about no.");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		if(PlayerInfo[playerid][pClan] != PlayerInfo[targetid][pClan]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't in your clan.");
		if(PlayerInfo[playerid][pClRank] <= PlayerInfo[targetid][pClRank]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is same or higher rank than you.");
	    PlayerInfo[targetid][pClRank] = rank;
	    format(string, sizeof(string), "INFO:{FFFFFF} You have succesfully set %s's rank to %d.", GetName(targetid), rank);
	    SendClientMessage(playerid, COLOR_GREY, string);
	    format(string, sizeof(string), "CLAN:{FFFFFF} %s has set your rank to %d.", GetName(playerid), rank);
	    SendClientMessage(playerid, greenyellow, string);
	}
	return 1;
}

CMD:cquit(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128];
	    if(PlayerInfo[playerid][pClan] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(PlayerInfo[playerid][pClLeader] == 1)
	    {
   			format(ClanInfo[PlayerInfo[playerid][pClan]-1][cLeader], 24, "Nobody");
			ClanInfo[PlayerInfo[playerid][pClan]-1][cMembers]--;
   			PlayerInfo[playerid][pClan] = 0;
   			PlayerInfo[playerid][pClLeader] = 0;
            SaveClan(PlayerInfo[playerid][pClan]-1);
   			SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully quit your clan.");
			format(string, sizeof(string), "CL-QUIT:{FFFFFF} %s has quit the clan.", GetName(playerid));
			SendClanMessage(playerid, greenyellow, string);
		}
   		else
		{
            ClanInfo[PlayerInfo[playerid][pClan]-1][cMembers]--;
			PlayerInfo[playerid][pClan] = 0;
			SaveClan(PlayerInfo[playerid][pClan]-1);
		    SendClientMessage(playerid, COLOR_GREY, "INFO:{FFFFFF} You have successfully quit your clan.");
            format(string, sizeof(string), "CL-QUIT:{FFFFFF} %s has quit the clan.", GetName(playerid));
			SendClanMessage(playerid, greenyellow, string);
		}
	}
	return 1;
}

CMD:c(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
		new string[128], message[128];
		if(PlayerInfo[playerid][pClan] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		if(sscanf(params, "s[128]", message)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /c [message]");
        if(strlen(message) < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Message is too short.");
	    if(strlen(message) > 100) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Message is too long.");
		format(string, sizeof(string), "CL-CHAT:{FFFFFF} %s: %s", GetName(playerid), message);
		SendClanMessage(playerid, greenyellow, string);
	}
	return 1;
}

CMD:cmembers(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128];
		if(PlayerInfo[playerid][pClan] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
		SendClientMessage(playerid, yellow, "Online clan members:");
		for(new i = 0; i < MAX_PLAYERS; i++)
    	{
			if(IsPlayerConnected(i) && PlayerInfo[playerid][pClan] == PlayerInfo[i][pClan])
			{
            	format(string, sizeof(string), "%s, Rank: %s.", GetName(i), GetClRankName(i));
            	SendClientMessage(playerid, -1, string);
            }
        }
        SendClientMessage(playerid, yellow, "-----------------------");
    }
    return 1;
}

CMD:cinvite(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new string[128], targetid;
	    if(PlayerInfo[playerid][pClan] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(PlayerInfo[playerid][pClRank] < 5) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /cinvite [playerid]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
	    PlayerInfo[targetid][pInvited] = PlayerInfo[playerid][pClan];
	    format(string, sizeof(string), "CL-INVITE:{FFFFFF} You have been invited to join clan ID %d by %s, type /caccept to accept.", PlayerInfo[playerid][pClan], GetName(playerid));
	    SendClientMessage(targetid, greenyellow, string);
	    format(string, sizeof(string), "INFO:{FFFFFF} You have successfully invited %s to join your clan.", GetName(targetid));
	    SendClientMessage(playerid, COLOR_GREY, string);
	}
	return 1;
}

CMD:ckick(playerid, params[])
{
    if(Logged[playerid] == 1)
	{
	    new string[128], targetid;
	    if(PlayerInfo[playerid][pClan] < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(PlayerInfo[playerid][pClRank] < 5) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You aren't authorized to use that command.");
	    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /ckick [playerid]");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
	    if(PlayerInfo[playerid][pClan] != PlayerInfo[targetid][pClan]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't a member of your clan.");
        if(PlayerInfo[targetid][pClan] > PlayerInfo[playerid][pClan]) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player is higher ranked than you.");
		PlayerInfo[targetid][pClan] = 0;
		PlayerInfo[targetid][pClRank] = 0;
		ClanInfo[PlayerInfo[playerid][pClan]-1][cMembers]--;
		SaveClan(PlayerInfo[playerid][pClan]-1);
		format(string, sizeof(string), "CL-KICK:{FFFFFF} %s has kicked %s out of the clan.", GetName(playerid), GetName(targetid));
		SendClanMessage(playerid, greenyellow, string);
		format(string, sizeof(string), "INFO:{FFFFFF} You have been kicked out of the clan by %s.", GetName(playerid));
		SendClientMessage(playerid, COLOR_GREY, string);
		format(string, sizeof(string), "INFO:{FFFFFF} You have successfully kicked %s out of the clan.", GetName(targetid));
		SendClientMessage(playerid, COLOR_GREY, string);
	}
	return 1;
}
		

CMD:caccept(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new string[128];
		if(PlayerInfo[playerid][pInvited] == 0) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You haven't been invited to join a clan.");
		PlayerInfo[playerid][pClan] = PlayerInfo[playerid][pInvited];
		PlayerInfo[playerid][pClRank] = 1;
		ClanInfo[PlayerInfo[playerid][pInvited]-1][cMembers]++;
		format(string, sizeof(string), "INFO:{FFFFFF} You have accepted the invitation to clan ID %d.", PlayerInfo[playerid][pInvited]);
		SendClientMessage(playerid, COLOR_GREY, string);
		format(string, sizeof(string), "CL-MSG:{FFFFFF} %s has joined the clan.", GetName(playerid));
		SendClanMessage(playerid, greenyellow, string);
		PlayerInfo[playerid][pInvited] = 0;
	}
	return 1;
}

CMD:clans(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		new str[128];
		SendClientMessage(playerid, yellow, "----------------------------------------------------------------------------------------------------------");
		for(new i = 0; i < MAX_CLANS; i++)
	    {
	        format(str, sizeof(str), "Clan Name: %s, Leader: %s, Members: %d.", ClanInfo[i][cName], ClanInfo[i][cLeader], ClanInfo[i][cMembers]);
	        SendClientMessage(playerid, -1, str);
	    }
	    SendClientMessage(playerid, yellow, "----------------------------------------------------------------------------------------------------------");
	}
	return 1;
}

CMD:piss(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
		SetPlayerSpecialAction(playerid, 68);
		SendClientMessage(playerid, orange, "ANIM:{FFFFFF} Type /stopanim to stop the animation.");
	}
	return 1;
}

CMD:wank(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 1, 0, 1);
        SendClientMessage(playerid, orange, "ANIM:{FFFFFF} Type /stopanim to stop the animation.");
	}
	return 1;
}

CMD:wave(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 1, 0, 1);
	    SendClientMessage(playerid, orange, "ANIM:{FFFFFF} Type /stopanim to stop the animation.");
	}
	return 1;
}

CMD:stopanim(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    ClearAnimations(playerid);
	    SendClientMessage(playerid, orange, "ANIM:{FFFFFF} Animation stopped.");
	}
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(Logged[playerid] == 1)
	{
	    new targetid, amount, string[128];
	    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE:{FFFFFF} /givemoney [playerid] [amount]");
		else if(amount < 1) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Amount can't be less than 1.");
		else if(PlayerInfo[playerid][pMoney] < amount) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} You don't have that much money.");
	    else if(targetid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} That player isn't online.");
		else if(targetid == playerid) return SendClientMessage(playerid, COLOR_RED, "ERROR:{FFFFFF} Giving money to yourself? How about no?");
		else
	    {
			GivePlayerMoney(playerid, -amount);
			PlayerInfo[playerid][pMoney] -= amount;
			GivePlayerMoney(targetid, amount);
			PlayerInfo[targetid][pMoney] += amount;
			format(string, sizeof(string), "INFO:{FFFFFF} You gave %s %d$.", GetName(targetid), amount);
			SendClientMessage(playerid, COLOR_GREY, string);
			format(string, sizeof(string), "INFO:{FFFFFF} %s has gave you %d$.", GetName(playerid), amount);
			SendClientMessage(targetid, COLOR_GREY, string);
		}
	}
	return 1;
}

AntiDeAMX()
{
	new antidamx[][] =
	{
		"Unarmed (Fist)",
		"Brass K",
		"Fire Ex"
	};
    #pragma unused antidamx
}
