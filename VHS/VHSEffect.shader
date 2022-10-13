Shader "Hidden/VHSEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "black" {}
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

            #pragma shader_feature _TAPE_NOISE_ON
            #pragma shader_feature _LINE_NOISE_ON

            //

            #define MOD3 float3(443.8975, 397.2973, 491.1871)

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _TapeColor;
            float _TapeGrainSize;
            float _TapeAmount;
            float _TapePower;
            float _TapeSpeed;

            float _LineSize;
            float _LinePower;
            float _LineXPower;
            float _LinePosition;
 
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

               return (niq(float3(y * 0.01 + s, 1.0, 1.0)) + 0.0) * (niq(float3(y * 0.011 + 100.0 + s, 1.0, 1.0)) + 0.0) * (niq(float3(y * 0.51 + 421.0 + s, 1.0, 1.0)) + 0.0);
            }

            float hash12(float2 p)
            {
                float3 p3 = frac(float3(p.xyx) * MOD3);
                p3 += dot(p3, p3.yzx + 19.19);
                return frac(p3.x * p3.z * p3.y);
            }

            float tapeNoise(float nl, float2 p, float amount, float sz)
            {
                float nm = hash12(sqrt(p + float2(sz * 5.0, 0.637)));
                nm = nm * nm * nm * nm + 0.3;

                nl *= nm;

                if (nl < amount) nl = 0.0;
                else nl = 1.0;

                return nl;
            }

            float random(float2 p)
            {
                return frac(cos(dot(p * _Time.x, float2(23.14069263277926, 2.665144142690225))) * 123456.6789);
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

                float2 uv = i.uv;

                #if UNITY_UV_STARTS_AT_TOP
                    uv.y = 1.0 - uv.y;
                #endif

                //

                #ifdef _LINE_NOISE_ON
                    float pos = 1.0 - _LinePosition;

                    float a = pos;
                    float b = pos + _LineSize;
                    float dist = (b - a);

                    float normcoords = (i.uv.y - a) / dist;

                    float offset = (normcoords * 2.0) - 1.0; // -1.0 .. 1.0
                    float s = sign(offset);
                    float val = pow(abs(offset), _LinePower);
                    float c = val * s * dist;

                    if (i.uv.y > a && i.uv.y < b) col = tex2D(_MainTex, float2(i.uv.x + _LineXPower * sin(normcoords * UNITY_PI), a + (c * 0.5 + 0.5 * dist)));
                #endif

                //

                #ifdef _TAPE_NOISE_ON
                    float time = _Time.y * _TapeSpeed;

                    float nt = 0.0;
                    float nl = 0.0;
                    float ntail = 0.0;

                    nl = tapeNoiseLines(uv, time);
                    nt = tapeNoise(nl, uv, 1.0 - _TapeAmount, clamp(_TapeGrainSize, 1.0, 20000.0));
                    ntail = random(uv);

                    float4 color = float4(nt, nt, nt, ntail) * _TapeColor;

                    if (ntail > _TapePower) color.rgb = float3(0.0, 0.0, 0.0);

                    col += (color * _TapeColor.a);
                #endif

                //

                return col;
            }
 
            ENDCG
        }
    }
}