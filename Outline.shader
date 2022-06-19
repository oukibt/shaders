Shader "Custom/Outline"
{
    Properties
    {
        _Color("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.0

        _OutlineColor("Outline Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _OutlineWidth("Outline Width", Range(0, 0.2)) = 0.01

    }

    Subshader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float4 color : COLOR;
        };

        half4 _Color;
        half _Smoothness;
        half _Metallic;

        void surf(float4 color : COLOR, inout SurfaceOutputStandard o)
        {
            o.Albedo = _Color.rgb * color.rgb;
            o.Smoothness = _Smoothness;
            o.Metallic = _Metallic;
            o.Alpha = _Color.a * color.a;
        }

        ENDCG

        Pass
        {
            Cull Front

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            half _OutlineWidth;

            float4 vert(float4 position : POSITION) : SV_POSITION
            {
                position.xyz = mul(unity_WorldToObject, (mul(unity_ObjectToWorld, position.xyz) * (1.0f + _OutlineWidth)));

                return UnityObjectToClipPos(position);
            }

            half4 _OutlineColor;

            half4 frag() : SV_TARGET
            {
                return _OutlineColor;
            }

            ENDCG
        }
    }
}