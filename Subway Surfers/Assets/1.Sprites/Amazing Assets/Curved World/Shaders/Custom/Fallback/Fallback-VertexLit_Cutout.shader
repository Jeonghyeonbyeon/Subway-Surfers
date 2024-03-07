Shader "Hidden/Amazing Assets/Curved World/Fallback/VertexLit Cutout" 
{
    Properties 
    {
[HideInInspector][CurvedWorldBendSettings] _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)

         
        
        _Color ("Color (RGB)", Color) = (1, 1, 1, 1)
        _MainTex ("Base (RGB)", 2D) = "white" { }
        [HideInInspector] _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

		[HideInInspector][MaterialEnum(Front,2,Back,1,Both,0)] _Cull("Face Cull", Int) = 0

        // Blending state
        [HideInInspector] _Mode ("__mode", Float) = 0.0
        [HideInInspector] _SrcBlend ("__src", Float) = 1.0
        [HideInInspector] _DstBlend ("__dst", Float) = 0.0
        [HideInInspector] _ZWrite ("__zw", Float) = 1.0
    }
	 

SubShader  
{ 
    LOD 80
    Tags { "RenderType"="CurvedWorld_Opaque" }
    Cull[_Cull]
    
    Pass 
    {
        Tags { "LIGHTMODE"="Vertex" "RenderType"="CurvedWorld_Opaque" }

        Blend [_SrcBlend] [_DstBlend]
        ZWrite [_ZWrite]

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 2.0
        #include "UnityCG.cginc"
        #pragma multi_compile_fog
        #define USING_FOG (defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2))

        // ES2.0/WebGL can not do loops with non-constant-expression iteration counts :(
        #if defined(SHADER_API_GLES)
          #define LIGHT_LOOP_LIMIT 8
        #else
          #define LIGHT_LOOP_LIMIT unity_VertexLightParams.x
        #endif

        // Some ES3 drivers (e.g. older Adreno) have problems with the light loop
        #if defined(SHADER_API_GLES3) && !defined(SHADER_API_DESKTOP) && (defined(SPOT) || defined(POINT))
          #define LIGHT_LOOP_ATTRIBUTE UNITY_UNROLL
        #else
          #define LIGHT_LOOP_ATTRIBUTE
        #endif
        #define ENABLE_SPECULAR 1

        // Compile specialized variants for when positional (point/spot) and spot lights are present
        #pragma multi_compile __ POINT SPOT
        #define _ALPHATEST_ON



#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc"



          // Compute illumination from one light, given attenuation
          half3 computeLighting (int idx, half3 dirToLight, half3 eyeNormal, half3 viewDir, half4 diffuseColor, half shininess, half atten, inout half3 specColor) 
          {
              half NdotL = max(dot(eyeNormal, dirToLight), 0.0);
              // diffuse
              half3 color = NdotL * diffuseColor.rgb * unity_LightColor[idx].rgb;
              return color * atten;
          }

          // Compute attenuation & illumination from one light
          half3 computeOneLight(int idx, float3 eyePosition, half3 eyeNormal, half3 viewDir, half4 diffuseColor, half shininess, inout half3 specColor) 
          {
              float3 dirToLight = unity_LightPosition[idx].xyz;
              half att = 1.0;
              #if defined(POINT) || defined(SPOT)
                  dirToLight -= eyePosition * unity_LightPosition[idx].w;
                  // distance attenuation
                  float distSqr = dot(dirToLight, dirToLight);
                  att /= (1.0 + unity_LightAtten[idx].z * distSqr);

                  if (unity_LightPosition[idx].w != 0 && distSqr > unity_LightAtten[idx].w) 
                      att = 0.0; // set to 0 if outside of range

                  distSqr = max(distSqr, 0.000001); // don't produce NaNs if some vertex position overlaps with the light
                  dirToLight *= rsqrt(distSqr);
                  #if defined(SPOT)
                      // spot angle attenuation
                      half rho = max(dot(dirToLight, unity_SpotDirection[idx].xyz), 0.0);
                      half spotAtt = (rho - unity_LightAtten[idx].x) * unity_LightAtten[idx].y;
                      att *= saturate(spotAtt);
                  #endif
              #endif
              att *= 0.5; // passed in light colors are 2x brighter than what used to be in FFP
              return min (computeLighting (idx, dirToLight, eyeNormal, viewDir, diffuseColor, shininess, att, specColor), 1.0);
          }

          // uniforms
          int4 unity_VertexLightParams; // x: light count, y: zero, z: one (y/z needed by d3d9 vs loop instruction)
          float4 _MainTex_ST;

          // vertex shader input data
          struct appdata 
          {
              float4 pos : POSITION;
              float3 normal : NORMAL;
              float4 tangent : TANGENT;
              float3 uv0 : TEXCOORD0;
              UNITY_VERTEX_INPUT_INSTANCE_ID
          };

          // vertex-to-fragment interpolators
          struct v2f 
          {
              fixed4 color : COLOR0;
              float2 uv0 : TEXCOORD0;
              #if USING_FOG
                fixed fog : TEXCOORD1;
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
            



              half4 color = half4(0,0,0,1.1);
              float3 eyePos = UnityObjectToViewPos(IN.pos).xyz;
              half3 eyeNormal = normalize (mul ((float3x3)UNITY_MATRIX_IT_MV, IN.normal).xyz);
              half3 viewDir = 0.0;
              // lighting
              half3 lcolor = half4(0,0,0,1).rgb + half4(1,1,1,1).rgb * glstate_lightmodel_ambient.rgb;
              half3 specColor = 0.0;
              half shininess = 0 * 128.0;
              LIGHT_LOOP_ATTRIBUTE for (int il = 0; il < LIGHT_LOOP_LIMIT; ++il) 
              {
                  lcolor += computeOneLight(il, eyePos, eyeNormal, viewDir, half4(1,1,1,1), shininess, specColor);
              }
              color.rgb = lcolor.rgb;
              color.a = half4(1,1,1,1).a;
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
          float _Cutoff;
          fixed4 _Color;

          // fragment shader
          fixed4 frag (v2f IN) : SV_Target 
          {
              fixed4 col;
              fixed4 tex, tmp0, tmp1, tmp2;
              // SetTexture #0
              tex = tex2D (_MainTex, IN.uv0.xy) * _Color;

              #if defined(_ALPHATEST_ON)
                clip (tex.a - _Cutoff * 1.01);
              #endif

              col = tex * IN.color;
              col *= 2;
              
              // fog
              #if USING_FOG
                col.rgb = lerp (unity_FogColor.rgb, col.rgb, IN.fog);
              #endif

			  
              return col;
          }


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
        #include "UnityShaderVariables.cginc"
        #include "UnityShaderUtilities.cginc"

        #define _ALPHATEST_ON



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

        float4 _MainTex_ST;

        struct appdata
        {
            float4 pos : POSITION;
            float3 uv1 : TEXCOORD1;
            float3 uv0 : TEXCOORD0;
            UNITY_VERTEX_INPUT_INSTANCE_ID 
        };

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

        v2f vert(appdata IN)
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(IN);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


			#if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
				CURVEDWORLD_TRANSFORM_VERTEX(IN.pos)
			#endif
            


            o.uv0 = IN.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
            o.uv1 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;

            #if USING_FOG
                float3 eyePos = UnityObjectToViewPos(IN.pos);
                float fogCoord = length(eyePos.xyz);
                UNITY_CALC_FOG_FACTOR_RAW(fogCoord);
                o.fog = saturate(unityFogFactor);
            #endif

            o.pos = UnityObjectToClipPos(IN.pos);
            return o;
        }


        sampler2D _MainTex;
        float _Cutoff;
        fixed4 _Color;

        fixed4 frag(v2f IN) : SV_Target
        {
            fixed4 col;
            fixed4 tex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.uv0.xy);
            half3 bakedColor = DecodeLightmap(tex);

            tex = tex2D(_MainTex, IN.uv1.xy) * _Color;

            #if defined(_ALPHATEST_ON)
              clip (tex.a - _Cutoff * 1.01);
            #endif

            col.rgb = tex.rgb * bakedColor;
            col.a = tex.a;

            #if USING_FOG
            col.rgb = lerp(unity_FogColor.rgb, col.rgb, IN.fog);
            #endif



            return col;
        }

        ENDCG
    }

    Pass 
    {
        Name "ShadowCaster"
        Tags { "LIGHTMODE"="SHADOWCASTER" "SHADOWSUPPORT"="true" "RenderType"="CurvedWorld_Opaque" }

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

        #pragma shader_feature_local _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON



#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON

#include "../../Core/Shadow.cginc" 

        ENDCG
    }
}

CustomEditor "AmazingAssets.CurvedWorldEditor.FallbackShaderGUI"
}
