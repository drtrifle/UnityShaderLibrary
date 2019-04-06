Shader "Unlit/DualColor" {
    Properties {
        // Color property for material inspector
        _Color1("Color1", Color) = (1,0,0,1)
        _Color2("Color2", Color) = (0,1,0,1)
        _blend("BlendAmt", Range(0,1)) = 0.0
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // vertex shader
            float4 vert(float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            // Inputs from material
            fixed4 _Color1;
            fixed4 _Color2;
            float _blend;

            // fragment shader
            fixed4 frag() : SV_Target {
                return lerp(_Color1, _Color2, _blend); ; // just return it
            }
        ENDCG
        }
    }
}