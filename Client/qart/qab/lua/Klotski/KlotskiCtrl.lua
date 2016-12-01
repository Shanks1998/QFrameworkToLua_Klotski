-- 华容道。开始逻辑

KlotskiCtrl = {}

local this = KlotskiCtrl

require("Klotski/LevelPanel")
local HomePanel = require("Klotski/HomePanel")
require("Klotski/NumberSpriteMgr")
function KlotskiCtrl.EnterGame()
	QFramework.QUtil.Log("进入游戏"..":".."华容道")
	this.Init()
end

function KlotskiCtrl.Init()
	QFramework.QUtil.Log("初始化")
	QApp.Canvas = GameObject.Find("Canvas/KlotskiPage").transform
	HomePanel.new():Enter()
	--this.mPlayPanel = this.mPage:Find("PlayPanel").gameObject
	--this.mLevelPanel = this.mPage:Find("LevelPanel").gameObject
end

function KlotskiCtrl.Show()
	this.mPage.gameObject:setActive(true)
end

function KlotskiCtrl.Hide()
	this.mPage.gameObject:SetActive(false)
end

return KlotskiCtrl