Shader "Custom/ChromaticAberration"
{
    Properties
    {
        _MainTex("Texture", 2D) = "black" {}
        _Offset("Offset", Vector) = (0.0, 0.0, 0.0, 0.0)
        _Samples("Samples", Range(1.0, 64.0)) = 8
        _Center("Center", Vector) = (0.0, 0.0, 0.0, 0.0)
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

            #pragma shader_feature _FAST_MODE_ON
            #pragma shader_feature _USE_CENTER_ON

            #pragma vertex vert
            #pragma fragment frag
 
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Offset;
            int _Samples;
            float4 _Center;
 
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
                #ifdef _FAST_MODE_ON ///////////////

                    #ifdef _USE_CENTER_ON

                        fixed2 dist = (i.uv - _Center.xy) * 5.0;

                        fixed2 rUV = fixed2(i.uv.x + (_Offset.x * -dist.x / 2.0), i.uv.y + (_Offset.y * -dist.y / 2.0));
                        fixed2 gUV = fixed2(i.uv.x + (_Offset.x * -dist.x), i.uv.y + (_Offset.y * -dist.y));

                    #else

                        fixed2 rUV = fixed2(i.uv.x + _Offset.x, i.uv.y);
                        fixed2 gUV = fixed2(i.uv.x - _Offset.x / 2.0, i.uv.y);

                    #endif

                    return fixed4(tex2D(_MainTex, rUV).r, tex2D(_MainTex, gUV).g, tex2D(_MainTex, i.uv).b, 1.0);
                
                #else ///////////////

                    fixed4 tex = 0.0;

                    fixed2 v = _Offset / _Samples;

                    #ifdef _USE_CENTER_ON

                        fixed2 dist = (i.uv - _Center.xy) * 10.0;
                        for (int iter = 0; iter < _Samples; iter++)
                        {
                            fixed2 rUV = fixed2(i.uv.x + (v.x * (iter + 1) * -dist.x), i.uv.y + (v.y * (iter + 1) * -dist.y));
                            fixed2 gUV = fixed2(i.uv.x + (v.x * (iter + 1) * -dist.x) / 2.0, i.uv.y + (v.y * (iter + 1) * -dist.y) / 2.0);

                            tex += fixed4(tex2D(_MainTex, rUV).r, tex2D(_MainTex, gUV).g, tex2D(_MainTex, i.uv).b, 1.0);
                        }

                    #else

                        for (int iter = 0; iter < _Samples; iter++)
                        {
                            fixed2 rUV = fixed2(i.uv.x + v.x * 1.5 * (iter + 1), i.uv.y);
                            fixed2 gUV = fixed2(i.uv.x - v.x * 1.5 * (iter + 1) / 2.0, i.uv.y);

                            tex += fixed4(tex2D(_MainTex, rUV).r, tex2D(_MainTex, gUV).g, tex2D(_MainTex, i.uv).b, 1.0);
                        }

                    #endif

                return tex / _Samples;

                #endif ///////////////
            }
 
            ENDCG
 
        }
 
    }
    FallBack "Diffuse"
}
