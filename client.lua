local ReadyToRespawn = false

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

CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/revive', 'Revive yourself when dead', {})
	TriggerEvent('chat:addSuggestion', '/respawn', 'Respawn at the default spawn point', {})

	local timeOfDeath = nil

	while true do
		Wait(0)

		if IsPedDeadOrDying(PlayerPedId()) then
			if not timeOfDeath then
				timeOfDeath = GetSystemTime()

				local sourceOfDeath = GetPedSourceOfDeath(PlayerPedId())
				local killer = GetPlayerFromPed(sourceOfDeath)

				SendNUIMessage({
					type = 'showHud',
					killer = killer and GetPlayerName(killer)
				})
			else
				if IsControlJustPressed(0, Config.ToggleControl) then
					SendNUIMessage({
						type = 'toggleHud'
					})
				end

				local timeLeft = timeOfDeath + Config.Cooldown - GetSystemTime()

				if timeLeft < 1 then
					if not ReadyToRespawn then
						SendNUIMessage({
							type = 'showInstructions'
						})
						ReadyToRespawn = true
					end

					if IsControlJustPressed(0, Config.RespawnControl) then -- Reload, R
						exports.spawnmanager:spawnPlayer()
					elseif IsControlJustPressed(0, Config.ReviveControl) then -- DynamicScenario, E
						ResurrectPed(PlayerPedId())
					end
				else
					SendNUIMessage({
						type = 'updateCooldownTimer',
						timeLeft = timeLeft
					})
				end
			end
		elseif timeOfDeath then
			SendNUIMessage({
				type = 'hideHud'
			})
			timeOfDeath = nil
			ReadyToRespawn = false
		end
	end
end)
