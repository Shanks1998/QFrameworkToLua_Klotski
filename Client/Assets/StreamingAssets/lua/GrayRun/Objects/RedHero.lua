--
-- Author: Your Name
-- Date: 2016-10-06 20:28:59
--
local RedHero = class("RedHero", require("GrayRun/Objects/SuperHero"))

function RedHero:ctor()
	self.super:ctor("GrayRun/Prefab/RedHero")

	QFramework.QUtil.Log("ctor")
	self.bgBody = self.transform:GetComponent("Rigidbody2D")
	self.eyeBody = self.transform:GetComponentInChildren(tolua.typeof(UnityEngine.Rigidbody2D))
end

return RedHero