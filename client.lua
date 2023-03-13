local anchored = false
RegisterNetEvent("BoatAnchor", function(boat)
	Wait(0)
	local ped = PlayerPedId()
	if not IsVehicleEngineOn(boat) then
		if not IsPedInAnyVehicle(ped) and boat ~= nil then
			if not IsBoatAnchoredAndFrozen(vehicle) then
				SetBoatAnchor(boat, true)
				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				ClearPedTasks(ped)
				lib.notify({
					title = 'Anchored',
					description = 'Boat Anchored',
					type = 'success'
				})
			else
				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				SetBoatAnchor(boat, false)
				ClearPedTasks(ped)
				lib.notify({
					title = 'Removed Anchor',
					description = 'Removed Boat Anchor',
					type = 'success'
				})
			end
			anchored = not anchored
		end
	else
		lib.notify({
			title = 'Turn Boat off',
			description = 'Make sure you turn off your engines to anchor this boat',
			type = 'error'
		})
		anchored = false
	end
end)

local isBoat = false
RegisterNetEvent('radial:boatanchor', function()
  local coords = GetEntityCoords(PlayerPedId())
  local boating = lib.getClosestVehicle(coords, 3, false)
  if GetVehicleClass(boating) and GetVehicleClass(boating) == 14 then
    if isBoat == false then
      lib.addRadialItem({
        {
            id = 'boat_anchor',
            label = 'Boat Anchor',
            icon = 'anchor',
            onSelect = function()
                TriggerEvent('BoatAnchor', boating)
            end
        },
      })
      isBoat = true
    end
  else
    if isBoat == true then
      lib.removeRadialItem('boat_anchor')
      isBoat = false
    end
  end
end)
