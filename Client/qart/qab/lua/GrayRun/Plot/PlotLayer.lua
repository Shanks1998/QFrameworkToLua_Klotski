--
-- Author: 凉鞋
-- Date: 2016-09-11 00:41:20
-- 剧情界面

local PlotLayer = class("PlotLayer")

function PlotLayer:ctor()
	self.transform = QApp.GrayRun.transform:Find("PlotLayer")
	self.gameObject = self.transform.gameObject
	self.mNextBtnGo = self.transform:Find("NextBtn").gameObject
	self.gameObject:SetActive(false)
end

function PlotLayer:Enter()
	QFramework.QUtil.Log("进入剧情界面")
	self.gameObject:SetActive(true)
	-- 会自动加载
	soundMgr:PlayBacksound("GrayRun/Sound/storybg",true)

	-- 先初始化背景颜色,可能用的材质是同一个材质所以颜色都会跟着改变
	self.transform:GetComponent("Image").material.color = Color.white

	self.mCoPlot = nil
	-- QApp.LuaBehaviour:AddClick(self.mNextBtnGo,function ()
	-- 	self:Exit()
	-- end)
	local listener = QUIEventListener.Get(self.mNextBtnGo)
	listener.onClick = function ( go )
		self:Exit()
	end


	local one = self.transform:Find("1")
	-- Transform.DOMove(UnityEngine.Transform:target,UnityEngine.Vector3:endValue,System.Single:duration,System.Boolean:snapping)

	local two = self.transform:Find("2")
	local three = self.transform:Find("3")
	local four = self.transform:Find("4")
	local five = self.transform:Find("5")
	local six = self.transform:Find("6")
	local seven = self.transform:Find("7")

	-- local nextBtn = 
	--开始剧情
	local function Plot()
		-- 剧情1  one two three four
		one.localPosition = Vector2.New(-258.6 - 640 / 2,755 - 960  / 2)
		-- 等待0.1秒
		coroutine.wait(0.1)
		-- Transform.DOLocalMove(UnityEngine.Transform:target,UnityEngine.Vector3:endValue,System.Single:duration,System.Boolean:snapping)
		one:DOLocalMove(Vector2.New(317.4 - 640 / 2,755 - 960  / 2),1,true)

		-- 等待一秒
		coroutine.wait(1)

		local audioClip1 = soundMgr:LoadAudioClip("GrayRun/Sound/01")
		coroutine.wait(0.5)
		soundMgr:Play(audioClip1,Camera.main.transform.position)

		
		-- two
		two.localPosition = Vector2.New(900.2 - 640 / 2,532.1 - 960 / 2,0)
		coroutine.wait(1.4)
		-- 开始移动
		two:DOLocalMove(Vector2.New(331.6 - 640 / 2,532.1 - 960 / 2),1,true)

		local audioClip2 = soundMgr:LoadAudioClip("GrayRun/Sound/02")
		coroutine.wait(1)
		soundMgr:Play(audioClip2,Camera.main.transform.position)

		-- three
		three.localPosition = Vector2.New(-262.6 - 640 / 2,297.4 - 960 / 2)
		coroutine.wait(1)
		three:DOLocalMove(Vector2.New(310.5 - 640 / 2,297.4 - 960 / 2),0.5,true)

		local audioClip3 = soundMgr:LoadAudioClip("GrayRun/Sound/03")
		coroutine.wait(0.5)
		soundMgr:Play(audioClip3,Camera.main.transform.position)

		-- four
        four.localPosition = Vector2.New(316.2 - 640 / 2,-138.0 - 960 / 2)
        coroutine.wait(1)
        four:DOLocalMove(Vector2.New(319.2 - 640 / 2,145.7 - 960 / 2),0.5,true)

        local audioClip4 = soundMgr:LoadAudioClip("GrayRun/Sound/04")
        coroutine.wait(0.5)
        soundMgr:Play(audioClip4,Camera.main.transform.position)

        coroutine.wait(audioClip4.length)

        one.gameObject:SetActive(false)
        two.gameObject:SetActive(false)
        three.gameObject:SetActive(false)
        four.gameObject:SetActive(false)
        GameObject.Destroy(one.gameObject)
        GameObject.Destroy(two.gameObject)
        GameObject.Destroy(three.gameObject)
        GameObject.Destroy(four.gameObject)
        soundMgr:UnloadAudioClip("GrayRun/Sound/01")
        soundMgr:UnloadAudioClip("GrayRun/Sound/02")
        soundMgr:UnloadAudioClip("GrayRun/Sound/03")
        soundMgr:UnloadAudioClip("GrayRun/Sound/04")
        Resources.UnloadUnusedAssets()


        -- 剧情2 five six
        five.localPosition = Vector2.New(323.2 - 640 / 2,1088 - 960 / 2)
        coroutine.wait(1.5)
        five:DOLocalMove(Vector2.New(323.2 - 640 / 2,813.0 - 960 / 2),0.5,true)
        coroutine.wait(0.6)

        local audioClip5 = soundMgr:LoadAudioClip("GrayRun/Sound/05")
        coroutine.wait(0.5)
        soundMgr:Play(audioClip5,Camera.main.transform.position)

        six.localPosition = Vector2.New(323.3 - 640 / 2 ,1122.5 - 960 / 2)
        coroutine.wait(1.1)
        six:DOLocalMove(Vector2.New(323.2 - 640 / 2,604.1 - 960 / 2),0.8,true)

        local audioClip6 = soundMgr:LoadAudioClip("GrayRun/Sound/06")
       	coroutine.wait(0.8) 
       	soundMgr:Play(audioClip6,Camera.main.transform.position)

       	seven.localPosition = Vector2.New(322.7 - 640 / 2,1213.0 - 960 / 2)
       	coroutine.wait(0.6)
       	seven:DOLocalMove(Vector2.New(322.7 - 640 / 2,264.0 - 960 / 2),0.8,true)
       	coroutine.wait(0.8)

       	local audioClip7 = soundMgr:LoadAudioClip("GrayRun/Sound/07")
       	soundMgr:Play(audioClip7,Camera.main.transform.position)
       	coroutine.wait(0.6)
       	five.gameObject:SetActive(false)
       	six.gameObject:SetActive(false)
       	seven.gameObject:SetActive(false)
       	GameObject.Destroy(five.gameObject)
       	GameObject.Destroy(six.gameObject)
       	GameObject.Destroy(seven.gameObject)
       	soundMgr:UnloadAudioClip("GrayRun/Sound/05")
       	soundMgr:UnloadAudioClip("GrayRun/Sound/06")
       	soundMgr:UnloadAudioClip("GrayRun/Sound/07")

       	-- self:Exit()
	end
	-- 协程
	self.mCoPlot = coroutine.start(Plot)


end

function PlotLayer:Exit()
	QFramework.QUtil.Log("退出剧情界面")

	soundMgr:PlayBacksound("GrayRun/Sound/storybg",false)
	soundMgr:UnloadAudioClip("GrayRun/Sound/storybg")
	coroutine.stop(self.mCoPlot)
	self.gameObject:SetActive(false)
	QApp.GrayRun.mHomeLayer:Enter()
end


return PlotLayer
