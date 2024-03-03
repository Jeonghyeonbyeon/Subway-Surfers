#ifndef CURVEDWORLD_FORWARDBASE_CGINC
#define CURVEDWORLD_FORWARDBASE_CGINC


#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
 
#include "../../Core/CurvedWorldTransform.cginc" 


//Defines/////////////////////////////////////////////////////////////
#ifdef _NORMALMAP
	#define FORWARD_LIGHTDIR i.lightDir
#else
	#define FORWARD_LIGHTDIR _WorldSpaceLightPos0.xyz
#endif

#if defined(_REFLECTION) || (defined(_SPECULAR) && !defined(_NORMALMAP))
	#define NEED_VIEWDIR_WS
#endif
#if defined(_REFLECTION) || defined(_RIM) || (defined(_SPECULAR) && defined(_NORMALMAP))
	#define NEED_VIEWDIR_OS
#endif



//Variables/////////////////////////////////////////////////////////////
float4 _Color;
sampler2D _MainTex;
float4 _MainTex_ST;
float2 _MainTex_Scroll;



float _IncludeVertexColor;

#ifdef _LIGHTLOOKUP
	sampler2D _LightLookupTex;
	float _LightLookupOffset;
#endif

#ifdef _NORMALMAP
	sampler2D _NormalMap;
	float4 _NormalMap_ST;
	float2 _NormalMap_Scroll;
	float _NormalMapStrength;
#endif

#ifdef _SPECULAR
	float4 _SpecularColor;
	float _Shininess;
	float _SpecularMaskOffset;
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



//Structs///////////////////////////////////////////////////////////////
struct vInput
{
	float4 vertex : POSITION;   

	float4 texcoord : TEXCOORD0;

	#ifndef LIGHTMAP_OFF
		float4 texcoord1 : TEXCOORD1;
	#endif

	float3 normal : NORMAL;

	float4 tangent : TANGENT;

	float4 color : COLOR0;

	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct vOutput
{
	float4 pos : SV_POSITION;
	float2 texcoord : TEXCOORD0;

	float4 normal : TEXCOORD1; //xyz - normal, w - rim

	#if defined(_REFLECTION)
		float4 refl : TEXCOORD2;	//xyz - refl, w - fresnel
	#endif


	float4 color : COLOR0;

	
	
	UNITY_FOG_COORDS(3)
	


	#ifndef LIGHTMAP_OFF
		float2 lm : TEXCOORD4;

		#if defined(_RIM)
			float4 viewDir : TEXCOORD5;
		#endif
	#else
		float4 vLight : TEXCOORD4;

		#if defined(_SPECULAR) || defined(_RIM)
			float4 viewDir : TEXCOORD5;	//xyz - viewdir, w - specular(nh)
		#endif

		#ifdef _NORMALMAP
			float3 lightDir : TEXCOORD6;
		#endif	

		SHADOW_COORDS(7)
	#endif

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
	

	float3 normal_WS = UnityObjectToWorldNormal(v.normal);
	
	#ifdef NEED_VIEWDIR_WS
		float3 viewDir_WS = WorldSpaceViewDir(v.vertex);
	#endif
	#ifdef NEED_VIEWDIR_OS
		float3 viewDir_OS = normalize(ObjSpaceViewDir(v.vertex));
	#endif

	
	#ifndef LIGHTMAP_OFF
		o.lm = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;

		#if defined(_RIM)
			o.viewDir.xyz = WorldSpaceViewDir(v.vertex);
		#endif
	#else
		
		#ifdef UNITY_SHOULD_SAMPLE_SH

			#ifdef _AMBIENTLIGHTS_ON
				o.vLight.rgb = ShadeSH9 (float4(normal_WS, 1.0));
			#endif

		
			#if defined(VERTEXLIGHT_ON) && defined(_PERVERTEXLIGHTS_ON)
				float3 pos_WS = mul(unity_ObjectToWorld, v.vertex).xyz;
			
				o.vLight.rgb += Shade4PointLights ( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					 							   unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
												   unity_4LightAtten0, pos_WS, normal_WS );
			#endif
		#endif


		#ifdef _NORMALMAP
			TANGENT_SPACE_ROTATION;

			o.lightDir = normalize(mul (rotation, ObjSpaceLightDir(v.vertex)));

			#if defined(_SPECULAR) || defined(_RIM)
				o.viewDir.xyz = mul (rotation, viewDir_OS);
			#endif
		#else
			#if defined(_SPECULAR) || defined(_RIM)
				o.viewDir.xyz = WorldSpaceViewDir(v.vertex);
			#endif
		#endif
	#endif
		

	o.normal.xyz = normal_WS;


	#if defined(_REFLECTION)		
		o.refl.xyz = normalize(reflect(-viewDir_WS, normal_WS));

		float fresnel = 1 - saturate(dot (v.normal, viewDir_OS) + _ReflectionFresnelBias);
		o.refl.w = fresnel * fresnel;
	#endif

		
	#ifdef LIGHTMAP_OFF
		TRANSFER_SHADOW(o);
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
	

	
	#ifndef LIGHTMAP_OFF
		fixed3 diff = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lm));
	#else
		float atten = LIGHT_ATTENUATION(i);

		#ifdef _NORMALMAP
			float3 normal = bumpNormal;				
		#else
			float3 normal = normalize(i.normal.xyz);
		#endif
		
		fixed3 diff = _LightColor0.rgb * atten;

		#ifdef _LIGHTLOOKUP
			float2 rampUV = float2(max(0, saturate(dot(normal, FORWARD_LIGHTDIR) + _LightLookupOffset)), 0.5);
			diff *= tex2D(_LightLookupTex, rampUV);
		#else
			diff *= max(0, dot(normal, FORWARD_LIGHTDIR));
		#endif
										
		#ifdef _SPECULAR 
			#ifdef _LIGHTLOOKUP 
				float nh = max (0, dot (normal, normalize (FORWARD_LIGHTDIR + normalize(i.viewDir.xyz))));
				nh = nh > _Shininess ? 1 : 0;
			#else
				float nh = max (0, dot (normal, normalize (FORWARD_LIGHTDIR + normalize(i.viewDir.xyz))));
				nh = pow(nh, 128 * _Shininess);				
			#endif

			fixed3 specular = _SpecularColor.rgb * _LightColor0.rgb * atten * saturate(retColor.a + _SpecularMaskOffset) * nh;
		#endif	
		
		//Ambient and per-vertex lights
		diff += i.vLight.rgb;
	#endif
		
				
	retColor.rgb = diff * retColor.rgb;		


	#ifndef LIGHTMAP_OFF
	#else
		#if defined(_SPECULAR)
			retColor.rgb = saturate(retColor.rgb + specular);
		#endif
	#endif

	
	#if defined(_REFLECTION)
		#ifdef _NORMALMAP
			float4 reflTex = texCUBE( _ReflectionCubeMap, i.refl.xyz + bumpNormal) * _ReflectionColor;
		#else
			float4 reflTex = texCUBE( _ReflectionCubeMap, i.refl.xyz ) * _ReflectionColor;
		#endif

		
		retColor.rgb += reflTex.rgb * i.refl.w * clamp(retColor.a + _ReflectionMaskOffset, 0, 1);
	#endif

	#ifdef _EMISSION
		float2 emissionUV = i.texcoord.xy * _EmissionMap_ST.xy + _EmissionMap_ST.zw + _EmissionMap_Scroll.xy * _Time.x;
		
		retColor.rgb += tex2D(_EmissionMap, emissionUV).rgb * _EmissionColor.rgb;
	#endif
	
	#ifdef _RIM
		#ifndef LIGHTMAP_OFF
			float rimFresnel = 1 - saturate(dot (normalize(i.normal.xyz), normalize(i.viewDir.xyz)) + _RimBias);			
		#else
			float rimFresnel = 1 - saturate(dot (normal, normalize(i.viewDir.xyz)) + _RimBias);			
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