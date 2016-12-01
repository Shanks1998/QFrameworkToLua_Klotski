--
-- Author: Your Name
-- Date: 2016-10-04 17:17:27
--
local CCButton = class("CCButton",require("cc.CCNode"))

local CCTexturePool = require("cc.CCTexturePool")

function CCButton.create(normalImageFilepath,pressedImageFilePath,onClickFunc)
	return CCButton.new(normalImageFilepath,pressedImageFilePath,onClickFunc)
end

function CCButton:ctor(normalImageFilepath,pressedImageFilePath,onClickFunc)
	self.scale = Vector2.one

	self.normalTexture2D = CCTexturePool.GetTexture(normalImageFilepath)
	self.pressedTexture2D = CCTexturePool.GetTexture(pressedImageFilePath)

	self.gameObject = GameObject.Instantiate(Resources.Load("Prefab/CCButton"))
	self.transform = self.gameObject.transform
	self.onClickFunc = onClickFunc
	self.buttonComponent = self.gameObject:GetComponent("Button")
end

function CCButton:addTo(transform)
	self.super.addTo(self,transform)
	self.transform.anchoredPosition = self.position
	self.normalImage = self.gameObject:GetComponent("Image")
	self.normalImage.sprite = Sprite.Create(self.normalTexture2D,Rect.New(0,0,self.normalTexture2D.width,self.normalTexture2D.height),Vector2.New(0.5,0.5))
	self.normalImage:SetNativeSize()

	local spriteState = UnityEngine.UI.SpriteState.New()
	spriteState.pressedSprite = Sprite.Create(self.pressedTexture2D,Rect.New(0,0,self.pressedTexture2D.width,self.pressedTexture2D.height),Vector2.New(0.5,0.5))
	self.buttonComponent.spriteState = spriteState

	QApp.QLuaBehaviour:AddClick(self.gameObject,function (go)
		if self.onClickFunc then 
			self.onClickFunc()
		end
	end)
end

return CCButton