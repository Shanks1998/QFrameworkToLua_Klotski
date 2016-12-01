--
-- Author: 凉鞋
-- Date: 2016-10-04 17:24:54
--
CCTexturePool = class("CCTexturePool")

function CCTexturePool.GetTexture(filepath)
		-- 先加载
	if not TexturePool[filepath] then
		TexturePool[filepath] = Resources.Load(filepath)
	end

	return TexturePool[filepath]
end

return CCTexturePool