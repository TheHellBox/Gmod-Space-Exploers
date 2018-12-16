include("shop_npc.lua")
include("fractions_ui.lua")
include("scoreboard.lua")
include("lose_menu.lua")

local spacesuit_glass = Material( "se_materials/spacesuit.png", "noclamp smooth" )

surface.CreateFont("se_ScoreboardFont", {
	size = 22,
	antialias = false,
	font = "Roboto Bold"
} );

surface.CreateFont("se_NPCFont", {
	size = 42,
	antialias = false,
	font = "Roboto Bold"
} );

function se_draw_hud_element(text, pos_y)
  surface.DrawRect( 50, ScrH() - pos_y-5, 320, 25 )
  draw.DrawText( text, "TargetID", 60, ScrH() - pos_y, Color( 255, 255, 255, 255 ) )
end

function GM:HUDPaint()
  if LocalPlayer():GetNWBool("SE_InSuit") then
    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( spacesuit_glass	)
  	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
  end
  surface.SetDrawColor( 20, 20, 20, 200 )
  surface.DrawRect( 50, ScrH() - 150, 320, 30 )

  se_draw_hud_element("Race: "..LocalPlayer():GetNWString("se_race", "Humans"), 110)

  se_draw_hud_element("Health: "..LocalPlayer():Health().."/"..LocalPlayer():GetNWInt("se_maxhealth", 100), 80)

  se_draw_hud_element("Repair skills: "..math.Round(LocalPlayer():GetNWInt("repair_skills", 1) * 100).."%", 50)

  surface.SetDrawColor( 255, 20, 20, 255 )
  surface.DrawRect( 60, ScrH() - 140, 300 * (LocalPlayer():Health() / LocalPlayer():GetNWInt("se_maxhealth", 100)), 10 )

	if se_camera_enabled then
		local CamData = {}
		CamData.angles = Angle(0,0,0)
		CamData.origin = Vector(-78,-903,85)
		CamData.x = 0
		CamData.y = 0
		CamData.w = ScrW()
		CamData.h = ScrH()
		CamData.fov = 120
		render.RenderView( CamData )

		local CamData = {}
		CamData.angles = Angle(0,90,0)
		CamData.origin = Vector(-397,-920,85)
		CamData.x = 0
		CamData.y = 0
		CamData.w = ScrW() / 3
		CamData.h = ScrH() / 3
		CamData.fov = 120
		render.RenderView( CamData )

		local CamData = {}
		CamData.angles = Angle(0,-90,0)
		CamData.origin = Vector(-397,-920,85)
		CamData.x = ScrW() - ScrW() / 3
		CamData.y = 0
		CamData.w = ScrW() / 3
		CamData.h = ScrH() / 3
		CamData.fov = 120
		render.RenderView( CamData )

		local CamData = {}
		CamData.angles = Angle(0,180,0)
		CamData.origin = Vector(Vector(-1934,-885,45))
		CamData.x = 0
		CamData.y = ScrH() - ScrH() / 3
		CamData.w = ScrW() / 3
		CamData.h = ScrH() / 3
		CamData.fov = 120
		render.RenderView( CamData )
	end
end

function se_draw_player_name( ply )
	local angle = LocalPlayer():EyeAngles()
	angle:RotateAroundAxis( angle:Forward(), 90 )
	angle:RotateAroundAxis( angle:Right(), 90 )

	for k, v in pairs(player.GetAll()) do
		if v != LocalPlayer() then
			cam.Start3D2D(v:GetPos() + Vector(0, 0, 85), angle, 0.2)
				local text = v:Name()
				surface.SetFont( "se_NPCFont" )
				local width, _ = surface.GetTextSize( text )
				local is_captain = ply:GetNWBool("se_is_сaptain", false)
				local color = Color(200, 200, 200, 255)
				if is_captain then
					color = Color(200, 100, 100, 255)
				end
				draw.SimpleText(text, "se_NPCFont", -width / 2, 0, color, 0, 0, TEXT_ALIGN_CENTER);
			cam.End3D2D()
		end
	end
end
hook.Add( "PostPlayerDraw", "se_draw_player_name", se_draw_player_name )

function GM:HUDShouldDraw(name)
	if name == "CHudHealth" or name == "CHudBattery" then return false else return true end
end

local function se_draw_bar(value, color, pos, size, max)
	if size == nil then size = 40 end
	if max == nil then max = 100 end
	surface.SetDrawColor( 20, 20, 20, 255 )
	surface.DrawRect( 10, pos, 580, 40 )
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.DrawRect( 10, pos, (580 * (value / max)), 40 )
end

hook.Add( "PostDrawTranslucentRenderables", "se_draw_ship_state", function()
	local is_player_there = LocalPlayer():GetPos():WithinAABox(  Vector(506, -1946, 723), Vector(-2667, -173, -229) )
	if !is_player_there then return end
	if se_enemy_ship_state.health > 0 then
		cam.Start3D2D(Vector(-800,-1159,128), Angle(0, 180, 90), 0.15)
			surface.SetDrawColor( 40, 40, 40, 255 )
			surface.DrawRect( 0, 0, 600, 600 )

			se_draw_bar(se_enemy_ship_state.shields, Color(40, 40, 80), 40)

			se_draw_bar(se_enemy_ship_state.health, Color(80, 40, 40), 90)

			surface.SetFont( "se_ScoreboardFont" )
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( 10, 20 )
			surface.DrawText( "Enemy state:" )
			surface.SetTextPos( 10, 50 )
			surface.DrawText( "Shields: "..se_enemy_ship_state.shields.."%" )
			surface.SetTextPos( 10, 100 )
			surface.DrawText( "Health: "..se_enemy_ship_state.health.."%" )
			surface.SetTextPos( 10, 160 )
			surface.DrawText( "Enemy modules:" )

			local index = 0
			for k, v in pairs(se_enemy_ship_state.modules) do
				surface.SetDrawColor( 80, 40, 80, 255 )
				surface.DrawRect( 10, 180 + (index * 50), (580 * (v / 100)), 40 )
				-- Don't ask why I use surface.DrawText in upper code and use draw.DrawText here
				draw.DrawText( k..": "..v.."%", "se_ScoreboardFont", 10, 190 + (index * 50), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				index = index + 1
			end
		cam.End3D2D()
	end
	cam.Start3D2D(Vector(-890,-650,128), Angle(0, 0, 90), 0.15)
		surface.SetDrawColor( 40, 40, 40, 255 )
		surface.DrawRect( 0, 0, 600, 600 )

		se_draw_bar(se_player_spaceship_state.shields, Color(40, 40, 80), 40, 40, se_player_spaceship_state.max_sh)

		se_draw_bar(se_player_spaceship_state.health, Color(80, 40, 40), 90, 40, se_player_spaceship_state.max_hp)

		se_draw_bar(se_player_spaceship_state.oxygen, Color(40, 80, 80), 140)

		surface.SetFont( "se_ScoreboardFont" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 10, 20 )
		surface.DrawText( "Ship State:" )
		surface.SetTextPos( 10, 50 )
		surface.DrawText( "Shields: "..se_player_spaceship_state.shields.."%" )
		surface.SetTextPos( 10, 100 )
		surface.DrawText( "Health: "..se_player_spaceship_state.health.."%" )
		surface.SetTextPos( 10, 150 )
		surface.DrawText( "Oxygen:"..se_player_spaceship_state.oxygen.."%" )
		surface.SetTextPos( 10, 190 )
		surface.DrawText( "Ship modules:" )

		local index = 0
		for k, v in pairs(se_player_spaceship_state.modules) do
			surface.SetDrawColor( 80, 40, 80, 255 )
			surface.DrawRect( 10, 220 + (index * 50), (580 * (v / 100)), 40 )
			-- Don't ask why I use surface.DrawText in upper code and use draw.DrawText here
			draw.DrawText( k..": "..v.."%", "se_ScoreboardFont", 10, 230 + (index * 50), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			index = index + 1
		end
	cam.End3D2D()

	cam.Start3D2D(Vector(-1500,-1137,100), Angle(0, 180, 90), 0.08)
		surface.SetDrawColor( 40, 40, 40, 255 )
		surface.DrawRect( 0, 0, 600, 100 )

		surface.SetDrawColor( 40, 80, 80, 255 )
		surface.DrawRect( 10, 40, (580 * (se_player_spaceship_state.drive_charge / 100)), 40 )

		surface.SetFont( "se_ScoreboardFont" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 10, 20 )
		surface.DrawText( "Drive state:" )
		surface.SetTextPos( 10, 50 )
		surface.DrawText( "Charge: "..se_player_spaceship_state.drive_charge.."%" )
		surface.SetTextPos( 10, 100 )
	cam.End3D2D()

	cam.Start3D2D(	Vector(-685,-1159,140), Angle(0, 180, 90), 0.2)
		surface.SetDrawColor( 40, 40, 40, 255 )
		surface.DrawRect( 0, 0, 300, 300 )

		surface.SetFont( "se_ScoreboardFont" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 10, 20 )
		surface.DrawText( "Weapons charge:" )

		for k, v in pairs(se_player_spaceship_state.weapons) do
			surface.SetDrawColor( 80, 40, 80, 255 )
			surface.DrawRect( 10, (index * 30) - 160, (280 * (v[1] / v[2])), 20 )
			-- Don't ask why I use surface.DrawText in upper code and use draw.DrawText here
			draw.DrawText( v[3]..": "..v[1].."/"..v[2], "se_ScoreboardFont", 10, (index * 30) - 160, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			index = index + 1
		end
	cam.End3D2D()

	cam.Start3D2D(Vector(-1911,-920,100), Angle(0, 90, 90), 0.08)
		surface.SetDrawColor( 40, 40, 40, 255 )
		surface.DrawRect( 0, 0, 600, 200 )

		surface.SetFont( "se_ScoreboardFont" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 10, 20 )
		surface.DrawText( "Planet info" )
		surface.SetTextPos( 10, 50 )
		surface.DrawText( "Name: "..se_curret_planet_info.name )
		surface.SetTextPos( 10, 70 )
		surface.DrawText( "Air: "..tostring(se_curret_planet_info.air) )
	cam.End3D2D()

end)
