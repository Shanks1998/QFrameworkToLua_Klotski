--
-- Author: Your Name
-- Date: 2016-10-03 03:33:45
--
local CCLayer = class("CCLayer")

function CCLayer:ctor()
	QFramework.QUtil.Log("CCLayer ctor")

	self.node = QFramework.QLayer.New()
	self:init()

	self.node.onEnterCallback = function ()
		self:onEnter()
	end

	self.node.onExitCallback = function ()
		self:onExit()
	end

end


return CCLayer

