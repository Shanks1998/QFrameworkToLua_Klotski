using UnityEngine;
using System.Collections;
using Cocos2d;

namespace Cocos2d{
	public class BBFlashDisplayFactory : DisplayFactory
	{
		public Graphic createGraphic(DefineGraphic define){
			return new BBFlashGraphic (define);
		}
		public Movie createMovie(DefineMovie define){
			return new BBFlashMovieImp (define);
		}
	}
}

