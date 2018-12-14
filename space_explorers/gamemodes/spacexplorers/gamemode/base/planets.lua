se_planet_ent = {}

se_planet_npcs = {
  {
    ent = "npc_antlion",
    min_hp = 100,
    max_hp = 250,
  },
  {
    ent = "npc_headcrab",
    min_hp = 20,
    max_hp = 80,
  },
  {
    ent = "npc_headcrab_fast",
    min_hp = 20,
    max_hp = 50,
  },
  {
    ent = "npc_headcrab_black",
    min_hp = 20,
    max_hp = 50,
  },
  {
    ent = "npc_zombie",
    min_hp = 150,
    max_hp = 350,
  },
  {
    ent = "npc_antlionguard",
    min_hp = 200,
    max_hp = 500,
  },
}

se_planet_positions = {
  DryPlanet = {
    name = "Dry planet",
    desc = "Looks like this planet was alive, but now it full of hay",
    player = Vector(-8588, -10325, -5495),
    teleport = Vector(-9810, -10220, -5252),
    spawn_bugs = true,
    air = false,
    max_npc = 30,
    bugs = {
      Vector(-10601, -9664, -5286),
      Vector(-12149, -9506, -5218),
      Vector(-12900, -9046, -4912),
      Vector(-13416, -8418, -5007),
      Vector(-13616, -7045, -5047),
      Vector(-12889, -6309, -5344),
      Vector(-12279, -7245, -4445),
      Vector(-10871, -7176, -5613),
      Vector(-9738, -6840, -5461),
      Vector(-9064, -5808, -4900),
      Vector(-8037, -5472, -5235),
      Vector(-7162, -4359, -5251),
      Vector(-5587, -3834, -5472),
      Vector(-4220, -5240, -5475),
      Vector(-4177, -6257, -5448),
      Vector(-4143, -7768, -5475),
      Vector(-4366, -9010, -5395),
      Vector(-5117, -8998, -5265),
      Vector(-5760, -8091, -4941),
      Vector(-6392, -9907, -5763),
      Vector(-5298, -10349, -5725),
      Vector(-5652, -10548, -5734),
      Vector(-12266, -12811, -5424),
      Vector(-12130, -10385, -5715),
      Vector(-13137, -7384, -5354),
      Vector(-11945, -6605, -5205),
      Vector(-10795, -3846, -5025),
      Vector(-10169, -4391, -5404),
    }
  },
  GrayPlanet = {
    name = "Gray planet",
    desc = "Looks like this planet has grass, it full of clay and dirt but there is some life on it",
    player = Vector(-8237, -8711, -3468),
    teleport = Vector(-8877, -9778, -3787),
    spawn_bugs = true,
    air = false,
    max_npc = 50,
    bugs = {
      Vector(-7753, -11212, -3797),
      Vector(-6211, -11467, -3805),
      Vector(-5784, -11097, -3798),
      Vector(-5053, -11060, -3389),
      Vector(-5759, -9140, -3414),
      Vector(-5527, -8399, -3262),
      Vector(-5519, -7868, -3211),
      Vector(-5982, -6858, -3437),
      Vector(-6000, -6311, -3411),
      Vector(-5087, -5146, -3613),
      Vector(-4355, -4370, -3670),
      Vector(-3996, -2511, -3805),
      Vector(-5393, -2405, -3806),
      Vector(-6858, -2761, -3703),
      Vector(-8309, -2668, -3773),
      Vector(-9736, -2834, -3719),
      Vector(-11326, -2968, -3430),
      Vector(-12701, -4487, -3383),
      Vector(-13410, -5519, -3770),
      Vector(-13742, -6531, -3631),
      Vector(-13875, -7707, -3589),
      Vector(-12344, -7724, -3709),
      Vector(-11769, -7021, -4036),
      Vector(-11569, -9955, -3738),
      Vector(-9267, -8864, -3737),
    }
  },
  DesertPlanet = {
    name = "Desert planet",
    desc = "Boring planet full of desert",
    player = Vector(-8455, -8106, 322),
    teleport = Vector(-9411, -7987, 325),
    spawn_bugs = true,
    air = false,
    max_npc = 30,
    bugs = {
      Vector(-10580, -10196, 321),
      Vector(-11255, -11448, 625),
      Vector(-9625, -11653, 377),
      Vector(-7824, -11774, 290),
      Vector(-6832, -11830, 284),
      Vector(-5649, -11897, 296),
      Vector(-5397, -10943, 293),
      Vector(-5350, -9602, 445),
      Vector(-5445, -8589, 498),
      Vector(-5785, -6126, 414),
      Vector(-7045, -5465, 394),
      Vector(-8456, -4829, 354),
      Vector(-9579, -4562, 425),
      Vector(-10968, -4162, 452),
      Vector(-12471, -4473, 495),
      Vector(-13265, -6072, 379),
      Vector(-13455, -7617, 355),
      Vector(-13398, -9055, 501),
      Vector(-13035, -10883, 553),
      Vector(-13593, -12081, 850),
      Vector(-12416, -12815, 424),
    }
  },
  Station = {
    name = "Orbital Space Station",
    desc = "An space station around planet orbit. Maybe we can buy/sell something here",
    player = Vector(725, -5541, -975),
    teleport = Vector(562, -6473, -783),
    max_artifacts = 1,
    spawn_npcs = true,
    spawn_bugs = false,
    air = true
  },
  LostStation = {
    name = "Lost Space Station",
    desc = "Seems like this space station is run out of power and now it just flys around space.",
    player = Vector(725, -5541, -975),
    teleport = Vector(562, -6473, -783),
    max_artifacts = 5,
    spawn_bugs = true,
    only_bugs = true,
    air = false,
    max_npc = 10,
    bugs = {
      Vector(1802, -5878, -783),
      Vector(1976, -4992, -783),
      Vector(1314, -4143, -783),
      Vector(367, -3988, -783),
      Vector(-490, -5040, -783),
      Vector(648, -5444, -975),
      Vector(791, -5379, -815),
      Vector(1049, -5125, -815),
      Vector(901, -4915, -815),
      Vector(671, -4964, -815),
      Vector(1675, -4117, -463),
      Vector(1987, -5881, -463),
      Vector(564, -6384, -463),
    }
  },
  SnowPlanet = {
    name = "Snow Planet",
    desc = "Planet full of snow",
    player = Vector(-10060,-7024,-7487),
    teleport = Vector(-10492,-7883,-7674),
    spawn_bugs = true,
    air = false,
    max_npc = 50,
    bugs = {
      Vector(-12327,-8754,-7395),
      Vector(-13681,-9172,-7185),
      Vector(-13844,-7678,-7025),
      Vector(-13554,-4839,-7310),
      Vector(-12954,-2936,-7212),
      Vector(-10665,-3737,-6961),
      Vector(-7960,-3468,-7383),
      Vector(-6090,-3437,-7374),
      Vector(-4227,-3353,-7514),
      Vector(-3918,-4996,-7364),
      Vector(-4198,-6875,-7546),
      Vector(-4342,-8373,-7357),
      Vector(-4159,-10172,-7480),
      Vector(-3915,-11692,-7383),
      Vector(-4325,-12980,-7375),
      Vector(-5373,-11457,-6770),
      Vector(-7650,-10241,-7227),
      Vector(-7930,-8938,-7156),
      Vector(-8449,-7994,-7256),
    }
  },
}

space_body = {
  Exists = true,
  Color = Color(math.random(1, 200), math.random(1, 200), math.random(1, 200)),
  Size = math.random(50, 150)
}

function se_create_planet_model(planet_name)
  local asteroids = {}
  for k = 0, 50 do
    local asteroid = {
      Vector(math.random(-5000, 5000), math.random(-5000, 5000), math.random(-5000, 5000)),
      math.random(0, 3)
    }
    table.insert(asteroids, asteroid)
  end
  local planet = table.Random(se_planet_positions)
  if planet_name != nil then
    planet = se_planet_positions[planet_name]
  end
  space_body = {
    Exists = true,
    Color = Color(math.random(1, 200), math.random(1, 200), math.random(1, 200)),
    Size = math.random(1000, 5000),
    Atmoshpere = math.random(0, 10) > 5,
    Material = math.random(1, 3),
    asteroids = asteroids
  }
  net.Start("se_update_space_body")
  net.WriteTable(space_body)
  net.Broadcast()

  se_is_planet = true
  se_curret_planet = planet
  se_asteroids = asteroids
  for k, v in pairs( ents.FindByClass( "npc_*" ) ) do
	   v:Remove()
  end
  timer.Stop("se_spawn_enemy_npcs")
  for k, v in pairs( ents.FindByClass( "se_shop_npc" ) ) do
     v:Remove()
  end
  for k, v in pairs( ents.FindByClass( "se_rare_item" ) ) do
     v:Remove()
  end

  local sky_color = Vector(space_body.Color.r / 255, space_body.Color.g / 255, space_body.Color.b / 255)
  local paint = ents.FindByClass('env_skypaint')[1]
  paint:SetDrawStars(true)
  paint:SetStarTexture('skybox/starfield')

  paint:SetTopColor(sky_color)
  paint:SetBottomColor(sky_color)
  paint:SetFadeBias(1)

  paint:SetDuskColor(Vector(1.0, 0.2, 0.0))
  paint:SetDuskScale(1)
  paint:SetDuskIntensity(1)

  if planet.spawn_bugs then
    timer.Create("se_spawn_enemy_npcs", 0.2, math.random(5, planet.max_npc), function()
      local npc = table.Random(se_planet_npcs)
      local pos = table.Random(planet.bugs)
      if planet.only_bugs then
        npc = se_planet_npcs[1]
      end
      local pos = Vector(pos[1], pos[2], pos[3] + 64)
      local ant = ents.Create(npc.ent)
      ant:SetPos(pos)
      ant:Spawn()
      ant:SetHealth(math.random(npc.min_hp, npc.max_hp))
      ant:SetColor(Color(math.random(1, 200), math.random(1, 200), math.random(1, 200)))
      for k, v in pairs( ents.FindByClass( "npc_*" ) ) do
        ant:AddEntityRelationship( v, D_FR, 99 )
      end
    end)
    timer.Create("se_spawn_atrifacts", 0.2, math.random(2, planet.max_artifacts or 20), function()
      local pos = table.Random(planet.bugs)
      local pos = Vector(pos[1], pos[2], pos[3] + 64)
      local ant = ents.Create("se_rare_item")
      ant:SetPos(pos)
      ant:Spawn()
      ant:SetColor(Color(math.random(1, 200), math.random(1, 200), math.random(1, 200)))
    end)
  end
  if planet.spawn_npcs then
    se_init_npcs()
  end
  se_send_planet_info()
end

function se_remove_planet_model()
  local asteroids = {}
  for k = 0, 50 do
    local asteroid = {
      Vector(math.random(-5000, 5000), math.random(-5000, 5000), math.random(-5000, 5000)),
      math.random(0, 3)
    }
    table.insert(asteroids, asteroid)
  end
  space_body = {
    Exists = false,
    Color = Color(math.random(1, 200), math.random(1, 200), math.random(1, 200)),
    Size = math.random(2000, 5000),
    Material = math.random(1, 3),
    asteroids = asteroids
  }
  net.Start("se_update_space_body")
  net.WriteTable(space_body)
  net.Broadcast()
  se_send_planet_info()
end

function se_init_teleports()
  for k, v in pairs(se_planet_positions) do
    local v = v.teleport
    local teleport = ents.Create("se_teleport")
    teleport:SetPos(Vector(v[1], v[2], v[3]))
    teleport:Spawn()
  end
end

function se_send_planet_info()
  if se_is_planet then
    local planet = {
      name = se_curret_planet.name,
      desk = se_curret_planet.desc,
      air = se_curret_planet.air
    }
    net.Start("se_send_planet_info")
    net.WriteTable(planet)
    net.Broadcast()
  end
end
