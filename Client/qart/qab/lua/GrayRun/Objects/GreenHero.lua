--
-- Author: Your Name
-- Date: 2016-10-06 20:29:19
--
local GreenHero = class("GreenHero", require("GrayRun/Objects/SuperHero"))

function GreenHero:ctor()
	self.super:ctor("GrayRun/Prefab/GreenHero")

	QFramework.QUtil.Log("ctor")
	self.bgBody = self.transform:GetComponent("Rigidbody2D")
	self.eyeBody = self.transform:GetComponentInChildren(tolua.typeof(UnityEngine.Rigidbody2D))
end

return GreenHero