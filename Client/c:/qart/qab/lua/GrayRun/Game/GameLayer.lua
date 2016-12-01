--
-- Author: Your Name
-- Date: 2016-10-07 19:33:27
--
local GameLayer = class("GameLayer", require("cc.CCNode"))

local CCSprite = require("cc.CCSprite")

function GameLayer:ctor()
	QFramework.QUtil.Log("GameLayer init")	

	self.transform = QApp.GrayRun.transform:Find("UIGameLayer")
	self.gameObject = self.transform.gameObject

end

function GameLayer:Enter()
	QFramework.QUtil.Log("GameLayer Enter")

	self:InitData()
	self:InitBox2D()
	self:SetupBg()
end

function GameLayer:InitData()
	self.mCompleteBlue = 0
	self.mCompleteRed = 0
	self.mCompleteGreen = 0
	self.mCompleteYellow = 0
	self.mIsBegin = false
	self.mIsOver = false
	self.mIsNext = false
	self.mCurStage = PlayerPrefs.GetInt("curStage",1)
	self.mBlueCount = PlayerPrefs.GetInt("blue"..self.mCurStage)
	self.mRedCount = PlayerPrefs.GetInt("red"..self.mCurStage)
	self.mGreenCount = PlayerPrefs.GetInt("green"..self.mCurStage)
	self.mYellowCount = PlayerPrefs.GetInt("yellow"..self.mCurStage)

	self.mHeros = {}
end

function GameLayer:InitBox2D()
	
end

function GameLayer:SetupBg()
	local name = nil 
	if self.mCurStage < 21 then 
		name = "GrayRun/Sprite/Bg/bg1"
	elseif self.mCurStage < 41 then 
		name = "GrayRun/Sprite/Bg/bg2"
	elseif self.mCurStage < 61 then 
		name = "GrayRun/Sprite/Bg/bg3"	
	elseif self.mCurStage < 81 then 
		name = "GrayRun/Sprite/Bg/bg4"
	else
		name = "GrayRun/Sprite/Bg/bg5"
	end

	local bg = CCSprite.create(name)
	bg:setName("bg")
	bg:setPosition(320,480)
	bg:addTo(self.transform)

	self.mIsWin = PlayerPrefs.GetInt("isWin",0)
	if self.mIsWin == 1 then 
		self:LevelUp()

		QSoundMgr:Play(soundMgr:LoadAudioClip("GrayRun/Sound/next"),Vector2.zero)
	end 
end

function GameLayer:LevelUp()
	QFramework.QUtil.Log("LevelUp")
    -- CCSprite *bg = CCSprite::createWithSpriteFrameName("game_levelupbg.png");
    -- bg->setPosition(ccpHeight(320, -200));
    -- bg->setZOrder(12    );
    -- this->addChild(bg);
    
    -- CCSprite *num100 = CCSprite::createWithSpriteFrameName(CCString::createWithFormat("nb_level_%d.png",presentStage / 100 % 10)->getCString());
    -- num100->setPosition(ccp(187.0, 41.0));
    -- bg->addChild(num100);
    
    -- CCSprite *num10 = CCSprite::createWithSpriteFrameName(CCString::createWithFormat("nb_level_%d.png",presentStage / 10 % 10)->getCString());
    -- num10->setPosition(ccp(214.0, 41.0));
    -- bg->addChild(num10);
    
    -- CCSprite *num1 = CCSprite::createWithSpriteFrameName(CCString::createWithFormat("nb_level_%d.png",presentStage % 10)->getCString());
    -- num1->setPosition(ccp(242.0, 41.0));
    -- bg->addChild(num1);
    
    -- bg->runAction(CCSequence::create(CCEaseOut::create(CCMoveTo::create(1, ccpHeight(320, 480)),2),CCDelayTime::create(1),CCMoveTo::create(0.5,ccpHeight(320, 1000)),NULL));
end



return GameLayer