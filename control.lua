-- require('util')
require('control.robot-recall')
require('control.robot-redistribute')
-- require('')

script.on_init(function(event)
    storage.teleportQueue = {}
    storage.teleportQueueEntryCount = 0
    storage.hasChanged = false
    storage.openedGUIPlayers = {}
    storage.deploying = {}
end)

script.on_configuration_changed(function(event)
        if (event.mod_changes and event.mod_changes['robot-recall']) then
        local old_ver = event.mod_changes['robot-recall'].old_version
        if (old_ver) then
            if (old_ver == "0.2.0" or string.find(old_ver, "0.1.")) then
                storage.teleportQueue = {}
                storage.teleportQueueEntryCount = 0
            end

            if (old_ver == "0.2.0" or old_ver == "0.2.1") then
                storage.deploying = {}
                for _, surface in pairs(game.surfaces) do
                    local deploymentstations =
                        surface.find_entities_filtered(
                            {name = "robot-redistribute-chest"})
                    for k, v in pairs(deploymentstations) do
                        storage.deploying[v.unit_number] =
                            {ent = v, deploying = false}
                    end
                end
            end
            if (new_ver == "0.2.1" or 
                new_ver == "0.2.2" or 
                new_ver == "0.2.3" or 
                string.find(old_ver, "0.1.")) then 
                local newTeleportQueue = {}
                for k,e in pairs(storage.teleportQueue) do
                    local newEl = e
                    if (newEl.source and newEl.source.valid) then
                        newEl.srcPos = newEl.source.position
                        newEl.surface = newEl.source.surface
                    end
                    if (newEl.destination and newEl.destination.valid) then
                        newEl.surface = newEl.destination.surface
                        newEl.destPos = newEl.destination.position
                    end
                    table.insert(newTeleportQueue, newEl)
                end
                storage.teleportQueue = newTeleportQueue
                storage.teleportQueueEntryCount = table_size(newTeleportQueue)
            end
        end
    end

    storage.deploying = storage.deploying or {}
    storage.teleportQueue = storage.teleportQueue or {}
    storage.teleportQueueEntryCount = storage.teleportQueueEntryCount or 0
    storage.hasChanged = storage.hasChanged or false
    storage.openedGUIPlayers = storage.openedGUIPlayers or {}
end)
