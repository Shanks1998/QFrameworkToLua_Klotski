require("Klotski/GameData")
require("Klotski/KlotskiDefine")

local AccountPanel = require("Klotski/AccountPanel")
local HelpPanel = require("Klotski/HelpPanel")
local HerosPanel = class("HerosPanel")
local peoples
local peopleUnitSize
local initHeroList
local PlayPanel
local stepLabel
local bestStep
local levelName
local stepRecord
local passData
local curStageHeros
local curBeganDragPos
local heroPanel
local parentNode
local herosPanelCellFlag
local panelCellWidthNum
local panelCellHeightNum
local mainRoleInfo
local isGameOver
local accountPnlCtrl
local levelIndex
local curDragItemIndex
local UnitWidth
local UnitHeight
local HeroPosMin
local HeroPosMax

function HerosPanel:ctor(mainPage, levelIndex)
	self.parentNode = mainPage
	self.levelIndex = levelIndex
	self:ResetData()
	self:InitUI()
	self.updateDelegate = function() self:Update() end
	QFrameworkLua.QLuaApp.Instance.onUpdate = QFrameworkLua.QLuaApp.Instance.onUpdate + self.updateDelegate
	self:GameOver()
end

function HerosPanel:ResetData()
	self.peopleUnitSize = 110
	self.stepRecord = 0
	self.panelCellWidthNum = 4
	self.panelCellHeightNum = 5
	self.mainRoleInfo = nil
	self.isGameOver = false
	self.curDragItemIndex = -1
	self.UnitWidth = 98
	self.UnitHeight = 98
	self.HeroPosMin = {x=-196, y=-245}
	self.HeroPosMax = {x=196, y=245}
	self.herosPanelCellFlag = {}
	for i=1, self.panelCellWidthNum, 1 do
		self.herosPanelCellFlag[i] = {}
		for j=1, self.panelCellHeightNum, 1 do
			self.herosPanelCellFlag[i][j] = {id=0, flag=false}
		end
	end
	soundMgr:Play(soundMgr:LoadAudioClip("Sound/gamebegan"),QFrameworkLua.QLuaApp.Instance.transform.position)
end

function HerosPanel:InitUI()

	local prefab = Resources.Load("UIPrefab/PlayPanel")
	self.PlayPanel = GameObject.Instantiate(prefab)

	self.PlayPanel.transform:SetParent(self.parentNode.transform)

	self.PlayPanel.transform.localPosition = Vector3.zero
	self.PlayPanel.transform.localScale = Vector3.one

	self.PlayPanel.name = "PlayPanel"

	self.stepLabel = self.PlayPanel.transform:Find("StepLabel"):Find("Grid")
	self.bestStep = self.PlayPanel.transform:Find("BestStep"):Find("Grid")
	self.levelName = self.PlayPanel.transform:Find("Level"):Find("Grid")


	local backBtn = self.PlayPanel.transform:Find("BackBtn").gameObject

	local listener = QUIEventListener.Get(backBtn)

	listener.onClick = function ( go )

		QFrameworkLua.QLuaApp.Instance.onUpdate = QFrameworkLua.QLuaApp.Instance.onUpdate - self.updateDelegate

		GameObject.Destroy(self.PlayPanel)

		LevelPanel:New(self.parentNode)

	end


		
	-- 结算面板
	local accountPanel = self.PlayPanel.Find("AccountPanel").gameObject

	self.accountPnlCtrl = AccountPanel.new(accountPanel, self, self.levelIndex)

	self:ResetHerosInfo(self.levelIndex)



	-- 帮助面板
	local helpPanelTrans = self.PlayPanel.transform:Find("HelpPanel")
	self.helpPanel = HelpPanel.new(helpPanelTrans)

	if PlayerPrefs.GetInt("NotFirstEnterGame", 0) == 0 then 
		self.helpPanel:show()
		PlayerPrefs.SetInt("NotFirstEnterGame", 1)
	else 
		self.helpPanel:hide()
	end 

	--帮助按钮
	local helpBtn = self.PlayPanel.transform:Find("HelpBtn").gameObject

	QUIEventListener.Get(helpBtn).onClick = function ( go )
		
		self.helpPanel:show()	
	end



end

function HerosPanel:SetStepNum(num)
	local tmpNum = num
	QFramework.QUtil.Log(tmpNum)
	for i=3,0,-1 do
		local value = math.modf(tmpNum) 
		self.stepLabel:GetChild(i):GetComponent("Image").sprite = NumberSpriteMgr.GetSprite(value %10)
		tmpNum = tmpNum / 10 
		QFramework.QUtil.Log(value)
	end

end

function HerosPanel:SetLevelNum(num)
	local tmpNum = num
	for i=1,0,-1 do
		local value = math.modf(tmpNum) 
		value = value % 10
		self.levelName:GetChild(i):GetComponent("Image").sprite = NumberSpriteMgr.GetSprite(value %10)
		tmpNum = tmpNum / 10 

	end
end

function HerosPanel:SetBestStepNum(num)
	local tmpNum = num
	for i=3,0,-1 do
		local value = math.modf(tmpNum) 
		value = value % 10
		self.bestStep:GetChild(i):GetComponent("Image").sprite = NumberSpriteMgr.GetSprite(value %10)
		tmpNum = tmpNum / 10 
	end
end

function HerosPanel:ResetHerosInfo(levelIndex)

	self:ResetData()

	self.levelIndex = levelIndex

	local stageData = GameData.LevelsData[levelIndex]

	self.initHeroList = stageData.data


	self:SetLevelNum(levelIndex)

	self.accountPnlCtrl.levelIndex = levelIndex
	self.accountPnlCtrl:Hide()

	self:SetBestStepNum(PlayerPrefs.GetInt(self.levelIndex.."_bestStep", 0))
	self:SetStepNum(self.stepRecord)
	self:SetLevelNum(self.levelIndex)
	if 1 == KLOTSKI_DEBUG then
		self:CreateDebugPosFlagText()
	end

	self:PutHeroToPanel()
end

function HerosPanel:ResizePanel()

	local backgroundSize = self.PlayPanel.Find("RolePanelBg").transform.sizeDelta

	self.UnitWidth = backgroundSize.x / self.panelCellWidthNum
	self.UnitHeight = backgroundSize.y / self.panelCellHeightNum

	self.HeroPosMin = Vector2.New(-self.UnitWidth*2, -self.UnitHeight*2.5)
	self.HeroPosMax = Vector2.New(self.UnitWidth*2, self.UnitHeight*2.5)

end

function HerosPanel:GetHeroSizeById(heroId)

	for k, v in pairs(GameData.HeroSize) do
		if (v.id == heroId) then
			return v
		end
	end

	print("Error not found data")

	return nil
end

function HerosPanel:MarkHeroFlag(heroInfo)
	local sizeData = self:GetHeroSizeById(heroInfo.hero)

	local halfWidth = sizeData.width * 0.5
	local halfHeight = sizeData.height * 0.5

	local minx = heroInfo.x - halfWidth + 1
	local maxx = heroInfo.x + halfWidth
	local maxy = heroInfo.y + halfHeight
	local miny = heroInfo.y - halfHeight + 1

	self:MarkCellFlag(true, {minx=minx, miny=miny, maxx=maxx, maxy=maxy}, heroInfo.id)
end

function HerosPanel:MarkCellFlag(value, cellRect, id)

	for i=cellRect.minx, cellRect.maxx, 1 do

		for j=cellRect.miny, cellRect.maxy, 1 do

			if value then

				self.herosPanelCellFlag[i][j] = {id=id, flag=true, cell=cellRect}

				if 1 == KLOTSKI_DEBUG then

					self.DebugPosFlagTable[i][j].text = 1
				end
			else

				self.herosPanelCellFlag[i][j] = {flag=false}

				if 1 == KLOTSKI_DEBUG then
					self.DebugPosFlagTable[i][j].text = 0
				end
			end
		end
	end
end

function HerosPanel:PutHeroToPanel()

	self.heroPanel = self.PlayPanel.Find("RolePanel").gameObject

	self.heroPanel.transform:DetachChildren()

	if nil ~= self.curStageHeros then
		for index=1, #self.curStageHeros, 1 do
			GameObject.Destroy(self.curStageHeros[index].prefab)
		end
	end

	self.curStageHeros = {}

	for k, v in pairs(self.initHeroList) do

		local rectSize = self:GetHeroSizeById(v.hero)

		local position = Vector3.New(v.x * self.UnitWidth + self.HeroPosMin.x, v.y * self.UnitHeight + self.HeroPosMin.y, 0)

		local heroInfo = GameData.GetHeroInfoById(v.hero)

		local prefabName = "UIPrefab/"..heroInfo.icon
		local heroPrefab = GameObject.Instantiate(Resources.Load(prefabName))

		heroPrefab.name = heroInfo.icon .. "_" ..k
		heroPrefab:SetActive(true)

		heroPrefab.transform:SetParent(self.heroPanel.transform)

		heroPrefab.transform.localPosition = position
		heroPrefab.transform.localScale = Vector3.one

		heroPrefab.transform.sizeDelta = Vector2.New(rectSize.width*self.UnitWidth, rectSize.height*self.UnitHeight)

		self.curStageHeros[#self.curStageHeros+1] = {id=v.id, prefab=heroPrefab}

		local tmpHeroId = v.id

		self:AddItemEventListener(tmpHeroId, QUIEventListener.Get(heroPrefab))

		--mark flag
		self:MarkHeroFlag(v);

		if 1 == heroInfo.main then
			if (nil ~= self.mainRoleInfo) then print("config error!") end

			local terminalPosX = (1+rectSize.width*0.5) * self.UnitWidth + self.HeroPosMin.x
			local terminalPosY = (rectSize.height*0.5) * self.UnitHeight + self.HeroPosMin.y

			self.mainRoleInfo = {prefab=heroPrefab, terminal=Vector2.New(terminalPosX, terminalPosY)}
		end
	end
end

function HerosPanel:AddItemEventListener(id, listener)
	-- 先保存
	local savedColor = Color.white
	listener.onPointerDown = function (event)
		local prefab = self:GetHeroPrefabById(id)
		savedColor = prefab.gameObject:GetComponent("Image").color
		prefab.gameObject:GetComponent("Image").color = Color.New(0.5,0.5,0.5,1)
	end

	listener.onPointerUp = function (event)
		local prefab = self:GetHeroPrefabById(id)
		prefab.gameObject:GetComponent("Image").color = savedColor
	end

	-- add listener
	listener.onBeginDrag = function (event)

		local prefab = self:GetHeroPrefabById(id)

		self.beganDragItemPos = prefab.transform.localPosition

		self.curBeganDragPos = event.position

		self.curDragItemIndex = id
	end

	listener.onDrag = function(event)

		self:DragItem(id, event.position)

	end

	listener.onEndDrag = function ( event )

		listener.gameObject:GetComponent("Image").color = savedColor

		local prefab = self:GetHeroPrefabById(id)

		local direction = self:GetDirection(event.position)

		local curDragItemCellLocation = self:GetCellFlagInfoById(id)

		local nextCellLocation

		if direction == Direction.Right or direction == Direction.Left then

			local moveDis = prefab.transform.localPosition.x - self.beganDragItemPos.x

			local moveCellNum, resteNum = math.modf(moveDis / self.UnitWidth)

			moveCellNum = moveCellNum + self:RoundOff(resteNum)

			nextCellLocation = {minx= curDragItemCellLocation.minx+moveCellNum, miny=curDragItemCellLocation.miny, 
							maxx=curDragItemCellLocation.maxx+moveCellNum, maxy=curDragItemCellLocation.maxy}

			prefab.transform.localPosition = Vector3.New(self.beganDragItemPos.x + self.UnitWidth*moveCellNum, self.beganDragItemPos.y)

			self.stepRecord = self.stepRecord + math.abs(moveCellNum)
			self:SetStepNum(self.stepRecord)

		elseif direction == Direction.Up or direction == Direction.Down then

			local moveDis = prefab.transform.localPosition.y - self.beganDragItemPos.y

			local moveCellNum, resteNum = math.modf(moveDis / self.UnitHeight)

			moveCellNum = moveCellNum + self:RoundOff(resteNum)

			nextCellLocation = {minx=curDragItemCellLocation.minx, miny=curDragItemCellLocation.miny+moveCellNum, 
							maxx=curDragItemCellLocation.maxx, maxy=curDragItemCellLocation.maxy+moveCellNum}

			prefab.transform.localPosition = Vector3.New(self.beganDragItemPos.x, self.beganDragItemPos.y + self.UnitHeight*moveCellNum)

			self.stepRecord = self.stepRecord + math.abs(moveCellNum)
			self:SetStepNum(self.stepRecord)
		end

		self:MarkCellFlag(false, curDragItemCellLocation, id)

		self:MarkCellFlag(true, nextCellLocation, id)
	end
end

function HerosPanel:RoundOff(num)

	if num > 0.5 then 
		return 1
	elseif num <= 0.5 and num >= -0.5 then
		return 0
	elseif num < -0.5 then
		return -1
	end
end

function HerosPanel:CreateDebugPosFlagText()

	self.DebugPosFlagTable = {}

	local templateText = self.PlayPanel.Find("TemplateText").gameObject

	local debugPanel = self.PlayPanel.Find("DebugPanel").gameObject

	for i=1, self.panelCellWidthNum, 1 do

		self.DebugPosFlagTable[i] = {}

		for j=1, self.panelCellHeightNum, 1 do
			local prefab = GameObject.Instantiate(templateText)

			prefab.name = "PosFlag"..i.."_"..j

			prefab.transform:SetParent(debugPanel.transform)

			local posX = (i - 0.5) * self.UnitWidth + self.HeroPosMin.x
			local posY = (j - 0.5) * self.UnitHeight + self.HeroPosMin.y

			prefab.transform.localPosition = Vector3.New(posX, posY, 0)

			local label = prefab:GetComponent("Text")

			label.text = 0

			self.DebugPosFlagTable[i][j] = label
		end
	end

end

function HerosPanel:GetCellFlagInfoById(id)

	for i=1, self.panelCellWidthNum, 1 do
		for j=1, self.panelCellHeightNum, 1 do

			if (self.herosPanelCellFlag[i][j].id == id) then
				return self.herosPanelCellFlag[i][j].cell	
			end
		end
	end

	return nil
end

function HerosPanel:GetHeroPrefabById(id)
	if #self.curStageHeros < 1 then return nil end

	for i=1, #self.curStageHeros, 1 do
		if self.curStageHeros[i].id == id then
			return self.curStageHeros[i].prefab
		end
	end

	return nil
end


function HerosPanel:Update()

	if (nil ~= self.PlayPanel) then

		if not self.isGameOver then
			self:GameOver()
		end
	end
end

function HerosPanel:DragItem(id, dragPos)

	local horizontalMoveDis = dragPos.x - self.curBeganDragPos.x
	local verticalMoveDis = dragPos.y - self.curBeganDragPos.y

	local direction = self:GetDirection(dragPos)

	local prefab = self:GetHeroPrefabById(id)

	local curCellLocation = self:GetCellFlagInfoById(id)

	local itemNewPosition

	if direction == Direction.Right or direction == Direction.Left then

		local horizontalMoveDis = dragPos.x - self.curBeganDragPos.x

		itemNewPosition = self.beganDragItemPos + Vector3.New(horizontalMoveDis, 0, 0)
	
	elseif direction == Direction.Up or direction == Direction.Down then 

		local verticalMoveDis = dragPos.y - self.curBeganDragPos.y

		itemNewPosition = self.beganDragItemPos + Vector3.New(0, verticalMoveDis, 0)
	else
		print("direction error!")

		return false
	end

	local fixPosition = self:CheckDragHeroPosRange(id, itemNewPosition, direction)

	prefab.transform.localPosition = fixPosition
end


function HerosPanel:CheckDragHeroPosRange(id, newPosition, direction)

	if direction == Direction.Right then

		local rightEdge = self:FindMoveEdge(id, Direction.Right)

		if newPosition.x > rightEdge then
			return Vector3.New(rightEdge, newPosition.y, newPosition.z)
		end

	elseif direction == Direction.Left then

		local leftEdge = self:FindMoveEdge(id, Direction.Left)

		if newPosition.x < leftEdge then 
			return Vector3.New(leftEdge, newPosition.y, newPosition.z)
		end

	elseif direction == Direction.Up then

		local upEdge = self:FindMoveEdge(id, Direction.Up)

		if newPosition.y > upEdge then 
			return Vector3.New(newPosition.x, upEdge, newPosition.z)
		 end

	elseif direction == Direction.Down then

		local downEdge = self:FindMoveEdge(id, Direction.Down)

		if newPosition.y < downEdge then 
			return Vector3.New(newPosition.x, downEdge, newPosition.z)
		end
	end

	return newPosition
end


function HerosPanel:FindItemCellIndex(id)

	for i=1, self.panelCellWidthNum, 1 do
		for j=1, self.panelCellHeightNum, 1 do

			if self.herosPanelCellFlag[i][j].flag and self.herosPanelCellFlag[i][j].id == id then
				return i, j				
			end
		end
	end
 
	return -1, -1
end

function HerosPanel:GetHeroIdByNormalId(id)

	for k, v in pairs(self.initHeroList) do
		if (v.id == id) then
			return v.hero
		end
	end

	return -1
end

function HerosPanel:FindMoveEdge(id, direction)

	local heroSize = self:GetHeroSizeById(self:GetHeroIdByNormalId(id))

	local curCellLocation = self:GetCellFlagInfoById(id)

	if direction == Direction.Right then

		local isSpaces = true

		for i=curCellLocation.maxx+1, self.panelCellWidthNum, 1 do

			for j=curCellLocation.miny, curCellLocation.maxy, 1 do

				if self.herosPanelCellFlag[i][j].flag then

					isSpaces = false
					break
				end
			end

			if not isSpaces then

				local spaceIndex = i - 1

				return (spaceIndex - 0.5*heroSize.width) * self.UnitWidth + self.HeroPosMin.x
			end
		end

		if isSpaces then
			return (self.panelCellWidthNum - 0.5*heroSize.width) * self.UnitWidth + self.HeroPosMin.x
		end
		
	elseif direction == Direction.Left then

		local isSpaces = true

		for i=curCellLocation.minx-1, 1, -1 do

			for j=curCellLocation.miny, curCellLocation.maxy, 1 do

				if self.herosPanelCellFlag[i][j].flag then

					isSpaces = false
					break
				end
			end

			if not isSpaces then

				return (i + 0.5*heroSize.width) * self.UnitWidth + self.HeroPosMin.x
			end
		end

		if isSpaces then
			return 0.5 * self.UnitWidth * heroSize.width + self.HeroPosMin.x
		end

	elseif direction == Direction.Up then

		local isSpaces = true

		for i=curCellLocation.maxy+1, self.panelCellHeightNum, 1 do

			local isSpaces = true

			for j=curCellLocation.minx, curCellLocation.maxx, 1 do

				print("up cell "..i.." -- "..j.." -- "..tostring(self.herosPanelCellFlag[j][i].flag ))

				if self.herosPanelCellFlag[j][i].flag then

					isSpaces = false
					break
				end
			end

			if not isSpaces then

				local spaceIndex = i - 1

				return (spaceIndex - 0.5*heroSize.height) * self.UnitHeight + self.HeroPosMin.y
			end

		end

		if isSpaces then
			return (self.panelCellHeightNum - 0.5*heroSize.height) * self.UnitHeight + self.HeroPosMin.y
		end

	elseif direction == Direction.Down then

		local isSpaces = true

		for i=curCellLocation.miny-1, 1, -1  do
			
			for j=curCellLocation.minx, curCellLocation.maxx, 1 do

				if self.herosPanelCellFlag[j][i].flag then

					isSpaces = false
					break
				end
			end

			if not isSpaces then

				return (i + 0.5*heroSize.height) * self.UnitHeight + self.HeroPosMin.y
			end
		end

		if isSpaces then
			return 0.5 * self.UnitHeight * heroSize.height + self.HeroPosMin.y
		end
	end

	return 0

end

function HerosPanel:GetHeroInfo(id)
	for i=1, #self.initHeroList, 1 do

		if self.initHeroList[i].id == id then
			return self.initHeroList[i]
		end
	end
	 
	return nil
end

function HerosPanel:GetHeroCellFlagInfo(id)
	for i=1, self.panelCellWidthNum, 1 do

		self.herosPanelCellFlag[i] = {}

		for j=1, self.panelCellHeightNum, 1 do

			self.herosPanelCellFlag[i][j] = {id=0, flag=false}

			if id == self.herosPanelCellFlag[i][j].id then

			end
		end
	end
end


function HerosPanel:GetDirection(dragPos)

	local horizontalMoveDis = dragPos.x - self.curBeganDragPos.x
	local verticalMoveDis = dragPos.y - self.curBeganDragPos.y

	local isHorizontalMove = math.abs(horizontalMoveDis) > math.abs(verticalMoveDis)

	local direction = Direction.Now

	if isHorizontalMove then
		if horizontalMoveDis > 0 then
			direction = Direction.Right
		else
			direction = Direction.Left
		end
	else
		if verticalMoveDis > 0 then
			direction = Direction.Up
		else
			direction = Direction.Down
		end
	end

	return direction
end


function HerosPanel:MoveHeroCard(id, direction)

	local prefab = self:GetHeroPrefabById(id)

	print("prefab " .. prefab.name)

	local curPosition = prefab.transform.localPosition
	local curCellLocation = self:GetCellFlagInfoById(id)

	local nextCellLocation, nextPosition
	local newCellRange = {}

	if direction == Direction.Up then

		nextCellLocation = {minx=curCellLocation.minx, miny=curCellLocation.miny+1, 
							maxx=curCellLocation.maxx, maxy=curCellLocation.maxy+1}

		newCellRange = {minx=curCellLocation.minx, miny=curCellLocation.maxy+1, 
							maxx=curCellLocation.maxx, maxy=curCellLocation.maxy+1}

		nextPosition = Vector3.New(curPosition.x, curPosition.y+self.UnitHeight, curPosition.z)

	elseif direction == Direction.Down then

		nextCellLocation = {minx=curCellLocation.minx, miny=curCellLocation.miny-1, 
							maxx=curCellLocation.maxx, maxy=curCellLocation.maxy-1}

		newCellRange = {minx=curCellLocation.minx, miny=curCellLocation.miny-1, 
							maxx=curCellLocation.maxx, maxy=curCellLocation.miny-1}

		nextPosition = Vector3.New(curPosition.x, curPosition.y-self.UnitHeight, curPosition.z)

	elseif direction == Direction.Left then

		nextCellLocation = {minx=curCellLocation.minx-1, miny=curCellLocation.miny, 
							maxx=curCellLocation.maxx-1, maxy=curCellLocation.maxy}

		newCellRange = {minx=curCellLocation.minx-1, miny=curCellLocation.miny, 
							maxx=curCellLocation.minx-1, maxy=curCellLocation.maxy}

		nextPosition = Vector3.New(curPosition.x-self.UnitWidth, curPosition.y, curPosition.z)

	elseif direction == Direction.Right then

		nextCellLocation = {minx=curCellLocation.minx+1, miny=curCellLocation.miny, 
							maxx=curCellLocation.maxx+1, maxy=curCellLocation.maxy}

		newCellRange = {minx=curCellLocation.maxx+1, miny=curCellLocation.miny,
							maxx=curCellLocation.maxx+1, maxy=curCellLocation.maxy}

		nextPosition = Vector3.New(curPosition.x+self.UnitWidth, curPosition.y, curPosition.z)

	end

	if self:IsOutHeroPanelRange(newCellRange) then return false end

	if not self:HasCellSpaces(newCellRange) then return false end

	prefab.transform.localPosition = nextPosition

	local curCellLocation = self:GetCellFlagInfoById(id)

	self:MarkCellFlag(false, curCellLocation)
	self:MarkCellFlag(true, nextCellLocation, id)

	self.stepRecord = self.stepRecord+1
	self:SetStepNum(self.stepRecord)

	return true
end

function HerosPanel:IsOutHeroPanelRange(cellRange)
	return (cellRange.minx < 1 
		or cellRange.miny < 1 
		or cellRange.maxx > self.panelCellWidthNum 
		or cellRange.maxy > self.panelCellHeightNum)
end

function HerosPanel:HasCellSpaces(cellRange)
	for i=cellRange.minx, cellRange.maxx, 1 do
		for j=cellRange.miny, cellRange.maxy, 1 do

			if self.herosPanelCellFlag[i][j].flag then
				return false
			end
		end
	end

	return true
end

function HerosPanel:GameOver()
	if nil ~= self.mainRoleInfo then
		local curPosition = self.mainRoleInfo.prefab.transform.localPosition
		local terminalPos = self.mainRoleInfo.terminal

		if math.abs(curPosition.x - terminalPos.x) < 2 and math.abs(curPosition.y - terminalPos.y) < 2 then
			self.isGameOver = true
			self.accountPnlCtrl:Show()
			local preBestStep = PlayerPrefs.GetInt(tostring(self.levelIndex), 0)
			PlayerPrefs.SetInt(self.levelIndex.."_crossed", 1)
			if self.stepRecord < preBestStep or preBestStep == 0 then
				PlayerPrefs.SetInt(self.levelIndex.."_bestStep", self.stepRecord)
				soundMgr:Play(soundMgr:LoadAudioClip("Sound/newscore"),QFrameworkLua.QLuaApp.Instance.transform.position)
			else 
				soundMgr:Play(soundMgr:LoadAudioClip("Sound/success"),QFrameworkLua.QLuaApp.Instance.transform.position)
			end
		end
	end
end

return HerosPanel