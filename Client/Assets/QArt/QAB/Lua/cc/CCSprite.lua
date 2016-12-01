--
-- Author: Your Name
-- Date: 2016-10-04 16:01:22
--
local CCSprite = class("CCSprite",require("cc.CCNode"))

function CCSprite.create(filepath)
	return CCSprite.new(filepath)
end

function CCSprite:ctor(filepath)
	self.super:ctor()

	self.texture2D = nil
	self.name = ""
	self.position = Vector2.zero
	self.scale = Vector2.one
	self.rotation = 0
	self.needSwallowTouches = false
	-- 先加载
	if not TexturePool[filepath] then
		TexturePool[filepath] = Resources.Load(filepath)
	end

	self.texture2D = TexturePool[filepath]
end

function CCSprite:setSwallowTouches(needSwallow)
	self.needSwallowTouches = needSwallow
end

function CCSprite:addTo(transform)
	self.gameObject = GameObject.New(self.name)
	self.transform = self.gameObject.transform

	self.super.addTo(self,transform)
	-- self.transform.anchoredPosition = self.position
	self.image = self.gameObject:AddComponent(tolua.typeof(Image))
	self.image.sprite = Sprite.Create(self.texture2D,Rect.New(0,0,self.texture2D.width,self.texture2D.height),Vector2.New(0.5,0.5))
	self.image:SetNativeSize()

	-- 是否
	self.image.raycastTarget = self.needSwallowTouches
end

return CCSprite