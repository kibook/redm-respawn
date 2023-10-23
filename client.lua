AddEventHandler('onClientMapStart', function()
	Citizen.Trace("Disabled: autospawn.")
	exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("disabled:.")
end)


local ReadyToRespawn = false

local RespawnOptionsPrompts = UipromptGroup:new("Respawn Options")

local RevivePrompt = Uiprompt:new(Config.ReviveControl, "Revive", RespawnOptionsPrompts, false)
RevivePrompt:setHoldMode(true)
RevivePrompt:setOnHoldModeJustCompleted(function(prompt)
	ResurrectPed(PlayerPedId())
end)

local RespawnPrompt = Uiprompt:new(Config.RespawnControl, "Respawn", RespawnOptionsPrompts, false)
RespawnPrompt:setHoldMode(true)
RespawnPrompt:setOnHoldModeJustCompleted(function(prompt)
	exports.spawnmanager:spawnPlayer()
end)

local TogglePrompt = Uiprompt:new(Config.ToggleControl, "Toggle Death Screen", RespawnOptionsPrompts)
TogglePrompt:setHoldMode(true)
TogglePrompt:setOnHoldModeJustCompleted(function(prompt)
	SendNUIMessage({
		type = "toggleHud"
	})
end)

RegisterCommand('revive', function(source, args, raw)
	if ReadyToRespawn then
		ResurrectPed(PlayerPedId())
	end
end, false)

RegisterCommand('respawn', function(source, args, raw)
	if ReadyToRespawn or not IsPedDeadOrDying(PlayerPedId()) then
		exports.spawnmanager:spawnPlayer()
	end
end, false)

function GetPlayerFromPed(ped)
	for _, playerId in ipairs(GetActivePlayers()) do
		if GetPlayerPed(playerId) == ped then
			return playerId
		end
	end

	return nil
end

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/revive', 'Revive yourself when dead', {})
	TriggerEvent('chat:addSuggestion', '/respawn', 'Respawn at the default spawn point', {})

	local timeOfDeath = nil

	while true do
		local playerPed = PlayerPedId()

		if IsPedDeadOrDying(playerPed) then
			local currentTime = GetSystemTime()

			if not timeOfDeath then
				timeOfDeath = currentTime

				local sourceOfDeath = GetPedSourceOfDeath(playerPed)
				local killer = GetPlayerFromPed(sourceOfDeath)

				SendNUIMessage({
					type = 'showHud',
					killer = killer and GetPlayerName(killer)
				})
			else
				local timeLeft = timeOfDeath + Config.Cooldown - currentTime

				if timeLeft < 1 then
					if not ReadyToRespawn then
						ReadyToRespawn = true
						RevivePrompt:setEnabledAndVisible(true)
						RespawnPrompt:setEnabledAndVisible(true)
					end
				else
					SendNUIMessage({
						type = 'updateCooldownTimer',
						timeLeft = timeLeft
					})
				end
			end

			RespawnOptionsPrompts:handleEvents()
		elseif timeOfDeath then
			SendNUIMessage({
				type = 'hideHud'
			})
			timeOfDeath = nil
			ReadyToRespawn = false

			RevivePrompt:setEnabledAndVisible(false)
			RespawnPrompt:setEnabledAndVisible(false)
		end

		Citizen.Wait(0)
	end
end)
