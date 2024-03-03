// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Simplified VertexLit shader, optimized for high-poly meshes. Differences from regular VertexLit one:
// - less per-vertex work compared with Mobile-VertexLit
// - supports only DIRECTIONAL lights and ambient term, saves some vertex processing power
// - no per-material color
// - no specular
// - no emission

Shader "Amazing Assets/Curved World/Mobile/VertexLit (Only Directional Lights)" 
{
    Properties 
    {
        [HideInInspector][CurvedWorldBendSettings]	  _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)

        _MainTex ("Base (RGB)", 2D) = "white" {}
    }

    SubShader 
    {
        Tags { "RenderType"="CurvedWorld_Opaque" }
        LOD 80

        Cull Back

        Pass 
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            #pragma vertex vert_surf
            #pragma fragment frag_surf
            #pragma target 2.0
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #include "HLSLSupport.cginc"
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#pragma shader_feature_local CURVEDWORLD_NORMAL_TRANSFORMATION_ON
#include "../../Core/CurvedWorldTransform.cginc" 


            inline float3 LightingLambertVS (float3 normal, float3 lightDir)
            {
                fixed diff = max (0, dot (normal, lightDir));
                return _LightColor0.rgb * diff;
            }

            sampler2D _MainTex;

            struct Input 
            {
                float2 uv_MainTex;
            };

            void surf (Input IN, inout SurfaceOutput o) 
            {
                half4 c = tex2D (_MainTex, IN.uv_MainTex);
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }
            struct v2f_surf 
            {
                float4 pos : SV_POSITION;
                float2 pack0 : TEXCOORD0;
                #ifndef LIGHTMAP_ON
                fixed3 normal : TEXCOORD1;
                #endif
                #ifdef LIGHTMAP_ON
                float2 lmap : TEXCOORD2;
                #endif
                #ifndef LIGHTMAP_ON
                fixed3 vlight : TEXCOORD2;
                #endif
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float4 _MainTex_ST;

            v2f_surf vert_surf (appdata_full v)
            {
                v2f_surf o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


                #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
                    #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
                         CURVEDWORLD_TRANSFORM_VERTEX_AND_NORMAL(v.vertex, v.normal, v.tangent)
                    #else
                        CURVEDWORLD_TRANSFORM_VERTEX(v.vertex)
                    #endif
                #endif



                o.pos = UnityObjectToClipPos(v.vertex);
                o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                #ifdef LIGHTMAP_ON
                o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                #endif
                float3 worldN = UnityObjectToWorldNormal(v.normal);
                #ifndef LIGHTMAP_ON
                o.normal = worldN;
                #endif
                #ifndef LIGHTMAP_ON

                o.vlight = ShadeSH9 (float4(worldN,1.0));
                o.vlight += LightingLambertVS (worldN, _WorldSpaceLightPos0.xyz);

                #endif
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            fixed4 frag_surf (v2f_surf IN) : SV_Target
            {
                Input surfIN;
                surfIN.uv_MainTex = IN.pack0.xy;
                SurfaceOutput o;
                o.Albedo = 0.0;
                o.Emission = 0.0;
                o.Specular = 0.0;
                o.Alpha = 0.0;
                o.Gloss = 0.0;
                #ifndef LIGHTMAP_ON
                o.Normal = IN.normal;
                #else
                o.Normal = 0;
                #endif
                surf (surfIN, o);
                fixed atten = LIGHT_ATTENUATION(IN);
                fixed4 c = 0;
                #ifndef LIGHTMAP_ON
                c.rgb = o.Albedo * IN.vlight * atten;
                #endif
                #ifdef LIGHTMAP_ON
                fixed3 lm = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy));
                #ifdef SHADOWS_SCREEN
                c.rgb += o.Albedo * min(lm, atten*2);
                #else
                c.rgb += o.Albedo * lm;
                #endif
                c.a = o.Alpha;
                #endif
                UNITY_APPLY_FOG(IN.fogCoord, c);
                UNITY_OPAQUE_ALPHA(c.a);
                return c;
            }

            ENDCG
        }


        Pass 
    {
        Name "ShadowCaster"
        Tags { "LIGHTMODE"="SHADOWCASTER" "SHADOWSUPPORT"="true" "RenderType"="CurvedWorld_Opaque" }
        Cull Off
        ZWrite On ZTest LEqual

        CGPROGRAM
        #include "HLSLSupport.cginc"
        #define UNITY_INSTANCED_LOD_FADE
        #define UNITY_INSTANCED_SH
        #define UNITY_INSTANCED_LIGHTMAPSTS
        #include "UnityShaderVariables.cginc"
        #include "UnityShaderUtilities.cginc"


        #pragma vertex vert
        #pragma fragment frag
        #pragma target 2.0
        #pragma multi_compile_shadowcaster 
        #include "UnityCG.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 

#include "../../Core/Shadow.cginc" 

        ENDCG
    }
        
}

    FallBack "Hidden/Amazing Assets/Curved World/Fallback/VertexLit"

    CustomEditor "AmazingAssets.CurvedWorldEditor.DefaultShaderGUI"
}
