ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('t_proshops:getItemLabels', function(source, cb, dataTable)
    local twl = {} -- TableWithLabels = twl
    local xPlayer = ESX.GetPlayerFromId(source)

    for i=1, #dataTable, 1 do
        local item = xPlayer.getInventoryItem(dataTable[i].name)
        if item.name ~= nil then
            twl[#twl + 1] = {label = item.label, name = item.name, limit = item.limit, price = dataTable[i].price}
        else
            print("Item doesn't exist!")
        end
    end

    cb(twl)
end)

RegisterServerEvent('t_proshops:buyItem')
AddEventHandler('t_proshops:buyItem', function(item, amount, price, label, zone)
    local src = source 
    local xPlayer = ESX.GetPlayerFromId(src)
    local sourceItem = xPlayer.getInventoryItem(item)
    local amount = ESX.Round(amount)

    if amount < 0 then
		return
	end

    local totalPrice = price * amount
    local account = getAccountName(zone)

    if xPlayer.getAccount(account).money >= totalPrice then
        if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
			xPlayer.showNotification(_U('buy_inv_full'))
        else
            payToPossibleSociety(zone, totalPrice)

			xPlayer.removeAccountMoney(account, totalPrice)
			xPlayer.addInventoryItem(item, amount)
			xPlayer.showNotification(_U('buy_bought',amount, label, ESX.Math.GroupDigits(totalPrice)))

            DiscordLog(_U('log_bought', GetPlayerName(src), zone, item, label, amount, ESX.Math.GroupDigits(totalPrice)))
        end
    else
        local missingMoney = totalPrice - xPlayer.getAccount(account).money 
		xPlayer.showNotification(_U('buy_no_money', ESX.Math.GroupDigits(missingMoney)))
    end
end)

function payToPossibleSociety(zone, amount)
    local sAccount = Cfg.ShopSettings[zone].AccountJob
    if sAccount ~= nil then
        TriggerEvent('esx_addonaccount:getSharedAccount', sAccount, function(account)
            account.addMoney(amount)
        end)
    end
end

function getAccountName(zone)
    local acc = ''
    if Cfg.ShopSettings[zone].BlackMoneyPayment == true then
        acc = 'black_money'
    else
        acc = 'bank'
    end
    return acc
end

function DiscordLog(message)
    local webhook = Cfg.DiscordLogWebhook
	local embeds = {
        {
            ['color'] = 56108,
            ['title'] = '**'.. _U('log_title') ..'**',
            ['description'] = message,
			['footer'] = {
				['text'] = _U('log_footer'),
			},
        }
	}

  if message == nil or message == '' or webhook == '' or webhook == nil then return false end
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = _U('log_bot_name'), name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end