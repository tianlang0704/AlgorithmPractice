require ("Requires")

local function BubbleSort(arr)
    for i = 1, #arr, 1 do
        for j = i, #arr, 1 do
            if (arr[i] > arr[j]) then
                local temp = arr[i]
                arr[i] = arr[j]
                arr[j] = temp
            end
        end
    end
    return arr
end

-- Main(BubbleSort)
-- Test(BubbleSort)
TimeTest(BubbleSort)

