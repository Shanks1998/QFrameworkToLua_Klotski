require("Klotski/GameData")

local AccountPanel = class("AccountPanel")

local parentNode
local herosPanelClass

local levelIndex

function AccountPanel:ctor(parentNode, herosPanelClass, index)

	self.parentNode = parentNode

	self.herosPanelClass = herosPanelClass

	self.index = index

	self.parentNode.gameObject:SetActive(false)

	local luaBehaviour = GameObject.Find("LuaBehaviour"):GetComponent("QLuaBehaviour")

	local nextlevelBtn = self.parentNode.transform:Find("NextLevelBtn").gameObject

	luaBehaviour:RemoveClick(nextlevelBtn);

	luaBehaviour:AddClick(nextlevelBtn, function (go)
		local page = GameObject.Find("Canvas/KlotskiPage").transform

		local nextIndex = self.index + 1

		if (nextIndex > #GameData.LevelsData) then
			nextIndex = #GameData.LevelsData
		end

		self.herosPanelClass:ResetHerosInfo(nextIndex)
	end)


	local levelsPanel = self.parentNode.transform:Find("LevelsPanelBtn").gameObject

	luaBehaviour:RemoveClick(levelsPanel);

	luaBehaviour:AddClick(levelsPanel, function (go)
		local page = GameObject.Find("Canvas/KlotskiPage").transform

		QFramework.QApp.Instance.onUpdate = QFramework.QApp.Instance.onUpdate - self.herosPanelClass.updateDelegate

		GameObject.Destroy(self.herosPanelClass.PlayPanel)

		self.herosPanelClass = nil

		LevelPanel:New(page)
	end)
end

function AccountPanel:Hide()
	self.parentNode.gameObject:SetActive(false)
end

function AccountPanel:Show()
	self.parentNode.gameObject:SetActive(true)
end

return AccountPanel