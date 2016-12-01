using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
using System;
using System.Text;
using System.IO;
using LuaInterface;
using System.Reflection;
using System.Diagnostics;


using BindType = ToLuaMenu.BindType;
using UnityEngine.UI;

using Object = UnityEngine.Object;
using Debug = UnityEngine.Debug;
using Debugger = LuaInterface.Debugger;
using System.Threading;


namespace ToLuaDevMenu {

	public class ToLuaDevMenu {

		[MenuItem("QFramework/ToLuaDev/1.Gen Completions Code")]
		public static void GenCompletionsCode()
		{
			if (EditorApplication.isCompiling)
			{
				EditorUtility.DisplayDialog("警告", "请等待编辑器完成编译再执行此功能", "确定");
				return;
			}

			beAutoGen = true;
			// 目前还用到Delegate
			//			GenLuaDelegates();
			AssetDatabase.Refresh();
			GenerateClassWraps();
			//			GenLuaBinder();
			beAutoGen = false;
		}


		[MenuItem("QFramework/ToLuaDev/3.SetupSublimeText3(请先打开Sublime再进行设置)")]
		public static void MoveToLuaDevToSublime3Package()
		{


			string srcDirPath = Application.dataPath + "/ToLuaDev";
			#if UNITY_EDITOR_OSX 
			// 以下的admin要改成自己的计算机名称
			// 1：Users 2:username
			string dstDirPath = "/Users/"+ Environment.UserName  + "/Library/Application Support/Sublime Text 3/Packages/ToLuaDev";
			#else
			// 以下的admin要改成自己的计算机名称
			// 1：Users 2:username
			string dstDirPath = "C:\\Users\\"+ Environment.UserName  + "\\AppData\\Roaming\\Sublime Text 3\\Packages\\ToLuaDev";
			#endif

			CopyDir (srcDirPath, dstDirPath);
		}

		[MenuItem("QFramework/ToLuaDev/3.SetupSublimeText2(请先打开Sublime再进行设置)")]
		public static void CopyToLuaDevToSublime2Package()
		{
			string srcDirPath = Application.dataPath + "/ToLuaDev";
			#if UNITY_EDITOR_OSX 
			// 以下的admin要改成自己的计算机名称
			// 1：Users 2:username
			string dstDirPath = "/Users/"+ Environment.UserName + "/Library/Application Support/Sublime Text 2/Packages/ToLuaDev";
			#else
			// 以下的admin要改成自己的计算机名称
			// 1：Users 2:username
			string dstDirPath = "C:\\Users\\"+ Environment.UserName  + "\\AppData\\Roaming\\Sublime Text 2\\Packages\\ToLuaDev";
			#endif

			CopyDir (srcDirPath, dstDirPath);
		}


		/// 复制文件夹
		public static void CopyDir(string srcDirPath,string dstDirPath)
		{
			if (Directory.Exists (dstDirPath)) {
				Directory.Delete (dstDirPath, true);
			}

			Directory.CreateDirectory (dstDirPath);


			// 创建所有的对应目录
			foreach (string dirPath in Directory.GetDirectories(srcDirPath, "*", SearchOption.AllDirectories)) {
				Directory.CreateDirectory (dirPath.Replace (srcDirPath, dstDirPath));

				//			递归复制
				//			CopyDir(dirPath,dirPath.Replace (srcDirPath, dstDirPath));
			}

			// 复制原文件夹下所有内容到目标文件夹，直接覆盖
			foreach (string newPath in Directory.GetFiles(srcDirPath, "*.*", SearchOption.AllDirectories)) {

				File.Copy (newPath, newPath.Replace (srcDirPath, dstDirPath), true);
			}
		}


		//不需要导出或者无法导出的类型
		public static List<Type> dropType = new List<Type>
		{
			typeof(ValueType),                                  //不需要
			#if !UNITY_5
			typeof(Motion),                                     //很多平台只是空类
			#endif
			typeof(UnityEngine.YieldInstruction),               //无需导出的类      
			typeof(UnityEngine.WaitForEndOfFrame),              //内部支持
			typeof(UnityEngine.WaitForFixedUpdate),
			typeof(UnityEngine.WaitForSeconds),        
			typeof(UnityEngine.Mathf),                          //lua层支持                
			typeof(Plane),                                      
			typeof(LayerMask),                                  
			typeof(Vector3),
			typeof(Vector4),
			typeof(Vector2),
			typeof(Quaternion),
			typeof(Ray),
			typeof(Bounds),
			typeof(Color),                                    
			typeof(Touch),
			typeof(RaycastHit),                                 
			typeof(TouchPhase),     
			//typeof(LuaInterface.LuaOutMetatable),               //手写支持
			typeof(LuaInterface.NullObject),             
			typeof(System.Array),                        
			typeof(System.Reflection.MemberInfo),    
			typeof(System.Reflection.BindingFlags),
			typeof(LuaClient),
			typeof(LuaInterface.LuaFunction),
			typeof(LuaInterface.LuaTable),
			typeof(LuaInterface.LuaThread),
			typeof(LuaInterface.LuaByteBuffer),                 //只是类型标识符
			typeof(DelegateFactory),                            //无需导出，导出类支持lua函数转换为委托。如UIEventListener.OnClick(luafunc)
		};

		//可以导出的内部支持类型
		public static List<Type> baseType = new List<Type>
		{
			typeof(System.Object),
			typeof(System.Delegate),
			typeof(System.String),
			typeof(System.Enum),
			typeof(System.Type),
			typeof(System.Collections.IEnumerator),
			typeof(UnityEngine.Object),
			typeof(LuaInterface.EventObject),
			typeof(LuaInterface.LuaMethod),
			typeof(LuaInterface.LuaProperty),
			typeof(LuaInterface.LuaField),
			typeof(LuaInterface.LuaConstructor),        
		};

		private static bool beAutoGen = false;
		private static bool beCheck = true;        
		static List<BindType> allTypes = new List<BindType>();

		static ToLuaDevMenu()
		{
			string dir = CustomSettings.saveDir;
			string[] files = Directory.GetFiles(dir, "*.cs", SearchOption.TopDirectoryOnly);

			if (files.Length < 3 && beCheck)
			{
				if (EditorUtility.DisplayDialog("自动生成", "点击确定自动生成常用类型注册文件， 也可通过菜单逐步完成此功能", "确定", "取消"))
				{
					beAutoGen = true;
					GenLuaDelegates();
					AssetDatabase.Refresh();
					GenerateClassWraps();
					beAutoGen = false;                
				}

				beCheck = false;
			}
		}

		static string RemoveNameSpace(string name, string space)
		{
			if (space != null)
			{
				name = name.Remove(0, space.Length + 1);
			}

			return name;
		}



		static void AutoAddBaseType(BindType bt, bool beDropBaseType)
		{
			Type t = bt.baseType;

			if (t == null)
			{
				return;
			}

			if (t.IsInterface)
			{
				Debugger.LogWarning("{0} has a base type {1} is Interface, use SetBaseType to jump it", bt.name, t.FullName);
				bt.baseType = t.BaseType;
			}
			else if (dropType.IndexOf(t) >= 0)
			{
				Debugger.LogWarning("{0} has a base type {1} is a drop type", bt.name, t.FullName);
				bt.baseType = t.BaseType;
			}
			else if (!beDropBaseType || baseType.IndexOf(t) < 0)
			{
				int index = allTypes.FindIndex((iter) => { return iter.type == t; });

				if (index < 0)
				{
					#if JUMP_NODEFINED_ABSTRACT
					if (t.IsAbstract && !t.IsSealed)
					{
					Debugger.LogWarning("not defined bindtype for {0}, it is abstract class, jump it, child class is {1}", t.FullName, bt.name);
					bt.baseType = t.BaseType;
					}
					else
					{
					Debugger.LogWarning("not defined bindtype for {0}, autogen it, child class is {1}", t.FullName, bt.name);
					bt = new BindType(t);
					allTypes.Add(bt);
					}
					#else
					Debugger.LogWarning("not defined bindtype for {0}, autogen it, child class is {1}", t.FullName, bt.name);                        
					bt = new BindType(t);
					allTypes.Add(bt);
					#endif
				}
				else
				{
					return;
				}
			}
			else
			{
				return;
			}

			AutoAddBaseType(bt, beDropBaseType);
		}

		static BindType[] GenBindTypes(BindType[] list, bool beDropBaseType = true)
		{
			allTypes = new List<BindType>(list);

			for (int i = 0; i < list.Length; i++)
			{
				for (int j = i + 1; j < list.Length; j++)
				{
					if (list[i].type == list[j].type)
						throw new NotSupportedException("Repeat BindType:" + list[i].type);
				}

				if (dropType.IndexOf(list[i].type) >= 0)
				{
					Debug.LogWarning(list[i].type.FullName + " in dropType table, not need to export");
					allTypes.Remove(list[i]);
					continue;
				}
				else if (beDropBaseType && baseType.IndexOf(list[i].type) >= 0)
				{
					Debug.LogWarning(list[i].type.FullName + " is Base Type, not need to export");
					allTypes.Remove(list[i]);
					continue;
				}
				else if (list[i].type.IsEnum)
				{
					continue;
				}

				AutoAddBaseType(list[i], beDropBaseType);
			}

			return allTypes.ToArray();
		}


		static void GenerateClassWraps()
		{
			if (!beAutoGen && EditorApplication.isCompiling)
			{
				EditorUtility.DisplayDialog("警告", "请等待编辑器完成编译再执行此功能", "确定");
				return;
			}

			// 测试
			if (!Directory.Exists(Application.dataPath + "/ToLuaDev/quickxlib/system_api/")) {
				Directory.CreateDirectory (Application.dataPath + "/ToLuaDev/quickxlib/system_api/");
			}

			allTypes.Clear();
			BindType[] typeList = CustomSettings.customTypeList;

			BindType[] list = GenBindTypes(typeList);
			ToLuaDevExport.allTypes.AddRange(baseType);

			for (int i = 0; i < list.Length; i++)
			{            
				ToLuaDevExport.allTypes.Add(list[i].type);
			}

			for (int i = 0; i < list.Length; i++)
			{
				ToLuaDevExport.Clear();
				ToLuaDevExport.className = list[i].name;
				ToLuaDevExport.type = list[i].type;
				ToLuaDevExport.isStaticClass = list[i].IsStatic;  
				ToLuaDevExport.baseType = list[i].baseType;
				ToLuaDevExport.wrapClassName = list[i].wrapName;
				ToLuaDevExport.libClassName = list[i].libName;
				ToLuaDevExport.extendList = list[i].extendList;
				ToLuaDevExport.Generate(Application.dataPath + "/ToLuaDev/quickxlib/system_api/");
			}

			Debug.Log("Generate lua binding files over");
			ToLuaDevExport.allTypes.Clear();
			allTypes.Clear();        
			AssetDatabase.Refresh();
		}

		static HashSet<Type> GetCustomTypeDelegates()
		{
			BindType[] list = CustomSettings.customTypeList;
			HashSet<Type> set = new HashSet<Type>();
			BindingFlags binding = BindingFlags.Public | BindingFlags.Static | BindingFlags.IgnoreCase | BindingFlags.Instance;

			for (int i = 0; i < list.Length; i++)
			{
				Type type = list[i].type;
				FieldInfo[] fields = type.GetFields(BindingFlags.GetField | BindingFlags.SetField | binding);
				PropertyInfo[] props = type.GetProperties(BindingFlags.GetProperty | BindingFlags.SetProperty | binding);
				MethodInfo[] methods = null;

				if (type.IsInterface)
				{
					methods = type.GetMethods();
				}
				else
				{
					methods = type.GetMethods(BindingFlags.Instance | binding);
				}

				for (int j = 0; j < fields.Length; j++)
				{
					Type t = fields[j].FieldType;

					if (ToLuaDevExport.IsDelegateType(t))
					{
						set.Add(t);
					}
				}

				for (int j = 0; j < props.Length; j++)
				{
					Type t = props[j].PropertyType;

					if (ToLuaDevExport.IsDelegateType(t))
					{
						set.Add(t);
					}
				}

				for (int j = 0; j < methods.Length; j++)
				{
					MethodInfo m = methods[j];

					if (m.IsGenericMethod)
					{
						continue;
					}

					ParameterInfo[] pifs = m.GetParameters();

					for (int k = 0; k < pifs.Length; k++)
					{
						Type t = pifs[k].ParameterType;
						if (t.IsByRef) t = t.GetElementType();

						if (ToLuaDevExport.IsDelegateType(t))
						{
							set.Add(t);
						}
					}
				}

			}

			return set;
		}

		static void GenLuaDelegates()
		{
			if (!beAutoGen && EditorApplication.isCompiling)
			{
				EditorUtility.DisplayDialog("警告", "请等待编辑器完成编译再执行此功能", "确定");
				return;
			}

			ToLuaDevExport.Clear();
			List<DelegateType> list = new List<DelegateType>();
			list.AddRange(CustomSettings.customDelegateList);
			HashSet<Type> set = GetCustomTypeDelegates();        

			foreach (Type t in set)
			{
				if (null == list.Find((p) => { return p.type == t; }))
				{
					list.Add(new DelegateType(t));
				}
			}

			ToLuaDevExport.GenDelegates(list.ToArray());
			set.Clear();
			ToLuaDevExport.Clear();
			AssetDatabase.Refresh();
			Debug.Log("Create lua delegate over");
		}    

		static ToLuaTree<string> InitTree()
		{                        
			ToLuaTree<string> tree = new ToLuaTree<string>();
			ToLuaNode<string> root = tree.GetRoot();        
			BindType[] list = GenBindTypes(CustomSettings.customTypeList);

			for (int i = 0; i < list.Length; i++)
			{
				string space = list[i].nameSpace;
				AddSpaceNameToTree(tree, root, space);
			}

			DelegateType[] dts = CustomSettings.customDelegateList;
			string str = null;      

			for (int i = 0; i < dts.Length; i++)
			{            
				string space = ToLuaDevExport.GetNameSpace(dts[i].type, out str);
				AddSpaceNameToTree(tree, root, space);            
			}

			return tree;
		}

		static void AddSpaceNameToTree(ToLuaTree<string> tree, ToLuaNode<string> parent, string space)
		{
			if (space == null || space == string.Empty)
			{
				return;
			}

			string[] ns = space.Split(new char[] { '.' });

			for (int j = 0; j < ns.Length; j++)
			{
				List<ToLuaNode<string>> nodes = tree.Find((_t) => { return _t == ns[j]; }, j);

				if (nodes.Count == 0)
				{
					ToLuaNode<string> node = new ToLuaNode<string>();
					node.value = ns[j];
					parent.childs.Add(node);
					node.parent = parent;
					node.layer = j;
					parent = node;
				}
				else
				{
					bool flag = false;
					int index = 0;

					for (int i = 0; i < nodes.Count; i++)
					{
						int count = j;
						int size = j;
						ToLuaNode<string> nodecopy = nodes[i];

						while (nodecopy.parent != null)
						{
							nodecopy = nodecopy.parent;
							if (nodecopy.value != null && nodecopy.value == ns[--count])
							{
								size--;
							}
						}

						if (size == 0)
						{
							index = i;
							flag = true;
							break;
						}
					}

					if (!flag)
					{
						ToLuaNode<string> nnode = new ToLuaNode<string>();
						nnode.value = ns[j];
						nnode.layer = j;
						nnode.parent = parent;
						parent.childs.Add(nnode);
						parent = nnode;
					}
					else
					{
						parent = nodes[index];
					}
				}
			}
		}

		static string GetSpaceNameFromTree(ToLuaNode<string> node)
		{
			string name = node.value;

			while (node.parent != null && node.parent.value != null)
			{
				node = node.parent;
				name = node.value + "." + name;
			}

			return name;
		}

		static string RemoveTemplateSign(string str)
		{
			str = str.Replace('<', '_');

			int index = str.IndexOf('>');

			while (index > 0)
			{
				str = str.Remove(index, 1);
				index = str.IndexOf('>');
			}

			return str;
		}

		static void GenRegisterInfo(string nameSpace, StringBuilder sb, List<DelegateType> delegateList, List<DelegateType> wrappedDelegatesCache)
		{
			for (int i = 0; i < allTypes.Count; i++)
			{
				Type dt = CustomSettings.dynamicList.Find((p) => { return allTypes[i].type == p; });

				if (dt == null && allTypes[i].nameSpace == nameSpace)
				{
					string str = "\t\t" + allTypes[i].wrapName + "Wrap.Register(L);\r\n";
					sb.Append(str);
					allTypes.RemoveAt(i--);
				}
			}

			string funcName = null;

			for (int i = 0; i < delegateList.Count; i++)
			{
				DelegateType dt = delegateList[i];
				Type type = dt.type;
				string typeSpace = ToLuaDevExport.GetNameSpace(type, out funcName);

				if (typeSpace == nameSpace)
				{
					funcName = ToLuaDevExport.ConvertToLibSign(funcName);
					string abr = dt.abr;
					abr = abr == null ? funcName : abr;
					sb.AppendFormat("\t\tL.RegFunction(\"{0}\", {1});\r\n", abr, dt.name);
					wrappedDelegatesCache.Add(dt);
				}
			}
		}


		static string GetOS()
		{
			return LuaConst.osDir;
		}

		static string CreateStreamDir(string dir)
		{
			dir = Application.streamingAssetsPath + "/" + dir;

			if (!File.Exists(dir))
			{
				Directory.CreateDirectory(dir);
			}

			return dir;
		}

		static void BuildLuaBundle(string subDir, string sourceDir)
		{
			string[] files = Directory.GetFiles(sourceDir + subDir, "*.bytes");
			string bundleName = subDir == null ? "lua.unity3d" : "lua" + subDir.Replace('/', '_') + ".unity3d";
			bundleName = bundleName.ToLower();

			#if UNITY_5        
			for (int i = 0; i < files.Length; i++)
			{
				AssetImporter importer = AssetImporter.GetAtPath(files[i]);            

				if (importer)
				{
					importer.assetBundleName = bundleName;
					importer.assetBundleVariant = null;                
				}
			}
			#else        
			List<Object> list = new List<Object>();

			for (int i = 0; i < files.Length; i++)
			{
			Object obj = AssetDatabase.LoadMainAssetAtPath(files[i]);
			list.Add(obj);
			}

			BuildAssetBundleOptions options = BuildAssetBundleOptions.CollectDependencies | BuildAssetBundleOptions.CompleteAssets | BuildAssetBundleOptions.DeterministicAssetBundle;

			if (files.Length > 0)
			{
			string output = string.Format("{0}/{1}/" + bundleName, Application.streamingAssetsPath, GetOS());
			File.Delete(output);
			BuildPipeline.BuildAssetBundle(null, list.ToArray(), output, options, EditorUserBuildSettings.activeBuildTarget);            
			}
			#endif        
		}

		static void ClearAllLuaFiles()
		{
			string osPath = Application.streamingAssetsPath + "/" + GetOS();

			if (Directory.Exists(osPath))
			{
				string[] files = Directory.GetFiles(osPath, "Lua*.unity3d");

				for (int i = 0; i < files.Length; i++)
				{
					File.Delete(files[i]);
				}
			}

			string path = osPath + "/Lua";

			if (Directory.Exists(path))
			{
				Directory.Delete(path, true);
			}

			path = Application.streamingAssetsPath + "/Lua";

			if (Directory.Exists(path))
			{
				Directory.Delete(path, true);
			}

			path = Application.dataPath + "/temp";

			if (Directory.Exists(path))
			{
				Directory.Delete(path, true);
			}

			path = Application.dataPath + "/Resources/Lua";

			if (Directory.Exists(path))
			{
				Directory.Delete(path, true);
			}

			path = Application.persistentDataPath + "/" + GetOS() + "/Lua";

			if (Directory.Exists(path))
			{
				Directory.Delete(path, true);
			}
		}

		[MenuItem("Lua/Gen LuaWrap + Binder", false, 4)]
		static void GenLuaWrapBinder()
		{
			if (EditorApplication.isCompiling)
			{
				EditorUtility.DisplayDialog("警告", "请等待编辑器完成编译再执行此功能", "确定");
				return;
			}

			beAutoGen = true;        
			AssetDatabase.Refresh();
			GenerateClassWraps();
			beAutoGen = false;   
		}

		[MenuItem("Lua/Generate All", false, 5)]
		static void GenLuaAll()
		{
			if (EditorApplication.isCompiling)
			{
				EditorUtility.DisplayDialog("警告", "请等待编辑器完成编译再执行此功能", "确定");
				return;
			}

			beAutoGen = true;
			GenLuaDelegates();
			AssetDatabase.Refresh();
			GenerateClassWraps();
			beAutoGen = false;
		}

		static void GetAllDirs(string dir, List<string> list)
		{
			string[] dirs = Directory.GetDirectories(dir);
			list.AddRange(dirs);

			for (int i = 0; i < dirs.Length; i++)
			{
				GetAllDirs(dirs[i], list);
			}
		}

		static void CopyDirectory(string source, string dest, string searchPattern = "*.lua", SearchOption option = SearchOption.AllDirectories)
		{                
			string[] files = Directory.GetFiles(source, searchPattern, option);

			for (int i = 0; i < files.Length; i++)
			{
				string str = files[i].Remove(0, source.Length);
				string path = dest + "/" + str;
				string dir = Path.GetDirectoryName(path);
				Directory.CreateDirectory(dir);
				File.Copy(files[i], path, true);
			}        
		}
	}
}
