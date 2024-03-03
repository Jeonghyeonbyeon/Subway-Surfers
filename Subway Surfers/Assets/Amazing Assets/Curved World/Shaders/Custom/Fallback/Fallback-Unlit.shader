Shader "Hidden/Amazing Assets/Curved World/Fallback/Unlit" 
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
        Tags { "RenderType"="CurvedWorld_Opaque" }
        LOD 100
        Cull[_Cull]

        Pass
        {
            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            #pragma shader_feature_local _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON

#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc"



			sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
			fixed _Cutoff; 

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;

				#if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
					CURVEDWORLD_TRANSFORM_VERTEX(v.vertex)
				#endif

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;                
                fixed alpha = col.a;
               

                #if defined(_ALPHATEST_ON)
                    clip (alpha - _Cutoff * 1.01);
                #endif

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);




				#if defined(_ALPHABLEND_ON) 
					col.a = alpha;
				#elif defined(_ALPHAPREMULTIPLY_ON)
					col.rgb *= alpha;
					col.a = alpha;
				#else
					UNITY_OPAQUE_ALPHA(col.a);
				#endif

                return col; 
            }
            ENDCG
        }
    }

CustomEditor "AmazingAssets.CurvedWorldEditor.FallbackShaderGUI"
}
