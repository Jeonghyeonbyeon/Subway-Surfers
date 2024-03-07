Shader "Amazing Assets/Curved World/One Directional Light"
{
	Properties    
	{                   

[HideInInspector][CurvedWorldBendSettings]	  _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)


[HideInInspector][MaterialEnum(Front,2,Back,1,Both,0)] _Cull("Face Cull", Int) = 0

		[HideInInspector][Toggle] _AmbientLights("", float) = 0
		[HideInInspector][Toggle] _PerVertexLights("", float) = 0
		
		[HideInInspector] _LightLookupTex("", 2D) = "grey"{}
		[HideInInspector] _LightLookupOffset("", Range(-1, 1)) = 0

		[HideInInspector][CurvedWorldToggleFloat] _IncludeVertexColor("", float) = 0
		[HideInInspector] _Color ("Color (RGB)", Color) = (1, 1, 1, 1)
        [HideInInspector] _MainTex ("Base (RGB)", 2D) = "white" { }
		[HideInInspector][CurvedWorldUVScroll] _MainTex_Scroll("", vector) = (0, 0, 0, 0)
        [HideInInspector] _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

		[HideInInspector][KeywordEnum(None, By Main Alpha, By Secondary Alpha, Multiple, Additive, By Vertex Alpha)] _TextureMix ("", Float) = 0
		[HideInInspector] _SecondaryTex ("", 2D) = "white" { }
		[HideInInspector][CurvedWorldUVScroll] _SecondaryTex_Scroll("", vector) = (0, 0, 0, 0)
		[HideInInspector] _SecondaryTex_Blend("", Range(-1, 1)) = 0
		
		[HideInInspector] _NormalMapStrength("", float) = 1
		[HideInInspector][Normal] _NormalMap("", 2D) = "bump" {}
		[HideInInspector] _NormalMap_Scroll ("", vector) = (0, 0, 0, 0)
		[HideInInspector][Normal] _SecondaryNormalMap("", 2D) = "bump"{}
		[HideInInspector] _SecondaryNormalMap_Scroll ("", vector) = (0, 0, 0, 0)

		[HideInInspector] _SpecularColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		[HideInInspector] _Shininess("Shininess", Range(0, 1)) = 0.7
		[HideInInspector] _SpecularMaskOffset("", Range(-1, 1)) = 0

		[HideInInspector] _ReflectionColor("", color) = (1, 1, 1, 1)
		[HideInInspector] _ReflectionMaskOffset("", Range(-1, 1)) = 0
		[HideInInspector] _ReflectionCubeMap("", Cube) = "_Skybox"{}	
		[HideInInspector] _ReflectionFresnelBias("", Range(-1, 1)) = 0

		[HideInInspector][HDR] _RimColor("", color) = (1, 1, 1, 1)
		[HideInInspector] _RimBias("", Range(-1, 1)) = 0

		[HideInInspector][HDR] _EmissionColor("", color) = (0, 0, 0, 0)
		[HideInInspector] _EmissionMap("", 2D) = "white"{}
		[HideInInspector] _EmissionMap_Scroll ("", vector) = (0, 0, 0, 0)

        // Blending state
        [HideInInspector] _Mode ("__mode", Float) = 0.0
        [HideInInspector] _SrcBlend ("__src", Float) = 1.0
        [HideInInspector] _DstBlend ("__dst", Float) = 0.0
        [HideInInspector] _ZWrite ("__zw", Float) = 1.0
	}

 
	SubShader 
	{
		Tags { "RenderType"="CurvedWorld_Opaque" } 
		LOD 200		
		Cull[_Cull]     
 
		//PassName "Forward"
		Pass
	    {
			Name "Forward"
			Tags { "LightMode" = "ForwardBase" } 

			Blend [_SrcBlend] [_DstBlend]
        	ZWrite [_ZWrite]

			CGPROGRAM       
			#pragma vertex vert  
	    	#pragma fragment frag  
			#pragma multi_compile_instancing 
			#pragma multi_compile_fwdbase nodirlightmap nodynlightmap
			#pragma multi_compile_fog	       
			#pragma shader_feature_local _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
  
			#pragma shader_feature_local _AMBIENTLIGHTS_ON
			#pragma shader_feature_local _PERVERTEXLIGHTS_ON
			#pragma shader_feature_local _LIGHTLOOKUP
			#pragma shader_feature_local _ _TEXTUREMIX_BY_MAIN_ALPHA _TEXTUREMIX_BY_SECONDARY_ALPHA _TEXTUREMIX_MULTIPLE _TEXTUREMIX_ADDITIVE _TEXTUREMIX_BY_VERTEX_ALPHA
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _SPECULAR
			#pragma shader_feature_local _REFLECTION
			#pragma shader_feature_local _RIM
			#pragma shader_feature_local _EMISSION


#define CURVEDWORLD_BEND_TYPE_CLASSICRUNNER_X_POSITIVE
#define CURVEDWORLD_BEND_ID_1
#pragma shader_feature_local CURVEDWORLD_DISABLED_ON
#pragma shader_feature_local CURVEDWORLD_NORMAL_TRANSFORMATION_ON


			#include "ForwardBase.cginc" 
			
			ENDCG    
			 
		} //Pass "Forward"  	


		//PassName "ShadowCaster"
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
		}	//Pass "ShadowCaster"
			
			
	} //SubShader


	Fallback "Hidden/Amazing Assets/Curved World/Fallback/VertexLit"
	CustomEditor "AmazingAssets.CurvedWorldEditor.OneDirectionalLightShaderGUI"
} //Shader
