--
-- Author: Your Name
-- Date: 2016-10-29 00:41:48
--
local CCSprite = require("cc.CCSprite")


local EdgeSprite = class("EdgeSprite",require("cc.CCNode"))
function EdgeSprite:ctor()
	self.super:ctor()
	self:createEmptyGo()
end

function EdgeSprite:Init(stageInfo)
		-- TODO:做到这 刚解析完XML
	for i=1,stageInfo.edgeInfos.Count do
		local edgeInfo =  stageInfo:getEdgeInfo(i)
		print(edgeInfo.name)
		print("GrayRun/Sprite/game/edge/"..edgeInfo.name..".png")
		local edgeSprite = CCSprite.new("GrayRun/Sprite/game/edge/"..edgeInfo.name)
		edgeSprite:setPosition(edgeInfo.x, edgeInfo.y)
		edgeSprite:setName(edgeInfo.name)
		edgeSprite:addTo(self.transform)
		self:setProperty("edgeSprite"..i, edgeSprite)

		local boxCollider2D = edgeSprite.gameObject:AddComponent(tolua.typeof(UnityEngine.BoxCollider2D))
		boxCollider2D.size = edgeSprite.gameObject:GetComponent("RectTransform").sizeDelta;
	end
end

return EdgeSprite