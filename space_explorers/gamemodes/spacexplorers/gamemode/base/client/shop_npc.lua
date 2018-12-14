net.Receive("se_open_npc_shop", function()
  local ent = net.ReadEntity()
  local shop = net.ReadTable()
  local credits = net.ReadInt(32)

  local se_shop_main = vgui.Create( "DFrame" )
  se_shop_main:SetSize(400, 600)
  se_shop_main:Center()
  se_shop_main:SetDraggable( true )
  se_shop_main:MakePopup()
  se_shop_main:SetTitle( "Shop" )
  function se_shop_main:Paint(w, h)
    draw.RoundedBox( 5, 0, 0, w, h, Color(50, 50, 50, 250) )
  end

  local DLabel = vgui.Create( "DLabel", se_shop_main )
  DLabel:SetSize(400, 50)
  DLabel:Dock(TOP)
  DLabel:SetContentAlignment(5)
  DLabel:SetText( credits.." credits" )
  DLabel:SetFont("se_ScoreboardFont")
  DLabel:SetColor(Color(255, 255, 255))

  for k, item in pairs(shop) do
    local se_shop_btn = vgui.Create( "DButton", se_shop_main )
    se_shop_btn:SetText("")
    se_shop_btn:SetSize(350, 40)
    se_shop_btn:DockMargin( 10, 10, 10, 0 )
    se_shop_btn:Dock(TOP)
    function se_shop_btn:Paint(w, h)
      if self.Hovered then
        draw.RoundedBox( 5, 0, 0, w, h, Color(80, 80, 80, 255) )
      else
        draw.RoundedBox( 5, 0, 0, w, h, Color(30, 30, 30, 255) )
      end
      draw.DrawText( item.Name.." / "..item.Price.." credits", "se_ScoreboardFont", w / 2, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
    end
    function se_shop_btn:OnMousePressed()
      if credits >= item.Price then
        net.Start("se_buy_item")
        net.WriteEntity(ent)
        net.WriteInt(k, 8)
        net.SendToServer()
        credits = credits - item.Price
        DLabel:SetText( credits.." credits" )
      end
    end
  end
end)
