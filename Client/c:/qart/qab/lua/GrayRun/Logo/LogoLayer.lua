--
-- Author: 凉鞋,
-- TODO:这里之前是加载资源 这个可以先干掉不管
-- Date: 2016-09-11 00:24:07
--
local LogoLayer = class("LogoLayer")


music = {
    "storybg.mp3",
    "homebg.mp3",
    "bg14.mp3",
    "bg5.mp3",
    "c01.wav",
    "c02.wav",
    "die1.wav",
    "die2.wav",
    "die3.wav",
    "die4.wav",
    "gameover.wav",
    "c03.wav",
    "maskoff.wav",
    "maskon.wav",
    "ufo.wav",
    "01.wav",
    "02.wav",
    "03.wav",
    "04.wav",
    "07.wav",
    "candy.wav",
    "bounce.wav",
    "knifeappear.wav",
    "knifedisappear.wav",
    "mapslide.wav",
    "knife.wav",
    "blowon.wav",
    "blowoff.wav",
    "btn.wav",
    "eleappear.wav",
    "eledie.wav",
    "eledisappear.wav",
    "die.wav",
    "fog.wav",
    "next.wav",
    "mapclick.wav",
    "homebegin.wav",
    "bomb.wav",
    "tick.wav",
    "win.wav",
    "a1in.wav",
    "a1out.wav"
}


function LogoLayer:ctor()
	QFramework.QUtil.Log("LogoLayer:new()")
    self.transform = QApp.GrayRun.transform:Find("LogoLayer")
    self.gameObject = self.transform.gameObject
    self.gameObject:SetActive(false)
end

function LogoLayer:Enter()
	QFramework.QUtil.Log("Enter Logo Layer")	

	self.transform:Find("Bg"):GetComponent("Image").color = Color.white

	local function DelayTime()
		self.transform:Find("Bg"):GetComponent("Image"):DOColor(Color.clear,2)
		coroutine.wait(2.0)
	-- print("Coroutine started")
	-- local i = 0
	-- for i = 0,10,1 do 
	-- 	print(fib(i))
	-- 	coroutine.wait(0.1)
	-- end
	-- print("current frameCount: "..Time.frameCount)
	-- coroutine.step()
	-- print("yiel frameCount: "..Time.frameCount)

	-- local www = UnityEngine.WWW("http://www.baidu.com")
	-- coroutine.www(www)
	-- local s = tolua.tolstring(www.bytes)
	-- print(s:sub(1,128))
	-- print('Coroutine ended')
		self:Exit()
	end
	coroutine.start(DelayTime)

	-- CCSize size = CCDirector::sharedDirector()->getWinSize();

 --    for (int i = 1; i < 10; i++) {
 --        CCTextureCache::sharedTextureCache()->addImage(CCString::createWithFormat("image%d.pvr.ccz",i)->getCString());
 --    }
    
 --    CCSprite *logo = CCSprite::create("launchlogo1.png");
 --    logo->setPosition(ccp(size.width / 2, size.height /2 ));
 --    this->addChild(logo);
 --    this->scheduleOnce(schedule_selector(LogoScene::next), 0.2);
end


function fib(n)
    local a, b = 0, 1
    while n > 0 do
        a, b = b, a + b
        n = n - 1
    end

    return a
end

function LogoLayer:Exit()
	-- 关闭当前Layer
	self.gameObject:SetActive(false)
	-- 进入故事场景
	QApp.GrayRun.mPlotLayer:Enter();
end

return LogoLayer