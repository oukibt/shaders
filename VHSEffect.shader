Shader "Hidden/VHSEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "black" {}
        _Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Amount("Amount", Float) = 0.5
        _Power("Power", Float) = 0.8
        _Speed("Speed", Float) = 0.5
        _Grain("Grain", Vector) = (0.5, 0.5, 0.0, 0.0)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }
 
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
 
            #include "UnityCG.cginc"

            #define MOD3 float3(443.8975, 397.2973, 491.1871)

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _Grain;
            float _Amount;
            float _Power;
            float _Speed;
 
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float hash(float n)
            {
                return frac(sin(n) * 43758.5453123);
            }

            float niq(in float3 x)
            {
                float3 p = floor(x);
                float3 f = frac(x);

                f = f * f * (3.0 - 2.0 * f);

                float n = p.x + p.y * 57.0 + 113.0 * p.z;
                float res = lerp(lerp(lerp(hash(n +  0.0), hash(n + 1.0), f.x),
                                    lerp(hash(n + 57.0), hash(n + 58.0), f.x), f.y),
                                    lerp(lerp(hash(n + 113.0), hash(n + 114.0), f.x),
                                    lerp(hash(n + 170.0), hash(n + 171.0), f.x), f.y), f.z);
                return res;
            }

            float tapeNoiseLines(float2 p, float t)
            {
               float y = p.y * _ScreenParams.y;
               float s = t * 2.0;

               return (niq(float3(y * 0.01 + s, 1.0, 1.0)) + 0.0) * (niq(float3(y * 0.011 + 1000.0 + s, 1.0, 1.0)) + 0.0) * (niq(float3(y * 0.51 + 421.0 + s, 1.0, 1.0)) + 0.0);
            }

            float hash12(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * MOD3);
                p3 += dot(p3, p3.yzx + 19.19);
                return frac(p3.x * p3.z * p3.y);
            }

            float tapeNoise(float nl, float2 p, float t, float amount, float2 grain)
            {
                float nm = hash12(frac(p + t * grain));
                nm = nm * nm * nm * nm + 0.3;

                nl *= nm;

                if (nl < amount) nl = 0.0;
                else nl = 1.0;

                return nl;
            }
 
            v2f vert(appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float time = _Time.y * _Speed;
                float2 uv = i.uv;

                #if UNITY_UV_STARTS_AT_TOP
                    uv.y = 1.0 - uv.y;
                #endif

                float nt = 0.0;
                float nl = 0.0;
                float ntail = 0.0;

                nl = tapeNoiseLines(uv, time);
                nt = tapeNoise(nl, uv, time, 1.0 - _Amount, _Grain.xy);
                ntail = hash12(uv + float2(0.01, 0.02));

                float2 pos = uv * 50.0;
                float4 val = float4(nt, nt, nt, ntail) * _Color;

                if (ntail > _Power) val.rgb = float3(0.0, 0.0, 0.0);

                return col + val;
            }
 
            ENDCG
        }
    }
}