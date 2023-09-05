if Config.ESX == "newESX" then 
    ESX = exports["es_extended"]:getSharedObject();
else
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

backupvalue = 0
isAfkModesLoad = false
isInAfk = false
AfkInProcess = {}
TimeInProcess = 0
haveAfk = false
menuOpen = false
ModesConfig = {}

RegisterNetEvent("esx:playerLoaded", function(xPlayer) 
    TriggerServerEvent("afk:getBaseConfig")
    Wait(1000)

    local plyCoords = GetEntityCoords(PlayerPedId())
    local dist = Vdist(plyCoords, Config.AfkCoords)
    
    if dist < 50 then 
        SetEntityCoords(PlayerPedId(), Config.CoordsLogOutInZone, false, false, false, true)
        ESX.ShowNotification("Vous avez été renvoyé au spawn car vous étiez près d'ube une zone d'investissement")
    end

    TriggerServerEvent("afk:requestHaveAfk")

    Wait(1000)
    if not haveAfk then
        SendNUIMessage({
            type = "setModesAfk",
            modes = Config.AFkModes
        })
        isAfkModesLoad = true
    else
        TimeInProcess = AfkInProcess.time
        for k, v in pairs(Config.AFkModes) do 
            if v.id == AfkInProcess.afkid then 
                AfkInProcess = v
            end
        end
        AfkInProcess.hours = TimeInProcess

        SendNUIMessage({
            type = "setAfk",
            afk = AfkInProcess
        })
        isAfkModesLoad = true
    end
end)

RegisterNetEvent("onResourceStart", function(resourceName) 
    if resourceName == GetCurrentResourceName() then 
        TriggerServerEvent("afk:getBaseConfig")

        TriggerServerEvent("afk:requestHaveAfk")

        Wait(2000)

        if not haveAfk then
            SendNUIMessage({
                type = "setModesAfk",
                modes = Config.AFkModes
            })
            isAfkModesLoad = true
        else
            TimeInProcess = AfkInProcess.time
            
            for k, v in pairs(Config.AFkModes) do 
                if v.id == AfkInProcess.afkid then 
                    AfkInProcess = v
                end
            end

            AfkInProcess.hours = TimeInProcess

            SendNUIMessage({
                type = "setAfk",
                afk = AfkInProcess
            })
            isAfkModesLoad = true
        end
    end
end)

RegisterNetEvent("afk:receiveHaveAfk", function(afk) 
    haveAfk = true
    AfkInProcess = afk
end)

RegisterNuiCallback("hideUI", function() 
    DisplayRadar(true)
    SetNuiFocus(false, false)
    menuOpen = false
end)

RegisterNuiCallback("showUI", function() 
    DisplayRadar(false)
    SetNuiFocus(true, true)
    menuOpen = true
end)

RegisterNuiCallback("goToAfk", function(afk)
    startAfk(afk)
end)

RegisterNuiCallback("afkstart", function(data) 
    TriggerServerEvent("afk:startAfk", data)
    haveAfk = true
    AfkInProcess = data

    TimeInProcess = AfkInProcess.ElementSelected.hours

    for k, v in pairs(Config.AFkModes) do 
        if v.id == data.ElementSelected.id then 
            AfkInProcess = v
        end
    end

    AfkInProcess.hours = TimeInProcess * 60

    SendNUIMessage({
        type = "setAfk",
        afk = AfkInProcess
    })
    
    startAfk(AfkInProcess)
end)

RegisterCommand("afk", function(source, args) 
    local plyCoords = GetEntityCoords(PlayerPedId())

    if isAfkModesLoad then
        if not menuOpen then
            for k, v in pairs(Config.AfkZonesToStart) do 
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v)

                if dist < 25 then
                    SendNUIMessage({
                        type = "showUI",
                    })

                    TriggerServerEvent("afk:refreshTopLeader")
                else
                    ESX.ShowNotification("Vous ne pouvez pas faire celui-ci")
                end
            end
        end
    end
end)

startAfk = function()
    lastCoords = GetEntityCoords(PlayerPedId())
    SetEntityCoords(PlayerPedId(), Config.AfkCoords, false, false, false, true)
    isInAfk = true
    SendNUIMessage({
        type = "showAfkTimer",
        timer = AfkInProcess.hours,
    })
    startAfkWhile()
    startAfkTimer()
end

startAfkWhile = function()
    Citizen.CreateThread(function() 
        while isInAfk do
            timer = 0
            local weapon = GetCurrentPedWeapon(PlayerPedId(), 1)
    
            if weapon ~= "WEAPON_UNARMED" then 
                SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
            end
            
            if IsControlJustPressed(0, 357) then 
                TriggerServerEvent("afk:updateAfkTimer", AfkInProcess.hours)
                SetEntityCoords(PlayerPedId(), lastCoords, false, false, false, true)
                isInAfk = false
                SendNUIMessage({
                    type = "setAfk",
                    afk = AfkInProcess
                })
                SendNUIMessage({
                    type = "hideAfkTimer",
                })
                break
            end
    
            for k, v in pairs(Config.KeysDisable) do 
                DisableControlAction(0, v, true)
            end
    
            Wait(timer)
        end
    end)
end

startAfkTimer = function()
    Citizen.CreateThread(function() 
        while isInAfk do
            Wait(60000)
            backupvalue = backupvalue + 1
            
            if AfkInProcess.hours then 
                AfkInProcess.hours = AfkInProcess.hours - 1
            end

            if tonumber(backupvalue) == tonumber(Config.TimerBackUpServerRegister) then 
                backupvalue = 0

                TriggerServerEvent("afk:updateAfkTimer", AfkInProcess.hours)
            end

            if AfkInProcess.hours == 0 then 

                isInAfk = false
                TimeInProcess = 0
                haveAfk = false
                Config.AFkModes = ModesConfig

                for k, v in ipairs(Config.AFkModes) do 
                    if v.id == AfkInProcess.id then 
                        AfkInProcess = v
                    end
                end

                TriggerServerEvent("afk:terminate", AfkInProcess)
                AfkInProcess = {}

                SendNUIMessage({
                    type = "afkTerminate"
                })

                Wait(100)

                SendNUIMessage({
                    type = "hideAfkTimer",
                })

                SendNUIMessage({
                    type = "setModesAfk",
                    modes = Config.AFkModes
                })

                SetEntityCoords(PlayerPedId(), lastCoords, false, false, false, true)
                break
            end

            SendNUIMessage({
                type = "updateAfkTimer",
                timer = AfkInProcess.hours,
            })
        end
    end)
end

RegisterNetEvent("afk:receiveBaseConfig", function(config) 
    ModesConfig = config
end)

RegisterNetEvent("afk:refreshclTop", function(topAfk) 
    SendNUIMessage({
        type = "refreshLeader",
        data = topAfk,
    })
end)