--游戏lua组件模版 Editor中通过Luacomponent挂载
LuaBehaviour = class("LuaBehaviour")
function LuaBehaviour:ctor()
end


function LuaBehaviour:getClassName()
	return self.class.__cname
end
