using UnityEngine;
using System.Collections;
using Cocos2d;
using Cocos2d;
using System.Collections.Generic;

namespace Cocos2d{
	public class BBFlashFactory
	{
		static Dictionary<string, BBFlash> _caches = new Dictionary<string, BBFlash>();
		public static BBFlash LoadFlash(string path, bool cached=true){
			BBFlash flash;
			if(!_caches.TryGetValue(path, out flash)){
				flash = new BBFlashImp (path);
				if(cached)
					_caches[path] = flash;
			}
			return flash;
		}
		public static void PurgeCachedData(){
			_caches.Clear ();
		}
		public static void RemoveCacheData(string path){
			_caches.Remove (path);
		}
	}
}
