using UnityEngine;
using System.Collections;
using System.Xml;
using System.Collections.Generic;

public class XMLConfigLoader  {

	static string mStageXMLText= null;

	public static StageInfo LoadStage(int curStage) {

		if (mStageXMLText == null) {
			TextAsset textAsset = Resources.Load<TextAsset> ("GrayRun/Config/stages");

			mStageXMLText = textAsset.text;
		}

		XmlDocument xmlDoc = new XmlDocument ();
		xmlDoc.LoadXml (mStageXMLText);

		StageInfo retInfo = new StageInfo ();

		XmlNode stageNode = xmlDoc.SelectSingleNode ("stages").ChildNodes[curStage - 1];

		XmlNodeList edgeList = stageNode.ChildNodes;

		foreach (XmlNode edge in edgeList) {
			EdgeInfo edgeInfo = new EdgeInfo ();
			edgeInfo.name = edge.Attributes ["name"].Value.ToString ();
			edgeInfo.x = int.Parse(edge.Attributes ["x"].Value.ToString ());
			edgeInfo.y = int.Parse(edge.Attributes ["y"].Value.ToString ());
			edgeInfo.Description ();
			retInfo.edgeInfos.Add (edgeInfo);
		}

		return retInfo;
	}


}
