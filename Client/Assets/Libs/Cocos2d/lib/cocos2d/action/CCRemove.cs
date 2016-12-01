using UnityEngine;
using System.Collections;

namespace Cocos2d{
	public class CCRemove : CCActionInstant
	{
		public override void update (float dt)
		{
			(_target as CCNode).removeFromParent ();
		}

		protected override CCAction copyImpl ()
		{
			return new CCRemove ();
		}
	}
}
