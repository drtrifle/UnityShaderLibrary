using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Graph3D : MonoBehaviour {

	public Transform pointPrefab;
    [Range(10, 100)]
    public int resolution = 10;

    void Start() {
        float step = 2f / resolution; //Clamp within -1 to 1 domain
        Vector3 currPointPosition = Vector3.right;
        Vector3 currPointScale = Vector3.one * step;

        for ( int i = 0; i < resolution; i++) {
            Transform pointTransform = Instantiate(pointPrefab);
            currPointPosition.x = (i + 0.5f) * step - 1f;
            currPointPosition.y = currPointPosition.x * currPointPosition.x * currPointPosition.x;
            pointTransform.position = currPointPosition;
            pointTransform.localScale = currPointScale;
            pointTransform.SetParent(transform, false);
        }
    }
}
