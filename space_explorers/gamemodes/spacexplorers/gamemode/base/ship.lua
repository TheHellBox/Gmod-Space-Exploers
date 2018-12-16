se_asteroids_aabb = {100, 100}

function se_init_ship()
  se_curret_comm = ""
  se_comm_done = false
  se_is_planet = false
  se_global_jumps = 0
  se_global_explored = 0
  se_global_sectors = 0
  se_fraction = "Federation"
  se_curret_planet = Vector(0, 0, 0)
  -- Корабль игрока. Синхронизация происходит каждую секунду
  players_spaceship = {
    name = "Random Ship",
    system_name = "Solar System",
    health = 100,
    shields = 100,
    fuel = 10,
    credits = 0,
    max_health = 100,
    max_shields = 100,
    shield_reg_mod = 0,
    drive_charge = 0,
    oxygen  = 100,
    star_pos = 1,
    pos = Vector(),
    ang = Angle(),
    virtual_speed = 0,
    virtual_angles = Angle(),
    speed = 0,
    angle_speed = Angle(),
    modules = {
      Weapons = {
        name = "Weapons",
        health = 100,
        pos = Vector(-716, -1128, 32),
        angle = Angle(0, 90, 0),
        weapons = {
          table.Copy(se_weapons.EnergyBlaster),
          table.Copy(se_weapons.SimpleMissle)
        },
      },
      Pilot = {
        name = "Pilot",
        health = 100,
        pos = Vector(-64, -792, 32),
        angle = Angle(0, -90, 0)
      },
      HyperDrive = {
        name = "Hyper Drive",
        health = 100,
        pos = Vector(-1522, -1128, 32),
        angle = Angle(0, 90, 0)
      },
      Teleport = {
        name = "Teleport",
        health = 100,
        pos = Vector(-1896, -895, 32),
        angle = Angle(0, 0, 0)
      },
      LifeSupport = {
        name = "Life Support",
        health = 100,
        pos = Vector(-1128, -580, 32),
        angle = Angle(0, 0, 0)
      },
      Shields = {
        name = "Shields",
        health = 100,
        pos = Vector(-716, -664, 32),
        angle = Angle(0, -90, 0)
      },
      Communication = {
        name = "Communication",
        health = 100,
        pos = Vector(-63, -1000, 32),
        angle = Angle(0, 90, 0),
      },
    }
  }
  space_explorers_spawn_modules()
end

sound.Add( {
	name = "se_drive_charge_sound",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "ambient/energy/force_field_loop1.wav"
} )

function se_game_losed()
  net.Start("se_game_losed")
  net.WriteTable({
    jumps = se_global_jumps,
    sectors = se_global_sectors,
    explored = se_global_explored
  })
  net.Broadcast()
  se_init_ship()
  timer.Simple(30, function()
    RunConsoleCommand("changelevel", "se_spaceship")
  end)
end

-- Old unused functional from piloting
function se_update_ship_pos(pos)
  players_spaceship.pos = pos
  net.Start("se_update_ship_pos")
  net.WriteVector(pos)
  net.Broadcast()
end
-- Old unused functional from piloting
function se_update_ship_angle(ang)
  players_spaceship.ang = ang
  net.Start("se_update_ship_angle")
  net.WriteAngle(ang)
  net.Broadcast()
end

function se_save_game()
  local ship_str = util.TableToJSON(players_spaceship)
  file.Write("se_save1.txt", ship_str)
end

function se_load_game()
  if !file.Exists( "se_save1.txt", "DATA" ) then return end
  local ship_save = file.Read( "se_save1.txt", "DATA" )
  local ship_load = util.JSONToTable( ship_save )
  if ship_load != nil then
    players_spaceship.health = ship_load.health
    players_spaceship.max_health = ship_load.max_health
    players_spaceship.max_shields = ship_load.max_shields
    players_spaceship.modules.Weapons.weapons = ship_load.modules.Weapons.weapons
    players_spaceship.shield_reg_mod = ship_load.shield_reg_mod
    players_spaceship.credits = ship_load.credits
  end
end

-- Old unused functional from piloting
function se_add_ship_pos (pos)
  players_spaceship.pos:Add(pos)
  se_update_ship_pos(players_spaceship.pos)
end
-- Old unused functional from piloting
function se_add_ship_angle (ang)
  players_spaceship.ang:RotateAroundAxis(ang:Up(),ang[1])
  players_spaceship.ang:RotateAroundAxis(ang:Right(),ang[2])
  players_spaceship.ang:RotateAroundAxis(ang:Forward(),ang[3])
  players_spaceship.ang:Normalize()
  se_update_ship_angle(players_spaceship.ang)
end

-- Main update function
function se_ship_update()
  if !players_spaceship then return end
  se_update_enemy_spaceship()
  -- Check shields HP
  if players_spaceship.modules.Shields.health > 50 and players_spaceship.modules.Shields.ent.enabled then
    if players_spaceship.shields < players_spaceship.max_shields then
      players_spaceship.shields = players_spaceship.shields + 3 + players_spaceship.shield_reg_mod
    else
      players_spaceship.shields = players_spaceship.max_shields
    end
  end
  -- Checks oxygen, if there is not enough of it make player take damage
  for k, v in pairs(player.GetAll()) do
    if players_spaceship.oxygen < 40 or (!v:GetPos():WithinAABox(  Vector(506, -1946, 723), Vector(-2667, -173, -229) ) and !se_curret_planet.air) then
      if v.race != "Robots" then
        if !v.in_suit then
          v:TakeDamage( 2, v, v )
          v:EmitSound("hl1/fvox/warning.wav")
          v:ChatPrint("Warning! Low oxygen level!")
        end
      end
    end
  end
  -- Charging weapons
  for k, v in pairs(players_spaceship.modules.Weapons.weapons) do
    if v.Charge < v.MaxCharge then
      v.Charge = v.Charge + 2
    end
  end
  -- Turn terminal off if HP is too small, I think better to move it to entity itself
  for k, v in pairs(players_spaceship.modules) do
    if v.health < 50 then
      if v.ent.enabled then
        v.ent:PrintLn("Terminal health is low, please repair terminal")
        v.ent.enabled = false
      end
    end
  end
  -- If LifeSupport is damaged, turn off oxygen generation
  if players_spaceship.modules.LifeSupport.health < 70 or !players_spaceship.modules.LifeSupport.ent.enabled then
    if players_spaceship.oxygen > 0 then
      players_spaceship.oxygen = players_spaceship.oxygen - 2
    else
      players_spaceship.oxygen = 0
    end
  else
    if players_spaceship.oxygen < 100 then
      players_spaceship.oxygen = players_spaceship.oxygen + 4
    else
      players_spaceship.oxygen = 100
    end
  end
  -- Destroy ship if hp is too low
  if players_spaceship.health <= 0 then
    se_game_losed()
  end
  se_send_ship_state()
end

function se_ship_ignite_random_module()
  local module = table.Random(players_spaceship.modules)
  module.ent:Ignite( 10, 250 )
end

function se_send_ship_state()
  local se_ship_state = {
    health  = math.floor(players_spaceship.health),
    shields = math.floor(players_spaceship.shields),
    oxygen  = math.floor(players_spaceship.oxygen),
    drive_charge  = math.floor(players_spaceship.drive_charge),
    max_hp  = math.floor(players_spaceship.max_health),
    max_sh  = math.floor(players_spaceship.max_shields),
    modules = {},
    weapons = {}
  }
  for k, v in pairs(players_spaceship.modules) do
    se_ship_state.modules[k] = math.floor(v.health)
  end
  for k, v in pairs(players_spaceship.modules.Weapons.weapons) do
    se_ship_state.weapons[k] = {math.floor(v.Charge), v.MaxCharge, v.Name}
  end
  net.Start("se_send_ship_state")
  net.WriteTable(se_ship_state)
  net.Broadcast()
end

-- Ship's modules spawn
function space_explorers_spawn_modules()
  for k, v in pairs( ents.FindByClass( "se_terminal" ) ) do
     v:Remove()
  end
  for k, v in pairs( ents.FindByClass( "se_spacesuit" ) ) do
     v:Remove()
  end
  for k, v in pairs(players_spaceship.modules) do
    local terminal = ents.Create("se_terminal")
    terminal:SetPos( v.pos )
    terminal:SetAngles( v.angle )
    terminal:Spawn()
    terminal.ModuleName = k
    terminal.enabled = true
    v.ent = terminal
    v.ent:SetNWString("se_terminal_name", v.name)
  end
  for k=1,3 do
    local suit = ents.Create("se_spacesuit")
    suit:SetPos( Vector(-1718 + k * 80, -664, 32) )
    suit:SetAngles( Angle(0, -90, 0) )
    suit:Spawn()
  end
end

-- Drive charging
function se_charge_drive()
  local charge_rate = 10
  if enemy_spaceship and enemy_spaceship.valid then
    charge_rate = 1
  else
    charge_rate = 10
  end
  players_spaceship.modules.HyperDrive.ent:StopSound("se_drive_charge_sound")
  players_spaceship.modules.HyperDrive.ent:EmitSound("se_drive_charge_sound")
  timer.Create("se_charge_drive_timer", 1, 0, function()
    if players_spaceship.modules.HyperDrive.ent.enabled then
      if players_spaceship.drive_charge < 100 then
        players_spaceship.drive_charge = players_spaceship.drive_charge + charge_rate
      else
        timer.Stop("se_charge_drive_timer")
        players_spaceship.drive_charge = 100
        players_spaceship.modules.HyperDrive.ent:StopSound("se_drive_charge_sound")
      end
    end
  end)
end

-- Jump, big and ugly function
function se_try_jump()
  if players_spaceship.drive_charge >= 100 and players_spaceship.fuel > 0 then
    if se_star_map.star_choosed != -1 then
      se_star_map.player_pos = se_star_map.star_choosed
      se_star_map.star_choosed = -1
    else
      players_spaceship.modules.Pilot.ent:PrintLn("Please choose destination(Press TAB and press 'Open Map' button)")
      return
    end
    local star = se_star_map.stars[se_star_map.player_pos]
    se_remove_planet_model()
    se_comm_done = false
    players_spaceship.fuel = players_spaceship.fuel - 1
    players_spaceship.drive_charge = 0
    players_spaceship.system_name = se_gen_system_name()
    players_spaceship.pos = Vector()
    players_spaceship.ang = Angle()
    se_update_enemy_sprite(false, 0, 0)
    if enemy_spaceship then enemy_spaceship.valid = false end
    local comm_enabled = math.random( 1, 8 ) > 2 and !star.explored
    if comm_enabled then
      local talent_points = math.random( 1, 8 ) > 5
      if talent_points then
        for k, v in pairs(player.GetAll()) do
          v:GiveTalentPoints(1)
        end
      end
      se_random_comm(star)
    end
    local planet = math.random( 1, 8 ) > 5
    if planet then
      se_create_planet_model()
    end
    if star.type == "Station" then
      se_create_planet_model("Station")
    end
    if star.type == "Mission" then
      se_award_for_mission()
    end

    if !star.explored and se_fractions.MoneyForExploring then
      players_spaceship.credits = players_spaceship.credits + 2
      players_spaceship.modules.Communication.ent:PrintLn("+2 credits for exploring system")
    end

    se_global_jumps = se_global_jumps + 1
    if !star.explored then
      se_global_explored = se_global_explored + 1
    end

    se_star_map.stars[se_star_map.player_pos].explored = true
    players_spaceship.modules.Pilot.ent:EmitSound("ambient/machines/teleport3.wav")
  end
end
