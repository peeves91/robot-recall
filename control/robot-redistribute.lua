script.on_nth_tick(15, function(event)
    for k, v in pairs(storage.deploying) do
        if (v.deploying and v.ent.valid) then
            local inv = v.ent.get_inventory(1)
            if (not inv.is_empty()) then
                local items = inv.get_contents()
                -- for name, count in pairs(items) do
                for index, item in pairs(items) do
                    name = item['name']
                    local placeresult = prototypes.item[name].place_result
                    if (placeresult.type == "logistic-robot" or placeresult.type ==
                        "construction-robot") then
                        if (logisticNetworkHasItemSpace(v.ent.logistic_network, name)) then
                            v.ent.surface.create_entity(
                                {
                                    name = placeresult.name,
                                    position = v.ent.position,
                                    force = v.ent.logistic_network.force
                                })
                            inv.remove({name = name, count = 1})
                        end
                    end

                end
            end
        end
    end
end)

script.on_event(defines.events.on_built_entity, function(event) 

    if (event.entity.name == "robot-redistribute-chest") then
        local entity = event.entity
        storage.deploying[entity.unit_number] = {ent = entity, deploying = false}
    end   

end)

script.on_event(defines.events.on_robot_built_entity, function(event) 

    if (event.entity.name == "robot-redistribute-chest") then
        local entity = event.entity
        storage.deploying[entity.unit_number] = {ent = entity, deploying = false}
    end   

end)

-- function canInsertIntoRoboport(itemname, logistic_network)
--     -- local roboport = 
--     if (logistic_network and logistic_network.valid) then
--         for k, v in pairs(logistic_network.cells) do
--             local inv = cell.owner.get_inventory(
--                             defines.inventory.roboport_robot)
--             if (inv and inv.can_insert({name = itemname, count = 1})) then
--                 return true
--             end
--         end
--     end
--     return false
-- end

function logisticNetworkHasItemSpace(logistic_network, itemname)
    if (logistic_network and logistic_network.valid) then
        for k, v in pairs(logistic_network.cells) do
            local inv = v.owner.get_inventory(defines.inventory.roboport_robot)
            if (inv and inv.can_insert({name = itemname, count = 1})) then
                return true
            end
        end
    end
    return false
end

script.on_nth_tick(60, function(event)
    for k, v in pairs(storage.deploying) do
        if (v.ent and not v.ent.valid) then table.remove(storage.deploying, k) 
        elseif (v.ent and not v.ent.get_inventory(1).is_empty()) then v.deploying = true 
        else v.deploying = false end
    end

end)
