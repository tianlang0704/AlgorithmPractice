require("Dijkstra")
require("FloydWarshall")

function Comparison()
    for i = 1, 10000 do
        local graphInfo = Generator:GenGraph(10)
        -- print(table.dump(graphInfo.verticesArr))
        local distanceTable = Dijkstra(graphInfo)
        local pathArr = RebuildDijkstraPath(graphInfo.verticesArr[#graphInfo.verticesArr], distanceTable)
        -- print(table.dump(pathArr, 200))
        local distanceTable = FloydWarshall(graphInfo)
        -- print(table.dump(distanceTable, 200))
        local distance = RebuildFloydWarshallPath(#graphInfo.verticesArr, distanceTable)
        -- print(distance)
        if (pathArr[#pathArr].distance ~= distance) then
            print("有问题 - " .. tostring(i) .. " : " .. tostring(pathArr[#pathArr].distance) .. ", " .. tostring(distance))
            print(table.dump(graphInfo.verticesArr))
            print(table.dump(graphInfo.edgeTable))
            print(table.dump(pathArr, 200))
            print(table.dump(distanceTable, 200))
            break
        end
    end
end

Comparison()