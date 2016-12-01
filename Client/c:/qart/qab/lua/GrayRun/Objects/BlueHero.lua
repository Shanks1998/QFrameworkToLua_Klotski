--
-- Author: Your Name
-- Date: 2016-10-06 18:15:42
--
local BlueHero = class("BlueHero",require("GrayRun/Objects/SuperHero"))

function BlueHero:ctor()
	self.super:ctor("GrayRun/Prefab/BlueHero")

	QFramework.QUtil.Log("ctor")
	self.bgBody = self.transform:GetComponent("Rigidbody2D")
	self.eyeBody = self.transform:GetComponentInChildren(tolua.typeof(UnityEngine.Rigidbody2D))
end

return BlueHero