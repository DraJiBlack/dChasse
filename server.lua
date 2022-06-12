--_____   _____        ___       _   _   _____   _           ___   _____   _   _   
--|  _  \ |  _  \      /   |     | | | | |  _  \ | |         /   | /  ___| | | / /  
--| | | | | |_| |     / /| |     | | | | | |_| | | |        / /| | | |     | |/ /   
--| | | | |  _  /    / / | |  _  | | | | |  _  { | |       / / | | | |     | |\ \   
--| |_| | | | \ \   / /  | | | |_| | | | | |_| | | |___   / /  | | | |___  | | \ \  
--|_____/ |_|  \_\ /_/   |_| \_____/ |_| |_____/ |_____| /_/   |_| \_____| |_|  \_\ 




ESX                = nil
PlayersHarvesting  = {}
PlayersCrafting    = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function Harvest(source)

	SetTimeout(4000, function()

		if PlayersHarvesting[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)
			local ViandeQuantity = xPlayer.getInventoryItem('viande').count

			if ViandeQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, '~r~Vous n avez plus de place')		
			else   
                xPlayer.addInventoryItem('viande', 1)
			end
		end
	end)
end

RegisterServerEvent('draji:startRecup')
AddEventHandler('draji:startRecup', function()
	local _source = source
	PlayersHarvesting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Récupération de ~b~viande~s~...')
	Harvest(source)
end)

RegisterServerEvent('draji:stopRecup')
AddEventHandler('draji:stopRecup', function()
	local _source = source
	PlayersHarvesting[_source] = false
end)

local function Craft(source)

	SetTimeout(4000, function()

		if PlayersCrafting[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)
			local ViandeQuantity = xPlayer.getInventoryItem('viande').count

			if ViandeQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez ~r~pas assez~s~ de viande')			
			else   
                xPlayer.removeInventoryItem('viande', 1)
				xPlayer.addMoney(10)
				
				Craft(source)
			end
		end
	end)
end

RegisterServerEvent('draji:startVente')
AddEventHandler('draji:startVente', function()
	local _source = source
	PlayersCrafting[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Vente de ~b~viande~s~...')
	Craft(_source)
end)

RegisterServerEvent('draji:stopVente')
AddEventHandler('draji:stopVente', function()
	local _source = source
	PlayersCrafting[_source] = false
end)