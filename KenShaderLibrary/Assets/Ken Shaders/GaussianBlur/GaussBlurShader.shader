// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "KenShader/GaussBlurShader"
{
   Properties
     {
         _MainTex ("Texture", 2D) = "white" { }
		 _BlurAmount("BlurAmount", int) = 1
     }
 
     SubShader
     {
         // Horizontal blur pass
         Pass
         {
             Blend SrcAlpha OneMinusSrcAlpha 
             Name "HorizontalBlur"
 
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag            
             #include "UnityCG.cginc"
             
             sampler2D _MainTex;
             float4 _MainTex_TexelSize;
             int _BlurAmount;
             float _KernelWeights[11];
             
             struct v2f
             {
                 float4  pos : SV_POSITION;
                 float2  uv : TEXCOORD0;
             };
             
             float4 _MainTex_ST;
             
             v2f vert (appdata_base v)
             {
                 v2f o;
                 o.pos = UnityObjectToClipPos(v.vertex);
                 o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                 return o;
             }
             
             half4 frag (v2f i) : COLOR
             {
 
                 half4 sum = half4(0, 0, 0, 0);
                 #define texelGrab(offset, weight) tex2D(_MainTex, float2(i.uv.x + (offset * _MainTex_TexelSize.x), i.uv.y)) * weight;

                 for (int j = 1; j <= _BlurAmount; ++j) {
                     sum += texelGrab(j, _KernelWeights[j]);
                     sum += texelGrab(-j, _KernelWeights[j]);
                 }
                 sum += texelGrab(0, _KernelWeights[0]);

                 return sum;
             }
             ENDCG
         }
          
         // Vertical blur pass
         Pass
         {
             Blend SrcAlpha OneMinusSrcAlpha
             Name "VerticalBlur"
                         
             CGPROGRAM
             #pragma vertex vert
             #pragma fragment frag            
             #include "UnityCG.cginc"
 
             sampler2D _GrabTexture : register(s0);
             float4 _GrabTexture_TexelSize;
             int _BlurAmount;
             float _KernelWeights[11];

             struct v2f 
             {
                 float4  pos : SV_POSITION;
                 float2  uv : TEXCOORD0;
             };
 
             float4 _GrabTexture_ST;
 
             v2f vert (appdata_base v)
             {
                 v2f o;
                 o.pos = UnityObjectToClipPos(v.vertex);
                 o.uv = TRANSFORM_TEX(v.texcoord, _GrabTexture);
                 return o;
             }
 
             half4 frag (v2f i) : COLOR
             { 
                 half4 sum = half4(0, 0, 0, 0);
                 #define texelGrab(offset, weight) tex2D(_GrabTexture, float2(i.uv.x, i.uv.y + (offset * _GrabTexture_TexelSize.x))) * weight;

                 for (int j = 1; j <= _BlurAmount; ++j) {
                     sum += texelGrab(j, _KernelWeights[j]);
                     sum += texelGrab(-j, _KernelWeights[j]);
                 }
                 sum += texelGrab(0, _KernelWeights[0]);
 
                 return sum;
             }		 
             ENDCG
         }
     }
 
     Fallback "VertexLit"
}
