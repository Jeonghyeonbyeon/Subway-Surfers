#ifndef CURVEDWORLD_UNLIT_CGINC
#define CURVEDWORLD_UNLIT_CGINC


#include "UnityCG.cginc"

#include "../../Core/CurvedWorldTransform.cginc" 


#if !defined(_REFLECTION) && !defined(_MATCAP) && !defined(_RIM)
	#ifdef _NORMALMAP
	#undef _NORMALMAP
	#endif
#endif


//Variables/////////////////////////////////////////////////////////////
float4 _Color;
sampler2D _MainTex;
float4 _MainTex_ST;
float2 _MainTex_Scroll;

float _IncludeVertexColor;


#ifdef _NORMALMAP
	sampler2D _NormalMap;
	float4 _NormalMap_ST;
	float2 _NormalMap_Scroll;
	float _NormalMapStrength;
#endif

 
#if defined(_REFLECTION)
	samplerCUBE _ReflectionCubeMap;
	float4 _ReflectionColor;
	float _ReflectionMaskOffset;
	float _ReflectionFresnelBias;
#endif

#if defined(_TEXTUREMIX_BY_MAIN_ALPHA) || defined(_TEXTUREMIX_BY_SECONDARY_ALPHA) || defined(_TEXTUREMIX_MULTIPLE) || defined(_TEXTUREMIX_ADDITIVE) || defined(_TEXTUREMIX_BY_VERTEX_ALPHA)
	sampler2D _SecondaryTex;
	float4 _SecondaryTex_ST;
	float2 _SecondaryTex_Scroll;

	#ifdef _TEXTUREMIX_BY_VERTEX_ALPHA
		float _SecondaryTex_Blend;
	#endif

	#ifdef _NORMALMAP
		sampler2D _SecondaryNormalMap;
		float4 _SecondaryNormalMap_ST;
		float2 _SecondaryNormalMap_Scroll;
	#endif
#endif

#ifdef _ALPHATEST_ON
	float _Cutoff;
#endif


#ifdef _EMISSION
	sampler2D _EmissionMap;
	float4 _EmissionColor;
	float4 _EmissionMap_ST;
	float2 _EmissionMap_Scroll;
#endif

#ifdef _RIM
	float4 _RimColor;
	float  _RimBias;
#endif

#if defined(_MATCAP)
	sampler2D _MatcapMap;
	float _MatcapIntensity;
	float _MatcapBlendMode;	//0 - multiply, 1 - additive
#endif

//Structs///////////////////////////////////////////////////////////////
struct vInput
{
	float4 vertex : POSITION;    
	float4 texcoord : TEXCOORD0;
	float3 normal : NORMAL;	
	float4 tangent : TANGENT;
	float4 color : COLOR;

	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct vOutput
{
	float4 pos : SV_POSITION;
	float2 texcoord : TEXCOORD0;

	float4 normal : TEXCOORD1; //xyz - normal

	#if defined(_REFLECTION)
		float4 refl : TEXCOORD2;	//xyz - refl, w - fresnel
	#endif

	UNITY_FOG_COORDS(3)

	#ifdef _MATCAP
		#ifdef _NORMALMAP
			float3 matcapTan : TEXCOORD4; 
			float3 matcapBiN : TEXCOORD5; 
		#else
			float2 matcap : TEXCOORD4; 
		#endif
	#endif

	#if defined(_RIM)
		float4 viewDir : TEXCOORD6;
	#endif

	float4 color : COLOR;

	UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

//Vertex////////////////////////////////////////////////////////////////
vOutput vert(vInput v)
{ 
	UNITY_SETUP_INSTANCE_ID(v);
	vOutput o;
	UNITY_INITIALIZE_OUTPUT(vOutput, o);
	UNITY_TRANSFER_INSTANCE_ID(v, o);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		

	//Curved World
	#if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
		#ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON
			CURVEDWORLD_TRANSFORM_VERTEX_AND_NORMAL(v.vertex, v.normal, v.tangent)
		#else
			CURVEDWORLD_TRANSFORM_VERTEX(v.vertex)
		#endif
	#endif


	o.pos = UnityObjectToClipPos(v.vertex);		

	o.texcoord.xy = v.texcoord.xy;
	o.color = v.color;


	#if defined(_REFLECTION)
		float3 viewDir_WS = WorldSpaceViewDir(v.vertex);
	#endif
	#if defined(_REFLECTION) || defined(_RIM)
		float3 viewDir_OS = normalize(ObjSpaceViewDir(v.vertex));
	#endif
	#if defined(_REFLECTION) || defined(_RIM) || defined(_MATCAP)
		float3 normal_WS = UnityObjectToWorldNormal(v.normal);
	#endif
	

	#if defined(_RIM) || defined(_MATCAP)
		o.normal.xyz = normal_WS;
	#endif

	#if defined(_REFLECTION)		
		o.refl.xyz = normalize(reflect(-viewDir_WS, normal_WS));

		float fresnel = 1 - saturate(dot (v.normal, viewDir_OS) + _ReflectionFresnelBias);
		o.refl.w = fresnel * fresnel;
	#endif

	#ifdef _MATCAP
		#ifdef _NORMALMAP

			fixed3 tangent_WS = UnityObjectToWorldDir(v.tangent.xyz);
			fixed3 binormal_WS = cross(normal_WS, tangent_WS) * v.tangent.w;
			
			o.matcapTan = tangent_WS;
			o.matcapBiN = binormal_WS;

		#else
			float3 normal_OS = normalize(unity_WorldToObject[0].xyz * v.normal.x + unity_WorldToObject[1].xyz * v.normal.y + unity_WorldToObject[2].xyz * v.normal.z);
			o.matcap.xy = mul((float3x3)UNITY_MATRIX_V, normal_OS) * 0.5 + 0.5;
		#endif
	#endif
	
	#ifdef _RIM
		#ifdef _NORMALMAP
			TANGENT_SPACE_ROTATION;

			o.viewDir.xyz = mul (rotation, viewDir_OS);
		#else
			o.viewDir.xyz = WorldSpaceViewDir(v.vertex);
		#endif
	#endif		


	UNITY_TRANSFER_FOG(o,o.pos);

	return o;
}


//Fragment//////////////////////////////////////////////////////////////
float4 frag (vOutput i) : SV_Target
{
	float2 mainUV = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw + _MainTex_Scroll.xy * _Time.x;
	float4 mainTex = tex2D(_MainTex, mainUV);


	#if defined(_TEXTUREMIX_BY_MAIN_ALPHA) || defined(_TEXTUREMIX_BY_SECONDARY_ALPHA) || defined(_TEXTUREMIX_MULTIPLE) || defined(_TEXTUREMIX_ADDITIVE) || defined(_TEXTUREMIX_BY_VERTEX_ALPHA)
		float2 secondaryUV = i.texcoord.xy * _SecondaryTex_ST.xy + _SecondaryTex_ST.zw + _SecondaryTex_Scroll.xy * _Time.x;
	#endif

	#ifdef _TEXTUREMIX_BY_MAIN_ALPHA
		float4 decal = tex2D(_SecondaryTex, secondaryUV);
		float4 retColor = lerp(decal, mainTex, mainTex.a);
	#elif defined(_TEXTUREMIX_BY_SECONDARY_ALPHA)
		float4 decal = tex2D(_SecondaryTex, secondaryUV);
		float4 retColor = lerp(mainTex, decal, decal.a);
	#elif defined(_TEXTUREMIX_MULTIPLE)
		float4 retColor = mainTex;
		retColor *= tex2D(_SecondaryTex, secondaryUV);
	#elif defined(_TEXTUREMIX_ADDITIVE)
		float4 retColor = mainTex;
		retColor = saturate(retColor + tex2D(_SecondaryTex, secondaryUV));
	#elif defined(_TEXTUREMIX_BY_VERTEX_ALPHA)
		float vBlend = clamp(_SecondaryTex_Blend + i.color.a, 0, 1);
		float4 retColor = lerp(mainTex, tex2D(_SecondaryTex, secondaryUV), vBlend);
	#else
		float4 retColor = mainTex;
	#endif

	retColor *= _Color;

	//Vertex Color
	retColor.rgb *= lerp(1, i.color.rgb, _IncludeVertexColor);


	#if defined(_ALPHATEST_ON)
		clip(retColor.a - _Cutoff * 1.01);	
	#endif		
		

	#ifdef _NORMALMAP
		
		float2 mainNormalUV = i.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw + _NormalMap_Scroll.xy * _Time.x;
		float4 normalMap = tex2D(_NormalMap, mainNormalUV);		
		

		#if defined(_TEXTUREMIX_BY_MAIN_ALPHA) || defined(_TEXTUREMIX_BY_SECONDARY_ALPHA) || defined(_TEXTUREMIX_MULTIPLE) || defined(_TEXTUREMIX_ADDITIVE) || defined(_TEXTUREMIX_BY_VERTEX_ALPHA)
			float2 secondaryNormalUV = i.texcoord.xy * _SecondaryNormalMap_ST.xy + _SecondaryNormalMap_ST.zw + _SecondaryNormalMap_Scroll.xy * _Time.x;
		#endif

		#ifdef _TEXTUREMIX_BY_MAIN_ALPHA
			float4 secondN =  tex2D(_SecondaryNormalMap, secondaryNormalUV);
			normalMap = lerp(secondN, normalMap, mainTex.a);	
		#elif defined(_TEXTUREMIX_BY_SECONDARY_ALPHA)
			float4 secondN =  tex2D(_SecondaryNormalMap, secondaryNormalUV);
			normalMap = lerp(normalMap, secondN, decal.a);		
		#elif defined(_TEXTUREMIX_MULTIPLE)
			float4 secondN =  tex2D(_SecondaryNormalMap, secondaryNormalUV);
			normalMap = (normalMap + secondN) * 0.5;	
		#elif defined(_TEXTUREMIX_ADDITIVE)
			float4 secondN =  tex2D(_SecondaryNormalMap, secondaryNormalUV);
			normalMap = (normalMap + secondN) * 0.5;	
		#elif defined(_TEXTUREMIX_BY_VERTEX_ALPHA)
			float4 secondN =  tex2D(_SecondaryNormalMap, secondaryNormalUV);
			normalMap = lerp(normalMap, secondN, vBlend);		
		#endif

		fixed3 bumpNormal = UnpackNormal(normalMap);
		bumpNormal =  normalize(fixed3(bumpNormal.x * _NormalMapStrength, bumpNormal.y * _NormalMapStrength, bumpNormal.z));
	#endif

	#ifdef _MATCAP

		#ifdef _NORMALMAP
			float3 matcapN = float3(dot(float3(i.matcapTan.x, i.matcapBiN.x, i.normal.x), bumpNormal), 
									dot(float3(i.matcapTan.y, i.matcapBiN.y, i.normal.y), bumpNormal), 
									dot(float3(i.matcapTan.z, i.matcapBiN.z, i.normal.z), bumpNormal));
			matcapN = mul((float3x3)UNITY_MATRIX_V, matcapN);
			
			float4 matColor = tex2D(_MatcapMap, matcapN.xy * 0.5 + 0.5) * _MatcapIntensity;
		#else
			float4 matColor = tex2D(_MatcapMap, i.matcap) * _MatcapIntensity;
		#endif

		retColor.rgb = lerp(retColor.rgb * matColor.rgb, retColor.rgb + matColor.rgb, _MatcapBlendMode);	//0 - multiply, 1 - additive
	#endif


	#if defined(_REFLECTION)
		#ifdef _NORMALMAP
			float4 reflTex = texCUBE( _ReflectionCubeMap, i.refl.xyz + bumpNormal) * _ReflectionColor;
		#else
			float4 reflTex = texCUBE( _ReflectionCubeMap, i.refl.xyz ) * _ReflectionColor;
		#endif

		retColor.rgb += reflTex.rgb * i.refl.w * clamp(mainTex.a + _ReflectionMaskOffset, 0, 1);
	#endif

	#ifdef _EMISSION
		float2 emissionUV = i.texcoord.xy * _EmissionMap_ST.xy + _EmissionMap_ST.zw + _EmissionMap_Scroll.xy * _Time.x;
		
		retColor.rgb += tex2D(_EmissionMap, emissionUV).rgb * _EmissionColor.rgb;
	#endif

	#ifdef _RIM
		#ifdef _NORMALMAP
			float rimFresnel = 1 - saturate(dot (bumpNormal, normalize(i.viewDir.xyz)) + _RimBias);	
		#else
			float rimFresnel = 1 - saturate(dot (i.normal.xyz, normalize(i.viewDir.xyz)) + _RimBias);	
		#endif
		
		retColor.rgb += _RimColor.rgb * rimFresnel;
	#endif


	UNITY_APPLY_FOG(i.fogCoord, retColor); 	
	



	#if defined(_ALPHABLEND_ON) 
		retColor.a = retColor.a;
	#elif defined(_ALPHAPREMULTIPLY_ON)
		retColor.rgb *= retColor.a;
		retColor.a = retColor.a;
	#else
		UNITY_OPAQUE_ALPHA(retColor.a);
	#endif

	return retColor;
}


#endif