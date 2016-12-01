--
-- Author: Your Name
-- Date: 2016-10-13 08:37:41
--
InfoManager = class("InfoManager")

InfoManager.Loaded = false
function InfoManager.Load()
	if not InfoManager.Loaded then 
		local stageInfosXMLStr = Resources.Load("GrayRun/Config/stages")

	end 
	InfoManager.Loaded = true
end


function InfoManager.GetStageInfo(stageIndex)
	InfoManager.Load()
	local stageInfo =  XMLConfigLoader.LoadStage(stageIndex)
	return stageInfo
end
return InfoManager