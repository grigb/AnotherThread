﻿using UnityEngine;
using System.Collections;

namespace UTJ {

[RequireComponent(typeof(MeshFilter),typeof(MeshRenderer))]
public class ExplosionRenderer : MonoBehaviour {

	private MeshFilter mf_;
	private MeshRenderer mr_;

	void Start()
	{
		mf_ = GetComponent<MeshFilter>();
		mr_ = GetComponent<MeshRenderer>();
		mf_.sharedMesh = Explosion.Instance.getMesh();
		mr_.sharedMaterial = Explosion.Instance.getMaterial();
	}
}

} // namespace UTJ {
