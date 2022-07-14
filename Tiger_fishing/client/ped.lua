Citizen.CreateThread(function()

    while true do
        Citizen.Wait(200)

        for k,v in ipairs(config.ped) do

            if not DoesEntityExist(v[1]) then
                RequestModel(v[2])

                while not HasModelLoaded(v[2]) do
                    Citizen.Wait(200)
                end
                config.ped[k][1] = CreatePed(4, v[2], v[4].x, v[4].y, v[4].z, 295.1, v[5])

                SetEntityAsMissionEntity(config.ped[k][1])
                FreezeEntityPosition(config.ped[k][1], true)
                SetBlockingOfNonTemporaryEvents(config.ped[k][1], true)
                SetEntityInvincible(config.ped[k][1], true)
                TaskStartScenarioInPlace(config.ped[k][1], v[6])

                SetModelAsNoLongerNeeded(v[2])
            end

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v[4].x, v[4].y, v[4].z)

            if dist < 3 then
                v[7] = true
            else
                v[7] = false
            end
        end
    end
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in ipairs(config.ped) do
            if v[7] then
                ESX.Game.Utils.DrawText3D({x=v[4].x, y=v[4].y, z=v[4].z+2.0}, v[3], 1.0)
            end
        end
    end
end)