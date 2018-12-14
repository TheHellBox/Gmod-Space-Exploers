local se_universe = Material( "se_materials/universe.png" )
local se_spaceship_icon = Material( "se_materials/spaceship_icon.png" )

function se_open_star_map(stars)
	if IsValid(se_scoreboard) then
		se_scoreboard:Hide()
	end

	se_map_browser = vgui.Create( "DPanel" )
	se_map_browser:SetSize( 800, 600 )
	se_map_browser:Center()
	se_map_browser:MakePopup()

	function se_map_browser:Paint(w, h)
    draw.RoundedBox( 5, 0, 0, w, h, Color(50, 50, 50, 230) )
  end

	se_map_browser_map = vgui.Create( "DPanel", se_map_browser )
	se_map_browser_map:SetSize( 800, 520 )
	se_map_browser_map:Dock(TOP)

	function se_map_browser_map:Paint(w, h)
		surface.SetDrawColor( 255, 255, 255, 100 )
		surface.SetMaterial( se_universe	)
		surface.DrawTexturedRect( 0, 0, w, h )
		for k, star in pairs(stars.stars) do
			local start_pos = { 20 + 750 * (star.pos[1] / 100), 20 + 450 * (star.pos[2] / 100)}
			if stars.player_pos == k then
				local c = math.cos( math.rad( (CurTime() % 360) * 10 ) )
				local s = math.sin( math.rad( (CurTime() % 360) * 10 ) )
				local newx = 30 * s - 30 * c + 15
				local newy = 30 * c + 30 * s + 15
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( se_spaceship_icon	)
				surface.DrawTexturedRectRotated( start_pos[1] + newx, start_pos[2] + newy, 30, 32, (CurTime() % 360) * 10 - 120 )
			end
			for k, v in pairs(star.connects_to) do
				local end_pos = { 20 + 750 * (stars.stars[v].pos[1] / 100), 20 + 450 * (stars.stars[v].pos[2] / 100)}
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawLine( start_pos[1] + 16, start_pos[2] + 16, end_pos[1] + 16, end_pos[2] + 16)
			end
		end
  end

	for k, star in pairs(stars.stars) do
		local pos = { 20 + 750 * (star.pos[1] / 100), 20 + 450 * (star.pos[2] / 100)}
		local DLabel = vgui.Create( "DLabel", se_map_browser_map )
		DLabel:SetPos( pos[1], pos[2] - 15 )
		DLabel:SetColor( Color(255, 255, 255) )
		DLabel:SetText( star.type )
		DLabel:SetFont("se_map_font")

		local se_map_browser_star = vgui.Create( "DButton", se_map_browser_map )
		se_map_browser_star:SetText("")
		se_map_browser_star:SetSize(33, 33)
		se_map_browser_star:SetPos(pos[1], pos[2])
		function se_map_browser_star:OnMousePressed()
			if table.HasValue(star.connects_to, stars.player_pos) then
				surface.PlaySound("buttons/button15.wav")
				stars.star_choosed = k
				net.Start("se_choose_star")
				net.WriteInt(k, 8)
				net.SendToServer()
			else
				surface.PlaySound("buttons/button10.wav")
			end
		end
		function se_map_browser_star:Paint(w, h)
			drawCircle(w / 2, h / 2, w / 2, 4, Color(255, 255, 255))
			if stars.player_pos == k then
				drawCircle(w / 2, h / 2, w / 2 * 0.8, 4, Color(40, 80, 40))
			elseif stars.star_choosed == k then
				drawCircle(w / 2, h / 2, w / 2 * 0.8, 4, Color(80, 80, 40))
			elseif star.type == "Exit" then
				drawCircle(w / 2, h / 2, w / 2 * 0.8, 4, Color(80, 40, 40))
			elseif star.type == "Mission" then
				drawCircle(w / 2, h / 2, w / 2 * 0.8, 4, Color(80, 40, 80))
			elseif star.explored then
				drawCircle(w / 2, h / 2, w / 2 * 0.8, 4, Color(40, 40, 80))
			else
				drawCircle(w / 2, h / 2, w / 2 * 0.8, 4, Color(40, 40, 40))
			end
		end
	end

	local se_map_browser_close = vgui.Create( "DButton", se_map_browser )
	se_map_browser_close:SetText("")
	se_map_browser_close:SetSize(350, 60)
	se_map_browser_close:DockMargin( 10, 10, 10, 10 )
	se_map_browser_close:Dock(LEFT)
	function se_map_browser_close:OnMousePressed()
		se_scoreboard:Show()
		se_map_browser:Remove()
	end
	function se_map_browser_close:Paint(w, h)
		if self.Hovered then
			draw.RoundedBox( 5, 0, 0, w, h, Color(40, 160, 40, 255) )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(10, 120, 10, 255) )
		end
		draw.DrawText( "Close", "se_ScoreboardFont", w / 2, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end

	local se_map_browser_jump_to_next_sec = vgui.Create( "DButton", se_map_browser )
	se_map_browser_jump_to_next_sec:SetText("")
	se_map_browser_jump_to_next_sec:SetSize(350, 60)
	se_map_browser_jump_to_next_sec:DockMargin( 10, 10, 10, 10 )
	se_map_browser_jump_to_next_sec:Dock(RIGHT)
	function se_map_browser_jump_to_next_sec:OnMousePressed()
		if stars.stars[stars.player_pos].type == "Exit" then
			net.Start("se_jump_to_next_sector")
			net.SendToServer()
			se_scoreboard:Show()
			se_map_browser:Remove()
		end
	end
	function se_map_browser_jump_to_next_sec:Paint(w, h)
		local color = 0.5
		if stars.stars[stars.player_pos].type == "Exit" then
			color = 1.0
		end
		if self.Hovered and stars.stars[stars.player_pos].type == "Exit" then
			draw.RoundedBox( 5, 0, 0, w, h, Color(40 * color, 40 * color, 160 * color, 255) )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(10 * color, 10 * color, 120 * color, 255) )
		end
		draw.DrawText( "Jump to next sector", "se_ScoreboardFont", w / 2, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end

end

function se_open_scoreboard(skills, stars)
  se_scoreboard = vgui.Create( "DFrame" )
  se_scoreboard:SetSize( 800, 600 )
  se_scoreboard:Center()
	se_scoreboard:SetTitle("")
  se_scoreboard:MakePopup()
  function se_scoreboard:Paint(w, h)

  end

  local se_scoreboard_main = vgui.Create( "DPanel", se_scoreboard )
  se_scoreboard_main:SetSize(400, 600)
  se_scoreboard_main:Dock(LEFT)
  function se_scoreboard_main:Paint(w, h)
    draw.RoundedBox( 5, 0, 0, w, h, Color(50, 50, 50, 250) )
  end

	local se_scoreboard_open_map = vgui.Create( "DButton", se_scoreboard_main )
	se_scoreboard_open_map:SetText("")
	se_scoreboard_open_map:SetSize(350, 60)
	se_scoreboard_open_map:DockMargin( 10, 10, 10, 0 )
	se_scoreboard_open_map:Dock(TOP)
	function se_scoreboard_open_map:OnMousePressed()
		se_open_star_map(stars)
	end
	function se_scoreboard_open_map:Paint(w, h)
		if self.Hovered then
			draw.RoundedBox( 5, 0, 0, w, h, Color(40, 160, 40, 255) )
		else
			draw.RoundedBox( 5, 0, 0, w, h, Color(10, 120, 10, 255) )
		end
		draw.DrawText( "Open Map", "se_ScoreboardFont", w / 2, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end

  local DLabel = vgui.Create( "DLabel", se_scoreboard_main )
  DLabel:SetSize(400, 50)
  DLabel:Dock(TOP)
  DLabel:SetContentAlignment(5)
  DLabel:SetText( LocalPlayer():GetNWInt("se_talent_points", 0).." talent points available" )
  DLabel:SetFont("se_ScoreboardFont")
  DLabel:SetColor(Color(255, 255, 255))

  for k, v in pairs(skills) do
    local se_scoreboard_skill_button = vgui.Create( "DButton", se_scoreboard_main )
    se_scoreboard_skill_button:SetText("")
    se_scoreboard_skill_button:SetSize(350, 40)
    se_scoreboard_skill_button:DockMargin( 10, 10, 10, 0 )
    se_scoreboard_skill_button:Dock(TOP)
    function se_scoreboard_skill_button:OnMousePressed()
      if LocalPlayer():GetNWInt("se_talent_points", 0) > 0 and v.level < v.max and !LocalPlayer():GetNWBool("SE_InSuit", false) then
				surface.PlaySound("buttons/button15.wav")
        v.level = v.level + 1
        DLabel:SetText( (LocalPlayer():GetNWInt("se_talent_points", 0) - 1).." talent points available" )
        net.Start("se_skill_update")
        net.WriteString(k)
        net.SendToServer()
			else
				surface.PlaySound("buttons/button10.wav")
      end
    end
    function se_scoreboard_skill_button:Paint(w, h)
      if self.Hovered then
        draw.RoundedBox( 5, 0, 0, w, h, Color(80, 80, 80, 255) )
      else
        draw.RoundedBox( 5, 0, 0, w, h, Color(30, 30, 30, 255) )
      end
      draw.DrawText( k, "se_ScoreboardFont", 5, 10, Color( 255, 255, 255, 255 ) )
      for k=1,v.max do
        if v.level >= k then
					draw.RoundedBox( 20, 150 + k * 25, 10, 20, 20, Color( 200, 200, 200, 255 ) )
        else
					draw.RoundedBox( 20, 150 + k * 25, 10, 20, 20, Color( 80, 80, 80, 255 ) )
        end
      end
    end
  end

  local se_scoreboard_players = vgui.Create( "DPanel", se_scoreboard )
  se_scoreboard_players:SetSize(350, 600)
  se_scoreboard_players:Dock(RIGHT)
  function se_scoreboard_players:Paint(w, h)
    draw.RoundedBox( 5, 0, 0, w, h, Color(50, 50, 50, 250) )
  end

  for k, v in pairs(player.GetAll()) do
    local se_scoreboard_player_btn = vgui.Create( "DButton", se_scoreboard_players )
    se_scoreboard_player_btn:SetText("")
    se_scoreboard_player_btn:SetSize(350, 40)
    se_scoreboard_player_btn:DockMargin( 10, 10, 10, 0 )
    se_scoreboard_player_btn:Dock(TOP)
    function se_scoreboard_player_btn:Paint(w, h)
      if self.Hovered then
        draw.RoundedBox( 5, 0, 0, w, h, Color(80, 80, 80, 255) )
        draw.DrawText( v:Name()..": "..v:GetNWString("se_race", "Humans"), "se_ScoreboardFont", w / 2, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
      else
        draw.RoundedBox( 5, 0, 0, w, h, Color(30, 30, 30, 255) )
        draw.DrawText( v:Name()..": "..v:GetNWString("se_race", "Humans"), "se_ScoreboardFont", w / 2, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
      end
    end
  end
end

function GM:ScoreboardShow()
  net.Start("se_open_scoreboard")
  net.SendToServer()
end

net.Receive("se_open_scoreboard", function()
  local skills = net.ReadTable()
	local stars = net.ReadTable()
  se_open_scoreboard(skills, stars)
end)

function GM:ScoreboardHide()
	if IsValid(se_scoreboard) then
		se_scoreboard:Remove()
	end
	if IsValid(se_map_browser) then
		se_map_browser:Remove()
	end
end
