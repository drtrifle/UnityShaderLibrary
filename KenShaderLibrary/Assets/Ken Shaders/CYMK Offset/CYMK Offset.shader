Shader "KenShader/CYMK_Offset"
{
    //Shows up in unity Editor
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1,1,1,1)
        _C_Offset("C_Offset", Vector) = (0,0,0,0)
        _Y_Offset("Y_Offset", Vector) = (0,0,0,0)
        _M_Offset("M_Offset", Vector) = (0,0,0,0)
        _K_Offset("K_Offset", Vector) = (0,0,0,0)
    }

    SubShader{
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

        //VertexShader: Defines what info you pass to the fragment shader
        struct v2f {
            float4 vertex: SV_POSITION;
            float2 uv : TEXCOORD0;
        };

        //Takes an appdata struct and returns a v2f
        v2f vert(appData v) {
            v2f o;
            //Transformation from point on object to point on screen
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            return o;
        }

        //Define maintex in scope of CGProgram for compilation
        sampler2D _MainTex;
        float4 _Color;
        float4 _C_Offset;
        float4 _Y_Offset;
        float4 _M_Offset;
        float4 _K_Offset;

        //FragShader:Takes a v2f and return a color in form of float4
        float4 frag(v2f i) : SV_Target{
            float4 tex = tex2D(_MainTex, i.uv + _C_Offset.xy);
            float white = max(tex.r, max(tex.g,(tex.b)));
            float cyan = 1.0f - (tex.r/ white);

            tex = tex2D(_MainTex, i.uv + _M_Offset.xy);
            white = max(tex.r, max(tex.g, (tex.b)));
            float magenta = 1.0f - (tex.g / white);

            tex = tex2D(_MainTex, i.uv + _Y_Offset.xy);
            white = max(tex.r, max(tex.g, (tex.b)));
            float yellow = 1.0f - (tex.b / white);

            tex = tex2D(_MainTex, i.uv + _K_Offset.xy);
            white = max(tex.r, max(tex.g, (tex.b)));
            float black = 1.0f - white;


            float red = (1 - cyan) * (1 - black);
            float green = (1 - magenta) * (1 - black);
            float blue = (1 - yellow) * (1 - black);
            tex = tex2D(_MainTex, i.uv);

            float4 color = float4(red, green, blue, 1);
            return color;
        }
        ENDCG
        }
    }
}
