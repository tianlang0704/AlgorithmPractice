require("Requires")

function FloydWarshall(graphInfo)
    local vCount = #graphInfo.verticesArr
    local dist = {}
    for i = 1, vCount do
        for j = 1, vCount do
            local row = dist[i]
            if (not row) then
                row = {}
                dist[i] = row
            end
            row[j] = math.maxinteger
        end
    end
    local idToIndexTable = graphInfo.idToIndexTable
    for _, info in pairs(graphInfo.edgeTable) do
        local v1Index = idToIndexTable[info.v1]
        local v2Index = idToIndexTable[info.v2]
        dist[v1Index][v2Index] = info.length
        dist[v2Index][v1Index] = info.length
    end
    for i = 1, vCount do
        dist[i][i] = 0
    end
    for k = 1, vCount do
        for i = 1, vCount do
            for j = 1, vCount do
                local firstPart = dist[i][k]
                local secondPart = dist[k][j]
                local distTest = (firstPart == math.maxinteger or secondPart == math.maxinteger) and math.maxinteger or firstPart + secondPart
                if (dist[i][j] > distTest) then
                    dist[i][j] = distTest
                end
            end
        end
    end
    return dist
end

function RebuildFloydWarshallPath(fromVIndex, distanceTable)
    return distanceTable[fromVIndex][1]
end

function Main()
    local graphInfo = Generator:GenGraph(10)
    local distanceTable = FloydWarshall(graphInfo)
    print(table.dump(distanceTable, 200))
    local distance = RebuildFloydWarshallPath(#graphInfo.verticesArr, distanceTable)
    print(distance)
end

-- Main()







