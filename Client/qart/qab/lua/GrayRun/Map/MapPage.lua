--
-- Author: Your Name
-- Date: 2016-10-07 17:41:10
--
local MapPage = class("MapPage", require("cc.CCNode"))
local CCSprite = require("cc.CCSprite")
local MapButton = require("GrayRun.Map.MapButton")
local GameLayer = require("GrayRUn.Game.GameLayer")

local x = {
    226.0,426.0
}

local y = {
    780.4+ 14,635.0+ 14,474.0+ 14,335.0+ 14,174.0+ 14
}

function MapPage:ctor()
	self.super:ctor()
	self:createEmptyGo()

	self:initData()
end

function MapPage:initData()
	PlayerPrefs.SetInt("blue1",2)
	PlayerPrefs.SetInt("red1",2)
	PlayerPrefs.SetInt("yellow1",2)
	PlayerPrefs.SetInt("green1",2)
end

function MapPage:setupBg()
	local map = CCSprite.create("GrayRun/Sprite/map/level_map")
	map:setPosition(322.1,478)
	map:addTo(self.transform)
	self:setProperty("map",map)
end


function MapPage:setStageCount(count,world)
	local bgIndex = 0
	if world == 0 or world == 1 then 
		bgIndex = 1
	elseif world == 2 or world == 3 then 
		bgIndex = 2
	elseif world == 4 or world == 5 then 
		bgIndex = 3
	elseif world == 6 or world == 7 then 
		bgIndex = 4
	elseif world == 8 or world == 9 then 
		bgIndex = 5
	end

	local bg = CCSprite.create("GrayRun/Sprite/Bg/bg"..bgIndex)
	bg:setPosition(320,480)
	bg:setZOrder(-1)
	bg:addTo(self.transform)
	self:setProperty("bg",bg)

	-- 在这里添加
	self:setupBg()

	for i=0,9 do
		local menu = nil 
		menu = MapButton.create("GrayRun/Sprite/map/level_bt_red", "GrayRun/Sprite/map/level_bt_red", function (  )
			QFramework.QUtil.Log("menu"..(i + 1 + world * 10).." click")
			if not menu.mNotFirst then return end 
			PlayerPrefs.SetInt("curStage",i + 1 + world * 10)
			QSoundMgr:Play(soundMgr:LoadAudioClip("GrayRun/Sound/mapclick"),Vector2.zero)
		end)
		local yIndex = math.modf(i / 2)
		menu:setName("menu"..(i + 1 + world * 10))
		menu:setStage(i + 1 + world * 10, "level_bt_red")
		menu:setPosition(x[i % 2 + 1],y[yIndex + 1])
		menu:addTo(self.transform)
		self:setProperty("menu"..i,menu)
	end
end

return MapPage