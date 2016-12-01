--
-- Author: 
-- Date: 2016-10-05 01:56:39
--
local SuperHero = class("SuperHero",require("cc.CCNode"))

function SuperHero:Left()
	self.bgBody:AddForce(Vector2.New(-5000,0))
	QFramework.QUtil.Log("Hero:Left")
end

function SuperHero:Right()
	self.bgBody:AddForce(Vector2.New(5000,0))
	QFramework.QUtil.Log("Hero:Right")
end

return SuperHero