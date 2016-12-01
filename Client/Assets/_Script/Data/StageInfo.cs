using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class StageInfo  {

	public List<EdgeInfo> edgeInfos = new List<EdgeInfo>();

	public EdgeInfo getEdgeInfo(int index) {
		return edgeInfos [index - 1];
	}

}
