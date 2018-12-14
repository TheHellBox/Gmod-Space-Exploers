GM.Version = "0.1.0"
GM.Name = "Space Explorers"
GM.Author = "The HellBox"

DeriveGamemode("base")

include("base/client/ship_state_update.lua")
include("base/client/race_choose_menu.lua")
include("base/client/draw_space_body.lua")
include("base/client/ship_uis.lua")
include("base/client/hud.lua")

include("lib/draw.lua")
include("lib/support.lua")

hook.Add( "CreateClientsideRagdoll", "se_fade_out_corpses", function( entity, ragdoll )
  timer.Simple(10, function()
    if IsValid(ragdoll) then
	   ragdoll:SetSaveValue( "m_bFadingOut", true )
    end
  end)
end )
