
CtrlNames = {
	Prompt = "PromptCtrl",
	Message = "MessageCtrl"
}

PanelNames = {
	"PromptPanel",	
	"MessagePanel",
}

--协议类型--
ProtocalType = {
	BINARY = 0,
	PB_LUA = 1,
	PBC = 2,
	SPROTO = 3,
}
--当前使用的协议类型--
TestProtoType = ProtocalType.BINARY;

QUtil = QFramework.QUtil;
QAppConst = QFramework.QAppConst;
QLuaHelper = QFramework.QLuaHelper;
QFrameworkApp = QFramework.QApp.Instance;

resMgr = QLuaHelper.GetResManager();
soundMgr = QLuaHelper.GetSoundManager();

QLuaBehavihour = QFramework.QLuaBehavihour
QSoundMgr = QLuaHelper.GetSoundManager();
QUIEventListener = QFramework.UI.UGUIEventListener
QResMgr = QLuaHelper.GetResManager()

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;
Resources = UnityEngine.Resources;
Image = UnityEngine.UI.Image;
QFrameworkApp = QFramework.QApp;
Input = UnityEngine.Input;
Screen = UnityEngine.Screen
Camera = UnityEngine.Camera
PlayerPrefs = UnityEngine.PlayerPrefs
--UI
ScrollRect = UnityEngine.UI.ScrollRect
Toggle = UnityEngine.UI.Toggle
ToggleEvent = UnityEngine.UI.Toggle.ToggleEvent
RectTransform = UnityEngine.RectTransform
--2D
Sprite = UnityEngine.Sprite


Rect = UnityEngine.Rect

CCDirector = Cocos2d.CCDirector
CCScene = Cocos2d.CCScene

function ccp(x,y)
	QFramework.QUtil.Log(Screen.width..":"..Screen.height)
	return Vector2.New(x - 320,y - 480)
end


TexturePool = {}
