// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Simplified Multiply Particle shader. Differences from regular Multiply Particle one:
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask


Shader "Amazing Assets/Curved World/Mobile/Particles/Multiply" 
{
    Properties 
    {
        [HideInInspector][CurvedWorldBendSettings]	  _CurvedWorldBendSettings("0|1", Vector) = (0, 0, 0, 0)

        _MainTex ("Particle Texture", 2D) = "white" { }
    }

SubShader 
{ 
    Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" "PreviewType"="Plane" }
    Pass 
    {
    	Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" "PreviewType"="Plane" }
        ZWrite Off
        Cull Off
        Blend Zero SrcColor
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
#include "../../Core/CurvedWorldTransform.cginc" 


        // uniforms
        float4 _MainTex_ST;

        // vertex shader input data
        struct appdata {
        float4 pos : POSITION;
        half4 color : COLOR;
        float3 uv0 : TEXCOORD0;
        UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        // vertex-to-fragment interpolators
        struct v2f {
        fixed4 color : COLOR0;
        float2 uv0 : TEXCOORD0;
        float2 uv1 : TEXCOORD1;
        #if USING_FOG
            fixed fog : TEXCOORD2;
        #endif
        float4 pos : SV_POSITION;
        UNITY_VERTEX_OUTPUT_STEREO
        };

        // vertex shader
        v2f vert (appdata IN) 
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(IN);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


            #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
                CURVEDWORLD_TRANSFORM_VERTEX(IN.pos)
            #endif


            half4 color = IN.color;
            float3 eyePos = UnityObjectToViewPos(IN.pos.xyz);// mul (UNITY_MATRIX_MV, float4(IN.pos,1)).xyz;
            half3 viewDir = 0.0;
            o.color = saturate(color);
            // compute texture coordinates
            o.uv0 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
            o.uv1 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
            // fog
            #if USING_FOG
                float fogCoord = length(eyePos.xyz); // radial fog distance
                UNITY_CALC_FOG_FACTOR_RAW(fogCoord);
                o.fog = saturate(unityFogFactor);
            #endif
            // transform position
            o.pos = UnityObjectToClipPos(IN.pos.xyz);
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
        col = tex * IN.color;
        // SetTexture #1
        tex = tex2D (_MainTex, IN.uv1.xy);
        col = lerp (fixed4(1,1,1,1), col, col.a);
        // fog
        #if USING_FOG
            col.rgb = lerp (unity_FogColor.rgb, col.rgb, IN.fog);
        #endif
        return col;
        }

        // texenvs
        //! TexEnv0: 01010103 01010103 [_MainTex]
        //! TexEnv1: 01008002 01008002 [_MainTex] [ffffffff]
        ENDCG
        }
        
    }


    CustomEditor "AmazingAssets.CurvedWorldEditor.DefaultShaderGUI"
}
