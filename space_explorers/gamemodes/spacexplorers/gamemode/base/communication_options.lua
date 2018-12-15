local cooldown = 0

function se_init_comms()
  communication_options = {
    ShopSimple = {
      Name = "Shop",
      Text = se_language[se_settings.language]["BuyFuelMain"],
      Enemy = false,
      Options = {
        BuyFuel = {
          text = se_language[se_settings.language]["BuyFuel"],
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
          text = se_language[se_settings.language]["RepairShip"],
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
      Text = se_language[se_settings.language]["PirateShip"],
      Enemy = true,
      Options = {}
    },
    AsteroidColony = {
      Name = "Colony on asteroids",
      Text = se_language[se_settings.language]["AsteroidColonyMain"],
      Enemy = false,
      Options = {
        GiveFuel = {
          text = se_language[se_settings.language]["Givefuel"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["AsteroidColonyThanks"],
              resources = {
                fuel = -5,
                health = 0,
                credits = 40,
              }
            },
            {
              event_text = se_language[se_settings.language]["AsteroidColonyLie"],
              resources = {
                fuel = -5,
                health = 0,
                credits = 0,
              }
            },
          },
        },
        FlyAway = {
          text = se_language[se_settings.language]["Deny"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["AsteroidColonyNotMad"],
              resources = {
                fuel = 0,
                health = 0,
                credits = 0
              }
            },
            {
              event_text = se_language[se_settings.language]["AsteroidColonyMad"],
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
      Text = se_language[se_settings.language]["ShipInAsteroidBelt"],
      Enemy = false,
      Options = {
        SaveShip = {
          -- Save the ship
          text = se_language[se_settings.language]["SaveShip"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["ShipInAsteroidBeltSaved"],
              resources = {
                fuel = 5,
                health = -20,
                credits = 25,
              }
            },
            {
              event_text = se_language[se_settings.language]["ShipInAsteroidBeltNotSaved"],
              resources = {
                fuel = 0,
                health = -20,
                credits = 5,
              }
            },
          },
        },
        FlyAway = {
          text = se_language[se_settings.language]["FlyAway"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["ShipInAsteroidBeltFlyAway"],
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
      Text = se_language[se_settings.language]["ScienceStationMain"],
      Enemy = false,
      Options = {
        TakeAPart = {
          --
          text = se_language[se_settings.language]["TakeAPart"],
          static = false,
          events = {
            {
              --
              event_text = se_language[se_settings.language]["ScienceStationMainTakeAPart"],
              resources = {
                fuel = 2,
                health = 0,
                credits = 10,
              }
            },
            {
              event_text = se_language[se_settings.language]["ScienceStationMainPirates"],
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
          text = se_language[se_settings.language]["FlyAway"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["DebyInvite"],
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
      Text = se_language[se_settings.language]["PiratesInAsteroidsMain"],
      Enemy = false,
      Options = {
        SaveShip = {
          --
          text = se_language[se_settings.language]["SavePirateShip"],
          static = false,
          events = {
            {
              --
              event_text = se_language[se_settings.language]["PiratesInAsteroidsGrateful"],
              resources = {
                fuel = 2,
                health = 0,
                credits = 10,
              }
            },
            {
              event_text = se_language[se_settings.language]["PiratesInAsteroidsAttack"],
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
          text = se_language[se_settings.language]["DestroyThem"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["PiratesInAsteroidsAttackDestroyThem"],
              resources = {
                fuel = 5,
                health = 0,
                credits = 20
              }
            },
            {
              event_text = se_language[se_settings.language]["PiratesInAsteroidsAttackDestroyThemFriends"],
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
      Text = se_language[se_settings.language]["FireOnScienceStationMain"],
      Enemy = false,
      Options = {
        TrySaveScientists = {
          text = se_language[se_settings.language]["TrySaveScientists"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["FireOnScienceStationMainTrySaveScientistsGr"],
              resources = {
                fuel = 2,
                health = -10,
                credits = 25,
              }
            },
            {
              event_text = se_language[se_settings.language]["FireOnScienceStationMainTrySaveScientistsFail"],
              resources = {
                fuel = 0,
                health = -10,
                credits = 0,
              }
            },
            {
              event_text = se_language[se_settings.language]["FireOnScienceStationMainTrySaveScientistsPirates"],
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
          text = se_language[se_settings.language]["Leave"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["FireOnScienceStationMainLeave"],
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
      Text = se_language[se_settings.language]["BugsAtStationMain"],
      Enemy = false,
      Options = {
        TrySavePeople = {
          text = se_language[se_settings.language]["FireOnScienceTrySavePeople"],
          static = false,
          events = {
            {
              event_text = se_language[se_settings.language]["FireOnScienceTrySavePeopleDock"],
              resources = {
                fuel = 5,
                health = 0,
                credits = 30,
              }
            },
            {
              event_text = se_language[se_settings.language]["FireOnScienceTrySavePeopleDockDead"],
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
end
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
