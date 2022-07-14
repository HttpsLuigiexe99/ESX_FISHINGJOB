ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
RegisterNetEvent("TIGER_fishing:spawnBoat")
RegisterNetEvent("TIGER_fishing:notify")
RegisterServerEvent("TIGER_fishing:checkMoney")
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
AddEventHandler("TIGER_fishing:checkMoney", function()
			local _source = source
                        local xPlayer = ESX.GetPlayerFromId(_source)
                        local money = xPlayer.getMoney(_source)
                        if money >= 500 then
                                xPlayer.addAccountMoney(money, 1000)
                                xPlayer.removeMoney(500)
                                TriggerClientEvent("TIGER_fishing:spawnBoat", _source)  
                        else
                                TriggerClientEvent("TIGER_fishing:notify", _source, "You do ~r~not ~w~have enough money.")
                        end
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
ESX.RegisterServerCallback("TIGER_fishing:getItemAmount", function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local qtty = xPlayer.getInventoryItem(item).count
        cb(qtty)
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterServerEvent("TIGER_fishing:buyItem")
AddEventHandler("TIGER_fishing:buyItem", function(item, price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local money = xPlayer.getMoney(_source)
        if money >= price then
                xPlayer.removeMoney(price)
                xPlayer.addInventoryItem(item, 1) 
        else
                TriggerClientEvent("TIGER_fishing:notify", _source, "You do ~r~not ~w~have enough money.")
        end 
end)
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterServerEvent("TIGER_fishing:addItem")
AddEventHandler("TIGER_fishing:addItem", function(item)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.addInventoryItem(item, 1)
end)               
--------------------------------------------------TIGER DEVELOPMENT™--------------------------------------------------
RegisterServerEvent("TIGER_fishing:sellItem")
AddEventHandler("TIGER_fishing:sellItem", function(item, price)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local itemQuantity = xPlayer.getInventoryItem(item).count

        if itemQuantity > 0 then
                xPlayer.removeInventoryItem(item, itemQuantity)
                xPlayer.addMoney(price*itemQuantity)
                TriggerClientEvent("TIGER_fishing:notify", _source, "You ~g~sold ~w~" ..itemQuantity.. "~y~ " ..item.. "~w~ for $" ..price*itemQuantity..".")
        else
                TriggerClientEvent("TIGER_fishing:notify", _source, "You do not have any of this item.")
        end

end)