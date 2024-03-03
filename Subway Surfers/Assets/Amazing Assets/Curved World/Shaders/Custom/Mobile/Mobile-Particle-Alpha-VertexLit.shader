// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Simplified VertexLit Blended Particle shader. Differences from regular VertexLit Blended Particle one:
// - no AlphaTest
// - no ColorMask

Shader "Amazing Assets/Curved World/Mobile/Particles/VertexLit Blended" 
{
    Properties 
    {
        [HideInInspector][CurvedWorldBendSettings]	  _CurvedWorldBendSettings("0|1", Vector) = (0, 0, 0, 0)

        _EmisColor ("Emissive Color", Color) = (0.200000,0.200000,0.200000,0.000000)
        _MainTex ("Particle Texture", 2D) = "white" { }
    }

    SubShader 
    { 
        Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" "PreviewType"="Plane" }
        Pass 
        {
        	Tags { "LIGHTMODE"="Vertex" "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" "PreviewType"="Plane" }
            ZWrite Off
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha
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

            // Compute illumination from one light, given attenuation
            half3 computeLighting (int idx, half3 dirToLight, half3 eyeNormal, half3 viewDir, half4 diffuseColor, half shininess, half atten, inout half3 specColor) {
            half NdotL = max(dot(eyeNormal, dirToLight), 0.0);
            // diffuse
            half3 color = NdotL * diffuseColor.rgb * unity_LightColor[idx].rgb;
            return color * atten;
            }

            // Compute attenuation & illumination from one light
            half3 computeOneLight(int idx, float3 eyePosition, half3 eyeNormal, half3 viewDir, half4 diffuseColor, half shininess, inout half3 specColor) {
            float3 dirToLight = unity_LightPosition[idx].xyz;
            half att = 1.0;
            #if defined(POINT) || defined(SPOT)
                dirToLight -= eyePosition * unity_LightPosition[idx].w;
                // distance attenuation
                float distSqr = dot(dirToLight, dirToLight);
                att /= (1.0 + unity_LightAtten[idx].z * distSqr);
                if (unity_LightPosition[idx].w != 0 && distSqr > unity_LightAtten[idx].w) att = 0.0; // set to 0 if outside of range
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
            half4 _EmisColor;
            int4 unity_VertexLightParams; // x: light count, y: zero, z: one (y/z needed by d3d9 vs loop instruction)
            float4 _MainTex_ST;

            // vertex shader input data
            struct appdata {
            float4 pos : POSITION;
            float3 normal : NORMAL;
            half4 color : COLOR;
            float3 uv0 : TEXCOORD0;
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
            v2f vert (appdata IN) 
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


                #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
                    CURVEDWORLD_TRANSFORM_VERTEX(IN.pos)
                #endif

                half4 color = IN.color;
                float3 eyePos = UnityObjectToViewPos(IN.pos.xyz);//mul (UNITY_MATRIX_MV, float4(IN.pos,1)).xyz;
                half3 eyeNormal = normalize (mul ((float3x3)UNITY_MATRIX_IT_MV, IN.normal).xyz);
                half3 viewDir = 0.0;
                // lighting
                half3 lcolor = _EmisColor.rgb + color.rgb * glstate_lightmodel_ambient.rgb;
                half3 specColor = 0.0;
                half shininess = 0 * 128.0;
                LIGHT_LOOP_ATTRIBUTE for (int il = 0; il < LIGHT_LOOP_LIMIT; ++il) {
                    lcolor += computeOneLight(il, eyePos, eyeNormal, viewDir, color, shininess, specColor);
                }
                color.rgb = lcolor.rgb;
                color.a = color.a;
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
                o.pos = UnityObjectToClipPos(IN.pos.xyz);
                return o;
            }

            // textures
            sampler2D _MainTex;

            // fragment shader
            fixed4 frag (v2f IN) : SV_Target 
            {
                fixed4 col;
                fixed4 tex, tmp0, tmp1, tmp2;
                // SetTexture #0
                tex = tex2D (_MainTex, IN.uv0.xy);
                col = tex * IN.color;
                // fog
                #if USING_FOG
                    col.rgb = lerp (unity_FogColor.rgb, col.rgb, IN.fog);
                #endif
                return col;
            }

            // texenvs
            //! TexEnv0: 01010103 01010103 [_MainTex]
            ENDCG
        }        
    }

    CustomEditor "AmazingAssets.CurvedWorldEditor.DefaultShaderGUI"
}
