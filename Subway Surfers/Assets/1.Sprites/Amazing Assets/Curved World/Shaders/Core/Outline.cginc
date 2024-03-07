#ifndef CURVEDWORLD_OUTLINE_CGINC
#define CURVEDWORLD_OUTLINE_CGINC


#include "UnityCG.cginc"
#include "CurvedWorldTransform.cginc" 


//Variables/////////////////////////////////////////////////////////////
float _OutlineWidth;
float4 _OutlineColor;
float _OutlineSizeIsFixed;

//Structs///////////////////////////////////////////////////////////////
struct vInput
{
	float4 vertex : POSITION;    
	float3 normal : NORMAL;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct vOutput
{
	float4 pos : SV_POSITION;

	UNITY_FOG_COORDS(0)

	fixed4 color : COLOR;

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
			

	#if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
		CURVEDWORLD_TRANSFORM_VERTEX(v.vertex)
	#endif
	

	float3 norm = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));
	float2 offset = TransformViewToProjection(norm.xy);


	offset /= lerp(distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex)), 1, _OutlineSizeIsFixed);


	float width = max(0, _OutlineWidth * 0.01);

	o.pos = UnityObjectToClipPos(v.vertex);
	#ifdef UNITY_Z_0_FAR_FROM_CLIPSPACE //to handle recent standard asset package on older version of unity (before 5.5)
		o.pos.xy += offset * UNITY_Z_0_FAR_FROM_CLIPSPACE(o.pos.z) * width;
	#else
		o.pos.xy += offset * o.pos.z * width;
	#endif

	o.color = _OutlineColor;
	
	
	UNITY_TRANSFER_FOG(o,o.pos);

	return o;
}


//Fragment//////////////////////////////////////////////////////////////
fixed4 frag (vOutput i) : SV_Target
{
	UNITY_APPLY_FOG(i.fogCoord, i.color);

	return i.color;
}


#endif