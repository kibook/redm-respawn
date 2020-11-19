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

CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/revive', 'Revive yourself when dead', {})
	TriggerEvent('chat:addSuggestion', '/respawn', 'Respawn at the default spawn point', {})

	local timeOfDeath = nil

	while true do
		Wait(0)

		if IsPedDeadOrDying(PlayerPedId()) then
			if not timeOfDeath then
				SendNUIMessage({
					type = 'showHud'
				})
				timeOfDeath = GetSystemTime()
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
