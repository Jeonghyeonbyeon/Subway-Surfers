// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Simplified Bumped Specular shader. Differences from regular Bumped Specular one:
// - no Main Color nor Specular Color
// - specular lighting directions are approximated per vertex
// - writes zero to alpha channel
// - Normalmap uses Tiling/Offset of the Base texture
// - no Deferred Lighting support
// - no Lightmap support
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "Amazing Assets/Curved World/Mobile/Bumped Specular" 
{
    Properties 
    {
        [HideInInspector][CurvedWorldBendSettings]	  _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)


        [PowerSlider(5.0)] _Shininess ("Shininess", Range (0.03, 1)) = 0.078125
        _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
        [NoScaleOffset] _BumpMap ("Normalmap", 2D) = "bump" {}
    }

    SubShader 
    {
        Tags { "RenderType"="CurvedWorld_Opaque" }
        LOD 250

        CGPROGRAM
        #pragma surface surf MobileBlinnPhong nolightmap noforwardadd halfasview interpolateview vertex:vert addshadow


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#pragma shader_feature_local CURVEDWORLD_NORMAL_TRANSFORMATION_ON
#include "../../Core/CurvedWorldTransform.cginc" 
            

        inline fixed4 LightingMobileBlinnPhong (SurfaceOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
        {
            fixed diff = max (0, dot (s.Normal, lightDir));
            fixed nh = max (0, dot (s.Normal, halfDir));
            fixed spec = pow (nh, s.Specular*128) * s.Gloss;

            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            UNITY_OPAQUE_ALPHA(c.a);
            return c;
        }

        sampler2D _MainTex;
        sampler2D _BumpMap;
        half _Shininess;

        void vert (inout appdata_full v) 
        {
            #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
                #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
                    CURVEDWORLD_TRANSFORM_VERTEX_AND_NORMAL(v.vertex, v.normal, v.tangent)
                #else
                    CURVEDWORLD_TRANSFORM_VERTEX(v.vertex)
                #endif
            #endif
        }

        struct Input 
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) 
        {
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = tex.rgb;
            o.Gloss = tex.a;
            o.Alpha = tex.a;
            o.Specular = _Shininess;
            o.Normal = UnpackNormal (tex2D(_BumpMap, IN.uv_MainTex));
        }
        ENDCG       
    }



    FallBack "Hidden/Amazing Assets/Curved World/Fallback/VertexLit"

    CustomEditor "AmazingAssets.CurvedWorldEditor.DefaultShaderGUI"
}
