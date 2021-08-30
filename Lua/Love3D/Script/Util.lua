local Util = {}

function Util:TableCopy(table, depth, curDepth)
    if (not depth) then depth = 1 end
    local curDepth = curDepth or 1
    if (curDepth > depth) then 
        return table
    end
    local newTable = {}
    for key, value in pairs(table) do
        if (type(value) == "table") then
            value = Util:TableCopy(value, depth, curDepth + 1)
        end
        newTable[key] = value
    end
    return newTable
end

return Util