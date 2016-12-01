--
-- Author: Your Name
-- Date: 2016-10-06 19:28:49
--

local MapLayer = class("MapLayer",require("cc.CCNode"))
local HomeLayer = require("GrayRun/Home/HomeLayer")
local MapPage = require("GrayRun/Map/MapPage")
local CCButton = require("cc.CCButton")
function MapLayer:ctor()
	QFramework.QUtil.Log("Ctor Map Layer")
	self.super:ctor()

	self.transform = QApp.GrayRun.transform:Find("UIMapLayer")
	self.gameObject = self.transform.gameObject
end

function MapLayer:Enter()
	QFramework.QUtil.Log("Enter Map Layer")

	self:InitData()
	self:SetupBg()
end

function MapLayer:InitData()
	local curStage = PlayerPrefs.GetInt("curStage",1)
	local curMapInt = math.modf((curStage - 1) / 10)
	self.mCurMap =  curMapInt % 10

	self.eUp = true
	self.eDown = true

	self.eTouch = true
	self.eMove = true
end

function MapLayer:SetupBg()
	
	local map1 = MapPage.new()
	map1:setName("map1")
	map1:setStageCount(10,0)
	map1:setPosition(320,960 * self.mCurMap + 480)
	map1:addTo(self.transform)

	for i=1,9 do
		local map2 = MapPage.new()
		map2:setPosition(320,-960 * i + 480)
		map2:setStageCount(5,i);
		map2:addTo(map1.transform)
	end

	local btnBack = CCButton.create("GrayRun/Sprite/ui/back", "GrayRun/Sprite/ui/back", function()
		QFramework.QUtil.Log("BtnBackClick")
		self:BackToHome()
	end)
	btnBack:setName("btnBack")
	btnBack:setPosition(80,909)
	btnBack:addTo(self.transform)
	self:setProperty("btnBack", btnBack)

	local btnDown = nil
	local btnUp = nil 
	btnUp = CCButton.create("GrayRun/Sprite/ui/down","GrayRun/Sprite/ui/down",function ()
		QFramework.QUtil.Log("btnUpClick")
		if not self.eTouch then return end 
		if not self.eUp then return end 
		if self.mCurMap ~= 0 then 
			self.mCurMap = self.mCurMap - 1
			
			QSoundMgr:Play(soundMgr:LoadAudioClip("GrayRun/Sound/mapslide"),Vector2.zero)

			btnUp:show()
			btnDown:show()

			self.eUp = true 
			self.eDown = true 
			self.eMove = false 
			map1.transform:DOLocalMoveY(960 * self.mCurMap,0.3,true):OnComplete(function ()
				QFramework.QUtil.Log("UpComplete")
			end)
		end

		if self.mCurMap == 0 then 
			btnUp:show()
			self.eUp = false
		end
	end)
	btnUp:setName("btnUp")
	btnUp:setPosition(320,857)
	btnUp:setScale(1, -1)
	btnUp:addTo(self.transform)
	self:setProperty("btnUp", btnUp)


	btnDown = CCButton.create("GrayRun/Sprite/ui/down","GrayRun/Sprite/ui/down",function ()
		QFramework.QUtil.Log("BtnDownClick")
		if not self.eTouch then return end 
		if not self.eDown then return end 
		if self.mCurMap ~= 9 then 
			self.mCurMap = self.mCurMap + 1
			QSoundMgr:Play(soundMgr:LoadAudioClip("GrayRun/Sound/mapslide"),Vector2.zero)

			btnUp:show()
			btnDown:show()

			self.eUp = true
			self.eDown = true 
			self.eMove = false

			map1.transform:DOLocalMoveY(960 * self.mCurMap,0.3,true):OnComplete(function ( complete )
				QFramework.QUtil.Log("Down Complete")
			end)
		end 


		if self.mCurMap == 9 then 
			btnDown:hide()
			self.eDown = false
		end 
	end)
	btnDown:setName("btnDown")
	btnDown:setPosition(320,102)
	btnDown:addTo(self.transform)
	self:setProperty("btnDown", btnDown)

	self.eUp = true
	self.eDown = true

	if self.mCurMap == 0 then 
		btnUp:hide()
		self.eUp = false
	end 

	if self.mCurMap == 9 then 
		btnDown:hide()
		self.eDown = false
	end 

end


function MapLayer:BackToHome()
	self:Exit()
	local homeLayer = HomeLayer.new()
	homeLayer:Enter()
end


function MapLayer:Exit()
	self:Destroy()
end

return MapLayer