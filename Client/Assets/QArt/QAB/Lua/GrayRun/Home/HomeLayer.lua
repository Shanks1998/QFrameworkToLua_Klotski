--
-- Author: Your Name
-- Date: 2016-09-16 17:03:25
--
local HomeLayer = class("HomeLayer",require("cc.CCNode"))

local CCNode = require("cc.CCNode")
local CCSprite = require("cc.CCSprite")
local CCToggle = require("cc.CCToggle")
local CCButton = require("cc.CCButton")

local BlueHero = require("GrayRun/Objects/BlueHero")
local RedHero = require("GrayRun/Objects/RedHero")
local GreenHero = require("GrayRun/Objects/GreenHero")
local YellowHero = require("GrayRun/Objects/YellowHero")

function HomeLayer:ctor()
	self.super:ctor("GrayRun/Prefab/UIHomeLayer")
	self:setName("UIHomeLayer")
	self:addTo(QApp.GrayRun.transform)
	QFramework.QUtil.Log("进入主界面")
	self.transform = QApp.GrayRun.transform:Find("HomeLayer")
	self.gameObject = self.transform.gameObject
	self.mHeros = {}
	self:hide()
end

function HomeLayer:Enter()
	self:show()

	self:SetupUI()

	QApp.GrayRun.InputCtrl:RegisterInputCallfuncs(
	--	left
	function (  )
		QFramework.QUtil.Log("Left")
		self:Left()
	end, 
	-- right 
	function (  )
		QFramework.QUtil.Log("Right")
		self:Right()
	end)
end

function HomeLayer:Left()
	for i,v in ipairs(self.mHeros) do
		v:Left()
	end
end

function HomeLayer:Right()
	for i,v in ipairs(self.mHeros) do
		v:Right()
	end
end

function HomeLayer:SetupUI()
	-- 添加Logo
	local bg = CCSprite.create("GrayRun/Sprite/home/bg1")
	bg:setName("bg")
	bg:setPosition(320,480)
	bg:addTo(self.transform)
	self:setProperty("bg",bg)

	local logo = CCSprite.create("GrayRun/Sprite/home/home_logo")
	logo:setName("logo")
	logo:setPosition(320, 856)
	logo:addTo(self.transform)
	self:setProperty("logo",logo)

	local bottleShadow = CCSprite.create("GrayRun/Sprite/home/home_jq_sd")
	bottleShadow:setName("bottleShadow")
	bottleShadow:setPosition(316.4,227.8)
	bottleShadow:addTo(self.transform)
	self:setProperty("bottleShadow",bottleShadow)

    -- 声音
    local soundShadow = CCSprite.create("GrayRun/Sprite/home/home_sound_sd")
    soundShadow:setPosition(94,86)
    soundShadow:setName("soundShadow")
   	soundShadow:addTo(self.transform)
   	self:setProperty("soundShadow",soundShadow)

    -- 音效
    local soundToggle = CCToggle.create("GrayRun/Sprite/home/home_sound1","GrayRun/Sprite/home/home_sound2",function (value)
    	if value then
    		QFramework.QUtil.Log("value chaged true")
    	else 
			QFramework.QUtil.Log("value chaged false")
    	end
    end)
    
    soundToggle:setName("soundToggle")
    soundToggle:setPosition(93.6, 93.2)
    soundToggle:addTo(self.transform)
    self:setProperty("soundToggle",soundToggle)

	PlayerPrefs.SetInt("curStage",1)
	QSoundMgr:PlayBacksound("GrayRun/Sound/homebg",true)
	PlayerPrefs.SetInt("isWin",0)

	-- 先读取数据
	local soundOff = PlayerPrefs.GetInt("isSoundOff",0)
	if soundOff == 0 then 
		soundToggle:setIsOn(true)
	else 
		soundToggle:setIsOn(false)
	end

	-- 帮助
	local helpShadow = CCSprite.create("GrayRun/Sprite/home/home_help_sd")
	helpShadow:setName("helpShadow")
	helpShadow:setPosition(544,90.6)
	helpShadow:addTo(self.transform)
	self:setProperty("helpShadow",helpShadow)

	-- 按钮
	local helpBtn = CCButton.create("GrayRun/Sprite/home/home_help1","GrayRun/Sprite/home/home_help2",function ()
		QFramework.QUtil.Log("help click")

		local btnClip = soundMgr:LoadAudioClip("GrayRun/Sound/btn")
		QSoundMgr:Play(btnClip,Vector2.zero)

		-- 原来cocos2d的逻辑
		-- if (isPause) return;
 		--    isPause = true;
 		--    sound->setEnabled(false);
 		--    SimpleAudioEngine::sharedEngine()->playEffect("btn.wav");
 		--    this->getChildByTag(kHelpLayer)->setPositionY(0);
	end)

	helpBtn:setName("helpBtn")
	helpBtn:setPosition(545.5, 95.8)
	helpBtn:addTo(self.transform)
	self:setProperty("helpBtn", helpBtn)

	-- 瓶子
	local bottle1 = CCSprite.create("GrayRun/Sprite/home/home_jq1")
	bottle1:setName("bottle1")
	bottle1:setSwallowTouches(false)
	bottle1:setPosition(320,96)
	bottle1:addTo(self.transform)
	self:setProperty("bottle1", bottle1)

	-- 要在这里设置英雄
	self:SetupHeros()

	local bottle2  = CCNode.createWithPrefab("GrayRun/Prefab/bottle2")
	bottle2:setName("bottle2")
	bottle2:setPosition(321,435.2)
	bottle2:addTo(self.transform)
	self:setProperty("bottle2", bottle2)

	local playBtn = CCButton.create("GrayRun/Sprite/home/home_bt_pl1","GrayRun/Sprite/home/home_bt_pl2",function ()

		local btnClip = soundMgr:LoadAudioClip("GrayRun/Sound/btn")
		QSoundMgr:Play(btnClip,Vector2.zero)

		bottle2.gameObject:GetComponent("BoxCollider2D").enabled = false

		self:Exit()
	end)

	playBtn:setName("playBtn")
	playBtn:setPosition(319,181)
	playBtn:addTo(self.transform)
	self:setProperty("PlayBtn",playBtn)

		-- 木条
	local wood = CCSprite.create("GrayRun/Sprite/home/home_wood")
	wood:setName("wood")
	wood:setPosition(319.6, 44)
	wood:addTo(self.transform)
	self:setProperty("wood",wood)
end

function HomeLayer:SetupHeros()

	for i=1,3 do
		local blueHero = BlueHero.new()
		blueHero:setName("blueHero")
		blueHero:setPosition(320 ,480)
		blueHero:addTo(self.transform)
		self.mHeros[#self.mHeros + 1] = blueHero

		local greenHero = GreenHero.new()
		greenHero:setName("blueHero")
		greenHero:setPosition(320 ,480)
		greenHero:addTo(self.transform)
		self.mHeros[#self.mHeros + 1] = greenHero

		local redHero = RedHero.new()
		redHero:setName("blueHero")
		redHero:setPosition(320 ,480)
		redHero:addTo(self.transform)
		self.mHeros[#self.mHeros + 1] = redHero

		local yellowHero = YellowHero.new()
		yellowHero:setName("blueHero")
		yellowHero:setPosition(320 ,480)
		yellowHero:addTo(self.transform)
		self.mHeros[#self.mHeros + 1] = yellowHero
	end

end

function HomeLayer:Exit()
	local function DelayTime()
		coroutine.wait(2.0)
		for i,hero in ipairs(self.mHeros) do
			hero:Destroy()
		end
		self:Destroy()
	end
	coroutine.start(DelayTime)
end

return HomeLayer