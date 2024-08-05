Config = {}

Config.Debug = true

Config.Notification = 'ox' -- ox , qb
Config.Progress = 'ox'     -- ox , qb

Config.TruckSpawn = vec4(200.51, 2797.27, 45.66, 94.79)

Config.BossPed = {
    model = `s_m_m_trucker_01`,
    coords = vec4(180.04, 2793.09, 45.66, 281.44)
}

Config.Trucks = {
    { minRep = 0, model = `hauler`, rentCost = 500 },
    { minRep = 10, model = `phantom`, rentCost = 1500 },
}

-- Will Set The Inv For You
AddEventHandler("onResourceStart", function()
    Wait(2000)
    if GetResourceState('ox_inventory') == 'started' then
        Config.Inventory = 'ox'
    elseif GetResourceState('qb-inventory') == 'started' then
        Config.Inventory = 'qb'
    end
end)