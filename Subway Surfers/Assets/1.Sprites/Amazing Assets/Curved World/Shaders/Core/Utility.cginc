#ifndef CURVEDWORLD_UTILITY_CGINC
#define CURVEDWORLD_UTILITY_CGINC


#ifndef SCRIPTABLE_RENDER_PIPELINE
	#ifndef UNITY_CG_INCLUDED
		#include "UnityCG.cginc"	//'UnityCG.cginc' file contains Unity default methods and definitions required by this cginc file.
	#endif
#endif



float3 CurvedWorld_ObjectToWorld(float4 vertexOS)
{
	#ifdef SCRIPTABLE_RENDER_PIPELINE 
		return GetAbsolutePositionWS(TransformObjectToWorld(vertexOS.xyz));
	#else
		return mul(unity_ObjectToWorld, vertexOS).xyz;
	#endif
}

float3 CurvedWorld_WorldToObject(float4 vertexWS, float HDRPCoef)
{
	#ifdef SCRIPTABLE_RENDER_PIPELINE

		#if (SHADEROPTIONS_CAMERA_RELATIVE_RENDERING != 0)
			vertexWS.xyz -= _WorldSpaceCameraPos * HDRPCoef;	//HDRPCoef is always 1 for URP. In HDRP for Spiral bend types = 1, for Cylindricals = 0. 
		#endif

		return mul(GetWorldToObjectMatrix(), vertexWS).xyz;
	#else
		return mul(unity_WorldToObject, vertexWS).xyz;
	#endif
}

float3 CurvedWorld_ObjectToWorldNormal(float3 normalOS)
{
	#ifdef SCRIPTABLE_RENDER_PIPELINE
		return TransformObjectToWorldNormal(normalOS);
	#else
		return UnityObjectToWorldNormal(normalOS);
	#endif
}

float3 CurvedWorld_WorldToObjectNormal(float3 normalWS)
{
	#ifdef SCRIPTABLE_RENDER_PIPELINE
		return TransformWorldToObjectNormal(normalWS);
	#else
		return mul((float3x3)unity_WorldToObject, normalWS);
	#endif
}
 
float3 CurvedWorld_ObjectToWorldTangent(float3 tangentOS)
{
	#ifdef SCRIPTABLE_RENDER_PIPELINE
		return TransformObjectToWorldDir(tangentOS);
	#else
		return UnityObjectToWorldDir(tangentOS);
	#endif
}  

inline float CurvedWorld_Smooth(float x)
{
	float t = cos(x * 1.57079632679);

	return 1 - t * t;
}

inline float2 CurvedWorld_Smooth(float2 x)
{
	float2 t = cos(x * 1.57079632679);

	return float2(1, 1) - t * t;
}

inline float3 CurvedWorld_Smooth(float3 x)
{
	float3 t = cos(x * 1.57079632679);

	return float3(1, 1, 1) - t * t;
}

inline float CurvedWorld_SmoothTwistedPositive(float x, float scale)
{
	float d = x / scale;
	float s = d * d;
	float smooth = lerp(s, d, s) * scale;

	return x < scale ? smooth : x;
}

inline float3 CurvedWorld_SmoothTwistedPositive(float3 x, float scale)
{
	float3 d = x / scale;
	float3 s = d * d;
	float3 smooth = lerp(s, d, s) * scale;

	return float3(x.x < scale ? smooth.x : x.x, x.y < scale ? smooth.y : x.y, x.z < scale ? smooth.z : x.z);
}

inline float CurvedWorld_SmoothTwistedNegative(float x, float scale)
{
	float d = x / scale;
	float s = d * d;
	float smooth = lerp(s, d, s) * scale;

	return x < scale ? x : smooth;
}

inline float3 CurvedWorld_SmoothTwistedNegative(float3 x, float scale)
{
	float3 d = x / scale;
	float3 s = d * d;
	float3 smooth = lerp(s, d, s) * scale;

	return float3(x.x < scale ? x.x : smooth.x, x.y < scale ? x.y : smooth.y, x.z < scale ? x.z : smooth.z);
}

inline float CurvedWorld_Sign(float a)
{
    return a < 0 ? -1.0f : 1.0f;
}

inline float2 CurvedWorld_Sign(float2 a)
{
    return float2(a.x < 0 ? -1.0f : 1.0f, a.y < 0 ? -1.0f : 1.0f);
}

inline void CurvedWorld_RotateVertex(inout float3 vertex, float3 pivot, float3 axis, float angle)
{
	//degree to rad / 2
	angle *= 0.00872664625;


	float sinA, cosA;
	sincos(angle, sinA, cosA);

	float3 q = axis * sinA;

	//vertex
	vertex -= pivot;
	vertex += cross(q, cross(q, vertex) + vertex * cosA) * 2;
	vertex += pivot;		
}

inline void CurvedWorld_RotateVertexAndNormal(inout float3 vertex, inout float3 normal, float3 pivot, float3 axis, float angle)
{
	//degree to rad / 2
	angle *= 0.00872664625;


	float sinA, cosA;
	sincos(angle, sinA, cosA);

	float4 q = float4(axis * sinA, cosA);


	//normal
	float3 normalPosition = vertex + normal;
	normalPosition -= pivot;
	normalPosition += 2.0 * cross(q.xyz, cross(q.xyz, normalPosition) + q.w * normalPosition);
	normalPosition += pivot;


	//vertex
	vertex -= pivot;
	vertex += cross(q.xyz, cross(q.xyz, vertex) + q.w * vertex) * 2;
	vertex += pivot;		


	//normal
	normal = normalize(normalPosition - vertex);
}

inline void Spiral_H_Rotate_X_Positive(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		vertex.x = pivot.x;
		vertex.y += pivot.y * smoothValue;
	}
	else
	{
		vertex.xy += float2(l, pivot.y);
	}		

	CurvedWorld_RotateVertex(vertex, pivot, float3(0, 1, 0), angle * saturate(absoluteValue));
}

inline void Spiral_H_Rotate_X_Negative(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		vertex.x = pivot.x;
		vertex.y += pivot.y * smoothValue;
	}
	else
	{
		vertex.xy += float2(-l, pivot.y);
	}			

	CurvedWorld_RotateVertex(vertex, pivot, float3(0, -1, 0), angle * saturate(absoluteValue));
}

inline void Spiral_H_Rotate_Z_Positive(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		vertex.z = pivot.z;
		vertex.y += pivot.y * smoothValue;
	}
	else
	{
		vertex.zy += float2(-l, pivot.y);
	}				

	CurvedWorld_RotateVertex(vertex, pivot, float3(0, 1, 0), angle * saturate(absoluteValue));
}

inline void Spiral_H_Rotate_Z_Negative(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		vertex.z = pivot.z;
		vertex.y += pivot.y * smoothValue;
	}
	else
	{
		vertex.zy += float2(l, pivot.y);
	}				

	CurvedWorld_RotateVertex(vertex, pivot, float3(0, -1, 0), angle * saturate(absoluteValue));
}

inline void Spiral_V_Rotate_X_Positive(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		vertex.x = pivot.x;
		vertex.z += pivot.z * smoothValue;
	}
	else
	{
		vertex.xz += float2(l, pivot.z);
	}			

	CurvedWorld_RotateVertex(vertex, pivot, -float3(0, 0, 1), angle * saturate(absoluteValue));
}

inline void Spiral_V_Rotate_X_Negative(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		vertex.x = pivot.x;
		vertex.z += pivot.z * smoothValue;
	}
	else
	{
		vertex.xz += float2(-l, pivot.z);
	}			

	CurvedWorld_RotateVertex(vertex, pivot, float3(0, 0, 1), angle * saturate(absoluteValue));
}

inline void Spiral_V_Rotate_Z_Positive(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		vertex.z = pivot.z;
		vertex.x += pivot.x * smoothValue;
	}
	else
	{
		vertex.zx += float2(-l, pivot.x);
	}			

	CurvedWorld_RotateVertex(vertex, pivot, -float3(1, 0, 0), angle * saturate(absoluteValue));
}

inline void Spiral_V_Rotate_Z_Negative(inout float3 vertex, float3 pivot, float absoluteValue, float smoothValue, float l, float angle)
{
	if (absoluteValue < 1)
	{
		 vertex.z = pivot.z;
		 vertex.x += pivot.x * smoothValue;
	}
	else
	{
		vertex.zx += float2(l, pivot.x);
	}			

	CurvedWorld_RotateVertex(vertex, pivot, float3(1, 0, 0), angle * saturate(absoluteValue));
}


#endif
