--
-- Author: Your Name
-- Date: 2016-09-30 20:50:48
--
local HomePanel = class("HomePanel")

local About = require("Klotski/About")
local LevelPanel = require("Klotski/LevelPanel")

function HomePanel:ctor()
	QFramework.QUtil.Log("进入Home界面")
	local prefab = Resources.Load("UIPrefab/HomePanel")
	self.gameObject = GameObject.Instantiate(prefab)
	self.gameObject:SetActive(false)
	self.transform = self.gameObject.transform
	self.transform:SetParent(QApp.Canvas)
	self.transform.localPosition = Vector3.zero
	self.transform.localScale = Vector3.one

	self.mBtnStart = self.transform:Find("BtnStart").gameObject
	self.mBtnAbout = self.transform:Find("BtnAbout").gameObject

	self.mAbout = About.new(self.transform:Find("About"))
	self.mAbout:Hide()
end

function HomePanel:Enter()
	self.gameObject:SetActive(true)

	soundMgr:PlayBacksound("Sound/bg",true)

	QUIEventListener.Get(self.mBtnStart).onClick = function (go) 
		QFramework.QUtil.Log("BtnStart Click")
		self:OnDestroy()
		LevelPanel.new(QApp.Canvas)
	end
	
	QUIEventListener.Get(self.mBtnAbout).onClick = function (go)
		QFramework.QUtil.Log("BtnAbout Click")
		self.mAbout:Show()
	end
end

function HomePanel:Exit()
	
end

function HomePanel:OnDestroy()
	GameObject.Destroy(self.gameObject)
end

return HomePanel