se_players_ship_pos = {
  pos = Vector(),
  ang = Angle()
}

se_enemy_ship_state = {
  health = 0,
  shields = 0,
  modules = {}
}

se_player_spaceship_state = {
  health = 0,
  shields = 0,
  oxygen = 0,
  drive_charge = 0,
  modules = {},
  weapons = {},
  max_hp = 100,
  max_sh = 100,
}

se_curret_planet_info = {
  name = "",
  desk = "",
  air = false
}

net.Receive("se_event_simple", function()
  local event = net.ReadInt(8)
  -- Drive Charge
  if event == 1 then
    local sound = CreateSound(LocalPlayer(), "ambient/energy/force_field_loop1.wav")
    sound:PlayEx(0.25, 100)
    timer.Simple(10, function()
      sound:FadeOut(1)
    end)
  end
  -- Jump
  if event == 2 then
    local sound = CreateSound(LocalPlayer(), "ambient/machines/teleport3.wav")
    sound:PlayEx(0.5, 100)
  end
  -- Hit into players ship
  if event == 3 then
    util.ScreenShake( Vector( 0, 0, 0 ), 10, 10, 1, 5000 )
  end
  -- Hit into shields
  if event == 4 then
    local sound = CreateSound(LocalPlayer(), "ambient/explosions/exp"..math.random(1, 4)..".wav")
    sound:PlayEx(0.5, 100)
  end
  -- Shoot
  if event == 5 then
    local sound = CreateSound(LocalPlayer(), "weapons/ar2/fire1.wav")
    sound:PlayEx(0.5, 100)
  end
  -- Enemy ship
  if event == 6 then
    local sound = CreateSound(LocalPlayer(), "ambient/alarms/alarm_citizen_loop1.wav")
    sound:PlayEx(0.25, 100)
    timer.Simple(10, function()
      sound:FadeOut(1)
    end)
  end
  -- Drive Charge(Long)
  if event == 7 then
    local sound = CreateSound(LocalPlayer(), "ambient/energy/force_field_loop1.wav")
    sound:PlayEx(0.25, 100)
    timer.Simple(60, function()
      sound:FadeOut(1)
    end)
  end
end)

net.Receive("se_wear_suit", function()
  local wear = net.ReadBool()
  if wear then
    surface.PlaySound("doors/door_metal_gate_move2.wav")
    LocalPlayer().suit_sound = CreateSound(LocalPlayer(), "ambient/atmosphere/undercity_loop1.wav")
    LocalPlayer().suit_sound:PlayEx(0.25, 100)
  else
    if LocalPlayer().suit_sound then
      LocalPlayer().suit_sound:FadeOut(1)
    end
  end
end)

net.Receive("se_open_pilot_camera", function()
  se_camera_enabled = net.ReadBool()
  if se_camera_enabled then
    if IsValid(TextEntry) then
      TextEntry:Remove()
    end
  end
end)

net.Receive("se_update_ship_pos", function()
  local pos = -net.ReadVector()
  se_players_ship_pos.pos = pos
end)

net.Receive("se_update_ship_angle", function()
  local ang = net.ReadAngle()
  se_players_ship_pos.ang = ang
end)

net.Receive("se_update_enemy_state", function()
  se_enemy_ship_state = net.ReadTable()
end)

net.Receive("se_send_ship_state", function()
  se_player_spaceship_state = net.ReadTable()
end)

net.Receive("se_send_planet_info", function()
  se_curret_planet_info = net.ReadTable()
end)
