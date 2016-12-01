local MapButton = class("MapButton", require("cc.CCNode"))
local CCButton = require("cc.CCButton")

local CCTexturePool = require("cc.CCTexturePool")

function MapButton.create(normalImageFilepath,pressedImageFilePath,onClickFunc)
	return MapButton.new(normalImageFilepath,pressedImageFilePath,onClickFunc)
end

function MapButton:ctor(normalImageFilepath,pressedImageFilePath,onClickFunc)
	self.scale = Vector2.one

	self.normalTexture2D = CCTexturePool.GetTexture(normalImageFilepath)
	self.pressedTexture2D = CCTexturePool.GetTexture(pressedImageFilePath)

	self.gameObject = GameObject.Instantiate(Resources.Load("Prefab/CCButton"))
	self.transform = self.gameObject.transform
	self.onClickFunc = onClickFunc
	self.buttonComponent = self.gameObject:GetComponent("Button")
end

function MapButton:setStage(n,name)
	self.mBgName = name 
	local stage = n
	self.mLevel = n 
	self.mBlueCount = PlayerPrefs.GetInt("blue"..n,0)
	self.mRedCount = PlayerPrefs.GetInt("red"..n,0)
	self.mYellowCount = PlayerPrefs.GetInt("yellow"..n,0)
	self.mGreenCount = PlayerPrefs.GetInt("green"..n,0)
	self.mNotFirst = PlayerPrefs.GetInt("isnotfirst"..n,0)

	if n == 1 then 
		self.mNotFirst = true
		self.mBlueCount = 2
		self.mRedCount = 2
		self.mGreenCount = 2
		self.mYellowCount = 2
	end 
end

function MapButton:addTo(transform)
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

return MapButton
