--
-- Author: Your Name
-- Date: 2016-10-29 02:02:42
--
require "framework.init"
local HomePanel = require "Klotski.HomePanel"

local Klotski = class("Klotski")
local gameObject = nil
local transform = nil
local self = Klotski

QApp = {}

require "klotski.LevelPanel"
require "klotski.manager.init"
require "klotski.data.init"

function Klotski.Start()
	QFramework.QUtil.Log("初始化")
	QApp.Canvas = transform:Find("KlotskiPage")
	QApp.QLuaBehaviour = GameObject.Find("LuaBehaviour"):GetComponent("QLuaBehaviour")
	HomePanel.new():Enter()
end

function Klotski.Update()
	-- print("update")
end

function Klotski.FixedUpdate()
	-- print("fixed update")
end

function Klotski.LatedUpdate()
	-- print("fixed lated update")
end

function Klotski.OnDestroy()
	-- print("on destroy")
end

function Main()
	QFramework.QUtil.Log("这里是Klotski的Main")
	local monoBehaviour = QFrameworkLua.QLuaApp.Instance;
	transform = monoBehaviour.transform
	gameObject = transform.gameObject
	Klotski.Start(transform)
	monoBehaviour.onUpdate = monoBehaviour.onUpdate + Klotski.Update
	monoBehaviour.onFixedUpdate = monoBehaviour.onFixedUpdate + Klotski.FixedUpdate
	monoBehaviour.onLatedUpdate = monoBehaviour.onLatedUpdate + Klotski.LatedUpdate
	monoBehaviour.onDestroy = monoBehaviour.onDestroy + Klotski.OnDestroy


end