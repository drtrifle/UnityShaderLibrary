// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "KenShader/BoringWhiteShader" {

	//White pixel shader
	Subshader{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			//Defines info you get from each vertex on mesh
			struct appData {
				float4 vertex: POSITION;
			};

			//Defines what info you pass to the fragment shader
			struct v2f{
				float4 vertex: SV_POSITION;
			};

			//Takes an appdata struct and returns a v2f
			v2f vert(appData v) {
				v2f o;
				//Transformation from point on object to point on screen
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			//Takes a v2f and return a color in form of float4
			float4 frag(v2f i) : SV_Target{
				return float4 (1,1,1,1);
			}
			ENDCG
		}		
	}
}
