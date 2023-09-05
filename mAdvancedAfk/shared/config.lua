Config = {}

Config.ESX = "newESX" --newESX or oldESX

if Config.ESX == "newESX" then 
    ESX = exports["es_extended"]:getSharedObject();
else
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

Config.AfkCoords = vector3(-2004.145, 3189.89, 32.8015)
Config.AfkZonesToStart = {
    vector3(222.0356, -795.0253, 30.71024),
} 
Config.CoordsLogOutInZone = vector3(220.523, -798.6065, 30.712)
Config.UpdateNameOnTopAfk = false
Config.TimerBackUpServerRegister = 10 -- minutes

Config.KeysDisable = {
    37,
    24,
    69,
    92,
    106, 
    168,
    160,
}

Config.GiveAfkRewardMoney = function(source, quantity) --Server Side
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addAccountMoney("bank", quantity)

    TriggerClientEvent("esx:showNotification", source, "Vous avez reçu votre récompense de $"..quantity)
end

Config.AFkModes = {
    {
        id = 1, --ID Random Unique
        hours = 0.05,
        moneyReward = 150000,
        image = "money1.png",
    },
    {
        id = 2, --ID Random Unique
        hours = 5,
        moneyReward = 250000,
        image = "money1.png",
    },
    {
        id = 3, --ID Random Unique
        hours = 8,
        moneyReward = 350000,
        image = "money1.png",
    },
    {
        id = 4, --ID Random Unique
        hours = 12,
        moneyReward = 500000,
        image = "money1.png",
    },
    {
        id = 5, --ID Random Unique
        hours = 24,
        moneyReward = 750000,
        image = "money1.png",
    },
    {
        id = 6, --ID Random Unique
        hours = 48,
        moneyReward = 1000000,
        image = "money1.png",
    },
}