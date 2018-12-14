function se_find_close_star(from, expect)
  local highest = 10000
  local star = nil
  for k, v in pairs( se_star_map.stars ) do
    if ( Vector(from.pos[1], from.pos[2]):Distance(Vector(v.pos[1], v.pos[2])) < highest ) then
      if v != from and !table.HasValue(expect, v) then
        star = k
        highest = Vector(from.pos[1], from.pos[2]):Distance(Vector(v.pos[1], v.pos[2]))
      end
    end
  end
  return star
end

function se_gen_star_map()
  se_star_map = {}
  se_star_map.stars = {}
  se_star_map.player_pos = 1
  se_star_map.star_choosed = -1
  for k=0, math.random(3, 12) do
    local star = {
      pos = {math.random(0, 100), math.random(0, 100)},
      type = "Unknow",
      connects_to = {},
      close = false
    }
    if math.random(0, 10) > 8 then
      star.type = "Shop"
    end
    if math.random(0, 10) > 8 then
      star.type = "Station"
    end
    table.insert(se_star_map.stars, star)
  end
  -- Connecting stars to each other
  local star = 1
  local stars = {}
  local iters = 0
  se_star_map.stars[se_star_map.player_pos].explored = true
  se_star_map.stars[se_star_map.player_pos].type = "Unknow"
  while true do
    iters = iters + 1
    if iters > 100 then
      print("Anti bug system detected something horrible at se_gen_star_map()! Please report this to the developer before craken destroy you")
      break
    end
    local star_old = star
    star = se_find_close_star(se_star_map.stars[star], stars)
    if star != nil then
      table.insert(se_star_map.stars[star_old].connects_to, star )
      table.insert(se_star_map.stars[star].connects_to, star_old )
      table.insert(stars, se_star_map.stars[star])
    else
      break
    end
  end
  se_star_map.stars[#se_star_map.stars].type = "Exit"
end

net.Receive("se_choose_star", function(_, ply)
  local indx = net.ReadInt(8)
  if table.HasValue(se_star_map.stars[indx].connects_to, se_star_map.player_pos) then
    se_star_map.star_choosed = indx
  end
end)

net.Receive("se_jump_to_next_sector", function(_, ply)
  if se_star_map.stars[se_star_map.player_pos].type == "Exit" then
    se_fractions.Mission = false
    se_gen_star_map()
  end
end)
