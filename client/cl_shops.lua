local Keys = {
	['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57, 
	['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177, 
	['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
	['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
	['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
	['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70, 
	['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
	['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
	['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

local ShopOpen = false
local PlayerData        = {}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)


Citizen.CreateThread(function() -- Creating blips for shops that have blips enabled
    local B_S = Cfg.BlipSettings

	for k,v in pairs(Cfg.ShopSettings) do
		if v.BlipEnabled then
            for i = 1, #v.Locations, 1 do
                local blip = AddBlipForCoord(v.Locations[i])
                SetBlipSprite (blip, B_S.Sprite)
                SetBlipScale  (blip, B_S.Scale)
                SetBlipDisplay(blip, B_S.Display)
                SetBlipColour (blip, B_S.Colour)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString(v.BlipName or B_S.DefaultName)
                EndTextCommandSetBlipName(blip)
            end
        end
	end
end)

function OpenShop(zone)
    local elements = {}
    local zoneItems = Cfg.ShopSettings[zone].Items
    ESX.TriggerServerCallback('t_proshops:getItemLabels', function(dataTable)
        for i=1, #dataTable, 1 do

            local item = dataTable[i]

            if item.limit == -1 then
                item.limit = 100
            end

            table.insert(elements, {
                label      = item.label .. ' - <span style="color: green;">$' .. item.price .. '</span>',
                label_real = item.label,
                item       = item.name,
                price      = item.price,

                -- menu properties
                value      = 1,
                type       = 'slider',
                min        = 1,
                max        = item.limit
            })
        end
    end, zoneItems)

	ESX.UI.Menu.CloseAll()

    ShopOpen = true

    while #zoneItems > #elements do
        Citizen.Wait(10)
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 't_proshop', {
		title    = zone,
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
        local action = data.current
        local fullPrice = action.price * action.value

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title    = _U('want_to_buy', action.value, action.label_real, ESX.Math.GroupDigits(fullPrice)),
			align    = 'bottom-right',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				TriggerServerEvent('t_proshops:buyItem', action.item, action.value, action.price, action.label_real, zone)
			end
			menu2.close()
            ShopOpen = false
		end, function(data2, menu2)
			menu2.close()
            ShopOpen = false
		end)
	end, function(data, menu)
		menu.close()
        ShopOpen = false
	end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local PlayerPed = PlayerPedId()
        local letSleep = true
        for k,v in pairs(Cfg.ShopSettings) do
            for i = 1, #v.Locations, 1 do
                local PedCoords = GetEntityCoords(PlayerPed)
                local Distance = #(PedCoords - v.Locations[i])
                local Mgs = Cfg.MarkerSettings
                if Distance < Mgs.DrawDistance then
                    if not ShopOpen then
                        --if CheckPermissions(k) then
                            letSleep = false
                            if v.MarkerEnabled then
                                local Shop = Cfg.ShopSettings[k]
                                local MColor = Shop.MarkerColour or Mgs.MarkerColour
                                local MType = Shop.MarkerType or Mgs.MarkerType
                                --local type2 = v.MarkerType or Mgs.MarkerType
                                DrawMarker(MType, v.Locations[i].x, v.Locations[i].y, v.Locations[i].z + 0.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Mgs.MarkerSize, Mgs.MarkerSize, Mgs.MarkerSize * 1.5, MColor.r, MColor.g, MColor.b, 100, false, false, 2, false, false, false, false)
                            end

                            if Distance <= Mgs.MarkerSize then
                                Draw3DText(PedCoords, v.TextPrompt)

                                if IsControlJustReleased(0, Keys[v.OpenControl]) then
                                    OpenShop(k)
                                    break
                                end
                            end
                        --end
                    end
                end
            end
        end

        if letSleep then
            Citizen.Wait(700)
        end
    end
end)

function CheckPermissions(shop)
    local pJob = PlayerData.job.name
    local aJobs = Cfg.ShopSettings[shop].AuthJobs
    local jobsChecked = 0
    local isJob = false

    if aJobs then
        for k,v in pairs(aJobs) do
            if pJob == v then
                isJob = true
            end
        end
    else
        isJob = true
    end

    return isJob
end

function Draw3DText(pos, text)
    local onScreen,_x,_y=World3dToScreen2d(pos.x, pos.y, pos.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.38, 0.38)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.024+ factor, 0.03, 21, 21, 21, 110)
end

function getClosestCoords()
    local _ClosestCoord = nil
    local _ClosestDistance = 100000
    local _playerPed = PlayerPedId()
    local _Coord = GetEntityCoords(_playerPed)

    for k,v in pairs(Config.ShopSettings) do
        for _, data in pairs(v.Locations) do
            local _Distance = #(data - _Coord)
            if _Distance <= _ClosestDistance then
                _ClosestDistance = _Distance
                _ClosestCoord = data
            end
        end
    end

    return _ClosestCoord
end

RegisterNetEvent('t_proshops:getClosest')
AddEventHandler('t_proshops:getClosest', function()
    local mesta = getClosestCoords()
    ESX.ShowNotification(_U('gps_set'))
    SetNewWaypoint(mesta.x, mesta.y)
end)

RegisterCommand('closestshop', function()
    TriggerEvent('t_proshops:getClosest')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)