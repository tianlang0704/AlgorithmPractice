require("Requires")

function Dijkstra(graphInfo, firstVIndex)
    -- 初始化距离表
    local vDistanceTable = {}
    for _, v in ipairs(graphInfo.verticesArr) do
        vDistanceTable[v] = {
            distance = math.maxinteger,
        }
    end
    local firstV = graphInfo.verticesArr[firstVIndex or 1]
    vDistanceTable[firstV].distance = 0
    -- 初始化要行走路径
    local travelHeap = MaxMinHeap.new(function(a, b) return a.distance > b.distance end)
    travelHeap:Push({distance = 0, v = firstV})
    -- 实际行走路径计算
    local vToEArrTable = graphInfo.vToEArrTable
    while (travelHeap:GetCount() > 0) do
        local curVInfo = travelHeap:Pop()
        local curV = curVInfo.v
        local curDis = curVInfo.distance
        local minDistance = vDistanceTable[curV].distance
        if (curDis <= minDistance) then
            local edgeArr = vToEArrTable[curV]
            if (edgeArr) then
                for _, edgeInfo in ipairs(edgeArr) do
                    local edgeLength = edgeInfo.length
                    local edgeTarget
                    if (curV == edgeInfo.v1) then
                        edgeTarget = edgeInfo.v2
                    else
                        edgeTarget = edgeInfo.v1
                    end
                    local targetDistanceMin = vDistanceTable[edgeTarget].distance
                    local targetDistance = curDis + edgeLength
                    if (targetDistance < targetDistanceMin) then
                        vDistanceTable[edgeTarget].distance = targetDistance
                        vDistanceTable[edgeTarget].source = curV
                        travelHeap:Push({
                            distance = targetDistance,
                            v = edgeTarget,
                        })
                    end
                end
            end
        end
    end
    return vDistanceTable
end

-- 根据点多多点信息重构路径
function RebuildDijkstraPath(vFrom, vDistanceTable)
    local pathArr = {}
    local distanceInfo = vDistanceTable[vFrom]
    while (distanceInfo) do
        distanceInfo.v = vFrom
        table.insert(pathArr, 1, distanceInfo)
        vFrom = distanceInfo.source
        distanceInfo = distanceInfo.source and vDistanceTable[distanceInfo.source]
    end
    return pathArr
end

function Main()
    local graphInfo = Generator:GenGraph(10)
    print(table.dump(graphInfo.verticesArr))
    local distanceTable = Dijkstra(graphInfo, 3)
    print(table.dump(distanceTable, 200))
    local pathArr = RebuildDijkstraPath(graphInfo.verticesArr[#graphInfo.verticesArr], distanceTable)
    print(table.dump(pathArr, 200))
end

-- Main()







