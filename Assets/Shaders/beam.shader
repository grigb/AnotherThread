﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/beam" {
    Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
    }
	SubShader {
   		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite Off
		Cull Off
		Blend SrcAlpha One 				// alpha additive
		
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
 			#pragma target 3.0
 			
 			#include "UnityCG.cginc"

            uniform sampler2D _MainTex;
			uniform fixed4 _Colors[3];

 			struct appdata_custom {
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				// fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
			};

 			struct v2f {
 				float4 pos:SV_POSITION;
 				fixed4 color:COLOR;
				float2 uv:TEXCOORD0;
 			};
 			
            v2f vert(appdata_custom v)
            {
				float size = v.texcoord2.x;
				float3 normal = v.normal;
				float3 tv = v.vertex.xyz;
				{
					float3 eye = ObjSpaceViewDir(float4(tv, 1));
					float3 side = normalize(cross(eye, normal));
					float3 vert = normalize(cross(eye, side));
					tv += (v.texcoord.x-0.5f)*side * size;
					tv -= (v.texcoord.y-0.5f)*vert * size;
				}
            	v2f o;
			    o.pos = UnityObjectToClipPos(float4(tv, 1));
				// o.color = v.color;
				int color_index = (int)v.texcoord2.y;
				o.color = _Colors[color_index];
				o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
            	return o;
			}

            fixed4 frag(v2f i) : SV_Target
            {
				// return tex2D(_MainTex, i.uv) * i.color;
				fixed4 albedo = tex2D(_MainTex, i.uv);
				fixed3 res = lerp(i.color.rgb, albedo.rgb, albedo.a);
				return fixed4(res, albedo.a);
            }

            ENDCG
        }
    }
}
