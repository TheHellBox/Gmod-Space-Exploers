local se_planet_materials = {"se_materials/se_planets/earthlike_planet.png", "se_materials/se_planets/desertlike_planet.png", "se_materials/se_planets/oceanlike_planet.png"}

local se_planet_clouds = Material("se_materials/se_planets/clouds.png")
local se_enemy = Material("se_materials/enemys/se_spaceship.png")
local se_enemy_shields = Material("se_materials/enemys/se_spaceship_shields.png")

local asteroids = ClientsideModel("models/props_wasteland/rockgranite01c.mdl")

--local enemy_model = ClientsideModel("models/props_combine/combine_train02a.mdl")
--enemy_model:SetColor(Color(255, 255, 255, 255))


net.Receive("se_update_space_body", function()
  body_info = net.ReadTable()
  body_info.material = Material( se_planet_materials[body_info.Material], "noclamp smooth" )
end)

net.Receive("se_update_enemy_sprite", function()
  enemy_sprite = net.ReadTable()
end)

hook.Add( "PostDrawTranslucentRenderables", "SE_DrawSpaceBody", function()
  local view = Matrix()
  view:Translate(Vector(-1203,-903,85))
  view:Rotate(se_players_ship_pos.ang)
  view:Translate(se_players_ship_pos.pos)

  local is_player_there = LocalPlayer():GetPos():WithinAABox(  Vector(506, -1946, 723), Vector(-2667, -173, -229) )
  if body_info and is_player_there then
    for k, v in pairs(body_info.asteroids or {}) do
      local model = Matrix()
      model:Translate(v[1])

      asteroids:DrawModel()
      asteroids:EnableMatrix( "RenderMultiply", view * model )
    end
  end
  if body_info and body_info.Exists then
    if is_player_there then
      --local model = Matrix()
      --model:Translate(Vector(600, 0, 0))

      --enemy_model:DrawModel()
      --enemy_model:EnableMatrix( "RenderMultiply", view * model )

      local planet_model = Matrix()
      planet_model:Rotate(se_players_ship_pos.ang)
      planet_model:Translate(Vector(10000, -900, 42))

      cam.PushModelMatrix(planet_model)
        render.SetMaterial( body_info.material )
        render.DrawSphere( Vector(), body_info.Size, 30, 30, body_info.Color )
        render.SetMaterial( se_planet_clouds )
        render.DrawSphere( Vector(), body_info.Size * 1.01, 30, 30, body_info.Color )
      cam.PopModelMatrix()
    end
  end

  if enemy_sprite and enemy_sprite.Exists and is_player_there then
    cam.Start3D2D(Vector(-352, 445, 100), Angle(0, 0, 90), 1.0)
    surface.SetDrawColor( 255, 255 * (enemy_sprite.Health / 100), 255 * (enemy_sprite.Health / 100), 255 )
  	surface.SetMaterial( se_enemy	)
  	surface.DrawTexturedRect( 0, 0, 179, 60 )

    surface.SetDrawColor( 255, 255, 255, 255 * (enemy_sprite.Shields / 100) )
    surface.SetMaterial( se_enemy_shields	)
    surface.DrawTexturedRect( -10, -20, 210, 101 )
    cam.End3D2D()
  end
end )
