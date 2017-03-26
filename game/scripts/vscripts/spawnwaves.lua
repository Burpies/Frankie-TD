-- Global variables used in multiple functions
G_creepCount = 0
G_listOfCreepsAlive = {}
G_wave = 1

function SpawnCreeps()
  local creepsSpawned= {}
  local point = Entities:FindByName(nil,"spawnerino"):GetAbsOrigin()
  local waypoint = Entities:FindByName(nil,"waypoint"):GetAbsOrigin()
  local units_to_spawn = 10
  if G_wave == 1 then
    for i=1, units_to_spawn do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("sheep", point+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
        ExecuteOrderFromTable({ UnitIndex = unit:GetEntityIndex(),
                                OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                                Position = waypoint, Queue = true})

        -- Global list of spawned creeps
        G_listOfCreepsAlive[i] = unit:GetEntityIndex()
        -- Global count for number of spawned creeps
        G_creepCount = G_creepCount + 1

        if G_creepCount == 10 then
          G_wave = 2
        end
        
        -- Stuff to help me debug...
        -- if G_creepCount == 10 then
        --   TrackDeadUnits()
        -- end

        print("Move ", unit:GetEntityIndex(), " to ", waypoint)

      end)
    end
  end

  if G_wave == 2 then
    for i=1, units_to_spawn do
      Timers:CreateTimer(function()
        local unit = CreateUnitByName("pigs", point+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
        ExecuteOrderFromTable({ UnitIndex = unit:GetEntityIndex(),
                                OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                                Position = waypoint, Queue = true})

        -- Global list of spawned creeps
        G_listOfCreepsAlive[i] = unit:GetEntityIndex()
        -- Global count for number of spawned creeps
        G_creepCount = G_creepCount + 1

        if G_creepCount == 10 then
          G_wave = 1
        end
        -- Stuff to help me debug...
        -- if G_creepCount == 10 then
        --   TrackDeadUnits()
        -- end

        print("Move ", unit:GetEntityIndex(), " to ", waypoint)

      end)
    end
  end

end

-- My function to help debug...
-- function TrackDeadUnits()
--   print("Creeps currently alive: ", G_creepCount)
--   for k,v in pairs(G_listOfCreepsAlive) do
--     print(k,v)
--   end
-- end

-- Checks if entity that dies is in the global list of spawned creeps
function CheckIfCreep(entindex_killed)
  local entity_id = entindex_killed

  for __, value in pairs(G_listOfCreepsAlive) do
    if value == entity_id then
      CreepsRemaining(entity_id)
    end
  end
end

-- Decrements global count if creep dies 
function CreepsRemaining(entindex_killed)
  local entity_id = entindex_killed
  print(entity_id, " has died")
  G_creepCount = G_creepCount - 1
  print("Creeps currently alive: ", G_creepCount)

  -- when global count == 0 then spawn creeps in 5 seconds
  if G_creepCount == 0 then
    Timers:CreateTimer(5, 
      function()
        SpawnCreeps()
      end)
  end
end