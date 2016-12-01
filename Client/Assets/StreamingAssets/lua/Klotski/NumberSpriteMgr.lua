NumberSpriteMgr = class("NumberSpriteMgr")

NumberSpriteMgr.Sprites = {}

local loaded = false
function NumberSpriteMgr.LoadSprite()
	
	if not loaded then 
		for i=0,9 do
			local texture2D = Resources.Load("Sprite/"..i)
			local sprite = Sprite.Create(texture2D,Rect.New(0,0,texture2D.width,texture2D.height),Vector2.New(0.5,0.5))
			NumberSpriteMgr.Sprites[i] = sprite
		end
	end 
	loaded = true
end


function NumberSpriteMgr.GetSprite(index)
	NumberSpriteMgr.LoadSprite();
	return NumberSpriteMgr.Sprites[index]
end




