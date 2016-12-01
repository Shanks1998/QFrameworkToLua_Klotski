using UnityEngine;
using System;
using System.Collections.Generic;
using LuaInterface;
using LuaFramework;
using BindType = ToLuaMenu.BindType;
using UnityEngine.UI;
using System.Reflection;
using System.Xml;
using UnityEngine.EventSystems;
using QFramework;
using QFramework.UI;
using QFramework.AB;
using Cocos2d;

public static class CustomSettings
{
	public static string FrameworkPath = QPath.FrameworkPath;
	public static string saveDir = Application.dataPath + "/ToLua/Source/Generate/";
	public static string luaDir = Application.dataPath + "/QArt/QAB" + "/Lua/";
	public static string toluaBaseType = Application.dataPath + "/ToLua/BaseType/";
	public static string toluaLuaDir = Application.dataPath + "/ToLua/Lua";

    //导出时强制做为静态类的类型(注意customTypeList 还要添加这个类型才能导出)
    //unity 有些类作为sealed class, 其实完全等价于静态类
    public static List<Type> staticClassTypes = new List<Type>
    {        
        typeof(UnityEngine.Application),
        typeof(UnityEngine.Time),
        typeof(UnityEngine.Screen),
        typeof(UnityEngine.SleepTimeout),
        typeof(UnityEngine.Input),
        typeof(UnityEngine.Resources),
        typeof(UnityEngine.Physics),
        typeof(UnityEngine.RenderSettings),
        typeof(UnityEngine.QualitySettings),
        typeof(UnityEngine.GL),
    };

    //附加导出委托类型(在导出委托时, customTypeList 中牵扯的委托类型都会导出， 无需写在这里)
    public static DelegateType[] customDelegateList = 
    {        
        _DT(typeof(Action)),        
        _DT(typeof(UnityEngine.Events.UnityAction)),
		_DT(typeof(DG.Tweening.TweenCallback)),
    };

    //在这里添加你要导出注册到lua的类型列表
    public static BindType[] customTypeList = 
    {                
        //------------------------为例子导出--------------------------------
        //_GT(typeof(TestEventListener)),
        //_GT(typeof(TestAccount)),
        //_GT(typeof(Dictionary<int, TestAccount>)).SetLibName("AccountMap"),
        //_GT(typeof(KeyValuePair<int, TestAccount>)),    
        //_GT(typeof(TestExport)),
        //_GT(typeof(TestExport.Space)),
        //-------------------------------------------------------------------        
        _GT(typeof(Debugger)).SetNameSpace(null),
		_GT(typeof(EdgeInfo)),
		_GT(typeof(StageInfo)),
		_GT(typeof(XMLConfigLoader)),
//#if USING_DOTWEENING
        _GT(typeof(DG.Tweening.DOTween)),
        _GT(typeof(DG.Tweening.Tween)).SetBaseType(typeof(System.Object)).AddExtendType(typeof(DG.Tweening.TweenExtensions)),
        _GT(typeof(DG.Tweening.Sequence)).AddExtendType(typeof(DG.Tweening.TweenSettingsExtensions)),
        _GT(typeof(DG.Tweening.Tweener)).AddExtendType(typeof(DG.Tweening.TweenSettingsExtensions)),
        _GT(typeof(DG.Tweening.LoopType)),
        _GT(typeof(DG.Tweening.PathMode)),
        _GT(typeof(DG.Tweening.PathType)),
        _GT(typeof(DG.Tweening.RotateMode)),
        _GT(typeof(Component)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Transform)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Light)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Material)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Rigidbody)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(Camera)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        _GT(typeof(AudioSource)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
		_GT(typeof(Image)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        //_GT(typeof(LineRenderer)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        //_GT(typeof(TrailRenderer)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),    
//#else
                                         
//        _GT(typeof(Component)),
//        _GT(typeof(Transform)),
//        _GT(typeof(Material)),
//        _GT(typeof(Light)),
//        _GT(typeof(Rigidbody)),
//        _GT(typeof(Camera)),
//        _GT(typeof(AudioSource)),
        //_GT(typeof(LineRenderer))
        //_GT(typeof(TrailRenderer))
//#endif   
		#region Cocos2d Support
		_GT(typeof(NSAppDelegate)),
		_GT(typeof(CCDirector)),
		_GT(typeof(CCScene)),
		_GT(typeof(CCLayer)),
		_GT(typeof(UIWindow)),
		_GT(typeof(CCGLView)),
		_GT(typeof(UIViewController)),
		_GT(typeof(CCLayerBase)), 
		_GT(typeof(CCNode)), 
		_GT(typeof(CCLabelTTF)),
		_GT(typeof(CCMenuItem)),
		_GT(typeof(CCMenuItemLabel<CCLabelTTF>)),
		_GT(typeof(CCMenuItemFont)),
		_GT(typeof(CCMenu)),
		_GT(typeof(QLayer)),
		_GT(typeof(CCNodeRGBA)),
		_GT(typeof(SimpleAudioEngine)),
		#endregion


		_GT(typeof(TextAsset)),
		_GT(typeof(SpriteState)),
		_GT(typeof(Toggle)),
		_GT(typeof(Toggle.ToggleEvent)),
		_GT(typeof(ScrollRect)),
		_GT(typeof(PlayerPrefs)),
		_GT(typeof(Resources)),
        _GT(typeof(Behaviour)),
        _GT(typeof(MonoBehaviour)),        
        _GT(typeof(GameObject)),
        _GT(typeof(TrackedReference)),
		_GT(typeof(UnityEngine.SceneManagement.SceneManager)),
        _GT(typeof(Application)),
        _GT(typeof(Physics)),
        _GT(typeof(Collider)),
        _GT(typeof(Time)),        
        _GT(typeof(Texture)),
        _GT(typeof(Texture2D)),
		_GT(typeof(Sprite)),
        _GT(typeof(Shader)),
        _GT(typeof(Renderer)),
        _GT(typeof(WWW)),
        _GT(typeof(Screen)),
        _GT(typeof(CameraClearFlags)),
        _GT(typeof(AudioClip)),
        _GT(typeof(AssetBundle)),
        _GT(typeof(ParticleSystem)),
        _GT(typeof(AsyncOperation)).SetBaseType(typeof(System.Object)),
        _GT(typeof(LightType)),
        _GT(typeof(SleepTimeout)),
        _GT(typeof(Animator)),
        _GT(typeof(Input)),
        _GT(typeof(KeyCode)),
        _GT(typeof(SkinnedMeshRenderer)),
        _GT(typeof(Space)),        
        _GT(typeof(MeshRenderer)),            
        _GT(typeof(ParticleEmitter)),
        _GT(typeof(ParticleRenderer)),
        _GT(typeof(ParticleAnimator)), 
                         
        _GT(typeof(BoxCollider)),
        _GT(typeof(MeshCollider)),
        _GT(typeof(SphereCollider)),        
        _GT(typeof(CharacterController)),
        _GT(typeof(CapsuleCollider)),
        
        _GT(typeof(Animation)),        
        _GT(typeof(AnimationClip)).SetBaseType(typeof(UnityEngine.Object)),        
        _GT(typeof(AnimationState)),
        _GT(typeof(AnimationBlendMode)),
        _GT(typeof(QueueMode)),  
        _GT(typeof(PlayMode)),
        _GT(typeof(WrapMode)),

        _GT(typeof(QualitySettings)),
        _GT(typeof(RenderSettings)),                                                   
        _GT(typeof(BlendWeights)),           
        _GT(typeof(RenderTexture)),       
          
        //for LuaFramework
        _GT(typeof(RectTransform)),
        _GT(typeof(Text)),

        _GT(typeof(QUtil)),
        _GT(typeof(QAppConst)),
        _GT(typeof(QLuaHelper)),
		_GT(typeof(QFrameworkLua.QLuaBehaviour)),

		_GT(typeof(GameManager)),
		_GT(typeof(QFrameworkLua.QLuaMgr)),
		_GT(typeof(QFrameworkLua.QLuaApp)),
		_GT(typeof(QSoundMgr)),
        _GT(typeof(QTimerMgr)),
        _GT(typeof(QThreadMgr)),
		_GT(typeof(QResMgr)),

		_GT(typeof(UGUIEventListener)),
		_GT(typeof(QVoidDelegate)),
		_GT(typeof(PointerEventData)),
		_GT(typeof(Rect)),


		_GT(typeof(BoxCollider2D)),
		_GT(typeof(Rigidbody2D)),
    };

    public static List<Type> dynamicList = new List<Type>()
    {        
        /*typeof(MeshRenderer),
        typeof(ParticleEmitter),
        typeof(ParticleRenderer),
        typeof(ParticleAnimator),

        typeof(BoxCollider),
        typeof(MeshCollider),
        typeof(SphereCollider),
        typeof(CharacterController),
        typeof(CapsuleCollider),

        typeof(Animation),
        typeof(AnimationClip),
        typeof(AnimationState),        

        typeof(BlendWeights),
        typeof(RenderTexture),
        typeof(Rigidbody),*/
    };

    //重载函数，相同参数个数，相同位置out参数匹配出问题时, 需要强制匹配解决
    //使用方法参见例子14
    public static List<Type> outList = new List<Type>()
    {
        
    };

    static BindType _GT(Type t)
    {
        return new BindType(t);
    }

    static DelegateType _DT(Type t)
    {
        return new DelegateType(t);
    }    
}
