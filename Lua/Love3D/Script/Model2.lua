local Model = {}

function Model.__index(t, k)
    local var = rawget(Model, k)
	if var ~= nil then
		return var
	end
end

function Model.New()
    local inst = {}
	setmetatable(inst, Model)
	inst:ctor()
    return inst
end

function Model:ctor()
	self.pointArr = {}
	self.patchArr2 = {}
	self.transform = FourFourMatrix.New()
	self.rotation = Quaternion.New()
	self.anchor = Vector3.New()
end

function Model:LoadTeapod(width, height)
	self:ParsePointArrFromFile("teapot")
    self:ParsePatchArrFromFile("teapotBezierPatches")
    self:SetPosition(Vector3.New(width / 2, height / 2, 0))
    self:SetScale(Vector3.New(10, 10, 10))
    self:SetColor(Color.New(1, 1, 1, 0.7))
	self:ProcessBezierHandle()
end

function Model:ParsePointArrFromFile(fileName)
	local pointArr = {}
	local file = io.open(fileName, "r")
	for line in file:lines() do
		local lineStrArr = line:split(",")
		local point = Vector3.New(tonumber(lineStrArr[1]), tonumber(lineStrArr[2]), tonumber(lineStrArr[3]))
		table.insert(pointArr, point)
	end
	file:close()
	self:SetPointArr(pointArr)
end

function Model:ParsePatchArrFromFile(pathFileName)
	local indexArr2 = {}
	local file = io.open(pathFileName, "r")
	local lineCount = 1
	for line in file:lines() do
		if (not line:startswith("#")) then
			local arr = {}
			indexArr2[lineCount] = arr
			local sinegleSpaceLine = line:gsub("%s+", " ")
			local lineStrArr = sinegleSpaceLine:split(" ")
			for i = 2, 17 do
				table.insert(arr, tonumber(lineStrArr[i]))
			end
			lineCount = lineCount + 1
		end
	end
	file:close()
	self.patchArr2 = indexArr2
end

local function BezierFunc(v3Arr, progress)
	if (progress > 1) then progress = 1 end
	local progressComplement = 1 - progress
	local w1 = math.pow(progressComplement, 3)
	local w2 = 3 * progress * math.pow(progressComplement, 2)
	local w3 = 3 * math.pow(progress, 2) * progressComplement
	local w4 = 3 * math.pow(progress, 3)
	return v3Arr[1] * w1 + v3Arr[2] * w2 + v3Arr[3] * w3 + v3Arr[4] * w4
end

local function BezierPatch(controlV3Arr, u, v)
	local v3secondLayerArr = {}
	for i = 0, 3 do
		local v3Arr = {controlV3Arr[i * 4 + 1], controlV3Arr[i * 4 + 2], controlV3Arr[i * 4 + 3], controlV3Arr[i * 4 + 4]}
		table.insert(v3secondLayerArr, BezierFunc(v3Arr, u))
	end
	return BezierFunc(v3secondLayerArr, v)
end

function Model:ProcessBezierHandle(subDivNum)
	if (not subDivNum) then subDivNum = 2 end
	local patchArr2 = self:GetPatchArr2()
	local controlV3Arr = self:GetPointArr()
	self.processedPointArr = {}
	for _, patchArr in ipairs(patchArr2) do
		local patchV3Arr = table.map(patchArr, function(i) return controlV3Arr[i] end)
		local processedPatchArr2 = {}
		local subDivNumP1 = subDivNum + 1
		for i = 0, subDivNumP1 do
			local patchResV3Arr = {}
			for j = 0, subDivNumP1 do
				table.insert(patchResV3Arr, BezierPatch(patchV3Arr, j / subDivNumP1, i / subDivNumP1))
			end
			table.insert(processedPatchArr2, patchResV3Arr)
		end
		for i = 1, subDivNum do
			for j = 1, subDivNum do
				table.insert(self.processedPointArr, processedPatchArr2[i][j])
				table.insert(self.processedPointArr, processedPatchArr2[i][j + 1])
				table.insert(self.processedPointArr, processedPatchArr2[i + 1][j])
				table.insert(self.processedPointArr, processedPatchArr2[i][j + 1])
				table.insert(self.processedPointArr, processedPatchArr2[i + 1][j + 1])
				table.insert(self.processedPointArr, processedPatchArr2[i + 1][j])
			end
		end
	end
end

function Model:SetPointArr(pointArr)
	self.pointArr = pointArr
	if (#pointArr <= 0) then return end
	-- 设置默认锚点
	local sumX, sumY, sumZ = 0, 0, 0
	for _, v3 in ipairs(pointArr) do
		sumX = sumX + v3.x
		sumY = sumY + v3.y
		sumZ = sumZ + v3.z
	end
	local count = #pointArr
	self.anchor = Vector3.New(sumX / count, sumY / count, sumZ / count)
end

function Model:GetPointArr()
	return self.pointArr
end

function Model:GetProcessedPointArr()
	return self.processedPointArr
end

function Model:GetPatchArr2()
	return self.patchArr2
end

function Model:SetAnchor(v3)
	self.anchor = v3
end

function Model:GetAnchor()
	return self.anchor
end

function Model:SetColor(color)
	self.color = color
end

function Model:GetColor()
	return self.color
end

function Model:SetPosition(v3)
	self.transform:SetTranslation(v3)
end

function Model:SetScale(v3)
	self.transform:SetScale(v3)
end

function Model:GetTransform()
	return self.transform
end

function Model:SetRotation(v3)
	self.rotation:SetByEuler(v3)
end

function Model:SetRotationByQuaternion(q)
	self.rotation = q
end

function Model:GetRotation()
	return self.rotation
end

return Model