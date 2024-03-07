// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit shader. Simplest possible textured shader.
// - SUPPORTS lightmap
// - no lighting
// - no per-material color

Shader "Amazing Assets/Curved World/Mobile/Unlit (Supports Lightmap)" 
{

    Properties 
    {
        [HideInInspector][CurvedWorldBendSettings]	  _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)

        _MainTex ("Base (RGB)", 2D) = "white" { }
    }

SubShader 
{ 
    LOD 100
    Tags { "RenderType"="CurvedWorld_Opaque" }
 
    Pass 
    {
        Tags { "LIGHTMODE"="Vertex" "RenderType"="CurvedWorld_Opaque" }
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 2.0
        #include "UnityCG.cginc"
        #pragma multi_compile_fog
        #define USING_FOG (defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2))


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#pragma shader_feature_local CURVEDWORLD_NORMAL_TRANSFORMATION_ON
#include "../../Core/CurvedWorldTransform.cginc" 


        // uniforms
        float4 _MainTex_ST;

        // vertex shader input data
        struct appdata {
        float3 pos : POSITION;
        float3 uv0 : TEXCOORD0;

        #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
            float3 normal  : NORMAL;
            float4 tangent : TANGENT;
        #endif
        UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        // vertex-to-fragment interpolators
        struct v2f {
        fixed4 color : COLOR0;
        float2 uv0 : TEXCOORD0;
        #if USING_FOG
            fixed fog : TEXCOORD1;
        #endif
        float4 pos : SV_POSITION;
        UNITY_VERTEX_OUTPUT_STEREO
        };

        // vertex shader
        v2f vert (appdata IN) {
        v2f o;
        UNITY_SETUP_INSTANCE_ID(IN);
        UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

        float4 vertexPos = float4(IN.pos.xyz, 1);
        #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
            #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
                CURVEDWORLD_TRANSFORM_VERTEX_AND_NORMAL(vertexPos, IN.normal, IN.tangent)
            #else
                CURVEDWORLD_TRANSFORM_VERTEX(vertexPos)
            #endif
        #endif
        IN.pos.xyz = vertexPos.xyz;


        half4 color = half4(0,0,0,1.1);
        float3 eyePos = UnityObjectToViewPos(IN.pos);//mul (UNITY_MATRIX_MV, float4(IN.pos,1)).xyz;
        half3 viewDir = 0.0;
        o.color = saturate(color);
        // compute texture coordinates
        o.uv0 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
        // fog
        #if USING_FOG
            float fogCoord = length(eyePos.xyz); // radial fog distance
            UNITY_CALC_FOG_FACTOR_RAW(fogCoord);
            o.fog = saturate(unityFogFactor);
        #endif
        // transform position
        o.pos = UnityObjectToClipPos(IN.pos);
        return o;
        }

        // textures
        sampler2D _MainTex;

        // fragment shader
        fixed4 frag (v2f IN) : SV_Target {
        fixed4 col;
        fixed4 tex, tmp0, tmp1, tmp2;
        // SetTexture #0
        tex = tex2D (_MainTex, IN.uv0.xy);
        col.rgb = tex;
        col.a = fixed4(1,1,1,1).a;
        // fog
        #if USING_FOG
            col.rgb = lerp (unity_FogColor.rgb, col.rgb, IN.fog);
        #endif
        return col;
        }

        // texenvs
        //! TexEnv0: 01010000 01060004 [_MainTex] [ffffffff]
        ENDCG
    }


    Pass 
    {
        Tags { "LIGHTMODE"="VertexLM" "RenderType"="CurvedWorld_Opaque" }
        CGPROGRAM


        #include "HLSLSupport.cginc"
        #define UNITY_INSTANCED_LOD_FADE
        #define UNITY_INSTANCED_SH
        #define UNITY_INSTANCED_LIGHTMAPSTS
        #define UNITY_INSTANCED_RENDERER_BOUNDS
        #include "UnityShaderVariables.cginc"
        #include "UnityShaderUtilities.cginc"


        #pragma vertex vert
        #pragma fragment frag
        #pragma target 2.0
        #include "UnityCG.cginc"
        #pragma multi_compile_fog
        #define USING_FOG (defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2))


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#pragma shader_feature_local CURVEDWORLD_NORMAL_TRANSFORMATION_ON
#include "../../Core/CurvedWorldTransform.cginc" 


        // uniforms
        float4 _MainTex_ST;

        // vertex shader input data
        struct appdata
        {
            float3 pos : POSITION;
            float3 uv1 : TEXCOORD1;
            float3 uv0 : TEXCOORD0;

             #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
                float3 normal  : NORMAL;
                float4 tangent : TANGENT;
            #endif

            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        // vertex-to-fragment interpolators
        struct v2f
        {
            float2 uv0 : TEXCOORD0;
            float2 uv1 : TEXCOORD1;
#if USING_FOG
            fixed fog : TEXCOORD2;
#endif
            float4 pos : SV_POSITION;
            UNITY_VERTEX_OUTPUT_STEREO
        };

        // vertex shader
        v2f vert(appdata IN)
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(IN);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


            float4 vertexPos = float4(IN.pos.xyz, 1);
            #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
                #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
                    CURVEDWORLD_TRANSFORM_VERTEX_AND_NORMAL(vertexPos, IN.normal, IN.tangent)
                #else
                    CURVEDWORLD_TRANSFORM_VERTEX(vertexPos)
                #endif
            #endif
            IN.pos.xyz = vertexPos.xyz;

            // compute texture coordinates
            o.uv0 = IN.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
            o.uv1 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;

            // fog
#if USING_FOG
            float3 eyePos = UnityObjectToViewPos(float4(IN.pos, 1));
            float fogCoord = length(eyePos.xyz);  // radial fog distance
            UNITY_CALC_FOG_FACTOR_RAW(fogCoord);
            o.fog = saturate(unityFogFactor);
#endif

            // transform position
            o.pos = UnityObjectToClipPos(IN.pos);
            return o;
        }

        // textures
        sampler2D _MainTex;

        // fragment shader
        fixed4 frag(v2f IN) : SV_Target
        {
            fixed4 col, tex;

            // Fetch lightmap
            half4 bakedColorTex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.uv0.xy);
            col.rgb = DecodeLightmap(bakedColorTex);

            // Fetch color texture
            tex = tex2D(_MainTex, IN.uv1.xy);
            col.rgb = tex.rgb * col.rgb;
            col.a = 1;

            // fog
            #if USING_FOG
                    col.rgb = lerp(unity_FogColor.rgb, col.rgb, IN.fog);
            #endif

            return col;
        }

        ENDCG
    }   //Pass     


    } //SubShader


    CustomEditor "AmazingAssets.CurvedWorldEditor.DefaultShaderGUI"
}
