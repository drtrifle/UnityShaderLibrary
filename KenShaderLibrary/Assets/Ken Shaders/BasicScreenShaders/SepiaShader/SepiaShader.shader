// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "KenShader/SepiaShader" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			float4 frag(v2f i) : SV_Target {
				float4 tex = tex2D(_MainTex, i.uv);
				float outputRed = (tex.r * .393) + (tex.g *.769) + (tex.b * .189);
				float outputGreen = (tex.r * .349) + (tex.g *.686) + (tex.b * .168);
				float outputBlue = (tex.r * .272) + (tex.g *.534) + (tex.b * .131);
				return float4(outputRed, outputGreen, outputBlue, tex.a);
			}
			ENDCG
		}
	}
}