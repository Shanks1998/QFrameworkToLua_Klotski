using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

namespace Cocos2d{
	public interface BBFlash
	{
		BBFlashMovie createMovie(string className);
		int frameRate{ get; }
		int flashVersion{ get;}
		bool hasMovie(string className);
		void Debug();
	}
}
