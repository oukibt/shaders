Shader "Custom/Burning"
{
    Properties
    {
        _MainTex("Main texture", 2D) = "white" {}
        _DissolveTex("Dissolution texture", 2D) = "black" {}
        _Step("Step", Range(0.0, 1.0)) = 1.0
        _Smoothness("Smoothness", Range(0.501, 1.5)) = 1.0
        _Strength("Strength", Range(-0.5, 0.5)) = 0.5
    }
 
    SubShader
    {
        Tags
        {
            "Queue"="Geometry"
        }
 
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
 
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DissolveTex;
            float _Strength;
            float _Step;
            float _Smoothness;
 
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
 
            v2f vert(appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }
 
            float4 frag(v2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.uv);
                float col = 1.0 - (c.r + c.g + c.b) / 3.0;
                float4 inv = float4(col, col, col, c.a);

                float4 val = tex2D(_DissolveTex, i.uv) * _Step;

                return lerp(inv, c, smoothstep(_Strength, _Smoothness, float4(val.rgb, 1.0) - _Strength));
            }
 
            ENDCG
 
        }
 
    }
    FallBack "Diffuse"
}