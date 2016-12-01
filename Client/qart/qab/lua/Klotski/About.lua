local About = class("About")

function About:ctor(transform)
	self.transform = transform
	self.gameObject = self.transform.gameObject

	self.mFadeBlack = self.transform:Find("FadeBlack")
	self.mBtnBack = self.transform:Find("BtnBack").gameObject

	QUIEventListener.Get(self.mBtnBack).onClick = function (go)
		QFramework.QUtil.Log("BtnBackClick")
		self:Hide()
	end
end

function About:Show()
	self.gameObject:SetActive(true)
end

function About:Hide()
	self.gameObject:SetActive(false)
end

function About:OnDestroy()
	
end

return About