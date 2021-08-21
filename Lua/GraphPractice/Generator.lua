require("tools.require")

local Generator  = {}

function Generator:AddEdgeTOVEArr(t, v, e)
    local eArr = t[v]
    if (not eArr) then
        eArr = {}
        t[v] = eArr
    end
    table.insert(eArr, e)
end

function Generator:GenGraph(vNumMax)
    -- 生成顶点
    -- 默认顶点最大ID是ID数量的2倍大
    local maxVID = vNumMax * 2
    local verticesTable = {}
    local vCount = 0
    while (vCount < vNumMax) do
        local vID
        repeat
            vID = math.random(0, maxVID)
        until not verticesTable[vID]
        verticesTable[vID] = vID
        vCount = vCount +1
    end
    local verticesArr = table.values(verticesTable)
    -- 生成连接两点的边
    local weightMax = 10
    local edgeCountMax = vNumMax
    local edgeCount = 0
    local edgeTable = {}
    local vToEArrTable = {}
    while (edgeCount < edgeCountMax) do
        local v1
        local v2
        local key
        local length = 0
        repeat
            v1 = verticesArr[math.random(1, #verticesArr)]
            v2 = verticesArr[math.random(1, #verticesArr)]
            key = tostring(v1) .. "," .. tostring(v2)
        until not edgeTable[key] and v1 ~= v2
        length = math.random(0, weightMax)
        local entry = {
            v1 = v1,
            v2 = v2,
            length = length,
        }
        edgeTable[key] = entry
        -- 这里是无方向的所以链接的两点都会被添加相应的边
        self:AddEdgeTOVEArr(vToEArrTable, v1, entry)
        self:AddEdgeTOVEArr(vToEArrTable, v2, entry)
        edgeCount = edgeCount +1
    end
    -- 组装返回信息
    local graphInfo = {
        verticesArr = verticesArr,
        edgeTable = edgeTable,
        vToEArrTable = vToEArrTable,
    }
    return graphInfo
end

return Generator