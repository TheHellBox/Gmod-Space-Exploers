-- A lot of code there is shit, but it works and I'm too lazy to make it better

-- Prints help
function se_terminal_help(ent, args)
  for k, v in pairs(se_terminal_commands) do
    if v.help then
      local allow_print = true
      if v.module and v.module != ent.ModuleName then allow_print = false end
      if allow_print then
        ent:PrintLn(k.." - "..v.help)
      end
    end
  end
end

-- Function name says everything
function se_terminal_print_weapons_list(ent, args)
  for k, v in pairs(players_spaceship.modules.Weapons.weapons) do
    ent:PrintLn(k..". "..v.Name)
    ent:PrintLn("  * Damage: "..v.Damage)
    ent:PrintLn("  * Shots: "..v.Shots)
    ent:PrintLn("  * Igonres shields: "..tostring(v.IgnoreShileds))
  end
end

-- Function name says everything
function se_terminal_print_enemy_weapons(ent, args)
  if !enemy_spaceship or !enemy_spaceship.valid then return end
  for k, v in pairs(enemy_spaceship.modules.Weapons.weapons) do
    ent:PrintLn(k..". "..v.Name)
    ent:PrintLn("  * Damage: "..v.Damage)
    ent:PrintLn("  * Shots: "..v.Shots)
    ent:PrintLn("  * Igonres shields: "..tostring(v.IgnoreShileds))
  end
end

-- Function name says everything
function se_terminal_enemy_modules(ent, args)
  if !enemy_spaceship or !enemy_spaceship.valid then return end
  for k,v in pairs(enemy_spaceship.modules) do
    ent:PrintLn(k.." - "..v.health)
  end
end

-- Shoot in enemy spaceship
function se_terminal_shoot(ent, args)
  if !enemy_spaceship or !enemy_spaceship.valid then return end
  local weapon = tonumber(args[1])
  local module = args[2]
  local weapon = players_spaceship.modules.Weapons.weapons[weapon]
  local module_exists = enemy_spaceship.modules[module]

  if !weapon then
    ent:PrintLn("No such weapon. Example of command: shoot 2 Shields")
    ent:PrintLn("Type 'Weapons' to get list of all weapons")
    return
  end
  if !module_exists then
    ent:PrintLn("No such module. Example of command: shoot 2 Shields")
    return
  end
  if weapon.Charge >= weapon.MaxCharge then
    weapon.Charge = 0
    se_damage_enemy_ship_with_weapon(weapon, module)
  else
    ent:PrintLn("Low weapon charge, "..weapon.Charge.."/"..weapon.MaxCharge)
  end
end

-- Clears the screen
function se_terminal_clear(ent, args)
  ent:ClearLines()
end

-- Jump into next system, again function name says everything
function se_terminal_jump(ent, args)
  if players_spaceship.drive_charge >= 100 then
    se_try_jump()
  else
    ent:PrintLn("Please charge drive")
  end
end

-- Old and unused anymore
function se_terminal_start_flying(ent, args, ply)
  ply:StartFlying(true)
end

-- Function name says everything
function se_terminaL_charge_drive(ent, args)
  se_charge_drive()
  ent:PrintLn("Charging hyper drive....")
end

-- Answer into communication terminal
function se_terminal_answer(ent, args)
  if !communication_options[se_curret_comm] then return end
  local keys = table.GetKeys( communication_options[se_curret_comm].Options )
  if keys[tonumber(args[1])] then
    se_choose_comm(keys[tonumber(args[1])])
  end
end

-- Function name says everything
function se_terminal_teleport(ent, args)
  if se_is_planet then
    ent:PrintLn("Teleporting...")
    for k, v in ipairs(player.GetAll()) do
      if v:GetPos():Distance(ent:GetPos()) < 300 then
        v:SetPos(se_curret_planet.player)
        v.on_planet = true
      end
    end
  else
    ent:PrintLn("No planets nearby")
  end
end

-- Function name says everything
function se_terminal_teleport_planet_info(ent, args)
  if se_is_planet then
    ent:PrintLn("")
    ent:PrintLn("Name: "..se_curret_planet.name)
    ent:PrintLn("")
    ent:PrintLn("Description: "..se_curret_planet.desc)
    ent:PrintLn("")
    ent:PrintLn("Air: "..tostring(se_curret_planet.air))
    ent:PrintLn("")
  else
    ent:PrintLn("No planets nearby")
  end
end

-- Fn to analize what user typed
function se_terminal_read_line(ent, line, ply)
  local args = string.Split( line, " " )
  local programm = args[1]
  table.remove( args, 1 )
  if ent.enabled then
    if se_terminal_commands[programm] then
      local command = se_terminal_commands[programm]
      if command.module and command.module != ent.ModuleName then return end
      command.fn(ent, args, ply)
    else
      ent:PrintLn("No such command")
    end
  else
    -- If terminal is turned off we have to type 'boot'
    if programm == "boot" and players_spaceship.modules[ent.ModuleName].health > 50 then
      ent:PrintLn("")
      local i = 0
      timer.Create("se_terminal_boot_timer", 1, 10, function()
        i = i + 1
        local text = "["
        for k = 0,10 do
          if k <= i then
            text = text.."#"
          else
            text = text.."_"
          end
        end
        text = text.."]"
        ent:ChangeLine(text, 0)
      end)
      timer.Simple(11, function()
        ent:PrintLn("Welcome to the terminal, type 'help' for more info")
        ent.enabled = true
      end)
    else
      if players_spaceship.modules[ent.ModuleName].health > 20 then
        ent:PrintLn("Terminal is turned off, please enter 'boot' to continue")
      else
        ent:PrintLn("Terminal health is low, please repair terminal")
      end
    end
  end
end

-- Main array with all commands, key is command name
se_terminal_commands = {
  help = {
    man = "",
    help = "help",
    fn = se_terminal_help
  },
  jump = {
    man = "",
    help = "Jump to next system",
    module = "Pilot",
    fn = se_terminal_jump
  },
  --[[pilot = {
    man = "",
    help = "",
    module = "Pilot",
    fn = se_terminal_start_flying
  },--]]
  answer = {
    man = "",
    help = "Answer",
    module = "Communication",
    fn = se_terminal_answer
  },
  charge = {
    man = "",
    help = "Charges drive",
    module = "HyperDrive",
    fn = se_charge_drive
  },
  get_charge = {
    man = "",
    help = "Prints drive charge",
    module = "HyperDrive",
    fn = function(ent) ent:PrintLn(players_spaceship.drive_charge.."%") end,
  },
  oxygen = {
    man = "",
    help = "Prints oxygen level",
    module = "LifeSupport",
    fn = function(ent) ent:PrintLn(math.Round(players_spaceship.oxygen).."%") end,
  },
  ship_health = {
    man = "",
    help = "Prints ship health",
    module = "Pilot",
    fn = function(ent) ent:PrintLn(math.Round(players_spaceship.health).."%") end,
  },
  fuel = {
    man = "",
    help = "Prints fuel amount",
    module = "Pilot",
    fn = function(ent) ent:PrintLn(math.Round(players_spaceship.fuel)) end,
  },
  ship_shields = {
    man = "",
    help = "Prints ship state",
    module = "Pilot",
    fn = function(ent) ent:PrintLn(math.Round(players_spaceship.shields).."%") end,
  },
  enemy_health = {
    man = "",
    help = "Prints enemy's ship health",
    module = "Weapons",
    fn = function(ent)
      if !enemy_spaceship or !enemy_spaceship.valid then return end
      ent:PrintLn(math.Round(enemy_spaceship.health).."%")
    end,
  },
  enemy_shields = {
    man = "",
    help = "Prints enemy's ship shields",
    module = "Weapons",
    fn = function(ent)
      if !enemy_spaceship or !enemy_spaceship.valid then return end
      ent:PrintLn(math.Round(enemy_spaceship.shields).."%")
    end,
  },
  credits = {
    man = "",
    help = "Prints amount of credits",
    module = "Communication",
    fn = function(ent) ent:PrintLn(players_spaceship.credits.." кредитов") end,
  },
  weapons = {
    man = "",
    help = "Prints weapons list",
    module = "Weapons",
    fn = se_terminal_print_weapons_list
  },
  enemy_modules = {
    man = "",
    help = "Prints enemy's modules list",
    module = "Weapons",
    fn = se_terminal_enemy_modules
  },
  shoot = {
    man = "",
    help = "Shoots",
    module = "Weapons",
    fn = se_terminal_shoot
  },
  enemy_weapons = {
    man = "",
    help = "prints list of enemy's weapons",
    module = "Weapons",
    fn = se_terminal_print_enemy_weapons
  },
  clear = {
    man = "",
    help = "Clears screen",
    fn = se_terminal_clear
  },
  teleport = {
    man = "",
    help = "Teleportation to the nearby station/planet",
    module = "Teleport",
    fn = se_terminal_teleport
  },
  planet_info = {
    man = "",
    help = "Prints all info about planet",
    module = "Teleport",
    fn = se_terminal_teleport_planet_info
  },
  shutdown = {
    man = "",
    help = "Shutdowns terminal",
    fn = function(ent) ent.enabled = false end,
  },
}

net.Receive("se_terminal_send_input", function(_, ply)
  local ent = net.ReadEntity()
  local text = net.ReadString()
  ent:PrintLn(ply:Name()..":/ "..text)
  se_terminal_read_line(ent, text, ply)
end)
