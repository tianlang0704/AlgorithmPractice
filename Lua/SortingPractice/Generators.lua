local Generators = {}

function Generators:GenRandomNubmerArr(len)
    if (not len) then len = 10 end
    local randomNumArr = {}
    for i = 1, len do
        local num = math.random(-10000000, 10000000)
        table.insert(randomNumArr, num)
    end
    return randomNumArr
end

return Generators