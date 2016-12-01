-- 这里是所有的入口
require "Framework.Init"

function Main()					
	-- 这里是GrayRun
	QFramework.QUtil.Log("这里是Entry Lua")
	UnityEngine.SceneManagement.SceneManager.LoadScene("GrayRun")
end
