-- Global variables
G_livesRemaining = 50

function OnStartTouch(key)

    --print(key.activator) --The entity that triggered the event to happen
    --print(key.caller) -- The entity that called for the event to happen

    killEntity(key.activator)

end

function killEntity(key)

    unitName = key:GetUnitName() -- Retrieves the name that the unit has, such as listed in "npc_units_custom.txt"

    print("Unit '" .. unitName .. "' has entered the killbox")

    if (key:IsOwnedByAnyPlayer() ) then -- Checks to see if the entity is a player controlled unit
            print("Is player owned - Ignore")

    else
        print("Is not owned by player - Terminate")
        key:ForceKill(true) -- Kills the unit
        G_livesRemaining = G_livesRemaining - 1

        local livesRemainingString = "<font color='#f2ab37'>" .. G_livesRemaining .. " lives remaining.</font>"
        GameRules:SendCustomMessage(livesRemainingString,0,0)
        print("Lives remaining: ", G_livesRemaining)
        if G_livesRemaining == 0 then
          GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        end
    end

end