
--游戏lua组件模版 Editor中通过Luacomponent挂载
local StartSceneUIHandler = class("StartSceneUIHandler")

function StartSceneUIHandler:ctor()
	-- StartSceneUIHandler.super.ctor(self)

	-- self._btnStart = nil
	-- self._btnSet = nil
	-- self._btnYuyin = nil
	-- self._btnQRCode = nil
	-- self._setBox = nil
end


function StartSceneUIHandler:Awake()
	-- self.gameObject = go
	-- self.transform = go.transform

	-- self._btnStart = self.transform:Find("BG/BtnStart").gameObject
	-- self._btnSet = self.transform:Find("BG/BtnSet").gameObject
	-- self._btnYuyin = self.transform:Find("BG/BtnYuyin").gameObject
	-- self._btnQRCode = self.transform:Find("BG/BtnQRCode").gameObject
	-- self._setBox = self.transform:Find("SetBox").gameObject


	-- LuaMain.AddClick(self._btnStart,self.OnStart)
	-- LuaMain.AddClick(self._btnSet,self.OnSet)
	-- LuaMain.AddClick(self._btnYuyin,self.OnYuyin)

	print("Awake")
end



function StartSceneUIHandler:OnStart()
	print("OnStart")
	-- UnityEngine.SceneManagement.SceneManager.LoadScene (GetSceneName(GameDefine.BookName,GameDefine.LOADING_SCENE));
end

function StartSceneUIHandler:OnSet() 
	print("OnSet")
end

function StartSceneUIHandler:OnYuyin() 
	print("OnYuyin")
end




function StartSceneUIHandler:OnQRCode()
	print("OnQRCode")
end







return StartSceneUIHandler.new()
