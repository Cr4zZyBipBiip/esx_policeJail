--[[
	Dans esx_policejob/client/main.lua, dans la function "OpenPoliceActionsMenu()", modifiez les citizen_interactions par ceci pour rajouter la federal :
]]


			'default', GetCurrentResourceName(), 'citizen_interaction',
          {
            title    = _U('citizen_interaction'),
            align    = 'top-left',
            elements = {
              {label = _U('id_card'),       value = 'identity_card'},
              {label = _U('search'),        value = 'body_search'},
              {label = _U('handcuff'),    value = 'handcuff'},
              {label = _U('drag'),      value = 'drag'},
              {label = _U('put_in_vehicle'),  value = 'put_in_vehicle'},
              {label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
              {label = _U('fine'),            value = 'fine'},
              {label = 'Mettre en prison Fédérale',   value ='federal'}
            },

--[[
	Plus bas, rajoutez donc l'appel de fonction équivalente :
]]
			if data2.current.value == 'federal' then
                OpenFederalMenu(player)
              end


--[[
	Rajoutez a la fin de votre fichier main.lua (que vous éditez encore) ceci :
]]

function OpenFederalMenu(player)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'federal',
    {
      title    = 'Sentence Fédérale',
      align    = 'top-left',
      elements = {
        {label = '1 mois',   value = 1},
        {label = '2 mois',   value = 2},
        {label = '3 mois',   value = 3},
        {label = '4 mois',   value = 4},
        {label = '5 mois',   value = 5},
        {label = '6 mois',   value = 6},
        {label = '7 mois',   value = 7},
        {label = '8 mois',   value = 8},
        {label = '9 mois',   value = 9},
        {label = '10 mois',  value = 10},
        {label = '11 mois',  value = 11},
        {label = '1 an',     value = 12}
      },
    },
    function(data, menu)
      Arrest(GetPlayerServerId(player), tonumber(data.current.value)*60)
      menu.close()
    end,
    function(data, menu)
      menu.close()
    end
  )

end

function Arrest(playerID, amount)
  TriggerServerEvent("jail:teleportToJail", playerID, amount)
end

-- jail addon
RegisterNetEvent('jail:teleportPlayer')
AddEventHandler('jail:teleportPlayer', function(amount)
  if IsHandcuffed then
    TriggerEvent('esx_policejob:handcuff')
    TriggerServerEvent('jail:removeInventaire', amount)
    Wait(500)
    SetEntityCoords(GetPlayerPed(-1), tonumber("1680.07"), tonumber("2512.8"), tonumber("45.4649"))
    RemoveAllPedWeapons(GetPlayerPed(-1))
    TriggerEvent('chatMessage', '^4[JAIL]', {0,0,0}, "Voici ta sentence : ^1".. (tonumber(amount)/60) .." minutes !")
    clearPed()
    Wait(500)
    local hashSkin = GetHashKey("mp_m_freemode_01")
    Citizen.CreateThread(function()
      if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
        SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 15, 0)--Pantalon
        SetPedComponentVariation(GetPlayerPed(-1), 11, 5, 0, 0)--Debardeur
        SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--Tshirt
        SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 0)--Bras
        SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 0)--Pied
        c_options.undershirt = 0
        c_options.undershirt_txt = 240
        SetPedComponentVariation(GetPlayerPed(-1), 8, tonumber(c_options.undershirt), tonumber(c_options.undershirt_txt), 0)
      else  
        SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 15, 0)--Pantalon
        SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 6, 0)--Debardeur
        SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)--Tshirt
        SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 0)--Bras
        SetPedComponentVariation(GetPlayerPed(-1), 6, 5, 0, 0)--Pied
        c_options.undershirt = 0
        c_options.undershirt_txt = 240
        SetPedComponentVariation(GetPlayerPed(-1), 8, tonumber(c_options.undershirt), tonumber(c_options.undershirt_txt), 0)
      end 
    end)
    Citizen.CreateThread(function()
      while (amount > 0) do
        if amount == 240 then
          TriggerEvent('chatMessage', '^4[JAIL]', {0,0,0}, "Temps restant : ^1".. (tonumber(amount)/60) .." minutes !")
        elseif amount == 180 then
          TriggerEvent('chatMessage', '^4[JAIL]', {0,0,0}, "Temps restant : ^1".. (tonumber(amount)/60) .." minutes !")
        elseif amount == 120 then
          TriggerEvent('chatMessage', '^4[JAIL]', {0,0,0}, "Temps restant : ^1".. (tonumber(amount)/60) .." minutes !")
        elseif amount == 60 then
          TriggerEvent('chatMessage', '^4[JAIL]', {0,0,0}, "Temps restant : ^1".. (tonumber(amount)/60) .." minute !")
        else

        end

        
        RemoveAllPedWeapons(GetPlayerPed(-1))
                LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        if (GetDistanceBetweenCoords(LastPosX, LastPosY, LastPosZ, 1680.06994628906,2512.80004882813,46.2684020996094, true) > 100.0001) then
            SetEntityCoords(GetPlayerPed(-1), tonumber("1680.07"), tonumber("2512.8"), tonumber("45.4649"))
          	TriggerEvent('chatMessage', '^4[JAIL]', {0,0,0}, "On ne s'échappe pas de la prison comme ça !")
        end
        Citizen.Wait(1000)
        amount = amount - 1
          
      end
      
      -- Sortie de prison après fin sentence
      SetEntityCoords(GetPlayerPed(-1), tonumber("1847.39"), tonumber("2602.78"), tonumber("45.5987"))
      clearPed()

    end)
  else
    TriggerEvent('chatMessage', source,'^4[JAIL]', {0,0,0}, "LE prisonnier doit être menotté !")
  end
end)


--[[
	Dans esx_policejob/server/main.lua rajoutez ceci a la fin de votre fichier :
]]

-- jail addon
RegisterServerEvent('jail:teleportToJail')
AddEventHandler('jail:teleportToJail', function(t, amount)
  TriggerClientEvent('jail:teleportPlayer', t, amount)
end)



RegisterServerEvent('jail:removeInventaire')
AddEventHandler('jail:removeInventaire', function(amount)
local xPlayer = ESX.GetPlayerFromId(source)
  for i=1, #xPlayer.inventory, 1 do
    if xPlayer.inventory[i].count > 0 then
      ESX.CreatePickup('item_standard', xPlayer.inventory[i].name, xPlayer.inventory[i].count, xPlayer.inventory[i].label .. ' [' .. xPlayer.inventory[i].count .. ']', _source)
      xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
    end
  end
  xPlayer.addInventoryItem('bread', amount/60)
  xPlayer.addInventoryItem('water', amount/60)
end)
-- jail addon end
