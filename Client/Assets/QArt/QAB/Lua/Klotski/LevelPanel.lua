LevelPanel = class("LevelPanel")

require("Klotski/GameData")
require("Klotski/KlotskiDefine")

local LevelItem = require("Klotski/LevelItem")


local parentNode
local contentView
local gridItemTable

local itemSpacing
local itemSize

local levelPanel

-- 为了兼容以前的版本 没有必要传parentTransform
function LevelPanel.New(parentTransform)
	return LevelPanel.new()
end

function LevelPanel:ctor()

	local prefab = Resources.Load("UIPrefab/LevelPanel")

	self.gameObject = GameObject.Instantiate(prefab).gameObject
	self.transform = self.gameObject.transform
	self.transform:SetParent(QApp.Canvas)

	self.transform.localPosition = Vector3.zero
	self.transform.localScale = Vector3.one

	self.mItemSpacing = 30
	self.mItemSize = Vector2.New(435, 148)

	local rectTransform = self.gameObject:GetComponent('RectTransform')

	rectTransform.offsetMin = Vector2.New(0, 0)
	rectTransform.offsetMax = Vector2.New(0, 0)

	self.gameObject.name = "LevelPanel"

	self.contentViewTrans = self.transform:Find("ContentView")
	self.gridItemTableTrans = self.contentViewTrans:Find("GridTable")

	local templateItemGo = self.gridItemTableTrans:Find("LevelItem").gameObject

	templateItemGo:SetActive(false)

	local stageData = GameData.LevelsData
	local itemCount =  math.modf(#stageData / 4) -- 取整数
	local gridItemSize = Vector2.New(self.mItemSize.x, (self.mItemSize.y + self.mItemSpacing) * itemCount)

	self.gridItemTableTrans.sizeDelta = gridItemSize

	self.gridItemTableTrans.localPosition = Vector3.New(0, (self.contentViewTrans.sizeDelta.y)*0.5 - gridItemSize.y, 0)

	self.mLevelItems = {};
	for k, v in pairs(stageData) do
		self.mLevelItems[#self.mLevelItems + 1] = LevelItem.new(self, self.gridItemTableTrans, templateItemGo, k, v,function (go)
			-- 这样做是避免误导
			self.gameObject:SetActive(false)
			GameObject.Destroy(self.gameObject)
			soundMgr:PlayBacksound("Sound/bg",false)
		end)
	end


end

return LevelPanel