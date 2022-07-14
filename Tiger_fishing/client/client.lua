ESX          = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
local fishing_starter = false

Citizen.CreateThread(function()
    for i = 1, #config.fishingStarterLocation, 1 do
        loc = config.fishingStarterLocation[i]  
        fishing_blip = AddBlipForCoord(loc.pos.x, loc.pos.y, loc.pos.z)
            SetBlipSprite(fishing_blip, 68)
            SetBlipColour(fishing_blip, 29)
            SetBlipDisplay(fishing_blip, 2)
            SetBlipScale(fishing_blip, 1.01)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Negozio di pesca")
            EndTextCommandSetBlipName(fishing_blip)
        for k,v in ipairs(config.ped) do
            fish_sell_blip = AddBlipForCoord(v[4].x, v[4].y,  v[4].z)
                SetBlipSprite(fish_sell_blip, -0)
                SetBlipColour(fish_sell_blip, 5)
                SetBlipDisplay(fish_sell_blip, 2)
                SetBlipScale(fish_sell_blip, 1.01)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Vendita pesce")
                EndTextCommandSetBlipName(fish_sell_blip)
        end
    end
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            for i = 1, #config.fishingStarterLocation, 1 do
                loc = config.fishingStarterLocation[i]  
                local playerCoord = GetEntityCoords(PlayerPedId(), false)
                local locVector = vector3(loc.pos.x, loc.pos.y, loc.pos.z)
                if Vdist2(playerCoord, locVector) < loc.scale*100.12 then
                    DrawMarker(loc.marker, loc.pos.x, loc.pos.y, loc.pos.z-0.90, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, loc.scale, loc.scale, loc.scale, loc.rgba[1], loc.rgba[2], loc.rgba[3], loc.rgba[4], false, true, 2, nil, nil, false)
                    if Vdist2(playerCoord, locVector) < loc.scale*1.12 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                        ESX.ShowHelpNotification('Premi ~INPUT_CONTEXT~ per noleggiare una barca ~r~500$')
                        if IsControlJustReleased(0, 46) then 
                            OpenFishingMenu()   
                        end
                    end
                end
            end
        end
    end
)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
function OpenFishingMenu()
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fishing',
        {
            title    = 'Negozio di pesca',
            elements = {
                {label = 'Acquista una canna da pesca ($'..config.item_fishingRod.price..')', value = 'buyFishingrod'},
                {label = 'Noleggia una barca ($'..config.boatRent_price..')', value = 'rentBoat'},
            }
        },
        function(data, menu)
            if data.current.value == 'buyFishingrod' then
                TriggerServerEvent("TIGER_fishing:buyItem", config.item_fishingRod.name, config.item_fishingRod.price)
            elseif data.current.value == 'rentBoat' then
                TriggerServerEvent("TIGER_fishing:checkMoney")
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterNetEvent("TIGER_fishing:spawnBoat")
AddEventHandler("TIGER_fishing:spawnBoat", function()
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback("TIGER_fishing:getItemAmount", function(qtty)
        if qtty > 0 then
            fishing_starter = true
            for i = 1, #config.fishingStarterLocation, 1 do
                loc = config.fishingStarterLocation[i]  
                SetEntityCoords(PlayerPedId(), loc.tpto.x, loc.tpto.y, loc.tpto.z, true, true, true, false)
                Citizen.Wait(5)
                TriggerEvent('esx:spawnVehicle', config.boat)
                TriggerEvent("TIGER_fishing:notify", _source, "Boat rented.")
                SetEntityHeading(PlayerPedId(), 0) 
                fishing_area_blip = AddBlipForCoord(config.fishing_area.x, config.fishing_area.y, config.fishing_area.z)
                    SetBlipSprite(fishing_area_blip, 404)
                    SetBlipColour(fishing_area_blip, 29)
                    SetBlipDisplay(fishing_area_blip, 2)
                    SetBlipScale(fishing_area_blip, 1.60)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Area di pesca")
                    EndTextCommandSetBlipName(fishing_area_blip)  
            end 
        else
          ESX.ShowNotification("You do not have a fishing rod.")
        end
end, config.item_fishingRod.name)           
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if fishing_starter == true then
            Citizen.Wait(1)
            ESX.ShowHelpNotification("Recati nella zona di pesca indicata sulla mappa per pescare buona fortuna")
            local playerCoord = GetEntityCoords(PlayerPedId(), false)
            if(Vdist(playerCoord.x, playerCoord.y, playerCoord.z, config.fishing_area.x, config.fishing_area.y, config.fishing_area.z) < 300) then
                ESX.ShowHelpNotification("Ferma la tua barca sei nell\'area di pesca", false, false)
                if not IsPedInAnyVehicle(PlayerPedId(), false) and fishing_starter == true then
                    ESX.ShowHelpNotification("Premi~INPUT_CONTEXT~ per pescare", false, false)
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("TIGER_fishing:startFishing")
                        ClearHelp(true)
                    end
                end
            end
        end
    end
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for i = 1, #config.vehicleDeleterMarker, 1 do
            vehicleDeleterloc = config.vehicleDeleterMarker[i]
            if fishing_starter == true then
                local playerCoord = GetEntityCoords(PlayerPedId(), false)
                local vehicleDeleterVector = vector3(vehicleDeleterloc.pos.x, vehicleDeleterloc.pos.y, vehicleDeleterloc.pos.z)
                if Vdist2(playerCoord, vehicleDeleterVector) < loc.scale*100.12 then
                    DrawMarker(vehicleDeleterloc.marker, vehicleDeleterloc.pos.x, vehicleDeleterloc.pos.y, vehicleDeleterloc.pos.z-0.75, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, vehicleDeleterloc.scale, vehicleDeleterloc.scale, vehicleDeleterloc.scale, vehicleDeleterloc.rgba[1], vehicleDeleterloc.rgba[2], vehicleDeleterloc.rgba[3], vehicleDeleterloc.rgba[4], false, true, 2, nil, nil, false)
                    if Vdist2(playerCoord, vehicleDeleterVector) < loc.scale*1.12 then
                        ClearHelp(true)
                        ESX.ShowHelpNotification("Premi ~INPUT_CONTEXT~ per smettere di pescare", false, false)
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent("TIGER_fishing:endFishing")
                            ClearHelp(true)
                        end
                    end
                end
            end
        end
    end
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterNetEvent("TIGER_fishing:startFishing")
AddEventHandler("TIGER_fishing:startFishing", function()
    fishing_starter = false
    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_STAND_FISHING", 0, true)
    local time_until_catch = math.random(config.fishing_time.value_1, config.fishing_time.value_2)
    local fish_type = math.random(0,3)
    local canna_da_pesca = math.random(0,2)
    Citizen.Wait(time_until_catch)
    ESX.ShowHelpNotification("Ne hai uno!")
    Citizen.Wait(3500)
        ClearPedTasks(GetPlayerPed(-1))
        if fish_type == 0 then 
            ClearHelp(true)
            ESX.ShowHelpNotification("L'hai perso!")
            Citizen.Wait(3500)
            fishing_starter = true
        elseif fish_type == 1 then
            ClearHelp(true) 
            ESX.ShowHelpNotification("Ottimo lavoro hai preso " ..config.item_1.label.. ".")
            TriggerServerEvent("TIGER_fishing:addItem", config.item_1.name)
            Citizen.Wait(3500)
            fishing_starter = true
        elseif fish_type == 2 then
            ClearHelp(true)
            ESX.ShowHelpNotification("Ottimo lavoro hai preso " ..config.item_2.label.. ".")
            TriggerServerEvent("TIGER_fishing:addItem", config.item_2.name)
            Citizen.Wait(3500)
            fishing_starter = true
        elseif fish_type == 3 then 
            ClearHelp(true)
            ESX.ShowHelpNotification("Ottimo lavoro hai preso " ..config.item_3.label.. ".")
            TriggerServerEvent("TIGER_fishing:addItem", config.item_3.name)
            Citizen.Wait(3500)
            canna_da_pesca = math.random(0,2)
            Citizen.Wait(1)
            if canna_da_pesca == 0 then
                Citizen.Wait(3500)
                ClearHelp(true)
                ESX.ShowHelpNotification("Hai rotto la tua lenza da pesca devi ripararla.")
                Citizen.Wait(3500)
                TriggerEvent("TIGER_fishing:repairFishingrod")
            elseif canna_da_pesca == 1 or canna_da_pesca == 2 then
                ClearHelp(true)
                fishing_starter = true
            end
        end
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterNetEvent("TIGER_fishing:endFishing")
AddEventHandler("TIGER_fishing:endFishing", function()
        fishing_starter = false
        vehicle = ESX.Game.GetClosestVehicle()
        ESX.Game.DeleteVehicle(vehicle)
        RemoveBlip(fishing_area_blip)
        for i = 1, #config.fishingStarterLocation, 1 do
            loc = config.fishingStarterLocation[i]  
            SetEntityCoords(PlayerPedId(), loc.pos.x, loc.pos.y, loc.pos.z, true, true, true, false)
        end
end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            for k,v in ipairs(config.ped) do  
                local playerCoord = GetEntityCoords(PlayerPedId(), false)
                loc = vector3(v[4].x, v[4].y, v[4].z)
                if Vdist2(playerCoord, loc) < 4.00*1.12 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                        ESX.ShowHelpNotification('Premi ~INPUT_CONTEXT~ per vendere il pesce')
                        if IsControlJustReleased(0, 46) then 
                            OpenSellMenu()   
                        end
                end
            end
        end
    end
)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
function OpenSellMenu()
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fishing',
        {
            title    = 'Vendita pesce',
            elements = {
                {label = 'Prezzo ' ..config.item_1.label.. ' ($'..config.item_1.price..')', value = 'sellitem1'},
                {label = 'Prezzo  ' ..config.item_2.label.. ' ($'..config.item_2.price..')', value = 'sellitem2'},
                {label = 'Prezzo  ' ..config.item_3.label.. ' ($'..config.item_3.price..')', value = 'sellitem3'},
            }
        },
        function(data, menu)
            if data.current.value == 'sellitem1' then
                TriggerServerEvent("TIGER_fishing:sellItem", config.item_1.name, config.item_1.price)
            elseif data.current.value == 'sellitem2' then
                TriggerServerEvent("TIGER_fishing:sellItem", config.item_2.name, config.item_2.price)
            elseif data.current.value == 'sellitem3' then
                TriggerServerEvent("TIGER_fishing:sellItem", config.item_3.name, config.item_3.price)
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterNetEvent("TIGER_fishing:repairFishingrod")
AddEventHandler("TIGER_fishing:repairFishingrod", function()
        TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        exports['progressBars']:startUI(15000, "Riparando la lenza...")
        Citizen.Wait(15000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        fishing_starter = true
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterNetEvent("TIGER_fishing:notify")
AddEventHandler("TIGER_fishing:notify", function(str)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandThefeedPostTicker(true, false)
end)