require ("Requires")

local function Swap(arr, idx1, idx2)
    local temp = arr[idx1]
    arr[idx1] = arr[idx2]
    arr[idx2] = temp
end

local function Partition(arr, lowIdx, highIdx)
    local centerIdx = math.floor((highIdx + lowIdx) / 2)
    local centerValue = arr[centerIdx]
    local lowSearchIdx = lowIdx - 1
    local highSearchIdx = highIdx + 1
    while (true) do
        -- 这里用Repeat先+1保证对比值相同的时候也移动指针, 否则需要在置换过后检查数值相等移动相应的指针
        repeat
            lowSearchIdx = lowSearchIdx + 1
            local lowSearchValue = arr[lowSearchIdx]
        until (lowSearchIdx >= highIdx or lowSearchValue >= centerValue)
        repeat
            highSearchIdx = highSearchIdx - 1
            local highSearchValue = arr[highSearchIdx]
        until (highSearchIdx <= lowIdx or highSearchValue <= centerValue)
        if (lowSearchIdx >= highSearchIdx) then
            -- 返回highSearchIdx因为下面分组用的center, center+1分组的, 现在highSearchIndex在低, lowSearchIndex在高, 用low会导致中间这一个数字分组错误
            -- 如果上面用math.ceil取中心, 导致下面用center - 1, center分组, 就应该返回lowSearchIdx因为lowSearchIndex在高位, -1才是正确分组
            return highSearchIdx
        end
        Swap(arr, lowSearchIdx, highSearchIdx)
    end
end

local function QuickSort(arr, lowIdx, highIdx)
    if (not lowIdx) then lowIdx = 1 end
    if (not highIdx) then highIdx = #arr end
    
    -- 这里保证下标没问题
    if (lowIdx >= highIdx) then
        return arr
    end

    local centerIdx = Partition(arr, lowIdx, highIdx)
    QuickSort(arr, lowIdx, centerIdx)               -- Partition用的floor,这里centerIdx会在low和high相差1的情况下变成low, 这里用centerIdx - 1就会出问题, 下面一行也会无限循环
    QuickSort(arr, centerIdx + 1, highIdx)          -- 如果Partition用的ceil, centerIdx会变成high, 这一行就不能+1, 上面一行就应该用-1

    return arr
end

-- Main(QuickSort)
-- Test(QuickSort)
TimeTest(QuickSort)