--
-- Author: Your Name
-- Date: 2016-10-04 16:22:54
--
local CCToggle = class("CCToggle",require("cc.CCNode"))
local CCTexturePool = require("cc.CCTexturePool")
function CCToggle.create(onImageFilePath,OffImageFilePath,onValueChangedCallback)
	return CCToggle.new(onImageFilePath,OffImageFilePath,onValueChangedCallback)
end

function CCToggle:ctor(onImageFilePath,OffImageFilePath,onValueChangedCallback)
	self.super:ctor()
	
	local prefab = Resources.Load("Prefab/CCToggle")
	self.gameObject = GameObject.Instantiate(prefab)
	self.transform = self.gameObject.transform
	self.toggleComponent = self.gameObject:GetComponent("Toggle")

	self.position = Vector2.zero
	self.scale = Vector2.one

	self.on = nil
	self.off = nil

	self.onTexture2D = CCTexturePool.GetTexture(onImageFilePath)
	self.offTexture2D = CCTexturePool.GetTexture(OffImageFilePath)
	self.onImage = self.transform:Find("Off"):Find("On"):GetComponent("Image")
	self.offImage = self.transform:Find("Off"):GetComponent("Image")
	self.onValueChangedCallback = onValueChangedCallback

	QApp.QLuaBehaviour:AddToggleValueChanged(self.gameObject,function ( value )
		if self.onValueChangedCallback then 
			self.onValueChangedCallback(value)
		end 
	end)
end

function CCToggle:setIsOn(value)
	self.toggleComponent.isOn = value
end
function CCToggle:setName(name)
	self.name = name
end

function CCToggle:setPosition(vec2)
	-- self.transform.localPosition = vec2
	self.position = vec2
end

function CCToggle:setPosition( x,y )
	self.position = ccp(x,y)
	-- self.transform.localPosition = self.position
end

function CCToggle:addTo(transform )
	self.super.addTo(self,transform)

	self.onImage.sprite = Sprite.Create(self.onTexture2D,Rect.New(0,0,self.onTexture2D.width,self.onTexture2D.height),Vector2.New(0.5,0.5))
	self.onImage:SetNativeSize()

	self.offImage.sprite = Sprite.Create(self.offTexture2D,Rect.New(0,0,self.offTexture2D.width,self.offTexture2D.height),Vector2.New(0.5,0.5))
	self.offImage:SetNativeSize()
end

return CCToggle