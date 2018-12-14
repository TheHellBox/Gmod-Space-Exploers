se_npcs_positions = {
  {
    Position = Vector(734,-4922,-975),
    Angles = Angle(0,117,0),
  },
  {
    Position = Vector(880,-4914,-975),
    Angles = Angle(0,67,0),
  },
  {
    Position = Vector(1017,-5056,-975),
    Angles = Angle(0,21,0),
  },
  {
    Position = Vector(893,-5321,-975),
    Angles = Angle(0,-70,0),
  },
  {
    Position = Vector(1044,-6457,-783),
    Angles = Angle(0,105,0),
  },
  {
    Position = Vector(1515,-6436,-783),
    Angles = Angle(0,148,0),
  },
  {
    Position = Vector(1761,-5749,-783),
    Angles = Angle(0,86,0),
  },
  {
    Position = Vector(-397,-5089,-783),
    Angles = Angle(0,81,0),
  },
  {
    Position = Vector(757,-5327,-975),
    Angles = Angle(0,-122,0),
  },
  {
    Position = Vector(635,-5227,-975),
    Angles = Angle(0,-161,0),
  },
}

se_npc_gun_shop = {
  {
    Name = "SMG",
    Weapon = "weapon_smg1",
    Ammo = "SMG1",
    PriceMin = 20,
    PriceMax = 50,
    IsAmmo = false
  },
  {
    Name = "SMG Ammo",
    Weapon = "SMG1",
    PriceMin = 1,
    PriceMax = 10,
    IsAmmo = true
  },
  {
    Name = "Shotgun",
    Weapon = "weapon_shotgun",
    Ammo = "SMG1",
    PriceMin = 20,
    PriceMax = 70,
    IsAmmo = false
  },
  {
    Name = "Shotgun Ammo",
    Weapon = "Buckshot",
    PriceMin = 1,
    PriceMax = 10,
    IsAmmo = true
  },
  {
    Name = "Crossbow",
    Weapon = "weapon_crossbow",
    Ammo = "SMG1",
    PriceMin = 20,
    PriceMax = 70,
    IsAmmo = false
  },
  {
    Name = "Crossbow Ammo",
    Weapon = "XBowBolt",
    PriceMin = 1,
    PriceMax = 10,
    IsAmmo = true
  },
}

se_npc_weapon_shop = {
  {
    Name = "Triple Missle",
    PriceMin = 100,
    PriceMax = 200,
    Id = "TripleMissle"
  },
  {
    Name = "Mega Blaster",
    PriceMin = 50,
    PriceMax = 150,
    Id = "MegaBlaster"
  },
  {
    Name = "Devil Gun",
    PriceMin = 50,
    PriceMax = 150,
    Id = "DevilGun"
  },
  {
    Name = "Mega Devil Gun",
    PriceMin = 150,
    PriceMax = 250,
    Id = "MegaDevilGun"
  },
}
function se_init_npcs()
  local prev_poses = {}
  for k=1,math.random(4, 7) do
    local pos_rot = table.Random(se_npcs_positions)
    local pos = pos_rot.Position
    local rot = pos_rot.Angles
    if !table.HasValue(prev_poses, pos) then
      table.insert(prev_poses, pos)
      local npc = ents.Create("se_shop_npc")
      npc:SetPos(pos)
      npc:SetAngles(rot)
      npc:Spawn()
    end
  end
end


function se_npc_gen_gun_shop (ent)
  local guns = {}
  for k=1, 3 do
    local gun = table.Random(se_npc_gun_shop)
    if !table.HasValue(guns, gun) then
      ent:AddItem(gun.Name, math.random(gun.PriceMin * se_fractions.Price_Mod, gun.PriceMax * se_fractions.Price_Mod), function(ply)
        if !gun.IsAmmo then
          local weapon = ply:Give(gun.Weapon)
          ply:GiveAmmo( 100, gun.Ammo )
        else
          ply:GiveAmmo( 10, gun.Weapon )
        end
      end)
      table.insert(guns, gun)
    end
  end
end

function se_npc_gen_weapons_shop (ent)
  local weapons = {}
  for k=1, 3 do
    local weapon = table.Random(se_npc_weapon_shop)
    if !table.HasValue(weapons, weapon) then
      ent:AddItem(weapon.Name, math.random(weapon.PriceMin * se_fractions.Price_Mod, weapon.PriceMax * se_fractions.Price_Mod), function(ply)
        local new_weapon = se_weapons[weapon.Id]
        table.insert(players_spaceship.modules.Weapons.weapons, table.Copy(new_weapon))
      end)
      table.insert(weapons, weapon)
    end
  end
end

function se_npc_ship_service (ent)
  local weapons = {}
  ent:AddItem("Buy fuel", 2, function(ply)
    players_spaceship.fuel = players_spaceship.fuel + 2
  end)
  ent:AddItem("Repair ship", 2, function(ply)
    players_spaceship.health = players_spaceship.health + 2
    if players_spaceship.health > players_spaceship.max_health then
      players_spaceship.health = players_spaceship.max_health
    end
  end)
end

function se_npc_ship_upgrades (ent)
  local weapons = {}
  ent:AddItem("+5 health", 25, function(ply)
    players_spaceship.health = players_spaceship.health + 5
    players_spaceship.max_health = players_spaceship.max_health + 5
  end)
  ent:AddItem("+5 shields", 25, function(ply)
    players_spaceship.shields = players_spaceship.shields + 5
    players_spaceship.max_shields = players_spaceship.max_shields + 5
  end)
  ent:AddItem("Shields regeneration speed", 50, function(ply)
    players_spaceship.shield_reg_mod = players_spaceship.shield_reg_mod + 1
  end)
end


net.Receive("se_buy_item", function(_, ply)
  local ent = net.ReadEntity()
  local item = net.ReadInt(8)
  local item = ent.items[item]
  if players_spaceship.credits >= item.Price then
    players_spaceship.credits = players_spaceship.credits - item.Price
    item.Fn(ply)
  end
end)
