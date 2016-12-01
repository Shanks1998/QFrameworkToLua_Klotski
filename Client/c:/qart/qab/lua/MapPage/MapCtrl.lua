--
-- Author: Your Name
-- Date: 2016-08-30 13:35:32
--

MapCtrl = {}

local this = MapCtrl

function MapCtrl.Init()
	
	this.mLuaBehaviour = GameObject.Find("LuaBehaviour"):GetComponent("LuaBehaviour")

	this.mainCanvasTrans = GameObject.Find("Canvas").transform
	this.mPage = this.mainCanvasTrans:Find("MapPage")
	
	this.mFirstGameBtn = this.mPage:Find("FirstGame").gameObject
	this.mSecondGameBtn = this.mPage:Find("SecondGame").gameObject
	this.mThirdGameBtn = this.mPage:Find("ThirdGame").gameObject
	this.mFourthGameBtn = this.mPage:Find("FourthGame").gameObject
	this.mFifthGameBtn = this.mPage:Find("FifthGame").gameObject
	this.mSixGameBtn = this.mPage:Find("SixGame").gameObject

	-- 测试能不能点击按钮
	this.mLuaBehaviour:AddClick(this.mFirstGameBtn,function (go )
		LuaFramework.Util.Log(go.name.."123")
	end)

	this.mLuaBehaviour:AddClick(this.mSecondGameBtn,MapCtrl.OnClick)
	this.mLuaBehaviour:AddClick(this.mThirdGameBtn,MapCtrl.OnClick)
	this.mLuaBehaviour:AddClick(this.mFourthGameBtn,MapCtrl.OnClick)
	this.mLuaBehaviour:AddClick(this.mFifthGameBtn,MapCtrl.OnClick)
	this.mLuaBehaviour:AddClick(this.mSixGameBtn,MapCtrl.OnDestroy)
end


function MapCtrl.OnClick(go)
	-- body
	LuaFramework.Util.Log(go.name)

	if go.name == "SecondGame" then
		MapCtrl.OnDestroy()
		require("Klotski/Main").EnterGame()
		this.Hide()
	end
end

function MapCtrl.Hide()
	this.mPage.gameObject:SetActive(false)
end

function MapCtrl.Show()
	this.mPage.gameObject:SetActive(true)
end

function MapCtrl.OnDestroy(go)
	this.mLuaBehaviour:RemoveClick(this.mFirstGameBtn)
	GameObject.Destroy(this.mFirstGameBtn)
end

return MapCtrl
