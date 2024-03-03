#ifndef CURVEDWORLD_SHADOW_CGINC
#define CURVEDWORLD_SHADOW_CGINC


#include "CurvedWorldTransform.cginc" 


//Variables/////////////////////////////////////////////////////////////
float4 _MainTex_ST;
sampler2D _MainTex;
float _Cutoff;
fixed4 _Color;

//Structs///////////////////////////////////////////////////////////////
struct v2f 
{
	float2 uv0 : TEXCOORD3;
	V2F_SHADOW_CASTER;
	UNITY_VERTEX_OUTPUT_STEREO
};

//Vertex////////////////////////////////////////////////////////////////
v2f vert( appdata_base v )
{
	v2f o;
	UNITY_SETUP_INSTANCE_ID(v);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

	#if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
		CURVEDWORLD_TRANSFORM_VERTEX(v.vertex)
	#endif


	o.uv0 = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
	return o;
}

//Fragment//////////////////////////////////////////////////////////////
float4 frag( v2f i ) : SV_Target
{
	#if defined(_ALPHABLEND_ON) || defined(_ALPHAPREMULTIPLY_ON)
		clip(-1);
	#elif defined(_ALPHATEST_ON)
		clip (tex2D (_MainTex, i.uv0.xy).a * _Color.a - _Cutoff);            
	#endif

	SHADOW_CASTER_FRAGMENT(i)
}


#endif