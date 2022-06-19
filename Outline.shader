Shader "Custom/Outline"
{
    Properties
    {
        _OutlineColor("Outline Color", Color) = (0.0, 0.0, 0.0, 1.0)
        _OutlineWidth("Outline Width", Range(0.0, 0.2)) = 0.01

    }

    Subshader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }
        
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