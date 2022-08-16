Shader "Custom/Burning"
{
    Properties
    {
        _MainTex ("Main texture", 2D) = "white" {}
        _DissolveTex ("Dissolution texture", 2D) = "gray" {}
        _Strength ("Strength", Range(-2.0, 2.0)) = 1.0
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
 
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv);
                float col = max(c.r, max(c.g, c.b));
                c.rgb = clamp(col + float3(0.1, 0.09, 0.06), float3(0.0, 0.0, 0.0), float3(0.7, 0.7, 0.7));

                fixed4 inv = fixed4(1.0 - c.rgb, c.a);
                fixed4 val = tex2D(_DissolveTex, i.uv);

                return lerp(inv, c, fixed4(val.rgb, 1.0) + _Strength);
            }
 
            ENDCG
 
        }
 
    }
    FallBack "Diffuse"
}