--
-- Author: Your Name
-- Date: 2016-10-06 18:54:01
--
local InputCtrl = class("InputCtrl")

local LEFT = 0
local RIGHT = 1
local IDLE = 2

function InputCtrl:ctor(transform)

	self.leftCallfunc = nil
	self.rightCallfunc = nil

	self.transform = transform
	self.gameObject = self.transform.gameObject

	self.state = IDLE

	QUIEventListener.Get(self.gameObject).onPointerDown = function (event)
		if event.position.x <= 320 then 
			self.state = LEFT
		else 
			self.state = RIGHT
		end
	end

	QFramework.QApp.Instance.onUpdate = QFramework.QApp.Instance.onUpdate + function ( )
		
		if self.state == LEFT then 
			if self.leftCallfunc then 
				self.leftCallfunc()
			end 
		elseif self.state == RIGHT then 
			if self.rightCallfunc then 
				self.rightCallfunc()
			end 
		elseif self.state == IDLE then 

		end
	end

	QUIEventListener.Get(self.gameObject).onPointerUp = function (event)
		self.state = IDLE
	end
end

function InputCtrl:RegisterInputCallfuncs(leftCallfunc,rightCallfunc)
	self.leftCallfunc = leftCallfunc
	self.rightCallfunc = rightCallfunc
end

return InputCtrl