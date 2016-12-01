--
-- Author: Your Name
-- Date: 2016-10-04 16:47:45
--
local CCNode = class("CCNode")

function CCNode.createWithPrefab(prefabPath)
	return CCNode.new(prefabPath)
end

function CCNode:ctor(prefabPath)
	self.position = Vector2.zero
	self.scale = Vector3.one
	self.name = ""
	self.mProperties = {}

	if prefabPath then 
		QFramework.QUtil.Log(prefabPath)

		-- Dirty
		local splits = string.split(prefabPath, "/")
		local bundleName = string.lower(splits[1])
		for i = 2,#splits - 1 do 
			bundleName = bundleName.."/"..string.lower(splits[i])
		end
		QFramework.QUtil.Log(bundleName..string.lower(splits[#splits]))
		local prefab = QResMgr:LoadPrefab(bundleName,string.lower(splits[#splits]))

		self.gameObject = GameObject.Instantiate(prefab)
		self.transform = self.gameObject.transform
	end 
end

function CCNode:setProperty(name,node)
	QFramework.QUtil.Log(name)
	if self.mProperties[name] then 
		QFramework.QUtil.Log("propertie with name:"..name.." already exists in node:"..self.name)
	else 
		self.mProperties[name] = node
	end 
end

function CCNode:getProperty(name)

	if self.mProperties[name] then 
		QFramework.QUtil.Log("propertie with name:"..name.." is not exists in node:"..self.name)
		return nil
	else 
		return self.mProperties[name]
	end 
end

function CCNode:createEmptyGo()
	if not self.transform then 
		self.gameObject = GameObject.New()
		self.transform = self.gameObject.transform
	end 
end
function CCNode:setName(name)
	self.name = name 
end

function CCNode:setPosition(vec2)
	self.position = vec2
end

function CCNode:setPosition(x,y)
	self.position = ccp(x,y)
end

function CCNode:setScale(x,y)
	self.scale = Vector3.New(x,y,1)
end

function CCNode:setZOrder(z)
	self.position = Vector3.New(self.position.x,self.position.y,z)
end

function CCNode:show()
	self.gameObject:SetActive(true)
end

function CCNode:hide()
	self.gameObject:SetActive(false)
end

function CCNode:addTo( transform )

	self.transform:SetParent(transform)
	self.rectTransform = self.transform:GetComponent("RectTransform")

	if self.rectTransform then 
	 	self.rectTransform.anchoredPosition = self.position
	else 
		self.transform.localPosition = self.position
	end

	self.transform.localScale = self.scale
	self.gameObject.name = self.name
end

function CCNode:Destroy()
	if self.mProperties and #self.mProperties ~= 0 then 
		for name,obj in pairs(self.mProperties) do
			if obj == self then 
				QFramework.QUtil.Log("don't set property to self")
			else 
				obj:Destroy()
			end 
		end
	else 
		QFramework.QUtil.Log(self.name.."'s properties is null or empty")
	end 

	GameObject.Destroy(self.gameObject)
	self.name = nil
	self.position = nil
	self.scale = nil 
	self.transform = nil
	self.gameObject = nil 
	self.mProperties = nil
	self = nil
end

return CCNode