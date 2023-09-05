if Config.ESX == "newESX" then 
    ESX = exports["es_extended"]:getSharedObject();
else
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end

TopAfkPlayers = {}

RegisterNetEvent("afk:startAfk", function(data) 
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('INSERT INTO afk_process (identifier, afkid, time) VALUES (@identifier, @afkid, @time)',{
        ['@identifier'] = xPlayer.identifier,
        ['@afkid'] = data.ElementSelected.id,
        ['@time'] = data.ElementSelected.hours * 60 --Minutes
    })
end)

RegisterNetEvent("afk:requestHaveAfk", function() 
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM afk_process WHERE identifier = @identifier', {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        if result[1] ~= nil then
            TriggerClientEvent("afk:receiveHaveAfk", xPlayer.source, result[1])
        end
    end)
end)

RegisterNetEvent("afk:updateAfkTimer", function(timer) 
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("UPDATE afk_process SET time = @time WHERE identifier = @identifier", {
        ['@time'] = timer,
        ['@identifier'] = xPlayer.identifier
    })
end)

RegisterNetEvent("afk:terminate", function(AfkInProcess) 
    local xPlayer = ESX.GetPlayerFromId(source)

    Config.GiveAfkRewardMoney(source, AfkInProcess.moneyReward)

    local identifier = xPlayer.identifier

    MySQL.Async.execute("DELETE FROM afk_process WHERE identifier = @identifier", { 
        ['@identifier'] = identifier 
    }, function(rowsChanged)
        if rowsChanged > 0 then
            MySQL.Async.fetchAll('SELECT * FROM afk_stats WHERE identifier = @identifier', {
                ["@identifier"] = identifier
            }, function(result)
                if result[1] == nil then
                    MySQL.Async.execute('INSERT INTO afk_stats (identifier, allmoney, afks, afkshours, PlayerName) VALUES (@identifier, @allmoney, @afks, @afkshours, @PlayerName)',{
                        ['@identifier'] = identifier,
                        ['@allmoney'] = AfkInProcess.moneyReward,
                        ['@afks'] = 1,
                        ['@afkshours'] = AfkInProcess.hours,
                        ['@PlayerName'] = xPlayer.getName(),
                    })
                else
                    MySQL.Async.execute("UPDATE afk_stats SET allmoney = @allmoney, afks = @afks, afkshours = @afkshours WHERE identifier = @identifier", {
                        ['@allmoney'] = result[1].allmoney + AfkInProcess.moneyReward,
                        ['@afks'] = result[1].afks + 1,
                        ['@afkshours'] = result[1].afkshours + AfkInProcess.hours,
                        ['@identifier'] = identifier
                    })
                    if Config.UpdateNameOnTopAfk then
                        MySQL.Async.execute("UPDATE afk_stats SET PlayerName = @PlayerName WHERE identifier = @identifier", {
                            ['@PlayerName'] = xPlayer.getName(),
                        })
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent("afk:getBaseConfig", function() 
    TriggerClientEvent("afk:receiveBaseConfig", source, Config.AFkModes)
end)

RegisterNetEvent("afk:refreshTopLeader", function() 
    local source = source
    
    MySQL.Async.fetchAll('SELECT * FROM afk_stats ORDER BY afkshours DESC LIMIT 3', {}, function(result)
        if result then
            local val = 1
            TopAfkPlayers = {}
            for _, row in ipairs(result) do
                table.insert(TopAfkPlayers, {top = val, hours = row.afkshours, money = row.allmoney, afks = row.afks, name = row.PlayerName})
                val = val + 1
            end
            TriggerClientEvent("afk:refreshclTop", source, TopAfkPlayers)
        end
    end)
end)