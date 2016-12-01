--
-- Author: 凉鞋
-- Date: 2016-10-06 20:29:06
--

local YellowHero = class("YellowHero", require("GrayRun/Objects/SuperHero"))

function YellowHero:ctor()
	self.super:ctor("GrayRun/Prefab/YellowHero")

	QFramework.QUtil.Log("ctor")
	self.bgBody = self.transform:GetComponent("Rigidbody2D")
	self.eyeBody = self.transform:GetComponentInChildren(tolua.typeof(UnityEngine.Rigidbody2D))
end

return YellowHero