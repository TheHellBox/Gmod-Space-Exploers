local cooldown = 0

communication_options = {
  ShopSimple = {
    Name = "Shop",
    Text = "Welcome wanderers! Take a look on what we've got...",
    Enemy = false,
    Options = {
      BuyFuel = {
        text = "Buy fuel",
        static = true,
        events = {
          {
            event_text = "",
            resources = {
              fuel = 1,
              health = 0,
              credits = -2,
            }
          },
        },
      },
      RepairShip = {
        text = "Repair ship",
        static = true,
        events = {
          {
            event_text = "",
            resources = {
              fuel = 0,
              health = 5,
              credits = -2
            }
          },
        },
      }
    }
  },
  PirateShip = {
    Name = "Pirates",
    Text = "After doing your hyperdrive jump you face the enemy ship. The captain of their ship said some menacing phrases on language unknown to you.",
    Enemy = true,
    Options = {}
  },
  AsteroidColony = {
    Name = "Colony on asteroids",
    Text = "Welcome! We have a little bit of a problem, fuel is running out on all ships in the station, and we can't find anything around, can you help us?",
    Enemy = false,
    Options = {
      GiveFuel = {
        text = "Give fuel",
        static = false,
        events = {
          {
            event_text = "Thank you wanderers, here's your payback.",
            resources = {
              fuel = -5,
              health = 0,
              credits = 40,
            }
          },
          {
            event_text = "They were liars! After we gave fuel the signal with the station is fading out!",
            resources = {
              fuel = -5,
              health = 0,
              credits = 0,
            }
          },
        },
      },
      FlyAway = {
        text = "Deny",
        static = false,
        events = {
          {
            event_text = "Allright, we are not that mad on you.",
            resources = {
              fuel = 0,
              health = 0,
              credits = 0
            }
          },
          {
            event_text = "Captain of the colony became very mad on you, and you suddenly notice how a little rocket flew into your ship",
            resources = {
              fuel = 0,
              health = -10,
              credits = 0
            }
          },
        },
      }
    }
  },
  ShipInAsteroidBelt = {
    Name = "Ship in asteroid belt",
    Text = "After hyperjump you face a ship trying to get out of asteroid field. They said that their shields are down and they won't survive for long",
    Enemy = false,
    Options = {
      SaveShip = {
        -- Save the ship
        text = "Save the ship",
        static = false,
        events = {
          {
            event_text = "You successfully saved the ship, but after that you look pretty bad. Crew of their ship are grateful to us and they gave use some of the resources",
            resources = {
              fuel = 5,
              health = -20,
              credits = 25,
            }
          },
          {
            event_text = "You couldn't save the ship, they crashed into a huge asteroid and your communicator is fading out.",
            resources = {
              fuel = 0,
              health = -20,
              credits = 5,
            }
          },
        },
      },
      FlyAway = {
        text = "Fly away",
        static = false,
        events = {
          {
            event_text = "You left their ship alone. Who knows, maybe they will survive.",
            resources = {
              fuel = 0,
              health = 0,
              credits = 0
            }
          },
        },
      }
    }
  },
  ScienceStation = {
    Name = "Science station",
    Text = "You hear voices from your communicator. It turned out to be that this is a group of scientists who explore the effect of long space travels on humans.",
    Enemy = false,
    Options = {
      TakeAPart = {
        --
        text = "Take a part in research",
        static = false,
        events = {
          {
            --
            event_text = "Scientists are very grateful to you. They gave you some of their resources for help",
            resources = {
              fuel = 2,
              health = 0,
              credits = 10,
            }
          },
          {
            event_text = "They are not scientists! They are pirates! After you got close to them, they started shooting!",
            enemy = true,
            resources = {
              fuel = 0,
              health = 0,
              credits = 0,
            }
          },
        },
      },
      FlyAway = {
        text = "Fly away",
        static = false,
        events = {
          {
            event_text = "You deny their invite",
            resources = {
              fuel = 0,
              health = 0,
              credits = 0
            }
          },
        },
      }
    }
  },
  PiratesInAsteroids = {
    Name = "Pirate ship in asteroids",
    Text = "After hyper jump you face a pirate ship, looks like they're stuck in the asteroids. Their sheilds are down and you can destroy them",
    Enemy = false,
    Options = {
      SaveShip = {
        --
        text = "Release them from the asteroids",
        static = false,
        events = {
          {
            --
            event_text = "Pirates are very grateful to you. They gave you some of their resources for help.",
            resources = {
              fuel = 2,
              health = 0,
              credits = 10,
            }
          },
          {
            event_text = "After you released them, they attacked you!",
            enemy = true,
            resources = {
              fuel = 0,
              health = 0,
              credits = 0,
            }
          },
        },
      },
      Destroy = {
        text = "Destroy them",
        static = false,
        events = {
          {
            event_text = "You decided that the pirates are not worth saving, and you destroyed them.",
            resources = {
              fuel = 5,
              health = 0,
              credits = 20
            }
          },
          {
            event_text = "You decided that the pirates are not worth saving, and you destroyed them, but after that- their friends starting to flash on your radar.",
            enemy = true,
            resources = {
              fuel = 5,
              health = 0,
              credits = 20
            }
          },
        },
      }
    }
  },
  FireOnScienceStation = {
    Name = "Fire on the science station",
    Text = "You hear voices from your communicator. Scientists on station say that fire got out of control and their fire suppression system is not responding.",
    Enemy = false,
    Options = {
      TrySaveScientists = {
        text = "Save Scientists",
        static = false,
        events = {
          {
            event_text = "Scientists are very grateful to you. They gave you some of their resources for help",
            resources = {
              fuel = 2,
              health = -10,
              credits = 25,
            }
          },
          {
            event_text = "You coulnd't save the scientists, their door system is not respodning too and they can't enter into your ship",
            resources = {
              fuel = 0,
              health = -10,
              credits = 0,
            }
          },
          {
            event_text = "They are not scientists! They are pirates! After you got close to them, they started shooting!",
            enemy = true,
            resources = {
              fuel = 0,
              health = 0,
              credits = 0,
            }
          },
        },
      },
      FlyAway = {
        text = "Leave",
        static = false,
        events = {
          {
            event_text = "You decided to leave this station alone",
            resources = {
              fuel = 0,
              health = 0,
              credits = 0
            }
          },
        },
      }
    }
  },
  BugsAtStation = {
    Name = "Bugs At The Station",
    Text = "You hear voiced from your communicator. It turned out that the nearest station was taken bugs and crew of the station are asking for help.",
    Enemy = false,
    Options = {
      TrySavePeople = {
        text = "Save people on station",
        static = false,
        events = {
          {
            event_text = "You decided to dock with the station and save people. They are very grateful to you",
            resources = {
              fuel = 5,
              health = 0,
              credits = 30,
            }
          },
          {
            event_text = "You decided to dock with the station and save people. But when you came close to the station, all people were dead already",
            resources = {
              fuel = 1,
              health = 0,
              credits = 5,
            }
          },
        },
      },
    }
  },
}
function se_choose_comm(choose)
  if cooldown < SysTime() and !se_comm_done then
    cooldown = SysTime() + 0.5
    local event = communication_options[se_curret_comm]
    local option = event.Options[choose]
    local event = table.Random(option.events)
    if !option.static then
      se_comm_done = true
    end
    if event.enemy then
      se_create_random_enemy_ship()
    end
    if (players_spaceship.credits + event.resources.credits) >= 0 then
      players_spaceship.fuel = players_spaceship.fuel + event.resources.fuel
      players_spaceship.health = players_spaceship.health + event.resources.health
      players_spaceship.credits = players_spaceship.credits + event.resources.credits
      if players_spaceship.fuel < 0 then
        players_spaceship.fuel = 0
      end
      if players_spaceship.health < 0 then
        players_spaceship.health = 0
      end
      if players_spaceship.health > players_spaceship.max_health then
        players_spaceship.health = players_spaceship.max_health
      end
      local text_to_add = ""
      if event.event_text != "" then
        players_spaceship.modules.Communication.ent:PrintLn(event.event_text)
      end
      if event.resources.fuel != 0 then
        players_spaceship.modules.Communication.ent:PrintLn(event.resources.fuel.." fuel")
      end
      if event.resources.health != 0 then
        players_spaceship.modules.Communication.ent:PrintLn(event.resources.health.." health")
      end
      if event.resources.credits != 0 then
        players_spaceship.modules.Communication.ent:PrintLn(event.resources.credits.." credits")
      end
    else
      players_spaceship.modules.Communication.ent:PrintLn("Not enough credits")
    end
  end
end


net.Receive("send_my_team", function(len, ply)
  local team = net.ReadInt(8)
  ply:SetNWInt("wantrole", team)
end)
