using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;
using LuaFramework;
using QFramework.PRIVATE;

namespace QFramework {
	public class GameManager : QMgrBehaviour {
        private List<string> downloadFiles = new List<string>();

		protected override void SetupMgrId ()
		{
			mMgrId = 0;
		}

		protected override void SetupMgr ()
		{
			
		}

		public static GameManager Instance {
			get {
				return QMonoSingletonComponent<GameManager>.Instance;
			}
		}

        /// <summary>
        /// 初始化
        /// </summary>
		public IEnumerator Start() {
            DontDestroyOnLoad(gameObject); 
            CheckExtractResource();
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Application.targetFrameRate = QAppConst.GameFrameRate;
			yield return null;
        }
			
		public IEnumerator Launch(){
			yield return null;
		}

        /// <summary>
        /// 释放资源
        /// </summary>
        public void CheckExtractResource() {
            bool isExists = Directory.Exists(QUtil.DataPath) &&
              Directory.Exists(QUtil.DataPath + "lua/") && File.Exists(QUtil.DataPath + "files.txt");
            if (isExists || QAppConst.DebugMode) {
				OnResourceInited ();
				return;   //文件已经解压过了，自己可添加检查文件列表逻辑
            }
            StartCoroutine(OnExtractResource());    //启动释放协成 
        }

        IEnumerator OnExtractResource() {
            string dataPath = QUtil.DataPath;  //数据目录
            string resPath = QUtil.AppContentPath(); //游戏包资源目录

            if (Directory.Exists(dataPath)) Directory.Delete(dataPath, true);
            Directory.CreateDirectory(dataPath);

            string infile = resPath + "files.txt";
            string outfile = dataPath + "files.txt";
            if (File.Exists(outfile)) File.Delete(outfile);

            string message = "正在解包文件:>files.txt";
            Debug.Log(infile);
            Debug.Log(outfile);
            if (Application.platform == RuntimePlatform.Android) {
                WWW www = new WWW(infile);
                yield return www;

                if (www.isDone) {
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return 0;
            } else File.Copy(infile, outfile, true);
            yield return new WaitForEndOfFrame();

            //释放所有文件到数据目录
            string[] files = File.ReadAllLines(outfile);
            foreach (var file in files) {
                string[] fs = file.Split('|');
                infile = resPath + fs[0];  //
                outfile = dataPath + fs[0];

                message = "正在解包文件:>" + fs[0];
                Debug.Log("正在解包文件:>" + infile);

                string dir = Path.GetDirectoryName(outfile);
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

                if (Application.platform == RuntimePlatform.Android) {
                    WWW www = new WWW(infile);
                    yield return www;

                    if (www.isDone) {
                        File.WriteAllBytes(outfile, www.bytes);
                    }
                    yield return 0;
                } else {
                    if (File.Exists(outfile)) {
                        File.Delete(outfile);
                    }
                    File.Copy(infile, outfile, true);
                }
            }
            message = "解包完成!!!";
			Debug.Log (message);
            yield return new WaitForSeconds(0.1f);

            message = string.Empty;
            //释放完成，开始启动更新资源
			OnResourceInited();
		}
			

        void OnUpdateFailed(string file) {
            string message = "更新失败!>" + file;
        }

        /// <summary>
        /// 是否下载完成
        /// </summary>
        bool IsDownOK(string file) {
            return downloadFiles.Contains(file);
        }

        /// <summary>
        /// 线程下载
        /// </summary>
        void BeginDownload(string url, string file) {     //线程下载
            object[] param = new object[2] { url, file };

            ThreadEvent ev = new ThreadEvent();
			ev.Key = QFrameworkMsg.UPDATE_DOWNLOAD;
            ev.evParams.AddRange(param);
        }

        /// <summary>
        /// 线程完成
        /// </summary>
        /// <param name="data"></param>
        void OnThreadCompleted(NotiData data) {
            switch (data.evName) {
			case QFrameworkMsg.UPDATE_EXTRACT:  //解压一个完成
                //
                break;
			case QFrameworkMsg.UPDATE_DOWNLOAD: //下载一个完成
                downloadFiles.Add(data.evParam.ToString());
                break;
            }
        }

        /// <summary>
        /// 资源初始化结束
        /// </summary>
        public void OnResourceInited() {
#if ASYNC_MODE
            ResManager.Initialize(AppConst.AssetDir, delegate() {
                Debug.Log("Initialize OK!!!");
                this.OnInitialize();
            });
#else
			QResMgr.Instance.Initialize();
            this.OnInitialize();
#endif
        }

        void OnInitialize() {
			QFrameworkLua.QLuaMgr.Instance.InitStart ();
        }

        /// <summary>
        /// 当从池子里面获取时
        /// </summary>
        /// <param name="obj"></param>
        void OnPoolGetElement(TestObjectClass obj) {
            Debug.Log("OnPoolGetElement--->>>" + obj);
        }

        /// <summary>
        /// 当放回池子里面时
        /// </summary>
        /// <param name="obj"></param>
        void OnPoolPushElement(TestObjectClass obj) {
            Debug.Log("OnPoolPushElement--->>>" + obj);
        }

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy() {
			QFrameworkLua.QLuaMgr.Instance.Close ();
            Debug.Log("~GameManager was destroyed");
        }
    }
}