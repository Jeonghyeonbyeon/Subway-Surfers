Shader "Amazing Assets/Curved World/Debug Normal"
{
    Properties
    {
        [CurvedWorldBendSettings] _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="CurvedWorld_Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#pragma shader_feature_local CURVEDWORLD_NORMAL_TRANSFORMATION_ON
#include "../../Core/CurvedWorldTransform.cginc" 

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {                
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
            };


            v2f vert (appdata v)
            {
                v2f o;


                #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
                    #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
                        CURVEDWORLD_TRANSFORM_VERTEX_AND_NORMAL(v.vertex, v.normal, v.tangent)
                    #else
                        CURVEDWORLD_TRANSFORM_VERTEX(v.vertex)
                    #endif
                #endif


                o.vertex = UnityObjectToClipPos(v.vertex);  
                o.normal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {                
                return float4(i.normal, 1);
            }
            ENDCG
        }        
    }
}
