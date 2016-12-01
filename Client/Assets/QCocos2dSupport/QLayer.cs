using UnityEngine;
using System.Collections;
using Cocos2d;
namespace QFramework {
	public class QLayer : CCLayer {

		public QVoidDelegate.WithVoid onInitCallback = delegate{};
		public QVoidDelegate.WithVoid onEnterCallback = delegate{};
		public QVoidDelegate.WithVoid onEnterTransitionDidFinishCallback = delegate{};
		public QVoidDelegate.WithVoid onExitCallback = delegate{};
		public QVoidDelegate.WithVoid onExitTransitionDidStartCallback = delegate{};
		public QVoidDelegate.WithVoid onCleanupCallback = delegate {};

		protected override void init ()
		{
			base.init ();
		}

		public override void onEnter ()
		{
			base.onEnter ();
		}


		public override void onEnterTransitionDidFinish ()
		{
			base.onEnterTransitionDidFinish ();
		}

		public override void onExit ()
		{
			base.onExit ();
		}

		public override void onExitTransitionDidStart ()
		{
			base.onExitTransitionDidStart ();
		}

		public override void cleanup ()
		{
			base.cleanup ();

		}
	}

}