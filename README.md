# shaders

### Useful functions:
```hlsl
// avoid depth texture distortion 
float Correct01PerspectiveDepth(float rawDepth, float2 uv)
{
    float2 centeredUV = uv - 0.5;
    float aspect = _ScreenParams.x / _ScreenParams.y;
    centeredUV.x *= aspect;

    float fov = atan(1.0 / unity_CameraProjection._m11) * 2.0;
    float fovScale = tan(fov * 0.5);

    float3 rayDir = normalize(float3(centeredUV * fovScale * 2.0, 1.0));

    float depthScale = 1.0 / rayDir.z;

    float correctedDepth = rawDepth * depthScale;

    return saturate(correctedDepth);
}
```
