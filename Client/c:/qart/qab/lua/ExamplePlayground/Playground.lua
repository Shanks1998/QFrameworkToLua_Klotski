--
-- Author: 凉鞋
-- Date: 2016-09-11 16:10:27
--

local Playground = class("Playground")

function TestClass:ctor()

	LuaFramework.Util.Log("Playground:new()")
	self:ResourcesExample()
	self:DoTweenExample()

end

-- Playground示例 待更新
function Playground:ResourcesExample()
	local prefab = Resources.Load("Text")
	GameObject.Instantiate(prefab)
end

-- DOTween示例 待更新
function Playground:DOTweenExample()
	GameObject.Find("some object").transform:DOMove(Vector3.zero,3,false)
	GameObject.Find("some object").transform:DOMove(Vector3.New(1,1,1),3,false)
	GameObject.Find("some Image"):GetComponent("Image").material:DOColor(Color.clear,1,false)
	GameObject.Find("some Image"):GetComponent("Image").material:DOColor(Color.white,1,false)
	GameObject.Find("some Image"):GetComponent("Image").material:DOColor(Color.New(0,0,0,0),1,false)
end



-- Update获取
function Playground:Update()
	QFrameworkApp.Instance.onUpdate = function ()
		LuaFramework.Util.Log("asd")
	end
end

-- 播放背景音乐
function Playground:PlayBackground()
	local soundMgr = LuaHelper.GetSoundManager()
	-- 会自动加载
	soundMgr:PlayBacksound("GrayRun/Sound/storybg",true)
end

-- 添加事件
function  Playground:EventListner()
	-- 添加注册
	local listener = QUIEventListener.Get(self.gameObject)

	listener.onClick = function ( go )
		self:Exit()
	end

	-- 销毁
	listener.onClick = nil


	listener.onPointerDown = function (event)
		QFramework.QUtil.Log(event.position.x..","..event.position.y)
	end

	listener.onDrag = function ( event )
		QFramework.QUtil.Log("drag:"..event.position.x..","..event.position.y)
	end

	-- body
	--[[

		QFramework.UI.UGUIEventListener.Get
		withgo   function(go)
		QFramework.UI.UGUIEventListener.onClick

		QFramework.UI.UGUIEventListener.onPointerDown
		QFramework.UI.UGUIEventListener.onPointerEnter
		QFramework.UI.UGUIEventListener.onPointerExit
		QFramework.UI.UGUIEventListener.onPointerUp
		QFramework.UI.UGUIEventListener.onSelect
		with event fuction(event)
		QFramework.UI.UGUIEventListener.onBeginDrag
		QFramework.UI.UGUIEventListener.onDrag
		QFramework.UI.UGUIEventListener.onEndDrag

	]]


	QApp.LuaBehaviour:AddToggleValueChanged(self.mSoundToggle.gameObject,function ( value )
		if value then
			QFramework.QUtil.Log("Sound On")
		else
			QFramework.QUtil.Log("Sound Off")
		end
	end)

end

return TestClass