local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local cfg = Config

local bossPed
local clipboard
local curTruck

local function SpawnBoss()

  RequestModel(cfg.BossPed.model)
  while (not HasModelLoaded(cfg.BossPed.model)) do Citizen.Wait(1) RequestModel(cfg.BossPed.model) end

  bossPed = CreatePed(1, cfg.BossPed.model, cfg.BossPed.coords.x, cfg.BossPed.coords.y, cfg.BossPed.coords.z - 1,
  cfg.BossPed.coords.w, false, false)
  FreezeEntityPosition(bossPed, true)
  SetEntityInvincible(bossPed, true)
  SetBlockingOfNonTemporaryEvents(bossPed, true)
end

local function SpawnTruck(model, cost)
    curTruck = CreateVehicle(model, cfg.TruckSpawn.x, cfg.TruckSpawn.y, cfg.TruckSpawn.z, cfg.TruckSpawn.w,
    true, false)

    TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(curTruck))
    TriggerServerEvent('tw-truckjob:server:RemoveMoney', cost)
end

local function SelectTruck(model, cost)
  local animDict = "missfam4"

  print('SelectTruck Passed')

  RequestAnimDict(animDict)
  while (not HasAnimDictLoaded(animDict)) do Citizen.Wait(1) print('loop 1') RequestAnimDict(animDict) end

  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)

  local clipboardModel = `p_amb_clipboard_01`
  RequestModel(clipboardModel)
  while (not HasModelLoaded(clipboardModel)) do Citizen.Wait(1) print('loop 2') RequestModel(clipboardModel) end
  clipboard = CreateObject(clipboardModel, coords.x, coords.y, coords.z, false, false, false)

  TaskPlayAnim(ped, animDict, "base", 2.0, 2.0, 50000000, 51, 0, false, false, false)

  AttachEntityToEntity(clipboard, ped, GetPedBoneIndex(ped, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)

  if lib.progressCircle({
      duration = 2000,
      label = 'Signing Out Truck',
      position = 'bottom',
      useWhileDead = false,
      canCancel = true,
      disable = {
          move = true,
      },
      anim = {},
      prop = {},
    })
  then
    DeleteEntity(clipboard)
    ClearPedTasks(ped)
    
    SpawnTruck(model, cost)

  else print('Do stuff when cancelled') end
end

Citizen.CreateThread(function()
  SpawnBoss()
  
  exports.ox_target:addLocalEntity(bossPed, {
    name = 'boss_target',
    label = 'Trucker Boss',
    icon = "fa-solid fa-truck-moving",

    onSelect = function ()
      TriggerEvent('tw-truckjob:client:InteractWithBoss')
    end

  })

end)

RegisterNetEvent('tw-truckjob:client:InteractWithBoss', function ()
  lib.showContext('trucker_menu')
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

    if Config.Debug then
        DeleteEntity(curTruck)
    end

  DeleteEntity(bossPed)
  DeleteEntity(clipboard)

end)

lib.registerContext({
  id = 'trucker_menu',
  title = 'Trucker Job',
  options = {
    {
      title = 'Trucking Rep',
      progress = PlayerData.metadata['rep']["trucker"]
    },
    {
      title = 'Truck One',
      description = 'The Base Truck',
      icon = 'fa-truck-moving',
      onSelect = function()
        SelectTruck(Config.Trucks[1].model, Config.Trucks[1].rentCost)
      end,
    },
    {
      title = 'Truck Two',
      description = 'The Base Truck',
      icon = 'fa-truck-moving',
      onSelect = function()
        SpawnTruck(Config.Trucks[2].model, Config.Trucks[2].rentCost)
      end,
    },
  }
})


