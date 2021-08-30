require("Requires")

local function HeapSort(arr)
    local minHeap = MaxMinHeap.new()
    for _, value in ipairs(arr) do
        minHeap:Push(value)
    end
    arr = minHeap:GetSortedArr()
    return arr
end

-- Main(HeapSort)
-- Test(HeapSort)
TimeTest(HeapSort)