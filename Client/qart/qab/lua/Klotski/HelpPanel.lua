--
-- Author: Your Name
-- Date: 2016-10-05 23:46:18
--
local HelpPanel = class("HelpPanel")


function HelpPanel:ctor(transform)
	self.transform = transform
	self.gameObject = self.transform.gameObject

	self.btnBackGo = self.transform:Find("BtnBack").gameObject

	QUIEventListener.Get(self.btnBackGo).onClick = function (go)
		self:hide()
	end
end

function HelpPanel:hide()
	self.gameObject:SetActive(false)
end

function HelpPanel:show()
	self.gameObject:SetActive(true)
end

return HelpPanel
