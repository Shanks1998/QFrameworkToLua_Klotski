-- Author: 凉鞋 来自星星的你 Unity版本
-- Date: 2016-09-11 00:13:04
local GrayRunCtrl = class("GrayRunCtrl")

function GrayRunCtrl:ctor()
	QFramework.QUtil.Log("初始化GrayRunCtrl")

	self.transform = GameObject.Find("Canvas").transform
	self.gameObject = self.transform.gameObject
end

local LogoLayer = require("GrayRun/Logo/LogoLayer")
local HomeLayer = require("GrayRun/Home/HomeLayer")
local MapLayer = require("GrayRun/Map/MapLayer")
local GameLayer = require("GrayRun.Game.GameLayer")
local InputCtrl = require("GrayRUn/InputCtrl")

require "Framework.Init"
require "GrayRun.Manager.Init"

function GrayRunCtrl:EnterGame()

	local function preload( )
		QResMgr:Init()

		QFramework.QUtil.Log("进入游戏")

		QApp.GrayRun.InputCtrl = InputCtrl.new(self.transform:Find("InputCtrl"))

		QResMgr:LoadAB("grayrun/prefab")
		-- self.homeLayer = HomeLayer.new()
		-- self.homeLayer:Enter()
		-- self.mapLayer = MapLayer.new()
		-- self.mapLayer:Enter()
		self.gameLayer = GameLayer.new()
		self.gameLayer:Enter()
	end

	coroutine.start(preload)

end

return GrayRunCtrl