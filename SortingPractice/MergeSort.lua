require("tools.require")
require("Mains")
local function SubArr(arr, s, e)
    local newArr = {}
    
    for i = s, e do
        table.insert(newArr, arr[i])
    end
    return newArr
end

local function Merge(arr1, arr2)
    local res = {}
    local idx1 = 1
    local idx2 = 1
    while (idx1 <= #arr1 or idx2 <= #arr2) do
        local v1 = arr1[idx1] or math.maxinteger
        local v2 = arr2[idx2] or math.maxinteger
        if (v1 < v2) then
            table.insert(res, v1)
            idx1 = idx1 + 1
        else
            table.insert(res, v2)
            idx2 = idx2 + 1
        end
    end
    return res
end

local function MergeSort(arr)
    local len = #arr
    if (len <= 1) then return arr end

    local mid = math.floor(len / 2)
    local left = MergeSort(SubArr(arr, 1, mid))
    local right = MergeSort(SubArr(arr, mid + 1, len))
    return Merge(left, right)
end

-- Main(MergeSort)
-- Test(MergeSort)
TimeTest(MergeSort)