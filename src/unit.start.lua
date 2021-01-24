-- Databank Duplicator
-- connect a databank and name as "source"
-- connect target databank with slot name "target"
-- activate the board and follow instructions in lua channel
function handleTextCommandInput(text)
    if text == 'confirm' then
        duplicate(true, false)
    elseif text == 'confirm overwrite' then
        duplicate(true, true)
    else
        duplicate(false,false)
    end
end

function duplicate(action, overwrite)
    local errMsg = false
    if source == nil then
        errMsg = 'No source databank found.'
    end
    if target == nil then
        local thisMsg = 'No target databank found.'
        errMsg = errMsg and errMsg..' '..thisMsg or thisMsg
    end
    if errMsg then
        system.print(errMsg)
        return false
    end

    local sourceKeys = json.decode(source.getKeys())
    local duplicateKeyCount, skippedKeyCount, newKeyCount, newKeyString = 0, 0, 0, false
    
    for _, k in pairs(sourceKeys) do

        if target.hasKey(k) == 1 then 
            duplicateKeyCount = duplicateKeyCount + 1
            if action and overwrite then
                target.setStringValue(k, source.getStringValue(k))
            elseif action then
                local sourceValue = source.getStringValue(k)
                if target.getStringValue(k) ~= sourceValue then
                    local increment = 2
                    local newKey = k..'('..increment..')'
                    while target.hasKey(newKey) == 1 do
                        increment = increment + 1
                        newKey = k..'('..increment..')'
                    end
                    target.setStringValue(newKey, sourceValue)
                    newKeyCount = newKeyCount + 1
                    newKeyString = newKeyString == false and newKey or newKeyString..', '..newKey
                else
                    skippedKeyCount = skippedKeyCount + 1
                end
            end
        else            
            if action then
                target.setStringValue(k, source.getStringValue(k))
            end
        end
    end
    
    if not action then
        system.print('..:: DU Databank Duplicator ::..')
        system.print(source.getNbKeys() .. ' keys in source databank.')
        system.print(target.getNbKeys() .. ' keys in target databank.')
        system.print(duplicateKeyCount .. ' duplicate keys were found between the databanks.')
        system.print(':: Actions - ')
        system.print('Type "confirm" to copy the databank without overwriting existing keys.')
        system.print('Type "confirm overwrite" to copy the databank, overwriting existing keys.')
    else
        system.print(':: Completed! ')
        if overwrite then
            system.print('The databank was copied and existing data was overwritten.')
        else 
            system.print('The databank was copied and existing data was untouched.')
            if skippedKeyCount > 0 then
                system.print(skippedKeyCount..' keys were skipped as values matched.')
            end
            if newKeyCount > 0 then
                if newKeyCount == 1 then
                    system.print('1 new key was created as to same key but different value.')
                    system.print('Created key is: '..newKeyString)
                else
                    system.print(newKeyCount..' new keys were created as to same keys but different values.')
                    system.print('Created keys are: '..newKeyString)
                end
            end
        end
    end
end

duplicate(false, false)
