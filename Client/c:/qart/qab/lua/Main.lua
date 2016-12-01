--主入口函数。从这里开始lua逻辑
-- 全局
QApp = {}

function Main()					
	QFramework.QUtil.Log("从这里开始游戏吗?")
	QFramework.QUtil.Log("LuaFramework太好用了")

	require ("Common/functions")
	require ("Common/define")
	require ("MapPage/MapCtrl")
	require("Common/LuaBehaviour")

	QApp.QLuaBehaviour = GameObject.Find("LuaBehaviour"):GetComponent("QLuaBehaviour")
	
	-- require("Klotski/KlotskiCtrl").EnterGame();
	-- 来自星星的你Unity版本 
	QApp.GrayRun =  require("GrayRun/GrayRunCtrl").new()
	QApp.GrayRun:EnterGame()
end

--场景切换通知
function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0
end