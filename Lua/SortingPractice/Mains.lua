require("tools.require")
local Generators = require("Generators")
function Main(sortFunc)
    local numberArr = Generators:GenRandomNubmerArr(10)
    print(table.dump(numberArr, false, 200) .. "\n")
    numberArr = sortFunc(numberArr)
    print(table.dump(numberArr, false, 200) .. "\n")
end

function Test(sortFunc)
    local isNoProblem = true
    for i = 1, 10 do
        local numberArr = Generators:GenRandomNubmerArr(1000)
        numberArr = sortFunc(numberArr)
        local problemArr = {}
        for j = 2, #numberArr do
            if (numberArr[j] < numberArr[j-1]) then
                table.insert(problemArr, j)
            end
        end
        if (#problemArr > 0) then
            print(table.dump(numberArr, false, 200) .. "\n")
            print("有问题-")
            print(tostring(i) .. ":\n" .. table.dump(problemArr)  .. "\n")
            isNoProblem = false
        end
    end
    if (isNoProblem) then
        print("没得问题")
    end
end

function TimeTest(sortFunc)
    local times = 1000
    local numSize = 1000
    local numArrArr = {}
    for i = 1, times do
        local numberArr = Generators:GenRandomNubmerArr(numSize)
        table.insert(numArrArr, numberArr)
    end
    Profiler.start()
    for i = 1, times do
        numArrArr[i] = sortFunc(numArrArr[i])
    end
    local profileData = Profiler.stop()
    print(Profiler.format(profileData))
end