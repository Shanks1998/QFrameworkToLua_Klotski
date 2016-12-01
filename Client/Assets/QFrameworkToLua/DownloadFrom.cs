using UnityEngine;
using System.Collections;
using System.IO;

public class DownloadFrom : MonoBehaviour {

	// Use this for initialization
	IEnumerator Start () {
		WWW www = new WWW ("http://localhost:8123/resitems.xml");
		yield return www;

		File.WriteAllBytes (Application.dataPath + "/resitems.xml", www.bytes);

	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
