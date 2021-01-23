-- Databank Duplicator
-- connect a databank and name as "source"
-- connect target databank with slot name "target"
-- activate the board and follow instructions in lua channel
function handleTextCommandInput(text)
    
    if text == "confirm" then
        duplicate(true, false)
    end 
    
    if text == "confirm overwrite" then
        duplicate(true, true)
    end
    
end

function duplicate(action, overwrite)
    
    if source == nil then
        system.print("No source databank found")
        return false
    end
    
    if target == nil then
        system.print("No target databank found")
        return false
    end

    local sourceKeys = json.decode(source.getKeys())
    local duplicateKeyCount = 0
    
    for k, v in pairs(sourceKeys) do

        if target.hasKey(v) == 1 then 
            duplicateKeyCount = duplicateKeyCount + 1
            if action and overwrite then
                target.setStringValue(v, source.getStringValue(v))
            end
	   else            
            if action then
                target.setStringValue(v, source.getStringValue(v))
            end
        end
        
    end
    
    if action == false then
        system.print('..:: DU Databank Duplicator ::..')
        system.print(source.getNbKeys() .. ' keys in source databank.')
        system.print(target.getNbKeys() .. ' keys in target databank.')
        system.print(duplicateKeyCount .. ' duplicate keys were found between the databanks.')
        system.print(':: Actions - ')
        system.print('Type "confirm" to copy the databank without overwriting existing keys ')
        system.print('Type "confirm overwrite to copy the databank, overwriting existing keys ')
    else
        system.print(':: Completed! ')
        if overwrite then
            system.print('The databank was copied and existing data was overwritten.')
        else 
            system.print('The databank was copied and existing data was untouched.')
        end
    end
end

duplicate(false, false)
