local LevelItem = class("LevelItem")

require("Klotski/GameData")
require("Klotski/KlotskiDefine")

local HerosPanel = require("Klotski/HerosPanel")

local index

local levelPanel

function LevelItem:ctor(levelPanel, parentNode, templateItem, index, data,clickCallfunc)

	self.itemSpacing = 0
	self.itemSize = Vector2.New(435, 148)

	self.index = index
	self.levelPanel = levelPanel

	local itemPrefab = GameObject.Instantiate(templateItem).gameObject

	local gridItemSize = parentNode.transform.sizeDelta

	itemPrefab.transform:SetParent(parentNode.transform)
	
	itemPrefab:SetActive(true)
	itemPrefab.name = "item_"..index
	
	itemPrefab.transform.sizeDelta = self.itemSize
	
	itemPrefab.transform.localPosition = Vector2.New(0, gridItemSize.y*0.5 - (index-0.5) * (self.itemSize.y + self.itemSpacing))
	itemPrefab.transform.localScale = Vector3.one

	if index < 10 then 
		itemPrefab.transform:Find("LevelNum"):Find("Grid"):GetChild(1):GetComponent("Image").sprite = NumberSpriteMgr.GetSprite(index)
	else
		itemPrefab.transform:Find("LevelNum"):Find("Grid"):GetChild(0):GetComponent("Image").sprite = NumberSpriteMgr.GetSprite(1) 
		itemPrefab.transform:Find("LevelNum"):Find("Grid"):GetChild(1):GetComponent("Image").sprite = NumberSpriteMgr.GetSprite(0)
	end


	local clickEventBtn = itemPrefab.Find("ClickEvent").gameObject

	clickEventBtn.name = "ClickEvent"..index
	
	-- 先删除掉以防万一
	QApp.QLuaBehaviour:RemoveClick(clickEventBtn);

	QApp.QLuaBehaviour:AddClick(clickEventBtn,function (go)

		clickCallfunc()

		QFramework.QUtil.Log("clickEventBtn")

		HerosPanel.new(QApp.Canvas, index)
	end)

	local bestStep = PlayerPrefs.GetInt(index .. "_bestStep", 0)

	local tmpBestStep = bestStep
	for i=3,0,-1 do
		local bitValue = math.modf(tmpBestStep)
		itemPrefab.transform:Find("BestStepNum"):Find("Grid"):GetChild(i):GetComponent("Image").sprite = NumberSpriteMgr.GetSprite(bitValue%10)
		tmpBestStep = tmpBestStep / 10 
	end


	local crossed = PlayerPrefs.GetInt(index.."_crossed", 0)

	itemPrefab.transform:Find("CrossLevelMark").gameObject:SetActive((crossed == 1))
end


function LevelItem:Show()
	
end

return LevelItem