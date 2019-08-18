// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "KenShader/GaussBlurShader"
{
   Properties
     {
         _MainTex ("Texture", 2D) = "white" { }
		 _BlurAmount("BlurAmount", float) = 0.0075
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
			 float _BlurAmount; 
             
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
 
                 half4 sum = half4(0,0,0,0);
                 #define GRABPIXEL(weight,kernelx) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x + _GrabTexture_TexelSize.x * kernelx*_Size, i.uvgrab.y, i.uvgrab.z, i.uvgrab.w))) * weight
                 #define texelGrab(offset, weight) tex2D(_MainTex, float2(i.uv.x - offset * _BlurAmount, i.uv.y)) * weight;
 
                 sum += tex2D(_MainTex, float2(i.uv.x - 5.0 * _BlurAmount, i.uv.y)) * 0.025;
                 sum += tex2D(_MainTex, float2(i.uv.x - 4.0 * _BlurAmount, i.uv.y)) * 0.05;
                 sum += tex2D(_MainTex, float2(i.uv.x - 3.0 * _BlurAmount, i.uv.y)) * 0.09;
                 sum += tex2D(_MainTex, float2(i.uv.x - 2.0 * _BlurAmount, i.uv.y)) * 0.12;
                 sum += tex2D(_MainTex, float2(i.uv.x - _BlurAmount, i.uv.y)) * 0.15;
                 sum += tex2D(_MainTex, float2(i.uv.x, i.uv.y)) * 0.16;
                 sum += tex2D(_MainTex, float2(i.uv.x + _BlurAmount, i.uv.y)) * 0.15;
                 sum += tex2D(_MainTex, float2(i.uv.x + 2.0 * _BlurAmount, i.uv.y)) * 0.12;
                 sum += tex2D(_MainTex, float2(i.uv.x + 3.0 * _BlurAmount, i.uv.y)) * 0.09;
                 sum += tex2D(_MainTex, float2(i.uv.x + 4.0 * _BlurAmount, i.uv.y)) * 0.05;
                 sum += tex2D(_MainTex, float2(i.uv.x + 5.0 * _BlurAmount, i.uv.y)) * 0.025;
				 
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
 			 float _BlurAmount; 

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
                 half4 sum = half4(0.0, 0.0, 0.0, 0.0); 
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y - 5.0 * _BlurAmount)) * 0.025;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y - 4.0 * _BlurAmount)) * 0.05;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y - 3.0 * _BlurAmount)) * 0.09;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y - 2.0 * _BlurAmount)) * 0.12;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y - _BlurAmount)) * 0.15;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y)) * 0.16;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y + _BlurAmount)) * 0.15;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y + 2.0 * _BlurAmount)) * 0.12;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y + 3.0 * _BlurAmount)) * 0.09;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y + 4.0 * _BlurAmount)) * 0.05;
                 sum += tex2D(_GrabTexture, float2(i.uv.x, i.uv.y + 5.0 * _BlurAmount)) * 0.025;
 
                 return sum;
             }		 
             ENDCG
         }
     }
 
     Fallback "VertexLit"
}
