-- Global variables used in multiple functions
G_count = 0
G_creepsSpawned = {}

function SpawnCreeps()
  local creepsSpawned= {}
  local point = Entities:FindByName(nil,"spawnerino"):GetAbsOrigin()
  local waypoint = Entities:FindByName(nil,"waypoint"):GetAbsOrigin()
  local units_to_spawn = 10
  for i=1, units_to_spawn do
    Timers:CreateTimer(function()
      local unit = CreateUnitByName("sheep", point+RandomVector(RandomInt(100,200)), true, nil, nil, DOTA_TEAM_NEUTRALS)
      ExecuteOrderFromTable({ UnitIndex = unit:GetEntityIndex(),
                              OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                              Position = waypoint, Queue = true})

      -- Global list of spawned creeps
      G_creepsSpawned[i] = unit:GetEntityIndex()
      -- Global count for number of spawned creeps
      G_count = G_count + 1

      -- Stuff to help me debug...
      -- if G_count == 10 then
      --   TrackDeadUnits()
      -- end

      print("Move ", unit:GetEntityIndex(), " to ", waypoint)

    end)
  end
end

-- My function to help debug...
-- function TrackDeadUnits()
--   print("Creeps currently alive: ", G_count)
--   for k,v in pairs(G_creepsSpawned) do
--     print(k,v)
--   end
-- end

-- Checks if entity that dies is in the global list of spawned creeps
function CheckIfCreep(entindex_killed)
  local entity_id = entindex_killed

  for __, value in pairs(G_creepsSpawned) do
    if value == entity_id then
      CreepsLeft(entity_id)
    end
  end
end

-- Decrements global count if creep dies 
function CreepsLeft(entindex_killed)
  local entity_id = entindex_killed
  print(entity_id, " has died")
  G_count = G_count - 1
  print("Creeps currently alive: ", G_count)

  -- when global count == 0 then spawn creeps in 5 seconds
  if G_count == 0 then
    Timers:CreateTimer(5, 
      function()
        SpawnCreeps()
      end)
  end
end