-- Space Explorers. Gamemode made by The HellBox.
-- Use the code as you want, just don't forget that orginally gamemode was made by me.
-- If you want to contribute, feel free. But if you want to change something(Not just bug fixing), contact with me before pull request [thehellbox11@gmail.com]

-- About comments, I made them AFTER I wrote all the code, so they can be wrong in some places

--resource.AddWorkshop( "1590745371" )

space_explorers = {}

-- Init all NetWorkStrings
util.AddNetworkString( "se_change_module_ui" )
util.AddNetworkString( "se_choose_race" )
util.AddNetworkString( "se_race_choosen" )
util.AddNetworkString( "se_charge_drive" )
util.AddNetworkString( "se_try_jump" )
util.AddNetworkString( "se_event_simple" )
util.AddNetworkString( "se_terminal_start_type" )
util.AddNetworkString( "se_terminal_send_input" )
util.AddNetworkString( "se_terminal_println" )
util.AddNetworkString( "se_terminal_print" )
util.AddNetworkString( "se_terminal_clear" )
util.AddNetworkString( "se_terminal_changeline" )
util.AddNetworkString( "se_wear_suit" )
util.AddNetworkString( "se_open_scoreboard" )
util.AddNetworkString( "se_skill_update" )
util.AddNetworkString( "se_update_space_body" )
util.AddNetworkString( "se_update_enemy_sprite" )
util.AddNetworkString( "se_open_npc_shop" )
util.AddNetworkString( "se_buy_item" )
util.AddNetworkString( "se_open_pilot_camera" )
util.AddNetworkString( "se_update_ship_pos" )
util.AddNetworkString( "se_update_ship_angle" )
util.AddNetworkString( "se_choose_star" )
util.AddNetworkString( "se_jump_to_next_sector" )
util.AddNetworkString( "se_open_fractions_npc" )
util.AddNetworkString( "se_change_fraction" )
util.AddNetworkString( "se_take_mission" )
util.AddNetworkString( "se_update_enemy_state" )
util.AddNetworkString( "se_send_ship_state" )
util.AddNetworkString( "se_send_planet_info" )
util.AddNetworkString( "se_change_lang" )
util.AddNetworkString( "se_make_captain" )
util.AddNetworkString( "se_game_losed" )
util.AddNetworkString( "se_load_game" )
util.AddNetworkString( "se_save_game" )
util.AddNetworkString( "se_enable_shopping" )

-- Include libs
include("lib/name_gen.lua")
include("lib/races.lua")
include("lib/draw.lua")
include("lib/player_lib.lua")
include("lib/events_simple.lua")
include("lib/support.lua")

-- Include base
include("base/se_settings.lua")
include("base/se_lang.lua")
include("base/se_lang_ru.lua")
include("base/skills.lua")
include("base/weapons.lua")
include("base/ship.lua")
include("base/races.lua")
include("base/enemy_ships.lua")
include("base/communication_options.lua")
include("base/terminal_commands.lua")
include("base/planets.lua")
include("base/shop_npc.lua")
include("base/star_map.lua")
include("base/fractions.lua")

-- AddCSLuaFile(Make client download all client side scripts)
AddCSLuaFile("base/client/ship_state_update.lua")
AddCSLuaFile("base/client/race_choose_menu.lua")
AddCSLuaFile("base/client/ship_uis.lua")
AddCSLuaFile("base/client/draw_space_body.lua")
AddCSLuaFile("base/client/hud.lua")
AddCSLuaFile("base/client/shop_npc.lua")
AddCSLuaFile("base/client/fractions_ui.lua")
AddCSLuaFile("base/client/scoreboard.lua")
AddCSLuaFile("base/client/lose_menu.lua")
AddCSLuaFile("lib/support.lua")
AddCSLuaFile("lib/draw.lua")

function GM:PlayerSpawn( ply )
  ply:SetTeam(123)
  ply.on_planet = false
  ply.race = "Humans"
  ply:SetModel("models/player/kleiner.mdl")
  ply:WearSuit(false)
  ply:ChooseRace()
  ply:SetNoCollideWithTeammates(true)
  for k, v in pairs(player.GetAll()) do
     v:ChatPrint( ply:Nick() .. " has spawned!" )
  end

  local hands = ents.Create( "gmod_hands" )
  if ( IsValid( hands ) ) then
      hands:DoSetup( ply )
      hands:Spawn()
  end
  if player.GetCount() == 1 then
    ply:SetNWBool("se_is_сaptain", true)
    ply:SetNWBool("se_shopping_enabled", true)
    ply.is_captain = true
    ply.shopping_enabled = true
  end
end

function GM:PlayerInitialSpawn( ply )
  -- There we just print some info about gamemode and doSetCustomCollisionCheck(For disabling collision) and SetupSkills(lib/player_lib.lua)
  ply:SetCustomCollisionCheck(true)
  ply:SetupSkills()
  ply:ChatPrint("---------------------------------------------------")
  ply:ChatPrint("Space Explorers. Gamemode made by The HellBox")
  ply:ChatPrint("Special thanks to: ")
  ply:ChatPrint("-    Niteko - for creation of map prototype")
  ply:ChatPrint("-    Klark - for help with translation")
  ply:ChatPrint("---------------------------------------------------")
end

function GM:Initialize()
  se_init_comms()
  -- I don't remember why I made custom team for players, but I don't want to break anything
  team.SetUp( 123, "Players", Color( 255, 0, 0 ) )
end

function GM:InitPostEntity()
  -- Generating star map
  se_gen_star_map()
  -- Initialiazing players spaceship
  se_init_ship()
  -- Initialiazing teleports on the planets
  se_init_teleports()
  -- Init fractions
  se_init_fractions()
  -- Create timer for ship update
  timer.Create("se_ship_update", 1, 0, se_ship_update)
end

function GM:Think()
  -- Reset timer if something fails
  if !timer.Exists("se_ship_update") then
    timer.Create("se_ship_update", 1, 0, se_ship_update)
  end
end

hook.Add("ShouldCollide","se_nocollide_player",function(a,b)
  -- Disable collision and damage
  if a:IsPlayer() and b:IsPlayer() then
    return false
  end
  if a:IsNPC() and b:IsNPC() then
    return false
  end
end)

function se_change_lang(lang)
  print("Language has been changed to "..lang)
  se_settings.language = lang
  se_init_comms()
end

net.Receive("se_change_lang", function(_, ply)
  local lang = net.ReadString()
  if !ply.is_captain then ply:ChatPrint("Only captain can change language") return end
  if se_language[lang] != nil then
    se_change_lang(lang)
  end
end)

net.Receive("se_load_game", function(_, ply)
  if !ply.is_captain then ply:ChatPrint("Only captain can load game") return end
  se_load_game()
end)
net.Receive("se_save_game", function(_, ply)
  if !ply.is_captain then ply:ChatPrint("Only captain can save game") return end
  se_save_game()
end)
net.Receive("se_enable_shopping", function(_, ply)
  local pl = net.ReadEntity()
  local enabled = net.ReadBool()
  if !ply.is_captain then ply:ChatPrint("Only captain can do this") return end
  pl:SetNWBool("se_shopping_enabled", enabled)
  pl.shopping_enabled = enabled
end)

net.Receive("se_make_captain", function(_, ply)
  local new_captain = net.ReadEntity()
  if IsValid(new_captain) and new_captain:IsPlayer() and ply.is_captain then
    ply:SetNWBool("se_is_сaptain", false)
    ply.is_captain = false

    new_captain:SetNWBool("se_is_сaptain", true)
    new_captain.is_captain = true
  end
end)
