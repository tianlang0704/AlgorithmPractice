local MaxMinHeap = {}

function MaxMinHeap.new(compareFunc)
    local inst = {}
    inst.compareFunc = compareFunc or function(a, b)
        return a < b
    end
    return setmetatable(inst, {
        __index = MaxMinHeap
    })
end

function MaxMinHeap:Push(num)
    if (not self.dataArr) then
        self.dataArr = {}
    end
    table.insert(self.dataArr, num)
    self:SiftUp(#self.dataArr)
end

function MaxMinHeap:Pop()
    local count = #self.dataArr
    if (count <= 0) then return end
    if (count <= 1) then 
        return table.remove(self.dataArr, 1)
    end
    local res = self.dataArr[1]
    self.dataArr[1] = table.remove(self.dataArr, #self.dataArr)
    self:SiftDown(1)
    return res
end

function MaxMinHeap:SiftUp(idx)
    if (#self.dataArr <= 1 or idx <= 1) then return end
    local value = self.dataArr[idx]
    local idxParent = math.floor(idx / 2)
    local valueParent = self.dataArr[idxParent]
    if (self.compareFunc(value, valueParent)) then
        self.dataArr[idx] = valueParent
        self.dataArr[idxParent] = value
        self:SiftUp(idxParent)
    end
end

function MaxMinHeap:SiftDown(idx)
    local count = #self.dataArr
    if (count <= 1) then return end
    local value = self.dataArr[idx]
    local idxChild1 = idx * 2
    local idxChild2 = idx * 2 + 1
    local idxTargetChild
    if (idxChild1 <= count and idxChild2 <= count) then
        local is1Better = self.compareFunc(self.dataArr[idxChild1], self.dataArr[idxChild2])
        idxTargetChild = is1Better and idxChild1 or idxChild2
    elseif (idxChild1 <= count) then
        idxTargetChild = idxChild1
    elseif (idxChild2 <= count) then
        idxTargetChild = idxChild2
    end
    if (idxTargetChild) then
        local valueChild = self.dataArr[idxTargetChild]
        if (self.compareFunc(valueChild, value)) then
            self.dataArr[idx] = valueChild
            self.dataArr[idxTargetChild] = value
            self:SiftDown(idxTargetChild)
        end
    end
end

function MaxMinHeap:GetSortedArr()
    local tableCopy = table.pack(table.unpack(self.dataArr))
    local resArr = {}
    while (#self.dataArr > 0) do
        local value = self:Pop()
        if (value) then
            table.insert(resArr, value)
        end
    end
    self.dataArr = tableCopy
    return resArr
end

function MaxMinHeap:GetCount()
    return #self.dataArr
end

return MaxMinHeap