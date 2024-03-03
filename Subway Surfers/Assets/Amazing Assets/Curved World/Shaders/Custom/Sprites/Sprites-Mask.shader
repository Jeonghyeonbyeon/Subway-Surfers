// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Amazing Assets/Curved World/Sprites/Mask"
{
    Properties
    {
        [HideInInspector][CurvedWorldBendSettings]	  _CurvedWorldBendSettings("0|1", Vector) = (0, 0, 0, 0)

        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [HideInInspector] _Cutoff ("Mask alpha cutoff", Range(0.0, 1.0)) = 0.0
        _Color ("Tint", Color) = (1,1,1,0.2)
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0

        [HideInInspector][MaterialEnum(Front,2,Back,1,Both,0)] _Cull("Face Cull", Int) = 0
    }

    SubShader
    {
        Cull[_Cull] 

        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Lighting Off
        ZWrite Off
        Blend Off
        ColorMask 0

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_local _ PIXELSNAP_ON
            #pragma multi_compile _ ETC1_EXTERNAL_ALPHA


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#include "../../Core/CurvedWorldTransform.cginc" 


            #include "UnitySprites.cginc"

            // alpha below which a mask should discard a pixel, thereby preventing the stencil buffer from being marked with the Mask's presence
            fixed _Cutoff;

            struct appdata_masking
            {
                float4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f_masking
            {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f_masking vert(appdata_masking IN)
            {
                v2f_masking OUT;

                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);


                #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
                    CURVEDWORLD_TRANSFORM_VERTEX(IN.vertex)
                #endif


                OUT.pos = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.texcoord;

                #ifdef PIXELSNAP_ON
                OUT.pos = UnityPixelSnap (OUT.pos);
                #endif

                return OUT;
            }


            fixed4 frag(v2f_masking IN) : SV_Target
            {
                fixed4 c = SampleSpriteTexture(IN.uv);
                // for masks: discard pixel if alpha falls below MaskingCutoff
                clip (c.a - _Cutoff);
                return _Color;
            }
        ENDCG
        }
    }

    CustomEditor "AmazingAssets.CurvedWorldEditor.SpritesShaderGUI"
}
