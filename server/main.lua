local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('tw-truckjob:server:RemoveMoney', function (cost)
    src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.GetMoney("bank") > cost then
        Player.Functions.RemoveMoney("bank", cost)
    elseif Player.Functions.GetMoney("cash") > cost then
        Player.Functions.RemoveMoney("cash", cost)
    else
        print('you r broke')
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

end)
