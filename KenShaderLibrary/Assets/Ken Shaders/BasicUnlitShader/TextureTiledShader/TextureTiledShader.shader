// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "KenShader/TextureTiledShader" {

	//Shows up in unity Editor
	Properties{
		_MainTex("Texture", 2D) = "white" {}
	}

	//White pixel shader
	Subshader{

		Tags{
			//Render after opaque geometry
			"Queue" = "Transparent"
		}

		Pass {
			//Blending is used to make transparent objects
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			//Defines info you get from each vertex on mesh
			struct appData {
				float4 vertex: POSITION;
				float2 uv : TEXCOORD0;
			};

			//Defines what info you pass to the fragment shader
			struct v2f{
				float4 vertex: SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			//Takes an appdata struct and returns a v2f
			v2f vert(appData v) {
				v2f o;
				//Transformation from point on object to point on screen
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * 2;
				return o;
			}

			//Define maintex in scope of CGProgram for compilation
			sampler2D _MainTex;

			//Takes a v2f and return a color in form of float4
			float4 frag(v2f i) : SV_Target{
				float4 color = tex2D(_MainTex, i.uv) * float4(i.uv.r, i.uv.g, 1, 1);
				return color;
			}
			ENDCG
		}		
	}
}
